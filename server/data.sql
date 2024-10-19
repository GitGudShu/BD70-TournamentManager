-- Temporary data to test the API :)
CREATE TABLE Jeux (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    min_players INT NOT NULL,
    max_players INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    rules TEXT,
    image BLOB
);

-- Insert sample board games (without images for now)
INSERT INTO Jeux (name, min_players, max_players, type, rules)
VALUES 
('Shogi', 2, 2, 'solo', 'Shogi is a two-player strategy game similar to chess, but with drop rules.'),
('Go', 2, 2, 'solo', 'Go is an ancient board game where players try to surround more territory than the opponent.'),
('Othello', 2, 2, 'solo', 'Othello is a strategy board game for two players where the goal is to have the majority of discs turned to display your color.'),
('Les Colons de Catane', 3, 4, 'team', 'The goal of the game is to build settlements, cities, and roads, while trading resources with other players.'),
('Monopoly', 2, 8, 'team', 'Monopoly is an economic-themed board game where players buy and trade properties, trying to bankrupt opponents.');
