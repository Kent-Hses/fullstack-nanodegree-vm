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
                            loser int REFERENCES playerlist(p_id)
                          );

--View used to relate player with their score

CREATE VIEW winVIEW as SELECT playerlist.p_id,
                              playerlist.name,
                              count(matchhistory.winner) as wins
                            FROM playerlist 
                            LEFT JOIN matchhistory 
                              ON playerlist.p_id = matchhistory.winner 
                            GROUP BY playerlist.p_id,
                                     playerlist.name
                            ORDER BY wins;

CREATE VIEW lostVIEW as SELECT playerlist.p_id,
                               playerlist.name,
                               count(matchhistory.loser) as losts
                              FROM playerlist
                              LEFT JOIN matchhistory
                               ON playerlist.p_id = matchhistory.loser
                              GROUP BY playerlist.p_id,
                                       playerlist.name
                              ORDER BY losts;

--
CREATE VIEW standings as SELECT winVIEW.p_id,
                                winVIEW.name,
                                wins,
                                SUM(winVIEW.wins + lostVIEW.losts) as numOfmatch
                         FROM winVIEW
                         LEFT JOIN lostVIEW
                           on winVIEW.p_id = lostVIEW.p_id
                         GROUP BY winVIEW.p_id, winVIEW.name, winVIEW.wins
                         ORDER BY wins;

/*
--first attempt
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
