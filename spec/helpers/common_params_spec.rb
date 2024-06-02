# frozen_string_literal: true

require 'helpers/common_params'

class DummyClass
  def initialize(**params)
    initialize_common_params(**params)
  end
  include CommonParams
end

RSpec.describe CommonParams do
  let(:service) { Service.new(name: 'Haircut', duration: 30) }
  let(:timeslot_interval) { 15 }

  subject do
    DummyClass.new(service: service, timeslot_interval: timeslot_interval)
  end

  context 'failure' do
    context 'when timeslot_interval is not an Integer' do
      let(:timeslot_interval) { '60' }

      it 'raises an error with message' do
        expect { subject }.to raise_error(StandardError, 'timeslot_interval must be an integer')
      end
    end

    context 'when service is not an instance of Service' do
      let(:service) { 'Hair & Beardtrim' }

      it 'raises an error with message' do
        expect { subject }.to raise_error(StandardError, 'service must be an instance of Service')
      end
    end
  end
end
