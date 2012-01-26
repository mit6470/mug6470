class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.references :datum, :null => false
      t.text :content, :null => false, :limit => 1.kilobyte
      t.integer :example_id, :null => false
    end
    add_index :examples, [:datum_id, :example_id], :null => false, 
                                                   :unique => true
  end
end
