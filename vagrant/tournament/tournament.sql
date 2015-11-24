-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

--Table that contains the data of the matches
CREATE TABLE matchHistory ( match_id SERIAL primary key,
                            p_id references playerlist(p_id),
                            o_id references playerlist(p_id),
                            win int,
                            lose int
                          )

CREATE TABLE playerlist ( p_id SERIAL primary key,
                          name varchar(255)
                        )

CREATE VIEW standings SELECT pidtable.p_id,
                             playerlist.name,
                             pidtable.score,
                             pidtable.numMatch
                      FROM ( SELECT p_id,
                                    count(win) as score,
                                    count(*) as numMatch
                             FROM matchHistory 
                             GROUP BY p_id
                           ) as pidtable,
                           playerlist
                      WHERE pidtable.p_id = playerlist.p_id
       

