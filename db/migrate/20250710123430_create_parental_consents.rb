class CreateParentalConsents < ActiveRecord::Migration[7.2]
  def change
    create_table :parental_consents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :parent_name
      t.string :parent_email
      t.datetime :consent_given_at

      t.timestamps
    end
  end
end
