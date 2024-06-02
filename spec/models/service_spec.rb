# frozen_string_literal: true

require 'models/service'

RSpec.describe Service do
  let(:name) { 'Haircut' }
  let(:duration) { 30 }

  subject do
    described_class.new(name: name, duration: duration)
  end

  context 'success' do
    context '#duration_in_sec' do
      it 'returns duration in seconds' do
        expect(subject.duration_in_sec).to eq(1800)
      end
    end
  end

  context 'failure' do
    context 'when name is missing' do
      let(:name) { :hair }

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError, 'name must be a String')
      end
    end

    context 'when duration is missing' do
      let(:duration) { '60' }

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError, 'duration must be an Integer')
      end
    end
  end
end
