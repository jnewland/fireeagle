desc 'Generate RDoc and upload to RubyForge'
task :website => [:redocs, :publish_website]
