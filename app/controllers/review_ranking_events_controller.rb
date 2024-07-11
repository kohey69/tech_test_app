class ReviewRankingEventsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @events = Event.published.ended.with_category(params[:category]).order_by_review_score.page(params[:page]).per(10)
  end
end
