
CREATE TABLE IF NOT EXISTS integration_test.titanic (

        Id int,
        LastName text,
        FirstName text,
        PClass text,
        Age int,
        Sex text,
        Survived int,
        SexCode int
);

LOAD DATA LOCAL INFILE '/data/Titanic.csv'
        INTO TABLE integration_test.titanic
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY'\n';

