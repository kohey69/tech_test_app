class My::EventsController < My::ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = current_user.events.default_order.page(params[:page])
  end

  def show
  end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to my_event_path(@event), notice: t('controllers.created')
    else
      flash.now[:alert] = t('controllers.failed')
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to my_event_path(@event), notice: t('controllers.updated')
    else
      flash.now[:alert] = t('controllers.failed')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy!
    redirect_to my_events_path, notice: t('controllers.destroyed')
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :place, :start_at, :end_at, :category, :published)
  end

  def set_event
    @event = current_user.events.find(params[:id])
  end
end
