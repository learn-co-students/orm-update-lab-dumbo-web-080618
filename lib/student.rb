require_relative "../config/environment.rb"
require "pry"

class Student
  attr_accessor :id,:name,:grade
  def initialize(name,grade)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if !self.id
      sql = <<-SQL
        INSERT INTO students (name,grade)
        VALUES (?,?)
      SQL
      DB[:conn].execute(sql,self.name,self.grade)

      sql_id = <<-SQL
        SELECT id FROM students
        ORDER BY id
        DESC
        LIMIT 1
      SQL
      x = DB[:conn].execute(sql_id)[0][0]
      self.id = x
      #binding.pry
    else
      self.update
    end
  end

  def update
    sql = <<-SQL
    UPDATE students
    SET name = ?, grade = ?
    WHERE id = ?
    SQL
    DB[:conn].execute(sql,self.name,self.grade,self.id)
  end

  def self.create (name,grade)
    student1 = self.new(name,grade)
    student1.save

  end

  def self.new_from_db (arr)
    id = arr[0]
    name = arr[1]
    grade = arr[2]
    x=self.new(name,grade)
    x.id = id
    x
  end

  def self.find_by_name (name)
    sql1 =         <<-SQL
                  SELECT * FROM students
                  WHERE name = ?
                  SQL
    student_row = (DB[:conn].execute(sql1, name)).flatten!
    self.new_from_db (student_row)
  end
end
  # binding.pry
  # 0
