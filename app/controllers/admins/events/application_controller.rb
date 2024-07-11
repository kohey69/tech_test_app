class Admins::Events::ApplicationController < Admins::ApplicationController
  before_action :set_event

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
