require 'rails_helper'

describe 'User Sign In', type: :request do
  before { create :user }

  it 'logins with a valid credentials' do
    post '/auth/sign_in', params: { email: 'user1@example.com', password: 'password1', format: :json }

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json.dig('data', 'email')).to eq('user1@example.com')
  end

  it 'cannot login with invalid credentials' do
    post '/auth/sign_in', params: { email: 'user1@example.com', password: 'wrongpassword', format: :json }

    json = JSON.parse(response.body)

    expect(response).not_to be_success
    expect(response.status).to eq 401
    expect(json['errors'][0]).to eq('Invalid login credentials. Please try again.')
  end
end
