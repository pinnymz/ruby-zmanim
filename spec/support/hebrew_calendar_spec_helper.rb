module Zmanim
  module HebrewCalendarSpecHelper
    SECULAR_DATES = {
        modern: '2017-10-26',
        pre_gregorian: '1550-10-01',
        bce: '-0100-05-05'
    }

    ABSOLUTE_DATES = {
        modern: 736628,
        pre_gregorian: 566044,
        bce: -36741
    }

    JEWISH_DATES = {
        modern: '5778-08-06',
        pre_gregorian: '5311-07-11',
        bce: '3660-02-19'
    }

    def expect_gregorian_date(actual, *expected)
      expected = %i(year month day).map(&expected.first.method(:send)) if expected.first.respond_to?(:year)
      expect([actual.gregorian_year, actual.gregorian_month, actual.gregorian_day]).to eq expected
    end

    def expect_jewish_date(actual, *expected)
      expect([actual.jewish_year, actual.jewish_month, actual.jewish_day]).to eq expected
    end

    def expect_date_mappings(subject, gregorian, jewish)
      actual_gregorian = [subject.gregorian_year, subject.gregorian_month, subject.gregorian_day]
      actual_jewish = [subject.jewish_year, subject.jewish_month, subject.jewish_day]
      actual = [actual_gregorian, actual_jewish].map{|d| format_as_iso8601(*d)}
      expect(actual).to eq [gregorian, jewish]
    end

    def offset_days(date_string, offset)
      if date_string[0] == '-'
        negative = true
        date_string = date_string[1..-1]
      end
      year, month, day = date_string.split('-').map(&:to_i)
      year = -year if negative
      format_as_iso8601(year, month, day + offset)
    end

    def format_as_iso8601(year, month, day)
      "#{("%0+5i" % year).delete('+')}-#{"%02i" % month}-#{"%02i" % day}"
    end

    def days_matching(collection, days)
      collection.select{|k,v| days.include?(k)}
    end

    def all_days_matching(year, matcher, in_israel: false, use_modern_holidays: false)
      calendar = Zmanim::HebrewCalendar::JewishCalendar.new(year, 7, 1)
      calendar.in_israel = in_israel
      calendar.use_modern_holidays = use_modern_holidays
      (1..calendar.days_in_jewish_year).each_with_object({}) do |day_offset, m|
        if sd = matcher.call(calendar)
          m[sd] ||= []
          m[sd] << "#{calendar.jewish_month}-#{calendar.jewish_day}"
        end
        calendar.forward!
      end
    end

    { standard_monday_chaseir:    5777,
      standard_monday_shaleim:    5759,
      standard_tuesday_kesidran:  5762,
      standard_thursday_kesidran: 5778,
      standard_thursday_shaleim:  5754,
      standard_shabbos_chaseir:   5781,
      standard_shabbos_shaleim:   5770,
      leap_monday_chaseir:        5749,
      leap_monday_shaleim:        5776,
      leap_tuesday_kesidran:      5755,
      leap_thursday_chaseir:      5765,
      leap_thursday_shaleim:      5774,
      leap_shabbos_chaseir:       5757,
      leap_shabbos_shaleim:       5763,
    }.each do |k,v|
      define_method(k){ v }
    end
  end
end

RSpec.shared_examples "annual_significant_event" do |event_name, earlier_increment, later_increment|
  it_behaves_like("annual_event", event_name, earlier_increment, later_increment) do
    let(:test_block){ ->(result){ result.significant_day == event_name.to_sym } }
  end
end

RSpec.shared_examples "annual_event" do |event_name, earlier_increment, later_increment|
  let(:sample_year){ target_date.jewish_year }
  let(:earlier_date){ target_date - earlier_increment }
  let(:later_date){ target_date + later_increment }
  context 'for a given year' do
    it "returns #{event_name} for that year" do
      result = earlier_date.public_send(event_name, year: sample_year + 5)
      expect(result.jewish_year).to eq(sample_year + 5)
      expect(test_block.(result)).to be_truthy
    end
  end
  context 'with no year' do
    it "returns #{event_name} for the current year" do
      result = earlier_date.public_send(event_name)
      expect(result.jewish_year).to eq(sample_year)
      expect(test_block.(result)).to be_truthy
    end
  end
  context 'with upcoming as true' do
    context 'for an earlier date' do
      it "returns #{event_name} for the current year" do
        result = earlier_date.public_send(event_name, upcoming: true)
        expect(result.jewish_year).to eq(sample_year)
        expect(test_block.(result)).to be_truthy
      end
    end
    context "for the date of #{event_name}" do
      it "returns the date itself" do
        result = target_date.public_send(event_name, upcoming: true)
        expect(result).to eq(target_date)
        expect(test_block.(result)).to be_truthy
      end
    end
    context 'for a later date' do
      it "returns #{event_name} for the next year" do
        result = later_date.public_send(event_name, upcoming: true)
        expect(result.jewish_year).to eq(sample_year + 1)
        expect(test_block.(result)).to be_truthy
      end
    end
  end
end
