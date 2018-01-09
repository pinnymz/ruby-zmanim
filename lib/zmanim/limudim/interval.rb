module Zmanim::Limudim
  class Interval
    attr_reader :start_date, :end_date, :iteration, :cycle

    def initialize(start_date, end_date, iteration, cycle)
      @start_date = start_date
      @end_date = end_date
      @iteration = iteration
      @cycle = cycle
    end

    def self.first_for_cycle(cycle, interval_end_calculation)
      start_date = cycle.start_date
      iteration = 1
      end_date = interval_end_calculation.(cycle, start_date)
      Interval.new(start_date, end_date, iteration, cycle)
    end

    def next(interval_end_calculation)
      next_for_iteration(iteration+1, interval_end_calculation)
    end

    def skip(interval_end_calculation)
      next_for_iteration(iteration, interval_end_calculation)
    end

    private

    def next_for_iteration(new_iteration, interval_end_calculation)
      return nil if end_date >= cycle.end_date    # paranoid check to remain in cycle bounds
      new_start_date = end_date + 1
      new_end_date = interval_end_calculation.(cycle, new_start_date)
      Interval.new(new_start_date, new_end_date, new_iteration, cycle)
    end

  end
end
