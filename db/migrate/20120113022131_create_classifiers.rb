class CreateClassifiers < ActiveRecord::Migration
  def change
    create_table :classifiers do |t|
      t.string :type, :null => true
      t.string :name, :null => false, :limit => 32
      t.string :program_name, :null => false, :limit => 128, :unique => true
      
      t.timestamps
    end
    
    add_index :classifiers, [:type, :name], :unique => true, :null => false 
  end
end
