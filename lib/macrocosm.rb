require 'macrocosm/version'
require 'macrocosm/template'
require 'json'

class Macrocosm

  NoCategory = 'no-category'

  class Links
    MaxCurveness = 0.7
    CurvenessRange = MaxCurveness - 0.1

    def initialize
      @links = []
      @links_on_same_ends = Hash.new{ |h, k| h[k] = 0 }
      @last_curveness = Hash.new{ |h, k| h[k] = MaxCurveness.dup }
    end

    def add_link(source, target, relation_in_list: nil, relation_in_graph: nil, line_style: {})
      ends = [source, target].sort!.join

      link = {
        ends: ends,
        lineStyle: line_style,
        source: source,
        target: target
      }
      link[:relation_in_list] = relation_in_list if relation_in_list
      link[:relation_in_graph] = relation_in_graph if relation_in_graph
      @links << link

      @links_on_same_ends[ends] += 1
    end

    def links
      @links.map do |link|
        link[:lineStyle][:curveness] = calc_curveness(link)
        link.delete(:ends)
        link
      end
    end

    def calc_curveness(link)
      ends = link[:ends]
      count = @links_on_same_ends[ends]
      return 0 if count == 0
      step = (CurvenessRange / count).round(2)
      @last_curveness[ends] -= step
    end
  end

  attr_reader :curveness

  def initialize(curveness: 0)
    category_index = -1
    @categories = Hash.new{ |h, cate| h[cate] = (category_index += 1) }
    @nodes = []
    @links = Links.new

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

  def add_link(source, target, relation_in_list: nil, relation_in_graph: nil, line_style: {})
    @links.add_link(
      source,
      target,
      relation_in_list: relation_in_list,
      relation_in_graph: relation_in_graph,
      line_style: line_style
    )
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
      links: @links.links,
      categories: @categories.keys.sort!.map{ |name| {name: name} }
    })
  end

end
