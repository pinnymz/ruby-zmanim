# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Pirkei Avos limudim calculation
- Support for explicit skip_unit (used by DafYomiYerushalmi)
- CHANGELOG (this file :) )
### Changed
- Refactored skip_interval to generic limud detection
### Fixed
- Cycle detection falsely identifies dates between cycle windows as belonging to a prior cycle
- Load sequence can't find Zmanim module when loaded externally

## [0.1.0] - 2017-01-09 (Original release)
### Added
- Port of KosherJava/zmanim library, primary functionality
- Limudim calculation framework
- Weekly Parsha, Tehillim (Month cycle), Mishna Yomis limudim calculation
