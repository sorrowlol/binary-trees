require_relative 'node'
require 'pry-byebug'
#tree class
class Tree
  attr_accessor :root, :data
  #initialize with array [1,2,3,4] and call the build_tree function with array
  def initialize array
    @data = array.sort.uniq
    @root = build_tree @data
  end

  def build_tree(array, start = 0, last = array.length-1)
    #base case
    return nil if start > last
    middle = (start+last) / 2
    #create new Node object
    tree_node = Node.new(array[middle])
    #recursion starts
    tree_node.left = build_tree(array, start, middle-1)
    tree_node.right = build_tree(array, middle+1, last)
    #return tree_node to @root
    tree_node
  end
   
  def insert_node(new_node, node = @root)
    #base_case
    if node.nil?
      node = Node.new new_node
      return node
    end
    #recursion starts
    if node.data > new_node
      node.left = insert_node(new_node, node.left)
    elsif node.data < new_node
      node.right = insert_node(new_node, node.right)
    end
    node
  end

  def delete_node(this_node, node = @root)
    #base_case
    return this_node if node.nil?
    #recursion_starts
    if this_node < node.data
      node.left = delete_node(this_node, node.left)
    elsif this_node > node.data
      node.right = delete_node(this_node, node.right)
    #if node to be deleted == root node
    else 
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end
      temp = min_value_node(node.right)
      node.data = temp.data
      node.right = delete_node(temp.data, node.right)
    end
    node
  end

  #finds the lowest value node in tree
  def min_value_node(node)
    min_node = node
    while(!min_node.left.nil?)
      min_node = min_node.left
    end
    min_node
  end


  def find(find_node, node = @root)
    #base case
    return node if node.nil? || node.data.equal?(find_node)
    
    #recursion starts
    if find_node < node.data
     find(find_node, node.left)
    else 
     find(find_node, node.right)
    end
  end

  #breadth-first with iteration
  #if block given return each node else return array of data
  def level_order_i
    queue = [@root]
    if block_given?
      until queue.empty?
        yield(queue.first)
        queue << queue.first.left unless queue.first.left.nil?
        queue << queue.first.right unless queue.first.right.nil?
        queue.shift
      end
    else
      self.data
    end
  end

  #breadth-first with recursion
  #if block given return each node else return array of data
  def level_order_r(root = [@root], &block)
    queue = root 
    return if queue.empty?
    if block_given?
      yield(queue.first)
      queue << queue.first.left unless queue.first.left.nil?
      queue << queue.first.right unless queue.first.right.nil?
      queue.shift
      level_order_r(queue, &block)
    else
      self.data
    end
  end

  #depth-first: pre-order
  def pre_order(node = @root)
    return if node.nil?
    p node.data
    pre_order(node.left)
    pre_order(node.right)
  end

  #depth-first: in_order
  def in_order(node = @root)
    return if node.nil?
    pre_order(node.left)
    p node.data
    pre_order(node.right)
  end

  #depth-first: in_order
  def post_order(node = @root)
    return if node.nil?
    post_order(node.left)
    post_order(node.right)
    p node.data
  end

  def height(node = @root)
    unless node.nil? || node == root
      node = (node.instance_of?(Node) ? find(node.data) : find(node))
    end
    #base case
    return -1 if node.nil?
    #recursion starts
    left_height = height(node.left)
    right_height = height(node.right)

    if left_height > right_height
      left_height + 1
    else
      right_height + 1
    end
  end

  def depth(find_node, node = @root)
    return -1 if node.nil?

    distance = -1
    return distance + 1 if node.data == find_node

    distance = depth(find_node, node.left)
    return distance + 1 if distance >= 0

    distance = depth(find_node, node.right)
    return distance + 1 if distance >= 0

    distance
  end

  def balanced?(node = root)
    return true if node.nil?
    left_height = height(node.left)
    right_height = height(node.right)
    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
    false
  end

  def rebalance
    self.data = inorder_array
    self.root = build_tree(data)
  end

  def inorder_array(node = root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.data
      inorder_array(node.right, array)
    end
    array
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

#TEST

array = Array.new(10) { rand(1..100) }
bst = Tree.new(array)

bst.pretty_print

p bst.balanced?
p "LEVEL-ORDER (breadth-first) - recursion"
p bst.level_order_r
p "LEVEL-ORDER (breadth-first) - iteration"
p bst.level_order_i
p "PRE-ORDER:"
p bst.pre_order
p "POST-ORDER:"
p bst.post_order
p "IN-ORDER:"
p bst.in_order
p bst.insert_node(rand(100..200))
p bst.insert_node(rand(100..200))
p bst.insert_node(rand(100..200))

bst.pretty_print

p bst.balanced?
p bst.rebalance

bst.pretty_print

p "LEVEL-ORDER (breadth-first) - recursion"
p bst.level_order_r
p "LEVEL-ORDER (breadth-first) - iteration"
p bst.level_order_i
p "PRE-ORDER:"
p bst.pre_order
p "POST-ORDER:"
p bst.post_order
p "IN-ORDER:"
p bst.in_order
