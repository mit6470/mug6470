class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.references :project, :null => false
      t.string :name, :null => false, :limit => 32

      t.references :classifier, :null => true
      t.references :datum, :null => true
      t.text :output, :null => true, :limit => 32.kilobytes
      t.string :selected_features, :null => true, :limit => 128
      
      t.timestamps
    end
    
    add_index :trials, :project_id, :null => false
  end
end
