-- PATCH: Empresa SUNAT SIGRE_WEB y rucOrigen dinámico (ya no se guarda en config)

UPDATE config.configuracion
SET valor_texto = 'SIGRE_WEB',
    modificado_en = NOW()
WHERE modulo = 'SUNAT'
  AND parametro = 'API_EMPRESA';

DELETE FROM config.configuracion
WHERE modulo = 'SUNAT'
  AND parametro = 'API_RUC_ORIGEN';
