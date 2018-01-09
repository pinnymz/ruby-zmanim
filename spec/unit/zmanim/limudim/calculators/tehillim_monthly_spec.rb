require 'spec_helper'

describe Zmanim::Limudim::Calculators::TehillimMonthly, hebrew_calendar: true do
  describe '#limud' do
    context 'for a simple date' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 10, 8) }
      it 'returns the expected start-end pair' do
        limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
        expect_jewish_date(limud.end_date, 5778, 10, 8)
        expect(limud.description).to eq '44 - 48'
      end
    end
    context 'for the beginning of a month' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 10, 1) }
      it 'returns the expected start-end pair' do
        limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
        expect(limud.description).to eq '1 - 9'
      end
    end
    context 'for the end of a short month' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 10, 29) }
      it 'returns the expected start-end pair' do
        limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
        expect(limud.description).to eq '140 - 150'
      end
    end
    context 'for the end of a long month' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 11, 30) }
      it 'returns the expected start-end pair' do
        limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
        expect(limud.description).to eq '145 - 150'
      end
    end
    context 'for the 29th day of a long month' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 11, 29) }
      it 'returns the expected start-end pair' do
        limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
        expect(limud.description).to eq '140 - 144'
      end
    end
    context 'for special case' do
      context 'day 25' do
        let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 11, 25) }
        it 'returns the expected start-end pair' do
          limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
          expect(limud.description).to eq '119 1-30'
        end
      end
      context 'day 26' do
        let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 11, 26) }
        it 'returns the expected start-end pair' do
          limud = Zmanim::Limudim::Calculators::TehillimMonthly.new.limud(date)
          expect(limud.description).to eq '119 40-400'
        end
      end
    end
  end
end
