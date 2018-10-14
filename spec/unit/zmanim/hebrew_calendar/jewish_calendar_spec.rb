require 'spec_helper'

describe Zmanim::HebrewCalendar::JewishCalendar, hebrew_calendar: true do
  let(:all_year_types){
    [standard_monday_chaseir, standard_monday_shaleim, standard_tuesday_kesidran, standard_thursday_kesidran, standard_thursday_shaleim,
     standard_shabbos_chaseir, standard_shabbos_shaleim, leap_monday_chaseir, leap_monday_shaleim, leap_tuesday_kesidran, leap_thursday_chaseir,
     leap_thursday_shaleim, leap_shabbos_chaseir, leap_shabbos_shaleim]
  }
  let(:all_rosh_hashanas){ all_year_types.map{|y| Zmanim::HebrewCalendar::JewishCalendar.new(y, 7, 1) } }
  let(:chanukah_for_chaseir){ ['9-25', '9-26', '9-27', '9-28', '9-29', '10-1', '10-2', '10-3'] }
  let(:leap_purim){ {purim_katan: ['12-14'], shushan_purim_katan: ['12-15'], taanis_esther: ['13-13'], purim: ['13-14'], shushan_purim: ['13-15']}}
  let(:standard_significant_days){
    {
        erev_pesach: ['1-14'],
        pesach: ['1-15', '1-16', '1-21', '1-22'],
        chol_hamoed_pesach: ['1-17', '1-18', '1-19', '1-20'],
        pesach_sheni: ['2-14'],
        erev_shavuos: ['3-5'],
        shavuos: ['3-6', '3-7'],
        seventeen_of_tammuz: ['4-17'],
        tisha_beav: ['5-9'],
        tu_beav: ['5-15'],
        erev_rosh_hashana: ['6-29'],
        rosh_hashana: ['7-1', '7-2'],
        tzom_gedalyah: ['7-3'],
        erev_yom_kippur: ['7-9'],
        yom_kippur: ['7-10'],
        erev_succos: ['7-14'],
        succos: ['7-15', '7-16'],
        chol_hamoed_succos: ['7-17', '7-18', '7-19', '7-20'],
        hoshana_rabbah: ['7-21'],
        shemini_atzeres: ['7-22'],
        simchas_torah: ['7-23'],
        chanukah: ['9-25', '9-26', '9-27', '9-28', '9-29', '9-30', '10-1', '10-2'],
        tenth_of_teves: ['10-10'],
        tu_beshvat: ['11-15'],
        taanis_esther: ['12-13'],
        purim: ['12-14'],
        shushan_purim: ['12-15']
    }
  }
  let(:leap_significant_days){ standard_significant_days.merge(leap_purim) }
  let(:israel_standard_significant_days){
    standard_significant_days.merge(
      pesach: ['1-15', '1-21'],
      chol_hamoed_pesach: ['1-16', '1-17', '1-18', '1-19', '1-20'],
      shavuos: ['3-6'],
      succos: ['7-15'],
      chol_hamoed_succos: ['7-16', '7-17', '7-18', '7-19', '7-20']
    ).reject{|k,v| k == :simchas_torah}
  }
  let(:israel_leap_significant_days){
    israel_standard_significant_days.merge(leap_purim)
  }
  let(:modern_significant_days){
    %i(yom_hashoah yom_hazikaron yom_haatzmaut yom_yerushalayim)
  }

  it 'confirms years have expected properties' do
    expect(all_rosh_hashanas.map(&:jewish_leap_year?)).to eq [false, false, false, false, false, false, false,
                                                          true, true, true, true, true, true, true]
    expect(all_rosh_hashanas.map(&:day_of_week)).to eq [2, 2, 3, 5, 5, 7, 7, 2, 2, 3, 5, 5, 7, 7]
    expect(all_rosh_hashanas.map(&:cheshvan_kislev_kviah)).to eq %i(chaseirim shelaimim kesidran kesidran shelaimim chaseirim shelaimim
                                                                chaseirim shelaimim kesidran chaseirim shelaimim chaseirim shelaimim)
  end

  describe '#significant_day' do
    context 'outside israel' do
      let(:significant_days){ all_days_matching(year, ->(c){ c.significant_day }) }
      context 'standard year, Monday RH, chaseirim' do
        let(:year){ standard_monday_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days.merge(
              chanukah: chanukah_for_chaseir,
              taanis_esther: ['12-11']
          ))
        end
      end
      context 'standard year, Monday RH, shelaimim' do
        let(:year){ standard_monday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days)
        end
      end
      context 'standard year, Tuesday RH, kesidran' do
        let(:year){ standard_tuesday_kesidran }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days)
        end
      end
      context 'standard year, Thursday RH, kesidran' do
        let(:year){ standard_thursday_kesidran }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days.merge(
              tzom_gedalyah: ['7-4'],
              seventeen_of_tammuz: ['4-18'],
              tisha_beav: ['5-10']
          ))
        end
      end
      context 'standard year, Thursday RH, shelaimim' do
        let(:year){ standard_thursday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days.merge(
              tzom_gedalyah: ['7-4']
          ))
        end
      end
      context 'standard year, Shabbos RH, chaseirim' do
        let(:year){ standard_shabbos_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days.merge(
              chanukah: chanukah_for_chaseir
          ))
        end
      end
      context 'standard year, Shabbos RH, shelaimim' do
        let(:year){ standard_shabbos_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(standard_significant_days.merge(
              taanis_esther: ['12-11']
          ))
        end
      end

      context 'leap year, Monday RH, chaseirim' do
        let(:year){ leap_monday_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days.merge(
              chanukah: chanukah_for_chaseir
          ))
        end
      end
      context 'leap year, Monday RH, shelaimim' do
        let(:year){ leap_monday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days.merge(
              seventeen_of_tammuz: ['4-18'],
              tisha_beav: ['5-10']
          ))
        end
      end
      context 'leap year, Tuesday RH, kesidran' do
        let(:year){ leap_tuesday_kesidran }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days.merge(
              seventeen_of_tammuz: ['4-18'],
              tisha_beav: ['5-10']
          ))
        end
      end
      context 'leap year, Thursday RH, chaseirim' do
        let(:year){ leap_thursday_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days.merge(
              tzom_gedalyah: ['7-4'],
              chanukah: chanukah_for_chaseir
          ))
        end
      end
      context 'leap year, Thursday RH, shelaimim' do
        let(:year){ leap_thursday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days.merge(
              tzom_gedalyah: ['7-4'],
              taanis_esther: ['13-11']
          ))
        end
      end
      context 'leap year, Shabbos RH, chaseirim' do
        let(:year){ leap_shabbos_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days.merge(
              chanukah: chanukah_for_chaseir,
              taanis_esther: ['13-11']
          ))
        end
      end
      context 'leap year, Shabbos RH, shelaimim' do
        let(:year){ leap_shabbos_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(leap_significant_days)
        end
      end
    end

    context 'in israel' do
      let(:significant_days){ all_days_matching(year, ->(c){ c.significant_day }, in_israel: true) }
      context 'standard year, Monday RH, chaseirim' do
        let(:year){ standard_monday_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days.merge(
              chanukah: chanukah_for_chaseir,
              taanis_esther: ['12-11']
          ))
        end
      end
      context 'standard year, Monday RH, shelaimim' do
        let(:year){ standard_monday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days)
        end
      end
      context 'standard year, Tuesday RH, kesidran' do
        let(:year){ standard_tuesday_kesidran }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days)
        end
      end
      context 'standard year, Thursday RH, kesidran' do
        let(:year){ standard_thursday_kesidran }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days.merge(
              tzom_gedalyah: ['7-4'],
              seventeen_of_tammuz: ['4-18'],
              tisha_beav: ['5-10']
          ))
        end
      end
      context 'standard year, Thursday RH, shelaimim' do
        let(:year){ standard_thursday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days.merge(
              tzom_gedalyah: ['7-4']
          ))
        end
      end
      context 'standard year, Shabbos RH, chaseirim' do
        let(:year){ standard_shabbos_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days.merge(
              chanukah: chanukah_for_chaseir
          ))
        end
      end
      context 'standard year, Shabbos RH, shelaimim' do
        let(:year){ standard_shabbos_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_standard_significant_days.merge(
              taanis_esther: ['12-11']
          ))
        end
      end

      context 'leap year, Monday RH, chaseirim' do
        let(:year){ leap_monday_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days.merge(
              chanukah: chanukah_for_chaseir
          ))
        end
      end
      context 'leap year, Monday RH, shelaimim' do
        let(:year){ leap_monday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days.merge(
              seventeen_of_tammuz: ['4-18'],
              tisha_beav: ['5-10']
          ))
        end
      end
      context 'leap year, Tuesday RH, kesidran' do
        let(:year){ leap_tuesday_kesidran }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days.merge(
              seventeen_of_tammuz: ['4-18'],
              tisha_beav: ['5-10']
          ))
        end
      end
      context 'leap year, Thursday RH, chaseirim' do
        let(:year){ leap_thursday_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days.merge(
              tzom_gedalyah: ['7-4'],
              chanukah: chanukah_for_chaseir
          ))
        end
      end
      context 'leap year, Thursday RH, shelaimim' do
        let(:year){ leap_thursday_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days.merge(
              tzom_gedalyah: ['7-4'],
              taanis_esther: ['13-11']
          ))
        end
      end
      context 'leap year, Shabbos RH, chaseirim' do
        let(:year){ leap_shabbos_chaseir }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days.merge(
              chanukah: chanukah_for_chaseir,
              taanis_esther: ['13-11']
          ))
        end
      end
      context 'leap year, Shabbos RH, shelaimim' do
        let(:year){ leap_shabbos_shaleim }
        it 'contains the expected significant days' do
          expect(significant_days).to eq(israel_leap_significant_days)
        end
      end
    end

    context 'using modern holidays' do
      let(:significant_days){ all_days_matching(year, ->(c){ c.significant_day }, use_modern_holidays: true) }
      context 'Nissan starts on Sunday' do
        let(:year){ standard_thursday_shaleim }
        it 'has the expected modern holidays' do
          expected = {yom_hashoah: ['1-26'], yom_hazikaron: ['2-2'], yom_haatzmaut: ['2-3'], yom_yerushalayim: ['2-28']}
          expect(days_matching(significant_days, modern_significant_days)).to eq expected
        end
      end
      context 'Nissan starts on Tuesday' do
        let(:year){ standard_monday_chaseir }
        it 'has the expected modern holidays' do
          expected = {yom_hashoah: ['1-28'], yom_hazikaron: ['2-5'], yom_haatzmaut: ['2-6'], yom_yerushalayim: ['2-28']}
          expect(days_matching(significant_days, modern_significant_days)).to eq expected
        end
      end
      context 'Nissan starts on Thursday' do
        let(:year){ standard_monday_shaleim }
        it 'has the expected modern holidays' do
          expected = {yom_hashoah: ['1-27'], yom_hazikaron: ['2-4'], yom_haatzmaut: ['2-5'], yom_yerushalayim: ['2-28']}
          expect(days_matching(significant_days, modern_significant_days)).to eq expected
        end
      end
      context 'Nissan starts on Shabbos' do
        let(:year){ standard_thursday_kesidran }
        it 'has the expected modern holidays' do
          expected = {yom_hashoah: ['1-27'], yom_hazikaron: ['2-3'], yom_haatzmaut: ['2-4'], yom_yerushalayim: ['2-28']}
          expect(days_matching(significant_days, modern_significant_days)).to eq expected
        end
      end
    end
  end

  describe '#yom_tov?' do
    context 'outside israel' do
      let(:yom_tov_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov? }).values.flatten }
      it 'detects the expected days' do
        expect(yom_tov_days).to eq ['7-1', '7-2', '7-10', '7-15', '7-16',
                                       '7-17', '7-18', '7-19', '7-20', '7-21', '7-22', '7-23',
                                       '9-25', '9-26', '9-27', '9-28', '9-29', '9-30', '10-1', '10-2',
                                       '11-15', '12-14', '12-15', '13-14', '13-15',
                                       '1-15', '1-16', '1-17', '1-18', '1-19', '1-20', '1-21', '1-22',
                                       '2-14', '3-6', '3-7', '5-15']
      end
    end
    context 'in israel' do
      let(:yom_tov_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expect(yom_tov_days).to eq ['7-1', '7-2', '7-10', '7-15', '7-16',
                                    '7-17', '7-18', '7-19', '7-20', '7-21', '7-22',
                                    '9-25', '9-26', '9-27', '9-28', '9-29', '9-30', '10-1', '10-2',
                                    '11-15', '12-14', '12-15', '13-14', '13-15',
                                    '1-15', '1-16', '1-17', '1-18', '1-19', '1-20', '1-21',
                                    '2-14', '3-6', '5-15']
      end
    end
    context 'using modern holidays' do
      let(:yom_tov_days){
        all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov? }, use_modern_holidays: true).values.flatten
      }
      it 'detects the expected days' do
        expect(yom_tov_days).to include '1-27', '2-4', '2-5', '2-28'
      end
    end
  end

  describe '#yom_tov_assur_bemelacha?' do
    context 'outside israel' do
      let(:issur_melacha_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov_assur_bemelacha? }).values.flatten }
      it 'detects the expected days' do
        expect(issur_melacha_days).to eq ['7-1', '7-2', '7-10', '7-15', '7-16', '7-22', '7-23',
                                    '1-15', '1-16', '1-21', '1-22', '3-6', '3-7']
      end
    end
    context 'in israel' do
      let(:issur_melacha_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov_assur_bemelacha? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expect(issur_melacha_days).to eq ['7-1', '7-2', '7-10', '7-15', '7-22', '1-15', '1-21', '3-6']
      end
    end
    context 'using modern holidays' do
      let(:issur_melacha_days){
        all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov_assur_bemelacha? }, use_modern_holidays: true).values.flatten
      }
      it 'excludes the expected days' do
        expect(issur_melacha_days).to_not include '1-27', '2-4', '2-5', '2-28'
      end
    end
  end

  describe '#assur_bemelacha?' do
    context 'outside israel' do
      let(:issur_melacha_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.assur_bemelacha? }).values.flatten }
      it 'detects the expected days' do
        expected_yom_tov = ['7-1', '7-2', '7-10', '7-15', '7-16', '7-22', '7-23',
                            '1-15', '1-16', '1-21', '1-22', '3-6', '3-7']
        expected_shabbosos = all_days_matching(leap_shabbos_shaleim, ->(c){c.day_of_week == 7}).values.flatten
        expect(issur_melacha_days.sort).to eq((expected_yom_tov | expected_shabbosos).sort)
      end
    end
    context 'in israel' do
      let(:issur_melacha_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.assur_bemelacha? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expected_yom_tov = ['7-1', '7-2', '7-10', '7-15', '7-22', '1-15', '1-21', '3-6']
        expected_shabbosos = all_days_matching(leap_shabbos_shaleim, ->(c){c.day_of_week == 7}).values.flatten
        expect(issur_melacha_days.sort).to eq((expected_yom_tov | expected_shabbosos).sort)
      end
    end
  end

  describe '#tomorrow_assur_bemelacha?' do
    context 'outside israel' do
      let(:tomorrow_assur_bemelacha_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.tomorrow_assur_bemelacha? }).values.flatten }
      it 'detects the expected days' do
        expected_erev_yom_tov = ['7-9', '7-14', '7-21', '1-14', '1-20', '3-5', '6-29']
        expected_erev_yom_tov_sheni = ['7-1', '7-15', '7-22', '1-15', '1-21', '3-6']
        expected_erev_shabbos = all_days_matching(leap_shabbos_shaleim, ->(c){c.day_of_week == 6}).values.flatten
        expected_days = expected_erev_yom_tov | expected_erev_yom_tov_sheni | expected_erev_shabbos
        expect(tomorrow_assur_bemelacha_days.sort).to eq expected_days.sort
      end
    end
    context 'in israel' do
      let(:tomorrow_assur_bemelacha_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.tomorrow_assur_bemelacha? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expected_erev_yom_tov = ['7-9', '7-14', '7-21', '1-14', '1-20', '3-5', '6-29']
        expected_erev_yom_tov_sheni = ['7-1']
        expected_erev_shabbos = all_days_matching(leap_shabbos_shaleim, ->(c){c.day_of_week == 6}).values.flatten
        expected_days = expected_erev_yom_tov | expected_erev_yom_tov_sheni | expected_erev_shabbos
        expect(tomorrow_assur_bemelacha_days.sort).to eq expected_days.sort
      end
    end
  end

  describe '#delayed_candle_lighting?' do
    let(:subject){ Zmanim::HebrewCalendar::JewishCalendar.new(Date.parse(date)) }
    context 'for a non candle lighting day' do
      let(:date){ '2018-09-13' }
      it 'returns false' do
        expect(subject.delayed_candle_lighting?).to be false
      end
    end
    context 'for a standard erev shabbos' do
      let(:date){ '2018-09-14' }
      it 'returns false' do
        expect(subject.delayed_candle_lighting?).to be false
      end
    end
    context 'for a standard erev yom tov' do
      let(:date){ '2018-09-30' }
      it 'returns false' do
        expect(subject.delayed_candle_lighting?).to be false
      end
    end
    context 'for a standard first day of yom tov' do
      let(:date){ '2018-10-01' }
      it 'returns true' do
        expect(subject.delayed_candle_lighting?).to be true
      end
    end
    context 'for a yom tov erev shabbos' do
      let(:date){ '2019-04-26' }
      it 'returns false' do
        expect(subject.delayed_candle_lighting?).to be false
      end
    end
    context 'for a shabbos followed by yom tov' do
      let(:date){ '2019-06-08' }
      it 'returns true' do
        expect(subject.delayed_candle_lighting?).to be true
      end
    end
  end

  describe '#erev_yom_tov?' do
    context 'outside israel' do
      let(:erev_yom_tov_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.erev_yom_tov? }).values.flatten }
      it 'detects the expected days' do
        expect(erev_yom_tov_days).to eq ['7-9', '7-14', '7-21', '1-14', '1-20', '3-5', '6-29']
      end
    end
    context 'in israel' do
      let(:erev_yom_tov_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.erev_yom_tov? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expect(erev_yom_tov_days).to eq ['7-9', '7-14', '7-21', '1-14', '1-20', '3-5', '6-29']
      end
    end
  end

  describe '#yom_tov_sheni?' do
    context 'outside israel' do
      let(:yom_tov_sheni_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov_sheni? }).values.flatten }
      it 'detects the expected days' do
        expect(yom_tov_sheni_days).to eq ['7-2', '7-16', '7-23', '1-16', '1-22', '3-7']
      end
    end
    context 'in israel' do
      let(:yom_tov_sheni_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.yom_tov_sheni? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expect(yom_tov_sheni_days).to eq ['7-2']
      end
    end
  end

  describe '#erev_yom_tov_sheni?' do
    context 'outside israel' do
      let(:erev_yom_tov_sheni_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.erev_yom_tov_sheni? }).values.flatten }
      it 'detects the expected days' do
        expect(erev_yom_tov_sheni_days).to eq ['7-1', '7-15', '7-22', '1-15', '1-21', '3-6']
      end
    end
    context 'in israel' do
      let(:erev_yom_tov_sheni_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.erev_yom_tov_sheni? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expect(erev_yom_tov_sheni_days).to eq ['7-1']
      end
    end
  end

  describe '#chol_hamoed?' do
    context 'outside israel' do
      let(:chol_hamoed_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.chol_hamoed? }).values.flatten }
      it 'detects the expected days' do
        expect(chol_hamoed_days).to eq ['7-17', '7-18', '7-19', '7-20', '7-21', '1-17', '1-18', '1-19', '1-20']
      end
    end
    context 'in israel' do
      let(:chol_hamoed_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.chol_hamoed? }, in_israel: true).values.flatten }
      it 'detects the expected days' do
        expect(chol_hamoed_days).to eq ['7-16', '7-17', '7-18', '7-19', '7-20', '7-21', '1-16', '1-17', '1-18', '1-19', '1-20']
      end
    end
  end

  describe '#taanis?' do
    let(:fast_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.taanis? }).values.flatten }
    it 'detects the expected days' do
      expect(fast_days).to eq ['7-3', '7-10', '10-10', '13-13', '4-17', '5-9']
    end
  end

  describe '#rosh_chodesh?' do
    let(:rosh_chodesh_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.rosh_chodesh? }).values.flatten }
    it 'detects the expected days' do
      expect(rosh_chodesh_days).to eq ['7-30', '8-1', '8-30', '9-1', '9-30', '10-1',
                                       '11-1', '11-30', '12-1', '12-30', '13-1', '1-1', '1-30',
                                       '2-1', '3-1', '3-30', '4-1', '5-1', '5-30', '6-1']
    end
  end

  describe '#erev_rosh_chodesh?' do
    let(:erev_rosh_chodesh_days){ all_days_matching(leap_shabbos_shaleim, ->(c){ c.erev_rosh_chodesh? }).values.flatten }
    it 'detects the expected days' do
      expect(erev_rosh_chodesh_days).to eq ['7-29', '8-29', '9-29', '10-29', '11-29', '12-29', '13-29',
                                            '1-29', '2-29', '3-29', '4-29', '5-29']
    end
  end

  describe '#chanukah?' do
    context 'for chaseirim year' do
      let(:chanukah_days){ all_days_matching(standard_monday_chaseir, ->(c){ c.chanukah? }).values.flatten }
      it 'detects the expected days' do
        expect(chanukah_days).to eq chanukah_for_chaseir
      end
    end
    context 'for other years' do
      let(:chanukah_days){ all_days_matching(standard_tuesday_kesidran, ->(c){ c.chanukah? }).values.flatten }
      it 'detects the expected days' do
        expect(chanukah_days).to eq standard_significant_days[:chanukah]
      end
    end
  end

  describe '#day_of_chanukah' do
    context 'for the days of chanukah' do
      context 'for chaseirim years' do
        let(:year){ standard_monday_chaseir }
        let(:month_days){ chanukah_for_chaseir.map{|d| d.split('-').map(&:to_i) } }
        it 'calculates correctly' do
          results = month_days.map{|m, d| Zmanim::HebrewCalendar::JewishCalendar.new(year, m, d).day_of_chanukah }
          expect(results).to eq((1..8).to_a)
        end
      end
      context 'for other years' do
        let(:year){ standard_tuesday_kesidran }
        let(:month_days){ standard_significant_days[:chanukah].map{|d| d.split('-').map(&:to_i) } }
        it 'calculates correctly' do
          results = month_days.map{|m, d| Zmanim::HebrewCalendar::JewishCalendar.new(year, m, d).day_of_chanukah }
          expect(results).to eq((1..8).to_a)
        end
      end
    end
    context 'for days that are not chanukah' do
      let(:calendar){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 7, 1) }
      it 'returns nil' do
        expect(calendar.day_of_chanukah).to be_nil
      end
    end
  end

  describe '#day_of_omer' do
    context 'for days of the omer' do
      let(:calendar){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 1, 16) }
      it 'calculates correctly' do
        results = 49.times.map do |i|
          omer = calendar.day_of_omer
          calendar.forward!
          omer
        end
        expect(results).to eq((1..49).to_a)
      end
    end
    context 'for days not during the omer' do
      let(:calendar){ Zmanim::HebrewCalendar::JewishCalendar.new(standard_monday_chaseir, 7, 1) }
      it 'returns nil' do
        expect(calendar.day_of_omer).to be_nil
      end
    end
  end

  describe '#molad_as_datetime' do
    let(:expected_offset){ [2, 20, 56.496]}  # UTC is 2:20:56.496 behind Jerusalem Local Time
    subject { Zmanim::HebrewCalendar::JewishCalendar.new(5776, 8, 1) }
    it 'calculates the molad as UTC' do
      hours, minutes, chalakim = 5, 51, 10
      seconds = (chalakim * 10) / 3.0
      hours, minutes, seconds = [hours, minutes, seconds].zip(expected_offset).map{|t, o| t - o}
      partial_day = (((((seconds / 60) + minutes) / 60) + hours) / 24)
      expected_molad = DateTime.new(2015, 10, 13) + partial_day
      expect(subject.molad_as_datetime).to eq expected_molad
    end
  end

  describe '#sof_zman_kiddush_levana_between_moldos' do
    subject { Zmanim::HebrewCalendar::JewishCalendar.new(5776, 8, 1) }
    let(:first_molad){ subject.molad_as_datetime }
    let(:next_molad){ Zmanim::HebrewCalendar::JewishCalendar.new(5776, 9, 1).molad_as_datetime }
    it 'calculates the midpoint between this molad and the next' do
      expected_offset = (next_molad - first_molad) / 2.0
      expect(subject.sof_zman_kiddush_levana_between_moldos).to eq first_molad + expected_offset
    end
  end

  describe '#end_of_week' do
    context 'for a Sunday' do
      subject { Zmanim::HebrewCalendar::JewishCalendar.new(5779, 8, 5) }
      it 'returns the upcoming shabbos' do
        expect(subject.end_of_week).to eq subject + 6
      end
    end
    context 'for a Shabbos' do
      subject { Zmanim::HebrewCalendar::JewishCalendar.new(5779, 8, 4) }
      it 'returns the same day' do
        expect(subject.end_of_week).to eq subject
      end
    end
    context 'for the middle of the week' do
      subject { Zmanim::HebrewCalendar::JewishCalendar.new(5779, 8, 1) }
      it 'returns the upcoming shabbos' do
        expect(subject.end_of_week).to eq subject + 3
      end
    end
  end

  describe 'limudim' do
    let(:date){ Date.parse('2017-12-28') }
    subject{ Zmanim::HebrewCalendar::JewishCalendar.new(date) }
    describe '#daf_yomi_bavli' do
      it 'returns the appropriate limud' do
        result = subject.daf_yomi_bavli
        expect(result.description).to eq 'shevuos 30'
      end
    end
    describe '#daf_yomi_yerushalmi' do
      it 'returns the appropriate limud' do
        result = subject.daf_yomi_yerushalmi
        expect(result.description).to eq 'bava_metzia 33'
      end
    end
    describe '#daf_hashavua_bavli' do
      it 'returns the appropriate limud' do
        result = subject.daf_hashavua_bavli
        expect(result.description).to eq 'rosh_hashanah 26'
      end
    end
    describe '#parshas_hashavua' do
      subject { Zmanim::HebrewCalendar::JewishCalendar.new(5775, 1, 27) }
      context 'outside israel' do
        it 'returns the appropriate limud' do
          result = subject.parshas_hashavua
          expect(result.description).to eq 'shemini'
        end
      end
      context 'in israel' do
        it 'returns the appropriate limud' do
          subject.in_israel = true
          result = subject.parshas_hashavua
          expect(result.description).to eq 'tazria - metzora'
        end
      end
      context 'for this week only' do
        context 'for a standard shabbos' do
          subject { Zmanim::HebrewCalendar::JewishCalendar.new(5779, 7, 1) }
          it 'returns the appropriate limud' do
            result = subject.parshas_hashavua(current_week_only: true)
            expect(result.description).to eq 'vayeilech'
          end
        end
        context 'for a week where weekly parsha is not read' do
          subject { Zmanim::HebrewCalendar::JewishCalendar.new(5779, 7, 17) }
          it 'returns a blank limud' do
            result = subject.parshas_hashavua(current_week_only: true)
            expect(result.description).to eq ''
          end
        end
        context 'for early in week where parsha is read mid-week' do
          subject { Zmanim::HebrewCalendar::JewishCalendar.new(5779, 7, 21) }
          it 'returns a blank limud' do
            result = subject.parshas_hashavua(current_week_only: true)
            expect(result.description).to eq 'vezos_haberacha'
          end
        end
      end
    end
    describe '#tehillim_portion' do
      it 'returns the appropriate limud' do
        result = subject.tehillim_portion
        expect(result.description).to eq '55 - 59'
      end
    end
    describe '#mishna_yomis' do
      it 'returns the appropriate limud' do
        result = subject.mishna_yomis
        expect(result.description).to eq 'megillah 3:4-5'
      end
    end
    describe '#pirkei_avos' do
      subject { Zmanim::HebrewCalendar::JewishCalendar.new(5775, 1, 30) }
      it 'returns the appropriate limud' do
        result = subject.pirkei_avos
        expect(result.description).to eq '2'
      end
      context 'on a Pesach edge' do
        subject { Zmanim::HebrewCalendar::JewishCalendar.new(5775, 1, 22) }
        context 'outside israel' do
          it 'recognizes Pesach as outside the cycle' do
            result = subject.pirkei_avos
            expect(result).to be_nil
          end
        end
        context 'in israel' do
          it 'returns the appropriate limud' do
            subject.in_israel = true
            result = subject.pirkei_avos
            expect(result.description).to eq '1'
          end
        end
      end
    end
  end

  describe '#tefillah_additions' do
    let(:summer_date){ [standard_monday_chaseir, 2, 5] }
    let(:winter_date){ [standard_monday_chaseir, 10, 5] }
    subject { Zmanim::HebrewCalendar::JewishCalendar.new }
    context 'for regular days' do
      before { subject.set_jewish_date(*summer_date) }
      it 'does not include special tefillos' do
        additions = subject.tefilah_additions
        expect(additions).to_not include :atah_yatzarta, :yaaleh_veyavo, :al_hanissim, :borchi_nafshi
      end
    end
    context 'for yaaleh veyavo days' do
      before { subject.set_jewish_date(standard_monday_chaseir, 7, 17) }
      it 'includes yaaleh veyavo' do
        expect(subject.tefilah_additions).to include :yaaleh_veyavo
      end
    end
    context 'for a regular shabbos' do
      before { subject.set_jewish_date(standard_monday_chaseir, 1, 5) }
      it 'does not include atah yatzarta' do
        expect(subject.day_of_week).to eq 7
        expect(subject.tefilah_additions).to_not include :atah_yatzarta
      end
    end
    context 'for rosh chodesh' do
      before { subject.set_jewish_date(standard_monday_chaseir, 1, 1) }
      it 'does not include atah yatzarta' do
        expect(subject.day_of_week).to_not eq 7
        expect(subject.tefilah_additions).to_not include :atah_yatzarta
      end
      it 'includes borchi nafshi' do
        expect(subject.tefilah_additions).to include :borchi_nafshi
      end
      context 'that falls on shabbos' do
        before { subject.set_jewish_date(standard_monday_chaseir, 11, 1) }
        it 'includes atah yatzarta' do
          expect(subject.day_of_week).to eq 7
          expect(subject.tefilah_additions).to include :atah_yatzarta
        end
      end
    end
    context 'for Purim' do
      before { subject.set_jewish_date(standard_monday_chaseir, 12, 14) }
      it 'includes al hanissim' do
        expect(subject.tefilah_additions).to include :al_hanissim
      end
    end
    context 'for Shushan Purim' do
      before { subject.set_jewish_date(standard_monday_chaseir, 12, 15) }
      it 'does not include al hanissim' do
        expect(subject.tefilah_additions).to_not include :al_hanissim
      end
    end
    context 'for ashkenaz' do
      context 'in the summer' do
        before { subject.set_jewish_date(*summer_date) }
        it 'does not include mashiv haruach' do
          expect(subject.tefilah_additions).to_not include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions).to_not include :morid_hatal
        end
        it 'includes vesein beracha' do
          expect(subject.tefilah_additions).to include :vesein_beracha
        end
        it 'does not include vesein tal umatar' do
          expect(subject.tefilah_additions).to_not include :vesein_tal_umatar
        end
      end
      context 'in the winter' do
        before { subject.set_jewish_date(*winter_date) }
        it 'includes mashiv haruach' do
          expect(subject.tefilah_additions).to include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions).to_not include :morid_hatal
        end
        it 'includes vesein tal umatar' do
          expect(subject.tefilah_additions).to include :vesein_tal_umatar
        end
        it 'does not include vesein beracha' do
          expect(subject.tefilah_additions).to_not include :vesein_beracha
        end
      end
      context 'when switching to mashiv_haruach' do
        before { subject.set_jewish_date(standard_monday_chaseir, 7, 22) }
        it 'includes start mashiv haruach indicator' do
          expect(subject.tefilah_additions).to include :begin_mashiv_haruach
        end
        it 'does not include mashiv haruach' do
          expect(subject.tefilah_additions).to_not include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions).to_not include :morid_hatal
        end
      end
      context 'when switching out of mashiv_haruach' do
        before { subject.set_jewish_date(standard_monday_chaseir, 1, 15) }
        it 'includes end mashiv haruach indicator' do
          expect(subject.tefilah_additions).to include :end_mashiv_haruach
        end
        it 'does not include start morid hatal indicator' do
          expect(subject.tefilah_additions).to_not include :begin_morid_hatal
        end
        it 'does not include mashiv haruach' do
          expect(subject.tefilah_additions).to_not include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions).to_not include :morid_hatal
        end
      end
    end
    context 'for sefard' do
      context 'in the summer' do
        before { subject.set_jewish_date(*summer_date) }
        it 'does not include mashiv haruach' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :mashiv_haruach
        end
        it 'includes morid hatal' do
          expect(subject.tefilah_additions(nusach: :sefard)).to include :morid_hatal
        end
        it 'includes vesein beracha' do
          expect(subject.tefilah_additions(nusach: :sefard)).to include :vesein_beracha
        end
        it 'does not include vesein tal umatar' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :vesein_tal_umatar
        end
      end
      context 'in the winter' do
        before { subject.set_jewish_date(*winter_date) }
        it 'includes mashiv haruach' do
          expect(subject.tefilah_additions(nusach: :sefard)).to include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :morid_hatal
        end
        it 'includes vesein tal umatar' do
          expect(subject.tefilah_additions(nusach: :sefard)).to include :vesein_tal_umatar
        end
        it 'does not include vesein beracha' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :vesein_beracha
        end
      end
      context 'when switching to mashiv_haruach' do
        before { subject.set_jewish_date(standard_monday_chaseir, 7, 22) }
        it 'includes start mashiv haruach indicator' do
          expect(subject.tefilah_additions(nusach: :sefard)).to include :begin_mashiv_haruach
        end
        it 'does not include mashiv haruach' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :morid_hatal
        end
      end
      context 'when switching out of mashiv_haruach' do
        before { subject.set_jewish_date(standard_monday_chaseir, 1, 15) }
        it 'includes start morid hatal indicator' do
          expect(subject.tefilah_additions(nusach: :sefard)).to include :begin_morid_hatal
        end
        it 'does not include end mashiv haruach indicator' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :end_mashiv_haruach
        end
        it 'does not include mashiv haruach' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :mashiv_haruach
        end
        it 'does not include morid hatal' do
          expect(subject.tefilah_additions(nusach: :sefard)).to_not include :morid_hatal
        end
      end
    end
    context 'for walled cities' do
      context 'for Shushan Purim' do
        before { subject.set_jewish_date(standard_monday_chaseir, 12, 15) }
        it 'includes al hanissim' do
          expect(subject.tefilah_additions(walled_city: true)).to include :al_hanissim
        end
      end
      context 'for Purim' do
        before { subject.set_jewish_date(standard_monday_chaseir, 12, 14) }
        it 'does not include al hanissim' do
          expect(subject.tefilah_additions(walled_city: true)).to_not include :al_hanissim
        end
      end
    end
  end

  describe '#significant_shabbos' do
    let(:significant_shabbosos){ all_days_matching(year, ->(c){ c.significant_shabbos }) }
    context 'standard year, Monday RH, chaseirim' do
      let(:year){ standard_monday_chaseir }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-6'],
          parshas_shekalim: ['11-29'],
          parshas_zachor: ['12-13'],
          parshas_parah: ['12-20'],
          parshas_hachodesh: ['12-27'],
          shabbos_hagadol: ['1-12']
        })
      end
    end
    context 'standard year, Monday RH, shelaimim' do
      let(:year){ standard_monday_shaleim }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-6'],
          parshas_shekalim: ['11-27'],
          parshas_zachor: ['12-11'],
          parshas_parah: ['12-18'],
          parshas_hachodesh: ['12-25'],
          shabbos_hagadol: ['1-10']
        })
      end
    end
    context 'standard year, Tuesday RH, kesidran' do
      let(:year){ standard_tuesday_kesidran }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-5'],
          parshas_shekalim: ['11-27'],
          parshas_zachor: ['12-11'],
          parshas_parah: ['12-18'],
          parshas_hachodesh: ['12-25'],
          shabbos_hagadol: ['1-10']
        })
      end
    end
    context 'standard year, Thursday RH, kesidran' do
      let(:year){ standard_thursday_kesidran }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-3'],
          parshas_shekalim: ['11-25'],
          parshas_zachor: ['12-9'],
          parshas_parah: ['12-23'],
          parshas_hachodesh: ['1-1'],
          shabbos_hagadol: ['1-8']
        })
      end
    end
    context 'standard year, Thursday RH, shelaimim' do
      let(:year){ standard_thursday_shaleim }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-3'],
          parshas_shekalim: ['12-1'],
          parshas_zachor: ['12-8'],
          parshas_parah: ['12-22'],
          parshas_hachodesh: ['12-29'],
          shabbos_hagadol: ['1-14']
        })
      end
    end
    context 'standard year, Shabbos RH, chaseirim' do
      let(:year){ standard_shabbos_chaseir }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-8'],
          parshas_shekalim: ['12-1'],
          parshas_zachor: ['12-8'],
          parshas_parah: ['12-22'],
          parshas_hachodesh: ['12-29'],
          shabbos_hagadol: ['1-14']
        })
      end
    end
    context 'standard year, Shabbos RH, shelaimim' do
      let(:year){ standard_shabbos_shaleim }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-8'],
          parshas_shekalim: ['11-29'],
          parshas_zachor: ['12-13'],
          parshas_parah: ['12-20'],
          parshas_hachodesh: ['12-27'],
          shabbos_hagadol: ['1-12']
        })
      end
    end

    context 'leap year, Monday RH, chaseirim' do
      let(:year){ leap_monday_chaseir }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-6'],
          parshas_shekalim: ['12-27'],
          parshas_zachor: ['13-11'],
          parshas_parah: ['13-18'],
          parshas_hachodesh: ['13-25'],
          shabbos_hagadol: ['1-10']
        })
      end
    end
    context 'leap year, Monday RH, shelaimim' do
      let(:year){ leap_monday_shaleim }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-6'],
          parshas_shekalim: ['12-25'],
          parshas_zachor: ['13-9'],
          parshas_parah: ['13-23'],
          parshas_hachodesh: ['1-1'],
          shabbos_hagadol: ['1-8']
        })
      end
    end
    context 'leap year, Tuesday RH, kesidran' do
      let(:year){ leap_tuesday_kesidran }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-5'],
          parshas_shekalim: ['12-25'],
          parshas_zachor: ['13-9'],
          parshas_parah: ['13-23'],
          parshas_hachodesh: ['1-1'],
          shabbos_hagadol: ['1-8']
        })
      end
    end
    context 'leap year, Thursday RH, chaseirim' do
      let(:year){ leap_thursday_chaseir }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-3'],
          parshas_shekalim: ['13-1'],
          parshas_zachor: ['13-8'],
          parshas_parah: ['13-22'],
          parshas_hachodesh: ['13-29'],
          shabbos_hagadol: ['1-14']
        })
      end
    end
    context 'leap year, Thursday RH, shelaimim' do
      let(:year){ leap_thursday_shaleim }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-3'],
          parshas_shekalim: ['12-29'],
          parshas_zachor: ['13-13'],
          parshas_parah: ['13-20'],
          parshas_hachodesh: ['13-27'],
          shabbos_hagadol: ['1-12']
        })
      end
    end
    context 'leap year, Shabbos RH, chaseirim' do
      let(:year){ leap_shabbos_chaseir }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-8'],
          parshas_shekalim: ['12-29'],
          parshas_zachor: ['13-13'],
          parshas_parah: ['13-20'],
          parshas_hachodesh: ['13-27'],
          shabbos_hagadol: ['1-12']
        })
      end
    end
    context 'leap year, Shabbos RH, shelaimim' do
      let(:year){ leap_shabbos_shaleim }
      it 'contains the expected significant shabbosos' do
        expect(significant_shabbosos).to eq({
          shabbos_shuva: ['7-8'],
          parshas_shekalim: ['12-27'],
          parshas_zachor: ['13-11'],
          parshas_parah: ['13-18'],
          parshas_hachodesh: ['13-25'],
          shabbos_hagadol: ['1-10']
        })
      end
    end
  end

  describe '#shabbos_mevorchim?' do
    let(:matches){ all_days_matching(leap_monday_shaleim, ->(c){ c.shabbos_mevorchim? }).values.first }
    it 'returns the expected days' do
      expect(matches).to eq ['7-27', '8-25', '9-23', '10-28', '11-27', '12-25', '13-23',
                             '1-29', '2-27', '3-26', '4-24', '5-23']
    end
  end

  describe '#mashiv_haruach_starts?' do
    let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.mashiv_haruach_starts? }).values.first }
    it 'returns the expected days' do
      expect(matches).to eq ['7-22']
    end
  end

  describe '#mashiv_haruach_ends?' do
    let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.mashiv_haruach_ends? }).values.first }
    it 'returns the expected days' do
      expect(matches).to eq ['1-15']
    end
  end

  describe '#mashiv_haruach?' do
    let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.mashiv_haruach? }).values.first }
    it 'returns the expected days' do
      expect(matches).to include '7-22', '7-23', '1-14', '1-15', '11-25', '1-5'   # 1-5 is shabbos
      expect(matches).to_not include '7-21', '1-16', '3-7'
    end
  end

  describe '#morid_hatal?' do
    let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.morid_hatal? }).values.first }
    it 'returns the expected days' do
      expect(matches).to include '7-21', '7-22', '1-15', '1-16', '3-7', '7-6'    # 7-6 is shabbos
      expect(matches).to_not include '7-23', '1-14', '11-25'
    end
  end

  describe '#vesein_tal_umatar?' do
    let(:matches){ all_days_matching(5777, ->(c){ c.vesein_tal_umatar? }).values.first }
    it 'returns the expected days' do
      # 9-5 represents December 5
      expect(matches).to include '9-5', '11-25', '1-13', '1-14'
      expect(matches).to_not include '9-4', '1-17', '3-8', '1-5'                        # 1-5 is shabbos
    end
    context 'preceding a gregorian leap year' do
      let(:matches){ all_days_matching(5772, ->(c){ c.vesein_tal_umatar? }).values.first }
      it 'returns the expected days' do
        # 9-10 represents December 6
        expect(matches).to include '9-10', '11-24', '1-13', '1-14'
        expect(matches).to_not include '9-9', '1-17', '3-8'
      end
    end
    context 'in israel' do
      let(:matches){ all_days_matching(5777, ->(c){ c.vesein_tal_umatar? }, in_israel: true).values.first }
      it 'returns the expected days' do
        expect(matches).to include '8-7', '11-25', '1-13', '1-14'
        expect(matches).to_not include '8-6', '1-16', '3-8'
      end
    end
  end

  describe '#vesein_tal_umatar_starts_tonight?' do
    context 'when December 4th falls on most days' do
      let(:matches){ all_days_matching(5779, ->(c){ c.vesein_tal_umatar_starts_tonight? }).values.first }
      it 'returns the expected day' do
        expect(matches).to eq ['9-26']   # 12-4
      end
    end
    context 'when December 4th falls on Friday' do
      let(:matches){ all_days_matching(5770, ->(c){ c.vesein_tal_umatar_starts_tonight? }).values.first }
      it 'returns the expected day' do
        expect(matches).to eq ['9-18']   # 12-5
      end
    end
    context 'preceding a Gregorian leap year' do
      context 'when December 5th falls on most days' do
        let(:matches){ all_days_matching(5776, ->(c){ c.vesein_tal_umatar_starts_tonight? }).values.first }
        it 'returns the expected day' do
          expect(matches).to eq ['9-23']   # 12-5
        end
      end
      context 'when December 5th falls on Friday' do
        let(:matches){ all_days_matching(5764, ->(c){ c.vesein_tal_umatar_starts_tonight? }).values.first }
        it 'returns the expected day' do
          expect(matches).to eq ['9-11']   # 12-6
        end
      end
    end
    context 'in israel' do
      # 6 Cheshvan can never fall on Friday, so it will always be the starting night of Vesein Tal Umatar
      let(:matches){ all_days_matching(5777, ->(c){ c.vesein_tal_umatar_starts_tonight? }, in_israel: true).values.first }
      it 'returns the expected day' do
        expect(matches).to eq ['8-6']
      end
    end
  end

  describe '#vesein_beracha?' do
    let(:matches){ all_days_matching(5777, ->(c){ c.vesein_beracha? }).values.first }
    it 'returns the expected days' do
      # 9-5 represents December 5
      expect(matches).to include '9-4', '1-17', '3-8', '7-7'
      expect(matches).to_not include '9-5', '11-25', '1-13', '1-14', '7-6'              # 7-6 is shabbos
    end
    context 'preceding a gregorian leap year' do
      let(:matches){ all_days_matching(5772, ->(c){ c.vesein_beracha? }).values.first }
      it 'returns the expected days' do
        # 9-10 represents December 6
        expect(matches).to include '9-9', '1-17', '3-8'
        expect(matches).to_not include '9-10', '11-24', '1-13', '1-14'
      end
    end
    context 'in israel' do
      let(:matches){ all_days_matching(5777, ->(c){ c.vesein_beracha? }, in_israel: true).values.first }
      it 'returns the expected days' do
        expect(matches).to include '8-6', '1-16', '3-7'
        expect(matches).to_not include '8-7', '11-24', '1-13', '1-14'
      end
    end
  end

  describe '#yaaleh_veyavo?' do
    let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.yaaleh_veyavo? }).values.first }
    it 'returns the expected days' do
      expect(matches).to eq ['7-1', '7-2', '7-10', '7-15', '7-16', '7-17', '7-18', '7-19', '7-20', '7-21', '7-22', '7-23', '7-30',
                             '8-1', '9-1', '10-1', '11-1', '11-30', '12-1', '1-1',
                             '1-15', '1-16', '1-17', '1-18', '1-19', '1-20', '1-21', '1-22', '1-30', '2-1', '3-1',
                             '3-6', '3-7', '3-30', '4-1', '5-1', '5-30', '6-1']
    end
    context 'in israel' do
      let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.yaaleh_veyavo? }, in_israel: true).values.first }
      it 'returns the expected days' do
        expect(matches).to eq ['7-1', '7-2', '7-10', '7-15', '7-16', '7-17', '7-18', '7-19', '7-20', '7-21', '7-22', '7-30',
                               '8-1', '9-1', '10-1', '11-1', '11-30', '12-1', '1-1',
                               '1-15', '1-16', '1-17', '1-18', '1-19', '1-20', '1-21', '1-30', '2-1', '3-1',
                               '3-6', '3-30', '4-1', '5-1', '5-30', '6-1']
      end
    end
  end
  describe '#al_hanissim?' do
    let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.al_hanissim? }).values.first }
    it 'returns the expected days' do
      expect(matches).to eq ['9-25', '9-26', '9-27', '9-28', '9-29', '10-1', '10-2', '10-3', '12-14']
    end
    context 'for walled cities' do
      let(:matches){ all_days_matching(standard_monday_chaseir, ->(c){ c.al_hanissim?(true) }).values.first }
      it 'returns the expected days' do
        expect(matches).to eq ['9-25', '9-26', '9-27', '9-28', '9-29', '10-1', '10-2', '10-3', '12-15']
      end
    end
  end
end
