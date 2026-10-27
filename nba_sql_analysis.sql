-- Query 1: Preview player data.
SELECT *
FROM nba_players
LIMIT 10;

-- Query 2: Top 10 players by total assists.
SELECT p.player_name, p.team, s.assists
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
ORDER BY s.assists DESC
LIMIT 10;

-- Query 3: Top players by assists per minute.
SELECT p.player_name, p.team, s.assists, s.minutes_played, s.assists * 1.0 / s.minutes_played AS assists_per_minute
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
WHERE s.minutes_played > 0
ORDER BY assists_per_minute DESC
LIMIT 10;

-- Query 4: Average assists by team.
SELECT p.team, AVG(s.assists) AS average_assists
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
GROUP BY p.team
ORDER BY average_assists DESC;

-- Query 5: Team assists per minute.
SELECT p.team, SUM(s.assists) AS total_assists, SUM(s.minutes_played) AS total_minutes, SUM(s.assists) * 1.0 / SUM(s.minutes_played) AS team_assists_per_minute
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
GROUP BY p.team
ORDER BY team_assists_per_minute DESC;

-- Query 6: Top assist rates among players with 1,000+ minutes.
SELECT p.player_name, s.assists, s.minutes_played, s.assists * 1.0 / s.minutes_played AS assists_per_minute
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
WHERE s.minutes_played >= 1000
ORDER BY assists_per_minute DESC
LIMIT 10;

-- Query 7: Player share of team assists using a subquery.
SELECT p.player_name, p.team, s.assists,
       (
           SELECT SUM(s2.assists)
           FROM nba_players AS p2
           INNER JOIN player_stats AS s2
           ON p2.player_id = s2.player_id
           WHERE p2.team = p.team
       ) AS team_total_assists,
       s.assists * 100.0 / (
           SELECT SUM(s2.assists)
           FROM nba_players AS p2
           INNER JOIN player_stats AS s2
           ON p2.player_id = s2.player_id
           WHERE p2.team = p.team
       ) AS team_assist_percentage
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
ORDER BY team_assist_percentage DESC
LIMIT 10;

-- Query 8: Average assists by player position.
SELECT p.position,
       COUNT(*) AS player_count,
       ROUND(AVG(s.assists), 2) AS average_assists
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
GROUP BY p.position
ORDER BY average_assists DESC;

-- Query 9: Top rebounders by rebounds per minute.
SELECT p.player_name,
       p.team,
       s.offensive_rebounds + s.defensive_rebounds AS rebounds,
       s.minutes_played,
       (s.offensive_rebounds + s.defensive_rebounds) * 1.0 / s.minutes_played AS rebounds_per_minute
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
WHERE s.minutes_played >= 1000
ORDER BY rebounds_per_minute DESC
LIMIT 10;

-- Query 10: Team assists and win percentage.
SELECT p.team,
       ROUND(AVG(s.assists), 2) AS average_assists,
       MAX(s.wins) AS wins,
       MAX(s.losses) AS losses,
       ROUND(MAX(s.wins) * 100.0 /
             (MAX(s.wins) + MAX(s.losses)), 2) AS win_percentage
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
GROUP BY p.team
ORDER BY win_percentage DESC;

-- Query 11: Player share of team assists using a window function.
SELECT p.player_name,
       p.team,
       s.assists,
       ROUND(
           s.assists * 100.0 /
           SUM(s.assists) OVER (PARTITION BY p.team),
           2
       ) AS team_assist_share
FROM nba_players AS p
INNER JOIN player_stats AS s
ON p.player_id = s.player_id
ORDER BY team_assist_share DESC
LIMIT 10;

-- Query 12: Leading assist player for each team.
WITH ranked_players AS (
    SELECT p.player_name,
           p.team,
           s.assists,
           ROW_NUMBER() OVER (
               PARTITION BY p.team
               ORDER BY s.assists DESC
           ) AS team_rank
    FROM nba_players AS p
    INNER JOIN player_stats AS s
    ON p.player_id = s.player_id
)
SELECT player_name,
       team,
       assists
FROM ranked_players
WHERE team_rank = 1
ORDER BY assists DESC;