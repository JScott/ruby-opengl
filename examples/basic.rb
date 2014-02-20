#!/usr/bin/env ruby -w
# reworking the first example from the Red Book 8th ed.
# https://github.com/kestess/opengl8thfirstexample

require 'glfw3'
require 'opengl-core'
require 'opengl-core/aux'
require 'snow-data'

include Gl

class Utils
  def self.error_check
    error = glGetError()
    raise "GLError: #{error.to_s(16)}" unless error == GL_NO_ERROR
  end

  def self.compile_shader(type, path)
    shader = Shader.new type
    shader.source = File.open(path).read
    shader.compile
    puts "Compiling #{path}", shader.info_log
    return shader
  end

  def self.create_shader_program(*shaders)
    program = Program.new
    shaders.each { |shader| program.attach_shader shader }
    program.link
    puts "Creating shader program", program.info_log
    return program
  end
end

Glfw.init
window = Glfw::Window.new(800, 600, "Hello Triangles")
window.make_context_current

vaos = VertexArray.new
vaos.bind
Utils.error_check

vertex2 = Snow::CStruct.new {
  float :x
  float :y
}
vertices = vertex2[6]
vertices[0].x, vertices[0].y = -0.90, -0.90
vertices[1].x, vertices[1].y = 0.85, -0.90
vertices[2].x, vertices[2].y = -0.90, 0.85
vertices[3].x, vertices[3].y = 0.90, -0.85
vertices[4].x, vertices[4].y = 0.90, 0.90
vertices[5].x, vertices[5].y = -0.85, 0.90

buffers = Buffer.new GL_ARRAY_BUFFER
buffers.bind
glBufferData GL_ARRAY_BUFFER, vertices.bytesize, vertices.address, GL_STATIC_DRAW
Utils.error_check

vertex_shader = Utils.compile_shader GL_VERTEX_SHADER, "passthru.vert"
fragment_shader = Utils.compile_shader GL_FRAGMENT_SHADER, "passthru.frag"
Utils.error_check

program = Utils.create_shader_program vertex_shader, fragment_shader
program.use
Utils.error_check

glVertexAttribPointer 0, 2, GL_FLOAT, GL_FALSE, 0, 0
glEnableVertexAttribArray 0
Utils.error_check

until window.should_close?
  Glfw.wait_events
  glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
  glDrawArrays GL_TRIANGLES, 0, 6
  window.swap_buffers
end

window.destroy
Glfw.terminate
