class RemoveGradeSourcePrefectureFromMountains < ActiveRecord::Migration[7.2]
  def change
    remove_column :mountains, :grade_source_prefecture, :string
  end
end
