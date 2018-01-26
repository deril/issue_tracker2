require 'rails_helper'

describe 'User Tickets Management', type: :request do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let!(:ticket1) { create :ticket, user: user }
  let!(:ticket2) { create :ticket, user: other_user }

  it 'see only own tickets' do
    sign_in user
    get '/tickets', params: { format: :json }

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json.map { |ticket| ticket['id'] }).to eq [ticket1.id]
  end

  it 'can see only own ticket' do
    sign_in user
    get "/tickets/#{ticket1.id}", params: { format: :json }

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json['subject']).to eq(ticket1.subject)
  end

  it 'cannot see other tickets' do
    sign_in user
    get "/tickets/#{ticket2.id}", params: { format: :json }
    expect(response).to be_success

    json = JSON.parse(response.body)

    expect(json['errors']).to include 'You are not authorized to perform this action'
  end

  it 'can create ticets' do
    sign_in user
    post '/tickets', params: { ticket: { subject: 'New Subject', body: 'New body' }, format: :json }
    json = JSON.parse(response.body)

    expect(response.status).to eq 201
    ticket_id = json['id']

    sign_in user
    get "/tickets/#{ticket_id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json['subject']).to eq 'New Subject'
  end

  it 'can update own tickets only' do
    sign_in user
    put "/tickets/#{ticket1.id}", params: { ticket: { subject: 'Subject changed' }, format: :json }
    expect(response.status).to eq 204

    sign_in user
    get "/tickets/#{ticket1.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['subject']).to eq 'Subject changed'

    sign_in user
    put "/tickets/#{ticket2.id}", params: { ticket: { subject: 'Subject changed' }, format: :json }
    expect(response).to be_success

    json = JSON.parse(response.body)

    expect(json['errors']).to include 'You are not authorized to perform this action'
  end

  it 'cannot update status and manager' do
    sign_in user
    put "/tickets/#{ticket1.id}", params: { ticket: { subject: 'Subject changed', status: Ticket::RESOLVED, manager_id: 3 }, format: :json }
    sign_in user
    get "/tickets/#{ticket1.id}", params: { format: :json }
    json = JSON.parse(response.body)

    expect(json['subject']).to eq 'Subject changed'
    expect(json['status']).to eq ticket1.status
    expect(json['manager_id']).to eq ticket1.manager_id
  end

  it 'can destroy only own tickets' do
    sign_in user
    delete "/tickets/#{ticket1.id}", params: { format: :json }
    expect(response.status).to eq 204

    expect do
      sign_in user
      get "/tickets/#{ticket1.id}", params: { format: :json }
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
