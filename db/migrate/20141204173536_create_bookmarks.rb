class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :url
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
