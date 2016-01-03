require 'cinch'
require 'gingerice'
require 'walrus'

module Walrus
  class SpellcheckBot
    include Cinch::Plugin
    @prefix = ''

    listen_to :channel

    PONDERS = ['thinks about', 'considers', 'ponders', 'wonders about', 'meditates upon']

    def listen(m)
      unless m.user.nick == Walrus.name
        parser = Gingerice::Parser.new
        check  = parser.parse m.message.to_s
        unless check['corrections'].empty?
          ([ Proc.new { m.reply("I think you meant '#{check['result']}'...") },
             Proc.new { m.action_reply("snickers at #{m.user.nick}'s grammar.") },
             Proc.new do
               mistake = check['corrections'].sample
               m.action_reply("#{PONDERS.sample} the difference between '#{mistake['text']}' and '#{mistake['correct']}'")
             end,
          ].sample).call

          WhatWasThat.update("SpellcheckBot", m)
        end
      end
    end
  end
end
