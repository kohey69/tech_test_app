class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @events = Event.published.not_started.order_by_participations.page(params[:page])
  end
end
