class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.string :file_name, :null => false, :unique => true, :limit => 64
      t.text :content, :null => false, :limit => 32.kilobytes
      t.integer :num_attributes, :null => false
      
      t.timestamps
    end
  end
end
