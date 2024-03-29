require_relative 'jewish_date'

module Zmanim::HebrewCalendar
  class JewishCalendar < JewishDate
    attr_accessor :in_israel, :use_modern_holidays

    SIGNIFICANT_DAYS = %i(erev_rosh_hashana rosh_hashana tzom_gedalyah erev_yom_kippur yom_kippur
                          erev_succos succos chol_hamoed_succos hoshana_rabbah shemini_atzeres simchas_torah
                          chanukah tenth_of_teves tu_beshvat
                          taanis_esther purim shushan_purim purim_katan shushan_purim_katan
                          erev_pesach pesach chol_hamoed_pesach pesach_sheni lag_baomer erev_shavuos shavuos
                          seventeen_of_tammuz tisha_beav tu_beav
                          yom_hashoah yom_hazikaron yom_haatzmaut yom_yerushalayim)

    SIGNIFICANT_TEFILOS = %i(yaaleh_veyavo al_hanissim begin_mashiv_haruach end_mashiv_haruach mashiv_haruach begin_morid_hatal morid_hatal vesein_tal_umatar vesein_beracha atah_yatzarta borchi_nafshi)

    SIGNIFICANT_SHABBOS = %i(parshas_shekalim parshas_zachor parshas_parah parshas_hachodesh shabbos_hagadol shabbos_shuva)

    def initialize(*args)
      if args.count == 4
        super(*args[0..2])
      else
        super
      end
      @in_israel = !!args[3]
      @use_modern_holidays = false
    end

    def significant_day
      send("#{jewish_month_name}_significant_day")
    end

    def assur_bemelacha?
      day_of_week == 7 || yom_tov_assur_bemelacha?
    end

    def tomorrow_assur_bemelacha?
      day_of_week == 6 || erev_yom_tov? || erev_yom_tov_sheni?
    end

    def candle_lighting?
      tomorrow_assur_bemelacha?
    end

    def delayed_candle_lighting?
      day_of_week != 6 && candle_lighting? && assur_bemelacha?
    end

    def yom_tov?
      sd = significant_day
      sd && !sd.to_s.start_with?('erev_') && (!taanis? || sd == :yom_kippur)
    end

    def yom_tov_assur_bemelacha?
      %i(pesach shavuos rosh_hashana yom_kippur succos shemini_atzeres simchas_torah).include?(significant_day)
    end

    def erev_yom_tov?
      return false unless sd = significant_day
      sd.to_s.start_with?('erev_') || sd == :hoshana_rabbah ||
          (sd == :chol_hamoed_pesach && jewish_day == 20)
    end

    def yom_tov_sheni?
      (jewish_month == 7 && jewish_day == 2) ||
          (!in_israel && ((jewish_month == 7 && [16, 23].include?(jewish_day)) ||
                          (jewish_month == 1 && [16, 22].include?(jewish_day)) ||
                          (jewish_month == 3 && jewish_day == 7)))
    end

    def erev_yom_tov_sheni?
      (jewish_month == 7 && jewish_day == 1) ||
          (!in_israel && ((jewish_month == 7 && [15, 22].include?(jewish_day)) ||
                          (jewish_month == 1 && [15, 21].include?(jewish_day)) ||
                          (jewish_month == 3 && jewish_day == 6)))
    end

    def chol_hamoed?
      sd = significant_day
      sd && (sd.to_s.start_with?('chol_hamoed_') || sd == :hoshana_rabbah)
    end

    def taanis?
      %i(seventeen_of_tammuz tisha_beav tzom_gedalyah yom_kippur tenth_of_teves taanis_esther).include?(significant_day)
    end

    def taanis_bechorim?
      (day_of_week != 7 && jewish_day == 14 && jewish_month == 1) ||   # normally 14th of nissan,
          (day_of_week == 5 && jewish_day == 12 && jewish_month == 1)  # when that falls on shabbos, moved to previous Thursday
    end

    def rosh_chodesh?
      jewish_day == 30 || (jewish_day == 1 && jewish_month != 7)
    end

    def erev_rosh_chodesh?
      jewish_day == 29 && jewish_month != 6
    end

    def chanukah?
      significant_day == :chanukah
    end

    def day_of_chanukah
      return unless chanukah?
      if jewish_month_name == :kislev
        jewish_day - 24
      else
        (kislev_short? ? 5 : 6) + jewish_day
      end
    end

    def day_of_omer
      case jewish_month_name
        when :nissan
          return (jewish_day - 15 if jewish_day > 15)
        when :iyar
          return jewish_day + 15
        when :sivan
          return (jewish_day + 44) if jewish_day < 6
      end
    end

    # DateTime for molad as UTC
    def molad_as_datetime
      m = molad
      location_name = 'Jerusalem, Israel'
      latitude = 31.778   # Har Habayis latitude
      longitude = 35.2354 # Har Habayis longitude
      tz = TZInfo::Timezone.get('Asia/Jerusalem')

      geo = Zmanim::Util::GeoLocation.new(location_name, latitude, longitude, tz)
      seconds = (m.molad_chalakim * 10) / 3.0
      # molad as local mean time
      time = DateTime.new(m.gregorian_year, m.gregorian_month, m.gregorian_day,
                          m.molad_hours, m.molad_minutes, seconds, '+2')
      offset_hours = geo.local_mean_time_offset / Zmanim::AstronomicalCalendar::HOUR_MILLIS.to_f
      # molad as Jerusalem standard time
      time -= offset_hours / 24.0
      # molad as UTC
      time.new_offset(0)
    end

    def techilas_zman_kiddush_levana_3_days
      molad_as_datetime + 3
    end

    def techilas_zman_kiddush_levana_7_days
      molad_as_datetime + 7
    end

    def sof_zman_kiddush_levana_between_moldos
      half_molad_in_days = CHALAKIM_PER_MONTH.to_f / (1080 * 24 * 2)
      molad_as_datetime + half_molad_in_days
    end

    def sof_zman_kiddush_levana_15_days
      molad_as_datetime + 15
    end

    def end_of_week
      self + (7 - day_of_week)
    end

    def daf_yomi_bavli
      Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(self)
    end

    def daf_yomi_yerushalmi
      Zmanim::Limudim::Calculators::DafYomiYerushalmi.new.limud(self)
    end

    def daf_hashavua_bavli
      Zmanim::Limudim::Calculators::DafHashavuaBavli.new.limud(self)
    end

    def parshas_hashavua(current_week_only: false)
      limud = Zmanim::Limudim::Calculators::Parsha.new(in_israel: in_israel).limud(self)
      limud.clear! if current_week_only && limud.interval.end_date > end_of_week
      limud
    end

    def tehillim_portion
      Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(self)
    end

    def mishna_yomis
      Zmanim::Limudim::Calculators::MishnaYomis.new.limud(self)
    end

    def pirkei_avos
      Zmanim::Limudim::Calculators::PirkeiAvos.new(in_israel: in_israel).limud(self)
    end

    def tefilah_additions(walled_city: false, nusach: :ashkenaz)
      additions = []
      if mashiv_haruach_starts?
        additions << :begin_mashiv_haruach
      elsif mashiv_haruach_ends?
        additions << (nusach == :sefard ? :begin_morid_hatal : :end_mashiv_haruach)
      else
        additions << :mashiv_haruach if mashiv_haruach?
        additions << :morid_hatal if nusach == :sefard && morid_hatal?
      end
      additions << :vesein_beracha if vesein_beracha?
      additions << :vesein_tal_umatar if vesein_tal_umatar?
      additions << :atah_yatzarta if day_of_week == 7 && rosh_chodesh?
      additions << :yaaleh_veyavo if yaaleh_veyavo?
      additions << :al_hanissim if al_hanissim?(walled_city)
      additions << :borchi_nafshi if rosh_chodesh?
      additions
    end

    def significant_shabbos
      return nil unless day_of_week == 7
      if jewish_month == 1
        if jewish_day == 1
          :parshas_hachodesh
        elsif jewish_day.between?(8,14)
          :shabbos_hagadol
        end
      elsif jewish_month == 7 && jewish_day.between?(3,9)
        :shabbos_shuva
      elsif jewish_month == months_in_jewish_year - 1 && jewish_day.between?(25,30)
        :parshas_shekalim
      elsif jewish_month == months_in_jewish_year
        if jewish_day == 1
          :parshas_shekalim
        elsif jewish_day.between?(7, 13)
          :parshas_zachor
        elsif jewish_day.between?(17,23)
          :parshas_parah
        elsif jewish_day.between?(24,29)
          :parshas_hachodesh
        end
      end
    end

    def pesach(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 1, 15)
      end
    end

    def pesach_sheni(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 2, 14)
      end
    end

    def lag_baomer(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 2, 18)
      end
    end

    def shavuos(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 3, 6)
      end
    end

    def seventeen_of_tammuz(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        date = JewishCalendar.new(y, 4, 17)
        date.forward! if date.day_of_week == 7
        date
      end
    end

    def tisha_beav(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        date = JewishCalendar.new(y, 5, 9)
        date.forward! if date.day_of_week == 7
        date
      end
    end

    def tu_beav(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 5, 15)
      end
    end

    def rosh_hashana(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 7, 1)
      end
    end

    def tzom_gedalyah(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        date = JewishCalendar.new(y, 7, 3)
        date.forward! if date.day_of_week == 7
        date
      end
    end

    def yom_kippur(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 7, 10)
      end
    end

    def succos(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 7, 15)
      end
    end

    def chanukah(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 9, 25)
      end
    end

    def tenth_of_teves(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 10, 10)
      end
    end

    def tu_beshvat(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, 11, 15)
      end
    end

    def purim(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        JewishCalendar.new(y, months_in_jewish_year(y), 14)
      end
    end

    def rosh_chodesh(upcoming: nil, month: nil, year: nil)
      find_monthly_event(upcoming, month, year) do |m, y|
        m = 8 if m == 7
        prev = m - 1
        prev = months_in_jewish_year(y) if prev < 1
        if days_in_jewish_month(prev,y) == 30
          JewishCalendar.new(y, prev, 30)
        else
          JewishCalendar.new(y, m, 1)
        end
      end
    end

    def shabbos_mevorchim(upcoming: nil, month: nil, year: nil)
      find_monthly_event(upcoming, month, year) do |m, y|
        m = 8 if m == 7
        prev = m - 1
        prev = months_in_jewish_year(y) if prev < 1
        mevorchim_start = JewishCalendar.new(y,prev,23)
        mevorchim_start + (7 - mevorchim_start.day_of_week)
      end
    end

    def vesein_tal_umatar_start(upcoming: nil, year: nil)
      find_annual_event(upcoming, year) do |y|
        start_date =
          if in_israel
            JewishCalendar.new(y, 8, 7)
          else
            JewishCalendar.new(y, 7, 1) + (47 - tekufas_tishrei_elapsed_days(1, year: y))
          end
        start_date.forward! if start_date.day_of_week == 7
        start_date
      end
    end

    def shabbos_mevorchim?
      day_of_week == 7 &&
          jewish_month != 6 &&
          (23..29).include?(jewish_day)
    end

    def mashiv_haruach_starts?
      jewish_month == 7 && jewish_day == 22
    end

    def mashiv_haruach_ends?
      jewish_month == 1 && jewish_day == 15
    end

    def mashiv_haruach?
      start_date = JewishDate.new(jewish_year, 7, 22)
      end_date = JewishDate.new(jewish_year, 1, 15)
      self.between?(start_date, end_date)
    end

    def morid_hatal?
      !mashiv_haruach? || mashiv_haruach_starts? || mashiv_haruach_ends?
    end

    # Because the jewish date does not auto-increment in the evening,
    # we use the daytime transition (e.g. December 5/6 for 20th/21st century) as the start date
    # and rely on the user to increment the jewish date after nightfall.
    def vesein_tal_umatar?
      return false if day_of_week == 7 || yom_tov_assur_bemelacha?
      return true if jewish_month == 1 && jewish_day < 15
      return false if jewish_month < 8
      if in_israel
        jewish_month > 8 || (jewish_month == 8 && jewish_day >= 7)
      else
        tekufas_tishrei_elapsed_days >= 47
      end
    end

    def vesein_tal_umatar_starts?
      if in_israel
        # 7 Cheshvan, or 8 Cheshvan if 7 is Shabbos
        return false unless jewish_month == 8
        (day_of_week != 7 && jewish_day == 7) || (day_of_week == 1 && jewish_day == 8)
      else
        elapsed_days = tekufas_tishrei_elapsed_days
        (day_of_week != 7 && elapsed_days == 47) || (day_of_week == 1 && elapsed_days == 48)
      end
    end

    def vesein_tal_umatar_starts_tonight?
      succ.vesein_tal_umatar_starts?
    end

    def vesein_beracha?
      return false if day_of_week == 7 || yom_tov_assur_bemelacha?
      !vesein_tal_umatar?
    end

    def yaaleh_veyavo?
      rosh_chodesh? || chol_hamoed? || yom_tov_assur_bemelacha?
    end

    def al_hanissim?(walled_city=false)
      purim_day = walled_city ? :shushan_purim : :purim
      [:chanukah, purim_day].include?(significant_day)
    end

    private

    def nissan_significant_day
      pesach = [15, 21]
      pesach |= [16, 22] unless in_israel
      chol_hamoed_pesach = (16..20)
      if jewish_day == 14
        :erev_pesach
      elsif pesach.include? jewish_day
        :pesach
      elsif chol_hamoed_pesach.include? jewish_day
        :chol_hamoed_pesach
      elsif use_modern_holidays
        if (jewish_day == 26 && day_of_week == 5) ||
           (jewish_day == 27 && ![1,6].include?(day_of_week)) ||
           (jewish_day == 28 && day_of_week == 2)
          :yom_hashoah
        end
      end
    end

    def iyar_significant_day
      if jewish_day == 14
        :pesach_sheni
      elsif jewish_day == 18
        :lag_baomer
      elsif use_modern_holidays
        # Note that this logic follows the current rules, which were last revised in 5764.
        # The calculations for years prior may not reflect the actual dates observed at that time.
        if ([2,3].include?(jewish_day) && day_of_week == 4) ||
           (jewish_day == 4 && day_of_week == 3) ||
           (jewish_day == 5 && day_of_week == 2)
          :yom_hazikaron
        elsif ([3,4].include?(jewish_day) && day_of_week == 5) ||
              (jewish_day == 5 && day_of_week == 4) ||
              (jewish_day == 6 && day_of_week == 3)
          :yom_haatzmaut
        elsif jewish_day == 28
          :yom_yerushalayim
        end
      end
    end

    def sivan_significant_day
      shavuos = [6]
      shavuos << 7 unless in_israel
      if jewish_day == 5
        :erev_shavuos
      elsif shavuos.include?(jewish_day)
        :shavuos
      end
    end

    def tammuz_significant_day
      if (jewish_day == 17 && day_of_week != 7) ||
         (jewish_day == 18 && day_of_week == 1)
        :seventeen_of_tammuz
      end
    end

    def av_significant_day
      if (jewish_day == 9 && day_of_week != 7) ||
         (jewish_day == 10 && day_of_week == 1)
        :tisha_beav
      elsif jewish_day == 15
        :tu_beav
      end
    end

    def elul_significant_day
      if jewish_day == 29
        :erev_rosh_hashana
      end
    end

    def tishrei_significant_day
      succos = [15]
      succos << 16 unless in_israel
      chol_hamoed_succos = (16..20)
      if [1,2].include? jewish_day
        :rosh_hashana
      elsif (jewish_day == 3 && day_of_week != 7) ||
            (jewish_day == 4 && day_of_week == 1)
        :tzom_gedalyah
      elsif jewish_day == 9
        :erev_yom_kippur
      elsif jewish_day == 10
        :yom_kippur
      elsif jewish_day == 14
        :erev_succos
      elsif succos.include?(jewish_day)
        :succos
      elsif chol_hamoed_succos.include?(jewish_day)
        :chol_hamoed_succos
      elsif jewish_day == 21
        :hoshana_rabbah
      elsif jewish_day == 22
        :shemini_atzeres
      elsif jewish_day == 23 && !in_israel
        :simchas_torah
      end
    end

    def cheshvan_significant_day
      nil
    end

    def kislev_significant_day
      if jewish_day >= 25
        :chanukah
      end
    end

    def teves_significant_day
      chanukah = [1,2]
      chanukah << 3 if kislev_short?
      if chanukah.include?(jewish_day)
        :chanukah
      elsif jewish_day == 10
        :tenth_of_teves
      end
    end

    def shevat_significant_day
      if jewish_day == 15
        :tu_beshvat
      end
    end

    def adar_significant_day
      if jewish_leap_year?
        if jewish_day == 14
          :purim_katan
        elsif jewish_day == 15
          :shushan_purim_katan
        end
      else
        purim_significant_day
      end
    end

    def adar_ii_significant_day
      purim_significant_day
    end

    def purim_significant_day
      if (jewish_day == 13 && day_of_week != 7) ||
          (jewish_day == 11 && day_of_week == 5)
        :taanis_esther
      elsif jewish_day == 14
        :purim
      elsif jewish_day == 15
        :shushan_purim
      end
    end

    def tekufas_tishrei_elapsed_days(day_number=day_number_of_jewish_year, year: jewish_year)
      days = jewish_calendar_elapsed_days(year) + (day_number-1) + 0.5
      solar = (year - 1) * 365.25
      (days - solar).floor.to_i
    end

    # Finds the date for an annual event whose rules are provided to the method as a block
    # Supports boolean `upcoming` or a given integer jewish `year`.
    # If both are nil, defaults to current jewish year.
    # `upcoming` finds the current or next occurrence of this event
    def find_annual_event(upcoming, year)
      if upcoming && year
        raise "'upcoming' and 'year' options cannot be used together"
      end

      upcoming = false if upcoming.nil?    # 'upcoming' only when explicitly passed
      year = jewish_year if year.nil?

      current = yield(year)
      upcoming && current < self ? yield(year+1) : current
    end

    # Finds the date for a monthly event whose rules are provided to the method as a block
    # Supports boolean `upcoming` or a given integer jewish `year` and `month`.
    # If all are nil, defaults to current jewish month and year.
    # `upcoming` finds the current or next occurrence of this event
    # If only month is provided, defaults to current jewish year.
    # If only year is provided, defaults to current jewish month.
    def find_monthly_event(upcoming, month, year)
      if upcoming && (year || month)
        raise "'upcoming' option cannot be used together with 'year' or 'month'"
      end

      upcoming = false if upcoming.nil?    # 'upcoming' only when explicitly passed
      year ||= jewish_year
      month ||= jewish_month

      current = yield(month, year)
      if upcoming && current < self
        month += 1
        month = 1 if month > months_in_jewish_year(year)
        year += 1 if month == 7
        yield(month, year)
      else
        current
      end
    end

  end
end
