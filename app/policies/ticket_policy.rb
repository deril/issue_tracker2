class TicketPolicy < ApplicationPolicy
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
