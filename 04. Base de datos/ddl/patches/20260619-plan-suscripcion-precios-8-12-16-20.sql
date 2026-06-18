-- PATCH: Precios tarifa base 8 / 12 / 16 / 20 (USD, sin impuestos)

UPDATE auth.plan_suscripcion SET precio = 8 WHERE codigo = 'STANDARD';
UPDATE auth.plan_suscripcion SET precio = 12 WHERE codigo = 'SMALL_BUSINESS';
UPDATE auth.plan_suscripcion SET precio = 16 WHERE codigo = 'PERSONALIZADO';
UPDATE auth.plan_suscripcion SET precio = 20 WHERE codigo = 'ENTERPRISE';
