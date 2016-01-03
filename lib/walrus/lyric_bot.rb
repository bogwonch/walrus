require 'cinch'
require 'walrus'
require 'fuzzy_tools'

module Walrus
  class LyricBot
    include Cinch::Plugin
    @prefix = ''

    listen_to :channel

    def initialize(*args)
      super
      @LYRICS = Dir.glob('lyrics/*.txt').map { |f| File.open(f).read }
    end

    def listen(m)
      matches = @LYRICS
        .fuzzy_find_all_with_scores(m.message)
        .select { |x| x[1] > 0.1 }
        .first

      unless matches.nil?
        lyric = matches
          .first
          .split("\n")
          .sample

        m.reply("🎵 #{lyric} 🎵")
        WhatWasThat.update("Taylor Swift", m)
      end
    end
  end
end

