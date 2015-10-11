autoload :FileUtils, 'fileutils'

desc 'Execute the middleman build command'
task :build do
  run 'middleman build -e production'
end

desc 'Execute the middleman deploy command'
task :deploy do
  run 'middleman deploy'
end

namespace :travis do
  desc 'Deploy to GitHub Pages from within a Travis CI build'
  task :deploy do
    # QUESTION doesn't the branches configuration in .travis.yml already cause PRs to be skipped?
    next if %(#{ENV['TRAVIS_PULL_REQUEST']}).to_i > 0
    begin
      FileUtils.rm_r 'build' if File.exist? 'build'
      repo = %x(git config remote.origin.url).chomp.sub /^git@github.com:/, 'https://github.com/'
      run %(git clone -q --branch=gh-pages --depth=1 #{repo} build), ignore_failure: true
      if Dir.exist? 'build'
        Dir.chdir 'build' do
          FileUtils.rm_r Dir.entries('.') - ['.', '..', '.git'], secure: true
        end
      else
        Dir.mkdir 'build'
        Dir.chdir 'build' do
          run %(git init .)
          run %(git remote add origin #{repo})
        end
      end
      Dir.chdir 'build' do
        run 'git config credential.helper "store --file=.git/credentials"'
        IO.write '.git/credentials', %(https://#{ENV['GITHUB_USER']}:#{ENV['GITHUB_TOKEN']}@github.com)
      end
      # NOTE middleman deploy propogates this git user configuration to build/.git
      run %(git config user.name '#{ENV['GIT_NAME']}')
      run %(git config user.email '#{ENV['GIT_EMAIL']}')
      Rake::Task['build'].invoke
      FileUtils.cp_r 'config/meta/.', 'build'
      FileUtils.cp_r 'config/gh-pages/.', 'build'
      has_changes = true
      Dir.chdir 'build' do
        has_changes = false if %x(git status -s).empty?
      end
      next unless has_changes
      Rake::Task['deploy'].invoke
    ensure
      File.delete 'build/.git/credentials' if File.exist? 'build/.git/credentials'
    end
  end
end

def run command, opts = {}
  system command
  unless $?.exitstatus.zero? || opts[:ignore_failure]
    raise %(Previous command exited with unexpected status code #{$?.exitstatus})
  end
end
