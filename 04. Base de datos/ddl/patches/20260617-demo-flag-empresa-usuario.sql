-- ============================================================
-- PATCH: Agregar flag_demo a empresa y usuario
-- Permite registrar empresas y usuarios demo desde la landing
-- ============================================================

-- Empresa demo: flag_demo = '1' indica empresa demo (max 5 usuarios)
ALTER TABLE master.empresa
    ADD COLUMN IF NOT EXISTS flag_demo VARCHAR(1) NOT NULL DEFAULT '0'
    CHECK (flag_demo IN ('0', '1'));

-- Usuario demo: flag_demo = '1' indica usuario registrado por autoinscripción
ALTER TABLE auth.usuario
    ADD COLUMN IF NOT EXISTS flag_demo VARCHAR(1) NOT NULL DEFAULT '0'
    CHECK (flag_demo IN ('0', '1'));

CREATE INDEX IF NOT EXISTS IX_EMPRESA_DEMO ON master.empresa (flag_demo)
    WHERE flag_demo = '1';

CREATE INDEX IF NOT EXISTS IX_USUARIO_DEMO ON auth.usuario (flag_demo)
    WHERE flag_demo = '1';
