class EventsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_event, only: %i[show]

  def index
    @events = Event.published.not_started.order_by_start_at.page(params[:page])
  end

  def show
  end

  private

  def set_event
    @event = Event.published.find(params[:id])
  end
end
