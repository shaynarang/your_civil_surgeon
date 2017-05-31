class RenameColumnsOnUnavailableBlocks < ActiveRecord::Migration[5.0]
  def change
    rename_column :unavailable_blocks, :date_start, :start_date
    rename_column :unavailable_blocks, :date_end, :end_date
    rename_column :unavailable_blocks, :time_start, :start_time
    rename_column :unavailable_blocks, :time_end, :end_time
  end
end
