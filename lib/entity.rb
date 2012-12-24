class Entity
  def self.create &block
    instance = self.new
    closure_self = eval "self", block.binding
    instance.instance_variable_set(:@block_binding_self, closure_self)
    
    evaluator = SafeEvaluator.new(instance)
    evaluator.instance_eval &block
    
    instance
  end

  def method_missing(method, *args, &block)
    @block_binding_self.send method, *args, &block
  end

  class SafeEvaluator < BasicObject
    def initialize obj
      @obj = obj
    end

    def method_missing method_name, *args
      @obj.public_send method_name, *args
    end
  end
end