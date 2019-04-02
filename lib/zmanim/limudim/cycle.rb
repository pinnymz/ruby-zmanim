module Zmanim::Limudim
  class Cycle
    attr_reader :start_date, :end_date, :iteration

    def initialize(start_date, end_date, iteration)
      @start_date = start_date
      @end_date = end_date
      @iteration = iteration
    end

    def self.from_perpetual_anchor(anchor, cycle_end_calculation, date)
      start_date = anchor.current_or_previous_occurrence(date)
      end_date = cycle_end_calculation.(start_date, nil)
      Cycle.new(start_date, end_date, nil)
    end

    def self.from_cycle_initiation(initial_cycle_date, cycle_end_calculation, date)
      return nil if initial_cycle_date > date
      iteration = 1
      end_date = cycle_end_calculation.(initial_cycle_date, iteration)
      cycle = Cycle.new(initial_cycle_date, end_date, iteration)
      while date > cycle.end_date
        cycle = cycle.next(cycle_end_calculation)
      end
      cycle
    end

    def next(cycle_end_calculation)
      return nil unless iteration
      new_iteration = iteration + 1
      new_start_date = end_date + 1
      new_end_date = cycle_end_calculation.(new_start_date, new_iteration)
      Cycle.new(new_start_date, new_end_date, new_iteration)
    end
  end
end
