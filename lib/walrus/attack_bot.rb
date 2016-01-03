require 'cinch'
require 'fast_stemmer'
require 'set'
require 'walrus'

module Walrus
  class AttackBot
    include Cinch::Plugin
    @prefix = ''

    TRIGGERS = Set.new [ 'assault', 'attack', 'bash', 'beat', 'belt', 'clobber', 'cut', 'hit', 'hurt', 'tickle', 'torture', 'kick', 'knock', 'punch', 'shoot', 'slap', 'smack', 'strike', 'whack', 'throttle' ]

    BODY_PART = ['head', 'arm', 'shoulder', 'butt', 'spleen', 'solar plexus', 'eye', 'leg', 'arse', 'buttox', 'ribs', 'rib-cage' ]
    ITS = ['his', 'her', 'its']

    listen_to :action

    def listen(m)
      if match = m.message.match(/\b(\w+)\b\s+\b#{Walrus.name}\b/i)
        action = match[1]
        stemmed = Stemmer::stem_word action
        if TRIGGERS.member? stemmed
          ([ Proc.new { m.reply('Ow! Why would you do that?') },
             Proc.new { m.action_reply('cries') },
             Proc.new { m.action_reply("#{stemmed}s #{m.user.nick} back") },
             Proc.new { m.action_reply("glares at #{m.user.nick}") },
             Proc.new { m.reply("Help #{m.user.nick} is #{stemmed}ing me!") },
             Proc.new { m.action_reply("cries and rubs #{ITS.sample} #{BODY_PART.sample}") },
             Proc.new { m.action_reply("looks at the blood coming from #{ITS.sample} #{BODY_PART.sample}") },
             Proc.new { m.reply("Missed me :-P") },
          ].sample).call

          Walrus.angrier
          WhatWasThat.update('AttackBot', m)
        end
      end
    end
  end
end
