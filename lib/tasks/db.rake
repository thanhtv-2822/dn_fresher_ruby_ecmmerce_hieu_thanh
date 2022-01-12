namespace :db do
  desc "Drop, create, migrate and seed database"
  task my_setup_db: :environment do
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:schema:load"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:seed"].invoke
  end
end
