class TicketPolicy < ApplicationPolicy
  alias_method :ticket, :record

  def permitted_attributes
    default_attributes = %i[subject body]

    if user.is_a? Manager
      default_attributes.tap do |attributes|
        if user.owner_of?(ticket)
          attributes.push(:manager_id, :status)
        elsif ticket.manager.nil?
          attributes << :manager_id
        else
          attributes
        end
      end
    else
      default_attributes
    end
  end

  def create?
    if user.is_a? User
      true
    else
      false
    end
  end

  class Scope < Scope
    def resolve
      if user.is_a? Manager
        scope.all
      else
        scope.owned(user)
      end
    end
  end
end
