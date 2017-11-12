require 'spec_helper'

describe Zmanim::ZmanimCalendar do
  subject{ Zmanim::ZmanimCalendar.new(geo_location: Zmanim::AstroCalendarSpecHelper::LAKEWOOD,
                                      date: Date.parse('2017-10-17')) }

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
end
