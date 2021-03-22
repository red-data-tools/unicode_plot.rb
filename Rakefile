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
  content = File.read("README.md")
  File.write("README.md.orig", content) # backup

  File.open("README.md", "w") do |f|
    versions_section = false
    versions = [version]
    puts_version_entries = lambda do |f|
      versions.sort.reverse.each do |version|
        f.puts "- [#{version}](#{version})"
      end
    end
    content.each_line do |line|
      line.chomp!
      if versions_section
        case line.chomp
        when /\A\s*-\s*\[(.+)\]/
          versions << $1.chomp
          next
        else
          puts_version_entries.(f)
          versions_section = false
        end
      elsif line =~ /\A## Documentation/
        versions_section = true
      end
      f.puts line
    end
    puts_version_entries.(f) if versions_section
  end
end

def update_jekyll_config(version)
  content = File.read("_config.yml")
  File.write("_config.yml.orig", content) # backup

  new_entry = "  - #{version}"
  File.open("_config.yml", "w") do |f|
    include_section = false
    entries = [version]
    puts_entries = lambda do |f|
      entries.sort.each do |entry|
        f.puts "  - #{entry}"
      end
    end
    content.each_line do |line|
      line.chomp!
      if include_section
        case line
        when /\A\s*-\s*(.+)\z/
          entries << $1
          next
        else
          puts_entries.(f)
          include_section = false
        end
      elsif line =~ /\Ainclude:/
        include_section = true
      end
      f.puts line
    end
    puts_entries.(f) if include_section
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
