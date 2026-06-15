Fuentes JSON para seeds (SIGRE ERP)
========================================

Regenerar todo el seed maestro (TX0, TX1, TX3, TX4) desde estos JSON, manteniendo TX2 (doc_tipo):

  cd "03. Base de datos"
  python scripts/rebuild_seed_maestros.py

- EMPRESA.json
  Clave raiz: "EMPRESA" o "empresa". Generador: scripts/gen_seed_empresa.py
  (mapea empresa legado a master.empresa; db_name sugerido por SIGLA)

- ARTICULO_CATEG.json, ARTICULO_CLASE.json, ARTICULO_SUB_CATEG.json
  Generador parcial: scripts/gen_seed_articulos.py

- ARTICULO_MOV_TIPO.json
  Clave raiz del array: "articulo_mov_tipo" o "ARTICULO_MOV_TIPO" (export legado).
  Generador: scripts/gen_seed_articulo_mov_tipo.py

- IMPUESTOS_TIPO.json
  Clave raiz: "IMPUESTOS_TIPO". Generador: scripts/gen_seed_impuestos.py

Tras editar cualquier JSON, ejecutar rebuild_seed_maestros.py para que
ddl/seed/01-carga-inicial-maestros.sql coincida con los archivos de data/.

Para aplicar el SQL en el servidor: edite PG* en database-deploy.bat y ejecute
  database-deploy.bat insert
(o create si tambien debe recrearse el DDL).
