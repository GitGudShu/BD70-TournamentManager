DELIMITER //

CREATE PROCEDURE GetPlayersInTeam(
    IN p_team_id INT
)
BEGIN
    SELECT pt.player_id, t.team_id, t.team_name
    FROM PlayerTeam pt
    INNER JOIN Team t ON pt.team_id = t.team_id
    WHERE pt.team_id = p_team_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE RemovePlayerFromTeam(
    IN p_player_id INT,
    IN p_team_id INT
)
BEGIN
    DELETE FROM PlayerTeam
    WHERE player_id = p_player_id AND team_id = p_team_id;
END //

DELIMITER ;

CALL GetPlayersInTeam(1);
CALL RemovePlayerFromTeam(1, 1);