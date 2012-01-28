class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.string :file_path, :null => false, :unique => true, :limit => 512
      t.string :relation_name, :null => false, :limit => 256
      t.text :examples, :null => false, :limit => 32.kilobytes
      t.integer :num_examples, :null => false
      t.text :features, :null => false, :limit => 512
      t.integer :num_features, :null => false
      t.references :profile, :null => true
      t.boolean :is_test, :null => false, :default => false
      
      t.timestamps
    end
    
    add_index :data, :profile_id, :null => true
  end
end
