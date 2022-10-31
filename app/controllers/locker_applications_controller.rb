# frozen_string_literal: true

class LockerApplicationsController < ApplicationController
  before_action :set_locker_application, only: %i[show edit update destroy assign]
  before_action :force_admin, except: %i[new create show]

  # GET /locker_applications or /locker_applications.json
  def index
    @pagy, @locker_applications = pagy(LockerApplication.search(uid: params[:search]).order(:created_at))
  end

  # GET /locker_applications/1 or /locker_applications/1.json
  def show
    force_admin if @locker_application.user != current_user
  end

  # GET /locker_applications/new
  def new
    @locker_application = LockerApplication.new(user: current_user)
  end

  # GET /locker_applications/1/edit
  def edit; end

  # GET /locker_applications/awaiting_assignment
  def awaiting_assignment
    @pagy, @locker_applications = pagy(LockerApplication.awaiting_assignment)
  end

  # GET /locker_applications/1/assign
  def assign
    @locker_assignment = @locker_application.locker_assignment || LockerAssignment.new(locker_application: @locker_application)
  end

  # POST /locker_applications or /locker_applications.json
  def create
    @locker_application = LockerApplication.new(locker_application_params)
    force_admin if @locker_application.user != current_user
    return if !current_user.admin? && @locker_application.user != current_user

    update_or_create(@locker_application.save, message: 'Locker application was successfully created.', method: :new)
  end

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
      format.html { redirect_to locker_applications_url, notice: 'Locker application was successfully destroyed.' }
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
    locker_params = params.require(:locker_application).permit(:preferred_size, :preferred_general_area, :accessible, :semester,
                                                               :status_at_application, :department_at_application, :user_uid, :building_id, :complete)

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
           else
             User.find_by(uid: uid)
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
          format.html { redirect_to edit_locker_application_url(@locker_application) }
        else
          format.html { redirect_to @locker_application, notice: message }
        end
        format.json { render :show, status: :ok, location: @locker_application }
      else
        @locker_application.user ||= User.new
        format.html { redirect_to(action: method, id: @locker_application.id) }
        format.json { render json: @locker_application.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
end
