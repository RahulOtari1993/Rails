 module CarouselHelper

  ## Image Load While Editing Carousel Details
  def carousel_image_load
    if @carousel.new_record?
      "<img id='carousel-image-preview' class = 'carousel-image-preview' />"
    else
      "<img id='carousel-image-preview' class = 'carousel-image-preview' src='#{@carousel.image.url(:banner)}'/>"
    end
  end
 end
