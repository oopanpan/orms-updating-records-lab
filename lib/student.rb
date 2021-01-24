require_relative "../config/environment.rb"

class Student

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students
    (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def self.create(name, grade)
    student = self.new(nil, name, grade)
    student.save
  end

  def self.new_from_db(row)
    self.new(row[0],row[1],row[2])
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?;
    SQL
    self.new_from_db(DB[:conn].execute(sql,name).first)
  end
  
  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    if self.id == nil
      sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?);
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT id FROM students")[0][0]
    else
      self.update
    end
  end
  
  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? 
    WHERE id = ?;
    SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id) 
  end


end
