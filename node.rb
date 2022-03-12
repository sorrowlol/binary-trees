#class for single node
class Node
 
  #include comparable module/mixin (https://docs.ruby-lang.org/en/2.5.0/Comparable.html)
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left_node = nil, right_node = nil)
    @data = data
    @left = left_node
    @right = right_node 
  end
end

