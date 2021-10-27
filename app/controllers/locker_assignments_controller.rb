# frozen_string_literal: true

class LockerAssignmentsController < ApplicationController
  before_action :set_locker_assignment, only: %i[show edit update destroy]
  before_action :force_admin

  # GET /locker_assignments or /locker_assignments.json
  def index
    @locker_assignments = LockerAssignment.all
  end

  # GET /locker_assignments/1 or /locker_assignments/1.json
  def show; end

  # GET /locker_assignments/new
  def new
    @locker_assignment = LockerAssignment.new
  end

  # GET /locker_assignments/1/edit
  def edit; end

  # POST /locker_assignments or /locker_assignments.json
  def create
    @locker_assignment = LockerAssignment.new(locker_assignment_params)

    respond_to do |format|
      if @locker_assignment.save
        format.html { redirect_to @locker_assignment, notice: 'Locker assignment was successfully created.' }
        format.json { render :show, status: :created, location: @locker_assignment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @locker_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locker_assignments/1 or /locker_assignments/1.json
  def update
    respond_to do |format|
      if @locker_assignment.update(locker_assignment_params)
        format.html { redirect_to @locker_assignment, notice: 'Locker assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @locker_assignment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locker_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locker_assignments/1 or /locker_assignments/1.json
  def destroy
    @locker_assignment.destroy
    respond_to do |format|
      format.html { redirect_to locker_assignments_url, notice: 'Locker assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_locker_assignment
    @locker_assignment = LockerAssignment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def locker_assignment_params
    params.require(:locker_assignment).permit(:start_date, :end_date, :locker_application_id, :locker_id)
  end

  def force_admin
    return if current_user.admin?

    redirect_to :root, alert: 'Only administrators have access to Locker Assignments!'
  end

end
