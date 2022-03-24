# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2022-03-24
### Added
- `JewishCalendar#taanis_bechorim?` detects Taanis Bechorim for a given date
- `JewishCalendar#pesach` returns the date for start of Pesach for any year, or the next upcoming event
- `JewishCalendar#pesach_sheni` returns the date for Pesach Sheni for any year, or the next upcoming event
- `JewishCalendar#lag_baomer` returns the date for Lag Baomer for any year, or the next upcoming event
- `JewishCalendar#shavuos` returns the date for start of Shavuos for any year, or the next upcoming event
- `JewishCalendar#seventeen_of_tammuz` returns the date for Seventeen of Tammuz for any year, or the next upcoming event
- `JewishCalendar#tisha_beav` returns the date for Tisha Beav for any year, or the next upcoming event
- `JewishCalendar#tu_beav` returns the date for Tu Beav for any year, or the next upcoming event
- `JewishCalendar#rosh_hashana` returns the date for start of Rosh Hashana for any year, or the next upcoming event
- `JewishCalendar#tzom_gedalyah` returns the date for Tzom Gedalyah for any year, or the next upcoming event
- `JewishCalendar#yom_kippur` returns the date for Yom Kippur for any year, or the next upcoming event
- `JewishCalendar#succos` returns the date for start of Succos for any year, or the next upcoming event
- `JewishCalendar#chanukah` returns the date for start of Chanukah for any year, or the next upcoming event
- `JewishCalendar#tenth_of_teves` returns the date for Tenth of Teves for any year, or the next upcoming event
- `JewishCalendar#tu_beshvat` returns the date for Tu Beshvat for any year, or the next upcoming event
- `JewishCalendar#purim` returns the date for Purim for any year, or the next upcoming event
- `JewishCalendar#rosh_chodesh` returns the date for Rosh Chodesh for any month, or the next upcoming event
- `JewishCalendar#shabbos_mevorchim` returns the date for Shabbos Mevorchim for any month, or the next upcoming event
- `JewishCalendar#vesein_tal_umatar_start` returns the date for start of reciting Vesein Tal Umatar for any year, or the next upcoming event
- `JewishCalendar#vesein_tal_umatar_starts?` detects if reciting of Vesein Tal Umatar started today
### Changed
- Upgraded dependency versions to address known security vulnerabilities:
  - `rake` to 13.0.6
  - `bundler` to 2.3.10 
### Fixed
- `JewishCalendar#vesein_tal_umatar?` and `JewishCalendar#vesein_tal_umatar_starts_tonight?` now auto-adjust for any calendar year, previously only valid for 20th/21st century

## [0.4.0] - 2020-10-13
### Added
- `JewishCalendar#end_of_week` returns Shabbos for this week
- Parshas Hashavua modifier to return blank Limud if the standard Parsha is not read this Shabbos
- Daf Hashavua calculator
### Changed
- Refactor kviah calculation logic to JewishDate
- Remove formatter dependency for Parsha calculator
### Fixed
- Added Lag B'Omer as significant day / yom tov
- Fixed Lag B'Omer spelling for english formatted omer

## [0.3.0] - 2018-09-17
### Added
- Elevations used in shaos zmanios calculations if use_elevation property is set
- Hanetz and Shkia methods will use the appropriate calculation based on use_elevation setting
- Support Alos and Tzais offset using temporal minutes
- Various Assur Bemelacha related methods for calendar dates using JewishCalendar, 
  as well as point-in-time using ZmanimCalendar.
- Methods to determine Shabbos Mevorchim, first night of Vesein Tal Umatar,
  and delayed candle lighting

## [0.2.2] - 2018-08-31
### Fixed
- Typo in formatted Masechtos
- Additional load sequence issues

## [0.2.1] - 2018-04-30
### Fixed
- Additional load sequence issues 

## [0.2.0] - 2018-04-22
### Added
- Pirkei Avos limudim calculation
- Support for explicit skip_unit (used by DafYomiYerushalmi)
- CHANGELOG (this file :) )
### Changed
- Refactored skip_interval to generic limud detection
### Fixed
- Cycle detection falsely identifies dates between cycle windows as belonging to a prior cycle
- Load sequence can't find Zmanim module when loaded externally

## [0.1.0] - 2018-01-09 (Original release)
### Added
- Port of KosherJava/zmanim library, primary functionality
- Limudim calculation framework
- Weekly Parsha, Tehillim (Month cycle), Mishna Yomis limudim calculation
