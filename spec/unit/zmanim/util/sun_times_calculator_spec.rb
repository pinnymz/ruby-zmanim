require 'spec_helper'

describe Zmanim::Util::SunTimesCalculator do
  subject{ Zmanim::Util::SunTimesCalculator.new }
  describe 'utc_sunrise' do
    let(:expected){ {
        ['2017-10-17', 41.1181036, -74.0840691, 0.167] => 11.16276401,
        ['1955-02-26', 31.7962994, 35.1053185, 0.754] => 4.17848602,
        ['2017-06-21', 70.1498248,9.1456867, 0] => nil,
    } }
    it 'calculates for known dates to 8 decimal places' do
      results = expected.keys.reduce({}) do |memo, key|
        date, lat, lng, el = *key
        geo = Zmanim::Util::GeoLocation.new('test', lat, lng, 'US/Eastern', elevation: el)
        result = subject.utc_sunrise(Date.parse(date), geo, 90, adjust_for_elevation: true)
        memo.merge(key => (result.round(8) if result))
      end
      expect(results).to eq expected
    end
  end

  describe 'utc_sunset' do
    let(:expected){ {
        ['2017-10-17', 41.1181036, -74.0840691, 0.167] => 22.21747591,
        ['1955-02-26', 31.7962994, 35.1053185, 0.754] => 15.58295081,
        ['2017-06-21', 70.1498248,9.1456867, 0] => nil,
    } }
    it 'calculates for known dates to 8 decimal places' do
      results = expected.keys.reduce({}) do |memo, key|
        date, lat, lng, el = *key
        geo = Zmanim::Util::GeoLocation.new('test', lat, lng, 'US/Eastern', elevation: el)
        result = subject.utc_sunset(Date.parse(date), geo, 90, adjust_for_elevation: true)
        memo.merge(key => (result.round(8) if result))
      end
      expect(results).to eq expected
    end
  end
end
