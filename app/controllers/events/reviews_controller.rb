class Events::ReviewsController < Events::ApplicationController
  before_action :redirect_if_event_not_ended, only: %i[new create]
  before_action :set_review, only: [:destroy]

  def new
    @review = current_user.reviews.build
  end

  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      redirect_to event_path(@event), notice: t('controllers.created')
    else
      flash.now[:alert] = t('controllers.failed')
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    @review.destroy!
    redirect_to event_path(@event), notice: t('controllers.destroyed')
  end

  private

  def set_review
    @review = current_user.reviews.find_by!(event_id: @event.id)
  end

  def review_params
    params.require(:review).permit(:content, :score).merge(event_id: @event.id)
  end

  def redirect_if_event_not_ended
    if @event.not_ended?
      redirect_to event_path(@event), alert: 'レビューはイベント終了後に作成できます'
    end
  end
end
