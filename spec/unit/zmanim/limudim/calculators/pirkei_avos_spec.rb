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
    context 'for a date near the cycle end' do
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
    context 'for a date before the cycle starts' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 1, 20) }
      it 'returns a blank limud' do
        limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date)
        expect(limud).to be_nil
      end
    end
    context 'on a Pesach edge' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5778, 1, 22) }
      context 'outside israel' do
        it 'recognizes 8th day of Pesach as before the cycle' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date)
          expect(limud).to be_nil
        end
        it 'recognizes the following day as starting the cycle' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date + 1)
          expect_jewish_date(limud.end_date, 5778, 1, 29)
          expect(limud.description).to eq '1'
        end
      end
      context 'in israel' do
        it 'recognizes 8th day of Pesach as the start of a cycle' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new(in_israel: true).limud(date)
          expect_jewish_date(limud.end_date, 5778, 1, 22)
          expect(limud.description).to eq '1'
        end
        it 'recognizes the following day as starting the next iteration' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new(in_israel: true).limud(date + 1)
          expect_jewish_date(limud.end_date, 5778, 1, 29)
          expect(limud.description).to eq '2'
        end
      end
    end
    context 'where 7 Iyar falls on Shabbos' do
      let(:date){ Zmanim::HebrewCalendar::JewishDate.new(5769, 3, 3) }
      context 'outside israel' do
        it 'recognizes that iteration as having a limud with no unit' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date)
          expect_jewish_date(limud.end_date, 5769, 3, 7)
          expect(limud.unit).to be_nil
        end
        it 'recognizes the following iteration as beginning a new sub-cycle' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new.limud(date + 5) # 8 Iyar
          expect_jewish_date(limud.end_date, 5769, 3, 14)
          expect(limud.description).to eq '1'
        end
      end
      context 'in israel' do
        it 'recognizes that iteration as as beginning a new sub-cycle' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new(in_israel: true).limud(date)
          expect_jewish_date(limud.end_date, 5769, 3, 7)
          expect(limud.description).to eq '1'
        end
        it 'recognizes the following iteration as starting the next unit' do
          limud = Zmanim::Limudim::Calculators::PirkeiAvos.new(in_israel: true).limud(date + 5) # 8 Iyar
          expect_jewish_date(limud.end_date, 5769, 3, 14)
          expect(limud.description).to eq '2'
        end
      end
    end
  end
end
