class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    query = params[:query]
    if query != nil
      @courses = Course.where(title: query)
    else
      @courses = Course.all
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @people_in_course = get_students_in_course(@course.id)
    teacher = Person.find_by(id: @course.person_id)
    @teacher_name = teacher.first_name + " " + teacher.last_name
  end

  # GET /courses/new
  def new
    @course = Course.new
    @professors = Person.where("is_professor = True")
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_student_to_course
    if params[:student_id]
      new_person_course = Enrollment.new
      new_person_course.person_id = params[:student_id]
      new_person_course.course_id = params[:course_id]
      new_person_course.save
    end

    course_id = params[:course_id]
    @course = Course.find_by(id: course_id)
    @people_not_in_course = get_students_not_in_course(course_id)
  end

  def get_students_in_course(course_id)
    people_in_course = Enrollment.where("course_id = ?", course_id)
    list = Array.new([])

    for person_course in people_in_course
      person = Person.find_by(id: person_course.person_id)
      list.push(person)
    end
    return list
  end

  def get_students_not_in_course(course_id)
    people_in_course = get_students_in_course(course_id)
    all_people = Person.all
    list = Array.new([])
    list = all_people - people_in_course
    return list
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      teacher_id = params.require(:course)[:teacher]
      if teacher_id
        teacher = Person.find(teacher_id)
      else
        teacher = nil
      end

      params.require(:course).permit(:title, :code, :quota).merge(:teacher => teacher)
    end
end
