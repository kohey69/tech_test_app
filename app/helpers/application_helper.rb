module ApplicationHelper
  def avatar_path(avatar)
    if avatar.attached?
      avatar.variant(:small)
    else
      'default_avatar.svg'
    end
  end

  def event_category_text(category_value)
    case category_value
    when 'music'
      '音楽イベント'
    when 'sports'
      'スポーツイベント'
    when 'business'
      'ビジネスイベント'
    when 'hobby'
      '趣味イベント'
    when 'other'
      'その他イベント'
    else
      '全て'
    end
  end
end
