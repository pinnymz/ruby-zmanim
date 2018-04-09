require 'spec_helper'

describe Zmanim::Limudim::LimudimFormatter, hebrew_calendar: true do
  subject { Zmanim::Limudim::LimudimFormatter.new }

  let(:date){ Date.parse('2017-12-28') }
  describe '#format_parsha' do
    let(:limud){ Zmanim::HebrewCalendar::JewishCalendar.new(date).parshas_hashavua }
    context 'with hebrew format' do
      before { subject.hebrew_format = true }
      it 'formats as expected' do
        expect(subject.format_parsha(limud)).to eq 'פרשת ויחי'
      end
    end
    context 'without hebrew format' do
      before { subject.hebrew_format = false }
      it 'formats as expected' do
        expect(subject.format_parsha(limud)).to eq 'Parshas Vayechi'
      end
    end
    context 'for a double parsha' do
      let(:limud){ Zmanim::HebrewCalendar::JewishCalendar.new(5775, 1, 27, true).parshas_hashavua }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats as expected' do
          expect(subject.format_parsha(limud)).to eq 'פרשת תזריע - מצורע'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats as expected' do
          expect(subject.format_parsha(limud)).to eq 'Parshas Tazria - Metzora'
        end
      end
    end
  end

  describe '#format_talmudic' do
    let(:limud){ Zmanim::HebrewCalendar::JewishCalendar.new(date).daf_yomi_bavli }
    context 'when not applicable' do
      let(:date){ Date.new(1900, 1, 1) }
      it 'returns a blank string' do
        expect(subject.format_talmudic(limud)).to eq ''
      end
    end
    context 'with hebrew format' do
      before { subject.hebrew_format = true }
      it 'formats as expected' do
        expect(subject.format_talmudic(limud)).to eq 'שבועות ל'
      end
    end
    context 'without hebrew format' do
      before { subject.hebrew_format = false }
      it 'formats as expected' do
        expect(subject.format_talmudic(limud)).to eq 'Shevuos 30'
      end
    end
  end

  describe '#format_tehillim' do
    let(:limud){ Zmanim::HebrewCalendar::JewishCalendar.new(date).tehillim_portion }
    context 'with hebrew format' do
      before { subject.hebrew_format = true }
      it 'formats as expected' do
        expect(subject.format_tehillim(limud)).to eq 'תהלים נה - נט'
      end
    end
    context 'without hebrew format' do
      before { subject.hebrew_format = false }
      it 'formats as expected' do
        expect(subject.format_tehillim(limud)).to eq 'Tehillim 55 - 59'
      end
    end
  end

  describe '#format_avos' do
    let(:date){ Date.parse('2018-04-09')}
    let(:limud){ Zmanim::HebrewCalendar::JewishCalendar.new(date).pirkei_avos }
    context 'with hebrew format' do
      before { subject.hebrew_format = true }
      it 'formats as expected' do
        expect(subject.format_avos(limud)).to eq 'פרקי אבות א'
      end
    end
    context 'without hebrew format' do
      before { subject.hebrew_format = false }
      it 'formats as expected' do
        expect(subject.format_avos(limud)).to eq 'Pirkei Avos 1'
      end
    end
  end
end
