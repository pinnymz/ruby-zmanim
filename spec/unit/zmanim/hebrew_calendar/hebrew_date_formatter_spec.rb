require 'spec_helper'

describe Zmanim::HebrewCalendar::HebrewDateFormatter, hebrew_calendar: true do
  subject { Zmanim::HebrewCalendar::HebrewDateFormatter.new }

  describe '#defaults' do
    it 'has the expected configuration' do
      expect(subject.hebrew_format).to be_falsey
      expect(subject.use_long_hebrew_years).to be_falsey
      expect(subject.use_geresh_gershayim).to be_truthy
      expect(subject.long_week_format).to be_truthy
      expect(subject.hebrew_omer_prefix).to eq 'ב'
    end
  end

  describe '#format' do
    let(:date){ Zmanim::HebrewCalendar::JewishDate.new(year, month, 23) }
    let(:year){ leap_shabbos_shaleim }
    let(:month){ 12 }
    context 'with hebrew format' do
      before{ subject.hebrew_format = true }
      context 'with geresh gershayim' do
        it 'formats correctly' do
          expect(subject.format(date)).to eq 'כ״ג אדר א׳ תשס״ג'
        end
      end
      context 'without geresh gershayim' do
        before { subject.use_geresh_gershayim = false }
        it 'formats correctly' do
          expect(subject.format(date)).to eq 'כג אדר א תשסג'
        end
      end
    end
    context 'without hebrew format' do
      it 'formats correctly' do
        expect(subject.format(date)).to eq '23 Adar I, 5763'
      end
    end
  end

  describe '#format_month' do
    let(:date){ Zmanim::HebrewCalendar::JewishDate.new(year, month, 5) }
    let(:year){ standard_monday_chaseir }
    context 'hebrew format' do
      before { subject.hebrew_format = true}
      context 'standard months' do
        let(:month){ 8 }
        it 'formats as expected' do
          expect(subject.format_month(date)).to eq 'חשון'
        end
      end
      context 'adar in standard year' do
        let(:month){ 12 }
        it 'formats as expected' do
          expect(subject.format_month(date)).to eq 'אדר'
        end
      end
      context 'first adar in leap year' do
        let(:year){ leap_monday_chaseir }
        let(:month){ 12 }
        context 'with geresh-gershayim' do
          it 'formats as expected' do
            expect(subject.format_month(date)).to eq 'אדר א׳'
          end
        end
        context 'without geresh-gershayim' do
          before { subject.use_geresh_gershayim = false}
          it 'formats as expected' do
            expect(subject.format_month(date)).to eq 'אדר א'
          end
        end
      end
      context 'second adar in leap year' do
        let(:year){ leap_monday_chaseir }
        let(:month){ 13 }
        context 'with geresh-gershayim' do
          it 'formats as expected' do
            expect(subject.format_month(date)).to eq 'אדר ב׳'
          end
        end
        context 'without geresh-gershayim' do
          before { subject.use_geresh_gershayim = false}
          it 'formats as expected' do
            expect(subject.format_month(date)).to eq 'אדר ב'
          end
        end
      end
    end
    context 'without hebrew format' do
      context 'standard months' do
        let(:month){ 8 }
        it 'formats as expected' do
          expect(subject.format_month(date)).to eq 'Cheshvan'
        end
      end
      context 'adar in standard year' do
        let(:month){ 12 }
        it 'formats as expected' do
          expect(subject.format_month(date)).to eq 'Adar'
        end
      end
      context 'first adar in leap year' do
        let(:year){ leap_monday_chaseir }
        let(:month){ 12 }
        it 'formats as expected' do
          expect(subject.format_month(date)).to eq 'Adar I'
        end
      end
      context 'second adar in leap year' do
        let(:year){ leap_monday_chaseir }
        let(:month){ 13 }
        it 'formats as expected' do
          expect(subject.format_month(date)).to eq 'Adar II'
        end
      end
    end
  end

  describe '#format_day_of_week' do
    let(:date){ Zmanim::HebrewCalendar::JewishDate.new(year, 7, 1) }
    let(:year){ standard_monday_chaseir }
    context 'with hebrew format' do
      before { subject.hebrew_format = true}
      it 'formats correctly' do
        expect(subject.format_day_of_week(date)).to eq 'שני'
      end
    end
    context 'without hebrew format' do
      context 'for regular days' do
        it 'formats correctly' do
          expect(subject.format_day_of_week(date)).to eq 'Monday'
        end
      end
      context 'for shabbos' do
        let(:year){ standard_shabbos_shaleim }
        it 'formats correctly' do
          expect(subject.format_day_of_week(date)).to eq 'Shabbos'
        end
      end
    end
  end

  describe '#format_hebrew_number' do
    it 'formats for 0' do
      expect(subject.format_hebrew_number(0)).to eq 'אפס'
    end
    context 'with geresh gershayim enabled' do
      it 'formats for even hundreds' do
        expect(subject.format_hebrew_number(300)).to eq 'ש׳'
      end
      it 'formats for complex hundreds' do
        expect(subject.format_hebrew_number(700)).to eq 'ת״ש'
      end
      it 'formats for even tens' do
        expect(subject.format_hebrew_number(80)).to eq 'פ׳'
      end
      it 'formats for even ones' do
        expect(subject.format_hebrew_number(8)).to eq 'ח׳'
      end
      it 'formats for hundreds and tens' do
        expect(subject.format_hebrew_number(880)).to eq 'תת״ף'
      end
      it 'formats for tens and ones' do
        expect(subject.format_hebrew_number(88)).to eq 'פ״ח'
      end
      it 'formats for hundreds and ones' do
        expect(subject.format_hebrew_number(808)).to eq 'תת״ח'
      end
      it 'formats for hundreds, tens, and ones' do
        expect(subject.format_hebrew_number(888)).to eq 'תתפ״ח'
      end
      it 'formats for fifteen' do
        expect(subject.format_hebrew_number(15)).to eq 'ט״ו'
      end
      it 'formats for sixteen' do
        expect(subject.format_hebrew_number(16)).to eq 'ט״ז'
      end
      it 'formats for hundreds and fifteen' do
        expect(subject.format_hebrew_number(615)).to eq 'תרט״ו'
      end
      it 'formats for hundreds and sixteen' do
        expect(subject.format_hebrew_number(616)).to eq 'תרט״ז'
      end
      context 'for even thousands' do
        context 'with long numbers enabled' do
          before { subject.use_long_hebrew_years = true }
          it 'formats the thousand' do
            expect(subject.format_hebrew_number(6000)).to eq 'ו׳ אלפים'
          end
        end
        context 'with long numbers disabled' do
          before { subject.use_long_hebrew_years = false }
          it 'formats the thousand' do
            expect(subject.format_hebrew_number(6000)).to eq 'ו׳ אלפים'
          end
        end
      end
      context 'for thousands' do
        context 'with long numbers enabled' do
          before { subject.use_long_hebrew_years = true }
          it 'formats for even hundreds' do
            expect(subject.format_hebrew_number(6300)).to eq 'ו׳ ש׳'
          end
          it 'formats for complex hundreds' do
            expect(subject.format_hebrew_number(3700)).to eq 'ג׳ ת״ש'
          end
          it 'formats for even tens' do
            expect(subject.format_hebrew_number(6080)).to eq 'ו׳ פ׳'
          end
          it 'formats for even ones' do
            expect(subject.format_hebrew_number(6008)).to eq 'ו׳ ח׳'
          end
          it 'formats for hundreds, tens, and ones' do
            expect(subject.format_hebrew_number(6888)).to eq 'ו׳ תתפ״ח'
          end
        end
        context 'with long numbers disabled' do
          before { subject.use_long_hebrew_years = false }
          it 'ignores the thousands' do
            expect(subject.format_hebrew_number(6300)).to eq 'ש׳'
          end
        end
      end
    end
    context 'with geresh gershayim disabled' do
      before { subject.use_geresh_gershayim = false }
      before { subject.use_long_hebrew_years = true }
      it 'leaves out the geresh on base numbers' do
        expect(subject.format_hebrew_number(8)).to eq 'ח'
      end
      it 'leaves out the geresh on thousands' do
        expect(subject.format_hebrew_number(7008)).to eq 'ז ח'
      end
      it 'leaves out the geresh on even thousands' do
        expect(subject.format_hebrew_number(7000)).to eq 'ז אלפים'
      end
      it 'leaves out the gershayim' do
        expect(subject.format_hebrew_number(888)).to eq 'תתפח'
      end
    end
  end

  describe '#format_significant_day' do
    let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, month, day) }
    context 'for an insignificant day' do
      let(:month){ 8 }
      let(:day){ 8 }
      it 'returns a blank string' do
        expect(subject.format_significant_day(date)).to eq ''
      end
    end
    context 'for a standard significant day' do
      let(:month){ 7 }
      let(:day){ 1 }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats correctly' do
          expect(subject.format_significant_day(date)).to eq 'ראש השנה'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats correctly' do
          expect(subject.format_significant_day(date)).to eq 'Rosh Hashana'
        end
      end
    end
    context 'for one of the days of chanukah' do
      let(:month){ 9 }
      let(:day){ 28 }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats as expected' do
          expect(subject.format_significant_day(date)).to eq 'ד׳ חנוכה'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats as expected' do
          expect(subject.format_significant_day(date)).to eq '4 Chanukah'
        end
      end
    end
  end

  describe '#format_rosh_chodesh' do
    let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(leap_monday_chaseir, month, day) }
    context 'when not rosh chodesh related' do
      let(:month){ 10 }
      let(:day){ 8 }
      it 'returns an empty string' do
        expect(subject.format_rosh_chodesh(date)).to eq ''
      end
    end
    context 'for first day of month' do
      let(:month){ 10 }
      let(:day){ 1}
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'ראש חדש טבת'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'Rosh Chodesh Teves'
        end
      end
    end
    context 'for erev rosh chodesh' do
      let(:month){ 10 }
      let(:day){ 29 }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'ערב ראש חדש שבט'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'Erev Rosh Chodesh Shevat'
        end
      end
    end
    context 'for first day of double rosh chodesh' do
      let(:month){ 11 }
      let(:day){ 30 }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'ראש חדש אדר א׳'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'Rosh Chodesh Adar I'
        end
      end
    end
    context 'for erev rosh chodesh of last month' do
      let(:month){ 13 }
      let(:day){ 29 }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'ערב ראש חדש ניסן'
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats correctly' do
          expect(subject.format_rosh_chodesh(date)).to eq 'Erev Rosh Chodesh Nissan'
        end
      end
    end
  end

  describe '#format_omer' do
    let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(leap_monday_chaseir, month, day) }
    let(:day){ 3 }
    context 'outside of the omer' do
      let(:month){ 1 }
      it 'returns an empty string' do
        expect(subject.format_omer(date)).to eq ''
      end
    end
    context 'during the omer' do
      let(:month){ 2 }
      context 'with hebrew format' do
        before { subject.hebrew_format = true }
        it 'formats correctly' do
          expect(subject.format_omer(date)).to eq 'י״ח בעומר'
        end
        context 'with a modified omer prefix' do
          before { subject.hebrew_omer_prefix = 'ל'}
          it 'formats correctly' do
            expect(subject.format_omer(date)).to eq 'י״ח לעומר'
          end
        end
      end
      context 'without hebrew format' do
        before { subject.hebrew_format = false }
        it 'formats correctly' do
          expect(subject.format_omer(date)).to eq 'Omer 18'
        end
        context 'for lag baomer special case' do
          let(:day){ 18 }
          it 'formats correctly' do
            expect(subject.format_omer(date)).to eq "Lag B'Omer"
          end
        end
      end
    end
  end

  describe '#format_kviah' do
    it 'formats chaseirim correctly' do
      expect(subject.format_kviah(standard_monday_chaseir)).to eq 'בחג'
    end
    it 'formats kesidran correctly' do
      expect(subject.format_kviah(standard_tuesday_kesidran)).to eq 'גכה'
    end
    it 'formats shelaimim correctly' do
      expect(subject.format_kviah(standard_thursday_shaleim)).to eq 'השא'
    end
  end

  describe '#format_tefilah_additions' do
    let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 7, 20) }
    context 'with no additions' do
      let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 7, 6) }
      it 'returns an empty array' do
        expect(subject.format_tefilah_additions(date)).to eq []
      end
    end
    context 'with hebrew format' do
      before { subject.hebrew_format = true }
      it 'formats correctly' do
        results = subject.format_tefilah_additions(date)
        expect(results).to eq ['יעלה ויבא']
      end
      context 'with a specific nusach' do
        it 'formats correctly' do
          results = subject.format_tefilah_additions(date, nusach: :sefard)
          expect(results).to eq ['מוריד הטל', 'יעלה ויבא']
        end
      end
    end
    context 'without hebrew format' do
      before { subject.hebrew_format = false }
      it 'formats correctly' do
        results = subject.format_tefilah_additions(date)
        expect(results).to eq ['Yaaleh Veyavo']
      end
      context 'with a specific nusach' do
        it 'formats correctly' do
          results = subject.format_tefilah_additions(date, nusach: :sefard)
          expect(results).to eq ['Morid Hatal', 'Yaaleh Veyavo']
        end
      end
    end
  end
  describe '#format_significant_shabbos' do
    let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 7, 6) }
    context 'when not significant shabbos' do
      let(:date){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 7, 4) }
      it 'returns a blank string' do
        expect(subject.format_significant_shabbos(date)).to eq ''
      end
    end
    context 'with hebrew format' do
      before { subject.hebrew_format = true }
      it 'formats correctly' do
        expect(subject.format_significant_shabbos(date)).to eq 'שבת שובה'
      end
    end
    context 'without hebrew format' do
      before { subject.hebrew_format = false }
      it 'formats correctly' do
        expect(subject.format_significant_shabbos(date)).to eq 'Shabbos Shuva'
      end
    end
  end
end
