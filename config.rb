# Site content
set :site_title, 'OpenDevise'
set :site_description, 'OpenDevise is a content strategy and development firm that helps you understand your users and produce effective content that drives the adoption of your technology.'
set :site_keywords, 'content,strategy,content strategy,development,Open Source,community,Asciidoctor,AsciiDoc'
set :site_author, 'OpenDevise Inc.'
set :site_copyright, %(OpenDevise Inc. (c) #{Time.now.year})
set :site_twitter, '@opendevise'

# Site structure
set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'
set :layouts_dir, '_layouts'

# Template engine config
autoload :Asciidoctor, 'asciidoctor'
set :slim, format: :html, sort_attrs: false, pretty: true, disable_escape: true
require 'slim/include'

# Page config
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

helpers do
  def pretty?
    @app.config[:slim][:pretty]
  end
end

# Wire Sprockets to Bower
after_configuration do
  @bower_config = JSON.parse(IO.read %(#{root}/.bowerrc))
  sprockets.append_path File.join root, @bower_config['directory']
  %w(foundation/scss font-awesome/scss).each {|path|
    sprockets.append_path File.join root, @bower_config['directory'], path
  }
  #sprockets.css_compressor = ...
end

# NOTE: The `server` command defaults to the :development environment.
configure :development do
  activate :livereload if ENV['LIVE_RELOAD']
end

# http://opendevise.github.io/opendevise.io
#configure :prelaunch do
#  # Temporarily set asset host until we switch to the top-level domain
#  #activate :asset_host, host: '/opendevise.io', sources: %w(.html)
#  activate :asset_host, host: Proc.new {|asset| (asset.start_with? '//') ? '' : '/opendevise.io' }, sources: %w(.html)
#end

# NOTE: The `build` command defaults to the :production environment.
# http://opendevise.io
configure :production do
  config.slim[:indent] = ''
  require_relative 'lib/css_compressor'
  activate :minify_css, compressor: CssCompressor
  activate :minify_javascript
  activate :google_analytics do |ga|
    ga.tracking_id = 'UA-69249749-1'
    ga.minify = true
  end
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.remote = 'origin'
  deploy.branch = 'gh-pages'
  deploy.commit_message = 'Publish to GitHub pages via Travis CI'
  deploy.commit_message += %| (build #{ENV['TRAVIS_BUILD_NUMBER']})| if ENV['TRAVIS_BUILD_NUMBER']
end
