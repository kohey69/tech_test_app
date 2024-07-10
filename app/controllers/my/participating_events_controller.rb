class My::ParticipatingEventsController < My::ApplicationController
  def index
    @events = current_user.participate_events.not_ended.order_by_start_at.page(params[:page])
  end
end
