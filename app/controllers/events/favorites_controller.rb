class Events::FavoritesController < Events::ApplicationController
  before_action :redirect_if_event_created_by_current_user, only: [:create]

  def create
    current_user.favorites.find_or_create_by!(event: @event) # いいね済みの場合は例外を吐かないように
    redirect_to event_path(@event), notice: t('controllers.created')
  end

  def destroy
    favorite = current_user.favorites.find_by(event: @event)
    favorite&.destroy # windowを複数開いていいねを解除した時に例外を吐かないように
    redirect_to event_path(@event), notice: t('controllers.destroyed')
  end

  private

  def redirect_if_event_created_by_current_user
    if @event.user == current_user
      redirect_to event_path(@event), alert: 'イベント主催者はお気に入り登録できません'
    end
  end
end
