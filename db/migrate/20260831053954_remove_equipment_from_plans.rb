class RemoveEquipmentFromPlans < ActiveRecord::Migration[8.0]
  def change
    remove_column :plans, :equipment, :text
  end
end
