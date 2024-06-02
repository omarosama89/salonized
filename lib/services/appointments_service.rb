# frozen_string_literal: true

require_relative '../helpers/common_params'

class AppointmentsService
  include CommonParams

  attr_reader :appointments, :service, :timeslot_interval

  def initialize(service:, timeslot_interval:, appointments: [])
    @appointments = appointments
    initialize_common_params(timeslot_interval: timeslot_interval, service: service)

    validate_param!
  end

  def timeslots
    appointments.map do |appointment|
      # To prevent overlap between appoinments
      appointment_begin_in_sec = appointment.start_at_in_sec - (service.duration_in_sec - timeslot_interval_in_sec)
      appointment_end_in_sec = appointment.start_at_in_sec + appointment.service_duration_in_sec
      (appointment_begin_in_sec...appointment_end_in_sec)
        .step(timeslot_interval_in_sec).to_a
        .map { |t| Time.at(t) }
        .map { |t| t.strftime('%H:%M') }
    end.flatten.uniq
  end

  private

  def validate_param!
    raise ArgumentError, 'appointments should be empty or array of Appointment' unless appointments.empty? || appointments.all? { |e| e.is_a?(Appointment) }
  end

  def timeslot_interval_in_sec
    timeslot_interval * 60
  end
end
