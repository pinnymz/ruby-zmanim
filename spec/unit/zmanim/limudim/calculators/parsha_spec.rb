require 'spec_helper'

describe Zmanim::Limudim::Calculators::Parsha, hebrew_calendar: true do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 10, 8) }
      it 'returns the expected interval-parsha pair' do
        limud = Zmanim::Limudim::Calculators::Parsha.new.limud(date)
        expect_jewish_date(limud.end_date, 5778, 10, 12)
        expect(limud.description).to eq 'vayechi'
      end
    end
    context 'for a wraparound date' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5777, 6, 27) }
      it 'returns the expected interval-parsha pair' do
        limud = Zmanim::Limudim::Calculators::Parsha.new.limud(date)
        expect_jewish_date(limud.end_date, 5778, 7, 3)
        expect(limud.description).to eq 'haazinu'
      end
    end
    context 'for a date before the cycle restarts' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 7, 4) }
      it 'returns the expected interval-parsha pair' do
        limud = Zmanim::Limudim::Calculators::Parsha.new.limud(date)
        expect_jewish_date(limud.end_date, 5778, 7, 23)
        expect(limud.description).to eq 'vezos_haberacha'
      end
    end
    context 'for a date where israel has a different parsha' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5775, 1, 27) }
      context 'in israel' do
        it 'returns the expected parsha' do
          limud = Zmanim::Limudim::Calculators::Parsha.new(in_israel: true).limud(date)
          expect_jewish_date(limud.end_date, 5775, 1, 29)
          expect(limud.description).to eq 'tazria - metzora'
        end
      end
      context 'outside israel' do
        it 'returns the expected parsha' do
          limud = Zmanim::Limudim::Calculators::Parsha.new.limud(date)
          expect_jewish_date(limud.end_date, 5775, 1, 29)
          expect(limud.description).to eq 'shemini'
        end
      end
    end
  end
end
