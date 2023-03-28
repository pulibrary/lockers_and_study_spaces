# frozen_string_literal: true

class StudyRoomViolationsController < ApplicationController
  before_action :set_study_room_violation, only: %i[show edit update destroy]
  before_action :force_admin

  # GET /study_room_violations or /study_room_violations.json
  def index
    @study_room_violations = StudyRoomViolation.all
  end

  # GET /study_room_violations/1 or /study_room_violations/1.json
  def show; end

  # GET /study_room_violations/new
  def new
    @study_room_violation = StudyRoomViolation.new(study_room_violation_params)
  end

  # GET /study_room_violations/1/edit
  def edit; end

  # POST /study_room_violations or /study_room_violations.json
  def create
    @study_room_violation = StudyRoomViolation.new(study_room_violation_params)

    respond_to do |format|
      if @study_room_violation.save
        UserMailer.with(study_room_violation: @study_room_violation).study_room_violation.deliver
        format.html { redirect_to @study_room_violation, notice: { message: 'Study room violation was successfully created.', type: 'success' } }
        format.json { render :show, status: :created, location: @study_room_violation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @study_room_violation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /study_room_violations/1 or /study_room_violations/1.json
  def update
    respond_to do |format|
      if @study_room_violation.update(study_room_violation_params)
        format.html { redirect_to @study_room_violation, notice: { message: 'Study room violation was successfully updated.', type: 'success' } }
        format.json { render :show, status: :ok, location: @study_room_violation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @study_room_violation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /study_room_violations/1 or /study_room_violations/1.json
  def destroy
    @study_room_violation.destroy
    respond_to do |format|
      format.html { redirect_to study_room_violations_url, notice: { message: 'Study room violation was successfully destroyed.', type: 'success' } }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_study_room_violation
    @study_room_violation = StudyRoomViolation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def study_room_violation_params
    return {} if params[:study_room_violation].blank?

    params.require(:study_room_violation).permit(:user_id, :study_room_id, :number_of_books)
  end

  def force_admin
    return if current_user.admin?

    redirect_to :root, alert: 'Only administrators have access to the all the Study Room Violations'
  end
end
