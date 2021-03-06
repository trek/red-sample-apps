# Ribbons connect Bindable objects to the attrbiute values of other objects.  
# When a bound objects's attribute value is updated, the ribbon notifies the Bindable
# Bound objects must adhere to the KVO interface.
class Ribbon
  attr_reader :key_path, :object, :attribute
  def initialize(object, attribute, key_path)
    @object = object
    @attribute = attribute    
    @key_path = KeyPath.new(key_path)
    @bound_object = @key_path.target_object
    @bound_property = @key_path.target_property_name
    self.connect
  end
  
  def connect
    puts @bound_object.inspect
    @bound_object.add_binding_for_attribute(self,@bound_property)
  end
end
