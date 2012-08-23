task :default => :spec
task :test    => :spec

desc "Run all example specs"
task :spec do
  puts "Running examples, no output means it works."
  FileList['examples/*_spec.rb'].sort.each do |example|
    sh "ruby -I examples -I lib #{example} -e ''"
  end
end
