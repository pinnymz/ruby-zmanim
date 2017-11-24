require 'spec_helper'

describe Zmanim::Util::TextHelper do
  class ModuleTester; extend Zmanim::Util::TextHelper; end
  describe '#titleize' do
    it 'converts single words' do
      expect(ModuleTester.titleize('test')).to eq 'Test'
    end
    it 'converts multiple words' do
      expect(ModuleTester.titleize('test this now')).to eq 'Test This Now'
    end
    it 'converts snakecased words' do
      expect(ModuleTester.titleize('test_this_now')).to eq 'Test This Now'
    end
    it 'converts snakecased symbols' do
      expect(ModuleTester.titleize(:test_this_now)).to eq 'Test This Now'
    end
    it 'converts blank text to empty string' do
      expect(ModuleTester.titleize('')).to eq ''
      expect(ModuleTester.titleize(' ')).to eq ''
    end
    it 'converts nil to empty string' do
      expect(ModuleTester.titleize(nil)).to eq ''
    end
  end
end
