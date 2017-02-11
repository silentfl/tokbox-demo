class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  @@opentok = OpenTok::OpenTok.new(
    Rails.application.secrets.api_key,
    Rails.application.secrets.api_secret
  )

  # GET /sessions
  def index
    @sessions = Session.all
  end

  # GET /sessions/1
  def show
    @api_key = Rails.application.secrets.api_key
    @session_id = @session.session_id
    @token = @@opentok.generate_token(@session.session_id)
  end

  # GET /sessions/new
  def new
    @session = Session.new
  end

  # POST /sessions
  def create
    @session = Session.new(session_params)
    #byebug
    @session.session_id = @@opentok.create_session

    if @session.save
      redirect_to action: :index, notice: 'Session was successfully created.'
    else
      render :new
    end
  end

  # DELETE /sessions/1
  def destroy
    @session.destroy
    redirect_to sessions_url, notice: 'Session was successfully destroyed.'
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_session
    @session = Session.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def session_params
    params.fetch(:session, {}).permit(:title)
  end
end
