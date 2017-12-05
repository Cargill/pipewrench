CREATE TABLE IF NOT EXISTS integration_test.baseball (
        Id int,
        PlayerId text,
        Year int,
        Stint int,
        Team text,
        LG int,
        G int,
        AB int,
        R int,
        H int,
        X2b int,
        X3b int,
        HR int,
        RBI int,
        SB int,
        CS int,
        BB int,
        SO int,
        IBB int,
        HBP int,
        SH int,
        SF int,
        GIDP int
);

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

CREATE TABLE IF NOT EXISTS integration_test.vocab (

        Id int,
        Year int,
        Sex text,
        Education int,
        Vocabulary int
);

LOAD DATA LOCAL INFILE '/data/Titanic.csv'
        INTO TABLE integration_test.titanic
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY'\n';

LOAD DATA LOCAL INFILE '/data/IQ.csv'
	INTO TABLE integration_test.vocab
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY'\n';LOAD DATA LOCAL INFILE '/data/Vocab.csv';

LOAD DATA LOCAL INFILE '/mount/data/Baseball.csv' 
        INTO TABLE integration_test.baseball
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY'\n';

