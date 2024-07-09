class Events::ParticipationsController < Events::ApplicationController
  before_action :redirect_if_event_created_by_current_user, only: [:create]

  def create
    current_user.participations.find_or_create_by!(event: @event) # 参加済みの場合は例外を吐かないように
    redirect_to event_path(@event), notice: t('controllers.created')
  end

  def destroy
    participation = current_user.participations.find_by(event: @event) # windowを複数開いてキャンセルした時に例外を吐かないように
    participation&.destroy!
    redirect_to event_path(@event), notice: t('controllers.destroyed')
  end

  private

  def redirect_if_event_created_by_current_user
    if @event.user == current_user
      redirect_to event_path(@event), alert: 'イベント主催者は参加者として登録できません'
    end
  end
end
