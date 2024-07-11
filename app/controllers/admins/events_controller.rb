class Admins::EventsController < Admins::ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.default_order.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to admins_event_path, notice: t('controllers.updated')
    else
      flash.now[:alert] = t('controllers.failed')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy!
    redirect_to admins_events_path, notice: t('controllers.destroyed')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :place, :start_at, :end_at, :category, :published)
  end
end
