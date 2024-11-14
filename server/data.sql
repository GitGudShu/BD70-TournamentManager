DROP DATABASE IF EXISTS tournament_db;

CREATE DATABASE tournament_db
    CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

USE tournament_db;

-- UTF-8 support
SET NAMES 'utf8';

DROP TABLE IF EXISTS TeamMatch;
DROP TABLE IF EXISTS PlayerMatch;
DROP TABLE IF EXISTS PlayerTeam;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Reward;
DROP TABLE IF EXISTS Matchmaking;
DROP TABLE IF EXISTS TournamentRound;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Tournament;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Organizer;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(50),
    user_lastname VARCHAR(50),
    user_email VARCHAR(100),
    user_password VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    player_bio VARCHAR(1000),
    avatar MEDIUMBLOB,
    ranking INT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Organizer (
    organizer_id INT AUTO_INCREMENT PRIMARY KEY,
    organization_name VARCHAR(100),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Game (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(100),
    min_players INT,
    max_players INT,
    game_type TINYINT,
    game_rules TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Tournament (
    tournament_id INT AUTO_INCREMENT PRIMARY KEY,
    tournament_name VARCHAR(100),
    tournament_type TINYINT,
    start_date DATE,
    end_date DATE,
    nb_participants INT,
    playoffTeams INT,
    game_id INT,
    organizer_id INT,
    FOREIGN KEY (game_id) REFERENCES Game(game_id),
    FOREIGN KEY (organizer_id) REFERENCES Organizer(organizer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;


CREATE TABLE TournamentRound (
    tournamentRound_id INT AUTO_INCREMENT,
    round VARCHAR(50),
    section INT,
    tournament_id INT NOT NULL,
    PRIMARY KEY (tournamentRound_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Matchmaking (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    match_date VARCHAR(50),
    location VARCHAR(50),
    status TINYINT,
    tournamentRound_id INT NOT NULL,
    FOREIGN KEY(tournamentRound_id) REFERENCES TournamentRound(tournamentRound_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Reward (
    reward_id INT AUTO_INCREMENT PRIMARY KEY,
    reward_name VARCHAR(100),
    reward_description TEXT,
    tournament_id INT NOT NULL,
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE PlayerGame (
    player_id INT,
    game_id INT,
    PRIMARY KEY (player_id, game_id),
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (game_id) REFERENCES Game(game_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE PlayerTeam (
    player_id INT,
    team_id INT,
    PRIMARY KEY (player_id, team_id),
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (team_id) REFERENCES Team(team_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE PlayerMatch (
    player_id INT,
    match_id INT,
    score INT,
    status INT,
    PRIMARY KEY (player_id, match_id),
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (match_id) REFERENCES Matchmaking(match_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE TeamMatch(
   team_id INT,
   match_id INT,
   score INT,
   status INT,
   PRIMARY KEY(team_id, match_id),
   FOREIGN KEY(team_id) REFERENCES Team(team_id),
   FOREIGN KEY(match_id) REFERENCES Matchmaking(match_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

-- INITIAL INSERTS
INSERT INTO Game (game_name, min_players, max_players, game_type, game_rules) VALUES
('Les échecs', 2, 2, 0, 'Jeu de stratégie et de tactique où chaque joueur doit mettre le roi adverse en échec et mat.'),
('Othello', 2, 2, 0, 'Jeu de plateau où les joueurs doivent capturer les jetons adverses entre leurs propres jetons.'),
('Catane', 3, 4, 0, 'Jeu de stratégie où les joueurs collectent des ressources pour construire des routes, des colonies et des villes.'),
('Go', 2, 2, 0, 'Jeu de stratégie ancien où deux joueurs placent alternativement des pierres sur un plateau, visant à contrôler un territoire plus vaste.'),
('Shogi', 2, 2, 0, 'Variante japonaise des échecs où les pièces capturées peuvent être réintroduites sur le plateau par le joueur capturant.'),
('Carcassonne', 2, 5, 0, 'Jeu où les joueurs placent des tuiles pour construire des châteaux, des routes, des champs et des monastères pour marquer des points.'),
('Puissance 4', 2, 2, 0, 'Jeu de grille où les joueurs alternent pour placer des jetons, visant à aligner quatre jetons de leur couleur.'),
('Risk', 3, 6, 1, 'Jeu de conquête stratégique où les joueurs luttent pour le contrôle de territoires sur une carte du monde.'),
('Scrabble', 2, 4, 0, 'Jeu de lettres où les joueurs utilisent des tuiles de lettres pour former des mots sur une grille pour gagner des points.'),
('Dames', 2, 2, 0, 'Jeu de plateau où deux joueurs déplacent leurs pièces diagonalement pour capturer les pièces adverses en sautant par-dessus.');

-- ADMINISTRATOR ACCOUNT
INSERT INTO Users (user_name, user_lastname, user_email, user_password) VALUES
('Jean', 'Admin', 'admin@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC');
INSERT INTO Organizer (organization_name, user_id) VALUES
('Board Game Master Federation', 1);

INSERT INTO Users (user_name, user_lastname, user_email, user_password) VALUES 
('Lewis', 'Hamilton', 'lewis.hamilton@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Max', 'Verstappen', 'max.verstappen@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Charles', 'Leclerc', 'charles.leclerc@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Sebastian', 'Vettel', 'sebastian.vettel@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Fernando', 'Alonso', 'fernando.alonso@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Valtteri', 'Bottas', 'valtteri.bottas@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Lando', 'Norris', 'lando.norris@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Daniel', 'Ricciardo', 'daniel.ricciardo@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC');

INSERT INTO Player (player_bio, avatar, ranking, user_id) VALUES 
('Champion du ', NULL, 1, 2),  -- Lewis Hamilton
('Pilote exce', NULL, 2, 3),  -- Max Verstappen
('Talentueux pilot', NULL, 3, 4),  -- Charles Leclerc
('Ancien champi', NULL, 4, 5),  -- Sebastian Vettel
('Pilote de F1 e', NULL, 5, 6),  -- Fernando Alonso
('Connu pour ses pe', NULL, 6, 7),  -- Valtteri Bottas
('Jeune talent promett', NULL, 7, 8),  -- Lando Norris
('Pilote talentueu', NULL, 8, 9);  -- Daniel Ricciardo

INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id) 
VALUES 
('Tournoi de Stratégie 2024', 1, '2024-12-01', '2024-12-10', 16, 1, 1);

-- TRANSACTIONS

-- This transaction is used to insert a new player into the database, it creates a new user and a new player (linked to the user)
DELIMITER //

CREATE PROCEDURE CreateUserAndPlayer(
    IN p_user_name VARCHAR(50),
    IN p_user_lastname VARCHAR(50),
    IN p_user_email VARCHAR(100),
    IN p_user_password VARCHAR(255),
    IN p_player_bio VARCHAR(50),
    IN p_avatar MEDIUMBLOB
)
BEGIN
    DECLARE new_user_id INT;

    START TRANSACTION;

    INSERT INTO Users (user_name, user_lastname, user_email, user_password)
    VALUES (p_user_name, p_user_lastname, p_user_email, p_user_password);

    SET new_user_id = LAST_INSERT_ID();

    INSERT INTO Player (user_id, player_bio, avatar, ranking)
    VALUES (new_user_id, p_player_bio, p_avatar, 0);

    COMMIT;
END //

DELIMITER ;

-- This transaction create a tournament 
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

-- procedures mockées
CALL GenerateTournamentRoundsForType1(1, 16);