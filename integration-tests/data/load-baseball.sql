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

LOAD DATA LOCAL INFILE '/data/Baseball.csv' 
        INTO TABLE integration_test.baseball
        FIELDS TERMINATED BY ','
        LINES TERMINATED BY'\n';

