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

INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id) 
VALUES ('ChampionshipTest', 2, '2024-12-01', '2024-12-10', 12, 2, 1);

CALL GenerateTournamentRoundsForType2(3, 4);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (1, 7, 3, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (2, 7, 2, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (3, 8, 4, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (4, 8, 1, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (1, 9, 2, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (3, 9, 3, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (2, 10, 1, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (4, 10, 5, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (1, 11, 3, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (4, 11, 2, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (2, 12, 4, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (3, 12, 1, NULL);


INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id) 
VALUES ('ChampionshipTestWithPlayoff', 3, '2024-12-01', '2024-12-10', 4, 2, 2, 1);

CALL GenerateTournamentRoundsForType2(4, 4);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (5, 13, 2, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (6, 13, 3, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (7, 14, 4, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (8, 14, 1, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (5, 15, 3, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (7, 15, 2, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (6, 16, 5, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (8, 16, 1, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (5, 17, 4, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (8, 17, 3, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (6, 18, 2, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (7, 18, 4, NULL);

-- Playoff Match, new tree
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (5, 19, NULL, NULL);
INSERT INTO TeamMatch (team_id, match_id, score, status) VALUES (7, 19, NULL, NULL);


-- INSERT LOTS OF TOURNAMENTS
DELIMITER //

CREATE PROCEDURE CreateSequentialTournamentsType1WithPlayersNoScoreForRound1(
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

    DROP TEMPORARY TABLE IF EXISTS TempMatches;

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


DELIMITER //

CREATE PROCEDURE CreateSequentialTournamentsType1WithPlayersWithScoresForRound1(
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

    DECLARE score1 INT;
    DECLARE score2 INT;

    DROP TEMPORARY TABLE IF EXISTS TempMatches;

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

            -- Generate random scores for player 1 and player 2
            SET score1 = FLOOR(RAND() * 11); -- Score between 0 and 10
            SET score2 = FLOOR(RAND() * 11); -- Score between 0 and 10

            -- Ensure the scores are different
            WHILE score1 = score2 DO
                SET score2 = FLOOR(RAND() * 11);
            END WHILE;

            -- Add player 1 to the current match
            INSERT INTO PlayerMatch (player_id, match_id, score, status)
            VALUES (player_index, current_match_id, score1, NULL);

            -- Add player 2 to the current match
            INSERT INTO PlayerMatch (player_id, match_id, score, status)
            VALUES (player_index + 1, current_match_id, score2, NULL);

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

DELIMITER //

CREATE PROCEDURE CreateSequentialTournamentsType1WithTeams(
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
    DECLARE team_index INT;
    DECLARE match_index INT;
    DECLARE current_match_id INT;

    DROP TEMPORARY TABLE IF EXISTS TempMatches;

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
        SET team_index = 1;
        SET match_index = 1;

        -- Assign players to matches in round 1
        WHILE match_index <= match_count DO
            -- Fetch the current match ID
            SELECT match_id INTO current_match_id
            FROM TempMatches
            WHERE temp_match_index = match_index;

            -- Add player 1 to the current match
            INSERT INTO TeamMatch (team_id, match_id, score, status)
            VALUES (team_index, current_match_id, NULL, NULL);

            -- Add player 2 to the current match
            INSERT INTO TeamMatch (team_id, match_id, score, status)
            VALUES (team_index + 1, current_match_id, NULL, NULL);

            -- Increment player and match indices
            SET team_index = team_index + 2;
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

DELIMITER //

CREATE PROCEDURE CreateSequentialTournamentsType2(
    IN p_tournament_count INT
)
BEGIN
    -- Déclaration des variables
    DECLARE tournament_index INT DEFAULT 1;
    DECLARE participant_count INT;
    DECLARE playoff_teams INT;
    DECLARE random_game_id INT;
    DECLARE random_month INT;
    DECLARE random_start_date DATE;
    DECLARE inserted_tournament_id INT;

    WHILE tournament_index <= p_tournament_count DO
        -- Générer un nombre aléatoire de participants (0 à 20)
        SET participant_count = FLOOR(RAND() * 21);

        -- Générer un ID de jeu aléatoire (de 1 à 10)
        SELECT game_id INTO random_game_id
        FROM Game
        WHERE game_id BETWEEN 1 AND 10
        ORDER BY RAND()
        LIMIT 1;

        -- Générer une date de début aléatoire dans les 12 prochains mois
        SET random_month = FLOOR(1 + (RAND() * 12));
        SET random_start_date = DATE_ADD(CURDATE(), INTERVAL random_month MONTH);

        -- Insérer un nouveau tournoi
        INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id)
        VALUES (
            CONCAT('Tournament ', tournament_index),
            2, 
            random_start_date,
            DATE_ADD(random_start_date, INTERVAL 10 DAY),
            participant_count,
            random_game_id,
            1 
        );

        -- Récupérer l'ID du tournoi inséré
        SET inserted_tournament_id = LAST_INSERT_ID();

        -- Appeler la procédure pour générer les rounds pour le tournoi de type 2
        CALL GenerateTournamentRoundsForType2(inserted_tournament_id, participant_count);

        -- Passer au tournoi suivant
        SET tournament_index = tournament_index + 1;
    END WHILE;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE CreateSequentialTournamentsType3(
    IN p_tournament_count INT
)
BEGIN
    -- Déclaration des variables
    DECLARE tournament_index INT DEFAULT 1;
    DECLARE participant_count INT;
    DECLARE playoff_teams INT;
    DECLARE random_game_id INT;
    DECLARE random_month INT;
    DECLARE random_start_date DATE;
    DECLARE inserted_tournament_id INT;

    WHILE tournament_index <= p_tournament_count DO
        -- Générer un nombre aléatoire de participants (0 à 20)
        SET participant_count = FLOOR(RAND() * 21);

        -- Générer un nombre aléatoire de joueurs pour les playoffs (NULL, 4, 8 ou 16)
        SET playoff_teams = CASE FLOOR(1 + (RAND() * 4))
            WHEN 1 THEN NULL
            WHEN 2 THEN 4
            WHEN 3 THEN 8
            WHEN 4 THEN 16
        END;

        -- Générer un ID de jeu aléatoire (de 1 à 10)
        SELECT game_id INTO random_game_id
        FROM Game
        WHERE game_id BETWEEN 1 AND 10
        ORDER BY RAND()
        LIMIT 1;

        -- Générer une date de début aléatoire dans les 12 prochains mois
        SET random_month = FLOOR(1 + (RAND() * 12));
        SET random_start_date = DATE_ADD(CURDATE(), INTERVAL random_month MONTH);

        -- Insérer un nouveau tournoi
        INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id)
        VALUES (
            CONCAT('Tournament ', tournament_index),
            3,
            random_start_date,
            DATE_ADD(random_start_date, INTERVAL 10 DAY),
            participant_count,
            playoff_teams,
            random_game_id,
            1 -- Organizer ID
        );

        -- Récupérer l'ID du tournoi inséré
        SET inserted_tournament_id = LAST_INSERT_ID();

        -- Appeler la procédure pour générer les rounds pour le tournoi de type 2
        CALL GenerateTournamentRoundsForType2(inserted_tournament_id, participant_count);

        -- Passer au tournoi suivant
        SET tournament_index = tournament_index + 1;
    END WHILE;
END //

DELIMITER ;

-- CALL CreateSequentialTournamentsType1WithPlayersNoScoreForRound1(25);
-- CALL CreateSequentialTournamentsType1WithPlayersWithScoresForRound1(25);
-- CALL CreateSequentialTournamentsType1WithTeams(50);
-- CALL CreateSequentialTournamentsType2(50);
-- CALL CreateSequentialTournamentsType3(50);