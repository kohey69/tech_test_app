class Admins::Events::ReviewsController < Admins::Events::ApplicationController
  def destroy
    @review = @event.reviews.find(params[:id])
    @review.destroy!
    redirect_to admins_event_path(@event), notice: t('controllers.destroyed')
  end
end
