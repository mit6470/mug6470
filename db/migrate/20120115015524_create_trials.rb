class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.references :project, :null => false
      t.string :name, :null => false, :limit => 32

      t.references :classifier, :null => false
      t.references :datum, :null => false
      t.string :selected_features, :null => false, :limit => 128
      t.text :output, :null => false, :limit => 32.kilobytes
      
      t.timestamps
    end
    
    add_index :trials, :project_id, :null => false
  end
end
