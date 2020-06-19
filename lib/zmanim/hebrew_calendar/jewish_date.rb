module Zmanim::HebrewCalendar
  class JewishDate
    include Comparable

    MONTHS = %i(nissan iyar sivan tammuz av elul tishrei cheshvan kislev teves shevat adar adar_ii)

    RD = Date.new(1,1,1, Date::GREGORIAN)
    JEWISH_EPOCH = -1373429     # 1 Tishrei of year 1 (Shnas Tohu)
                                # Note that while the Gregorian year will be calculated as -3760, the actual year is -3761BCE
                                # This discrepancy is due to the presence of a year 0 in the Ruby implementation

    CHALAKIM_PER_MINUTE = 18
    CHALAKIM_PER_HOUR = CHALAKIM_PER_MINUTE * 60
    CHALAKIM_PER_DAY = CHALAKIM_PER_HOUR * 24
    CHALAKIM_PER_MONTH = (CHALAKIM_PER_DAY * 29.5).to_i + 793

    CHALAKIM_MOLAD_TOHU = CHALAKIM_PER_DAY + (CHALAKIM_PER_HOUR * 5) + 204

    CHESHVAN_KISLEV_KEVIAH = %i(chaseirim kesidran shelaimim)

    attr_reader :molad_hours, :molad_minutes, :molad_chalakim
    attr_reader :jewish_year, :jewish_month, :jewish_day, :day_of_week, :gregorian_date

    def initialize(*args)
      if args.size == 0
        reset_date!
      elsif args.size == 3
        set_jewish_date(*args)
      elsif args.size == 1 && args.first.is_a?(Date)
        self.date = args.first
      elsif args.size == 1 && args.first.is_a?(Numeric)
        set_from_molad(args.first)
      else
        raise ArgumentError
      end
    end

    def self.from_molad(molad)
      new(molad)
    end

    def self.from_jewish_date(year, month, day)
      new(year, month, day)
    end

    def self.from_date(date)
      new(date)
    end

    def reset_date!
      self.date = Date.today
      self
    end

    def date=(date)
      @gregorian_date = date.gregorian
      @absolute_date = gregorian_date_to_abs_date(gregorian_date)
      reset_day_of_week
      @molad_hours = @molad_minutes = @molad_chalakim = 0
      @jewish_year, @jewish_month, @jewish_day = jewish_date_from_abs_date(@absolute_date)
    end

    def set_gregorian_date(year, month, day)
      raise ArgumentError if year < -3760 || month < 1 || month > 12 || day < 1 || day > 31
      if day > (max_days = days_in_gregorian_month(month, year))
        day = max_days
      end
      self.date = Date.new(year, month, day, Date::GREGORIAN)
    end

    def set_jewish_date(year, month, day, hours=0, minutes=0, chalakim=0)
      raise ArgumentError if year < 1 || month < 1 || month > 13 || day < 1 || day > 30 ||
          hours < 0 || hours > 23 || minutes < 0 || minutes > 59  || chalakim < 0 || chalakim > 17
      if month > (max_months = months_in_jewish_year(year))
        month = max_months
      end
      if day > (max_days = days_in_jewish_month(month, year))
        day = max_days
      end
      self.date = gregorian_date_from_abs_date(jewish_date_to_abs_date(year, month, day))
      @molad_hours, @molad_minutes, @molad_chalakim = hours, minutes, chalakim
    end

    def forward!(increment=1)
      return back!(-increment) if increment < 0
      if increment > 500
        self.date = gregorian_date + increment
        return self
      end
      days_of_year = sorted_days_in_jewish_year
      y, m, d = jewish_year, jewish_month, jewish_day
      d += increment
      while d > (days_in_month = days_of_year.assoc(m)[1]) do
        d -= days_in_month
        m += 1
        m = 1 if m > days_of_year.length
        if m == 7
          y += 1
          days_of_year = sorted_days_in_jewish_year(y)
        end
      end
      @gregorian_date += increment
      @absolute_date += increment
      reset_day_of_week
      @jewish_year, @jewish_month, @jewish_day = y, m, d
      self
    end

    def back!(decrement=1)
      return forward!(-decrement) if decrement < 0
      if decrement > 500
        self.date = gregorian_date - decrement
        return self
      end
      days_of_year = sorted_days_in_jewish_year
      y, m, d = jewish_year, jewish_month, jewish_day
      d -= decrement
      while d <= 0 do
        m -= 1
        m = days_of_year.length if m == 0
        if m == 6
          y -= 1
          days_of_year = sorted_days_in_jewish_year(y)
        end
        days_in_month = days_of_year.assoc(m)[1]
        d += days_in_month
      end
      @gregorian_date -= decrement
      @absolute_date -= decrement
      reset_day_of_week
      @jewish_year, @jewish_month, @jewish_day = y, m, d
      self
    end

    def +(addend)
      raise ArgumentError unless addend.is_a?(Numeric)
      self.dup.forward!(addend)
    end

    def -(subtrahend)
      if subtrahend.is_a?(Numeric)
        self.dup.back!(subtrahend)
      elsif subtrahend.is_a?(JewishDate)
        absolute_date - subtrahend.send(:absolute_date)
      elsif subtrahend.respond_to?(:to_date)
        gregorian_date - subtrahend.to_date
      else
        raise ArgumentError
      end
    end

    def <=>(other)
      if other.is_a?(JewishDate)
        gregorian_date <=> other.gregorian_date
      else
        gregorian_date <=> other
      end
    end

    def succ
      self + 1
    end

    def step(limit, step=1, &block)
      if step < 0
        downto(limit, -step, &block)
      else
        upto(limit, step, &block)
      end
    end

    def downto(limit, step=1)
      raise ArgumentError, 'step argument must be greater than 0' if step <= 0
      return to_enum(__method__, limit, step) unless block_given?
      c = self
      while c >= limit
        yield c
        c -= step
      end
      self
    end

    def upto(limit, step=1)
      raise ArgumentError, 'step argument must be greater than 0' if step <= 0
      return to_enum(__method__, limit, step) unless block_given?
      c = self
      while c <= limit
        yield c
        c += step
      end
      self
    end

    def gregorian_year=(year)
      set_gregorian_date(year, gregorian_month, gregorian_day)
    end

    def gregorian_year
      gregorian_date.year
    end

    def gregorian_month=(month)
      set_gregorian_date(gregorian_year, month, gregorian_day)
    end

    def gregorian_month
      gregorian_date.month
    end

    def gregorian_day=(day)
      set_gregorian_date(gregorian_year, gregorian_month, day)
    end

    def gregorian_day
      gregorian_date.day
    end

    def days_in_gregorian_year(year=gregorian_year)
      gregorian_leap_year?(year) ? 366 : 365
    end

    def days_in_gregorian_month(month=gregorian_month, year=gregorian_year)
      case month
        when 2
          gregorian_leap_year?(year) ? 29 : 28
        when 4, 6, 9, 11
          30
        else
          31
      end
    end

    def gregorian_leap_year?(year=gregorian_year)
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    end

    def jewish_year=(year)
      set_jewish_date(year, jewish_month, jewish_day)
    end

    def jewish_month=(month)
      set_jewish_date(jewish_year, month, jewish_day)
    end

    def jewish_day=(day)
      set_jewish_date(jewish_year, jewish_month, day)
    end

    def days_in_jewish_year(year=jewish_year)
      jewish_calendar_elapsed_days(year+1) - jewish_calendar_elapsed_days(year)
    end

    def months_in_jewish_year(year=jewish_year)
      jewish_leap_year?(year) ? 13 : 12
    end

    # Returns the list of jewish months for a given jewish year in chronological order
    #   sorted_months_in_jewish_year(5779)
    #   => [7, 8, 9, 10, 11, 12, 13, 1, 2, 3, 4, 5, 6]
    def sorted_months_in_jewish_year(year=jewish_year)
      (1..months_in_jewish_year(year)).sort_by{|y| [y >= 7 ? 0 : 1, y]}
    end

    # Returns the number of days in each jewish month for a given jewish year in chronological order
    #   sorted_days_in_jewish_year(5779)
    #   => [[7, 30], [8, 29], [9, 30], [10, 29], [11, 30], [12, 30], [13, 29], [1, 30], [2, 29], [3, 30], [4, 29], [5, 30], [6, 29]]
    def sorted_days_in_jewish_year(year=jewish_year)
      sorted_months_in_jewish_year(year).map{|month| [month, days_in_jewish_month(month, year)]}
    end

    def days_in_jewish_month(month=jewish_month, year=jewish_year)
      m = jewish_month_name(month)
      if %i(iyar tammuz elul teves adar_ii).include?(m) ||
          (m == :cheshvan && cheshvan_short?(year)) ||
          (m == :kislev && kislev_short?(year)) ||
          (m == :adar && !jewish_leap_year?(year))
        29
      else
        30
      end
    end

    def day_number_of_jewish_year(year=jewish_year, month=jewish_month, day=jewish_day)
      month_index = month_number_from_tishrei(year, month) - 1
      day + sorted_months_in_jewish_year(year)[0...month_index].sum{|m| days_in_jewish_month(m, year)}
    end

    def jewish_leap_year?(year=jewish_year)
      ((7 * year) + 1) % 19 < 7
    end

    def cheshvan_long?(year=jewish_year)
      days_in_jewish_year(year) % 10 == 5
    end

    def cheshvan_short?(year=jewish_year)
      !cheshvan_long?(year)
    end

    def kislev_long?(year=jewish_year)
      !kislev_short?(year)
    end

    def kislev_short?(year=jewish_year)
      days_in_jewish_year(year) % 10 == 3
    end

    def cheshvan_kislev_kviah(year=jewish_year)
      CHESHVAN_KISLEV_KEVIAH[(days_in_jewish_year(year) % 10) - 3]
    end

    def kviah(year=jewish_year)
      date = year.is_a?(Numeric) ? Zmanim::HebrewCalendar::JewishDate.new(year, 7, 1) : year
      kviah = date.cheshvan_kislev_kviah
      rosh_hashana_day = date.day_of_week
      date.jewish_month = 1
      pesach_day = date.day_of_week
      {rosh_hashana: rosh_hashana_day,
       kviah: kviah,
       pesach: pesach_day}
    end

    # Returns a new JewishDate as the molad for given month
    def molad(month=jewish_month, year=jewish_year)
      self.class.from_molad(chalakim_since_molad_tohu(year, month))
    end

    def jewish_month_from_name(month_name)
      MONTHS.index(month_name) + 1
    end

    def jewish_month_name(month=jewish_month)
      MONTHS[month - 1]
    end

    private

    attr_accessor :absolute_date
    attr_writer :gregorian_date

    def set_from_molad(molad)
      gregorian_date = gregorian_date_from_abs_date(molad_to_abs_date(molad))
      remainder = molad % CHALAKIM_PER_DAY
      molad_hours, remainder = remainder.divmod CHALAKIM_PER_HOUR
      # molad hours start at 18:00, which means that
      # we cross a secular date boundary if hours are 6 or greater
      gregorian_date += 1 if molad_hours >= 6
      self.date = gregorian_date
      # Normalize hours to start at 00:00
      @molad_hours = (molad_hours + 18) % 24
      @molad_minutes, @molad_chalakim = remainder.divmod CHALAKIM_PER_MINUTE
      self
    end

    def month_number_from_tishrei(year, month)
      leap = jewish_leap_year?(year)
      1 + ((month + (leap ? 6 : 5)) % (leap ? 13 : 12))
    end

    def dechiyos_count(year, days, remainder)
      count = 0
      # 'days' is Monday-based due to start of Molad at BaHaRaD
      # add 1 to convert to Sunday-based, '0' represents Shabbos
      rosh_hashana_day = (days+1) % 7
      if (remainder >= 19440) ||
          ((rosh_hashana_day == 3) && (remainder >= 9924) && !jewish_leap_year?(year)) ||
          ((rosh_hashana_day == 2) && (remainder >= 16789) && jewish_leap_year?(year-1))
        count = 1
      end
      count += 1 if [1, 4, 6].include?((rosh_hashana_day+count) % 7)
      count
    end

    def molad_components_for_year(year)
      chalakim = chalakim_since_molad_tohu(year, 7)  # chalakim up to tishrei of given year
      chalakim.divmod(CHALAKIM_PER_DAY)
    end

    def jewish_calendar_elapsed_days(year)
      days, remainder = molad_components_for_year(year)
      days + dechiyos_count(year, days, remainder)
    end

    def chalakim_since_molad_tohu(year=jewish_year, month=jewish_month)
      prev_year = year - 1
      months = month_number_from_tishrei(year, month) - 1
      cycles, remainder = prev_year.divmod(19)
      months += (235 * cycles) +
          (12 * remainder) +
          (((7 * remainder) + 1) / 19)
      CHALAKIM_MOLAD_TOHU + (CHALAKIM_PER_MONTH * months)
    end

    def jewish_date_to_abs_date(year, month, day)
      day_number_of_jewish_year(year, month, day) +
          jewish_year_start_to_abs_date(year) - 1
    end

    def jewish_year_start_to_abs_date(year)
      jewish_calendar_elapsed_days(year) + JEWISH_EPOCH + 1
    end

   def jewish_date_from_abs_date(absolute_date)
      jewish_year = (absolute_date - JEWISH_EPOCH) / 366

      # estimate may be low for CE
      while absolute_date >= jewish_year_start_to_abs_date(jewish_year+1) do
        jewish_year += 1
      end

      # estimate may be high for BCE
      while absolute_date < jewish_year_start_to_abs_date(jewish_year) do
        jewish_year -= 1
      end

      months = sorted_months_in_jewish_year(jewish_year)
      jewish_month = months[0..-2].detect.with_index do |m, i|
        absolute_date < jewish_date_to_abs_date(jewish_year, months[i+1], 1)
      end || months.last

      jewish_day = absolute_date - jewish_date_to_abs_date(jewish_year, jewish_month, 1) + 1

      [jewish_year, jewish_month, jewish_day]
    end

    def molad_to_abs_date(chalakim)
      (chalakim / CHALAKIM_PER_DAY) + JEWISH_EPOCH
    end

    def gregorian_date_from_abs_date(absolute_date)
      RD + (absolute_date - 1)
    end

    def gregorian_date_to_abs_date(date)
      (date - RD).to_i + 1
    end

    def reset_day_of_week
      @day_of_week = (gregorian_date.cwday % 7) + 1   # 1-based starting with Sunday
    end
  end
end
