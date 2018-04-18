require 'zmanim/limudim/limud_calculator'

module Zmanim::Limudim::Calculators
  class DafYomiYerushalmi
    include Zmanim::Limudim::LimudCalculator

    def initial_cycle_date
      jewish_date(Date.parse('1980-02-02'))
    end

    def default_units
      { berachos: 68, peah: 37, demai: 34, kilayim: 44, shviis: 31, terumos: 59, maasros: 26, maaser_sheni: 33,
        chalah: 28, orlah: 20, bikurim: 13, shabbos: 92, eruvin: 65, pesachim: 71, beitzah: 22, rosh_hashanah: 22,
        yoma: 42, sukkah: 26, taanis: 26, shekalim: 33, megilah: 34, chagigah: 22, moed_katan: 19, yevamos: 85,
        kesubos: 72, sotah: 47, nedarim: 40, nazir: 47, gitin: 54, kiddushin: 48, bava_kama: 44, bava_metzia: 37,
        bava_basra: 34, sanhedrin: 44, makos: 9, shevuos: 57, avodah_zarah: 37, horayos: 19, niddah: 13 }
    end

    def cycle_end_calculation
      ->(start_date, iteration) do
        end_date = start_date + (1554 - 1)
        found_skips_between = ->(a, b) do
          (a.jewish_year..b.jewish_year).sum do |year|
            skip_days.count do |m, d|
              Zmanim::HebrewCalendar::JewishDate.new(year, m, d).between?(a,b)
            end
          end
        end
        while (found_days = found_skips_between.(start_date, end_date)) > 0 do
          start_date, end_date = end_date + 1, end_date + found_days
        end
        end_date
      end
    end

    def skip_unit
      Zmanim::Limudim::Unit.new('no_daf_today')
    end

    def skip_interval?(interval)
      matches_skip_day?(interval.start_date)
    end

    private

    def matches_skip_day?(date)
      skip_days.any?{|m, d| date.jewish_month == m && date.jewish_day == d}
    end

    def skip_days
      [[5, 9], [7, 10]]
    end
  end
end
