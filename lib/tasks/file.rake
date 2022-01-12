namespace :file do
  desc "Create file example and add main file to .gitignore"
  task :create_example do
    gitignore = File.open Rails.root.join(".gitignore"), "a"

    file_names = [
      "config/database.yml",
      "config/application.yml"
    ]

    text = File.read Rails.root.join(".gitignore")

    file_names.each do |f|
      example = f + ".example"
      FileUtils.cp f, example unless File.exist? f
      gitignore << f + "\n" unless text.include? f
    end

    gitignore.close
  end

  desc "Remove comment, redundant line and replace (') to (\") in Gemfile"
  task :remove_comment do
    file_name = "Gemfile"

    text = File.read file_name

    content = text.gsub(/^\s*#.*/, "")
    content = content.gsub(/'/, '"')
    content = content.gsub(/^$\n+/, "\n")

    File.open(file_name, "w"){|f| f.puts content}
  end
end
