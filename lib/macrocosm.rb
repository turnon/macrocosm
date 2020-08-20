require 'macrocosm/version'
require 'json'

class Macrocosm

  NoCategory = 'no-category'

  def initialize
    category_index = -1
    @categories = Hash.new{ |h, cate| h[cate] = (category_index += 1) }
    @nodes = []
    @links = []
  end

  def add_node(name, category = nil)
    category ||= NoCategory
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
    tmpl = File.join(__dir__, 'macrocosm', 'template.html')
    File.read(tmpl).sub(/\/\/start-sub.*\/\/end-sub/m, to_json)
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
