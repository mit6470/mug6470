class CreateTrials < ActiveRecord::Migration
  def change
    create_table :trials do |t|
      t.references :classifier, :null => true
      t.references :datum, :null => true

      t.timestamps
    end
  end
end
