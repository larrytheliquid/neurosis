require "spec/rake/spectask"

namespace :test do
  desc "Run all tests"
  task :all => [:hunit, :spec]
  
  desc "Run HUnit tests"
  task :hunit do
    `runghc PerceptronTest.hs`
  end

  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_files = FileList["*_spec.rb"]
    t.spec_opts = ["-cfs"]
  end
end
