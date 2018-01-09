require 'spec_helper'

describe Zmanim::Limudim::Calculators::DafYomiYerushalmi do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Date.parse('2017-12-28') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafYomiYerushalmi.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'bava_metzia 33'
      end
    end
    context 'before the cycle began' do
      let(:date){ Date.parse('1980-01-01') }
      it 'should be nil' do
        limud = Zmanim::Limudim::Calculators::DafYomiYerushalmi.new.limud(date)
        expect(limud).to be_nil
      end
    end
    context 'for the first day of a cycle' do
      let(:date){ Date.parse('2005-10-03') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafYomiYerushalmi.new.limud(date)
        expect(limud.description).to eq 'berachos 1'
      end
    end
    context 'for the last day of a cycle' do
      let(:date){ Date.parse('2010-01-12') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafYomiYerushalmi.new.limud(date)
        expect(limud.description).to eq 'niddah 13'
      end
    end
    context 'on a skip day' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 7, 10) }
      it 'should return a limud with no daf' do
        limud = Zmanim::Limudim::Calculators::DafYomiYerushalmi.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'no_daf_today'
      end
    end
  end
end
