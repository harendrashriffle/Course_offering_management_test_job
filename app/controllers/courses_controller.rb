class CoursesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :admin_access, only: [:create, :update, :destroy]
  before_action :course, only: [:show, :update, :destroy, :enroll_course, :assign_course_instructor]

  def index
    courses = Course.all
    courses = courses.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    if courses.present?
      render json: {message: "List of Courses", data: courses}, status: :ok
    else
      render json: {errors: "No Courses are available"}, status: :not_found
    end
  end

  def create
    course = @current_user.courses.new(set_params)
    return render json: {errors: course.errors.full_messages}, status: :unprocessable_entity unless course.save
    render json: {message:"Course Created", data: course}, status: :ok
  end

  def show
    render json: course
  end

  def update
    if course.update(set_params)
      render json: {message:"Course Updated", data: course}, status: :ok
    else
      render json: {errors: "Course doesn't update"}, status: :unprocessable_entity
    end
  end

  def destroy
    if course.destroy
      render json: {message: "Course deleted"}, status: :ok
    else
      render json: {errors: "Course doesn't deleted"}, status: :unprocessable_entity
    end
  end

  def enroll_course
    if student?
      enrolling_course = @current_user.student_enroll_course.new(course_id: params[:course_id])
      if enrolling_course.save
        render json: {message:"You have enrolled in the course", data: enrolling_course}, status: :ok
      else
        render json: {errors: enrolling_course.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: {errors: "You are not authorized to get enrolled"}, status: :unprocessable_entity
    end
  end

  def show_enrolled_course
    course = @current_user.courses
    if student?
      render json: {message:"Your Enrolled Course", data: course}, status: :ok
    elsif instructor?
      render json: {message: "Student enrolled in your assigned course", data: course.students}
    else
      render json: {errors: "You are not authorized to see enrolled"}, status: :unprocessable_entity
    end
  end

  def assign_course_instructor
    instructor = User.find_by(id: params[:user_id], type: "Instructor")
    course = Course.find_by(id: params[:course_id])
      if instructor.present? && course.present?
        assign_instructor = InstructorAssigneeCourse.new(instructor: instructor, course: course)
        if assign_instructor.save
          render json: {message:"Instructor assign to the course successfully", data: assign_instructor}, status: :ok
        else
          render json: {errors: assign_instructor.errors.full_messages}, status: :unprocessable_entity
        end
      else
        render json: {errors: "Instructor and course not found"}, status: :unprocessable_entity
      end
    else
      render json: {errors: "You are not authorized to assign instructor to course"}, status: :unprocessable_entity
    end
  end

  private
    def set_params
      params.require(:course).permit(:name, :content)
    end

    def course
      course = Course.find_by_id(params[:id])
      course.nil? ? "Course doesn't exist" : course
    end

    def student
      @current_user.type == "Student"
    end

    def instructor
      @current_user.type == "Instructor"
    end
end
