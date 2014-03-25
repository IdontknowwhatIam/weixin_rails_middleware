require 'rails/generators/active_record'

module WeixinRailsMiddleware
  module Generators
    class MigrationGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      # desc 'Adds a Wexin Secret Key for your application.'
      # def create_migration_file
      #   migration_template "add_weixin_secret_key_and_weixin_token_migration.rb", "db/migrate/add_weixin_secret_key_and_weixin_token_to_#{plural_name}.rb"
      # end

      def inject_model_content

        content = <<-CONTENT
  # It will auto generate weixin token and secret
  include WeixinRailsMiddleware::AutoGenerateWeixinTokenSecretKey

CONTENT

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      private

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

    end
  end
end
