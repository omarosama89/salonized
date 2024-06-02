# frozen_string_literal: true

require 'services/availability_service'
require 'models/service'
require 'models/appointment'
require 'time'

RSpec.describe AvailabilityService do
  # The time ranges a salon is open daily
  let(:opening_times_range) do
    [
      (Time.parse('09:00')..Time.parse('12:00')),
      (Time.parse('13:00')..Time.parse('17:00'))
    ]
  end

  # Customers already booked these appointments in this salon, these spots are taken:
  let(:appointments) do
    [
      Appointment.new(
        start_at: Time.parse('10:00'),
        service: services[0] # Haircut
      ),
      Appointment.new(
        start_at: Time.parse('14:00'),
        service: services[1] # Haircut & Beardtrim
      ),
      Appointment.new(
        start_at: Time.parse('14:30'),
        service: services[1] # Haircut & Beardtrim
      )
    ]
  end

  # Services that can be booked in this salon
  let(:services) do
    [
      Service.new(name: 'Haircut', duration: 30),
      Service.new(name: 'Haircut & Beardtrim', duration: 60)
    ]
  end
  let(:service) { services[0] }
  let(:opening_times_service) do
    instance_double('OpeningTimesService', timeslots: opening_times_service_response)
  end
  let(:appointments_service) do
    instance_double('AppointmentsService', timeslots: appointments_service_response)
  end
  let(:opening_times_service_response) do
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
  let(:appointments_service_response) do
    [
      '09:45', '10:00', '10:15', '13:45', '14:00',
      '14:15', '14:30', '14:45', '15:00', '15:15'
    ]
  end
  # The interval used to show the timeslots, open slots should be shown every 15 minutes
  let(:timeslot_interval) { 15 }

  subject do
    described_class.new(
      opening_times_service: opening_times_service, appointments_service: appointments_service,
      timeslot_interval: timeslot_interval, service: service
    )
  end

  context 'success' do
    context 'when appointments is not empty' do
      let(:result) do
        [
          '09:00', '09:15', '09:30', '10:30',
          '10:45', '11:00', '11:15', '11:30',
          '13:00', '13:15', '13:30', '15:30',
          '15:45', '16:00', '16:15', '16:30'
        ]
      end

      it 'should have a first slot at 09:00' do
        expect(subject.timeslots.first).to eq('09:00')
      end

      it 'should have a gap in slots after 11:30' do
        expect(subject.timeslots).to include('11:30')
        expect(subject.timeslots).not_to include('11:45')
        expect(subject.timeslots).not_to include('12:45')
        expect(subject.timeslots).to include('13:00')
      end

      it 'should have a last slot at 16:30' do
        expect(subject.timeslots.last).to eq('16:30')
      end

      it 'returns all available timeslots' do
        expect(subject.timeslots).to eq(result)
      end
    end

    context 'when appointments is empty' do
      let(:opening_times_range) do
        [
          (Time.parse('09:00')..Time.parse('10:00')),
          (Time.parse('13:00')..Time.parse('14:00'))
        ]
      end
      let(:appointments) { [] }
      let(:appointments_service_response) { [] }
      let(:opening_times_service_response) do
        [
          '09:45', '10:00', '10:15', '13:45', '14:00',
          '14:15', '14:30', '14:45', '15:00', '15:15'
        ]
      end
      let(:result) do
        [
          '09:45', '10:00', '10:15', '13:45', '14:00',
          '14:15', '14:30', '14:45', '15:00', '15:15'
        ]
      end

      it 'returns all timeslots' do
        expect(subject.timeslots).to eq(result)
      end
    end
  end

  context 'failure' do
    context 'when opening_times_range does not respond to :timeslots' do
      let(:opening_times_service) { double }

      it 'raises an error with message' do
        expect { subject.timeslots }.to raise_error(StandardError, 'opening_times_service must be an instance of OpeningTimesService')
      end
    end

    context 'when appointments_service does not respond to :timeslots' do
      let(:appointments_service) { double }

      it 'raises an error with message' do
        expect { subject.timeslots }.to raise_error(StandardError, 'appointments_service must be an instance of AppointmentsService')
      end
    end
  end
end
