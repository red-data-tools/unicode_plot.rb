require "bundler/setup"

def clean(version)
  FileUtils.rm_rf("src")
  FileUtils.rm_rf(version)
end

def clone(version)
  system("git", "clone", "-b", "v#{version}", "--", ".", "src")
end

def yard(version)
  system("yard", "-o", version)
end

def update_readme(version)
  File.open("README.md", "a") do |f|
    f.puts "- [#{version}](#{version})"
  end
end

task :yard, [:version] do |t, args|
  unless (version = args[:version])
    $stderr.puts "version is required"
    abort
  end
  clean(version)
  clone(version)
  yard(version)
  update_readme(version)
end
