# encoding: UTF-8
module Zmanim::Util
  module HebrewNumericFormatter
    attr_accessor :use_geresh_gershayim

    GERESH = '׳'
    GERSHAYIM = '״'

    def initialize
      @use_geresh_gershayim = true
    end

    def format_hebrew_number(number, include_thousands=false)
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
      elsif thousands > 0 && include_thousands
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

    private

    def add_geresh(str)
      use_geresh_gershayim ? str + GERESH : str
    end
  end
end
