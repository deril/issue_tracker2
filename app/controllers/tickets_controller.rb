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
    @ticket = current_person.tickets.new(permitted_attributes(Ticket))
    authorize ticket
    ticket.save
    respond_with ticket
  end

  def update
    ticket.update(permitted_attributes(ticket))
    respond_with ticket
  end

  def destroy
    ticket.destroy
    respond_with ticket
  end

  private

  def ticket
    @ticket ||= Ticket.find(params[:id])
  end

  def authorize_ticket
    authorize ticket
  end
end
