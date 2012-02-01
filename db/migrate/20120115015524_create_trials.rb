class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.references :project, :null => false
      t.string :name, :null => false, :limit => 32

      t.references :classifier, :null => false
      t.references :datum, :null => false
      t.text :selected_features, :null => false, :limit => 512
      t.text :output, :null => false, :limit => 32.kilobytes
      
      t.integer :test_datum_id, :null => true
      t.string :mode, :null => false, :default => :cv, :limit => 32 
      t.integer :number, :null => false
      
      t.timestamps
    end
    
    add_index :trials, [:project_id, :number], :null => false, :unique => true
  end
end
