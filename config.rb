#page "/path/to/file.html", :layout => false

activate :livereload

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

set :haml, :format => :html5

configure :build do
  ignore 'javascripts/lib/*'
  ignore 'javascripts/vendor/*'

  activate :minify_css
  activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method       = :rsync
  deploy.host         = "home.jaischeema.com"
  deploy.user         = "jais"
  deploy.path         = "/var/www/perann"
  deploy.clean        = true
end

