class CreateAgeGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :age_groups do |t|
      t.string :name
      t.integer :min_age
      t.integer :max_age
      t.text :description

      t.timestamps
    end
  end
end
