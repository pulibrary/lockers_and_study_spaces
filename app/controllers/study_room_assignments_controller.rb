# frozen_string_literal: true

class StudyRoomAssignmentsController < ApplicationController
  before_action :set_study_room_assignment, only: %i[show edit update destroy]
  before_action :force_admin

  # GET /study_room_assignments or /study_room_assignments.json
  def index
    @pagy, @study_room_assignments = pagy(StudyRoomAssignment.order(expiration_date: :desc).order(start_date: :desc).all)
  end

  # GET /study_room_assignments/1 or /study_room_assignments/1.json
  def show; end

  # GET /study_room_assignments/new
  def new
    @study_room_assignment = StudyRoomAssignment.new
  end

  # GET /study_room_assignments/1/edit
  def edit; end

  # POST /study_room_assignments or /study_room_assignments.json
  def create
    @study_room_assignment = StudyRoomAssignment.new(study_room_assignment_params)

    respond_to do |format|
      if @study_room_assignment.save
        format.html { redirect_to @study_room_assignment, notice: 'Study room assignment was successfully created.' }
        format.json { render :show, status: :created, location: @study_room_assignment }
        UserMailer.with(study_room_assignment: @study_room_assignment).study_room_assignment_confirmation.deliver
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @study_room_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /study_room_assignments/1 or /study_room_assignments/1.json
  def update
    respond_to do |format|
      if @study_room_assignment.update(study_room_assignment_params)
        format.html { redirect_to @study_room_assignment, notice: 'Study room assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @study_room_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @study_room_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /study_room_assignments/1 or /study_room_assignments/1.json
  def destroy
    @study_room_assignment.destroy
    respond_to do |format|
      format.html { redirect_to study_room_assignments_url, notice: 'Study room assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_study_room_assignment
    @study_room_assignment = StudyRoomAssignment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def study_room_assignment_params
    params.require(:study_room_assignment).permit(:start_date, :expiration_date, :user_id, :study_room_id)
  end

  def force_admin
    return if current_user.admin?

    redirect_to :root, alert: 'Only administrators have access to the specific Study Room Assignments!'
  end
end
