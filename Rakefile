require "spec/rake/spectask"

task :default => :spec
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList["*_spec.rb"]
  t.spec_opts = ["-cfs"]
end
