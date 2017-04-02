class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]

  # GET /enrollments
  # GET /enrollments.json
  def index
    @enrollments = Enrollment.all
  end

  # GET /enrollments/1
  # GET /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments
  # POST /enrollments.json
  def create
    @enrollment = Enrollment.new(enrollment_params)

    respond_to do |format|
      if @enrollment.save
        actual_course = Course.find(@enrollment.course_id)
        actual_course_name = actual_course.title
        quota = actual_course.quota
        actual_size = Enrollment.where(:course => @enrollment.course_id).size
        if actual_size <= quota
          format.html { redirect_to @enrollment, notice: 'Enrollment was successfully created.' }
          format.json { render :show, status: :created, location: @enrollment }
        else
          @enrollment.destroy
          format.html {render :new }
          flash[:notice] = ('Course "' + actual_course_name + '" quota exceeded')
        end
      else
        format.html { render :new }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to @enrollment, notice: 'Enrollment was successfully updated.' }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1
  # DELETE /enrollments/1.json
  def destroy
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: 'Enrollment was successfully destroyed.' }
      format.json { head :no_content }
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enrollment_params
      student_id = params.require(:enrollment)[:student]
      if student_id
        student = Person.find(student_id)
      else
        student = nil
      end
      params.require(:enrollment).permit(:course_id).merge(:student => student)
    end
end
