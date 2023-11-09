require 'zmanim/limudim/calculators/daf_yomi_bavli'

module Zmanim::Limudim::Calculators
  class AmudYomiBavliDirshu < DafYomiBavli
    def initial_cycle_date
      jewish_date(Date.parse('2023-10-16'))
    end

    def default_units
      @default_units ||= super.map.with_index do |(unit_name, last_page), index|
        last_amud = case index
        when 0,2,5,8,9,10,11,12,21,27,29,30,31,32,33,35,36,39  # these end on amud 'a'
          last_page
        else
          last_page + 0.5
        end
        [unit_name, last_amud]
      end.to_h
    end

    def unit_step
      0.5r  # rational numbers recommended over float
    end

    def fractional_units
      @fractional_units ||= %w(a b)
    end

    def starting_page(units, unit_name)
      case units.keys.index(unit_name.to_sym)
      when 36
        22.5
      when 37
        25.5
      when 38
        34
      else
        default_starting_page
      end
    end

    def cycle_end_calculation
      ->(start_date, iteration) do
        start_date + (5406 - 1)
      end
    end

    def cycle_units_calculation
      ->(cycle){ default_units }
    end
  end
end
