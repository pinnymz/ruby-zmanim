require 'spec_helper'

describe Zmanim::Util::NOAACalculator do
  subject{ Zmanim::Util::NOAACalculator.new }
  describe 'utc_sunrise' do
    let(:expected){ {
        ['2017-10-17', 41.1181036, -74.0840691, 167] => 11.13543634,
        ['2017-10-17', 34.0201613,-118.6919095, 71] => 14.00708152,  # 14.007081524682999
        ['1955-02-26', 31.7962994, 35.1053185, 754] => 4.11885084,
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
        ['2017-10-17', 41.1181036, -74.0840691, 167] => 22.24078702,
        ['1955-02-26', 31.7962994, 35.1053185, 754] => 15.64531391,
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



