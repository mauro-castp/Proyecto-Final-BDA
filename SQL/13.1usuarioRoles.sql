DELIMITER //
CREATE PROCEDURE usuarioRoles(
    IN p_id_usuario INT
)
BEGIN
    SELECT r.nombre_rol
    FROM usuarios u
    JOIN roles r ON r.id_rol = u.id_rol
    WHERE u.id_usuario = p_id_usuario;
END //
DELIMITER ;
