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

INSERT INTO Users (user_name, user_lastname, user_email, user_password) VALUES 
('Arthur', 'Pendragon', 'arthur.pendragon@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Lancelot', 'du Lac', 'lancelot.dulac@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Gawain', 'Green', 'gawain.green@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Percival', 'Brave', 'percival.brave@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Galahad', 'Pureheart', 'galahad.pureheart@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Tristan', 'Valiant', 'tristan.valiant@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Kay', 'Steadfast', 'kay.steadfast@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC'),
('Bedivere', 'Loyal', 'bedivere.loyal@example.com', '$2b$10$5nHegeYB/uFrSpGqbHleteyI06E3ixBlc7zBGdmSPLUoUHdFRPtFC');

INSERT INTO Player (player_bio, avatar, ranking, user_id) VALUES 
('Legendary F1 champion known for his skill and determination.', NULL, 1, 2), -- Lewis Hamilton
('Exceptional F1 driver with unmatched precision and speed.', NULL, 2, 3), -- Max Verstappen
('Talented young F1 driver with a bright future ahead.', NULL, 3, 4), -- Charles Leclerc
('Former world champion and icon of motorsport excellence.', NULL, 4, 5), -- Sebastian Vettel
('Veteran F1 driver renowned for his strategic brilliance.', NULL, 5, 6), -- Fernando Alonso
('Consistent performer and team player in the F1 circuit.', NULL, 6, 7), -- Valtteri Bottas
('Rising star in F1, known for his charisma and daring moves.', NULL, 7, 8), -- Lando Norris
('Talented driver with a reputation for thrilling comebacks.', NULL, 8, 9); -- Daniel Ricciardo

INSERT INTO Player (player_bio, avatar, ranking, user_id) VALUES 
('Visionary leader and champion with an unyielding sense of justice.', NULL, 9, 10), -- Arthur Pendragon
('Chivalrous competitor, known for his elegance and raw talent.', NULL, 10, 11), -- Lancelot du Lac
('Fearless racer who thrives in high-pressure situations.', NULL, 11, 12), -- Gawain Green
('Courageous driver with a knack for clutch performances.', NULL, 12, 13), -- Percival Brave
('The epitome of purity and sportsmanship on and off the track.', NULL, 13, 14), -- Galahad Pureheart
('Valiant contender, always racing with passion and purpose.', NULL, 14, 15), -- Tristan Valiant
('Steadfast and reliable, a true pillar of the motorsport community.', NULL, 15, 16), -- Kay Steadfast
('Loyal to the core, admired for his resilience and teamwork.', NULL, 16, 17); -- Bedivere Loyal
