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
  SELECT p.namefirst, p.namelast, (sum(b.H)+sum(b.H2B)+sum(b.H3B)*2+sum(b.HR)*3+0.0)/(sum(b.AB)+0.0) as lslg
  FROM people p INNER JOIN batting b
  ON p.playerid = b.playerid
  GROUP BY p.playerid, p.namefirst, p.namelast
  HAVING lslg > (
    SELECT (sum(b.H)+sum(b.H2B)+sum(b.H3B)*2+sum(b.HR)*3+0.0)/(sum(b.AB)+0.0)
    FROM people p INNER JOIN batting b
    ON p.playerid = b.playerid and p.playerid = 'mayswi01'
  ) and sum(b.AB) > 50
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT yearid, min(salary), max(salary), avg(salary)
  FROM salaries s
  GROUP BY yearid
  ORDER BY yearid
;

-- Helper table for 4ii
DROP TABLE IF EXISTS binids;
CREATE TABLE binids(binid);
INSERT INTO binids VALUES (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

-- Question 4ii
CREATE VIEW srange2016(low, high)
AS
  SELECT min(salary), max(salary)
  FROM salaries s
  WHERE s.yearid = 2016
;
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT binid, (sr.high-sr.low)/10*b.binid + sr.low as lowval, (sr.high-sr.low)/10*(b.binid+1) + sr.low as highval, count(*)
  FROM binids b, salaries s, srange2016 sr
  ON s.yearid = 2016
  WHERE (b.binid < 9 and s.salary < highval 
    and s.salary >= lowval) or 
    (b.binid = 9 and s.salary <= highval
    and s.salary >= lowval)
  GROUP BY b.binid
; 

-- Question 4iii
CREATE VIEW sdat(yearid, minsal, maxsal, avgsal)
AS
  SELECT yearid, min(salary), max(salary), avg(salary)
  FROM salaries
  GROUP BY yearid
;
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT s1.yearid, s1.minsal - s2.minsal, s1.maxsal - s2.maxsal, s1.avgsal - s2.avgsal
  FROM sdat s1 INNER JOIN sdat s2
  ON s1.yearid = s2.yearid+1
  GROUP BY s1.yearid
;

-- Question 4iv
CREATE VIEW maxs(yearid, maxsal)
AS
  SELECT yearid, max(salary)
  FROM salaries
  GROUP BY yearid
;
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT p.playerid, namefirst, namelast, s.salary, s.yearid
  FROM people p INNER JOIN salaries s
  ON p.playerid = s.playerid INNER JOIN maxs ss 
  ON s.yearid = ss.yearid
  WHERE s.salary = ss.maxsal
  GROUP BY s.yearid
  HAVING (s.yearid = 2000 or s.yearid = 2001)
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT a.teamid, max(s.salary) - min(s.salary)
  FROM teams t INNER JOIN allstarfull a 
  ON t.teamid = a.teamid INNER JOIN salaries s
  ON s.playerid = a.playerid and s.yearid = a.yearid
  WHERE a.yearid = 2016
  GROUP BY a.teamid 
;

