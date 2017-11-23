require 'spec_helper'

describe Zmanim::HebrewCalendar::JewishCalendar, hebrew_calendar: true do
  let(:standard_monday_chaseir){5777}
  let(:standard_monday_shaleim){5759}
  let(:standard_tuesday_kesidran){5762}
  let(:standard_thursday_kesidran){5778}
  let(:standard_thursday_shaleim){5754}
  let(:standard_shabbos_chaseir){5781}
  let(:standard_shabbos_shaleim){5770}
  let(:leap_monday_chaseir){5749}
  let(:leap_monday_shaleim){5776}
  let(:leap_tuesday_kesidran){5755}
  let(:leap_thursday_chaseir){5765}
  let(:leap_thursday_shaleim){5774}
  let(:leap_shabbos_chaseir){5757}
  let(:leap_shabbos_shaleim){5763}
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
end
