# frozen_string_literal: true

require_relative '../helpers/common_params'

class AvailabilityService
  include CommonParams
  attr_reader :opening_times_service, :appointments_service, :timeslot_interval, :service

  def initialize(opening_times_service:, appointments_service:, timeslot_interval:, service:)
    @opening_times_service = opening_times_service
    @appointments_service = appointments_service
    initialize_common_params(timeslot_interval: timeslot_interval, service: service)

    validate_params!
  end

  def timeslots
    # Return all available timeslots to show in our booking widget in this format:
    # ['09:00', '09:15', '09:30', '09:45', ...]
    opening_times_timeslots_hash = opening_times_timeslots.each_with_object({}) do |timeslot, memo|
      memo[timeslot] = 0 # we don't care about the value
    end
    appointments_timeslots.each do |timeslot|
      opening_times_timeslots_hash.delete(timeslot)
    end
    opening_times_timeslots_hash.keys
  end

  private

  def opening_times_timeslots
    opening_times_service.timeslots
  end

  def appointments_timeslots
    appointments_service.timeslots
  end

  def timeslot_interval_in_sec
    timeslot_interval * 60
  end

  def validate_params!
    raise ArgumentError, 'opening_times_service must be an instance of OpeningTimesService' unless opening_times_service.respond_to?(:timeslots)
    raise ArgumentError, 'appointments_service must be an instance of AppointmentsService' unless appointments_service.respond_to?(:timeslots)
  end
end
