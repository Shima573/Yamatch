class AddEquipmentToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :equipment, :text, array: true, default: []
  end
end
