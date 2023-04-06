# frozen_string_literal: true

require_relative "lib/elden/version"

Gem::Specification.new do |spec|
  spec.name = "elden"
  spec.version = Elden::VERSION
  spec.authors = ["michael-a-grammar"]
  spec.email = ["5898731+michael-a-grammar@users.noreply.github.com"]

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://example.com"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["allowed_push_host"] = "https://example.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"] = "https://example.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) | f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "thor", "1.2.1"

  spec.add_development_dependency "pry",           "~> 0.14.2"
  spec.add_development_dependency "rubocop-rake",  "~> 0.6.0"
  spec.add_development_dependency "rbs",           "~> 3.0.4"
  spec.add_development_dependency "rubocop-rspec", "~> 2.19"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
