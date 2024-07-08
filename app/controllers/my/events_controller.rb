class My::EventsController < ApplicationController
  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to root_path, notice: t('controllers.created')
    else
      render :new, status: :unprocessable_content, alert: t('controllers.failed')
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :place, :start_at, :end_at, :category)
  end
end