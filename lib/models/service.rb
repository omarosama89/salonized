# frozen_string_literal: true

class Service
  attr_accessor :name, :duration

  def initialize(name:, duration:)
    @name = name
    @duration = duration

    validate_params!
  end

  def duration_in_sec
    duration * 60
  end

  private

  def validate_params!
    raise ArgumentError, 'name must be a String' unless name.is_a?(String)
    raise ArgumentError, 'duration must be an Integer' unless duration.is_a?(Integer)
  end
end
