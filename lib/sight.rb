require 'sight/version'
require 'json'

class Sight

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

  def add_link(source, target)
    @links << {
      source: source,
      target: target
    }
  end

  def to_s
    tmpl = File.join(__dir__, 'sight', 'template.html')
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
