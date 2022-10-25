# frozen_string_literal: true

class ScheduledMessagesController < ApplicationController
  before_action :set_scheduled_message, only: %i[show edit update destroy]
  before_action :force_admin
  helper_method :method_missing

  # GET /scheduled_messages or /scheduled_messages.json
  def index
    @sent_messages = ScheduledMessage.already_sent
    @upcoming_messages = ScheduledMessage.not_yet_sent
  end

  # GET /scheduled_messages/1 or /scheduled_messages/1.json
  def show; end

  # GET /scheduled_messages/new
  def new
    @scheduled_message = ScheduledMessage.new
  end

  # GET /scheduled_messages/1/edit
  def edit; end

  # POST /scheduled_messages or /scheduled_messages.json
  def create
    @scheduled_message = ScheduledMessage.new(scheduled_message_params)

    respond_to do |format|
      if @scheduled_message.save
        format.html { redirect_to @scheduled_message, notice: 'Scheduled message was successfully created.' }
        format.json { render :show, status: :created, location: @scheduled_message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @scheduled_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scheduled_messages/1 or /scheduled_messages/1.json
  def update
    respond_to do |format|
      if @scheduled_message.update(scheduled_message_params)
        format.html { redirect_to @scheduled_message, notice: 'Scheduled message was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduled_message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @scheduled_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scheduled_messages/1 or /scheduled_messages/1.json
  def destroy
    @scheduled_message.destroy

    respond_to do |format|
      format.html { redirect_to scheduled_messages_url, notice: 'Message was successfully removed from the schedule.' }
      format.json { head :no_content }
    end
  end

  private

  def force_admin
    return if current_user.admin? && current_user.works_at_enabled_building?

    redirect_to :root, alert: 'Only administrators have access to modify scheduled messages'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_scheduled_message
    @scheduled_message = ScheduledMessage.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def scheduled_message_params
    params.permit(:schedule, :applicable_range, :template, :user_filter, :type, :results)
  end

  # Allow all the route helper methods from subclassed controllers (e.g. new_scheduled_message_path) to
  # use the methods from this controller instead
  def method_missing(method_name, *args, &block)
    if method_name =~ /scheduled_message.*(path|url)/
      case controller_name
      when 'locker_renewal_messages'
        send(method_name.to_s.gsub('scheduled_message', 'locker_renewal_message'), *args, &block)
      end
    else
      super
    end
  end

  def respond_to_missing?(method_name, *args)
    method_name =~ /scheduled_message.*(path|url)/ or super
  end
end
