require 'treetop'
require 'test/unit'

require 'rpl_context'
require 'rpl_nodes'

Treetop.load 'rpl'

class RplTestSuite < Test::Unit::TestCase
  def setup
    @parser = RplParser.new
    @ctx = RplContext.new
  end

  def test_foo
    @parser.parse("$id;")
    @parser.parse("$id")

    @parser.parse("123")
    @parser.parse("$id = 123")
    @parser.parse("$a + $b")
  end


  def test_undefined_variable
    assert_raise(RplContext::UndefinedVariable, "no such variable defined \"foo\"") do
      @ctx.get_variable "foo"
    end
  end

  def test_assignment_number
    c = @parser.parse("$id = 52;").eval(@ctx)
    assert_equal 52, c.variables['$id']
  end

  def test_assignment_string
    c = @parser.parse("$id = 'foobar';").eval(@ctx)
    assert_equal 'foobar', c.variables['$id']
  end

  def test_copy_value
    c = @parser.parse("$a = 2;").eval(@ctx)
    c = @parser.parse("$b = $a;").eval(c)

    assert_equal 2, c.variables['$a']
  end

  def test_assignment_operation
    c = @parser.parse("$a = 2 + 3;").eval(@ctx)
    assert_equal 5, c.get_variable('$a')
  end

  def test_assignment_variables
    c = @parser.parse("$a = 2;").eval(@ctx)
    c = @parser.parse("$b = 4;").eval(c)
    c = @parser.parse("$a + $b;").eval(c)

    assert_equal 6, c.last_return
    c = @parser.parse("$c = $a + $b;").eval(c)

    assert_equal 6, c.variables['$c']
  end

  def test_operation_numbers
    c = @parser.parse("4 + 2;").eval(@ctx)
    assert_equal 6, c.last_return
  end

  def test_operation_variables
    c = @parser.parse("$a = 4;").eval(@ctx)
    c = @parser.parse("$b = 2;").eval(c)
    c = @parser.parse("$a + $b;").eval(c)

    assert_equal 6, c.last_return
  end

  def test_number
    c = @parser.parse("1;").eval(@ctx)
    assert c.empty?
  end

  def _skipped_test_comment
    c = @parser.parse("#;")
    assert /SyntaxNode\+Comment/ =~ c.elements.first.inspect.split("\n").first
  end

  def _skipped_test_more_statements
    c = @parser.parse("$a = 1; $b = 2").eval(@ctx)
    p c
  end
end
