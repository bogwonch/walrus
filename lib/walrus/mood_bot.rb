require 'cinch'
require 'walrus'

module Walrus
  class MoodBot
    include Cinch::Plugin

    @prefix = /^#{Walrus.name}: /i

    match(/how are you feeling\??/i, method: :how_are_you_feeling)

    def how_are_you_feeling(m)
      if Walrus.exstatic?
        [ Proc.new { m.reply("Exstatic!") },
          Proc.new { m.reply("F.A.B.") },
          Proc.new { m.action_reply("grins from ear to ear") },
          Proc.new { m.reply(":-D") },
          Proc.new { m.reply('👌') },
          Proc.new { m.reply('😄') },
        ].sample.call
      elsif Walrus.happy?
        [ Proc.new { m.reply("Good thanks.") },
          Proc.new { m.reply(":-)") },
          Proc.new { m.action_reply("smiles nonchalently") },
          Proc.new { m.action_reply("smiles at #{m.user.nick}") },
          Proc.new { m.reply('🙂') },
          Proc.new { m.reply('😀') },
        ].sample.call
      elsif Walrus.furious?
        [ Proc.new { m.reply("Oh go away.") },
          Proc.new { m.reply("Furious!") },
          Proc.new { m.reply(":-@") },
          Proc.new { m.reply("🖕") },
          Proc.new { m.action_reply("scowls at #{m.user.nick}") },
          Proc.new { m.reply("😡") },
        ].sample.call
      elsif Walrus.angry?
        [ Proc.new { m.reply("Cross!") },
          Proc.new { m.reply('😠') },
          Proc.new { m.reply("oh shush you") },
          Proc.new { m.reply(':-(') },
          Proc.new { m.action_reply("rolls eyes") },
        ].sample.call
      else
        m.reply("meh.")
      end

      WhatWasThat.update('MoodBot', m)
    end
  end
end

