class CreateUnavailableBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :unavailable_blocks do |t|
      t.date :date_start
      t.date :date_end
      t.time :time_start
      t.time :time_end
      t.text :notes

      t.timestamps
    end
  end
end
