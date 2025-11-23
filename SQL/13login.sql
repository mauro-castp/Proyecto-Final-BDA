DELIMITER //
CREATE PROCEDURE login(
    IN p_email VARCHAR(150),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    SELECT 
        id_usuario,
        nombre,
        email,
        id_rol
    FROM usuarios
    WHERE email = p_email
      AND password_hash = p_password_hash
      AND id_estado = 1;
END //
DELIMITER ;
