class IncomingController < ApplicationController

  # http://stackoverflow.com/questions/1177863/how-do-i-ignore-the-authenticity-token-for-specific-actions-in-rails
  skip_before_filter :verify_authenticity_token, only: [:create]
  
  def my_library
    @user = User.find(params[:id])
    @my_bookmarks = @user.bookmarks
    authorize! :show, @user, message: "You need to be an account holder."
  end

  def favorites
    @user = User.find(params[:id])
    @favorited_bookmarks = Bookmark.favorited(current_user)
    authorize! :show, @user, message: "You need to be an account holder."
  end

  def show 
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    #decoded_body = nil
    sender = params['sender']
    subject = params['subject']
    body_plain = params["body-plain"]
    user = User.find_by_email  params["sender"]
    if !user  
      head 200 && return
    end
    
    tags_array = params["Subject"].scan(/#\w+/)
    
    hashtags = tags_array.map do |tag|
      Hashtag.first_or_create(title: tag)
    end

    url = /\b(([\w-]+:\/\/?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:<>"]\s]|\/)))/.match(params["body-plain"])
    
    bookmark = user.bookmarks.create(
      url: params[:"body-plain"], 
      hashtag_ids: hashtags.map(&:id))
    
    head 200
  end
end
  