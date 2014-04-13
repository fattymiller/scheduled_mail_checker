$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scheduled_mail_checker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scheduled_mail_checker"
  s.version     = ScheduledMailChecker::VERSION
  s.authors     = ["fattymiller"]
  s.email       = ["fatty@mobcash.com.au"]
  s.homepage    = "https://github.com/fattymiller/base_jump"
  s.summary     = "Checks POP mail on a schedule."
  s.description = "Checks POP mail on a schedule using BaseJump and the mailman gems."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.1"
  
  s.add_dependency "base_jump_commands_base"
  s.add_dependency "base_jump_plugins_base"
  s.add_dependency "base_jump_scheduler"
  
  s.add_dependency "mailman"
  s.add_dependency "paperclip"
  s.add_dependency "delayed_job"
  s.add_dependency "attr_encrypted"

  s.add_development_dependency "sqlite3"
end
