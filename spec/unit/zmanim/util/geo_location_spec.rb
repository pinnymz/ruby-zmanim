require 'spec_helper'

describe Zmanim::Util::GeoLocation do
  describe '.GMT' do
    it 'returns the GMT geolocation' do
      geo = Zmanim::Util::GeoLocation.GMT
      expect(geo.location_name).to eq "Greenwich, England"
      expect(geo.latitude).to eq  51.4772
      expect(geo.longitude).to eq 0
      expect(geo.time_zone.name).to eq 'GMT'
      expect(geo.elevation).to eq 0
    end
  end

  describe '#latitude=' do
    subject{ Zmanim::Util::GeoLocation.GMT }
    context 'passing a single value' do
      it 'assigns the value' do
        subject.latitude = 35.4
        expect(subject.latitude).to eq 35.4
      end
    end
    context 'passing cartography' do
      context 'for North values' do
        it 'assigns the expected value' do
          subject.latitude = [41, 7, 5.17296, 'N']
          expect(subject.latitude).to eq 41.1181036
        end
      end
      context 'for South values' do
        it 'assigns the expected value' do
          subject.latitude = [41, 7, 5.17296, 'S']
          expect(subject.latitude).to eq -41.1181036
        end
      end
    end
  end

  describe '#longitude=' do
    subject{ Zmanim::Util::GeoLocation.GMT }
    context 'passing a single value' do
      it 'assigns the value' do
        subject.longitude = 35.4
        expect(subject.longitude).to eq 35.4
      end
    end
    context 'passing cartography' do
      context 'for East values' do
        it 'assigns the expected value' do
          subject.longitude = [74, 5, 2.6484, 'E']
          expect(subject.longitude).to eq 74.084069
        end
      end
      context 'for West values' do
        it 'assigns the expected value' do
          subject.longitude = [74, 5, 2.6484, 'W']
          expect(subject.longitude).to eq -74.084069
        end
      end
    end
  end

  describe '#antimeridian_adjustment' do
    context 'for GMT' do
      subject{ Zmanim::Util::GeoLocation.GMT }
      it 'should be 0' do
        expect(subject.antimeridian_adjustment).to eq 0
      end
    end
    context 'for an arbitrary time zone and longitude' do
      subject{ Zmanim::AstroCalendarSpecHelper::LAKEWOOD }
      it 'should be 0' do
        expect(subject.antimeridian_adjustment).to eq 0
      end
    end
    context 'for a location whose time zone crosses the antimeridian to the east' do
      subject{ Zmanim::AstroCalendarSpecHelper::SAMOA }
      it 'should adjust backward' do
        expect(subject.antimeridian_adjustment).to eq -1
      end
    end
    context 'for a location whose time zone crosses the antimeridian to the west' do
      # This doesn't exist today geographically, but we can conceive of such a case:
      subject{ Zmanim::Util::GeoLocation.GMT.tap do |geo|
        geo.longitude = 179            # Eastern longitude
        geo.time_zone = 'Etc/GMT+12'   # UTC offset of -12
      end }
      it 'should adjust forward' do
        expect(subject.antimeridian_adjustment).to eq 1
      end
    end
  end

  describe '#local_meridian_offset' do
    subject{ Zmanim::Util::GeoLocation.GMT }
    context 'for GMT' do
      it 'should be 0' do
        expect(subject.local_meridian_offset).to eq 0
      end
    end
    context 'for an eastern longitude around the time zone center' do
      it 'should match the expected offset' do
        subject.longitude = 75
        expect(subject.local_meridian_offset).to eq 5
      end
    end
    context 'for a western longitude around the time zone center' do
      it 'should match the expected offset' do
        subject.longitude = -75
        expect(subject.local_meridian_offset).to eq -5
      end
    end
    context 'for an eastern longitude close to the time zone edge' do
      it 'should match the expected offset' do
        subject.longitude = 112.49
        expect(subject.local_meridian_offset).to eq 7
      end
    end
    context 'for a western longitude close to the time zone edge' do
      it 'should match the expected offset' do
        subject.longitude = -112.51
        expect(subject.local_meridian_offset).to eq -8
      end
    end
    context 'for an eastern longitude at the time zone edge' do
      it 'should round up' do
        subject.longitude = 112.5
        expect(subject.local_meridian_offset).to eq 8
      end
    end
    context 'for a western longitude at the time zone edge' do
      it 'should round up' do
        subject.longitude = -112.5
        expect(subject.local_meridian_offset).to eq -7
      end
    end
  end

  describe '#local_mean_time_offset' do
    subject{ Zmanim::Util::GeoLocation.GMT }
    context 'for GMT' do
      it 'should be 0' do
        expect(subject.local_mean_time_offset).to eq 0
      end
    end
    context 'for an arbitrary timezone' do
      it 'should match the timezone offset' do
        subject.time_zone = 'US/Eastern'
        expect(subject.local_mean_time_offset).to eq (-5 * Zmanim::AstronomicalCalendar::HOUR_MILLIS)
      end
    end
  end

  describe '#local_time_offset_at' do
    context 'for several given scenarios' do
      let(:expected){{
          ['2017-03-12T06:30:00Z', 'US/Eastern'] => -5,
          ['2017-03-12T07:00:00Z', 'US/Eastern'] => -4,
          ['2017-03-12T09:30:00Z', 'US/Pacific'] => -8,
          ['2017-03-12T10:00:00Z', 'US/Pacific'] => -7,
          ['2017-03-23T23:30:00Z', 'Asia/Jerusalem'] => 2,
          ['2017-03-24T00:00:00Z', 'Asia/Jerusalem'] => 3,

      }}
      it 'matches the expected offsets' do
        results = expected.keys.reduce({}) do |memo, key|
          utc, zone = *key
          geo = Zmanim::Util::GeoLocation.GMT
          geo.time_zone = zone
          memo[key] = geo.local_time_offset_at(Time.parse(utc)) / Zmanim::AstronomicalCalendar::HOUR_MILLIS
          memo
        end
        expect(results).to eq expected
      end
    end
  end
end
