CREATE TABLE IF NOT EXISTS integration_test.vocab (

        Id int,
        Year int,
        Sex text,
        Education int,
        Vocabulary int
);

LOAD DATA LOCAL INFILE '/data/IQ.csv'
        INTO TABLE integration_test.vocab
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY'\n';
