-- Catálogo SIGRE RRHH_TIPO_DOC_RTPS (RRHH_TIPO_DOC_RTPS.json)
INSERT INTO core.tipo_doc_identidad (codigo, nombre, flag_estado, tipo_doc, tipo_doc_afpnet, flag_doc_bbva)
VALUES
    ('1', 'DNI', '1', NULL, '0', NULL),
    ('2', 'Carnet de las Fuerzas Policiales', '1', NULL, '2', NULL),
    ('3', 'Carnet de las Fuerzas Armadas', '1', NULL, '2', NULL),
    ('4', 'Carne de Extranjería', '1', NULL, '1', NULL),
    ('6', 'RUC', '1', NULL, '9', NULL),
    ('7', 'Pasaporte', '1', NULL, '4', NULL),
    ('0', 'OTROS TIPOS DE DOCUMENTOS', '1', NULL, '0', NULL)
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    flag_estado = EXCLUDED.flag_estado,
    tipo_doc = EXCLUDED.tipo_doc,
    tipo_doc_afpnet = EXCLUDED.tipo_doc_afpnet,
    flag_doc_bbva = EXCLUDED.flag_doc_bbva;
