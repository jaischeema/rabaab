activate :livereload

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'images'

set :haml, :format => :html5

configure :build do
  activate :minify_css
end

activate :deploy do |deploy|
  deploy.method = :git
end
