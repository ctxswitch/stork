
class Foo
  def self.test
    %Q{
      Hello
      World
      Foo
      Bar
    }
  end
end

puts Foo.test