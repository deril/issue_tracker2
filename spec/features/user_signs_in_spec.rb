require 'rails_helper'

describe 'User Sign In', type: :request do
  let(:users_email) { 'user1@example.com' }
  let(:users_password) { 'password1' }

  before { create :user, email: users_email, password: users_password }

  it 'logins with a valid credentials' do
    post '/auth/sign_in', params: { email: users_email, password: users_password, format: :json }

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json.dig('data', 'email')).to eq users_email
  end

  it 'cannot login with invalid credentials' do
    post '/auth/sign_in', params: { email: users_email, password: 'wrongpassword', format: :json }

    json = JSON.parse(response.body)

    expect(response).not_to be_success
    expect(response.status).to eq 401
    expect(json['errors'][0]).to eq('Invalid login credentials. Please try again.')
  end
end
