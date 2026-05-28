module MountainsHelper
  def toilet_label(mountain)
    mountain.has_toilet ? "あり" : "なし"
  end

  def cable_car(mountain)
    mountain.cable_car ? "あり" : "なし"
  end

  def mountain_image(mountain)
    mountain.image_url.presence || "sample/placeholder-mountain.jpg"
  end

  def physical_grade_comment(mountain)
    case mountain.raw_physical_grade
    when 1..3
      "初心者でも挑戦しやすい体力度です。"
    when 4..5
      "長時間歩行に必要な体力が求められます。"
    when 6..10
      "長距離・長時間行動に耐えられる体力が必要です。"
    end
  end

  def technical_grade_comment(mountain)
    case mountain.raw_technical_grade
    when "A"
      "整備された登山道が中心で、初心者にも歩きやすいレベルです。"
    when "B"
      "急登や分かりにくい道があり、基本的な登山経験があると安心です。"
    when "C"
      "岩場や鎖場を含む可能性があり、足元への注意が必要です。"
    when "D"
      "厳しい岩場やガレ場が続き、安定した歩行技術が求められます。"
    when "E"
      "危険箇所を含む上級者向けルートです。十分な経験が必要です。"
    end
  end

  def season_class(season)
    case season
    when "春"
      "spring"
    when "夏"
      "summer"
    when "秋"
      "autumn"
    when "冬"
      "winter"
    end
  end
end
