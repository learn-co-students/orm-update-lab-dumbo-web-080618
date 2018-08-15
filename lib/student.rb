require_relative "../config/environment.rb"
require 'pry'
class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id

  def initialize(name, grade, id: nil)
    @name = name
    @grade = grade
  end

  def self.create(name, grade)
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, name, grade)
  end

  def self.create_from_row(row)
    student = Student.new(row[1], row[2], id: row[0])
    student
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
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
    if self.id == nil
      sql_new = <<-SQL
        INSERT INTO students (name, grade) VALUES (?, ?)
      SQL
      DB[:conn].execute(sql_new, self.name, self.grade)[0]

      sql_retrieve = <<-SQL
        SELECT * FROM students ORDER BY id DESC LIMIT 1
      SQL

      info_row = DB[:conn].execute(sql_retrieve)[0]
      self.id = info_row[0]
    else
      self.update
    end
  end
    
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    info_row = DB[:conn].execute(sql, name)[0]
    student = Student.create_from_row(info_row)
    student.id = info_row[0]
    student
  end

  def update
    sql_update = <<-SQL 
      UPDATE students SET name = ?, grade = ? WHERE id = ? 
    SQL

    DB[:conn].execute(sql_update, self.name, self.grade, self.id)
  end

  def self.new_from_db(row)
    student = Student.new(row[1], row[2])
    student.id = row[0]
    # binding.pry
    student
  end

end
