require 'sqlite3'

module Stork
  class Database
    def initialize(dbfile)
      @db = SQLite3::Database.open(dbfile)
    end

    def create_tables
      execute <<-SQL
        CREATE TABLE IF NOT EXISTS hosts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          action TEXT
        )
      SQL
    end

    def execute(sql, *args)
      @db.execute(sql, args)
    end

    def find_one(sql, *args)
      stmt = @db.prepare(sql)
      result = stmt.execute(*args)

      if result
        result.first
      else
        nil
      end
    end

    def host(name)
      sql = 'SELECT * FROM hosts WHERE name=?'
      host = find_one(sql, name)

      if host
        { :name => host[1], :action => host[2] }
      else
        nil
      end
    end

    def boot_install(name)
      sql = "UPDATE hosts SET action='install' WHERE name=?"
      execute sql, name 
    end

    def boot_local(name)
      sql = "UPDATE hosts SET action='localboot' WHERE name=?"
      execute sql, name
    end

    def sync_hosts(hosts)
      hosts.each do |h|
        result = host(h.name)
        unless result
          execute <<-SQL
            INSERT INTO hosts(
              name, action
            ) 
            VALUES(
              '#{h.name}',
              'localboot'
            )
          SQL
        end
      end
    end

    def self.create(dbfile, hosts)
      @db = new(dbfile).tap do |d|
        d.create_tables
        d.sync_hosts(hosts)
      end
    end
  end
end