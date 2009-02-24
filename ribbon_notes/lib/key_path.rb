class KeyPath
  def initialize(path)
    @path = path
  end
  
  def self.step_through(path)
    callee = Object.module_eval_with_string_not_block(path.shift)
    while caller = path.shift
      callee = callee.send(caller)
    end
    return callee
  end
  
  def self.step_through_with_assignment(path,set_value)
    set_method = path.pop
    callee = Object.module_eval_with_string_not_block(path.shift)
    while caller = path.shift
      callee = callee.send(caller)
    end
    return callee.send((accessor + "="), set_value)
  end

  def target_object
    KeyPath.step_through(@path.split('.')[0..-2])
  end
  
  def target_property_name
    @path.split('.').last
  end
  
  def target_property
    KeyPath.step_through(@path.split('.'))
  end  
end
