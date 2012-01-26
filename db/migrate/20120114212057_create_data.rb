class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.string :file_name, :null => false, :unique => true, :limit => 64
      t.string :relation_name, :null => false, :limit => 256
      t.integer :num_examples, :null => false
      t.text :features, :null => false, :limit => 512
      t.integer :num_features, :null => false
      
      t.timestamps
    end
  end
end
