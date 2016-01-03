require 'cinch'

module Walrus
  class WhatWasThat
    attr_accessor :bot, :who, :msg
    @@bot = nil
    @@who = nil
    @@msg = nil

    def self.update(bot, m)
      @@bot = bot
      @@who = m.user.nick
      @@msg = m.message
    end

    def self.bot
      @@bot
    end

    def self.who
      @@who
    end

    def self.msg
      @@msg
    end
  end

  class WhatWasThatBot
    include Cinch::Plugin
    @prefix = /^#{Walrus.name}: /i

    match /what was that\??/i, method: :match

    def match(m)
      if WhatWasThat.bot.nil? ||
        WhatWasThat.who.nil? ||
        WhatWasThat.msg.nil?
        m.reply("Who me?")
      else
        m.reply("That was #{WhatWasThat.bot}, " +
                "because #{WhatWasThat.who} " +
                "said '#{WhatWasThat.msg}'")
      end
    end
  end
end
