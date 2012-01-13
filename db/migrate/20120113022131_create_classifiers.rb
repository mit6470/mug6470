class CreateClassifiers < ActiveRecord::Migration
  def change
    create_table :classifiers do |t|
      t.string :name
      t.string :program_name

      t.timestamps
    end
  end
end
