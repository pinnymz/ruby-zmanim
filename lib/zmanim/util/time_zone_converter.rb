module Zmanim::Util
  class TimeZoneConverter
    attr_reader :time_zone

    def initialize(time_zone)
      @time_zone = time_zone
    end

    # Adjust a DateTime for the provided time zone
    def modify_offset(time)
      offset = offset_at(time)
      time.new_offset(offset/24)
    end

    # offset in effect for time zone at the given time (in hours)
    def offset_at(time)
      time_zone.period_for_utc(time.new_offset(0)).utc_total_offset / (60 * 60).to_f
    end
  end
end
