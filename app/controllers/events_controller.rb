class EventsController < ApplicationController
  before_action :set_event, only: %i[show]

  def index
    @events = Event.published.not_started.order(start_at: :asc, id: :asc).page(params[:page])
  end

  def show
  end

  private

  def set_event
    @event = Event.published.not_started.find(params[:id])
  end
end
