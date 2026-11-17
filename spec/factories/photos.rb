FactoryBot.define do
  factory :photo do
    # 登山記録のテストデータも自動で作成して紐づける
    association :activity_record

    after(:build) do |photo|
      image_path = Rails.root.join("spec", "fixtures", "files", "test_image.png")

      # ここで画像を添付する
      photo.image.attach(
        io: File.open(image_path),
        filename: "test_image.png",
        content_type: "image/png"
      )
    end
  end
end
