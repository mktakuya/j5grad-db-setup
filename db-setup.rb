require 'sequel'
require 'csv'
require 'yaml'
require './dic'

class DBSetup
  attr_accessor :db
  TABLE_NAMES = %w(departments positions skills employees)

  def initialize
    connect_opt = YAML.load_file('./config.yml')
    @db = Sequel.postgres('h28_j5_grad', connect_opt)
  end

  def run
    employees = parse_csv
    reset_db
    setup_db(employees)
  end

  def setup_db(employees)
    TABLE_NAMES.each do |table_name|
      self.send("setup_#{table_name}", employees)
    end
  end

  def reset_db
    @db.run 'DROP SCHEMA public CASCADE;'
    @db.run 'CREATE SCHEMA public;'
    system('psql -f ./create_tables.sql -d h28_j5_grad')
  end

  private

  def parse_csv(path = './data/employees.csv')
    employees = []

    CSV.foreach(path) do |line|
      if (line[0] && line[0] != '姓')
        data = [DICTIONARY, line].transpose
        employees << Hash[*data.flatten]
      end
    end
    employees
  end

  def setup_departments(employees)
    depts = []
    employees.each { |emp| depts.push(emp['department']) }
    depts.uniq!

    @db.transaction do
      depts.each do |dept|
        @db[:departments].insert(name: dept)
      end
    end
  end

  def setup_positions(employees)
    positions = []
    employees.each { |emp| positions.push(emp['position']) }
    positions.uniq!

    @db.transaction do
      positions.each do |position|
        @db[:positions].insert(name: position)
      end
    end
  end

  def setup_skills(employees)
    skills = []
    employees.each { |emp| skills.push(emp['skill']) }
    skills.uniq!

    @db.transaction do
      skills.each do |skill|
        @db[:skills].insert(name: skill) unless skill.nil?
      end
    end
  end

  def setup_employees(employees)
    @db.transaction do
      employees.each do |emp|
        dept_code = @db[:departments].where(
          name: emp['department']
        ).all[0][:code]

        position_code = @db[:positions].where(
          name: emp['position']
        ).all[0][:code]

        unless emp['skill'].nil?
          skill_code = @db[:skills].where(
            name: emp['skill']
          ).all[0][:code]
        end

        @db[:employees].insert(
          first_name: emp['first_name'],
          last_name: emp['last_name'],
          first_kana: emp['first_kana'],
          last_kana: emp['last_kana'],
          gender: emp['gender'] == '男性' ? 1 : 0,
          age: emp['age'],
          salary: emp['salary'],
          department_code: dept_code,
          position_code: position_code,
          skill_code: skill_code
        )
      end
    end
  end
end

if $0 == __FILE__
  db_setup = DBSetup.new
  db_setup.run
end