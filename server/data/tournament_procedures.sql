DELIMITER //
CREATE PROCEDURE CreateTournament(
    IN p_tournament_name VARCHAR(100),
    IN p_tournament_type VARCHAR(50),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_nb_participants INT,
    IN p_playoffTeams INT,
    IN p_game_id INT,
    IN p_organizer_id INT,
    OUT new_tournament_id INT
)
BEGIN
    INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, playoffTeams, game_id, organizer_id)
    VALUES (p_tournament_name, p_tournament_type, p_start_date, p_end_date, p_nb_participants, p_playoffTeams, p_game_id, p_organizer_id);
    
    SET new_tournament_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- This transaction create round and match for TournamentType1
DELIMITER //
CREATE PROCEDURE GenerateTournamentRoundsForType1(
    IN p_tournament_id INT,
    IN p_participant_count INT
)
BEGIN
    -- Déclarer toutes les variables en haut du bloc
    DECLARE totalRounds INT;
    DECLARE currentMatchCount INT;
    DECLARE round INT DEFAULT 1;
    DECLARE new_round_id INT;
    DECLARE match_count INT;

    -- Calculer le nombre total de rounds nécessaires
    SET totalRounds = LOG2(p_participant_count);
    SET currentMatchCount = p_participant_count / 2;

    -- Boucle pour insérer les rounds et les matchs
    WHILE round <= totalRounds DO
        -- Insérer un round
        INSERT INTO TournamentRound (round, section, tournament_id)
        VALUES (round, 1, p_tournament_id);
        
        -- Obtenir l'ID du round inséré
        SET new_round_id = LAST_INSERT_ID();

        -- Initialiser la variable match_count pour chaque round
        SET match_count = 1;
        
        -- Boucle pour insérer les matchs pour chaque round
        WHILE match_count <= currentMatchCount DO
            INSERT INTO Matchmaking (match_date, location, status, tournamentRound_id)
            VALUES (NULL, NULL, 0, new_round_id);
            SET match_count = match_count + 1;
        END WHILE;

        -- Diviser par 2 le nombre de matchs pour le round suivant
        SET currentMatchCount = currentMatchCount / 2;
        SET round = round + 1;
    END WHILE;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE GenerateChampionshipTournamentRounds(
    IN p_tournament_id INT,
    IN p_participant_count INT
)
BEGIN
    DECLARE round_counter INT DEFAULT 1;
    DECLARE i INT;
    DECLARE j INT;
    DECLARE new_round_id INT;

    -- Boucle pour générer un round pour chaque "journée"
    WHILE round_counter <= p_participant_count - 1 DO
        -- Insérer un round
        INSERT INTO TournamentRound (round, section, tournament_id)
        VALUES (CONCAT('Round ', round_counter), round_counter, p_tournament_id);
        
        -- Obtenir l'ID du round créé
        SET new_round_id = LAST_INSERT_ID();

        -- Boucle pour générer les matchs dans ce round
        SET i = 1;
        WHILE i <= p_participant_count / 2 DO
            -- Trouver les joueurs pour chaque match
            SET j = p_participant_count - i + 1;

            -- Insérer les matchs pour cette journée
            INSERT INTO Matchmaking (match_date, location, status, tournamentRound_id)
            VALUES (NULL, NULL, 0, new_round_id);  -- Match entre les joueurs i et j

            -- Passer au match suivant
            SET i = i + 1;
        END WHILE;

        SET round_counter = round_counter + 1;
    END WHILE;
END //

DELIMITER ;

-- player participe tournament
DELIMITER //
CREATE PROCEDURE ParticipateInTournament(
    IN p_tournament_id INT,
    IN p_player_id INT
)
BEGIN
    DECLARE round1_id INT;
    DECLARE available_spots INT;

    -- Vérifier si le joueur est déjà inscrit au tournoi
    IF EXISTS (
        SELECT 1 
        FROM PlayerMatch pm
        JOIN Matchmaking m ON pm.match_id = m.match_id
        JOIN TournamentRound tr ON m.tournamentRound_id = tr.tournamentRound_id
        WHERE tr.tournament_id = p_tournament_id AND pm.player_id = p_player_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le joueur est déjà inscrit à ce tournoi';
    END IF;

    -- Obtenir l'ID du round 1 du tournoi
    SELECT tournamentRound_id INTO round1_id 
    FROM TournamentRound 
    WHERE tournament_id = p_tournament_id AND round = 1
    LIMIT 1;

    -- Vérifier s'il y a des places disponibles dans les matchs du round 1
    SELECT COUNT(*) INTO available_spots
    FROM Matchmaking m
    LEFT JOIN PlayerMatch pm ON m.match_id = pm.match_id
    WHERE m.tournamentRound_id = round1_id
    AND (SELECT COUNT(*) FROM PlayerMatch WHERE match_id = m.match_id) < 2;  -- Compter les matchs avec moins de 2 joueurs

    IF available_spots = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pas de places disponibles dans le round 1';
    END IF;

    -- Inscrire le joueur aux matchs disponibles
    INSERT INTO PlayerMatch (player_id, match_id)
    SELECT p_player_id, m.match_id
    FROM Matchmaking m
    LEFT JOIN PlayerMatch pm ON m.match_id = pm.match_id
    WHERE m.tournamentRound_id = round1_id
    GROUP BY m.match_id
    HAVING COUNT(pm.player_id) < 2
    LIMIT 1; -- Inscrire le joueur à un seul match du round 1

END //
DELIMITER ;

-- This transaction is used to update the result of a match, it updates the scores of the players and determines the winner
DELIMITER //
CREATE PROCEDURE UpdateMatchResult(
    IN p_match_id INT,
    IN p_player1_id INT,
    IN p_score1 INT,
    IN p_player2_id INT,
    IN p_score2 INT,
    IN p_next_match_id INT
)
BEGIN
    DECLARE winner_id INT;

    -- Step 1: Update scores in PlayerMatch
    UPDATE PlayerMatch
    SET score = p_score1, status = 1 -- Mark player as actively competing
    WHERE match_id = p_match_id AND player_id = p_player1_id;

    UPDATE PlayerMatch
    SET score = p_score2, status = 1 -- Mark player as actively competing
    WHERE match_id = p_match_id AND player_id = p_player2_id;

    -- Step 2: Determine winner based on scores
    IF p_score1 > p_score2 THEN
        SET winner_id = p_player1_id;

        -- Update player statuses: Winner and Loser
        UPDATE PlayerMatch
        SET status = 2 -- Winner
        WHERE match_id = p_match_id AND player_id = p_player1_id;

        UPDATE PlayerMatch
        SET status = 3 -- Loser
        WHERE match_id = p_match_id AND player_id = p_player2_id;

    ELSEIF p_score2 > p_score1 THEN
        SET winner_id = p_player2_id;

        -- Update player statuses: Winner and Loser
        UPDATE PlayerMatch
        SET status = 2 -- Winner
        WHERE match_id = p_match_id AND player_id = p_player2_id;

        UPDATE PlayerMatch
        SET status = 3 -- Loser
        WHERE match_id = p_match_id AND player_id = p_player1_id;

    ELSE
        SET winner_id = NULL; -- Draw or unresolved case
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Draws are not supported in this procedure.';
    END IF;

    -- Step 3: Update Matchmaking status to "completed"
    UPDATE Matchmaking
    SET status = 2 -- Match completed
    WHERE match_id = p_match_id;

    -- Step 4: Insert winner into the next match, if applicable
    IF winner_id IS NOT NULL AND p_next_match_id IS NOT NULL THEN
        INSERT INTO PlayerMatch (player_id, match_id, score, status)
        VALUES (winner_id, p_next_match_id, NULL, 0); -- Score is NULL, status is default
    END IF;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE EditTournament(
    IN p_tournament_id INT,
    IN p_tournament_name VARCHAR(100),
    IN p_tournament_type VARCHAR(50),
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_nb_participants INT,
    IN p_playoffTeams INT,
    IN p_game_id INT,
    IN p_organizer_id INT
)
BEGIN
    -- Vérification si le tournoi a des participants
    DECLARE participant_count INT;

    SELECT COUNT(*) INTO participant_count
    FROM PlayerMatch
    WHERE match_id IN (SELECT match_id FROM Matchmaking WHERE tournamentRound_id IN (SELECT tournamentRound_id FROM TournamentRound WHERE tournament_id = p_tournament_id));

    IF participant_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossible de modifier le tournoi car des participants sont déjà inscrits';
    ELSE
        -- Mise à jour du tournoi
        UPDATE Tournament
        SET tournament_name = p_tournament_name,
            tournament_type = p_tournament_type,
            start_date = p_start_date,
            end_date = p_end_date,
            nb_participants = p_nb_participants,
            playoffTeams = p_playoffTeams,
            game_id = p_game_id,
            organizer_id = p_organizer_id
        WHERE tournament_id = p_tournament_id;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteTournament(
    IN p_tournament_id INT
)
BEGIN
    -- Suppression des enregistrements dans PlayerMatch liés au tournoi
    DELETE FROM PlayerMatch
    WHERE match_id IN (
        SELECT match_id FROM Matchmaking
        WHERE tournamentRound_id IN (
            SELECT tournamentRound_id FROM TournamentRound
            WHERE tournament_id = p_tournament_id
        )
    );

    -- Suppression des récompenses liées au tournoi
    DELETE FROM Reward WHERE tournament_id = p_tournament_id;

    -- Suppression des matchs liés au tournoi
    DELETE FROM Matchmaking WHERE tournamentRound_id IN (
        SELECT tournamentRound_id FROM TournamentRound WHERE tournament_id = p_tournament_id
    );

    -- Suppression des tours liés au tournoi
    DELETE FROM TournamentRound WHERE tournament_id = p_tournament_id;

    -- Suppression du tournoi
    DELETE FROM Tournament WHERE tournament_id = p_tournament_id;
END //

DELIMITER ;