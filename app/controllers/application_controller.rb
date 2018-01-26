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
    message = {errors: 'You are not authorized to perform this action'}

    render request.format.to_sym => message
  end
end
