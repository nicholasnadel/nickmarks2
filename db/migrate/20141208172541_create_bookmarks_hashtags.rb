class CreateBookmarksHashtags < ActiveRecord::Migration
  def change
    create_table :bookmarks_hashtags, id: false do |t|
    	t.references :bookmark
    	t.references :hashtag
    end
  end
end
