require 'redshift'
class PhotoBucket
  def initialize(element)
    @element = element
    @req = Request.new
    # @req.upon(:request)  { self.show_loader }
    # @req.upon(:success)  { self.hide_loader }
    # @req.upon(:response) { self.load_photos }
    
    self.load_initial_photos
  end
  
  def load_initial_photos
    @req.execute({:url => '/ajax/1.html'})
  end
  
  def hide_loader
    @element['#loading'].styles[:display] = 'none'
  end
  
  def show_loader
    @element['#loading'].styles[:display] = 'block'
  end
  
  def load_photos
    
  end
end


Document.ready? do
  Document['.photo_wrapper'].each do |e|
    PhotoBucket.new(e)
  end
end