class CoursesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

  def index
    courses = Course.all
    courses = courses.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    if courses.present?
      render json: {message: "List of Courses", data: courses}
    else
      render json: {message: "No Courses are available"}
    end
  end

  def create
    if @current_user.type == "Admin"
      course = @current_user.courses.new(set_params)
      return render json: {errors: course.errors.full_messages} unless course.save
      render json: {message:"Course Created", data: course}
    else
      render json: {message: "You are not authorized to create course"}
    end
  end

  def show
    course = Course.find_by_id(params[:id])
    if course.present?
      render json: {message: "Here is your selected course", data: course}
    else
      render json: {error: "Course doesn't exist"}
    end
  end

  def update
    if @current_user.type == "Admin"
      course = Course.find_by_id(params[:id])
      return render json: {errors: "Course doesn't exist"} if course.nil?
      if course.update(set_params)
        render json: {message:"Course Updated", data: course}
      else
        render json: {errors: "Course doesn't update"}
      end
    else
      render json: {message: "You are not authorized to update course"}
    end
  end

  def enroll_course
    if @current_user.type == "Student"
      enrolling_course = @current_user.student_enroll_course.new(course_id: params[:course_id])
      if enrolling_course.save
        render json: {message:"You have enrolled in the course", data: enrolling_course}
      else
        render json: {errors: enrolling_course.errors.full_messages}
      end
    else
      render json: {message: "You are not authorized to get enrolled"}
    end
  end

  # def show_enrolled_course
  #   if @current_user.type == "Student"
  #     enrolled_course = StudentEnrollCourse.@current_user.course.name
  #     return render json: {errors: enrolled_course.errors.full_messages} unless enrolled_course.present?
  #     render json: {message:"Your Enrolled Course", data: enrolled_course}
  #   else
  #     render json: {message: "You are not authorized to see enrolled"}
  #   end
  # end

  def assign_course_instructor
    if @current_user.type == "Admin"
      assign_instructor = InstructorAssigneeCourse.new(course_id: params[:course_id], user_id: params[:user_id])
      if assign_instructor.save
        render json: {message:"You have enrolled in the course", data: assign_instructor}
      else
        render json: {errors: assign_instructor.errors.full_messages}
      end
    else
      render json: {message: "You are not authorized to assign instructor to course"}
    end
  end

  private
    def set_params
      params.permit(:name, :content)
    end
end
