require 'macrocosm/version'
require 'macrocosm/template'
require 'json'

class Macrocosm

  NoCategory = 'no-category'

  attr_reader :curveness

  def initialize(curveness: 0)
    category_index = -1
    @categories = Hash.new{ |h, cate| h[cate] = (category_index += 1) }
    @nodes = []
    @links = []

    @curveness = curveness
  end

  def add_node(name, category = nil)
    category = (category || NoCategory).to_s
    idx = @categories[category]
    @nodes << {
      name: name,
      category: idx
    }
  end

  def add_link(source, target, relation_in_list: nil, relation_in_graph: nil)
    link = {
      source: source,
      target: target
    }
    link[:relation_in_list] = relation_in_list if relation_in_list
    link[:relation_in_graph] = relation_in_graph if relation_in_graph
    @links << link
  end

  def to_s
    Template.new(
      graph: graph,
      curveness: curveness,
    ).render
  end

  def graph
    JSON.pretty_generate({
      nodes: @nodes,
      links: @links,
      categories: @categories.keys.sort!.map{ |name| {name: name} }
    })
  end

  private

  def to_json
    JSON.pretty_generate({
      nodes: @nodes,
      links: @links,
      categories: @categories.keys.map{ |name| {name: name} }
    })
  end
end
