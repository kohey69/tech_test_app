class Events::ApplicationController < ApplicationController
  before_action :set_event

  private

  def set_event
    @event = Event.published.find(params[:event_id])
  end
end
