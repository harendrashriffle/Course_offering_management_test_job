require 'rails_helper'

include JsonWebToken

RSpec.describe "Users", type: :request do

  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, type: "Admin") }
  let!(:student) { FactoryBot.create(:user, type: "Student") }

  describe "POST /user_login" do
    it 'should login user' do
      post "/user_login", params: {email: user.email, password_digest: user.password_digest}
      expect(response).to have_http_status(:ok)
    end
    it 'should reply to check email and password' do
      post "/user_login", params: {email: "fake", password_digest: nil}
      expect(response). to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /create" do
    it 'should allow admin to create account' do
      post "/users", params: {name: "abcd", email: "fake@gmail.com", contact: 12345, password_digest: "123456" , type: "Student"}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should allow admin but not create account' do
      post "/users", params: {name: nil}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not allow non-admin to create account' do
      post "/users", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should show invalid token error' do
      post "/users", params: {name: user.name, email: user.email, contact: user.contact, password_digest: user.password_digest, type: user.type}, headers: { "Authorization" => "Bearer #{"1234"}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /show" do
    it 'should allow admin to see other users' do
      get "/users/#{user.id}", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should show error for non existing user' do
      get "/users/:id", params: {id: nil}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:not_found)
    end
    it 'should show non-admin thier own id' do
      get "/users/#{student.id}", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:ok)
    end
  end
end
