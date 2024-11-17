-- ADMINISTRATOR ACCOUNT
INSERT INTO Users (user_name, user_lastname, user_email, user_password) VALUES
('Jean', 'Admin', 'admin@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC');
INSERT INTO Organizer (organization_name, user_id) VALUES
('Board Game Master Federation', 1);

-- PLAYERS ACCOUNTS
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