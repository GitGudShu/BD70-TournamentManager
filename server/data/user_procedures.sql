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