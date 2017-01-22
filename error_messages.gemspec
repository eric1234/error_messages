Gem::Specification.new do |s|
  s.name = 'error_messages'
  s.version = '0.4.0'
  s.homepage = 'http://github.com/eric1234/error_messages'
  s.author = 'Eric Anderson'
  s.email = 'eric@pixelwareinc.com'
  s.license = 'Public domain'
  s.add_dependency 'rails'
  s.add_dependency 'sass-rails'
  s.files = Dir['**/*.rb'] + Dir['**/*.rake'] + Dir['**/*.erb'] +
    Dir['**/*.js'] + Dir['**/*.scss'] + Dir['**/*.png'] +
    Dir['**/*.coffee']
  s.has_rdoc = true
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'
  s.summary = 'Provides some help in outputting and styling errors'
  s.description = <<-DESCRIPTION
    Provides some default style and images to give the error and flash
    messages a nice look as well as highlight problem fields. Also
    provides a helper to actually output the flash messages.
  DESCRIPTION
end
