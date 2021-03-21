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

def update_jekyll_config(version)
  content = File.read("_config.yml")
  File.write("_config.yml.orig", content) # backup

  include_section = false
  File.open("_config.yml", "w") do |f|
    content.each_line do |line|
      if include_section
        case line
        when /\A  -/
          # do nothing
        else
          f.puts "  - #{version}"
        end
      elsif line =~ /\Ainclude:/
        include_section = true
      end
      f.print line
    end
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
  update_jekyll_config(version)
end
