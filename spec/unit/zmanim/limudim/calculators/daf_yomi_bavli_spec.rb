require 'spec_helper'

describe Zmanim::Limudim::Calculators::DafYomiBavli do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Date.parse('2017-12-28') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'shevuos 30'
      end
    end
    context 'before the cycle began' do
      let(:date){ Date.parse('1920-01-01') }
      it 'should be nil' do
        limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
        expect(limud).to be_nil
      end
    end
    context 'for the first day of a cycle' do
      let(:date){ Date.parse('2012-08-03') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
        expect(limud.description).to eq 'berachos 2'
      end
    end
    context 'for the last day of a cycle' do
      let(:date){ Date.parse('2020-01-04') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
        expect(limud.description).to eq 'niddah 73'
      end
    end
    context 'before the shekalim transition' do
      context 'end of shekalim' do
        let(:date){ Date.parse('1969-04-28') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'shekalim 13'
        end
      end
      context 'beginning of yoma' do
        let(:date){ Date.parse('1969-04-29') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'yoma 2'
        end
      end
    end
    context 'after the shekalim transition' do
      context 'end of shekalim' do
        let(:date){ Date.parse('1976-09-29') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'shekalim 22'
        end
      end
      context 'beginning of yoma' do
        let(:date){ Date.parse('1976-09-30') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'yoma 2'
        end
      end
    end
    context 'for oddly placed masechtos' do
      context 'for end of meilah' do
        let(:date){ Date.parse('2019-10-9') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'meilah 22'
        end
      end
      context 'for beginning of kinnim' do
        let(:date){ Date.parse('2019-10-10') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'kinnim 23'
        end
      end
      context 'for beginning of tamid' do
        let(:date){ Date.parse('2019-10-13') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'tamid 26'
        end
      end
      context 'for beginning of midos' do
        let(:date){ Date.parse('2019-10-22') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'midos 35'
        end
      end
      context 'for after middos' do
        let(:date){ Date.parse('2019-10-25') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::DafYomiBavli.new.limud(date)
          expect(limud.description).to eq 'niddah 2'
        end
      end
    end
  end
end
