class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.string :title, :null => false, :limit => 128
      t.text :summary, :null => false, :limit => 4.kilobytes
      t.timestamps
    end
  end
end
