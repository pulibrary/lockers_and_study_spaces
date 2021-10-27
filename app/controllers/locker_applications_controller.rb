# frozen_string_literal: true

class LockerApplicationsController < ApplicationController
  before_action :set_locker_application, only: %i[show edit update destroy]
  before_action :force_admin, except: [:new, :create, :show]

  # GET /locker_applications or /locker_applications.json
  def index
    @locker_applications = LockerApplication.all
  end

  # GET /locker_applications/1 or /locker_applications/1.json
  def show
    force_admin if @locker_application.user != current_user
  end

  # GET /locker_applications/new
  def new
    @locker_application = LockerApplication.new
  end

  # GET /locker_applications/1/edit
  def edit; end

  # POST /locker_applications or /locker_applications.json
  def create
    @locker_application = LockerApplication.new(locker_application_params)
    force_admin if @locker_application.user != current_user
    return if !current_user.admin? && @locker_application.user != current_user

    respond_to do |format|
      if @locker_application.save
        format.html { redirect_to @locker_application, notice: 'Locker application was successfully created.' }
        format.json { render :show, status: :created, location: @locker_application }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @locker_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locker_applications/1 or /locker_applications/1.json
  def update
    respond_to do |format|
      if @locker_application.update(locker_application_params)
        format.html { redirect_to @locker_application, notice: 'Locker application was successfully updated.' }
        format.json { render :show, status: :ok, location: @locker_application }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locker_application.errors, status: :unprocessable_entity }
      end
    end
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
    params.require(:locker_application).permit(:preferred_size, :preferred_general_area, :accessible, :semester,
                                               :staus_at_application, :department_at_application, :user_id)
  end

  def force_admin
    return if current_user.admin?

    redirect_to :root, alert: 'Only administrators have access to the everyone\'s Locker Applications!'
  end
end
