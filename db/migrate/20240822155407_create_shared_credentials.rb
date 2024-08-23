class CreateSharedCredentials < ActiveRecord::Migration[7.2]
  def change
    create_table :shared_credentials do |t|
      t.string :original_id, null: false
      t.string :duplicate_id, null: false
      t.string :application_id, null: false
    end
  end
end
