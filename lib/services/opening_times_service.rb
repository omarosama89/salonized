# frozen_string_literal: true

require_relative '../helpers/common_params'

class OpeningTimesService
  include CommonParams

  attr_reader :time_ranges, :service, :timeslot_interval

  def initialize(time_ranges:, service:, timeslot_interval:)
    @time_ranges = time_ranges

    initialize_common_params(timeslot_interval: timeslot_interval, service: service)

    validate_param!
  end

  def timeslots
    time_ranges.map do |opening_time|
      begining_of_opening_time = opening_time.begin.to_i

      # To prevent overlap between appoinement and endtime
      end_of_opening_time = opening_time.end.to_i - service.duration_in_sec
      (begining_of_opening_time..end_of_opening_time)
        .step(timeslot_interval_in_sec).to_a
        .map { |t| Time.at(t) }
        .map { |t| t.strftime('%H:%M') }
    end.flatten
  end

  private

  def validate_param!
    raise ArgumentError, 'time_ranges shoud be an array of Range of Time' unless time_ranges.all? { |e| e.is_a?(Range) && e.begin.is_a?(Time) && e.end.is_a?(Time) }
  end

  def timeslot_interval_in_sec
    timeslot_interval * 60
  end
end
