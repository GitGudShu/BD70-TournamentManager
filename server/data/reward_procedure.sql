-- DELIMITER //

-- CREATE PROCEDURE ComputeTournamentRankingsWithDynamicRewards(IN tournament_id INT)
-- BEGIN
--     -- Declare all variables at the start
--     DECLARE final_match_id INT;
--     DECLARE final_match_status INT;
--     DECLARE rank INT;
--     DECLARE done INT;
--     DECLARE player_id INT;
--     DECLARE wins INT;
--     DECLARE reward_name VARCHAR(255);
--     DECLARE reward_description VARCHAR(255);

--     -- Declare cursor for looping through players
--     DECLARE player_cursor CURSOR FOR 
--         SELECT player_id, wins
--         FROM PlayerStats
--         ORDER BY wins DESC;

--     -- Declare continue handler for cursor
--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

--     -- Check if tournament exists
--     IF NOT EXISTS (SELECT 1 FROM Tournament WHERE tournament_id = tournament_id) THEN
--         SIGNAL SQLSTATE '45000' 
--         SET MESSAGE_TEXT = 'Tournoi introuvable.';
--     END IF;

--     -- Create temporary table for player stats
--     CREATE TEMPORARY TABLE PlayerStats (
--         player_id INT,
--         name VARCHAR(255),
--         wins INT DEFAULT 0,
--         status VARCHAR(50) DEFAULT 'En duel'
--     );

--     -- Insert data into the temporary table
--     INSERT INTO PlayerStats (player_id, name)
--     SELECT 
--         p.player_id, 
--         CONCAT(u.user_name, ' ', u.user_lastname) AS name
--     FROM Player p
--     JOIN Users u ON u.user_id = p.user_id
--     WHERE p.player_id IN (
--         SELECT DISTINCT pm.player_id
--         FROM PlayerMatch pm
--         JOIN Matchmaking m ON pm.match_id = m.match_id
--         JOIN TournamentRound tr ON tr.tournamentRound_id = m.tournamentRound_id
--         WHERE tr.tournament_id = tournament_id
--     );

--     -- Update wins for each player
--     UPDATE PlayerStats ps
--     SET wins = (
--         SELECT COUNT(*)
--         FROM PlayerMatch pm
--         JOIN Matchmaking m ON pm.match_id = m.match_id
--         WHERE pm.player_id = ps.player_id
--           AND m.status = 2 
--           AND pm.score = (
--               SELECT MAX(pm2.score)
--               FROM PlayerMatch pm2
--               WHERE pm2.match_id = pm.match_id
--           )
--     );

--     -- Get the final match details
--     SELECT m.match_id, m.status
--     INTO final_match_id, final_match_status
--     FROM Matchmaking m
--     JOIN TournamentRound tr ON m.tournamentRound_id = tr.tournamentRound_id
--     WHERE tr.tournament_id = tournament_id
--     ORDER BY tr.round DESC, m.match_id DESC
--     LIMIT 1;

--     -- Update champion if final match is over
--     IF final_match_status = 2 THEN
--         UPDATE PlayerStats
--         SET status = 'Champion'
--         WHERE player_id = (
--             SELECT pm.player_id
--             FROM PlayerMatch pm
--             WHERE pm.match_id = final_match_id
--               AND pm.score = (
--                   SELECT MAX(pm2.score)
--                   FROM PlayerMatch pm2
--                   WHERE pm2.match_id = final_match_id
--               )
--             LIMIT 1
--         );
--     END IF;

--     -- Update players who lost
--     UPDATE PlayerStats
--     SET status = 'Perdu'
--     WHERE player_id NOT IN (
--         SELECT DISTINCT pm.player_id
--         FROM PlayerMatch pm
--         JOIN Matchmaking m ON pm.match_id = m.match_id
--         WHERE m.status = 0 
--     );

--     -- Open cursor for looping through players
--     OPEN player_cursor;

--     -- Loop through players to assign ranks and rewards
--     read_loop: LOOP
--         FETCH player_cursor INTO player_id, wins;
--         IF done THEN
--             LEAVE read_loop;
--         END IF;

--         SET rank = rank + 1;

--         -- Get reward based on rank
--         IF rank = 1 THEN
--             SELECT reward_name, reward_description
--             INTO reward_name, reward_description
--             FROM Reward
--             WHERE tournament_id = tournament_id AND reward_name LIKE '%Winner%' 
--             LIMIT 1;
--         ELSEIF rank = 2 THEN
--             SELECT reward_name, reward_description
--             INTO reward_name, reward_description
--             FROM Reward
--             WHERE tournament_id = tournament_id AND reward_name LIKE '%Runner-up%' 
--             LIMIT 1;
--         ELSEIF rank = 3 THEN
--             SELECT reward_name, reward_description
--             INTO reward_name, reward_description
--             FROM Reward
--             WHERE tournament_id = tournament_id AND reward_name LIKE '%Third%' 
--             LIMIT 1;
--         ELSE
--             SET reward_name = 'Participation';
--             SET reward_description = 'Merci pour votre participation';
--         END IF;

--         -- Update player status with reward
--         UPDATE PlayerStats
--         SET status = CONCAT(status, ' - ', reward_name, ': ', reward_description)
--         WHERE player_id = player_id;
--     END LOOP;

--     -- Close cursor
--     CLOSE player_cursor;

--     -- Final result with ranking
--     SELECT 
--         ps.player_id,
--         ps.name,
--         ps.wins,
--         ps.status,
--         RANK() OVER (ORDER BY ps.wins DESC) AS rank
--     FROM PlayerStats ps;

--     -- Drop the temporary table
--     DROP TEMPORARY TABLE PlayerStats;
-- END //

-- DELIMITER ;

-- CALL ComputeTournamentRankingsWithDynamicRewards(1);