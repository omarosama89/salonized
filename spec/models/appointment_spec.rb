# frozen_string_literal: true

require 'models/service'
require 'models/appointment'

RSpec.describe Appointment do
  let(:start_at) { Time.parse('4/4/2024 10:00 UTC') }
  let(:service) do
    Service.new(name: 'Haircut', duration: 30)
  end

  subject do
    described_class.new(
      start_at: start_at,
      service: service
    )
  end

  context '#start_at_in_sec' do
    it 'returns start_at in seconds' do
      expect(subject.start_at_in_sec).to eq(1_712_224_800)
    end
  end

  context '#service_duration_in_sec' do
    it 'returns service_duration in seconds' do
      expect(subject.service_duration_in_sec).to eq(1_800)
    end
  end

  context 'failure' do
    context 'when start_at is not a Time instance' do
      let(:start_at) { '12/12/2012 13:00' }

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError, 'start_at is required to be an instance of Time')
      end
    end

    context 'when service is not an instance of Service' do
      let(:service) { "I'm a service" }

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError, 'service is required to be an instance of Service')
      end
    end
  end
end
