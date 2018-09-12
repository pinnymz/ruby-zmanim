require 'spec_helper'

describe Zmanim::HebrewCalendar::JewishDate, hebrew_calendar: true do
  let(:secular_dates){ Zmanim::HebrewCalendarSpecHelper::SECULAR_DATES }
  let(:jewish_dates){ Zmanim::HebrewCalendarSpecHelper::JEWISH_DATES }
  let(:standard_year_chaseir){5777}
  let(:standard_year_kesidran){5778}
  let(:standard_year_shaleim){5770}
  let(:leap_year_chaseir){5765}
  let(:leap_year_kesidran){5755}
  let(:leap_year_shaleim){5776}
  subject{ Zmanim::HebrewCalendar::JewishDate.new }
  describe '.new' do
    context 'with no arguments' do
      let(:today){ Date.today.gregorian }
      subject{ Zmanim::HebrewCalendar::JewishDate.new }
      it 'sets the gregorian date to today' do
        expect_gregorian_date(subject, today)
      end
      it 'sets the jewish date to today' do
        year, month, day = subject.jewish_year, subject.jewish_month, subject.jewish_day
        subject.date = today
        expect_jewish_date(subject, year, month, day)
      end
    end
    describe 'with a date argument' do
      subject{ Zmanim::HebrewCalendar::JewishDate.new(date)}
      context 'using default calendar (Date::ITALY)' do
        context 'in modern times' do
          let(:date){ Date.parse(secular_dates[:modern])}
          it 'converts to expected times' do
            expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
          end
        end
        context 'prior to 1582' do
          let(:date){ Date.parse(secular_dates[:pre_gregorian])}
          it 'converts to expected times' do
            expect_date_mappings(subject, offset_days(secular_dates[:pre_gregorian], 10), offset_days(jewish_dates[:pre_gregorian], 10))
          end
        end
        context 'prior to CE' do
          let(:date){ Date.parse(secular_dates[:bce])}
          it 'converts to expected times' do
            expect_date_mappings(subject, offset_days(secular_dates[:bce], -2), offset_days(jewish_dates[:bce], -2))
          end
        end
      end
      context 'using GREGORIAN calendar' do
        context 'in modern times' do
          let(:date){ Date.parse(secular_dates[:modern], true, Date::GREGORIAN)}
          it 'converts to expected times' do
            expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
          end
        end
        context 'prior to 1582' do
          let(:date){ Date.parse(secular_dates[:pre_gregorian], true, Date::GREGORIAN)}
          it 'converts to expected times' do
            expect_date_mappings(subject, secular_dates[:pre_gregorian], jewish_dates[:pre_gregorian])
          end
        end
        context 'prior to CE' do
          let(:date){ Date.parse(secular_dates[:bce], true, Date::GREGORIAN)}
          it 'converts to expected times' do
            expect_date_mappings(subject, secular_dates[:bce], jewish_dates[:bce])
          end
        end
      end
    end
    describe 'with 3 numeric arguments' do
      subject{ Zmanim::HebrewCalendar::JewishDate.new(*jewish_date)}
      context 'in modern times' do
        let(:jewish_date){ jewish_dates[:modern].split('-').map(&:to_i) }
        it 'calculates properly for the jewish date' do
          expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
        end
      end
      context 'prior to 1582' do
        let(:jewish_date){ jewish_dates[:pre_gregorian].split('-').map(&:to_i) }
        it 'calculates properly for the jewish date' do
          expect_date_mappings(subject, secular_dates[:pre_gregorian], jewish_dates[:pre_gregorian])
        end
      end
      context 'prior to CE' do
        let(:jewish_date){ jewish_dates[:bce].split('-').map(&:to_i) }
        it 'calculates properly for the jewish date' do
          expect_date_mappings(subject, secular_dates[:bce], jewish_dates[:bce])
        end
      end
    end
    describe 'with a single numeric argument' do
      subject{ Zmanim::HebrewCalendar::JewishDate.new(molad) }
      context 'with molad hours before midnight' do
        let(:molad){ 54700170003 }  # molad for 'Elul 5778'
        it 'calculates dates properly for the given molad' do
          expect_date_mappings(subject, '2018-08-11', '5778-05-30')
        end
        it 'calculates the correct molad components' do
          expect(subject.molad_hours).to eq 19
          expect(subject.molad_minutes).to eq 33
          expect(subject.molad_chalakim).to eq 9
        end
      end
      context 'with molad hours after midnight' do
        let(:molad){ 54692515673 }  # molad for 'Cheshvan 5778'
        it 'calculates dates properly for the given molad' do
          expect_date_mappings(subject, '2017-10-20', '5778-07-30')
        end
        it 'calculates the correct molad components' do
          expect(subject.molad_hours).to eq 12
          expect(subject.molad_minutes).to eq 12
          expect(subject.molad_chalakim).to eq 17
        end
      end
    end
  end
  describe '.from_date' do
    let(:date){ Date.parse(secular_dates[:modern]) }
    subject{ Zmanim::HebrewCalendar::JewishDate.from_date(date)}
    it 'calculates for the secular date' do
      expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
    end
  end
  describe '.from_jewish_date' do
    let(:date){ jewish_dates[:modern].split('-').map(&:to_i) }
    subject{ Zmanim::HebrewCalendar::JewishDate.from_jewish_date(*date)}
    it 'calculates for the jewish date' do
      expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
    end
  end
  describe '.from_molad' do
    let(:molad){ 54692515673 }
    subject{ Zmanim::HebrewCalendar::JewishDate.from_molad(molad) }
    it 'calculates for the molad' do
      expect_date_mappings(subject, '2017-10-20', '5778-07-30')
    end
  end
  describe '#reset_date!' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(Date.today - 3) }
    it 'returns self' do
      expect(subject.reset_date!).to eq subject
    end
    it 'resets the date to today' do
      subject.reset_date!
      expect_gregorian_date(subject, *Date.today.iso8601.split('-').map(&:to_i))
    end
  end
  describe '#date=' do
    let(:new_date){ Date.parse(secular_dates[:modern]) }
    it 'assigns the correct dates' do
      subject.date = new_date
      expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
    end
    it 'assigns the correct day of week' do
      subject.date = new_date
      expect(subject.day_of_week).to eq 5  # Thursday
      subject.date = new_date + 2
      expect(subject.day_of_week).to eq 7  # Saturday
    end
    context 'with a non-gregorian date' do
      let(:new_date){ Date.parse(secular_dates[:pre_gregorian]) }
      it 'converts to gregorian' do
        subject.date = new_date
        expect_date_mappings(subject, offset_days(secular_dates[:pre_gregorian], 10), offset_days(jewish_dates[:pre_gregorian], 10))
      end
    end
    context 'with a proleptic gregorian date' do
      let(:new_date){ Date.parse(secular_dates[:pre_gregorian], true, Date::GREGORIAN) }
      it 'calculates in place' do
        subject.date = new_date
        expect_date_mappings(subject, secular_dates[:pre_gregorian], jewish_dates[:pre_gregorian])
      end
    end
    context 'where a molad was set' do
      subject{ Zmanim::HebrewCalendar::JewishDate.new(54692515673) }
      it 'resets the molad components' do
        subject.date = new_date
        expect(subject.molad_hours).to eq 0
        expect(subject.molad_minutes).to eq 0
        expect(subject.molad_chalakim).to eq 0
      end
    end
  end
  describe '#set_gregorian_date' do
    let(:new_date){ secular_dates[:pre_gregorian] }
    it 'calculates correctly' do
      subject.set_gregorian_date(*new_date.split('-').map(&:to_i))
      expect_date_mappings(subject, secular_dates[:pre_gregorian], jewish_dates[:pre_gregorian])
    end
    it 'raises on invalid month' do
      expect{ subject.set_gregorian_date(2000, 13, 5) }.to raise_error ArgumentError
    end
    it 'raises on invalid day' do
      expect{ subject.set_gregorian_date(2000, 11, 50) }.to raise_error ArgumentError
    end
    it 'resets day to max day in month' do
      subject.set_gregorian_date(2000, 11, 31)
      expect(subject.gregorian_day).to eq 30
      subject.set_gregorian_date(2001, 2, 29)
      expect(subject.gregorian_day).to eq 28
    end
  end
  describe '#set_jewish_date' do
    let(:new_date){ jewish_dates[:modern] }
    it 'calculates correctly' do
      subject.set_jewish_date(*new_date.split('-').map(&:to_i))
      expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
    end
    it 'raises on invalid month' do
      expect{ subject.set_jewish_date(5778, 14, 23) }.to raise_error ArgumentError
    end
    it 'raises on invalid day' do
      expect{ subject.set_jewish_date(5778, 11, 31) }.to raise_error ArgumentError
    end
    it 'resets month to max month in year' do
      subject.set_jewish_date(5778, 13, 5)
      expect(subject.jewish_month).to eq 12
    end
    it 'resets day to max day in month' do
      subject.set_jewish_date(5778, 8, 30)
      expect(subject.jewish_day).to eq 29
      subject.set_jewish_date(5778, 12, 30)
      expect(subject.jewish_day).to eq 29
    end
    context 'where molad was set' do
      subject{ Zmanim::HebrewCalendar::JewishDate.new(54692515673) }
      it 'resets the molad components' do
        subject.set_jewish_date(*new_date.split('-').map(&:to_i))
        expect(subject.molad_hours).to eq 0
        expect(subject.molad_minutes).to eq 0
        expect(subject.molad_chalakim).to eq 0
      end
    end
    context 'where molad is being passed' do
      it 'sets the molad components' do
        subject.set_jewish_date(*new_date.split('-').map(&:to_i).concat([4, 5, 6]))
        expect(subject.molad_hours).to eq 4
        expect(subject.molad_minutes).to eq 5
        expect(subject.molad_chalakim).to eq 6
      end
    end
  end
  describe '#forward!' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(*initial_date) }
    let(:initial_date){ [Date.parse(secular_dates[:modern])]}
    it 'moves the date forward 1 day' do
      subject.forward!
      expect_date_mappings(subject, offset_days(secular_dates[:modern], 1), offset_days(jewish_dates[:modern], 1))
    end
    context 'with a number' do
      context 'within the same month' do
        let(:initial_date){ [5778, 10, 15] }
        it 'increments that amount' do
          initial = subject.gregorian_date
          subject.forward!(5)
          expect(subject.gregorian_date).to eq initial + 5
          expect_jewish_date(subject, 5778, 10, 20)
          expect(subject.day_of_week).to eq(((initial + 5).cwday % 7) + 1)
        end
      end
      context 'into the next month' do
        let(:initial_date){ [5778, 10, 28] }
        it 'increments that amount' do
          initial = subject.gregorian_date
          subject.forward!(5)
          expect(subject.gregorian_date).to eq initial + 5
          expect_jewish_date(subject, 5778, 11, 4)
        end
      end
      context 'into the next year' do
        let(:initial_date){ [5778, 6, 28] }
        it 'increments that amount' do
          initial = subject.gregorian_date
          subject.forward!(5)
          expect(subject.gregorian_date).to eq initial + 5
          expect_jewish_date(subject, 5779, 7, 4)
        end
      end
    end
  end
  describe '#back!' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(*initial_date) }
    let(:initial_date){ [Date.parse(secular_dates[:modern])]}
    it 'moves the date backward 1 day' do
      subject.back!
      expect_date_mappings(subject, offset_days(secular_dates[:modern], -1), offset_days(jewish_dates[:modern], -1))
    end
    context 'with a number' do
      context 'within the same month' do
        let(:initial_date){ [5778, 10, 15] }
        it 'decrements that amount' do
          initial = subject.gregorian_date
          subject.back!(5)
          expect(subject.gregorian_date).to eq initial - 5
          expect_jewish_date(subject, 5778, 10, 10)
          expect(subject.day_of_week).to eq(((initial - 5).cwday % 7) + 1)
        end
      end
      context 'into the previous month' do
        let(:initial_date){ [5778, 11, 4] }
        it 'decrements that amount' do
          initial = subject.gregorian_date
          subject.back!(5)
          expect(subject.gregorian_date).to eq initial - 5
          expect_jewish_date(subject, 5778, 10, 28)
        end
      end
      context 'into the previous year' do
        let(:initial_date){ [5779, 7, 4] }
        it 'decrements that amount' do
          initial = subject.gregorian_date
          subject.back!(5)
          expect(subject.gregorian_date).to eq initial - 5
          expect_jewish_date(subject, 5778, 6, 28)
        end
      end
    end
  end
  describe '#addition' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(*initial_date) }
    let(:initial_date){ [Date.parse(secular_dates[:modern])]}
    it 'returns a new date incremented by the given amount of days' do
      result = subject + 5
      expect_date_mappings(result, offset_days(secular_dates[:modern], 5), offset_days(jewish_dates[:modern], 5))
      expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
    end
    context 'with a negative number' do
      it 'returns a new date decremented by the given amount of days' do
        result = subject + (-5)
        expect_date_mappings(result, offset_days(secular_dates[:modern], -5), offset_days(jewish_dates[:modern], -5))
        expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
      end
    end
  end

  describe '#subtraction' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(*initial_date) }
    let(:initial_date){ [Date.parse(secular_dates[:modern])]}
    context 'with a numeric subtrahend' do
      it 'returns a new date decremented by the given amount of days' do
        result = subject - 5
        expect_date_mappings(result, offset_days(secular_dates[:modern], -5), offset_days(jewish_dates[:modern], -5))
        expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
      end
      context 'with a negative number' do
        it 'returns a new date incremented by the given amount of days' do
          result = subject - (-5)
          expect_date_mappings(result, offset_days(secular_dates[:modern], 5), offset_days(jewish_dates[:modern], 5))
          expect_date_mappings(subject, secular_dates[:modern], jewish_dates[:modern])
        end
      end
    end
    context 'with a jewish date subtrahend' do
      it 'returns the integer difference between the dates' do
        second_date = subject - 10
        expect(subject - second_date).to eq 10
      end
    end
    context 'with a standard date subtrahend' do
      it 'returns the integer difference between the dates' do
        second_date = subject.gregorian_date - 10
        expect(subject - second_date).to eq 10
      end
    end
  end

  describe '#comparable' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(*initial_date) }
    let(:initial_date){ [Date.parse(secular_dates[:modern])]}
    context 'when compared with a jewish date' do
      it 'should be comparable' do
        second_date = subject - 10
        expect(subject > second_date).to eq true
        expect(subject < second_date).to eq false
        expect(subject == second_date).to eq false
      end
    end
    context 'when compared with a standard date' do
      it 'should be comparable' do
        second_date = subject.gregorian_date - 10
        expect(subject > second_date).to eq true
        expect(subject < second_date).to eq false
        expect(subject == second_date).to eq false
      end
    end
    context 'when compared with both types of dates' do
      it 'should be comparable' do
        second_date = subject - 10
        third_date = subject.gregorian_date + 20
        expect(subject.between?(second_date, third_date)).to eq true
      end
    end
  end

  ### Gregorian date operations
  describe '#gregorian_year=' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(Date.parse('2017-06-07')) }
    it 'changes the current gregorian year' do
      subject.gregorian_year = 2016
      expect_gregorian_date(subject, 2016, 6, 7)
    end
    it 'recalculates the expected jewish date' do
      subject.gregorian_year = 2016
      expect_jewish_date(subject, 5776, 3, 1)
    end
  end
  describe '#gregorian_month=' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(Date.parse('2017-06-07')) }
    it 'changes the current gregorian month' do
      subject.gregorian_month = 10
      expect_gregorian_date(subject, 2017, 10, 7)
    end
    it 'recalculates the expected jewish date' do
      subject.gregorian_month = 10
      expect_jewish_date(subject, 5778, 7, 17)
    end
  end
  describe '#gregorian_day=' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(Date.parse('2017-06-07')) }
    it 'changes the current gregorian day' do
      subject.gregorian_day = 30
      expect_gregorian_date(subject, 2017, 6, 30)
    end
    it 'recalculates the expected jewish date' do
      subject.gregorian_day = 30
      expect_jewish_date(subject, 5777, 4, 6)
    end
  end
  describe '#days_in_gregorian_year' do
    let(:standard_year){ 2010 }
    let(:leap_year){ 2012 }
    it 'calculates leap years correctly' do
      expect(subject.days_in_gregorian_year(leap_year)).to eq 366
    end
    it 'calculates standard years correctly' do
      expect(subject.days_in_gregorian_year(standard_year)).to eq 365
    end
    it 'defaults to the current gregorian year' do
      subject.gregorian_year = standard_year
      expect(subject.days_in_gregorian_year).to eq 365
      subject.gregorian_year = leap_year
      expect(subject.days_in_gregorian_year).to eq 366
    end
  end
  describe '#days_in_gregorian_month' do
    let(:standard_year){ 2010 }
    let(:leap_year){ 2012 }
    let(:long_months){ [1, 3, 5, 7, 8, 10, 12]}
    let(:short_months){ [4, 6, 9, 11] }
    it 'calculates unchanging long months correctly' do
      expect(long_months.map{|m| subject.days_in_gregorian_month(m, standard_year) }.uniq).to eq [31]
    end
    it 'calculates unchanging short months correctly' do
      expect(short_months.map{|m| subject.days_in_gregorian_month(m, standard_year) }.uniq).to eq [30]
    end
    it 'calculates standard february correctly' do
      expect(subject.days_in_gregorian_month(2, standard_year)).to eq 28
    end
    it 'calculates leap year february correctly' do
      expect(subject.days_in_gregorian_month(2, leap_year)).to eq 29
    end
    it 'defaults to the current gregorian month and year' do
      subject.date = Date.parse('2013-04-16')
      expect(subject.days_in_gregorian_month).to eq 30
      subject.date = Date.parse('2013-05-16')
      expect(subject.days_in_gregorian_month).to eq 31
    end
  end
  describe '#gregorian_leap_year?' do
    let(:standard_year){ 2010 }
    let(:leap_year){ 2012 }
    let(:gregorian_century){ 1900 }
    let(:gregorian_century_exception){ 2000 }
    it 'calculates standard years correctly' do
      expect(subject.gregorian_leap_year?(standard_year)).to eq false
    end
    it 'calculates leap years correctly' do
      expect(subject.gregorian_leap_year?(leap_year)).to eq true
    end
    it 'calculates century years correctly' do
      expect(subject.gregorian_leap_year?(gregorian_century)).to eq false
    end
    it 'calculates special case century years correctly' do
      expect(subject.gregorian_leap_year?(gregorian_century_exception)).to eq true
    end
    it 'defaults to the current gregorian year' do
      subject.gregorian_year = standard_year
      expect(subject.gregorian_leap_year?).to eq false
      subject.gregorian_year = leap_year
      expect(subject.gregorian_leap_year?).to eq true
    end
  end

  ### Jewish date operations
  describe '#jewish_year=' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(5777, 3, 13) }
    it 'changes the current jewish year' do
      subject.jewish_year = 5776
      expect_jewish_date(subject, 5776, 3, 13)
    end
    it 'recalculates the expected gregorian date' do
      subject.jewish_year = 5776
      expect_gregorian_date(subject, 2016, 6, 19)
    end
  end
  describe '#jewish_month=' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(5777, 3, 13) }
    it 'changes the current jewish month' do
      subject.jewish_month = 7
      expect_jewish_date(subject, 5777, 7, 13)
    end
    it 'recalculates the expected gregorian date' do
      subject.jewish_month = 7
      expect_gregorian_date(subject, 2016, 10, 15)
    end
  end
  describe '#jewish_day=' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new(5777, 3, 13) }
    it 'changes the current jewish day' do
      subject.jewish_day = 6
      expect_jewish_date(subject, 5777, 3, 6)
    end
    it 'recalculates the expected gregorian date' do
      subject.jewish_day = 6
      expect_gregorian_date(subject, 2017, 5, 31)
    end
  end
  describe '#days_in_jewish_year' do
    let(:test_years){
      [standard_year_chaseir, standard_year_kesidran, standard_year_shaleim,
       leap_year_chaseir, leap_year_kesidran, leap_year_shaleim]
    }
    it 'calculates the various year lengths correctly' do
      expect(test_years.map{|y| subject.days_in_jewish_year(y)}).to eq [353, 354, 355, 383, 384, 385]
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_kesidran
      expect(subject.days_in_jewish_year).to eq 354
      subject.jewish_year = leap_year_shaleim
      expect(subject.days_in_jewish_year).to eq 385
    end
  end
  describe '#months_in_jewish_year' do
    it 'calculates for standard years correctly' do
      expect(subject.months_in_jewish_year(standard_year_kesidran)).to eq 12
    end
    it 'calculates for leap years correctly' do
      expect(subject.months_in_jewish_year(leap_year_kesidran)).to eq 13
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_kesidran
      expect(subject.months_in_jewish_year).to eq 12
      subject.jewish_year = leap_year_kesidran
      expect(subject.months_in_jewish_year).to eq 13
    end
  end
  describe '#sorted_months_in_jewish_year' do
    let(:leap_months){ [7, 8, 9, 10, 11, 12, 13, 1, 2, 3, 4, 5, 6]}
    let(:standard_months){ [7, 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6]}
    it 'calculates for standard years correctly' do
      expect(subject.sorted_months_in_jewish_year(standard_year_kesidran)).to eq standard_months
    end
    it 'calculates for leap years correctly' do
      expect(subject.sorted_months_in_jewish_year(leap_year_kesidran)).to eq leap_months
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_kesidran
      expect(subject.sorted_months_in_jewish_year).to eq standard_months
      subject.jewish_year = leap_year_kesidran
      expect(subject.sorted_months_in_jewish_year).to eq leap_months
    end
  end
  describe '#sorted_days_in_jewish_year' do
    let(:leap_chaseir_days){ [[7,30], [8,29], [9,29], [10,29], [11,30], [12,30], [13,29], [1,30], [2,29], [3,30], [4,29], [5,30], [6,29]]}
    let(:standard_shaleim_days){ [[7,30], [8,30], [9,30], [10,29], [11,30], [12,29], [1,30], [2,29], [3,30], [4,29], [5,30], [6,29]]}
    it 'calculates for standard years correctly' do
      expect(subject.sorted_days_in_jewish_year(standard_year_shaleim)).to eq standard_shaleim_days
    end
    it 'calculates for leap years correctly' do
      expect(subject.sorted_days_in_jewish_year(leap_year_chaseir)).to eq leap_chaseir_days
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_shaleim
      expect(subject.sorted_days_in_jewish_year).to eq standard_shaleim_days
      subject.jewish_year = leap_year_chaseir
      expect(subject.sorted_days_in_jewish_year).to eq leap_chaseir_days
    end
  end
  describe '#days_in_jewish_month' do
    let(:test_years){
      [standard_year_chaseir, standard_year_kesidran, standard_year_shaleim,
       leap_year_chaseir, leap_year_kesidran, leap_year_shaleim]
    }
    let(:standard_chaseir_months){ [30,29,30,29,30,29,30,29,29,29,30,29] }
    let(:standard_kesidran_months){ [30,29,30,29,30,29,30,29,30,29,30,29] }
    let(:standard_shaleim_months){ [30,29,30,29,30,29,30,30,30,29,30,29] }
    let(:leap_chaseir_months){ [30,29,30,29,30,29,30,29,29,29,30,30,29] }
    let(:leap_kesidran_months){ [30,29,30,29,30,29,30,29,30,29,30,30,29] }
    let(:leap_shaleim_months){ [30,29,30,29,30,29,30,30,30,29,30,30,29] }
    let(:expected_days){
      [standard_chaseir_months, standard_kesidran_months, standard_shaleim_months,
       leap_chaseir_months, leap_kesidran_months, leap_shaleim_months]
    }
    it 'calculates the correct days for the various year types' do
      expect(test_years.map { |y|
        (1..subject.months_in_jewish_year(y)).map{|m| subject.days_in_jewish_month(m, y)}
      }).to eq expected_days
    end
    it 'defaults to the current jewish year and month' do
      subject.set_jewish_date(5777, 9, 1)
      expect(subject.days_in_jewish_month).to eq 29
      subject.jewish_year = 5778
      expect(subject.days_in_jewish_month).to eq 30
    end
  end
  describe '#day_number_of_jewish_year' do
    let(:dates){ ['5778-07-01', '5778-01-01', '5778-06-29', '5779-13-29', '5777-10-01']}
    let(:expected){ [1, 178, 354, 208, 89]}
    it 'calculates correctly' do
      expect(dates.map{|d|
        year, month, day = d.split('-').map(&:to_i)
        subject.day_number_of_jewish_year(year, month, day)
      }).to eq expected
    end
    it 'defaults to the current jewish date' do
      subject.set_jewish_date(5770, 9, 1)
      expect(subject.day_number_of_jewish_year).to eq 61
      subject.set_jewish_date(5770, 10, 1)
      expect(subject.day_number_of_jewish_year).to eq 91
    end
  end
  describe '#jewish_leap_year?' do
    subject{ Zmanim::HebrewCalendar::JewishDate.new }
    it 'calculates standard years correctly' do
      expect(subject.jewish_leap_year?(standard_year_chaseir)).to eq false
    end
    it 'calculates leap years correctly' do
      expect(subject.jewish_leap_year?(leap_year_chaseir)).to eq true
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = leap_year_chaseir
      expect(subject.jewish_leap_year?).to eq true
      subject.jewish_year = standard_year_chaseir
      expect(subject.jewish_leap_year?).to eq false
    end
  end
  describe '#cheshvan_long?' do
    it 'calculates correctly' do
      expect(subject.cheshvan_long?(standard_year_chaseir)).to eq false
      expect(subject.cheshvan_long?(standard_year_kesidran)).to eq false
      expect(subject.cheshvan_long?(standard_year_shaleim)).to eq true
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_chaseir
      expect(subject.cheshvan_long?).to eq false
      subject.jewish_year = standard_year_shaleim
      expect(subject.cheshvan_long?).to eq true
    end
  end
  describe '#cheshvan_short?' do
    it 'calculates correctly' do
      expect(subject.cheshvan_short?(standard_year_chaseir)).to eq true
      expect(subject.cheshvan_short?(standard_year_kesidran)).to eq true
      expect(subject.cheshvan_short?(standard_year_shaleim)).to eq false
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_chaseir
      expect(subject.cheshvan_short?).to eq true
      subject.jewish_year = standard_year_shaleim
      expect(subject.cheshvan_short?).to eq false
    end
  end
  describe '#kislev_long?' do
    it 'calculates correctly' do
      expect(subject.kislev_long?(standard_year_chaseir)).to eq false
      expect(subject.kislev_long?(standard_year_kesidran)).to eq true
      expect(subject.kislev_long?(standard_year_shaleim)).to eq true
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_chaseir
      expect(subject.kislev_long?).to eq false
      subject.jewish_year = standard_year_shaleim
      expect(subject.kislev_long?).to eq true
    end
  end
  describe '#kislev_short?' do
    it 'calculates correctly' do
      expect(subject.kislev_short?(standard_year_chaseir)).to eq true
      expect(subject.kislev_short?(standard_year_kesidran)).to eq false
      expect(subject.kislev_short?(standard_year_shaleim)).to eq false
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_chaseir
      expect(subject.kislev_short?).to eq true
      subject.jewish_year = standard_year_shaleim
      expect(subject.kislev_short?).to eq false
    end
  end
  describe '#cheshvan_kislev_kviah' do
    it 'calculates correctly' do
      expect(subject.cheshvan_kislev_kviah(standard_year_chaseir)).to eq :chaseirim
      expect(subject.cheshvan_kislev_kviah(standard_year_kesidran)).to eq :kesidran
      expect(subject.cheshvan_kislev_kviah(standard_year_shaleim)).to eq :shelaimim
      expect(subject.cheshvan_kislev_kviah(leap_year_chaseir)).to eq :chaseirim
      expect(subject.cheshvan_kislev_kviah(leap_year_kesidran)).to eq :kesidran
      expect(subject.cheshvan_kislev_kviah(leap_year_shaleim)).to eq :shelaimim
    end
    it 'defaults to the current jewish year' do
      subject.jewish_year = standard_year_chaseir
      expect(subject.cheshvan_kislev_kviah).to eq :chaseirim
      subject.jewish_year = standard_year_shaleim
      expect(subject.cheshvan_kislev_kviah).to eq :shelaimim
    end
  end
  describe '#molad' do
    it 'returns the correct molad for the given year and month' do
      molad = subject.molad(5, 5778)
      expect_jewish_date(molad, 5778, 5, 1)
      expect([molad.molad_hours, molad.molad_minutes, molad.molad_chalakim]).to eq [6, 49, 8]
    end
    it 'defaults to the current jewish year and month' do
      subject.set_jewish_date(5778, 5, 1)
      molad = subject.molad
      expect_jewish_date(molad, 5778, 5, 1)
      expect([molad.molad_hours, molad.molad_minutes, molad.molad_chalakim]).to eq [6, 49, 8]
    end
  end
  describe '#jewish_month_from_name' do
    it 'converts as expected' do
      months = Zmanim::HebrewCalendar::JewishDate::MONTHS
      expect(months.map{|m| subject.jewish_month_from_name(m)}).to eq (1..13).to_a
    end
  end
  describe '#jewish_month_name' do
    it 'converts as expected' do
      expect(subject.jewish_month_name(3)).to eq :sivan
      expect(subject.jewish_month_name(8)).to eq :cheshvan
      expect(subject.jewish_month_name(15)).to eq nil
    end
    it 'defaults to the current jewish month' do
      subject.jewish_month = 3
      expect(subject.jewish_month_name).to eq :sivan
    end
  end
end
