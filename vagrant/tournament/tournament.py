#!/usr/bin/env python
# 
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    db = connect()
    c = db.cursor()
    c.execute("DROP TABLE matchHistory CASCADE")
    db.close()

def deletePlayers():
    """Remove all the player records from the database."""
    db = connect()
    c = db.cursor()
    c.execute("DROP TABLE playerlist CASCADE")
    db.close()

def countPlayers():
    """Returns the number of players currently registered."""
    db = connect()
    c = db.cursor()
    c.execute("SELECT count(*) as numOfPlayers FROM playerlist") 
    
    result = c.fetchone()
    # fetchall() retreives the data.
    resultint = int(result[0])
    print c
    return resultint
    db.close()
  
def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    db = connect()
    c = db.cursor()
    c.execute("INSERT INTO playerlist (name) VALUES (%s)", (str(name),))
    db.commit()
    db.close()

def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    db = connect()
    c = db.cursor()
    c.execute("SELECT * FROM standings ORDER BY score DESC")
    result = c.fetchall()
    for row in result:
       for tuple in row:
          print tuple
       print "-----" 

    db.close()

def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    
    db = connect()
    c = db.connect()
    # inserts in to the matchHistory
    #First Inserts to indicate a win by placing a 1 
    c.execute("INSERT into matchHistory (winner, loser, win, lost) VALUES (%s)", (winner, loser, 1, 0)) 
    #Second Inserts to indicate a lost
    c.execute("INSERT into matchHistory (winner, loser, win, lost) VALUES (%s)", (loser, winner, 0, 1))
    c.commit()
    db.close()

def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
        
    db = connect()
    c = db.cursor()
    c.execute("SELECT  * FROM standings ORDER BY score DESC")
    MATCHES = []
    result = c.fetchall()
    for index in (len(result)/2):
       MATCHES.append = (result[index][0], result[index][1], result[index+1][0], result[index+1][1])
    
    return MATCHES
    db.close()
