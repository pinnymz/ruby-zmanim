# Zmanim

A Ruby library for Zmanim.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'zmanim'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zmanim

## Usage

Some common examples include...

#### Zmanim calculations

```ruby

# Initialize a new ZmanimCalendar object, defaults to using today's date in GMT, located at Greenwich, England
zmanim = Zmanim::ZmanimCalendar.new
#=> #<Zmanim::ZmanimCalendar:0x007fa73c2ec7d8 @geo_location=#<Zmanim::Util::GeoLocation:0x007fa73c2ec710 @location_name="Greenwich, England", @latitude=51.4772, @longitude=0, @time_zone=#<TZInfo::DataTimezone: GMT>, @elevation=0>, @date=#<Date: 2018-01-09 ((2458128j,0s,0n),+0s,2299161j)>, @astronomical_calculator=#<Zmanim::Util::NOAACalculator:0x007fa73c24e920>, @candle_lighting_offset=18>

# Calculate the sunset for today at that location
zmanim.sunset
#=> #<DateTime: 2018-01-08T16:10:12+00:00 ((2458127j,58212s,336684777n),+0s,2299161j)>        

# Prepare a new location
location = Zmanim::Util::GeoLocation.new('Lakewood, NJ', 40.0721087, -74.2400243, 'US/Eastern', elevation: 15)
#=> #<Zmanim::Util::GeoLocation:0x007fa73c1c5008 @location_name="Lakewood, NJ", @latitude=40.0721087, @longitude=-74.2400243, @time_zone=#<TZInfo::DataTimezone: US/Eastern>, @elevation=15> 

# Initialize a new ZmanimCalendar object, passing a specific location and date
zmanim = Zmanim::ZmanimCalendar.new(geo_location: location, date: Date.parse('2017-12-15'))
#=> #<Zmanim::ZmanimCalendar:0x007fa73c33ee98 @geo_location=#<Zmanim::Util::GeoLocation:0x007fa73c1c5008 @location_name="Lakewood, NJ", @latitude=40.0721087, @longitude=-74.2400243, @time_zone=#<TZInfo::DataTimezone: US/Eastern>, @elevation=15>, @date=#<Date: 2017-12-15 ((2458103j,0s,0n),+0s,2299161j)>, @astronomical_calculator=#<Zmanim::Util::NOAACalculator:0x007fa73c33ee48>, @candle_lighting_offset=18>

# Calculate Sof Zman Krias Shma for that location/date per the opinion of GR"A
zmanim.sof_zman_shma_gra
#=> #<DateTime: 2017-12-15T09:32:09-05:00 ((2458103j,52329s,383390214n),-18000s,2299161j)>
```

#### Date Calculations

```ruby
# Initialize a new JewishDate object with today's date 
date = Zmanim::HebrewCalendar::JewishDate.new
# => #<Zmanim::HebrewCalendar::JewishDate:0x007fa73c2976e8 @gregorian_date=#<Date: 2018-01-09 ((2458128j,0s,0n),+0s,-Infj)>, @absolute_date=736703, @day_of_week=3, @molad_chalakim=0, @molad_minutes=0, @molad_hours=0, @jewish_year=5778, @jewish_month=10, @jewish_day=22>

# Initialize a HebrewDateFormatter object
formatter = Zmanim::HebrewCalendar::HebrewDateFormatter.new
#=> #<Zmanim::HebrewCalendar::HebrewDateFormatter:0x007fa73c2ec558 ...>

# Format the jewish date
formatter.format(date)
#=> "22 Teves, 5778" 

# Change the formatter to use hebrew
formatter.hebrew_format = true
formatter.format(date)
#=> "כ״ב טבת תשע״ח"  
```

#### Jewish Calendar occasions

```ruby
# Initialize a new JewishCalendar object with a specific Jewish date
calendar = Zmanim::HebrewCalendar::JewishCalendar.new(5778, 7, 4)
# => #<Zmanim::HebrewCalendar::JewishCalendar:0x007fa73c256ad0 @gregorian_date=#<Date: 2017-09-24 ((2458021j,0s,0n),+0s,-Infj)>, @absolute_date=736596, @day_of_week=1, @molad_chalakim=0, @molad_minutes=0, @molad_hours=0, @jewish_year=5778, @jewish_month=7, @jewish_day=4, @in_israel=false, @use_modern_holidays=false>

formatter = Zmanim::HebrewCalendar::HebrewDateFormatter.new

# Format the name of a significant day
formatter.format_significant_day(calendar)
#=> "Fast of Gedalyah"

# Format the name of a significant shabbos
calendar.set_jewish_date(5778, 7, 3)
formatter.format_significant_shabbos(calendar)
#=> "Shabbos Shuva"
```

#### Learning cycles

```ruby
# Fetch the daf for a calendar day
daf = calendar.daf_yomi_bavli
#=> #<Zmanim::Limudim::Limud:0x007fa73c1c7c40 ...>
daf.description
#=> "sanhedrin 69"

# Format the daf
limud_formatter = Zmanim::Limudim::LimudimFormatter.new
limud_formatter.hebrew_format = true
limud_formatter.format_talmudic(daf)
#=> "סנהדרין סט"

# Format the parsha of the week
parsha = calendar.parshas_hashavua
limud_formatter.format_parsha(parsha)
#=> "פרשת האזינו"
```

There is much more functionality included than demonstrated here.  Feel free to experiment or read the source code to learn more! 

---
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pinnymz/ruby-zmanim. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Zmanim project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pinnymz/ruby-zmanim/blob/master/CODE_OF_CONDUCT.md).
