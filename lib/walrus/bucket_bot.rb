require 'cinch'
require 'sqlite3'
require 'walrus'

module Walrus
  class BucketBot
    include Cinch::Plugin
    @prefix = ''

    def init_db
      @db = SQLite3::Database.new 'bucket.db'
      @db.results_as_hash = true

      @db.transaction do |db|
        db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS
          bucket_history
            ( idx  INTEGER PRIMARY KEY ASC
            , what TEXT
            , who  TEXT
            , stamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        SQL
      end
    end

    def add(what, who)
      @db.transaction do |db|
        db.execute("
        INSERT INTO bucket_history(what, who)
          VALUES(?, ?)
                   ", what, who)
      end
    end

    def get()
      @db.get_first_row <<-SQL
      SELECT what, who, stamp
      FROM bucket_history
      ORDER BY idx DESC
      SQL
    end

    def initialize(*args)
      super
      @db = nil
      init_db
    end

    listen_to :channel, method: :listen_messages
    listen_to :action,  method: :listen_action

    def listen_messages(m)
      if m.message.match(/^#{Walrus.name} what'?s in your bucket/i)
        item = get
        if item.nil? || item['what'] == ''
          m.reply "it's empty!"
        else
          m.reply "it's #{item['who']}'s #{item['what']}"
        end

        WhatWasThat.update('BucketBot-query', m)
      end
    end

    def listen_action(m)
      if match = m.message.match(/gives #{Walrus.name} an? \b(\S+)\b/i)
        item = match[1]
        previous = get
        add(item, m.user.nick)
        if previous.nil? || previous['what'] == ''
          m.reply("Yay! A lovely #{item}")
        else
          m.action_reply("throws away #{previous['who']}'s #{previous['what']} and replaces it with a #{item}")
        end

        Walrus.happier
        WhatWasThat.update('BucketBot-update', m)
      end
    end
  end
end
