class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @events = Event.published.not_ended.order_by_participations_count.page(params[:page])
  end
end
