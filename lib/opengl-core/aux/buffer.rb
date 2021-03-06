require 'opengl-core/aux/gl'
require 'opengl-core/aux/marked'

class Gl::Buffer < Gl::GlInternalMarked

  attr_reader :name
  attr_reader :target

  def initialize(target, name = nil)
    super()
    @name = (name != 0 && name) || 0
    @target = target
    __mark__ if @name != 0
  end

  def delete
    if @name != 0
      Gl.glDeleteBuffers(@name)
      @name = 0
      super
    end
    self
  end

  def bind(target = nil)
    if @name == 0
      @name = Gl.glGenBuffers(1)[0]
      __mark__
    end
    Gl.glBindBuffer(target || @target, @name)
    self
  end

  def self.unbind(target)
    Gl.glBindBuffer(target, 0)
    self
  end

  def unbind(target = nil)
    self.class.unbind(target || @target)
    self
  end

end
