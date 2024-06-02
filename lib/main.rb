# frozen_string_literal: true

require 'time'
require_relative 'services/availability_service'
require_relative 'models/service'
require_relative 'services/opening_times_service'
require_relative 'services/appointments_service'

timeslot_interval = 15
service = Service.new(name: 'Haircut', duration: 30)

opening_times_service = OpeningTimesService.new(time_ranges: [(Time.parse('09:00')..Time.parse('12:00'))], service: service, timeslot_interval: timeslot_interval)

appointments_service = AppointmentsService.new(appointments: [], service: service, timeslot_interval: timeslot_interval)

availability_service = AvailabilityService.new(
  opening_times_service: opening_times_service, appointments_service: appointments_service,
  timeslot_interval: timeslot_interval, service: service
)

puts 'Timeslots:'
puts availability_service.timeslots
