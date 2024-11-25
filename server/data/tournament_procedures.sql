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

CREATE PROCEDURE GenerateTournamentRoundsForType2(
    IN p_tournament_id INT,
    IN p_participant_count INT
)
BEGIN
    -- Déclaration de toutes les variables au début
    DECLARE round_counter INT DEFAULT 1;
    DECLARE i INT;
    DECLARE j INT;
    DECLARE new_round_id INT;
    DECLARE playoff_teams INT;
    DECLARE playoff_round INT DEFAULT 1;
    DECLARE currentMatchCount INT;
    DECLARE new_playoff_round_id INT;
    DECLARE match_count INT;

    -- Récupérer la valeur de playoffTeams depuis la table Tournament
    SELECT playoffTeams INTO playoff_teams
    FROM Tournament
    WHERE tournament_id = p_tournament_id;

    -- Boucle pour générer un round pour chaque "journée" (phase de round-robin)
    WHILE round_counter <= p_participant_count - 1 DO
        -- Insérer un round dans la section 1 pour le round-robin
        INSERT INTO TournamentRound (round, section, tournament_id)
        VALUES (CONCAT('Round ', round_counter), 1, p_tournament_id);  -- Section 1 pour round-robin
        
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

    -- Si playoffTeams est fourni (non NULL et une puissance de 2), créer les rounds pour les playoffs
    IF playoff_teams IS NOT NULL AND (playoff_teams & (playoff_teams - 1)) = 0 THEN
        -- Calculer le nombre total de rounds nécessaires pour les playoffs
        SET currentMatchCount = playoff_teams / 2;

        -- Boucle pour insérer les rounds et les matchs des playoffs (section 2)
        WHILE playoff_round <= LOG2(playoff_teams) DO
            -- Insérer un round dans la section 2 pour les playoffs
            INSERT INTO TournamentRound (round, section, tournament_id)
            VALUES (CONCAT('Playoff Round ', playoff_round), 2, p_tournament_id);  -- Section 2 pour les playoffs
            
            -- Obtenir l'ID du round créé
            SET new_playoff_round_id = LAST_INSERT_ID();

            -- Boucle pour insérer les matchs pour ce round des playoffs
            SET match_count = 1;
            WHILE match_count <= currentMatchCount DO
                INSERT INTO Matchmaking (match_date, location, status, tournamentRound_id)
                VALUES (NULL, NULL, 0, new_playoff_round_id);  -- Match entre les joueurs

                SET match_count = match_count + 1;
            END WHILE;

            -- Diviser par 2 le nombre de matchs pour le round suivant
            SET currentMatchCount = currentMatchCount / 2;
            SET playoff_round = playoff_round + 1;
        END WHILE;
    END IF;
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

DELIMITER //

CREATE PROCEDURE TournamentFilter(
    IN p_tournament_name VARCHAR(100),
    IN p_nb_participants INT,
    IN p_game_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SET @query = 'SELECT * FROM Tournament WHERE 1=1';

    IF p_tournament_name IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND tournament_name LIKE @tournament_name');
        SET @tournament_name = CONCAT('%', p_tournament_name, '%');
    END IF;

    IF p_nb_participants IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND nb_participants = @nb_participants');
        SET @nb_participants = p_nb_participants;
    END IF;

    IF p_game_id IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND game_id = @game_id');
        SET @game_id = p_game_id;
    END IF;

    IF p_start_date IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND start_date >= @start_date');
        SET @start_date = p_start_date;
    END IF;

    IF p_end_date IS NOT NULL THEN
        SET @query = CONCAT(@query, ' AND end_date <= @end_date');
        SET @end_date = p_end_date;
    END IF;

    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

CALL TournamentFilter(NULL, 16, NULL, NULL, NULL);
CALL TournamentFilter(NULL, NULL, 3, '2024-01-01', '2024-12-31');
CALL TournamentFilter('Winter', 8, 2, '2024-01-01', '2024-02-01');