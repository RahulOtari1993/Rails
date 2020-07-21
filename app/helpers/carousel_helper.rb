 module CarouselHelper

  ## Image Load While Editing Carousel Details
  def carousel_image_load
    if @carousel.new_record?
      "<img id='reward-image-preview' class = 'reward-image-preview' />"
    else
      "<img id='reward-image-preview' class = 'reward-image-preview' src='#{@carousel.image.url(:banner)}'/>"
    end
  end
 end
