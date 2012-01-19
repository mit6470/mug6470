class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.string :name, :null => false, :limit => 32
      t.references :classifier, :null => true
      t.references :datum, :null => true
      t.text :output, :null => true, :limit => 32.kilobytes
      
      t.timestamps
    end
  end
end
