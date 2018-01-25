# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

tickets_params = [
  {
    subject: 'Raising ProcessingError on version processing adds error message twice to record',
    body: 'When creating a version, if I raise ProcessingError I get the exception message twice on record.errors',
    status: Ticket::PENDING
  },
  {
    subject: 'content_type always nil when model loads',
    body: 'Carrierwave 0.9.0, Windows 7 64bit, Rails 4.0.2, Ruby 2.0.0p353, mime-types gem 1.25.1 In my uploader,'\
      'I have a conditional version method that looks like the following',
    status: Ticket::RESOLVED
  }
]

Ticket.create(tickets_params)

managers_params = [
  {
    email: 'manager1@example.com', password: 'password1'
  },
  {
    email: 'manager2@example.com', password: 'password2'
  }
]

Manager.create(managers_params)

users_params = [
  {
    email: 'user1@example.com', password: 'password1'
  },
  {
    email: 'user2@example.com', password: 'password2'
  }
]

User.create(users_params)
