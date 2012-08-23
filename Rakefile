task :default => :spec
task :test    => :spec

desc "Run all example specs"
task :spec do
  FileList['examples/*'].sort.each do |example|
    sh "ruby -I lib #{example} -e ''"
  end
end
