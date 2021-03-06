module CustomPunch
  def talk
    p self
    self
  end
end

module CustomPunch2
  def quack
    'quack'
  end
end

module CustomPunch3
  def wobble
  end
end

module ModWithOverride
  def talk
    'talk is cheap'
  end
end

module ModWithNestedMod
  def instance_method_1
  end

  module ClassMethods
    def class_method_1
    end
  end
end

class Animal
end

class Dog < Animal
end

class Kaia < Dog
end
