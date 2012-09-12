task :default => [:specs, :examples]

desc "Run all specs"
task :specs do
  FileList['spec/*_spec.rb'].sort.each do |spec|
    sh "ruby -I lib #{spec} -e ''"
  end
end

desc "Run all examples"
task :examples do
  puts "Running examples, no output means it works."
  FileList['examples/*_spec.rb'].sort.each do |example|
    sh "ruby -I examples -I lib #{example} -e ''"
  end
end

desc "Add magic encoding to all source files in the project"
task :magic do
  require File.expand_path('../rake/magic_encoding', __FILE__)
  MagicEncoding.apply
end