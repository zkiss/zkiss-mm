source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins

gem "tzinfo-data"
gem "wdm", "~> 0.1.0" if Gem.win_platform?

# activesupport version is a transitive dependency, not used directly
# flagged as vulnerable by github check, so force updating
# https://github.com/advisories/GHSA-j96r-xvjq-r9pg
gem "activesupport", ">= 4.1.11"

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  gem "jekyll-gist"
  gem "jekyll-feed"
  gem "jemoji"
  gem "jekyll-include-cache"
  gem "jekyll-algolia"
end
