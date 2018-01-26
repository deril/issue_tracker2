require 'rails_helper'

describe 'Manager Sign In', type: :request do
  let(:managers_email) { 'user1@example.com' }
  let(:managers_password) { 'password1' }

  before { create :manager, email: managers_email, password: managers_password }

  it 'logins with a valid credentials' do
    post '/admin_auth/sign_in', params: { email: managers_email, password: managers_password, format: :json }

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json.dig('data', 'email')).to eq managers_email
  end

  it 'cannot login with invalid credentials' do
    post '/admin_auth/sign_in', params: { email: managers_email, password: 'wrongpassword', format: :json }

    json = JSON.parse(response.body)

    expect(response).not_to be_success
    expect(response.status).to eq 401
    expect(json['errors'][0]).to eq('Invalid login credentials. Please try again.')
  end
end
