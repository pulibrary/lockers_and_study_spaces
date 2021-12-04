# frozen_string_literal: true

class StudyRoomsController < ApplicationController
  before_action :set_study_room, only: %i[show edit update destroy]
  before_action :force_admin

  # GET /study_rooms or /study_rooms.json
  def index
    @pagy, @study_rooms = pagy(StudyRoom.order(:location).all)
  end

  # GET /study_rooms/1 or /study_rooms/1.json
  def show; end

  # GET /study_rooms/new
  def new
    @study_room = StudyRoom.new
  end

  # GET /study_rooms/1/edit
  def edit; end

  # POST /study_rooms or /study_rooms.json
  def create
    @study_room = StudyRoom.new(study_room_params)

    respond_to do |format|
      if @study_room.save
        format.html { redirect_to @study_room, notice: 'Study room was successfully created.' }
        format.json { render :show, status: :created, location: @study_room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @study_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /study_rooms/1 or /study_rooms/1.json
  def update
    respond_to do |format|
      if @study_room.update(study_room_params)
        format.html { redirect_to @study_room, notice: 'Study room was successfully updated.' }
        format.json { render :show, status: :ok, location: @study_room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @study_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /study_rooms/1 or /study_rooms/1.json
  def destroy
    @study_room.destroy
    respond_to do |format|
      format.html { redirect_to study_rooms_url, notice: 'Study room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign_users
    @study_rooms = StudyRoom.where(general_area: params[:general_area])
  end

  def update_assignments
    errors = []
    study_room_assignment_params.each do |key, value|
      study_room = StudyRoom.find(key)
      if study_room.present?
        study_room.assign_user(value[:user_netid])
      else
        errors << "Unknown Study Room #{key}"
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_study_room
    @study_room = StudyRoom.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def study_room_params
    params.require(:study_room).permit(:location, :general_area, :notes)
  end

  def study_room_assignment_params
    @study_room_assignment_params ||= params.require(:study_room_assignment).permit!
  end

  def force_admin
    return if current_user.admin?

    redirect_to :root, alert: 'Only administrators have access to the specific Study Room Information!'
  end
end
