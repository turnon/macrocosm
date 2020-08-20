require "test_helper"

class MacrocosmTest < Minitest::Test
  def test_it_works
    s = Macrocosm.new

    s.add_node('p1', 'E')
    s.add_node('p2', 'D')
    s.add_node('p3', 'F')
    s.add_node('p4', 'F')
    s.add_node('p5', 'G')
    s.add_node('p6', 'G')
    s.add_node('p7', 'G')

    s.add_link('p1', 'p2')
    s.add_link('p1', 'p3')
    s.add_link('p2', 'p3')
    s.add_link('p4', 'p5')
    s.add_link('p5', 'p6')
    s.add_link('p6', 'p7')
    s.add_link('p5', 'p7')

    path = File.join(Dir.tmpdir, 'test_macrocosm.html')
    File.open(path, 'w'){ |f| f.puts s.to_s }
  end
end
