require 'spec_helper'

describe Zmanim::Limudim::Calculators::AmudYomiBavliDirshu do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Date.parse('2024-05-30') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
        expect(limud.start_date).to eq date
        expect(limud.end_date).to eq date
        expect(limud.description).to eq 'shabbos 53a'
      end
    end
    context 'before the cycle began' do
      let(:date){ Date.parse('2023-01-01') }
      it 'should be nil' do
        limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
        expect(limud).to be_nil
      end
    end
    context 'for the first day of a cycle' do
      let(:date){ Date.parse('2038-08-04') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
        expect(limud.description).to eq 'berachos 2a'
      end
    end
    context 'for the last day of a cycle' do
      let(:date){ Date.parse('2038-08-03') }
      it 'should return the expected limud' do
        limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
        expect(limud.description).to eq 'niddah 73a'
      end
    end
    context 'for oddly placed masechtos' do
      context 'for end of meilah' do
        let(:date){ Date.parse('2038-02-10') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
          expect(limud.description).to eq 'meilah 22a'
        end
      end
      context 'for beginning of kinnim' do
        let(:date){ Date.parse('2038-02-11') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
          expect(limud.description).to eq 'kinnim 22b'
        end
      end
      context 'for end of kinnim' do
        let(:date){ Date.parse('2038-02-16') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
          expect(limud.description).to eq 'kinnim 25a'
        end
      end
      context 'for beginning of tamid' do
        let(:date){ Date.parse('2038-02-17') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
          expect(limud.description).to eq 'tamid 25b'
        end
      end
      context 'for beginning of midos' do
        let(:date){ Date.parse('2038-03-06') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
          expect(limud.description).to eq 'midos 34a'
        end
      end
      context 'for after middos' do
        let(:date){ Date.parse('2038-03-14') }
        it 'should return the expected limud' do
          limud = Zmanim::Limudim::Calculators::AmudYomiBavliDirshu.new.limud(date)
          expect(limud.description).to eq 'niddah 2a'
        end
      end
    end
  end
end
