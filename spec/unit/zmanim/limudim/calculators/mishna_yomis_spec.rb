require 'spec_helper'

describe Zmanim::Limudim::Calculators::MishnaYomis do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Date.parse('2017-12-28') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::MishnaYomis.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'megillah 3:4-5'
      end
    end
    context 'for a date before the initial cycle' do
      let(:date){ Date.parse('1947-01-01') }
      it 'should be nil' do
        limud = Zmanim::Limudim::Calculators::MishnaYomis.new.limud(date)
        expect(limud).to be_nil
      end
    end
    context 'for the first day of a cycle' do
      let(:date){ Date.parse('2016-03-30') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::MishnaYomis.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'berachos 1:1-2'
      end
    end
    context 'for the last day of a cycle' do
      let(:date){ Date.parse('2016-03-29') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::MishnaYomis.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'uktzin 3:11-12'
      end
    end
    context 'for the a limud that spans two masechtos' do
      let(:date){ Date.parse('2016-04-27') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::MishnaYomis.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'berachos 9:5 - peah 1:1'
      end
    end
    context 'for the a limud that spans two perakim' do
      let(:date){ Date.parse('2017-12-23') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::MishnaYomis.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'megillah 1:11-2:1'
      end
    end
  end
end
