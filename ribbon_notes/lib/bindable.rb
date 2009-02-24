# Bindable module gives classes and instances a public interface for adding bindings via the 
# Ribbons class.  A Ribbon connects an attribute of the Bindable object to a a path.
# 
# Foo # extends Bindable
# f = Foo.new
# f.bind(:bar, 'BazesController.qux.quux')
# 
# creates a new Ribbon connecting f's :bar attribute to the value of BazesController.qux.quux
# when the value of BazesController.qux.quux changes, it will notify bound objects (including f).
# f will then follow the path again and set it's :bar attribute to the new value.
# 
# Objects that are Bindable must also be KVO-compliant either by including module KeyValueObserving or
# implementing the equivalent methods. 
# 
module Bindable
  def self.included(base)
    base.extend(SharedMethods)
  end
  attr_accessor :bindings
  
  module SharedMethods
    def bind(attribute,path)
      binding = ::Ribbon.new(self,attribute,path)
      self.send((attribute.to_s + "="), binding.key_path.target_property)
      return binding
    end

    def bindings
      @bindings
    end
    
    def bindings_for(attribute)
      @bindings ||= {}
      @bindings[attribute] || []
    end

    def add_binding_for_attribute(binding,attribute)
      @bindings ||= {}
      @bindings[attribute] ? @bindings[attribute] << binding : @bindings[attribute] = [binding]
    end
  end
  include SharedMethods
end