# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- `JewishCalendar#taanis_bechorim?` detects Taanis Bechorim for a given date

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
