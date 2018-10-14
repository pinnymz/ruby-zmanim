require 'spec_helper'

describe Zmanim::Limudim::Calculators::DafHashavuaBavli do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Date.parse('2018-10-10') } # Wednesday
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafHashavuaBavli.new.limud(date)
        expect(limud.start_date).to eq date - 3
        expect(limud.end_date).to eq date + 3
        expect(limud.description).to eq 'megillah 3'
      end
    end
    context 'before the cycle began' do
      let(:date){ Date.parse('2005-03-01') }
      it 'should be nil' do
        limud = Zmanim::Limudim::Calculators::DafHashavuaBavli.new.limud(date)
        expect(limud).to be_nil
      end
    end
    context 'for the first day of a cycle' do
      let(:date){ Date.parse('2057-02-11') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafHashavuaBavli.new.limud(date)
        expect(limud.description).to eq 'berachos 2'
      end
    end
    context 'for the last day of a cycle' do
      let(:date){ Date.parse('2057-02-10') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafHashavuaBavli.new.limud(date)
        expect(limud.description).to eq 'niddah 73'
      end
    end
  end
end
