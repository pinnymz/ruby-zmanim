require 'zmanim/hebrew_calendar/jewish_date'

module Zmanim::Limudim
  module LimudCalculator
    def limud(date)
      jewish_date = jewish_date(date)
      cycle = find_cycle(jewish_date)
      return nil unless cycle && cycle.end_date >= date
      units = cycle_units_calculation.(cycle)
      interval = cycle.first_interval(interval_end_calculation)
      while !jewish_date.between?(interval.start_date, interval.end_date) do
        interval = interval.next(interval_end_calculation)
        while !jewish_date.between?(interval.start_date, interval.end_date) && skip_interval?(interval)
          interval = interval.skip(interval_end_calculation)
        end
      end
      unit = unit_for_interval(units, interval)
      Zmanim::Limudim::Limud.new(interval, unit)
    end

    # Jewish Date on which the first cycle starts (if not perpetual)
    def initial_cycle_date
      nil
    end

    # Anchor on which a cycle resets (where relevant)
    # e.g. for Parsha this would be a Day-of-Year anchor
    def perpetual_cycle_anchor
      nil
    end

    # Number of units to apply over an iteration
    def unit_step
      1
    end

    # Are units components of some larger grouping? (e.g. pages or mishnayos)
    def tiered_units?
      true
    end

    # For tiered units, this would be a Hash in the format:
    #   `{some_name: last_page, ...}`
    # or:
    #   `{maseches: {perek_number => mishnayos, ...}, ...}`.
    #
    # For simple units, use an Array in the format:
    #   `[:some_name, ...]`
    def default_units
      {}
    end

    # Set if units are applied fractionally (indicated by a fractional unit_step).
    # For example, an amud yomi calculator would set `%w(a b)`
    def fractional_units
      nil
    end

    # Change this when using page numbers that do not generally start from one.
    # (e.g. Talmud Bavli pages start from 2)
    def default_starting_page
      1
    end

    def starting_page(units, unit_name)
      default_starting_page
    end

    def cycle_end_calculation
      ->(start_date, iteration){ start_date }
    end

    def interval_end_calculation
      ->(cycle, start_date){ start_date }
    end

    def cycle_units_calculation
      ->(cycle){ default_units }
    end

    def unit_for_interval(units, interval)
      return tiered_units_for_interval(units, interval) if tiered_units?
      Unit.new(*units[interval.iteration-1])
    end

    def skip_interval?(interval)
      false
    end

    def tiered_units_for_interval(units, interval)
      iteration = interval.iteration
      offset = ((iteration - 1) * unit_step) + 1
      offset2 = (offset - 1) + unit_step if unit_step > 1
      offsets = [offset, offset2].compact
      targets = offsets.map{|o| [o, []]}
      results = find_offset_units(units, targets)
      return nil unless results.map(&:first).uniq == [0]
      paths = results.map(&:last)
      Unit.new(*paths)
    end

    def find_offset_units(units, targets)
      units.reduce(targets) do |t, (name, attributes)|
        if attributes.is_a?(Numeric)
          start = starting_page(units, name)
          length = (attributes - start) + 1
          t.select{|o, p| o == 0} + t.reject{|o,p| o == 0}.map do |o, p|
            o <= length ?
                 [0, p + [name, (start + o) - 1]] :
                 [o - length, p]
          end
        else
          t.select{|o, p| o == 0} +
          find_offset_units(attributes, t.reject{|o,p| o == 0}.map{|o, p| [o, p + [name]]}).map do |o, p|
            o == 0 ? [o, p] : [o, p[0..-2]]
          end
        end
      end
    end

    def find_cycle(date)
      if initial_cycle_date
        Cycle.from_cycle_initiation(initial_cycle_date, cycle_end_calculation, date)
      elsif perpetual_cycle_anchor
        Cycle.from_perpetual_anchor(perpetual_cycle_anchor, cycle_end_calculation, date)
      else
        raise 'Cycle cannot be determined without an initial date or an anchor'
      end
    end

    protected

    def jewish_date(date)
      date.respond_to?(:jewish_year) ? date : Zmanim::HebrewCalendar::JewishDate.new(date)
    end
  end
end
