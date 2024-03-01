class CoursesController < ApplicationController
  skip_before_action :authenticate_request, only: [:index, :show]

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
    if @current_user.type == "Admin"
      course = @current_user.courses.new(set_params)
      return render json: {errors: course.errors.full_messages}, status: :unprocessable_entity unless course.save
      render json: {message:"Course Created", data: course}, status: :ok
    else
      render json: {errors: "You are not authorized to create course"}, status: :unprocessable_entity
    end
  end

  def show
    course = Course.find_by_id(params[:id])
    if course.present?
      render json: {message: "Here is your selected course", data: course}, status: :ok
    else
      render json: {errors: "Course doesn't exist"}, status: :not_found
    end
  end

  def update
    if @current_user.type == "Admin"
      course = Course.find_by_id(params[:id])
      return render json: {errors: "Course doesn't exist"} if course.nil?
      if course.update(set_params)
        render json: {message:"Course Updated", data: course}, status: :ok
      else
        render json: {errors: "Course doesn't update"}, status: :unprocessable_entity
      end
    else
      render json: {errors: "You are not authorized to update course"}, status: :unprocessable_entity
    end
  end

  def enroll_course
    if @current_user.type == "Student"
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
    if @current_user.type == "Student"
      enrolled_course = @current_user.courses
      render json: {message:"Your Enrolled Course", data: enrolled_course}, status: :ok
    elsif @current_user.type == "Instructor"
      assigned_courses = @current_user.courses
      students_enrolled = {}
      assigned_courses.each do |course|
        students_enrolled[course.name] = course.student.pluck(:name)
      end
      render json: {message: "Student enrolled oin your assigned course", data: students_enrolled}
    else
      render json: {errors: "You are not authorized to see enrolled"}, status: :unprocessable_entity
    end
  end

  def assign_course_instructor
    if @current_user.type == "Admin"
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
      params.permit(:name, :content)
    end
end
