module Zmanim::Limudim
  class Limud
    attr_reader :interval, :unit

    def initialize(interval, unit)
      @interval = interval
      @unit = unit
    end

    def cycle
      interval.cycle
    end

    def description
      unit.to_s
    end

    def start_date
      interval.start_date
    end

    def end_date
      interval.end_date
    end

    def iteration
      interval.iteration
    end

    def cycle_start_date
      cycle.start_date
    end

    def cycle_end_date
      cycle.end_date
    end

    def cycle_iteration
      cycle.iteration
    end
  end
end
