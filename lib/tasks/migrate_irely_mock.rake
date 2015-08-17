namespace :diplomat do
  namespace :irely do
    namespace :db do
      desc 'Create iRely mock database for development and testing'
      task create: :environment do
        with_engine_connection do
          configuration = # rubocop is being stupid here
            ActiveRecord::Base
            .configurations
            .values_at(irely_configuration_key)
            .first
          ActiveRecord::Tasks::DatabaseTasks.create(configuration)
        end
      end

      desc 'Migrate iRely mock tables for development and testing'
      task migrate: :environment do
        with_engine_connection do
          ActiveRecord::Migrator.migrate(
            "#{File.dirname(__FILE__)}/../../db/migrate/irely_mock",
            ENV['VERSION'].try(:to_i))
        end
      end
    end
  end
end

def irely_configuration_key
  "irely_#{Rails.env}".to_sym
end

# Hack to temporarily connect AR::Base to your engine.
def with_engine_connection
  original = ActiveRecord::Base.remove_connection
  ActiveRecord::Base.establish_connection(irely_configuration_key)
  yield
ensure
  ActiveRecord::Base.establish_connection(original)
end
