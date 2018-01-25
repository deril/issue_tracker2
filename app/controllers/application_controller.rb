class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  devise_group :person, contains: [:user, :manager]
  rescue_from Pundit::NotAuthorizedError, with: :person_not_authorized

  private

  def pundit_user
    current_person
  end

  def person_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    respond_with policy_name
  end
end
