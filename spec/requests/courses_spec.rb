require 'rails_helper'
include JsonWebToken

RSpec.describe "Courses", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, type: "Admin") }
  let!(:student) { FactoryBot.create(:user, type: "Student") }
  let!(:course) { FactoryBot.create(:course, user_id: admin.id) }
  let!(:instructor) { FactoryBot.create(:user, type: "Instructor") }

  describe "GET /index" do
    it 'should show list of courses' do
      get '/courses'
      expect(response).to have_http_status(:ok)
    end
    it 'should search course by name' do
      get "/courses?name=#{course.name}"
      expect(response).to have_http_status(:ok)
    end
    it 'should throw error if searched course not found' do
      get "/courses?name=#{"abcd"}"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do
    it 'should allow admin to create course' do
      post "/courses", params: { name: course.name }, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should allow admin but not create course' do
      post "/courses", params: {name: nil }, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not allow non-admin user to create course' do
      post "/courses", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /show" do
    it 'should show specific course' do
      get "/courses/#{course.id}"
      expect(response).to have_http_status(:ok)
    end
    it 'should show error if course not found' do
      get "/courses/:id", params: {id: nil}
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT /update" do
    it 'should allow admin to update course' do
      put "/courses/#{course.id}", params: {name: course.name }, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should allow admin but not update course' do
      put "/courses/#{course.id}", params: {name: nil }, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not allow non-admin user to update course' do
      put "/courses/:id", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /enroll_course" do
    it 'should allow student to enroll in course' do
      post "/courses/enroll_course", params: {course_id: course.id}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should allow student to enroll in course' do
      post "/courses/enroll_course", params: {course_id: nil}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not allow non-student user to enroll in course' do
      post "/courses/enroll_course", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /show_enrolled_course" do
    it 'should allow student to enroll in course' do
      get "/courses/show_enrolled_course", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should not allow non-student user to enroll in course' do
      get "/courses/show_enrolled_course", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /assign_course_instructor" do
    it 'should allow admin to assign course instructor' do
      post "/courses/assign_course_instructor", params: {course_id: course.id, user_id: instructor.id}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:ok)
    end
    it 'should not allow admin to assign instructor if course and instructor not found' do
      post "/courses/assign_course_instructor", params: {course_id: nil, user_id: nil}, headers: { "Authorization" => "Bearer #{jwt_encode(user_id: admin.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not allow non-admin to assign instructor' do
      post "/courses/assign_course_instructor", headers: { "Authorization" => "Bearer #{jwt_encode(user_id: student.id)}"}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
