class Events::FavoritesController < Events::ApplicationController
  def create
    current_user.favorites.find_or_create_by!(event: @event) # いいね済みの場合は例外を吐かないように
    redirect_to event_path(@event), notice: t('controllers.created')
  end

  def destroy
    favorite = current_user.favorites.find_by(event: @event)
    favorite&.destroy # windowを複数開いていいねを解除した時に例外を吐かないように
    redirect_to event_path(@event), notice: t('controllers.destroyed')
  end
end
