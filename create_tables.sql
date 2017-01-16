CREATE TABLE departments(
    code        serial  PRIMARY KEY,
    name        text    UNIQUE  NOT NULL
);

CREATE TABLE positions (
    code        serial  PRIMARY KEY,
    name        text    UNIQUE  NOT NULL
);

CREATE TABLE skills (
    code        serial  PRIMARY KEY,
    name        text    UNIQUE  NOT NULL
);

CREATE TABLE employees (
    code        serial  PRIMARY KEY,
    first_name  text    NOT NULL,
    last_name   text    NOT NULL,
    first_kana  text    NOT NULL,
    last_kana   text    NOT NULL,
    gender      integer NOT NULL,
    age         integer NOT NULL,
    salary      integer NOT NULL,
    department_code integer REFERENCES departments(code),
    position_code integer REFERENCES positions(code),
    skill_code integer REFERENCES skills(code)
);

GRANT ALL ON departments, positions, skills, employees TO PUBLIC;
