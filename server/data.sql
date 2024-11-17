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

-- Execute SQL files for data and procedures
SOURCE data/tournament_procedures.sql;
SOURCE data/user_procedures.sql;
SOURCE data/insert_games.sql;
SOURCE data/insert_users.sql;
SOURCE data/insert_tournaments.sql;
SOURCE data/insert_team.sql;