class ReviewRankingEventsController < ApplicationController
  def index
    @events = Event.with_category(params[:category]).order_by_review_score.page(params[:page]).per(10)
  end
end
