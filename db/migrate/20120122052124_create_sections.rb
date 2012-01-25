class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title, :null => false, :limit => 128
      t.references :tutorial, :null => false
      t.text :content, :null => false, :limit => 32.kilobytes
      
      t.timestamps
    end
    add_index :sections, :tutorial_id, :null => false
  end
end
