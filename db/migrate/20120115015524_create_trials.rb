class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.references :classifier, :null => true
      t.references :datum, :null => true
      t.references :profile, :null => false
      t.string :name, :null => false, :limit => 32
      t.text :output, :null => true, :limit => 32.kilobytes
      
      t.timestamps
    end
    
    add_index :trials, :profile_id, :null => false
  end
end
