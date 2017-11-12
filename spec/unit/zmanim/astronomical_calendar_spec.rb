require 'spec_helper'

describe Zmanim::AstronomicalCalendar, astro_calendar: true do
  describe '#sunrise' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sunrise }
      expected = ["2017-10-17T07:09:11-04:00",
                  "2017-10-17T06:39:32+03:00",
                  "2017-10-17T07:00:25-07:00",
                  "2017-10-17T05:48:20+09:00",
                  nil,
                  "2017-10-17T06:54:18+14:00"]
      expect_datetime_to_match(method, expected)
    end
  end
  describe '#sunset' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sunset }
      expected = ["2017-10-17T18:14:38-04:00",
                  "2017-10-17T18:08:46+03:00",
                  "2017-10-17T18:19:05-07:00",
                  "2017-10-17T17:04:46+09:00",
                  nil,
                  "2017-10-17T19:31:07+14:00"]
      expect_datetime_to_match(method, expected)
    end
  end
  describe '#sea_level_sunrise' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sea_level_sunrise }
      expected = ["2017-10-17T07:09:51-04:00",
                  "2017-10-17T06:43:43+03:00",
                  "2017-10-17T07:01:45-07:00",
                  "2017-10-17T05:49:21+09:00",
                  nil,
                  "2017-10-17T07:00:05+14:00"]
      expect_datetime_to_match(method, expected)
    end
  end
  describe '#sea_level_sunset' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sea_level_sunset }
      expected = ["2017-10-17T18:13:58-04:00",
                  "2017-10-17T18:04:36+03:00",
                  "2017-10-17T18:17:45-07:00",
                  "2017-10-17T17:03:45+09:00",
                  nil,
                  "2017-10-17T19:25:19+14:00"]
      expect_datetime_to_match(method, expected)
    end
  end
  describe '#utc_sunrise' do
    it 'calculates as expected' do
      method = -> (subject){ subject.utc_sunrise(90) }
      expected = [11.15327065, 3.65893934, 14.00708152, 20.8057012, nil, 16.90510688]
      expect_time_to_match(method, expected)
    end
  end
  describe '#utc_sunset' do
    it 'calculates as expected' do
      method = -> (subject){ subject.utc_sunset(90) }
      expected = [22.24410903, 15.14635336, 1.31819979, 8.07962871, nil, 5.51873532]
      expect_time_to_match(method, expected)
    end
  end
  describe '#utc_sea_level_sunrise' do
    it 'calculates as expected' do
      method = -> (subject){ subject.utc_sea_level_sunrise(90) }
      expected = [11.16434723, 3.72862262, 14.02926518, 20.82268461, nil, 17.00158411]
      expect_time_to_match(method, expected)
    end
  end
  describe '#utc_sea_level_sunset' do
    it 'calculates as expected' do
      method = -> (subject){ subject.utc_sea_level_sunset(90) }
      expected = [22.23304301, 15.07671429, 1.29603174, 8.06265871, nil, 5.42214918]
      expect_time_to_match(method, expected)
    end
  end
  describe '#sunrise_offset_by_degrees' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sunrise_offset_by_degrees(102) }
      expected = ["2017-10-17T06:10:57-04:00",
                  "2017-10-17T05:50:43+03:00",
                  "2017-10-17T06:07:22-07:00",
                  "2017-10-17T04:53:55+09:00",
                  "2017-10-17T04:47:28-04:00",
                  "2017-10-17T06:13:13+14:00"]
      expect_datetime_to_match(method, expected)
    end
    context 'for arctic regions in time zone extremities' do
      let(:date){ Date.parse('2017-04-20') }
      let(:geo){ Zmanim::AstroCalendarSpecHelper::DANEBORG }
      subject{ astro_calendar_for(date, geo) }
      it 'calculates the date as wrapping into the prior day' do
        expect(subject.sunrise_offset_by_degrees(94).to_s).to eq "2017-04-19T23:54:23-02:00"
      end
    end
  end
  describe '#sunset_offset_by_degrees' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sunset_offset_by_degrees(102) }
      expected = ["2017-10-17T19:12:49-04:00",
                  "2017-10-17T18:57:33+03:00",
                  "2017-10-17T19:12:05-07:00",
                  "2017-10-17T17:59:08+09:00",
                  "2017-10-17T19:15:04-04:00",
                  "2017-10-17T20:12:15+14:00"]
      expect_datetime_to_match(method, expected)
    end
    context 'for arctic regions in time zone extremities' do
      let(:date){ Date.parse('2017-06-21') }
      let(:geo){ Zmanim::AstroCalendarSpecHelper::HOOPER_BAY }
      subject{ astro_calendar_for(date, geo) }
      it 'calculates the date as wrapping into the next day' do
        expect(subject.sunset_offset_by_degrees(94).to_s).to eq "2017-06-22T02:00:16-08:00"
      end
    end
  end
  describe '#temporal_hour' do
    it 'calculates as expected' do
      method = ->(subject){ subject.temporal_hour&./ Zmanim::AstronomicalCalendar::HOUR_MILLIS }
      expected = [0.92239132, 0.94567431, 0.93889721, 0.93666451, nil, 1.03504709]
      expect_time_to_match(method, expected)
    end
  end
  describe '#sun_transit' do
    it 'calculates as expected' do
      method = ->(subject){ subject.sun_transit }
      expected = ["2017-10-17T12:41:55-04:00",
                  "2017-10-17T12:24:09+03:00",
                  "2017-10-17T12:39:45-07:00",
                  "2017-10-17T11:26:33+09:00",
                  nil,
                  "2017-10-17T13:12:42+14:00"]
      expect_datetime_to_match(method, expected)
    end
  end
end
