require 'zmanim/limudim/limud_calculator'

module Zmanim::Limudim::Calculators
  class Parsha
    include Zmanim::Limudim::LimudCalculator

    attr_reader :in_israel

    def initialize(in_israel:false)
      @in_israel = in_israel
    end

    def tiered_units?
      false
    end

    def perpetual_cycle_anchor
      Zmanim::Limudim::Anchor::DayOfYearAnchor.new(7, in_israel ? 23 : 24)
    end

    def default_units
      %i(bereishis noach lech_lecha vayeira chayei_sarah toldos vayeitzei vayishlach vayeishev mikeitz vayigash vayechi
         shemos vaeirah bo beshalach yisro mishpatim terumah tetzaveh ki_sisa vayakheil pekudei
         vayikra tzav shemini tazria metzora acharei kedoshim emor behar bechukosai
         bamidbar naso behaalosecha shelach korach chukas balak pinchas matos masei
         devarim vaeschanan eikev reei shoftim ki_seitzei ki_savo nitzavim vayeilech haazinu vezos_haberacha)
    end

    def cycle_end_calculation
      ->(start_date, iteration) do
        perpetual_cycle_anchor.next_occurrence(start_date) - 1
      end
    end

    def interval_end_calculation
      ->(cycle, start_date) do
        skips = in_israel ?
                        [[1, (15..21)], [3, [6]], [7, [1,2,10] + (15..21).to_a]] :
                        [[1, (15..22)], [3, [6,7]], [7, [1,2,10] + (15..22).to_a]]
        end_date = start_date + (7 - start_date.day_of_week)
        while skips.detect{|month, days| month == end_date.jewish_month && days.include?(end_date.jewish_day) } do
          end_date += 7
        end
        end_date > cycle.end_date ? cycle.end_date : end_date
      end
    end

    def cycle_units_calculation
      ->(cycle) do
        kviah = Zmanim::HebrewCalendar::HebrewDateFormatter.new.format_kviah(cycle.start_date.jewish_year)
        modifications = in_israel ?
                         {
                             'בחה' => [%i(matos masei), %i(nitzavim vayeilech)],
                             'בשז' => [],
                             'גכז' => [],
                             'החא' => [],
                             'השג' => [%i(nitzavim vayeilech)],
                             'זחג' => [%i(matos masei), %i(nitzavim vayeilech)],
                             'זשה' => [%i(matos masei), %i(nitzavim vayeilech)],
                             'בחג' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei), %i(nitzavim vayeilech)],
                             'בשה' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei), %i(nitzavim vayeilech)],
                             'גכה' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei), %i(nitzavim vayeilech)],
                             'הכז' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(matos masei)],
                             'השא' => [%i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei)],
                             'זחא' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei)],
                             'זשג' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei)],
                         }[kviah] :
                         {
                             'בחה' => [%i(chukas balak), %i(matos masei), %i(nitzavim vayeilech)],
                             'בשז' => [%i(matos masei)],
                             'גכז' => [%i(matos masei)],
                             'החא' => [],
                             'השג' => [%i(nitzavim vayeilech)],
                             'זחג' => [%i(matos masei), %i(nitzavim vayeilech)],
                             'זשה' => [%i(chukas balak), %i(matos masei), %i(nitzavim vayeilech)],
                             'בחג' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei), %i(nitzavim vayeilech)],
                             'בשה' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(chukas balak), %i(matos masei), %i(nitzavim vayeilech)],
                             'גכה' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(chukas balak), %i(matos masei), %i(nitzavim vayeilech)],
                             'הכז' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei)],
                             'השא' => [%i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei)],
                             'זחא' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei)],
                             'זשג' => [%i(vayakheil pikudei), %i(tazria metzora), %i(acharei kedoshim), %i(behar bechukosai), %i(matos masei), %i(nitzavim vayeilech)],
                         }[kviah]
        modifications.inject(default_units) do |transitioned_units, parsha_pair|
          index = transitioned_units.index(parsha_pair.first)
          transitioned_units[0...index] + [parsha_pair] + transitioned_units[(index + 2)..-1]
        end
      end
    end
  end
end
