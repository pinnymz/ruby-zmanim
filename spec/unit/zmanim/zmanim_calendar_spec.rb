require 'spec_helper'

describe Zmanim::ZmanimCalendar do
  subject{ Zmanim::ZmanimCalendar.new(geo_location: Zmanim::AstroCalendarSpecHelper::LAKEWOOD,
                                      date: Date.parse('2017-10-17')) }

  describe '#hanetz' do
    it 'is equivalent to sea level sunrise' do
      expect(subject.hanetz).to eq subject.sea_level_sunrise
    end
  end

  describe '#shkia' do
    it 'is equivalent to sea level sunset' do
      expect(subject.shkia).to eq subject.sea_level_sunset
    end
  end

  describe '#tzais' do
    it 'calculates correctly' do
      expect(subject.tzais.to_s).to eq "2017-10-17T18:54:29-04:00"
    end
  end
  describe '#tzais_72' do
    it 'calculates correctly' do
      expect(subject.tzais_72.to_s).to eq "2017-10-17T19:25:58-04:00"
    end
  end
  describe 'tzais with a custom degree offset' do
    it 'calculates correctly' do
      expect(subject.tzais(degrees: 19.8).to_s).to eq "2017-10-17T19:53:34-04:00"  #
    end
  end
  describe 'tzais with a custom minute offset' do
    it 'calculates correctly' do
      expect(subject.tzais(offset: 60).to_s).to eq "2017-10-17T19:13:58-04:00"  #
    end
  end
  describe 'tzais with a custom temporal minute offset' do
    it 'calculates correctly' do
      expect(subject.tzais(zmanis_offset: 90).to_s).to eq "2017-10-17T19:36:59-04:00"
    end
  end
  describe '#alos' do
    it 'calculates correctly' do
      expect(subject.alos.to_s).to eq "2017-10-17T05:49:30-04:00"
    end
  end
  describe '#alos_72' do
    it 'calculates correctly' do
      expect(subject.alos_72.to_s).to eq "2017-10-17T05:57:51-04:00"
    end
  end
  describe 'alos with a custom degree offset' do
    it 'calculates correctly' do
      expect(subject.alos(degrees: 19.8).to_s).to eq "2017-10-17T05:30:07-04:00"  #
    end
  end
  describe 'alos with a custom minute offset' do
    it 'calculates correctly' do
      expect(subject.alos(offset: 60).to_s).to eq "2017-10-17T06:09:51-04:00"
    end
  end
  describe 'alos with a custom temporal minute offset' do
    it 'calculates correctly' do
      expect(subject.alos(zmanis_offset: 90).to_s).to eq "2017-10-17T05:46:50-04:00"
    end
  end
  describe '#chatzos' do
    it 'calculates correctly' do
      expect(subject.chatzos.to_s).to eq "2017-10-17T12:41:55-04:00"
    end
  end
  describe '#sof_zman_shma' do
    let(:day_start){ subject.sunrise_offset_by_degrees(96)}
    let(:day_end){ subject.sunset_offset_by_degrees(96)}
    it 'calculates correctly' do
      expect(subject.sof_zman_shma(day_start, day_end).to_s).to eq "2017-10-17T09:42:10-04:00"
    end
  end
  describe '#sof_zman_shma_gra' do
    it 'calculates correctly' do
      expect(subject.sof_zman_shma_gra.to_s).to eq "2017-10-17T09:55:53-04:00"
    end
  end
  describe '#sof_zman_shma_mga' do
    it 'calculates correctly' do
      expect(subject.sof_zman_shma_mga.to_s).to eq "2017-10-17T09:19:53-04:00"
    end
  end
  describe '#sof_zman_tfila' do
    let(:day_start){ subject.sunrise_offset_by_degrees(96)}
    let(:day_end){ subject.sunset_offset_by_degrees(96)}
    it 'calculates correctly' do
      expect(subject.sof_zman_tfila(day_start, day_end).to_s).to eq "2017-10-17T10:42:05-04:00"
    end
  end
  describe '#sof_zman_tfila_gra' do
    it 'calculates correctly' do
      expect(subject.sof_zman_tfila_gra.to_s).to eq "2017-10-17T10:51:14-04:00"
    end
  end
  describe '#sof_zman_tfila_mga' do
    it 'calculates correctly' do
      expect(subject.sof_zman_tfila_mga.to_s).to eq "2017-10-17T10:27:14-04:00"
    end
  end
  describe '#mincha_gedola' do
    it 'calculates correctly' do
      expect(subject.mincha_gedola.to_s).to eq "2017-10-17T13:09:35-04:00"
    end
  end
  describe '#mincha_ketana' do
    it 'calculates correctly' do
      expect(subject.mincha_ketana.to_s).to eq "2017-10-17T15:55:37-04:00"
    end
  end
  describe '#plag_hamincha' do
    it 'calculates correctly' do
      expect(subject.plag_hamincha.to_s).to eq "2017-10-17T17:04:48-04:00"
    end
  end
  describe '#candle_lighting' do
    it 'calculates correctly' do
      expect(subject.candle_lighting.to_s).to eq "2017-10-17T17:55:58-04:00"
    end
  end
  describe '#shaah_zmanis' do
    let(:day_start){ subject.sunrise_offset_by_degrees(96)}
    let(:day_end){ subject.sunset_offset_by_degrees(96)}
    it 'calculates correctly' do
      expect(subject.shaah_zmanis(day_start, day_end).to_i).to eq 3594499
    end
  end
  describe '#shaah_zmanis_gra' do
    it 'calculates correctly' do
      expect(subject.shaah_zmanis_gra.to_i).to eq 3320608
    end
  end
  describe '#shaah_zmanis_mga' do
    it 'calculates correctly' do
      expect(subject.shaah_zmanis_mga.to_i).to eq 4040608
    end
  end
  describe '#shaah_zmanis_by_degrees_and_offset' do
    context 'with degrees' do
      it 'calculates correctly' do
        expect(subject.shaah_zmanis_by_degrees_and_offset(6,0).to_i).to eq 3594499
      end
    end
    context 'with offset' do
      it 'calculates correctly' do
        expect(subject.shaah_zmanis_by_degrees_and_offset(0,72).to_i).to eq 4040608
      end
    end
    context 'with both degrees and offset' do
      it 'calculates correctly' do
        expect(subject.shaah_zmanis_by_degrees_and_offset(6,72).to_i).to eq 4314499
      end
    end
  end
  context 'with use_elevation enabled' do
    before { subject.use_elevation = true }
    describe '#hanetz' do
      it 'is equivalent to sunrise at elevation' do
        expect(subject.hanetz).to eq subject.sunrise
      end
    end
    describe '#shkia' do
      it 'is equivalent to sunset at elevation' do
        expect(subject.shkia).to eq subject.sunset
      end
    end
    describe '#tzais' do
      it 'calculates correctly' do
        expect(subject.tzais.to_s).to eq "2017-10-17T18:54:29-04:00"
      end
    end
    describe '#tzais_72' do
      it 'calculates correctly' do
        expect(subject.tzais_72.to_s).to eq "2017-10-17T19:26:38-04:00"
      end
    end
    describe 'tzais with a custom degree offset' do
      it 'calculates correctly' do
        expect(subject.tzais(degrees: 19.8).to_s).to eq "2017-10-17T19:53:34-04:00"  #
      end
    end
    describe 'tzais with a custom minute offset' do
      it 'calculates correctly' do
        expect(subject.tzais(offset: 60).to_s).to eq "2017-10-17T19:14:38-04:00"  #
      end
    end
    describe 'tzais with a custom temporal minute offset' do
      it 'calculates correctly' do
        expect(subject.tzais(zmanis_offset: 90).to_s).to eq "2017-10-17T19:37:49-04:00"
      end
    end
    describe '#alos' do
      it 'calculates correctly' do
        expect(subject.alos.to_s).to eq "2017-10-17T05:49:30-04:00"
      end
    end
    describe '#alos_72' do
      it 'calculates correctly' do
        expect(subject.alos_72.to_s).to eq "2017-10-17T05:57:11-04:00"
      end
    end
    describe 'alos with a custom degree offset' do
      it 'calculates correctly' do
        expect(subject.alos(degrees: 19.8).to_s).to eq "2017-10-17T05:30:07-04:00"  #
      end
    end
    describe 'alos with a custom minute offset' do
      it 'calculates correctly' do
        expect(subject.alos(offset: 60).to_s).to eq "2017-10-17T06:09:11-04:00"
      end
    end
    describe 'alos with a custom temporal minute offset' do
      it 'calculates correctly' do
        expect(subject.alos(zmanis_offset: 90).to_s).to eq "2017-10-17T05:46:00-04:00"
      end
    end
    describe '#chatzos' do
      it 'calculates correctly' do
        expect(subject.chatzos.to_s).to eq "2017-10-17T12:41:55-04:00"
      end
    end
    describe '#sof_zman_shma' do
      let(:day_start){ subject.sunrise_offset_by_degrees(96)}
      let(:day_end){ subject.sunset_offset_by_degrees(96)}
      it 'calculates correctly' do
        expect(subject.sof_zman_shma(day_start, day_end).to_s).to eq "2017-10-17T09:42:10-04:00"
      end
    end
    describe '#sof_zman_shma_gra' do
      it 'calculates correctly' do
        expect(subject.sof_zman_shma_gra.to_s).to eq "2017-10-17T09:55:33-04:00"
      end
    end
    describe '#sof_zman_shma_mga' do
      it 'calculates correctly' do
        expect(subject.sof_zman_shma_mga.to_s).to eq "2017-10-17T09:19:33-04:00"
      end
    end
    describe '#sof_zman_tfila' do
      let(:day_start){ subject.sunrise_offset_by_degrees(96)}
      let(:day_end){ subject.sunset_offset_by_degrees(96)}
      it 'calculates correctly' do
        expect(subject.sof_zman_tfila(day_start, day_end).to_s).to eq "2017-10-17T10:42:05-04:00"
      end
    end
    describe '#sof_zman_tfila_gra' do
      it 'calculates correctly' do
        expect(subject.sof_zman_tfila_gra.to_s).to eq "2017-10-17T10:51:00-04:00"
      end
    end
    describe '#sof_zman_tfila_mga' do
      it 'calculates correctly' do
        expect(subject.sof_zman_tfila_mga.to_s).to eq "2017-10-17T10:27:00-04:00"
      end
    end
    describe '#mincha_gedola' do
      it 'calculates correctly' do
        expect(subject.mincha_gedola.to_s).to eq "2017-10-17T13:09:38-04:00"
      end
    end
    describe '#mincha_ketana' do
      it 'calculates correctly' do
        expect(subject.mincha_ketana.to_s).to eq "2017-10-17T15:56:00-04:00"
      end
    end
    describe '#plag_hamincha' do
      it 'calculates correctly' do
        expect(subject.plag_hamincha.to_s).to eq "2017-10-17T17:05:19-04:00"
      end
    end
    describe '#candle_lighting' do
      it 'calculates correctly' do
        expect(subject.candle_lighting.to_s).to eq "2017-10-17T17:55:58-04:00"
      end
    end
    describe '#shaah_zmanis' do
      let(:day_start){ subject.sunrise_offset_by_degrees(96)}
      let(:day_end){ subject.sunset_offset_by_degrees(96)}
      it 'calculates correctly' do
        expect(subject.shaah_zmanis(day_start, day_end).to_i).to eq 3594499
      end
    end
    describe '#shaah_zmanis_gra' do
      it 'calculates correctly' do
        expect(subject.shaah_zmanis_gra.to_i).to eq 3327251
      end
    end
    describe '#shaah_zmanis_mga' do
      it 'calculates correctly' do
        expect(subject.shaah_zmanis_mga.to_i).to eq 4047251
      end
    end
    describe '#shaah_zmanis_by_degrees_and_offset' do
      context 'with degrees' do
        it 'calculates correctly' do
          expect(subject.shaah_zmanis_by_degrees_and_offset(6,0).to_i).to eq 3594499
        end
      end
      context 'with offset' do
        it 'calculates correctly' do
          expect(subject.shaah_zmanis_by_degrees_and_offset(0,72).to_i).to eq 4047251
        end
      end
      context 'with both degrees and offset' do
        it 'calculates correctly' do
          expect(subject.shaah_zmanis_by_degrees_and_offset(6,72).to_i).to eq 4314499
        end
      end
    end
  end

  describe '#assur_bemelacha?' do
    before do
      subject.date = Date.parse(date)
    end
    let(:two_seconds){ 2.0 / 86400 }
    describe 'on a standard day' do
      let(:date){ "2017-10-17" }      # Tuesday
      describe 'before shkia' do
        let(:time){ subject.shkia - 2 }
        it 'calculates correctly' do
          expect(subject.assur_bemelacha?(time)).to eq false
        end
      end
      describe 'before tzais' do
        let(:time){ subject.tzais - two_seconds }
        it 'calculates correctly' do
          expect(subject.assur_bemelacha?(time)).to eq false
        end
      end
      describe 'after tzais' do
        let(:time){ subject.tzais + two_seconds }
        it 'calculates correctly' do
          expect(subject.assur_bemelacha?(time)).to eq false
        end
      end
    end
    describe 'on an issur melacha day' do
      let(:date){ "2017-10-21" }    # Shabbos
      describe 'before shkia' do
        it 'calculates correctly' do
          time = subject.shkia - two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
      describe 'before tzais' do
        it 'calculates correctly' do
          time = subject.tzais - two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
      describe 'after tzais' do
        it 'calculates correctly' do
          time = subject.tzais + two_seconds
          expect(subject.assur_bemelacha?(time)).to eq false
        end
      end
      context 'with a custom tzais time' do
        it 'respects the tzais time given' do
          tzais = subject.tzais_72
          expect(subject.assur_bemelacha?(tzais - two_seconds, tzais: tzais)).to eq true
          expect(subject.assur_bemelacha?(tzais + two_seconds, tzais: tzais)).to eq false
        end
      end
      context 'with a custom tzais rule' do
        it 'respects the tzais rule given' do
          tzais = subject.tzais(degrees: 11.5)
          expect(subject.assur_bemelacha?(tzais - two_seconds, tzais: {degrees: 11.5})).to eq true
          expect(subject.assur_bemelacha?(tzais + two_seconds, tzais: {degrees: 11.5})).to eq false
        end
      end
    end
    describe 'prior to an issur melacha day' do
      let(:date){ "2017-10-20" }      # Friday
      describe 'before shkia' do
        it 'calculates correctly' do
          time = subject.shkia - two_seconds
          expect(subject.assur_bemelacha?(time)).to eq false
        end
      end
      describe 'after shkia' do
        it 'calculates correctly' do
          time = subject.shkia + two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
      describe 'after tzais' do
        it 'calculates correctly' do
          time = subject.tzais + two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
    end
    describe 'on an issur melacha day followed by a second issur melacha day' do
      let(:date){ "2018-03-31" }      # First day of Pesach
      describe 'before shkia' do
        it 'calculates correctly' do
          time = subject.shkia - two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
      describe 'after shkia' do
        it 'calculates correctly' do
          time = subject.shkia + two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
      describe 'after tzais' do
        it 'calculates correctly' do
          time = subject.tzais + two_seconds
          expect(subject.assur_bemelacha?(time)).to eq true
        end
      end
      context 'in israel' do
        it 'considers yom tov sheni as not assur bemelacha' do
          expect(subject.assur_bemelacha?(subject.tzais - two_seconds, in_israel: true)).to eq true
          expect(subject.assur_bemelacha?(subject.tzais + two_seconds, in_israel: true)).to eq false
        end
        context 'where the following day is kept in israel' do
          let(:date){ "2018-05-19" }      # Shabbos before Shavuos
          it 'calculates as assur bemelacha' do
            expect(subject.assur_bemelacha?(subject.tzais - two_seconds, in_israel: true)).to eq true
            expect(subject.assur_bemelacha?(subject.tzais + two_seconds, in_israel: true)).to eq true
          end
        end
      end
    end
  end
end
