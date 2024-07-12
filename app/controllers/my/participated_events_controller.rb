class My::ParticipatedEventsController < My::ApplicationController
  def index
    @events = current_user.participate_events.ended.default_order.page(params[:page])
  end
end
