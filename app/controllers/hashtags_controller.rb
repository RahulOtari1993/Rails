class HashtagsController < ApplicationController
    def new
       @hashtag = @tagable.notes.new
    end
  
    def create
         @hashtag = @tagable.hashtags.new hashtags_params
         @tagable.save
         redirect_to @tagable, notice: "Your tag was successfully posted"
    end
  
      private
        
         def hashtags_params
           params.require(:hashtag).permit(:content)
         end
end