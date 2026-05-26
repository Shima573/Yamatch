class AddDetailsToMountains < ActiveRecord::Migration[7.2]
  def change
    # タグ：PostgreSQLの配列機能(array: true)を有効にし、初期値を空の配列([])にします
    add_column :mountains, :tags, :string, array: true, default: []
    add_column :mountains, :region, :string
    add_column :mountains, :best_season, :string

    change_column_default :mountains, :cable_car, from: nil, to: false
    change_column_null :mountains, :cable_car, false, false


    # 今後「読み仮名」や「タグ（配列）」で検索を高速化したい場合、ここにインデックスを追加
    add_index :mountains, :name_kana
    # ポスグレで配列を高速検索するための設定
    add_index :mountains, :tags, using: 'gin'
  end
end
