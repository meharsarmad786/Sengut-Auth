class CreateOrganizationMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :organization_memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.string :role
      t.datetime :joined_at

      t.timestamps
    end
  end
end
