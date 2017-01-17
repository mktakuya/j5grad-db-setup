CREATE TABLE names(
    name_code        serial  PRIMARY KEY,
    first_name  text    NOT NULL,
    last_name   text    NOT NULL,
    first_kana  text    NOT NULL,
    last_kana   text    NOT NULL
);

CREATE TABLE departments(
    department_code        serial  PRIMARY KEY,
    department_name        text    UNIQUE  NOT NULL
);

CREATE TABLE positions (
    position_code        serial  PRIMARY KEY,
    position_name        text    UNIQUE  NOT NULL
);

CREATE TABLE skills (
    skill_code        serial  PRIMARY KEY,
    skill_name        text    UNIQUE  NOT NULL
);

CREATE TABLE employees (
    employee_code        serial  PRIMARY KEY,
    name_code   integer REFERENCES names(name_code),
    gender      integer NOT NULL,
    age         integer NOT NULL,
    salary      integer NOT NULL,
    department_code integer REFERENCES departments(department_code),
    position_code integer REFERENCES positions(position_code),
    skill_code integer REFERENCES skills(skill_code)
);

GRANT ALL ON names, departments, positions, skills, employees TO PUBLIC;
