require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.pattern = '*_test.rb'
  t.verbose = true
end

task :tt do
  `tt rpl.treetop`
end

task :default => [:tt, :test] do
end
