require 'spec_helper'

describe Zmanim::Limudim::Unit do
  describe '#to_s' do
    context 'for a primitive unit' do
      let(:subject){ Zmanim::Limudim::Unit.new('berachos') }
      it 'renders as expected' do
        expect(subject.to_s).to eq 'berachos'
      end
    end
    context 'for a paged unit' do
      let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3]) }
      it 'renders as expected' do
        expect(subject.to_s).to eq 'berachos 3'
      end
    end
    context 'for a multi-level unit' do
      let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3, 5, 7, 4, 5]) }
      it 'renders as expected' do
        expect(subject.to_s).to eq 'berachos 3:5:7:4:5'
      end
    end
    context 'for a multi-component primitive unit' do
      let(:subject){ Zmanim::Limudim::Unit.new('tazria', 'metzora') }
      it 'renders as expected' do
        expect(subject.to_s).to eq 'tazria - metzora'
      end
    end
    context 'for a multi-component integer unit' do
      let(:subject){ Zmanim::Limudim::Unit.new(18, 25) }
      it 'renders as expected' do
        expect(subject.to_s).to eq '18 - 25'
      end
    end
    context 'for a page-spanning unit' do
      context 'with similar root nodes' do
        let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3], ['berachos', 4]) }
        it 'renders as expected' do
          expect(subject.to_s).to eq 'berachos 3-4'
        end
      end
      context 'with different root nodes' do
        let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3], ['shabbos', 4]) }
        it 'renders as expected' do
          expect(subject.to_s).to eq 'berachos 3 - shabbos 4'
        end
      end
    end
    context 'for a multi-level spanning unit' do
      context 'with different leaf nodes' do
        let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3, 5], ['berachos', 3, 7]) }
        it 'renders as expected' do
          expect(subject.to_s).to eq 'berachos 3:5-7'
        end
      end
      context 'with different middle nodes' do
        let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3, 5], ['berachos', 4, 1]) }
        it 'renders as expected' do
          expect(subject.to_s).to eq 'berachos 3:5-4:1'
        end
      end
      context 'with different root nodes' do
        let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 9, 1], ['peah', 1, 1]) }
        it 'renders as expected' do
          expect(subject.to_s).to eq 'berachos 9:1 - peah 1:1'
        end
      end
    end
  end
  describe '#render' do
    let(:subject){ Zmanim::Limudim::Unit.new(['berachos', 3]) }
    it 'manipulates the rendering via block' do
      result = subject.render do |e|
        case e
          when Numeric
            e * 2
          else
            e.upcase
        end
      end
      expect(result).to eq 'BERACHOS 6'
    end
  end
end
