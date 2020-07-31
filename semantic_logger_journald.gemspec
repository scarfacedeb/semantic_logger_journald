require_relative 'lib/semantic_logger_journald/version'

Gem::Specification.new do |spec|
  spec.name          = "semantic_logger_journald"
  spec.version       = SemanticLoggerJournald::VERSION
  spec.authors       = ["Andrew Volozhanin"]
  spec.email         = ["scarfacedeb@gmail.com"]

  spec.summary       = %q{Plugin for semantic_logger gem providing systemd-journal appender}
  spec.description   = %q{Plugin for semantic_logger that adds appender to send logs into journald. It depends on journald-native gem that provides the C-bindings}
  spec.homepage      = "https://rubygems.org/gems/semantic_logger_journald"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/scarfacedeb/semantic_logger_journald/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "semantic_logger", "~> 4.7"
  spec.add_dependency "journald-logger", "~> 3.0"
end
