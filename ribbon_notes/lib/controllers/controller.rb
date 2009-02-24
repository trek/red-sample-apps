class Controller
  include KeyValueObserving
  include Bindable
  def self.kvc_accessor(*accessors)
    accessors.each do |accessor|
      self.define_method(accessor) do
        self.instance_variable_get(("@" + accessor.to_s))
      end
      self.define_method((accessor.to_s + "=").to_sym) do |value|
        self.instance_variable_set(("@" + accessor.to_s), value)
        self.did_change_value_for(accessor.to_s)
      end
      m = Module.new((accessor.to_s + "ControllerAttributeModule"))
      m.instance_eval do
        self.define_method(accessor) do
          self.shared_instance.send(accessor)
        end
        
        self.define_method((accessor.to_s + "=").to_sym) do |value|
          self.shared_instance.send((accessor + "="), value)
          self.did_change_value_for(accessor.to_s)
        end
      end
      self.extend(m)
    end
  end
  
  def self.outlet(*accessors)
    @outlets ?  @outlets + accessors : @outlets = accessors
    accessors.each do |accessor|
      self.define_method(accessor) do
        self.instance_variable_get(("@" + accessor.to_s))
      end
      self.define_method((accessor.to_s + "=").to_sym) do |value|
        self.instance_variable_set(("@" + accessor.to_s), value)
      end
      m = Module.new((accessor.to_s + "ControllerOutletModule"))
      
      m.instance_eval do
        self.define_method(accessor) do
          self.shared_instance.send(accessor)
        end
        
        self.define_method((accessor.to_s + "=").to_sym) do |value|
          self.shared_instance.send((accessor + "="), value)
        end
      end
      self.extend(m)
    end
  end
  
  def self.outlets
    @outlets
  end
    
  def self.shared_instance
    @arranged_objects = ArrangedObjects.new
    @shared_instance ||= self.new
  end
end