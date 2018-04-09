require 'zmanim/limudim/limud_calculator'

module Zmanim::Limudim::Calculators
  class PirkeiAvos
    include Zmanim::Limudim::LimudCalculator

    attr_reader :in_israel

    def initialize(in_israel:false)
      @in_israel = in_israel
    end

    def tiered_units?
      false
    end

    def perpetual_cycle_anchor
      Zmanim::Limudim::Anchor::DayOfYearAnchor.new(1, in_israel ? 22 : 23)  # Day after Pesach
    end

    def default_units
      @default_units ||= (1..6).to_a * 4    # 4 sub-cycles of 6 perakim, with the last sub-cycle being compressed as needed
    end

    def cycle_end_calculation
      ->(start_date, iteration) do
        rosh_hashana = Zmanim::HebrewCalendar::JewishDate.new(start_date.jewish_year + 1, 7, 1)
        rosh_hashana - rosh_hashana.day_of_week  # last Shabbos before Rosh Hashanah
      end
    end

    def interval_end_calculation
      ->(cycle, start_date) do
        start_date + (7 - start_date.day_of_week)
      end
    end

    def cycle_units_calculation
      ->(cycle) do
        cycle_weeks = ((cycle.end_date - cycle.start_date) / 7.0).ceil
        unit_count = default_units.length
        compress_weeks = (unit_count - cycle_weeks) * 2
        default_units.first(unit_count - compress_weeks) + default_units.last(compress_weeks).each_slice(2).to_a
      end
    end
  end
end
