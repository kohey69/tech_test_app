module ApplicationHelper
  def avatar_path(avatar)
    if avatar.attached?
      avatar.variant(:small)
    else
      'default_avatar.svg'
    end
  end
end
