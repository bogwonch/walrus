require "walrus/version"
require 'walrus/whatwasthat_bot'

module Walrus
  class Walrus
    @@name = 'Walrus'
    @@mood = 0

    def self.name=(new_name)
      @@name = new_name
    end

    def self.name
      @@name
    end

    def self.mood=(new_mood)
      @@mood = new_mood
    end

    def self.happy?()     @@mood >= 2  end
    def self.angry?()     @@mood <=-2  end
    def self.exstatic?()  @@mood >= 8  end
    def self.furious?()   @@mood <=-8  end

    def self.happier(by: 1)
      @@mood += by
      @@mood = 10 if @@mood > 10
    end

    def self.angrier(by: 1)
      @@mood -= by
      @@mood = -10 if @@mood < -10
    end
  end
end

