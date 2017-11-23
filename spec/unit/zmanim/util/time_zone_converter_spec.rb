require 'spec_helper'

describe Zmanim::Util::TimeZoneConverter do
  let(:time_zone){ TZInfo::Timezone.get('America/New_York') }
  subject{ Zmanim::Util::TimeZoneConverter.new(time_zone) }
  describe '#modify_offset' do
    let(:time){ DateTime.new(2017,8,10,12,0,0,initial_offset) }
    context 'for UTC time' do
      let(:initial_offset){ 0 }
      it 'modifies correctly' do
        result = subject.modify_offset(time)
        expect(result.hour).to eq time.hour - 4
        expect(result.offset).to eq(-4/24.0)
      end
    end
    context 'for some other timezone' do
      let(:initial_offset){ 3/24.0 }
      it 'modifies correctly' do
        result = subject.modify_offset(time)
        expect(result.hour).to eq time.hour - 7
        expect(result.offset).to eq(-4/24.0)
      end
    end
  end
  describe '#offset_at' do
    context 'during DST' do
      let(:time){ DateTime.new(2017,8,10,12,0,0) }
      it 'returns the DST offset in hours' do
        expect(subject.offset_at(time)).to eq(-4.0)
      end
    end
    context 'during standard time' do
      let(:time){ DateTime.new(2017,2,10,12,0,0) }
      it 'returns the standard offset in hours' do
        expect(subject.offset_at(time)).to eq(-5.0)
      end
    end
  end
end
