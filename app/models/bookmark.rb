class Bookmark < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :hashtags
  has_many :votes

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

  def up_votes
     self.votes.where(value: 1).count
  end

  def down_votes
     self.votes.where(value: -1).count
  end

  def points
     self.votes.sum(:value).to_i     
  end 

  def update_rank
     # age = (self.created_at - Time.new(1970,1,1)) / 86400
     new_rank = points 

     self.update_attribute(:rank, new_rank)
  end

  private

  # Possible alternative: after_create, create a +1 vote for the User the Bookmark belongs to
  # (forcing rank update)
  def set_initial_rank
     self.rank = 0
  end

  def create_vote
     self.user.votes.create(value: 1, bookmark: self)
  end
end


