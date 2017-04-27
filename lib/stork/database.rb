require 'sqlite3'

module Stork
  class Database
    def initialize(dbpath)
      unless Dir.exist?(dbpath)
        FileUtils.mkdir_p(dbpath)
      end

      @db = SQLite3::Database.open(File.join(dbpath, 'stork.db'))
    end

    def create_tables
      sql = <<-SQL
        CREATE TABLE IF NOT EXISTS hosts(
          name TEXT PRIMARY KEY,
          action TEXT
        )
      SQL
      execute sql
    end

    def execute(sql, *args)
      @db.execute(sql, args)
    end

    def find(sql, *args)
      h = Array.new

      stmt = @db.prepare(sql)
      stmt.execute(*args) do |rows|
        rows.each do |row|
          h << {
            :name => row[0],
            :action => row[1]
          }
        end
      end

      h
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
        { :name => host[0], :action => host[1] }
      else
        nil
      end
    end

    def hosts
      sql = 'SELECT * FROM hosts ORDER BY name ASC'
      find(sql)
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
          sql = "INSERT INTO hosts(name,action) VALUES(?, 'localboot')" 
          execute sql, h.name
        end
      end
    end

    def self.load(dbpath)
      @db = new(dbpath).tap do |d|
        d.create_tables
      end
    end
  end
end