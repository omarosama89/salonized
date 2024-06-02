# frozen_string_literal: true

class Appointment
  attr_accessor :start_at, :service

  def initialize(start_at:, service:)
    @start_at = start_at
    @service = service

    validate_params!
  end

  def start_at_in_sec
    start_at.to_i
  end

  def service_duration_in_sec
    service.duration_in_sec
  end

  private

  def validate_params!
    raise ArgumentError, 'start_at is required to be an instance of Time' unless start_at.is_a?(Time)
    raise ArgumentError, 'service is required to be an instance of Service' unless service.is_a?(Service)
  end
end
