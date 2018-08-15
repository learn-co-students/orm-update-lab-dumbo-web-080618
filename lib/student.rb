require_relative "../config/environment.rb"

class Student

attr_accessor :id, :name, :grade

  def initialize(name,grade,id=nil)
    @id = id
    @name = name
    @grade= grade
  end


  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
      DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

def self.new_from_db(row)
  Student.new(name = row[1], grade = row[2], id = row[0])
end

def self.find_by_name(name)
  sql = <<-SQL
           SELECT * FROM students WHERE name = ?
         SQL

         DB[:conn].execute(sql,name).map do |row|
           self.new_from_db(row)
         end.first
end



def update
  sql = <<-SQL
  UPDATE students SET name = ?, grade = ?
  SQL
  DB[:conn].execute(sql, self.name, self.grade)
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
end





end
