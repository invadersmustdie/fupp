require 'treetop'

require 'rpl_context'
require 'rpl_nodes'

Treetop.load 'rpl'

parser = RplParser.new
ctx = RplContext.new

loop do
  print "> "
  line = gets.chomp
  if line =~ /^\s*print (.*)/
    puts "GET %s" % [ $1 ]
    p ctx.get_variable($1)
  else
    parse_result = parser.parse(line)
    if parse_result
      ctx = parse_result.eval(ctx)
    else
      puts "Error: invalid expression"
    end
  end
end
