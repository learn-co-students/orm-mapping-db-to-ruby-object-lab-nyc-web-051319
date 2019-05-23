require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def initialize(id=nil, name=nil, grade=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.instance_from_row(row)
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    rows = DB[:conn].execute(sql)

    self.instance_from_rows(rows)
  end

  def self.instance_from_rows(rows)
    rows.map do |row|
      self.instance_from_row(row)
    end
  end

  def self.instance_from_row(row)
    Student.new(row[0], row[1], row[2])
  end

  def self.all_students_in_grade_9
    sql = "
    SELECT * FROM students WHERE grade=9
    "
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "
    SELECT * FROM students WHERE grade < 12
    "
    result = DB[:conn].execute(sql)
    self.instance_from_rows(result)
  end

  def self.first_X_students_in_grade_10(num)
    sql = "
    SELECT * FROM students WHERE grade=10
    "
    result = DB[:conn].execute(sql)
    result.take(num)
  end

  def self.first_student_in_grade_10
    sql = "
    SELECT * FROM students WHERE grade=10
    "
    result = DB[:conn].execute(sql).first
    self.instance_from_row(result)
  end

  def self.all_students_in_grade_X(grade)
    sql = "
    SELECT * FROM students WHERE grade=#{grade}
    "
    result = DB[:conn].execute(sql)
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "
    SELECT * FROM students WHERE name='#{name}'
    "
    result = DB[:conn].execute(sql).flatten
    student = Student.new_from_db(result)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
