class My::FavoriteEventsController < My::ApplicationController
  def index
    @events = current_user.favorite_events.page(params[:page]) # has_manyのリレーションで並び順を指定している
  end
end
