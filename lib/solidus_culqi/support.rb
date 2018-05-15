# frozen_string_literal: true

module SolidusCulqi
  module Support
    def self.solidus_earlier(version)
      SolidusSupport.solidus_gem_version < Gem::Version.new(version)
    end
  end
end
