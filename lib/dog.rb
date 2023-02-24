require 'sqlite3'


class Dog

    DB = SQLite3::Database.new("dogs.db")

    attr_accessor :name, :breed, :id

    def initialize(name:, :breed:, id: nil)
        @id = id
        @name = name
        @breed = breed

    end
# create table 
    def self.create_table
        sql = <<-SQL
            DROP TABLE IF EXISTS dogs;
        SQL
        DB[:conn].execute(sql)

        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dog (
            id INTEGER PRIMARY KEY, 
            name TEXT,
            album TEXT
        )
        SQL
        DB[:conn].execute(sql)
    end
#drop_table
    def self.drop_table
        sql <<-SQL
          DROP TABLE IF EXISTS dogs;
        SQL
        DB[:conn].execute(sql)
    end

#save
    def save
        sql = <<-SQL
          INSERT INTO dogs (name, breed)
          VALUES (?, ?)
        SQL
    
        DB[:conn].execute(sql, self.name, self.breed)

        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

        self
    
    end

 #create
    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end

 #new_from_db
    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], album: row[2])
    end

 #all
    def self.all
        sql = <<-SQL
         SELECT *
         FROM dogs
        SQL

        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end
    end

 #find
    def self.find_by_name(name)
        sql = <<-SQL
            SELECT * 
            FROM dogs
            WHERE name = ?
            LIMIT 1
        SQL

        DB[:conn].execute(sql, self.name).map do |row|
            self
            .new_from_db(row)
        end.first
    end

end
