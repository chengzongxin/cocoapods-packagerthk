SKIP_UNRELEASED_VERSIONS = false

# Specify your gem's dependencies in cocoapods-imy-bin.gemspec


def cp_gem(name, repo_name, branch = 'master', path: false)
  return gem name if SKIP_UNRELEASED_VERSIONS
  opts = if path
           { :path => "./#{repo_name}" }
         else
           url = "https://github.com/chengzongxin/#{repo_name}.git"
           { :git => url, :branch => branch }
         end
  gem name, opts
  p "cp_gem"
  p opts
end

source 'https://rubygems.org'

# Specify your gem's dependencies in cocoapods-packagerthk.gemspec
gemspec

group :development do
  gem 'bacon'
  gem 'mocha-on-bacon'
  gem 'mocha'
  gem 'prettybacon'
  gem 'coveralls', :require => false
  gem 'rubocop'
  gem 'ruby-debug-ide'
  gem 'debase', '0.2.5.beta2'
  
  # gem 'cocoapods-packagerthk', :path => "./cocoapods-packagerthk"
end
