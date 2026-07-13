class RemoveImageFromPhotos < ActiveRecord::Migration[8.0]
  def change
    remove_column :photos, :image, :string
  end
end
