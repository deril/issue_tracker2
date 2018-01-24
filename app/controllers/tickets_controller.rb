class TicketsController < ApplicationController
  respond_to :xml, :json

  def index
    @tickets = Ticket.paginated(page: params[:page])
    respond_with @tickets
  end

  def show
    respond_with ticket
  end

  def create
    @ticket = Ticket.new(tickets_params)
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
    @ticket ||= Ticket.find(params[:id])
  end

  def tickets_params
    params.require(:ticket).permit(:subject, :body)
  end
end
