# encoding: UTF-8
module Zmanim::HebrewCalendar
  class HebrewDateFormatter
    extend Zmanim::Util::TextHelper
    attr_accessor :hebrew_format, :use_long_hebrew_years, :use_geresh_gershayim, :long_week_format,
                  :transliterated_days_of_week,  :transliterated_months, :transliterated_significant_days,
                  :hebrew_days_of_week, :hebrew_months, :hebrew_significant_days,
                  :hebrew_omer_prefix

    GERESH = '׳'
    GERSHAYIM = '״'
    HEBREW_OMER_PREFIX = 'ב'
    FORMATTED_DAYS_OF_WEEK = {
      transliterated: Date::DAYNAMES[0..-2] + ['Shabbos'],
      hebrew: %w(ראשון שני שלישי רביעי חמישי ששי שבת)
    }

    FORMATTED_MONTHS = {
        transliterated: Zmanim::HebrewCalendar::JewishCalendar::MONTHS.each_with_object({}){|m, h|
          h[m] = titleize(m)
        }.merge(adar_i: 'Adar I', adar_ii: 'Adar II'),
        hebrew: {
            nissan:   'ניסן',
            iyar:     'אייר',
            sivan:    'סיון',
            tammuz:   'תמוז',
            av:       'אב',
            elul:     'אלול',
            tishrei:  'תשרי',
            cheshvan: 'חשון',
            kislev:   'כסלו',
            teves:    'טבת',
            shevat:   'שבט',
            adar:     'אדר',
            adar_i:   'אדר א',
            adar_ii:  'אדר ב'
        }
    }

    FORMATTED_SIGNIFICANT_DAYS = {
        transliterated: Zmanim::HebrewCalendar::JewishCalendar::SIGNIFICANT_DAYS.each_with_object({}){|d, h|
          h[d] = titleize(d)
        }.merge(tzom_gedalyah: 'Fast of Gedalyah', tenth_of_teves: 'Tenth of Teves', tu_beshvat: "Tu B'Shvat",
                taanis_esther: 'Fast of Esther', seventeen_of_tammuz: 'Seventeenth of Tammuz',
                tisha_beav: "Tisha B'Av", tu_beav: "Tu B'Av", yom_hashoah: 'Yom HaShoah', yom_haatzmaut: "Yom Ha'atzmaut"),
        hebrew: {
            erev_rosh_hashana:   'ערב ראש השנה',
            rosh_hashana:        'ראש השנה',
            tzom_gedalyah:       'צום גדליה',
            erev_yom_kippur:     'ערב יום כיפור',
            yom_kippur:          'יום כיפור',
            erev_succos:         'ערב סוכות',
            succos:              'סוכות',
            chol_hamoed_succos:  'חול המועד סוכות',
            hoshana_rabbah:      'הושענה רבה',
            shemini_atzeres:     'שמיני עצרת',
            simchas_torah:       'שמחת תורה',
            chanukah:            'חנוכה',
            tenth_of_teves:      'עשרה בטבת',
            tu_beshvat:          'ט״ו בשבט',
            taanis_esther:       'תענית אסתר',
            purim:               'פורים',
            shushan_purim:       'שושן פורים',
            purim_katan:         'פורים קטן',
            shushan_purim_katan: 'שושן פורים קטן',
            erev_pesach:         'ערב פסח',
            pesach:              'פסח',
            chol_hamoed_pesach:  'חול המועד פסח',
            pesach_sheni:        'פסח שני',
            erev_shavuos:        'ערב שבועות',
            shavuos:             'שבועות',
            seventeen_of_tammuz: 'שבעה עשר בתמוז',
            tisha_beav:          'תשעה באב',
            tu_beav:             'ט״ו באב',
            yom_hashoah:         'יום השואה',
            yom_hazikaron:       'יום הזכרון',
            yom_haatzmaut:       'יום העצמות',
            yom_yerushalayim:    'יום ירושלים',
        }

    }

    def initialize
      @use_geresh_gershayim = true
      @long_week_format = true
      @transliterated_days_of_week = FORMATTED_DAYS_OF_WEEK[:transliterated]
      @transliterated_months = FORMATTED_MONTHS[:transliterated]
      @transliterated_significant_days = FORMATTED_SIGNIFICANT_DAYS[:transliterated]
      @hebrew_days_of_week = FORMATTED_DAYS_OF_WEEK[:hebrew]
      @hebrew_months = FORMATTED_MONTHS[:hebrew]
      @hebrew_significant_days = FORMATTED_SIGNIFICANT_DAYS[:hebrew]
      @hebrew_omer_prefix = HEBREW_OMER_PREFIX
    end

    def format(date)
      if hebrew_format
        format_hebrew_number(date.jewish_day) + ' ' + format_month(date) + ' ' + format_hebrew_number(date.jewish_year)
      else
        "#{date.jewish_day} #{format_month(date)}, #{date.jewish_year}"
      end
    end

    def format_month(date)
      format_month_from_name(date.jewish_month_name, date.jewish_leap_year?)
    end

    def format_day_of_week(date)
      format_day_of_week_from_number(date.day_of_week)
    end

    def format_hebrew_number(number)
      raise ArgumentError unless (0..9999).include?(number)
      descriptors = {efes: 'אפס', alafim: 'אלפים'}
      one_glyphs = [''] + %w(א ב ג ד ה ו ז ח ט)
      ten_glyphs = [''] + %w(י כ ל מ נ ס ע פ צ)
      final_ten_glyphs = [''] + %w(י ך ל ם ן ס ע ף ץ)
      hundred_glyphs = [''] + %w(ק ר ש ת תק תר תש תת תתק)
      tav_taz_glyphs = %w(טו טז)

      return descriptors[:efes] if number == 0

      thousands, remainder = number.divmod(1000)
      hundreds, remainder = remainder.divmod(100)
      tens, ones = remainder.divmod(10)

      str = ''

      if number % 1000 == 0
        return add_geresh(one_glyphs[thousands]) + ' ' + descriptors[:alafim]
      elsif thousands > 0 && use_long_hebrew_years
        str += add_geresh(one_glyphs[thousands]) + ' '
      end

      str += hundred_glyphs[hundreds]
      if tens == 1 and ones == 5
        str += tav_taz_glyphs[0]
      elsif tens == 1 and ones == 6
        str += tav_taz_glyphs[1]
      else
        if ones == 0 && hundreds != 0
          str += final_ten_glyphs[tens]
        else
          str += ten_glyphs[tens]
        end
        str += one_glyphs[ones]
      end

      if use_geresh_gershayim
        if [hundreds, tens, ones].select{|p| p > 0}.count == 1 && hundreds <= 4
          str += GERESH
        else
          str.insert(-2, GERSHAYIM)
        end
      end

      str
    end

    def format_significant_day(calendar)
      sd = calendar.significant_day
      return '' unless sd
      prefix = (day_number = calendar.day_of_chanukah) ? formatted_number(day_number) + ' ' : ''
      prefix + formatted_significant_day(sd)
    end

    def format_rosh_chodesh(calendar)
      return '' unless calendar.rosh_chodesh? || calendar.erev_rosh_chodesh?
      month = calendar.jewish_month
      day = calendar.jewish_day
      if day != 1
        month += 1
        month = 1 if month > calendar.months_in_jewish_year
      end
      month_name = calendar.jewish_month_name(month)
      formatted_rosh_chodesh(calendar.erev_rosh_chodesh?) + ' ' + format_month_from_name(month_name, calendar.jewish_leap_year?)
    end

    def format_omer(calendar)
      return '' unless number = calendar.day_of_omer
      if hebrew_format
        format_hebrew_number(number) + ' ' + hebrew_omer_prefix + 'עומר'
      else
        number == 33 ? 'Lag BaOmer' : "Omer #{number}"
      end
    end

    def format_kviah(year)
      date = year.is_a?(Numeric) ? Zmanim::HebrewCalendar::JewishDate.new(year, 7, 1) : year
      kviah = date.cheshvan_kislev_kviah
      rosh_hashana_day = date.day_of_week
      kviah_glyph = {chaseirim: 'ח', kesidran: 'כ', shelaimim: 'ש'}[kviah]
      date.jewish_month = 1
      pesach_day = date.day_of_week
      "#{format_hebrew_number(rosh_hashana_day)}#{kviah_glyph}#{format_hebrew_number(pesach_day)}".delete(GERESH)
    end

    # def format_daf_yomi_bavli
    #
    # end
    #
    # def format_daf_yomi_yerushalmi
    #
    # end

    private

    # We don't consider Rosh Chodesh similar to other significant days due to overlapping complexity with Chanuka
    def formatted_rosh_chodesh(is_erev)
      prefix = ''
      prefix += (hebrew_format ? 'ערב ' : 'Erev ') if is_erev
      prefix + (hebrew_format ? 'ראש חדש' : 'Rosh Chodesh')
    end

    def formatted_significant_day(sd)
      hebrew_format ? hebrew_significant_days[sd] : transliterated_significant_days[sd]
    end

    def formatted_number(number)
      hebrew_format ? format_hebrew_number(number) : number.to_s
    end

    def add_geresh(str)
      use_geresh_gershayim ? str + GERESH : str
    end

    def format_month_from_name(month_name, is_leap_year)
      month_name = :adar_i if month_name == :adar && is_leap_year
      if hebrew_format
        suffix = use_geresh_gershayim & month_name.to_s.start_with?('adar_') ? GERESH : ''
        hebrew_months[month_name] + suffix
      else
        transliterated_months[month_name]
      end
    end

    def format_day_of_week_from_number(number)
      if hebrew_format
        long_week_format ? hebrew_days_of_week[number - 1] : format_hebrew_number(number)
      else
        transliterated_days_of_week[number - 1]
      end
    end
  end
end
