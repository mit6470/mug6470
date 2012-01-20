class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, :null => false, :limit => 64
      t.references :profile, :null => false

      t.timestamps
    end
    add_index :projects, :profile_id, :null => false
  end
end
