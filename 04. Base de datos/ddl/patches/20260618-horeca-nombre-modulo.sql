-- PATCH: Actualizar nombre del módulo HORECA

UPDATE auth.modulo
SET nombre = 'Hoteles, Restaurantes y Catering'
WHERE codigo = 'HORECA';
