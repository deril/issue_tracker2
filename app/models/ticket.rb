# frozen_string_literal: true

class Ticket < ApplicationRecord
  STATUSES = [
    PENDING = 'PENDING',
    IN_PROGRESS = 'IN PROGRESS',
    RESOLVED = 'RESOLVED'
  ].freeze
  PER_PAGE = 25

  scope by_status: ->(status) { where(status: status) }
  scope paginated: ->(page: 1, per_page: PER_PAGE) { limit(page).offset(per_page.to_i * page.to_i) }
end
