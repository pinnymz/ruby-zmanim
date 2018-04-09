require 'spec_helper'

describe Zmanim::Limudim::Calculators::PirkeiAvos, hebrew_calendar: true do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 3, 1) }
      it 'returns the expected perek' do
        limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date)
        expect_jewish_date(limud.end_date, 5778, 3, 5)
        expect(limud.description).to eq '6'
      end
    end
    context 'for a compound date' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 6, 20) }
      it 'returns the expected combined pair' do
        limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date)
        expect_jewish_date(limud.end_date, 5778, 6, 21)
        expect(limud.description).to eq '3 - 4'
      end
    end
    context 'for a date after the cycle completes' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 6, 29) }
      it 'returns a blank limud' do
        limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date)
        expect(limud).to be_nil
      end
    end
  end
end
