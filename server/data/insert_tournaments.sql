INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id) 
VALUES ('GP Abu Dhabi', 1, '2024-12-01', '2024-12-10', 4, 1, 1);

CALL GenerateTournamentRoundsForType1(1, 4);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (1, 1, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (2, 1, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (3, 2, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (4, 2, NULL, NULL);

INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id) 
VALUES ('Shu schema test', 1, '2024-12-01', '2024-12-10', 4, 2, 1);

CALL GenerateTournamentRoundsForType1(2, 4);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (1, 4, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (2, 4, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (3, 5, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (4, 5, NULL, NULL);

INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id) 
VALUES ('ChampionshipTest', 2, '2024-12-01', '2024-12-10', 12, 8, 2, 1);


CALL GenerateChampionshipTournamentRounds(3, 12);

-- INSERT LOTS OF TOURNAMENTS
DELIMITER //

CREATE PROCEDURE CreateSequentialTournaments(
    IN p_tournament_count INT
)
BEGIN
    -- Declare variables
    DECLARE tournament_index INT DEFAULT 1;
    DECLARE participant_count INT;
    DECLARE match_count INT;
    DECLARE round1_id INT;
    DECLARE inserted_tournament_id INT;
    DECLARE random_game_id INT;
    DECLARE random_month INT;
    DECLARE random_start_date DATE;
    DECLARE player_index INT;
    DECLARE match_index INT;
    DECLARE current_match_id INT;

    -- Create a temporary table to hold match IDs
    CREATE TEMPORARY TABLE TempMatches (
        temp_match_index INT AUTO_INCREMENT PRIMARY KEY,
        match_id INT
    );

    WHILE tournament_index <= p_tournament_count DO
        -- Random participant count (4, 8, or 16)
        SET participant_count = CASE FLOOR(1 + (RAND() * 3))
            WHEN 1 THEN 4
            WHEN 2 THEN 8
            WHEN 3 THEN 16
        END;

        -- Random game ID (from 1 to 10)
        SELECT game_id INTO random_game_id
        FROM Game
        WHERE game_id BETWEEN 1 AND 10
        ORDER BY RAND()
        LIMIT 1;

        -- Random start date within the next 12 months
        SET random_month = FLOOR(1 + (RAND() * 12));
        SET random_start_date = DATE_ADD(CURDATE(), INTERVAL random_month MONTH);

        -- Insert new tournament
        INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id)
        VALUES (
            CONCAT('Tournament ', tournament_index),
            1,
            random_start_date,
            DATE_ADD(random_start_date, INTERVAL 10 DAY),
            participant_count,
            random_game_id,
            1
        );

        SET inserted_tournament_id = LAST_INSERT_ID();

        -- Generate rounds and matches
        CALL GenerateTournamentRoundsForType1(inserted_tournament_id, participant_count);

        -- Get round 1 ID
        SELECT tournamentRound_id INTO round1_id
        FROM TournamentRound
        WHERE tournament_id = inserted_tournament_id AND round = 1
        LIMIT 1;

        -- Populate TempMatches with all match IDs for the first round
        INSERT INTO TempMatches (match_id)
        SELECT match_id
        FROM Matchmaking
        WHERE tournamentRound_id = round1_id
        ORDER BY match_id;

        -- Initialize player and match indices
        SET match_count = participant_count / 2;
        SET player_index = 1;
        SET match_index = 1;

        -- Assign players to matches in round 1
        WHILE match_index <= match_count DO
            -- Fetch the current match ID
            SELECT match_id INTO current_match_id
            FROM TempMatches
            WHERE temp_match_index = match_index;

            -- Add player 1 to the current match
            INSERT INTO PlayerMatch (player_id, match_id, score, status)
            VALUES (player_index, current_match_id, NULL, NULL);

            -- Add player 2 to the current match
            INSERT INTO PlayerMatch (player_id, match_id, score, status)
            VALUES (player_index + 1, current_match_id, NULL, NULL);

            -- Increment player and match indices
            SET player_index = player_index + 2;
            SET match_index = match_index + 1;
        END WHILE;

        -- Clean up temporary table for the next iteration
        TRUNCATE TABLE TempMatches;

        SET tournament_index = tournament_index + 1;
    END WHILE;

    -- Drop the temporary table after completion
    DROP TEMPORARY TABLE IF EXISTS TempMatches;
END //

DELIMITER ;


CALL CreateSequentialTournaments(5);
