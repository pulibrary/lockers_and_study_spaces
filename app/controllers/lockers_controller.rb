# frozen_string_literal: true

class LockersController < ApplicationController
  before_action :set_locker, only: %i[show edit update destroy]
  before_action :force_admin

  # GET /lockers or /lockers.json
  def index
    @pagy, @lockers = pagy(Locker.search(location: params[:search]).order(:location))
  end

  # GET /lockers/1 or /lockers/1.json
  def show; end

  # GET /lockers/new
  def new
    @locker = Locker.new
  end

  # GET /lockers/1/edit
  def edit; end

  # POST /lockers or /lockers.json
  def create
    @locker = Locker.new(locker_params)

    respond_to do |format|
      if @locker.save
        format.html { redirect_to @locker, notice: 'Locker was successfully created.' }
        format.json { render :show, status: :created, location: @locker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lockers/1 or /lockers/1.json
  def update
    respond_to do |format|
      if @locker.update(locker_params)
        format.html { redirect_to @locker, notice: 'Locker was successfully updated.' }
        format.json { render :show, status: :ok, location: @locker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @locker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lockers/1 or /lockers/1.json
  def destroy
    @locker.destroy
    respond_to do |format|
      format.html { redirect_to lockers_url, notice: 'Locker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_locker
    @locker = Locker.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def locker_params
    params.require(:locker).permit(:location, :size, :general_area, :accessible, :boolean, :notes, :combination,
                                   :code, :tag, :discs, :clutch, :hubpos, :key_number, :floor)
  end

  def force_admin
    return if current_user.admin?

    redirect_to :root, alert: 'Only administrators have access to the specific Locker information!'
  end
end
