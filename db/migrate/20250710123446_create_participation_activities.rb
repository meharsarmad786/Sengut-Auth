class CreateParticipationActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :participation_activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :activity_type
      t.text :activity_data

      t.timestamps
    end
  end
end
