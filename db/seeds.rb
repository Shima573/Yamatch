# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# CSVライブラリを読み込む
require 'csv'

# 既存データの削除
puts "Cleaning up database..."
# Mountain.destroy_all

# CSVファイルの読み込みとデータ作成
puts "Creating mountains based on CSV Data (Automatic normalization)..."

# CSVファイルのパスを指定（db/csv/mountains.csv）
csv_file_path = Rails.root.join('db', 'csv', 'mountains.csv')

# headers: true を指定することで、1行目の見出し（nameやelevationなど）をキーとして扱えます
CSV.foreach(csv_file_path, headers: true) do |row|
  data = {
    name:                row['name'],
    name_kana:           row['name_kana'],
    elevation:           row['elevation'].to_i, # 数値（整数）に変換
    prefecture:          row['prefecture'],
    latitude:            row['latitude'].to_f,  # 数値（浮動小数点）に変換
    longitude:           row['longitude'].to_f, # 数値（浮動小数点）に変換
    raw_physical_grade:  row['raw_physical_grade'].to_i,
    raw_technical_grade: row['raw_technical_grade'],
    has_toilet:          row['has_toilet']&.downcase == 'true', # 大文字小文字対策をして真偽値に変換
    cable_car:           row['cable_car']&.downcase == 'true',
    access_detail:       row['access_detail'],
    main_course:         row['main_course'],
    narrative:           row['narrative'],
    region:              row['region'],
    best_season:         row['best_season'],
    image_url:           row['image_url']
  }

  # 名前が空欄の行（末尾の空行など）は、保存処理をせずに次の行へスキップする
  next if data[:name].blank?

  # タグが存在する場合のみ、カンマで区切って配列にする（配列型カラムの場合）
  if row ['tags'].present?
    data[:tags] = row['tags'].split(',').map(&:strip)
  end

  mountain = Mountain.find_or_initialize_by(name: data[:name])
  mountain.assign_attributes(data)
  mountain.save!
end

puts "Success: Created/Updated #{Mountain.count} mountains from CSV!"
