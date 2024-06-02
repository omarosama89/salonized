# frozen_string_literal: true

module CommonParams
  attr_reader :timeslot_interval, :service

  def initialize_common_params(timeslot_interval:, service:)
    @timeslot_interval = timeslot_interval
    @service = service

    validate_params!
  end

  private

  def validate_params!
    raise ArgumentError, 'timeslot_interval must be an integer' unless timeslot_interval.is_a?(Integer)
    raise ArgumentError, 'service must be an instance of Service' unless service.is_a?(Service)
  end
end
