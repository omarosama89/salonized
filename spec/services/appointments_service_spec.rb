# frozen_string_literal: true

require 'time'
require 'models/service'
require 'services/appointments_service'
require 'models/appointment'

RSpec.describe AppointmentsService do
  let(:service) do
    Service.new(name: 'Haircut', duration: 30)
  end
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
  let(:services) do
    [
      Service.new(name: 'Haircut', duration: 30),
      Service.new(name: 'Haircut & Beardtrim', duration: 60)
    ]
  end
  let(:timeslot_interval) { 15 }

  subject do
    described_class.new(appointments: appointments, service: service, timeslot_interval: timeslot_interval)
  end

  context 'success' do
    context 'when appointments is not empty' do
      let(:result) do
        [
          '09:45', '10:00', '10:15', '13:45', '14:00',
          '14:15', '14:30', '14:45', '15:00', '15:15'
        ]
      end

      it 'returns result' do
        expect(subject.timeslots).to eq(result)
      end
    end

    context 'when appointments is empty' do
      let(:appointments) { [] }
      let(:result) { [] }

      it 'returns result' do
        expect(subject.timeslots).to eq(result)
      end
    end

    context ' when timeslot interval is 10' do
      let(:timeslot_interval) { 10 }
      let(:result) do
        [
          '09:40', '09:50',
          '10:00', '10:10', '10:20',
          '13:40', '13:50',
          '14:00', '14:10', '14:20', '14:30', '14:40', '14:50',
          '15:00', '15:10', '15:20'
        ]
      end

      it 'returns result' do
        expect(subject.timeslots).to eq(result)
      end
    end
  end

  context 'failure' do
    context 'when appoinements is not an array of Appointment' do
      let(:appointments) { [1, 2] }

      it 'raises an error' do
        expect { subject.timeslots }.to raise_error(StandardError, 'appointments should be empty or array of Appointment')
      end
    end
  end
end
