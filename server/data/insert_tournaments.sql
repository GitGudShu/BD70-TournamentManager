INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id) 
VALUES ('GP Abu Dhabi', 1, '2024-12-01', '2024-12-10', 4, 1, 1);

CALL GenerateTournamentRoundsForType1(1, 4);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (1, 1, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (2, 1, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (3, 2, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (4, 2, NULL, NULL);

-- INSERT LOTS OF TOURNAMENTS
DELIMITER //

CREATE PROCEDURE CreateRandomTournaments(
    IN p_tournament_count INT
)
BEGIN
    DECLARE tournament_index INT DEFAULT 1;
    DECLARE participant_count INT;
    DECLARE match_count INT;
    DECLARE player_index INT;
    DECLARE round1_id INT;
    DECLARE inserted_tournament_id INT;
    DECLARE random_game_id INT;
    DECLARE random_month INT;
    DECLARE random_start_date DATE;
    DECLARE player_ids VARCHAR(255);

    SET player_ids = '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16';

    WHILE tournament_index <= p_tournament_count DO
        SET participant_count = CASE FLOOR(1 + (RAND() * 3))
            WHEN 1 THEN 4
            WHEN 2 THEN 8
            WHEN 3 THEN 16
        END;

        SELECT game_id INTO random_game_id
        FROM Game
        ORDER BY RAND()
        LIMIT 1;

        SET random_month = FLOOR(1 + (RAND() * 12));
        SET random_start_date = DATE_ADD(CURDATE(), INTERVAL random_month MONTH);

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

        CALL GenerateTournamentRoundsForType1(inserted_tournament_id, participant_count);

        SELECT tournamentRound_id INTO round1_id
        FROM TournamentRound
        WHERE tournament_id = inserted_tournament_id AND round = 1
        LIMIT 1;

        SET match_count = participant_count / 2;

        SET @players = SUBSTRING_INDEX(player_ids, ',', participant_count);
        SET @match_index = 1;

        WHILE @match_index <= match_count DO
            INSERT INTO PlayerMatch (player_id, match_id, score, status)
            SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@players, ',', @match_index * 2 - 1), ',', -1), m.match_id, NULL, NULL
            FROM Matchmaking m
            WHERE m.tournamentRound_id = round1_id
            ORDER BY m.match_id ASC
            LIMIT 1;

            INSERT INTO PlayerMatch (player_id, match_id, score, status)
            SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(@players, ',', @match_index * 2), ',', -1), m.match_id, NULL, NULL
            FROM Matchmaking m
            WHERE m.tournamentRound_id = round1_id
            ORDER BY m.match_id ASC
            LIMIT 1;

            SET @match_index = @match_index + 1;
        END WHILE;

        SET tournament_index = tournament_index + 1;
    END WHILE;
END //

DELIMITER ;


CALL CreateRandomTournaments(100);
