require 'zmanim/limudim/limud_calculator'

module Zmanim::Limudim::Calculators
  class TehillimMonthly
    include Zmanim::Limudim::LimudCalculator

    def tiered_units?
      false
    end

    def perpetual_cycle_anchor
      Zmanim::Limudim::Anchor::DayOfMonthAnchor.new(1)
    end

    def default_units
      [9,17,22,28,34,38,43,48,54,59,65,68,71,76,78,82,87,89,96,103,105,
       107,112,118,119,119,134,139,144,150]
    end

    def cycle_end_calculation
      ->(start_date, iteration) do
        perpetual_cycle_anchor.next_occurrence(start_date) - 1
      end
    end

    def unit_for_interval(units, interval)
      start, stop = case interval.iteration
        when 1
          [1, units[interval.iteration - 1]]
        when 25
          [[119, 1], [119, 30]]
        when 26
          [[119, 40], [119, 400]]
        else
          [units[interval.iteration - 2] + 1, units[interval.iteration - 1]]
      end
      if interval.end_date.jewish_day == 29 && interval.end_date.days_in_jewish_month == 29
        stop = units[interval.iteration]
      end
      Zmanim::Limudim::Unit.new(start, stop)
    end
  end
end
