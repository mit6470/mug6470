class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, :unique => true, :null => false

      t.timestamps
    end
    add_index :profiles, :user_id, :null => false, :unique => true
  end
end
