DROP DATABASE IF EXISTS tournament_db;

CREATE DATABASE tournament_db
    CHARACTER SET utf8
    COLLATE utf8_unicode_ci;

USE tournament_db;

DROP TABLE IF EXISTS PlayerMatch;
DROP TABLE IF EXISTS PlayerTeam;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS MatchTree;
DROP TABLE IF EXISTS Reward;
DROP TABLE IF EXISTS Ranking;
DROP TABLE IF EXISTS Matchmaking;
DROP TABLE IF EXISTS Tournament;
DROP TABLE IF EXISTS Team;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Organizer;
DROP TABLE IF EXISTS Game;
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
    player_bio VARCHAR(50),
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
    game_id INT,
    organizer_id INT,
    FOREIGN KEY (game_id) REFERENCES Game(game_id),
    FOREIGN KEY (organizer_id) REFERENCES Organizer(organizer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(50),
    ranking INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Matchmaking (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    match_date VARCHAR(50),
    round INT,
    location VARCHAR(50),
    status TINYINT,
    tournament_id INT,
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Ranking (
    ranking_id INT AUTO_INCREMENT PRIMARY KEY,
    rank_position INT,
    player_id INT,
    team_id INT,
    tournament_id INT,
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE Reward (
    reward_id INT AUTO_INCREMENT PRIMARY KEY,
    reward_name VARCHAR(100),
    reward_description TEXT,
    ranking_id INT,
    FOREIGN KEY (ranking_id) REFERENCES Ranking(ranking_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_unicode_ci;

CREATE TABLE MatchTree (
    matchTree_id VARCHAR(50),
    round INT,
    match_id INT,
    tournament_id INT,
    match_id_1 INT,
    PRIMARY KEY (matchTree_id),
    FOREIGN KEY (match_id) REFERENCES Matchmaking(match_id),
    FOREIGN KEY (tournament_id) REFERENCES Tournament(tournament_id),
    FOREIGN KEY (match_id_1) REFERENCES Matchmaking(match_id)
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
    team_id INT,
    match_id INT,
    score INT,
    status INT,
    PRIMARY KEY (player_id, team_id, match_id),
    FOREIGN KEY (player_id) REFERENCES Player(player_id),
    FOREIGN KEY (team_id) REFERENCES Team(team_id),
    FOREIGN KEY (match_id) REFERENCES Matchmaking(match_id)
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

    -- Get the new user's ID
    SET new_user_id = LAST_INSERT_ID();

    -- Insert into Player table with the new user's ID
    INSERT INTO Player (user_id, player_bio, avatar, ranking)
    VALUES (new_user_id, p_player_bio, p_avatar, 0);

    COMMIT;
END //

DELIMITER ;
