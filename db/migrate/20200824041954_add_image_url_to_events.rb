class AddImageUrlToEvents < ActiveRecord::Migration[6.0]
  def change
  	   add_column :events, :image_url, :string
  end
end
