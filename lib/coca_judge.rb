require 'active_support'
require 'active_support/rails'

require 'coca_judge/version'

module CocaJudge
  extend ActiveSupport::Autoload

  autoload :Core
end