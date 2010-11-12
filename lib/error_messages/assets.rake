require 'pathname'

namespace :error_messages do
  namespace :assets do

    task :copy_javascripts do
      if plugin_path('public/javascripts/').exist?
        src = plugin_path('public/javascripts/').children
        dest = app_path 'public/javascripts/'
        FileUtils.cp_r src, dest, :verbose => true
      end
    end

    task :copy_stylesheets do
      if plugin_path('public/stylesheets/').exist?
        src = plugin_path('public/stylesheets/').children
        dest = app_path 'public/stylesheets/'
        FileUtils.cp_r src, dest, :verbose => true
      end
    end

    task :copy_images do
      if plugin_path('public/images/').exist?
        src = plugin_path('public/images/').children
        dest = app_path 'public/images/'
        FileUtils.cp_r src, dest, :verbose => true
      end
    end

    desc "Copy assets (i.e. public/) directory to main public/"
    task :copy => [:copy_javascripts, :copy_images, :copy_stylesheets]

    private

    def app_path(path)
      Rails.root + path
    end

    def plugin_path(path)
      Pathname.new(__FILE__).dirname + '../../' + path
    end
  end
end
