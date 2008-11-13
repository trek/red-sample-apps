require 'redshift'

class PhotoBucket
  def initialize(element)
    @element = element
    @loader  = @element['#loading']
    @photo_container = element['.photo_table'].first
    @req = Request.new
    @req.upon(:request)  { self.show_loader }
    @req.upon(:success)  { self.hide_loader }
    @req.upon(:response) {|response| self.load_photos(response) }
    
    @element.listen(:click)       { |element,event| self.clicked(element,event)}
    
    self.load_initial_photos
  end
  
  def load_initial_photos
    @req.execute({:url => '/ajax/1.html'})
  end
  
  def hide_loader
    @loader.styles[:display] = 'none'
  end
  
  def show_loader
    @loader.styles[:display] = 'block'
  end
  
  def load_photos(response)
    @photo_container.empty!
    @photo_container.html = response.text
  end
  
  def show_photo(location)
    a = location.properties[:src].split('/')
    a[2] = 'full'
    a = a.join('/')
    @photo_container.empty!
    @photo_container.insert(Element.new('div', {:class => 'full photo'}).insert(Element.new('img', {:src => a})))
  end
  
  def page_to(location)
    @req.execute({:url => location.properties[:href]})
    @element['.pagination .current'].first.remove_class('current')
    location.parent.add_class('current')
  end
  
  def clicked(element,event)
    event.kill!
    container = event.target.parent.parent
    if(container.has_class?('pages'))
      self.page_to(event.target)
    elsif(container.has_class?('photo'))
      self.show_photo(event.target)
    end
  end
end


Document.ready? do
  Document['.photo_wrapper'].each do |e|
    PhotoBucket.new(e)
  end
end