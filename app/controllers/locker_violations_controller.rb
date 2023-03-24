# frozen_string_literal: true

class LockerViolationsController < ApplicationController
  before_action :set_violation, only: %i[show edit update destroy]
  before_action :force_admin

  # GET /locker_violations or /locker_violations.json
  def index
    @locker_violations = LockerViolation.all
  end

  # GET /locker_violations/1 or /locker_violations/1.json
  def show; end

  # GET /locker_violations/new
  def new
    @locker_violation = LockerViolation.new(locker_violation_params)
  end

  # GET /locker_violations/1/edit
  def edit; end

  # POST /locker_violations or /locker_violations.json
  def create
    @locker_violation = LockerViolation.new(locker_violation_params)

    respond_to do |format|
      if @locker_violation.save
        UserMailer.with(locker_violation: @locker_violation).locker_violation.deliver
        format.html { redirect_to @locker_violation, notice:  { message: 'LockerViolation was successfully created.', type: 'success' } }
        format.json { render :show, status: :created, location: @locker_violation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @locker_violation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locker_violations/1 or /locker_violations/1.json
  def update
    respond_to do |format|
      if @locker_violation.update(locker_violation_params)
        format.html { redirect_to @locker_violation, notice: { message: 'LockerViolation was successfully updated.', type: 'success' } }
        format.json { render :show, status: :ok, location: @locker_violation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locker_violation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locker_violations/1 or /locker_violations/1.json
  def destroy
    @locker_violation.destroy
    respond_to do |format|
      format.html { redirect_to locker_violations_url, notice:  { message: 'LockerViolation was successfully destroyed.', type: 'success' } }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_violation
    @locker_violation = LockerViolation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def locker_violation_params
    return {} if params[:locker_violation].blank?

    params.require(:locker_violation).permit(:locker_id, :user_id, :number_of_books)
  end

  def force_admin
    return if current_user.admin? && current_user.works_at_enabled_building?

    redirect_to :root, alert: 'Only administrators have access to the Locker Violations!'
  end
end
