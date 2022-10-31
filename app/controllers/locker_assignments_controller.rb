# frozen_string_literal: true

class LockerAssignmentsController < ApplicationController
  before_action :set_locker_assignment, only: %i[show edit update destroy card release]
  before_action :force_admin

  # GET /locker_assignments or /locker_assignments.json
  def index
    @pagy, @locker_assignments = pagy(LockerAssignment.order(expiration_date: :desc)
                                                      .order(start_date: :desc)
                                                      .search(queries: query_params)
                                                      .at_building(current_user.building))
  end

  # GET /locker_assignments/1 or /locker_assignments/1.json
  def show; end

  # GET /locker_assignments/1/edit
  def edit; end

  # POST /locker_assignments or /locker_assignments.json
  def create
    @locker_assignment = LockerAssignment.new(locker_assignment_params)
    valid = @locker_assignment.save
    respond_to_create(valid)
    UserMailer.with(locker_assignment: @locker_assignment).locker_assignment_confirmation.deliver if valid
  end

  # PATCH/PUT /locker_assignments/1 or /locker_assignments/1.json
  def update
    valid = @locker_assignment.update(locker_assignment_params)
    respond_to_update(valid)
  end

  # DELETE /locker_assignments/1 or /locker_assignments/1.json
  def destroy
    @locker_assignment.destroy
    respond_to do |format|
      format.html { redirect_to locker_assignments_url, notice: 'Locker assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assignment_report
    @report_data = LockerAssignment.search(queries: { active: true })
                                   .joins(:locker_application)
                                   .group(:department_at_application)
                                   .group(:status_at_application)
                                   .order(:department_at_application).count
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"locker_assignment_report_#{DateTime.now.to_date}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def occupancy_report
    @report_data = StudyRoom.new.space_report.merge(Locker.new.space_report)
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"locker_occupancy_report_#{DateTime.now.to_date}.csv\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def card
    render layout: 'mailer'
  end

  def release
    @locker_assignment.release
    respond_to do |format|
      format.html { redirect_to locker_assignments_url, notice: 'Locker assignment was successfully released.' }
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
    locker_assignment = params.require(:locker_assignment).permit(:start_date, :expiration_date, :locker_application_id, :locker_id, :any_locker_id)
    locker_assignment[:locker_id] ||= locker_assignment.delete(:any_locker_id) if locker_assignment[:any_locker_id].present?
    locker_assignment
  end

  def force_admin
    return if current_user.admin? && current_user.works_at_enabled_building?

    redirect_to :root, alert: 'Only administrators have access to Locker Assignments!'
  end

  def query_params
    query_params = params[:query]&.permit(:uid, :status_at_application, :general_area, :floor, :department_at_application, :active, :daterange)

    query_params.delete(:active) if query_params && query_params[:active] == '0'
    parse_expiration_date(query_params)
  end

  def parse_expiration_date(query_params)
    return query_params if query_params.blank? || query_params[:daterange].blank?

    daterange = query_params.delete(:daterange)
    date = daterange.split(' - ')
    query_params[:expiration_date_start] = Date.strptime(date[0], '%m/%d/%Y')
    query_params[:expiration_date_end] = Date.strptime(date[1], '%m/%d/%Y')
    query_params
  end

  def respond_to_update(valid)
    respond_to_create(valid, message: 'Locker assignment was successfully updated.', error_location: :edit)
  end

  def respond_to_create(valid, message: 'Locker assignment was successfully created.', error_location: 'locker_applications/assign')
    respond_to do |format|
      if valid
        format.html { redirect_to @locker_assignment, notice: message }
        format.json { render :show, status: :created, location: @locker_assignment }
      else
        @locker_application = @locker_assignment.locker_application
        format.html { render error_location, status: :unprocessable_entity }
        format.json { render json: @locker_assignment.errors, status: :unprocessable_entity }
      end
    end
  end
end
