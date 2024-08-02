class CreateHands < ActiveRecord::Migration[7.1]
  def change
    create_table :hands do |t|
      t.string :cards

      t.timestamps
    end
  end
end
