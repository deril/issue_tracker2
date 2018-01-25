class TicketsController < ApplicationController
  respond_to :xml, :json
  before_action :authenticate_person!
  before_action :authorize_ticket, only: %i[show update destroy]

  def index
    @tickets = policy_scope(Ticket).paginated(page: params[:page])
    authorize @tickets
    respond_with @tickets
  end

  def show
    respond_with ticket
  end

  def create
    @ticket = current_person.tickets.new(tickets_params)
    authorize ticket
    ticket.save
    respond_with ticket
  end

  def update
    ticket.update(tickets_params)
    respond_with ticket
  end

  def destroy
    ticket.destroy
    respond_with ticket
  end

  private

  def ticket
    @ticket ||= policy_scope(Ticket).find(params[:id])
  end

  def tickets_params
    allowed_user_attributes = %i[subject body]
    allowed_manager_attributes = allowed_user_attributes + %i[status, manager_id]
    params.require(:ticket).permit(current_person.is_a?(Manager) ? allowed_manager_attributes : allowed_user_attributes)
  end

  def authorize_ticket
    authorize ticket
  end
end
