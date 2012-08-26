require "bundler"
require "kramdown"
require "sanitize"
require "lib/uuid"
require "date"

###
# URLs
###

activate :directory_indexes

# Assemble resources to generate archive pages, Atom & JSON feeds


### 
# Compass
###

# Susy grids in Compass
# First: gem install compass-susy-plugin
# require 'susy'

# Change Compass configuration
compass_config do |config|
  config.output_style = :compact
  config.line_comments = false
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  # Properly format a content_entry_asset
  def entry_asset(img, url = nil)
    img_tag = image_tag img[:url], :itemprop => "image", :alt => img[:alt], :title => img[:title]
    unless url.nil?
      img_tag = link_to img_tag, url
    end
    '<div class="entry-content-asset photo-full">' + img_tag + '</div>'
  end

  # Strip all HTML tags from string
  def strip_tags(html)
    Sanitize.clean(html.strip).strip
  end
end

###
# Asset folders
###

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'

###
# Template settings
###
set :markdown_engine, :kramdown
set :markdown, :layout_engine => :erb, :tables => true, :autolink => true

ready do
  @pages = sitemap.resources.find_all{|p| p.destination_path.split('/')[0] == 'work' }.sort {|a,b| b.data['date'] <=> a.data['date']}
end

###
# Page settings
###
page "/index.html", :layout => false
page "404.html", :layout => false
page "/work/index.html", :layout => false
page "/sitemap.xml", :layout => "sitemap.xml"


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  activate :asset_hash
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end