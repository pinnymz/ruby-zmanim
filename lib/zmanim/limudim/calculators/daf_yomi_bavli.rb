require 'zmanim/limudim/limud_calculator'

module Zmanim::Limudim::Calculators
  class DafYomiBavli
    include Zmanim::Limudim::LimudCalculator

    def initial_cycle_date
      jewish_date(Date.parse('1923-09-11'))
    end

    def default_starting_page
      2
    end

    def starting_page(units, unit_name)
      case units.keys.index(unit_name.to_sym)
        when 36
          23
        when 37
          26
        when 38
          34
        else
          default_starting_page
      end
    end

    def default_units
      { berachos: 64, shabbos: 157, eruvin: 105, pesachim: 121, shekalim: 22, yoma: 88, sukkah: 56, beitzah: 40, rosh_hashanah: 35,
        taanis: 31, megillah: 32, moed_katan: 29, chagigah: 27, yevamos: 122, kesubos: 112, nedarim: 91, nazir: 66, sotah: 49,
        gitin: 90, kiddushin: 82, bava_kamma: 119, bava_metzia: 119, bava_basra: 176, sanhedrin: 113, makkos: 24, shevuos: 49,
        avodah_zarah: 76, horiyos: 14, zevachim: 120, menachos: 110, chullin: 142, bechoros: 61, arachin: 34, temurah: 34,
        kerisos: 28, meilah: 22, kinnim: 25, tamid: 33, midos: 37, niddah: 73 }
    end

    def cycle_end_calculation
      ->(start_date, iteration) do
        duration = iteration < 8 ? 2702 : 2711
        start_date + (duration - 1)
      end
    end

    def cycle_units_calculation
      ->(cycle) do
        if cycle.iteration < 8
          default_units.merge(shekalim: 13)
        else
          default_units
        end
      end
    end
  end
end
