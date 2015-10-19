RUBIES = ENV['CONE_RUBIES'] || %w(ruby-1.8.7-p299,ruby-1.9.2-p0,jruby-1.5.2,jruby-head)

task :runall do
  chdir('src') do
    ENV['SIMPLE_CONE_OUTPUT'] = 'true'
    sh "rvm #{RUBIES} road_to_victory.rb"
  end
end
