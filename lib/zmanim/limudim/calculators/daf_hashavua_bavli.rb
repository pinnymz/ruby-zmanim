require 'zmanim/limudim/calculators/daf_yomi_bavli'

module Zmanim::Limudim::Calculators
  class DafHashavuaBavli < DafYomiBavli
    def initial_cycle_date
      jewish_date(Date.parse('2005-03-02'))
    end

    def cycle_end_calculation
      ->(start_date, iteration){ start_date + ((2711*7) - start_date.day_of_week) }  # 2711 pages except first week * 7 days
    end

    def interval_end_calculation
      ->(cycle, start_date){ start_date + (7 - start_date.day_of_week) }
    end

    def cycle_units_calculation
      ->(cycle){ default_units }
    end
  end
end


