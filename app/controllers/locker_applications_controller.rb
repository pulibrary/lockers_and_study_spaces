# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

class LockerApplicationsController < ApplicationController
  before_action :set_locker_application, only: %i[show edit update destroy assign]
  before_action :force_admin, except: %i[new create show]

  # GET /locker_applications or /locker_applications.json
  def index
    @pagy, @locker_applications = pagy(LockerApplication.search(uid: params[:search], archived: false,
                                                                building_id: current_user.building_id).order(:created_at))
  end

  # GET /locker_applications/1 or /locker_applications/1.json
  def show
    force_admin if @locker_application.user != current_user
  end

  # GET /locker_applications/new
  def new
    @locker_application = LockerApplication.new(user: current_user, building_id: current_user.building_id)
  end

  # GET /locker_applications/1/edit
  def edit; end

  # GET /locker_applications/awaiting_assignment
  def awaiting_assignment
    @archived = archived_param
    @pagy, @locker_applications = pagy(LockerApplication.awaiting_assignment.search(uid: nil, archived: @archived, building_id: current_user.building_id))
  end

  # GET /locker_applications/1/assign
  def assign
    @locker_assignment = @locker_application.locker_assignment || LockerAssignment.new(locker_application: @locker_application)
  end

  # PUT /locker_applications/1/toggle_archived
  def toggle_archived
    @locker_application = LockerApplication.find(params[:id])
    @locker_application.update(archived: !@locker_application.archived)
    redirect_back(fallback_location: awaiting_assignment_locker_applications_path)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  # POST /locker_applications or /locker_applications.json
  def create
    @locker_application = LockerApplication.new(locker_application_params)
    force_admin if @locker_application.user != current_user
    return if !current_user.admin? && @locker_application.user != current_user

    @locker_application.preferred_size = 2 if @locker_application.building&.name == 'Lewis Library'

    @locker_application.complete = true if current_user.admin? || !Flipflop.lewis_patrons?
    update_or_create(@locker_application.save, message: 'Locker application was successfully created.', method: :new)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

  # PATCH/PUT /locker_applications/1 or /locker_applications/1.json
  def update
    valid = @locker_application.update(locker_application_params)
    @locker_application.update(complete: true) if valid
    update_or_create(valid)
  end

  # DELETE /locker_applications/1 or /locker_applications/1.json
  def destroy
    @locker_application.destroy
    respond_to do |format|
      format.html { redirect_to locker_applications_url, notice: { message: 'Locker application was successfully destroyed.', type: 'success' } }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_locker_application
    @locker_application = LockerApplication.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def locker_application_params
    @locker_params ||= lookup_objects_from_params
    @locker_params
  end

  def lookup_objects_from_params
    # If a user_uid is not passed in, something suspicious is going on and should raise an error
    params.require(:locker_application).require(:user_uid)
    locker_params = params.require(:locker_application).permit(:preferred_size, :preferred_general_area, :accessible, :semester,
                                                               :status_at_application, :department_at_application, :user_uid,
                                                               :building_id, :complete, accessibility_needs: [])
    locker_params[:accessibility_needs]&.compact_blank!
    locker_params = lookup_user_from_params(locker_params)
    locker_params = lookup_building_from_params(locker_params) if Flipflop.lewis_patrons? && locker_params[:building_id].present?
    locker_params
  end

  def lookup_building_from_params(locker_params)
    building_id = locker_params.delete(:building_id)
    building = Building.find(building_id)
    locker_params[:building] = building
    locker_params
  end

  def lookup_user_from_params(locker_params)
    uid = locker_params.delete(:user_uid)
    user = if current_user.uid == uid
             current_user
           elsif current_user.admin?
             User.from_uid(uid)
           end
    locker_params[:user] = user
    locker_params
  end

  def force_admin
    return if current_user.admin? && current_user.works_at_enabled_building?

    # Non-admins can only edit or update their application if it is not yet complete
    return if (action_name == 'update' || action_name == 'edit') && !@locker_application.complete? && @locker_application.user == current_user

    redirect_to :root, alert: 'Only administrators have access to the everyone\'s Locker Applications!'
  end

  # TODO: Address rubocop error
  # rubocop:disable Metrics/AbcSize
  def update_or_create(valid, message: 'Locker application was successfully updated.', method: :edit)
    respond_to do |format|
      if valid
        if method == :new && Flipflop.lewis_patrons?
          format.html do
            redirect_to edit_locker_application_url(@locker_application), notice: { message: 'Application successfully created', type: 'success' }
          end
        else
          format.html { redirect_to @locker_application, notice: { message:, type: 'success' } }
        end
        format.json { render :show, status: :ok, location: @locker_application }
      else
        @locker_application.user ||= User.new
        format.html { render method, status: :unprocessable_entity }
        format.json { render json: @locker_application.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def archived_param
    return false if params[:archived].blank?

    ActiveModel::Type::Boolean.new.cast(params[:archived])
  end
end

# rubocop:enable Metrics/ClassLength
