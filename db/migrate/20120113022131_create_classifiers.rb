class CreateClassifiers < ActiveRecord::Migration
  def change
    create_table :classifiers do |t|
      t.string :program_name, :null => false, :limit => 128, :unique => true
      t.text :synopsis, :null => true, :limit => 4.kilobytes    
      t.timestamps
    end
  end
end
