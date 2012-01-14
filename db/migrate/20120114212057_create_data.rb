class CreateData < ActiveRecord::Migration
  def change
    create_table :data do |t|
      t.string :file_name, :null => false, :unique => true

      t.timestamps
    end
  end
end
