class AddPlanToActivityRecords < ActiveRecord::Migration[8.0]
  def change
    add_reference :activity_records, :plan, foreign_key: true
  end
end
