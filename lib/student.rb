require_relative "../config/environment.rb"
require 'pry'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade
  def initialize (id=nil, name, grade)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    sql = <<-SQL
      SELECT * FROM students ORDER BY id DESC LIMIT 1
    SQL
    new_hash = DB[:conn].execute(sql)
    self.id = new_hash[0][0]
    self.update
    self
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);
    SQL

    DB[:conn].execute(sql)

  end

  def self.create(name, grade)
    #binding.pry
    new_hash = Student.new(name, grade)
    new_hash.save
    new_hash

  end

  def self.new_from_db(row)
    self.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    temp = DB[:conn].execute(sql, name)
    self.new_from_db(temp.flatten)
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ?
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

end
