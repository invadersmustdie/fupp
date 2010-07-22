class RplContext
  class RplContextError < StandardError; end
  class UndefinedVariable < RplContextError; end

  attr_accessor :variables, :last_return

  def initialize
    @variables = {}
    @last_return = nil
  end

  def get_variable(name)
    var = @variables[name]
    raise UndefinedVariable, "no such variable defined #{name.inspect}" if !var

    var
  end

  def set_variable(name, value)
    @variables[name] = value
  end

  def empty?
    @variables.empty? && !@last_return
  end
end
