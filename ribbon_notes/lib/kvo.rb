# KeyValueObserving (KVO) is a module that enables classes and instances to adhere to key-value-observing.
# key-value-observing means that objects 
# * implement did_change_value_for(:attr) which notifies each object bound to :attr that an update occured
# * implement attribute getters as Object#foo
# * implement attribute setters as Object#foo=(value)
# * calls to Object#foo=(value) trigger did_change_value_for(:foo)
module KeyValueObserving
  attr_accessor :bindings
  
  def self.included(base)
    base.extend(ClassMethods)
    base.extend(SharedMethods)
  end
  
  module SharedMethods
    def did_change_value_for(attribute)
      bindings_for(attribute).each do |binding|
        binding.object.send((binding.attribute + "="), binding.key_path.target_property)
        # binding.object.send((binding.attribute + "="), binding.key_path.follow)
      end
    end
  end
  include SharedMethods
  
  module ClassMethods
    def kvc_accessor(*accessors)
      accessors.each do |accessor|
        self.define_method(accessor) do
          self.instance_variable_get(("@" + accessor))
        end
        self.define_method((accessor.to_s + "=").to_sym) do |value|
          self.instance_variable_set(("@" + accessor), value)
          self.did_change_value_for(accessor.to_s)
        end
      end
    end
  end
end