# frozen_string_literal: true

require 'time'
require 'models/service'
require 'models/appointment'
require 'services/opening_times_service'

RSpec.describe OpeningTimesService do
  # The time ranges a salon is open daily
  let(:opening_times_range) do
    [
      (Time.parse('09:00')..Time.parse('12:00')),
      (Time.parse('13:00')..Time.parse('17:00'))
    ]
  end

  # Services that can be booked in this salon
  let(:service) { Service.new(name: 'Haircut', duration: 30) }

  subject do
    described_class.new(time_ranges: opening_times_range, service: service, timeslot_interval: timeslot_interval).timeslots
  end

  # The interval used to show the timeslots, open slots should be shown every 15 minutes
  let(:timeslot_interval) { 15 }

  context 'success' do
    context 'when service duration is 30 mins' do
      let(:service) { Service.new(name: 'Haircut', duration: 30) }
      let(:result) do
        [
          '09:00', '09:15', '09:30', '09:45',
          '10:00', '10:15', '10:30', '10:45',
          '11:00', '11:15', '11:30',
          '13:00', '13:15', '13:30', '13:45',
          '14:00', '14:15', '14:30', '14:45',
          '15:00', '15:15', '15:30', '15:45',
          '16:00', '16:15', '16:30'
        ]
      end

      it 'return timeslots array' do
        expect(subject).to eq(result)
      end
    end

    context 'when service duration is 60 mins' do
      let(:service) { Service.new(name: 'Haircut & Beardtrim', duration: 60) }

      let(:result) do
        [
          '09:00', '09:15', '09:30', '09:45',
          '10:00', '10:15', '10:30', '10:45',
          '11:00',
          '13:00', '13:15', '13:30', '13:45',
          '14:00', '14:15', '14:30', '14:45',
          '15:00', '15:15', '15:30', '15:45',
          '16:00'
        ]
      end

      it 'returns all timeslots' do
        expect(subject).to eq(result)
      end
    end

    context 'when timeslot interval is 10' do
      let(:timeslot_interval) { 10 }
      let(:result) do
        [
          '09:00', '09:10', '09:20', '09:30', '09:40', '09:50',
          '10:00', '10:10', '10:20', '10:30', '10:40', '10:50',
          '11:00', '11:10', '11:20', '11:30',
          '13:00', '13:10', '13:20', '13:30', '13:40', '13:50',
          '14:00', '14:10', '14:20', '14:30', '14:40', '14:50',
          '15:00', '15:10', '15:20', '15:30', '15:40', '15:50',
          '16:00', '16:10', '16:20', '16:30'
        ]
      end

      it 'return timeslots array' do
        expect(subject).to eq(result)
      end
    end
  end

  context 'failure' do
    context 'when time_ranges is not a range of Time' do
      let(:opening_times_range) { (1..2) }

      it 'raises an error with message' do
        expect { subject }.to raise_error(StandardError, 'time_ranges shoud be an array of Range of Time')
      end
    end
  end
end
