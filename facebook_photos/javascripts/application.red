require '../redshift/redshift'
class PhotoBucket
  def initialize(element)
    @element = element
    @photo_container = element['.photo_table'].first
    @req = Request.new
    c = self
    @req.upon(:request)  { c.show_loader }
    @req.upon(:success)  { c.hide_loader }
    @req.upon(:response) {|response| c.load_photos(response) }
    
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
  
  def load_photos(response)
    puts response
    @photo_container.empty!
    @photo_container.insert(response[:text])
  end
end


Document.ready? do
  Document['.photo_wrapper'].each do |e|
    PhotoBucket.new(e)
  end
end