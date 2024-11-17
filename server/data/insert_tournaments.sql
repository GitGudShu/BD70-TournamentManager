INSERT INTO Tournament (tournament_name, tournament_type, start_date, end_date, nb_participants, game_id, organizer_id) 
VALUES ('GP Abu Dhabi', 1, '2024-12-01', '2024-12-10', 4, 1, 1);

CALL GenerateTournamentRoundsForType1(1, 4);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (1, 1, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (2, 1, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (3, 2, NULL, NULL);
INSERT INTO PlayerMatch (player_id, match_id, score, status) VALUES (4, 2, NULL, NULL);