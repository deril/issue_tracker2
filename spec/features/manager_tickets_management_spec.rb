require 'rails_helper'

describe 'Manager Tickets Management', type: :request do
  let(:manager) { create :manager }
  let(:other_manager) { create :manager }
  let(:user1) { create :user }
  let(:user2) { create :user }
  let!(:ticket1) { create :ticket, user: user1, manager: manager }
  let!(:ticket2) { create :ticket, user: user2, manager: other_manager }
  let!(:ticket3) { create :ticket, user: user1, manager: nil }

  it 'can see all tickets' do
    sign_in manager
    get '/tickets', params: { format: :json }
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json.map { |ticket| ticket['id'] }).to eq Ticket.all.ids
  end

  it 'can assign ticket only to yourself' do
    # assign to yourself
    sign_in manager
    put "/tickets/#{ticket3.id}", params: { ticket: { manager_id: manager.id }, format: :json }
    expect(response.status).to eq 204

    sign_in manager
    get "/tickets/#{ticket3.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['manager_id']).to eq manager.id

    # assign to other manager
    sign_in manager
    put "/tickets/#{ticket3.id}", params: { ticket: { manager_id: other_manager.id }, format: :json }
    expect(response.status).to eq 422
    json = JSON.parse(response.body)

    expect(json.dig('errors', 'manager_id')).to include 'cannot be changed'

    sign_in manager
    get "/tickets/#{ticket3.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['manager_id']).to eq manager.id
  end

  it 'can assign ticket only if it is not assigned to somebody else' do
    sign_in manager
    put "/tickets/#{ticket2.id}", params: { ticket: { manager_id: manager.id }, format: :json }
    expect(response.status).to eq 204

    sign_in manager
    get "/tickets/#{ticket2.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['manager_id']).to eq other_manager.id
  end

  it 'can unassign ticket from yourself only' do
    # unassign from yourself
    sign_in manager
    put "/tickets/#{ticket1.id}", params: { ticket: { manager_id: '' }, format: :json }
    expect(response.status).to eq 204

    sign_in manager
    get "/tickets/#{ticket1.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['manager_id']).to be_nil

    # unassign from other manager
    sign_in manager
    put "/tickets/#{ticket2.id}", params: { ticket: { manager_id: '' }, format: :json }

    sign_in manager
    get "/tickets/#{ticket2.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['manager_id']).to eq other_manager.id
  end

  it 'can change status of the ticket only if it is assigned to yourself' do
    # change status of your ticket
    sign_in manager
    put "/tickets/#{ticket1.id}", params: { ticket: { status: Ticket::IN_PROGRESS }, format: :json }
    expect(response.status).to eq 204

    sign_in manager
    get "/tickets/#{ticket1.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['status']).to eq Ticket::IN_PROGRESS

    # change status of somebody else ticket
    sign_in manager
    put "/tickets/#{ticket2.id}", params: { ticket: { status: Ticket::IN_PROGRESS }, format: :json }
    expect(response.status).to eq 204

    sign_in manager
    get "/tickets/#{ticket2.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['status']).to eq ticket2.status

    # change status of unassigned ticket
    sign_in manager
    put "/tickets/#{ticket3.id}", params: { ticket: { status: Ticket::IN_PROGRESS }, format: :json }
    expect(response.status).to eq 204

    sign_in manager
    get "/tickets/#{ticket3.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['status']).to eq ticket3.status
  end
end
