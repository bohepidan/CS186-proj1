-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(era)
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM  people p
  WHERE p.weight > 300
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people p
  WHERE p.namefirst LIKE '% %'
  ORDER BY namefirst, namelast
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(*)
  FROM people p 
  GROUP BY birthyear
  ORDER BY birthyear
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height), COUNT(*)
  FROM people p 
  GROUP BY birthyear
  HAVING AVG(height) > 70
  ORDER BY birthyear
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT namefirst, namelast, p.playerid, yearid
  FROM people p INNER JOIN hallOfFame h
  ON p.playerid = h.playerid and inducted = 'Y'
  ORDER BY yearid DESC, p.playerid
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT namefirst, namelast, p.playerid, s.schoolid, yearid
  FROM people p, halloffame h, collegeplaying c, schools s
  WHERE p.playerid = h.playerid and p.playerid = c.playerid 
    and s.schoolid = c.schoolid and s.schoolState = 'CA' and h.inducted = 'Y'
  ORDER BY h.yearid DESC, s.schoolid, p.playerid
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT p.playerid, namefirst, namelast, s.schoolid
  FROM (people p INNER JOIN halloffame h 
  ON p.playerid = h.playerid and h.inducted = 'Y' )
  LEFT OUTER JOIN (
    collegeplaying c INNER JOIN schools s 
    ON c.schoolid = s.schoolid
  )ON p.playerid = c.playerid
  ORDER BY p.playerid DESC, s.schoolid 
;

-- Question 3i
CREATE VIEW slg(playerid, yearid, AB, slgval)
AS 
  SELECT playerid, yearid, AB, (H + H2B + 2*H3B + 3*HR + 0.0)/(AB + 0.0)
  FROM batting
;

CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, s.yearid, s.slgval
  FROM people p INNER JOIN slg s
  ON p.playerid = s.playerid
  WHERE s.AB > 50
  ORDER BY s.slgval DESC, s.yearid, p.playerid
  LIMIT 10
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, (sum(b.H)+sum(b.H2B)+sum(b.H3B)*2+sum(b.HR)*3+0.0)/sum(b.AB) as lslg
  FROM people p INNER JOIN batting b
  ON p.playerid = b.playerid 
  GROUP BY p.playerid
  HAVING sum(b.AB) > 50
  ORDER BY lslg DESC, p.playerid
  LIMIT 10
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
  SELECT p.namefirst, p.namelast, (sum(b.H)+sum(b.H2B)+sum(b.H3B)*2+sum(b.HR)*3+0.0)/(sum(b.AB)+0.0) 
  FROM people p INNER JOIN batting b
  ON p.playerid = b.playerid
  GROUP BY p.playerid, p.namefirst, p.namelast
  HAVING  > (
    SELECT (sum(b.H)+sum(b.H2B)+sum(b.H3B)*2+sum(b.HR)*3+0.0)/(sum(b.AB)+0.0)
    FROM people p INNER JOIN batting b
    ON p.playerid = b.playerid and p.playerid = 'mayswi01'
  )
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;


-- Helper table for 4ii
DROP TABLE IF EXISTS binids;
CREATE TABLE binids(binid);
INSERT INTO binids VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT 1, 1, 1, 1 -- replace this line
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT 1, 1, 1, 1, 1 -- replace this line
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT 1, 1 -- replace this line
;

