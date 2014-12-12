class Bookmark < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags

  # validates :url, :format => URI::regexp(%w(http https)), presence: true


  def tags_string
  	self.hashtags.map {|h| h.tag}.join(" ")
  end

  def tags_string=(values)
    # this is how you change the relation - right through the join table, without having to manipulate it directly
    self.hashtags = values.split(" ").map { |s| Hashtag.where(tag: s).first_or_create }
  end

  def self.create_through_email(user_email, tags, url)
    if user = User.where(email: user_email).first
      @bookmark = user.bookmarks.create(url: url, tags_string: tags) 
    end
	end

end

