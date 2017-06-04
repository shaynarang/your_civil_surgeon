class AddSeriesIdentifierToUnavailableBlocks < ActiveRecord::Migration[5.0]
  def change
    add_column :unavailable_blocks, :series_identifier, :string
  end
end
