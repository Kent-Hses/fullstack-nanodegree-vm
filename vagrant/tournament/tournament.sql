-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

--Table for players
CREATE TABLE playerlist ( p_id SERIAL primary key,
                          name varchar(255)
                        );

--Table that contains the data of the matches
CREATE TABLE matchHistory ( match_id SERIAL primary key,
                            winner int  REFERENCES playerlist(p_id),
                            loser int REFERENCES playerlist(p_id),
                            win int,
                            lose int
                          );

CREATE scoreSTANDING as SELECT playerlist.name,
                          count(matchhistory.winner) as wins
                   FROM playerlist 
                   LEFT JOIN matchhistory 
                       ON playerlist.p_id = matchhistory.winner 
                   GROUP BY playerlist.name
                   ORDER BY wins;

/*
CREATE VIEW numOfmatch as SELECT p_id,
                                 count(*) 
                          FROM matchhistory
                          GROUP BY p_id;

CREATE VIEW standings as SELECT pidtable.p_id,
                                playerlist.name,
                                pidtable.score,
                                pidtable.numMatch
                         FROM ( SELECT p_id,
                                       sum(win) as score,
                                       count(*) as numMatch
                                FROM matchHistory 
                                GROUP BY p_id
                              ) as pidtable,
                              playerlist
                         WHERE pidtable.p_id = playerlist.p_id;
   
*/
