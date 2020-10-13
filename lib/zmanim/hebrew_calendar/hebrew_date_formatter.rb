# encoding: UTF-8
require 'zmanim/util/text_helper'
require 'zmanim/util/hebrew_numeric_formatter'
require_relative 'jewish_calendar'

module Zmanim::HebrewCalendar
  class HebrewDateFormatter
    extend Zmanim::Util::TextHelper
    include Zmanim::Util::HebrewNumericFormatter

    attr_accessor :hebrew_format, :use_long_hebrew_years, :long_week_format,
                  :transliterated_days_of_week,  :transliterated_months, :transliterated_significant_days,
                  :transliterated_significant_tefilos, :transliterated_significant_shabbosos,
                  :hebrew_days_of_week, :hebrew_months, :hebrew_significant_days, :hebrew_significant_tefilos,
                  :hebrew_significant_shabbosos, :hebrew_omer_prefix

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
                taanis_esther: 'Fast of Esther', lag_baomer: "Lag B'Omer", seventeen_of_tammuz: 'Seventeenth of Tammuz',
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
            lag_baomer:          'ל״ג בעומר',
            erev_shavuos:        'ערב שבועות',
            shavuos:             'שבועות',
            seventeen_of_tammuz: 'שבעה עשר בתמוז',
            tisha_beav:          'תשעה באב',
            tu_beav:             'ט״ו באב',
            yom_hashoah:         'יום השואה',
            yom_hazikaron:       'יום הזכרון',
            yom_haatzmaut:       'יום העצמאות',
            yom_yerushalayim:    'יום ירושלים',
        }
    }

    FORMATTED_SIGNIFICANT_TEFILOS = {
        transliterated: Zmanim::HebrewCalendar::JewishCalendar::SIGNIFICANT_TEFILOS.each_with_object({}){|d, h|
          h[d] = titleize(d)
        }.merge(begin_mashiv_haruach: 'Mashiv Haruach (beginning Mussaf)',
                end_mashiv_haruach:   'Mashiv Haruach (ending Mussaf)',
                begin_morid_hatal:    'Morid Hatal (beginning Mussaf)'),
        hebrew: {
            yaaleh_veyavo:        'יעלה ויבא',
            al_hanissim:          'על הנסים',
            begin_mashiv_haruach: 'משיב הרוח (מתחילים במוסף)',
            end_mashiv_haruach:   'משיב הרוח (מסיימים במוסף)',
            mashiv_haruach:       'משיב הרוח',
            begin_morid_hatal:    'מוריד הטל (מתחילים במוסף)',
            morid_hatal:          'מוריד הטל',
            vesein_tal_umatar:    'ותן טל ומטר',
            vesein_beracha:       'ותן ברכה',
            atah_yatzarta:        'אתה יצרת',
            borchi_nafshi:        'ברכי נפשי',
        }
    }

    FORMATTED_SIGNIFICANT_SHABBOSOS = {
        transliterated: Zmanim::HebrewCalendar::JewishCalendar::SIGNIFICANT_SHABBOS.each_with_object({}){|d, h|
          h[d] = titleize(d)
        },
        hebrew: {
            parshas_shekalim:  'פרשת שקלים',
            parshas_zachor:    'פרשת זכור',
            parshas_parah:     'פרשת פרה',
            parshas_hachodesh: 'פרשת החדש',
            shabbos_hagadol:   'שבת הגדול',
            shabbos_shuva:     'שבת שובה',
        }
    }

    def initialize
      super  # hebrew numeric formatter
      @long_week_format = true
      @transliterated_days_of_week = FORMATTED_DAYS_OF_WEEK[:transliterated]
      @transliterated_months = FORMATTED_MONTHS[:transliterated]
      @transliterated_significant_days = FORMATTED_SIGNIFICANT_DAYS[:transliterated]
      @transliterated_significant_tefilos = FORMATTED_SIGNIFICANT_TEFILOS[:transliterated]
      @transliterated_significant_shabbosos = FORMATTED_SIGNIFICANT_SHABBOSOS[:transliterated]
      @hebrew_days_of_week = FORMATTED_DAYS_OF_WEEK[:hebrew]
      @hebrew_months = FORMATTED_MONTHS[:hebrew]
      @hebrew_significant_days = FORMATTED_SIGNIFICANT_DAYS[:hebrew]
      @hebrew_significant_tefilos = FORMATTED_SIGNIFICANT_TEFILOS[:hebrew]
      @hebrew_significant_shabbosos = FORMATTED_SIGNIFICANT_SHABBOSOS[:hebrew]
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
      super(number, use_long_hebrew_years)
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
        number == 33 ? "Lag B'Omer" : "Omer #{number}"
      end
    end

    def format_kviah(year)
      date = year.is_a?(Numeric) ? Zmanim::HebrewCalendar::JewishDate.new(year, 7, 1) : year
      kviah_values = date.kviah
      kviah_glyph = {chaseirim: 'ח', kesidran: 'כ', shelaimim: 'ש'}[kviah_values[:kviah]]
      "#{format_hebrew_number(kviah_values[:rosh_hashana])}#{kviah_glyph}#{format_hebrew_number(kviah_values[:pesach])}".delete(GERESH)
    end

    def format_tefilah_additions(calendar, customs={walled_city: false, nusach: :ashkenaz})
      additions = calendar.tefilah_additions(walled_city: customs[:walled_city], nusach: customs[:nusach])
      additions.map do |addition|
        hebrew_format ?
          hebrew_significant_tefilos[addition] :
          transliterated_significant_tefilos[addition]
      end
    end

    def format_significant_shabbos(calendar)
      return '' unless shabbos = calendar.significant_shabbos
      hebrew_format ?
          hebrew_significant_shabbosos[shabbos] :
          transliterated_significant_shabbosos[shabbos]
    end

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

    def format_month_from_name(month_name, is_leap_year)
      month_name = :adar_i if month_name == :adar && is_leap_year
      if hebrew_format
        suffix = use_geresh_gershayim & month_name.to_s.start_with?('adar_') ? Zmanim::Util::HebrewNumericFormatter::GERESH : ''
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
