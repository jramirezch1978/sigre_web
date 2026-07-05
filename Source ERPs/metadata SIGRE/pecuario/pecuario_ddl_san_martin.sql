-- ============================================================================
-- MODULO PECUARIO (PC_*) -- generico, cualquier especie (bovino, porcino,
-- caprino, ovino, equino, etc.), no exclusivo de una empresa ni de vacunos.
-- Compatible con Oracle 11g R2. Ejecutar como el usuario/esquema correspondiente
-- (ajustar el nombre de esquema si no es CANTABRIA -- buscar/reemplazar
-- "CANTABRIA." por el esquema de la empresa destino antes de correr).
--
-- ============================================================================
-- CONVENCION DE CLAVES PRIMARIAS (obligatoria, sin excepcion)
-- ============================================================================
-- 1) Tablas-DOCUMENTO (identidad = un numero de documento interno, igual
--    concepto que nro_orden/nro_os/nro_orden_compra en el resto del ERP):
--    PK = UNA SOLA COLUMNA CHAR(10), formato cod_origen(2) + correlativo(8,
--    zero-padded), ej. 'SU00000001'. El cod_origen queda embebido en el
--    propio numero, por eso NO es PK compuesta con cod_origen -- cod_origen
--    sigue existiendo como columna aparte (con su propia FK a ORIGEN) solo
--    para filtrar/consultar. Se genera con un trigger BEFORE INSERT que usa
--    la tabla generica NUM_TABLAS (tabla, origen, ult_nro), EXACTAMENTE el
--    mismo mecanismo que ya usa el resto del sistema (confirmado en
--    package_body_cantabria.sql y en la ventana w_cam006_numeracion_origen).
--    Tablas de este tipo en Pecuario: PC_ANIMAL (cod_animal), PC_SERVICIO
--    (nro_servicio).
-- 2) Tablas-DOCUMENTO EXTERNO (el numero lo asigna un tercero, ej. SENASA):
--    PK = reckey interno (ver 3), y el numero externo queda como columna de
--    texto libre UNIQUE, NO autogenerada. Tabla de este tipo: PC_DTA.
-- 3) Todo el resto de tablas (catalogos, detalle, eventos): PK = reckey
--    NUMBER(10), autonumerico via SEQUENCE + trigger BEFORE INSERT, mismo
--    patron ya usado en ARTICULO_MOV.nro_mov (SEQ_ALM_ARTICULO_MOV +
--    TIB_ARTICULO_MOV_NRO_MOV, confirmado en triggers_cantabria.sql). Los
--    codigos de negocio (cod_raza, cod_potrero, etc.) se mantienen como
--    columnas con constraint UNIQUE (no PK), asi las FK de otras tablas que
--    ya apuntaban a esos codigos NO cambian.
-- 4) cod_origen: SIN EXCEPCION, toda tabla que tenga esta columna debe
--    tener FK a CANTABRIA.ORIGEN(cod_origen).
-- ============================================================================
--
-- Orden de creacion respeta dependencias de FK:
--   0) Especie: NO se crea tabla PC_ESPECIE -- se reutiliza CANTABRIA.TG_ESPECIES
--      (catalogo real y ya existente del modulo de pesca), agregandole el valor
--      'P' (Pecuario) a su columna flag_tipo_especie y dos columnas nuevas
--      opcionales (periodo_gestacion_dias, periodo_incubacion_dias). TG_ESPECIES
--      NO es una tabla PC_*, por lo tanto nunca se dropea con este script.
--   1) Catalogos (PC_RAZA, PC_POTRERO, PC_ESTABLO, PC_CATEGORIA, PC_SEMENTAL,
--      PC_PRODUCTO_SANITARIO, PC_ENFERMEDAD, PC_DIETA, PC_DIETA_COMPONENTE)
--   1b) PC_RECETA / PC_RECETA_DET (nuevo: receta de fabricacion de
--      concentrado -- ver seccion de integracion con Almacen/Produccion)
--   1c) PC_LOTE (nuevo: cohorte/agrupacion de cabezas, ver seccion 8 del .md)
--   1d) Extension avicola (nuevo: PC_POSTURA, PC_INCUBACION,
--      PC_LOTE_MORTALIDAD -- ciclo reproductoras -> incubacion -> eclosion ->
--      lote de engorde, para especies oviparas -- ver seccion 8b del .md)
--   2) Maestro de animal (PC_ANIMAL, PC_OT_ANIMAL)
--   3) Reproduccion (PC_CELO, PC_SERVICIO, PC_DIAGNOSTICO_PRENEZ, PC_PARTO)
--   4) Produccion de leche (PC_LACTANCIA, PC_ORDENO, PC_CONTROL_LECHERO)
--   5) Nutricion (PC_CONDICION_CORPORAL, PC_ALIMENTACION_CONSUMO)
--   6) Sanidad (PC_SANIDAD_EVENTO)
--   7) Resultados de laboratorio (PC_LABORATORIO, PC_LABORATORIO_DET)
--   8) Movimientos / trazabilidad / bajas (PC_MOVIMIENTO_POTRERO,
--      PC_MOVIMIENTO_ESTABLO, PC_DTA, PC_DTA_DETALLE, PC_BAJA)
--
-- NOTA: ARTICULO, ORDEN_TRABAJO, OPERACIONES, ARTICULO_MOV, VALE_MOV,
-- ORDEN_SERVICIO, ALMACEN, TIPO_PRODUCTO, OT_TIPO, ORIGEN, NUM_TABLAS y
-- ORDEN_VENTA se asumen YA EXISTENTES (son tablas genericas y compartidas
-- del ERP, no exclusivas de Pecuario).
--
-- INTEGRACION CON ORDEN DE TRABAJO (OT) -- "OT Pecuaria": ver seccion 6 del
-- documento pecuario_modulo_diseno.md para el detalle completo (cadena real
-- ORDEN_TRABAJO -> OPERACIONES -> ARTICULO_MOV -> VALE_MOV, ORDEN_SERVICIO
-- para costos externos, I09 para ingresos de produccion). Una "OT Pecuaria"
-- es una fila de ORDEN_TRABAJO con ot_adm='PECU', y es POR EVENTO/PERIODO
-- operativo (ej. una semana de alimentacion, una campana de vacunacion), NO
-- una OT de por vida del animal ni por etapa -- ver seccion 6 para el
-- razonamiento completo.
--
-- NOTA SOBRE VENTANAS: las tablas usan el prefijo PC_* (Pecuario), pero las
-- VENTANAS PowerBuilder usan el prefijo real de Campo (CAM###), numeradas por
-- TIPO de opcion (igual regla que el resto del sistema): Tablas 000-299,
-- Operaciones 300-499, Consultas 500-699, Reportes 700-899, Procesos 900-999.
-- Bloques asignados a Pecuario (primer hueco contiguo libre en cada rango,
-- NO continuacion tras el ultimo codigo de Campo/cana):
--   Tablas      CAM061-CAM070 (hueco libre real: 061-199)
--   Operaciones CAM391-CAM411 (hueco libre real: 391-411 -- AGOTADO, ver .md)
--   Consultas   CAM500-CAM506 (rango completo sin uso previo)
--   Reportes    CAM716-CAM722 (hueco libre real: 716-751)
--   Procesos    CAM900-CAM905 (rango completo sin uso previo)
-- Detalle completo: Source ERPs/metadata SIGRE/pecuario/pecuario_modulo_diseno.md
--
-- IDEMPOTENCIA: este script se puede ejecutar tantas veces como se necesite.
-- El bloque de limpieza previa (justo abajo) elimina UNICAMENTE tablas y
-- secuencias con prefijo PC_*/SEQ_PC_* (nunca ORIGEN, ARTICULO, ORDEN_TRABAJO
-- ni ninguna otra tabla generica del ERP) usando CASCADE CONSTRAINTS, que
-- elimina automaticamente las FK que otras tablas PC_* tengan hacia la que
-- se esta borrando -- por eso NO importa el orden (una tabla maestra con
-- tablas detalle que la referencian se puede eliminar sin error). Los datos
-- que el script inserta en tablas COMPARTIDAS (ORIGEN, OT_TIPO, ALMACEN,
-- TIPO_PRODUCTO, ORDEN_TRABAJO, ORDEN_VENTA, TG_ESPECIES) usan "insertar solo
-- si no existe" en vez de tocar esas tablas de forma destructiva. La unica
-- excepcion son dos columnas nuevas y opcionales que se agregan a
-- TG_ESPECIES (periodo_gestacion_dias, periodo_incubacion_dias) mediante
-- ALTER TABLE ADD guardado (se ignora el error si la columna ya existe) --
-- nunca se elimina ni se modifica ninguna columna existente de esa tabla.
-- ============================================================================


-- ============================================================================
-- LIMPIEZA PREVIA (idempotencia) -- SOLO objetos PC_*/SEQ_PC_*
-- ============================================================================
begin
  for t in (
    select table_name from all_tables
     where owner = 'CANTABRIA'
       and table_name like 'PC\_%' escape '\'
  ) loop
    begin
      execute immediate 'drop table CANTABRIA.' || t.table_name || ' cascade constraints';
    exception when others then null; -- ORA-00942 si no existe: se ignora
    end;
  end loop;
end;
/

begin
  for s in (
    select sequence_name from all_sequences
     where sequence_owner = 'CANTABRIA'
       and sequence_name like 'SEQ\_PC\_%' escape '\'
  ) loop
    begin
      execute immediate 'drop sequence CANTABRIA.' || s.sequence_name;
    exception when others then null; -- ORA-02289 si no existe: se ignora
    end;
  end loop;
end;
/


-- ============================================================================
-- 0) ESPECIE -- REUTILIZA CANTABRIA.TG_ESPECIES (catalogo real y ya existente
-- del modulo de pesca/acopio, PK especie CHAR(8), 15 FK reales en produccion
-- desde tablas de flota/pesca -- NO es una tabla PC_*, por eso NUNCA se dropea
-- ni se toca con las sentencias destructivas de este script).
--
-- Decision del usuario: en vez de crear una tabla PC_ESPECIE nueva (que solo
-- necesitaria 3-4 columnas: codigo, nombre, estado, periodo de gestacion),
-- se reutiliza TG_ESPECIES agregando el valor 'P' (Pecuario) a su columna
-- flag_tipo_especie (que ya distingue 'H'=Hidrobiologico y 'V'=Vegetal). Los
-- procesos existentes de pesca filtran explicitamente flag_tipo_especie='H',
-- asi que las filas 'P' no interfieren con ellos.
--
-- Columnas de TG_ESPECIES que Pecuario usa: especie (PK), descr_especie,
-- nombre_cientifico (ya existia, gratis), flag_tipo_especie='P', flag_estado,
-- y dos columnas NUEVAS y OPCIONALES (nullable, agregadas de forma aditiva
-- y solo si no existen -- jamas se elimina ni se altera ninguna columna
-- existente de esta tabla ajena):
--   periodo_gestacion_dias  NUMBER(4) -- mamiferos: dias de fec_servicio a fec_prob_parto
--   periodo_incubacion_dias NUMBER(4) -- oviparos: dias de fec_carga a fec_eclosion_prevista
-- ============================================================================
begin
  execute immediate 'alter table CANTABRIA.TG_ESPECIES add periodo_gestacion_dias NUMBER(4)';
exception when others then
  if sqlcode != -1430 then raise; end if; -- ORA-01430: columna ya existe, se ignora
end;
/

begin
  execute immediate 'alter table CANTABRIA.TG_ESPECIES add periodo_incubacion_dias NUMBER(4)';
exception when others then
  if sqlcode != -1430 then raise; end if;
end;
/

comment on column CANTABRIA.TG_ESPECIES.periodo_gestacion_dias is 'Pecuario (flag_tipo_especie=P) - dias de gestacion (mamiferos): fec_prob_parto = fec_servicio + este valor';
comment on column CANTABRIA.TG_ESPECIES.periodo_incubacion_dias is 'Pecuario (flag_tipo_especie=P) - dias de incubacion (oviparos): fec_eclosion_prevista = fec_carga + este valor';

-- Datos iniciales sugeridos (insertar solo si no existe -- TG_ESPECIES es
-- una tabla compartida, nunca se trunca ni se borra desde este script).
-- AJUSTAR/VERIFICAR antes de ejecutar en un esquema con data real de pesca:
-- confirmar que estos codigos de 4 letras no colisionen con codigos de
-- especies hidrobiologicas/vegetales ya existentes.
insert into CANTABRIA.TG_ESPECIES (especie, descr_especie, nombre_cientifico, flag_tipo_especie, flag_estado, periodo_gestacion_dias)
  select 'BOVI','Bovino','Bos taurus','P','1',283 from dual
   where not exists (select 1 from CANTABRIA.TG_ESPECIES where especie = 'BOVI');
insert into CANTABRIA.TG_ESPECIES (especie, descr_especie, nombre_cientifico, flag_tipo_especie, flag_estado, periodo_gestacion_dias)
  select 'PORC','Porcino','Sus scrofa domesticus','P','1',114 from dual
   where not exists (select 1 from CANTABRIA.TG_ESPECIES where especie = 'PORC');
insert into CANTABRIA.TG_ESPECIES (especie, descr_especie, nombre_cientifico, flag_tipo_especie, flag_estado, periodo_gestacion_dias)
  select 'CAPR','Caprino','Capra aegagrus hircus','P','1',150 from dual
   where not exists (select 1 from CANTABRIA.TG_ESPECIES where especie = 'CAPR');
insert into CANTABRIA.TG_ESPECIES (especie, descr_especie, nombre_cientifico, flag_tipo_especie, flag_estado, periodo_gestacion_dias)
  select 'OVIN','Ovino','Ovis aries','P','1',150 from dual
   where not exists (select 1 from CANTABRIA.TG_ESPECIES where especie = 'OVIN');
insert into CANTABRIA.TG_ESPECIES (especie, descr_especie, nombre_cientifico, flag_tipo_especie, flag_estado, periodo_gestacion_dias)
  select 'EQUI','Equino','Equus ferus caballus','P','1',340 from dual
   where not exists (select 1 from CANTABRIA.TG_ESPECIES where especie = 'EQUI');
insert into CANTABRIA.TG_ESPECIES (especie, descr_especie, nombre_cientifico, flag_tipo_especie, flag_estado, periodo_incubacion_dias)
  select 'AVES','Avicola','Gallus gallus domesticus','P','1',21 from dual
   where not exists (select 1 from CANTABRIA.TG_ESPECIES where especie = 'AVES');
commit;


-- ============================================================================
-- 1) CATALOGOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_RAZA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_RAZA
(
  reckey        NUMBER(10)    not null,
  cod_especie   CHAR(8)       not null,
  cod_raza      CHAR(4)       not null,
  nom_raza      VARCHAR2(200)  not null,
  flag_tipo     CHAR(1)       default 'L' not null,
  flag_estado   CHAR(1)       default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_RAZA add constraint PK_PC_RAZA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_RAZA add constraint UQ_PC_RAZA_COD unique (cod_raza) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_RAZA add constraint CK_PC_RAZA_TIPO check (flag_tipo in ('L','C','M','F','T','R'));
alter table CANTABRIA.PC_RAZA add constraint FK_PC_RAZA_ESPECIE foreign key (cod_especie) references CANTABRIA.TG_ESPECIES(especie);

comment on table CANTABRIA.PC_RAZA is 'Pecuario - Catalogo de razas (de cualquier especie)';
comment on column CANTABRIA.PC_RAZA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_RAZA.cod_especie is 'FK a TG_ESPECIES.especie (catalogo compartido de especies del modulo de pesca; Pecuario usa las filas con flag_tipo_especie=P)';
comment on column CANTABRIA.PC_RAZA.cod_raza is 'codigo de raza (unique, no PK)';
comment on column CANTABRIA.PC_RAZA.nom_raza is 'nombre de la raza';
comment on column CANTABRIA.PC_RAZA.flag_tipo is 'L=Lechera, C=Carne, M=Doble proposito, F=Fibra/lana, T=Trabajo/traccion, R=Reproduccion/genetica (aplica a cualquier especie, no solo bovinos)';
comment on column CANTABRIA.PC_RAZA.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_RAZA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_RAZA
before insert on CANTABRIA.PC_RAZA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_RAZA.nextval into :new.reckey from dual;
  end if;
end;
/

-- Datos iniciales sugeridos: al menos algunas razas de ejemplo por cada
-- especie sembrada en TG_ESPECIES (BOVI, PORC, CAPR, OVIN, EQUI, AVES) --
-- agregar mas razas o especies segun necesidad real del cliente.
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','HOLS','Holstein','L');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','JERS','Jersey','L');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','BRSW','Brown Swiss','M');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','GYR','Gyr','M');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','BRAH','Brahman','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','ANGU','Angus','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('BOVI','CRUC','Cruzado / mestizo','M');
-- Porcino
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('PORC','YORK','Yorkshire (Large White)','R');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('PORC','LAND','Landrace','R');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('PORC','DURO','Duroc','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('PORC','HAMP','Hampshire','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('PORC','PIET','Pietrain','C');
-- Caprino
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('CAPR','SAAN','Saanen','L');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('CAPR','ALPI','Alpina','L');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('CAPR','BOER','Boer','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('CAPR','ANGO','Angora','F');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('CAPR','CRIC','Criollo','M');
-- Ovino
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('OVIN','MERI','Merino','F');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('OVIN','CORR','Corriedale','M');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('OVIN','SUFF','Suffolk','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('OVIN','DORP','Dorper','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('OVIN','PELI','Pelibuey','C');
-- Equino
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('EQUI','PERU','Peruano de Paso','T');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('EQUI','CRIE','Criollo','T');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('EQUI','PERC','Percheron','T');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('EQUI','PASO','Paso Fino','T');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('EQUI','PSCR','Pura Sangre de Carrera','R');
-- Avicola
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('AVES','ROSS','Ross 308 (pollo de engorde)','C');
insert into CANTABRIA.PC_RAZA (cod_especie, cod_raza, nom_raza, flag_tipo) values ('AVES','HYLN','Hy-Line Brown (ponedora)','L');
commit;


-- ----------------------------------------------------------------------------
-- PC_POTRERO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_POTRERO
(
  reckey         NUMBER(10)    not null,
  cod_origen     CHAR(2)       not null,
  cod_potrero    CHAR(6)       not null,
  nom_potrero    VARCHAR2(200)  not null,
  area_has       NUMBER(8,2),
  tipo_pasto     VARCHAR2(200),
  capacidad_cab  NUMBER(6),
  flag_estado    CHAR(1)       default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_POTRERO add constraint PK_PC_POTRERO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_POTRERO add constraint UQ_PC_POTRERO unique (cod_origen, cod_potrero) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_POTRERO add constraint FK_PC_POTRERO_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);

comment on table CANTABRIA.PC_POTRERO is 'Pecuario - Potreros/lotes de pastoreo por fundo';
comment on column CANTABRIA.PC_POTRERO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_POTRERO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_POTRERO.cod_potrero is 'codigo de potrero (unique junto a cod_origen, no PK)';
comment on column CANTABRIA.PC_POTRERO.nom_potrero is 'nombre del potrero';
comment on column CANTABRIA.PC_POTRERO.area_has is 'area en hectareas';
comment on column CANTABRIA.PC_POTRERO.tipo_pasto is 'tipo de pasto';
comment on column CANTABRIA.PC_POTRERO.capacidad_cab is 'capacidad de carga en numero de cabezas';
comment on column CANTABRIA.PC_POTRERO.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_POTRERO start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_POTRERO
before insert on CANTABRIA.PC_POTRERO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_POTRERO.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_ESTABLO -- ubicacion CUBIERTA (sala de ordeno, maternidad, cuarentena,
-- corral de manejo, engorde bajo techo, etc.), a diferencia de PC_POTRERO
-- que es pastoreo a cielo abierto (medido en hectareas). Un animal puede
-- estar en un potrero Y en un establo a la vez (ej. pastando de dia,
-- establo de ordeno en la manana) -- son dos dimensiones de ubicacion
-- independientes, no excluyentes.
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ESTABLO
(
  reckey         NUMBER(10)    not null,
  cod_origen     CHAR(2)       not null,
  cod_establo    CHAR(6)       not null,
  nom_establo    VARCHAR2(200) not null,
  flag_tipo      CHAR(1)       default 'G' not null,
  capacidad_cab  NUMBER(6),
  flag_estado    CHAR(1)       default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_ESTABLO add constraint PK_PC_ESTABLO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ESTABLO add constraint UQ_PC_ESTABLO unique (cod_origen, cod_establo) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ESTABLO add constraint CK_PC_ESTABLO_TIPO check (flag_tipo in ('O','M','C','G','E','I'));
alter table CANTABRIA.PC_ESTABLO add constraint FK_PC_ESTABLO_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);

comment on table CANTABRIA.PC_ESTABLO is 'Pecuario - Establos/corrales (ubicacion cubierta) por fundo';
comment on column CANTABRIA.PC_ESTABLO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_ESTABLO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_ESTABLO.cod_establo is 'codigo de establo (unique junto a cod_origen, no PK)';
comment on column CANTABRIA.PC_ESTABLO.nom_establo is 'nombre del establo';
comment on column CANTABRIA.PC_ESTABLO.flag_tipo is 'O=Ordeno, M=Maternidad, C=Cuarentena, G=Corral de manejo (General), E=Engorde, I=Incubadora (avicola)';
comment on column CANTABRIA.PC_ESTABLO.capacidad_cab is 'capacidad de carga en numero de cabezas';
comment on column CANTABRIA.PC_ESTABLO.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_ESTABLO start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_ESTABLO
before insert on CANTABRIA.PC_ESTABLO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_ESTABLO.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_CATEGORIA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CATEGORIA
(
  reckey          NUMBER(10)    not null,
  cod_categoria   CHAR(3)       not null,
  nom_categoria   VARCHAR2(200)  not null,
  flag_sexo       CHAR(1),
  edad_min_meses  NUMBER(4),
  edad_max_meses  NUMBER(4),
  flag_estado     CHAR(1)       default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_CATEGORIA add constraint PK_PC_CATEGORIA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CATEGORIA add constraint UQ_PC_CATEGORIA_COD unique (cod_categoria) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CATEGORIA add constraint CK_PC_CATEGORIA_SEXO check (flag_sexo in ('M','H') or flag_sexo is null);

comment on table CANTABRIA.PC_CATEGORIA is 'Pecuario - Catalogo de categorias/etapas del animal';
comment on column CANTABRIA.PC_CATEGORIA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_CATEGORIA.cod_categoria is 'codigo de categoria (TER, VAQ, NOV, VPR, VSC, VDE, TOR, TDE) -- unique, no PK';
comment on column CANTABRIA.PC_CATEGORIA.nom_categoria is 'nombre de la categoria';
comment on column CANTABRIA.PC_CATEGORIA.flag_sexo is 'M/H/null=ambos';
comment on column CANTABRIA.PC_CATEGORIA.edad_min_meses is 'edad minima en meses';
comment on column CANTABRIA.PC_CATEGORIA.edad_max_meses is 'edad maxima en meses';
comment on column CANTABRIA.PC_CATEGORIA.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_CATEGORIA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_CATEGORIA
before insert on CANTABRIA.PC_CATEGORIA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_CATEGORIA.nextval into :new.reckey from dual;
  end if;
end;
/

-- Datos iniciales sugeridos
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo, edad_min_meses, edad_max_meses) values ('TER','Ternero(a)', null, 0, 3);
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo, edad_min_meses, edad_max_meses) values ('VAQ','Vaquillona de reemplazo','H', 3, 12);
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo, edad_min_meses, edad_max_meses) values ('NOV','Novilla / vaquillona de vientre','H', 12, 24);
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('VPR','Vaca en produccion','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('VSC','Vaca seca','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('VDE','Vaca de descarte','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('TOR','Toro reproductor','M');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('TDE','Toro de descarte','M');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('REP','Reproductora (aves)','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('ENG','Pollo de engorde (aves)', null);
commit;


-- ----------------------------------------------------------------------------
-- PC_SEMENTAL
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_SEMENTAL
(
  reckey          NUMBER(10)    not null,
  cod_semental    CHAR(10)      not null,
  nom_semental    VARCHAR2(200)  not null,
  cod_raza        CHAR(4)       not null,
  proveedor       VARCHAR2(200),
  registro_genet  VARCHAR2(40),
  flag_estado     CHAR(1)       default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_SEMENTAL add constraint PK_PC_SEMENTAL primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_SEMENTAL add constraint UQ_PC_SEMENTAL_COD unique (cod_semental) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_SEMENTAL add constraint FK_PC_SEMENTAL_RAZA foreign key (cod_raza) references CANTABRIA.PC_RAZA(cod_raza);

comment on table CANTABRIA.PC_SEMENTAL is 'Pecuario - Catalogo de sementales/pajillas para inseminacion artificial';
comment on column CANTABRIA.PC_SEMENTAL.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_SEMENTAL.cod_semental is 'codigo del semental/pajilla (unique, no PK)';
comment on column CANTABRIA.PC_SEMENTAL.nom_semental is 'nombre del semental';
comment on column CANTABRIA.PC_SEMENTAL.cod_raza is 'raza del semental';
comment on column CANTABRIA.PC_SEMENTAL.proveedor is 'proveedor / central de inseminacion';
comment on column CANTABRIA.PC_SEMENTAL.registro_genet is 'registro genealogico / codigo de catalogo del proveedor';
comment on column CANTABRIA.PC_SEMENTAL.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_SEMENTAL start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_SEMENTAL
before insert on CANTABRIA.PC_SEMENTAL
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_SEMENTAL.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_PRODUCTO_SANITARIO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_PRODUCTO_SANITARIO
(
  reckey          NUMBER(10)     not null,
  cod_prod_san    CHAR(10)       not null,
  nom_producto    VARCHAR2(200)  not null,
  flag_tipo       CHAR(1)        not null,
  cod_art         CHAR(12),
  dias_refuerzo   NUMBER(4),
  periodo_retiro  NUMBER(3),
  flag_estado     CHAR(1)        default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_PRODUCTO_SANITARIO add constraint PK_PC_PRODUCTO_SANITARIO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_PRODUCTO_SANITARIO add constraint UQ_PC_PRODSAN_COD unique (cod_prod_san) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_PRODUCTO_SANITARIO add constraint CK_PC_PRODSAN_TIPO check (flag_tipo in ('V','D','M','S'));
alter table CANTABRIA.PC_PRODUCTO_SANITARIO add constraint FK_PC_PRODSAN_ART foreign key (cod_art) references CANTABRIA.ARTICULO(cod_art);

comment on table CANTABRIA.PC_PRODUCTO_SANITARIO is 'Pecuario - Catalogo de vacunas, medicamentos e insumos veterinarios';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.cod_prod_san is 'codigo de producto sanitario (unique, no PK)';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.nom_producto is 'nombre del producto';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.flag_tipo is 'V=Vacuna, D=Desparasitante, M=Medicamento, S=Suplemento';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.cod_art is 'FK a ARTICULO (Almacen) -- articulo real de stock que se descuenta al consumir este producto via una OT';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.dias_refuerzo is 'dias hasta la proxima dosis de refuerzo (si aplica)';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.periodo_retiro is 'dias de retiro de leche/carne tras aplicar';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_PRODUCTO_SANIT start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_PRODUCTO_SANIT
before insert on CANTABRIA.PC_PRODUCTO_SANITARIO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_PRODUCTO_SANIT.nextval into :new.reckey from dual;
  end if;
end;
/

-- Datos iniciales sugeridos (calendario sanitario base para bovinos en Peru, referencia SENASA)
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('VAC001','Vacuna Aftosa','V',180,21);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('VAC002','Vacuna Brucelosis (Cepa 19)','V',null,0);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('VAC003','Vacuna Carbunco sintomatico / Clostridiales','V',365,21);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('VAC004','Vacuna Rabia bovina','V',365,21);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('VAC005','Vacuna IBR-BVD','V',180,0);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('VAC006','Vacuna Leptospirosis','V',180,0);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('DES001','Desparasitante interno (Ivermectina)','D',90,35);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, dias_refuerzo, periodo_retiro) values ('DES002','Desparasitante externo (bano garrapaticida)','D',30,0);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, periodo_retiro) values ('MED001','Antibiotico intramamario (mastitis)','M',5);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, periodo_retiro) values ('MED002','Antiinflamatorio','M',3);
insert into CANTABRIA.PC_PRODUCTO_SANITARIO (cod_prod_san, nom_producto, flag_tipo, periodo_retiro) values ('SUP001','Sales minerales','S',0);
commit;


-- ----------------------------------------------------------------------------
-- PC_ENFERMEDAD
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ENFERMEDAD
(
  reckey             NUMBER(10)     not null,
  cod_enfermedad     CHAR(6)        not null,
  nom_enfermedad     VARCHAR2(200)  not null,
  flag_reproductiva  CHAR(1)        default '0',
  flag_estado        CHAR(1)        default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_ENFERMEDAD add constraint PK_PC_ENFERMEDAD primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ENFERMEDAD add constraint UQ_PC_ENFERMEDAD_COD unique (cod_enfermedad) using index tablespace CANTABRIA;

comment on table CANTABRIA.PC_ENFERMEDAD is 'Pecuario - Catalogo de enfermedades/diagnosticos';
comment on column CANTABRIA.PC_ENFERMEDAD.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_ENFERMEDAD.cod_enfermedad is 'codigo de enfermedad (unique, no PK)';
comment on column CANTABRIA.PC_ENFERMEDAD.nom_enfermedad is 'nombre de la enfermedad';
comment on column CANTABRIA.PC_ENFERMEDAD.flag_reproductiva is 'afecta el ciclo reproductivo (1=si)';
comment on column CANTABRIA.PC_ENFERMEDAD.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_ENFERMEDAD start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_ENFERMEDAD
before insert on CANTABRIA.PC_ENFERMEDAD
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_ENFERMEDAD.nextval into :new.reckey from dual;
  end if;
end;
/

-- Datos iniciales sugeridos
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('MASTI1','Mastitis','0');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('HIPOC1','Hipocalcemia / fiebre de leche','0');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('CETOS1','Cetosis','0');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('COJER1','Cojera / laminitis','0');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('NEUMO1','Neumonia en terneros','0');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('DIARR1','Diarrea neonatal','0');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('BRUCE1','Brucelosis','1');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('IBRBV1','IBR / BVD','1');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('LEPTO1','Leptospirosis','1');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('METRI1','Metritis','1');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('RETPL1','Retencion de placenta','1');
insert into CANTABRIA.PC_ENFERMEDAD (cod_enfermedad, nom_enfermedad, flag_reproductiva) values ('DISTO1','Distocia','1');
commit;


-- ----------------------------------------------------------------------------
-- PC_DIETA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DIETA
(
  reckey          NUMBER(10)    not null,
  cod_dieta       CHAR(6)       not null,
  nom_dieta       VARCHAR2(200)  not null,
  cod_categoria   CHAR(3)       not null,
  costo_kg_prom   NUMBER(10,4),
  flag_estado     CHAR(1)       default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_DIETA add constraint PK_PC_DIETA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DIETA add constraint UQ_PC_DIETA_COD unique (cod_dieta) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DIETA add constraint FK_PC_DIETA_CATEG foreign key (cod_categoria) references CANTABRIA.PC_CATEGORIA(cod_categoria);

comment on table CANTABRIA.PC_DIETA is 'Pecuario - Catalogo de dietas/raciones por categoria';
comment on column CANTABRIA.PC_DIETA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_DIETA.cod_dieta is 'codigo de dieta (unique, no PK)';
comment on column CANTABRIA.PC_DIETA.nom_dieta is 'nombre de la dieta';
comment on column CANTABRIA.PC_DIETA.cod_categoria is 'categoria de animal a la que aplica';
comment on column CANTABRIA.PC_DIETA.costo_kg_prom is 'costo promedio por kg, para costeo';
comment on column CANTABRIA.PC_DIETA.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_DIETA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_DIETA
before insert on CANTABRIA.PC_DIETA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_DIETA.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_DIETA_COMPONENTE (referencia ARTICULO del modulo Almacen)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DIETA_COMPONENTE
(
  reckey          NUMBER(10)     not null,
  cod_dieta       CHAR(6)        not null,
  item            NUMBER(3)      not null,
  cod_art         CHAR(12)       not null,
  cantidad_kg     NUMBER(8,3)    not null,
  flag_estado     CHAR(1)        default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_DIETA_COMPONENTE add constraint PK_PC_DIETA_COMPONENTE primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DIETA_COMPONENTE add constraint UQ_PC_DIETACOMP unique (cod_dieta, item) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DIETA_COMPONENTE add constraint FK_PC_DIETACOMP_DIETA foreign key (cod_dieta) references CANTABRIA.PC_DIETA(cod_dieta);
alter table CANTABRIA.PC_DIETA_COMPONENTE add constraint FK_PC_DIETACOMP_ART foreign key (cod_art) references CANTABRIA.ARTICULO(cod_art);

comment on table CANTABRIA.PC_DIETA_COMPONENTE is 'Pecuario - Detalle de insumos que componen cada dieta';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.cod_dieta is 'dieta a la que pertenece';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.item is 'item correlativo (unique junto a cod_dieta, no PK)';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.cod_art is 'articulo de almacen (forraje/concentrado/mineral)';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.cantidad_kg is 'cantidad en kg por animal/dia';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_DIETACOMP start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_DIETACOMP
before insert on CANTABRIA.PC_DIETA_COMPONENTE
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_DIETACOMP.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 1b) RECETA DE CONCENTRADO (nuevo) -- ver seccion 6 del .md: la fabricacion
-- del concentrado es OTRA OT (distinta de la OT que alimenta a los animales),
-- que consume materia prima y produce "concentrado" (un TIPO_PRODUCTO mas,
-- igual mecanismo I09 que la leche) hacia un almacen de concentrado.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_RECETA (cabecera: que producto se fabrica y su rendimiento)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_RECETA
(
  reckey          NUMBER(10)     not null,
  cod_receta      CHAR(6)        not null,
  nom_receta      VARCHAR2(200)   not null,
  cod_producto    CHAR(12)       not null,
  rendimiento_kg  NUMBER(10,3)   not null,
  flag_estado     CHAR(1)        default '1' not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_RECETA add constraint PK_PC_RECETA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_RECETA add constraint UQ_PC_RECETA_COD unique (cod_receta) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_RECETA add constraint FK_PC_RECETA_PRODUCTO foreign key (cod_producto) references CANTABRIA.TIPO_PRODUCTO(cod_prod);

comment on table CANTABRIA.PC_RECETA is 'Pecuario - Receta/formula de fabricacion de concentrado u otro insumo propio';
comment on column CANTABRIA.PC_RECETA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_RECETA.cod_receta is 'codigo de receta (unique, no PK)';
comment on column CANTABRIA.PC_RECETA.nom_receta is 'nombre de la receta (ej. Concentrado vacas en produccion)';
comment on column CANTABRIA.PC_RECETA.cod_producto is 'FK a TIPO_PRODUCTO -- producto terminado que se fabrica (el concentrado)';
comment on column CANTABRIA.PC_RECETA.rendimiento_kg is 'kg de producto terminado que rinde un lote de esta receta';
comment on column CANTABRIA.PC_RECETA.flag_estado is 'flag_estado';

create sequence CANTABRIA.SEQ_PC_RECETA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_RECETA
before insert on CANTABRIA.PC_RECETA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_RECETA.nextval into :new.reckey from dual;
  end if;
end;
/

-- ----------------------------------------------------------------------------
-- PC_RECETA_DET (materia prima que consume un lote de la receta)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_RECETA_DET
(
  reckey          NUMBER(10)     not null,
  cod_receta      CHAR(6)        not null,
  item            NUMBER(3)      not null,
  cod_art         CHAR(12)       not null,
  cantidad_kg     NUMBER(10,3)   not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_RECETA_DET add constraint PK_PC_RECETA_DET primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_RECETA_DET add constraint UQ_PC_RECETADET unique (cod_receta, item) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_RECETA_DET add constraint FK_PC_RECETADET_RECETA foreign key (cod_receta) references CANTABRIA.PC_RECETA(cod_receta);
alter table CANTABRIA.PC_RECETA_DET add constraint FK_PC_RECETADET_ART foreign key (cod_art) references CANTABRIA.ARTICULO(cod_art);

comment on table CANTABRIA.PC_RECETA_DET is 'Pecuario - Materia prima (por kg) que consume un lote de la receta';
comment on column CANTABRIA.PC_RECETA_DET.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_RECETA_DET.cod_receta is 'receta a la que pertenece';
comment on column CANTABRIA.PC_RECETA_DET.item is 'item correlativo (unique junto a cod_receta, no PK)';
comment on column CANTABRIA.PC_RECETA_DET.cod_art is 'FK a ARTICULO -- materia prima consumida';
comment on column CANTABRIA.PC_RECETA_DET.cantidad_kg is 'cantidad de materia prima, en kg, por lote de rendimiento_kg';

create sequence CANTABRIA.SEQ_PC_RECETADET start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_RECETADET
before insert on CANTABRIA.PC_RECETA_DET
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_RECETADET.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 1c) LOTE (nuevo -- agrupacion/cohorte de cabezas, validado contra el
-- ERP AGRI: "Control de cabezas" + "Control de lotes" son dos vistas del
-- MISMO modelo, no dos ramas paralelas. Cada PC_ANIMAL puede pertenecer a
-- un PC_LOTE (nullable); PC_LOTE lleva ademas cantidad agregada de cabezas,
-- para especies/operaciones donde no se registra cada cabeza individual
-- (ej. engorde masivo, aves) -- ver seccion 18 del .md.
-- ============================================================================
create table CANTABRIA.PC_LOTE
(
  reckey                  NUMBER(10)    not null,
  cod_origen              CHAR(2)       not null,
  cod_lote                CHAR(6)       not null,
  nom_lote                VARCHAR2(200) not null,
  cod_potrero             CHAR(6),
  cod_categoria           CHAR(3),
  fec_formacion           DATE          not null,
  fec_cierre              DATE,
  cantidad_cabezas_inicial  NUMBER(6),
  cantidad_cabezas_actual   NUMBER(6),
  flag_estado             CHAR(1)       default '1' not null,
  cod_usr                 CHAR(6),
  fec_registro            DATE          default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_LOTE add constraint PK_PC_LOTE primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LOTE add constraint UQ_PC_LOTE unique (cod_origen, cod_lote) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LOTE add constraint FK_PC_LOTE_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_LOTE add constraint FK_PC_LOTE_POTRERO foreign key (cod_origen, cod_potrero) references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);
alter table CANTABRIA.PC_LOTE add constraint FK_PC_LOTE_CATEG foreign key (cod_categoria) references CANTABRIA.PC_CATEGORIA(cod_categoria);

comment on table CANTABRIA.PC_LOTE is 'Pecuario - Lote/cohorte de animales (agrupacion de manejo). Sirve tanto para agrupar cabezas individuales (PC_ANIMAL.cod_lote) como, en especies/operaciones sin registro individual, para llevar el conteo agregado directamente aqui';
comment on column CANTABRIA.PC_LOTE.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_LOTE.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_LOTE.cod_lote is 'codigo de lote (unique junto a cod_origen, no PK)';
comment on column CANTABRIA.PC_LOTE.nom_lote is 'nombre/descripcion del lote';
comment on column CANTABRIA.PC_LOTE.cod_potrero is 'ubicacion actual del lote';
comment on column CANTABRIA.PC_LOTE.cod_categoria is 'categoria homogenea del lote, si aplica';
comment on column CANTABRIA.PC_LOTE.fec_formacion is 'fecha en que se formo/inicio el lote';
comment on column CANTABRIA.PC_LOTE.fec_cierre is 'fecha de cierre/disolucion del lote';
comment on column CANTABRIA.PC_LOTE.cantidad_cabezas_inicial is 'cabezas al formar el lote (para especies sin registro individual)';
comment on column CANTABRIA.PC_LOTE.cantidad_cabezas_actual is 'cabezas vivas actuales (se descuenta por mortalidad/baja)';
comment on column CANTABRIA.PC_LOTE.flag_estado is '1=Activo, 0=Cerrado';
comment on column CANTABRIA.PC_LOTE.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_LOTE.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_LOTE start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_LOTE
before insert on CANTABRIA.PC_LOTE
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_LOTE.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 1d) EXTENSION AVICOLA (nuevo) -- ciclo reproductivo de especies oviparas
-- (reproductoras -> incubacion -> eclosion -> engorde), investigado contra
-- Nisira ERP (modulo Avicola, unico precedente real en el mercado peruano
-- para produccion animal -- ver seccion 18 del .md). Reutiliza PC_LOTE como
-- unidad de manejo (una "reproductora" o una "parvada de engorde" es un
-- PC_LOTE), y agrega solo lo que el ciclo por huevo necesita y que PC_LOTE
-- por si solo no cubre: postura, incubacion/eclosion y mortalidad agregada.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_POSTURA -- registro diario de produccion de huevos de un lote de
-- reproductoras (mismo patron que PC_ORDENO para leche, pero por lote)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_POSTURA
(
  reckey            NUMBER(10) not null,
  cod_origen        CHAR(2)    not null,
  cod_lote          CHAR(6)    not null,
  fec_postura       DATE       not null,
  cantidad_huevos   NUMBER(8)  not null,
  cantidad_descarte NUMBER(8)  default 0,
  cod_usr           CHAR(6),
  fec_registro      DATE       default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_POSTURA add constraint PK_PC_POSTURA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_POSTURA add constraint UQ_PC_POSTURA unique (cod_origen, cod_lote, fec_postura) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_POSTURA add constraint FK_PC_POSTURA_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_POSTURA add constraint FK_PC_POSTURA_LOTE foreign key (cod_origen, cod_lote) references CANTABRIA.PC_LOTE(cod_origen, cod_lote);

comment on table CANTABRIA.PC_POSTURA is 'Pecuario (avicola) - Produccion diaria de huevos de un lote de reproductoras';
comment on column CANTABRIA.PC_POSTURA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_POSTURA.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_POSTURA.cod_lote is 'FK a PC_LOTE -- lote de reproductoras que postura';
comment on column CANTABRIA.PC_POSTURA.fec_postura is 'fecha de la postura';
comment on column CANTABRIA.PC_POSTURA.cantidad_huevos is 'huevos recolectados ese dia';
comment on column CANTABRIA.PC_POSTURA.cantidad_descarte is 'huevos descartados (rotos, sucios, deformes) no aptos para incubar';
comment on column CANTABRIA.PC_POSTURA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_POSTURA.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_POSTURA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_POSTURA
before insert on CANTABRIA.PC_POSTURA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_POSTURA.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_INCUBACION -- carga de huevos a la incubadora y su resultado de
-- eclosion. Trazabilidad completa: de que lote de reproductoras vinieron
-- los huevos (cod_lote_origen) y que lote de engorde se formo con los
-- pollitos nacidos (cod_lote_destino, se completa al eclosionar).
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_INCUBACION
(
  reckey                  NUMBER(10) not null,
  cod_origen              CHAR(2)    not null,
  cod_lote_origen         CHAR(6)    not null,
  cod_establo             CHAR(6),
  fec_carga               DATE       not null,
  cantidad_huevos_cargados NUMBER(8) not null,
  fec_eclosion_prevista   DATE,
  fec_eclosion_real       DATE,
  cantidad_nacidos        NUMBER(8),
  cantidad_mermas         NUMBER(8),
  cod_lote_destino        CHAR(6),
  flag_estado             CHAR(1)    default '1' not null,
  cod_usr                 CHAR(6),
  fec_registro            DATE       default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_INCUBACION add constraint PK_PC_INCUBACION primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_INCUBACION add constraint CK_PC_INCUBACION_ESTADO check (flag_estado in ('0','1','2'));
alter table CANTABRIA.PC_INCUBACION add constraint FK_PC_INCUBACION_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_INCUBACION add constraint FK_PC_INCUBACION_LOTE_ORIG foreign key (cod_origen, cod_lote_origen) references CANTABRIA.PC_LOTE(cod_origen, cod_lote);
alter table CANTABRIA.PC_INCUBACION add constraint FK_PC_INCUBACION_LOTE_DEST foreign key (cod_origen, cod_lote_destino) references CANTABRIA.PC_LOTE(cod_origen, cod_lote);
alter table CANTABRIA.PC_INCUBACION add constraint FK_PC_INCUBACION_ESTABLO foreign key (cod_origen, cod_establo) references CANTABRIA.PC_ESTABLO(cod_origen, cod_establo);

comment on table CANTABRIA.PC_INCUBACION is 'Pecuario (avicola) - Carga de incubadora y resultado de eclosion, con trazabilidad lote-reproductoras -> lote-engorde';
comment on column CANTABRIA.PC_INCUBACION.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_INCUBACION.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_INCUBACION.cod_lote_origen is 'FK a PC_LOTE -- lote de reproductoras del que vinieron los huevos (trazabilidad)';
comment on column CANTABRIA.PC_INCUBACION.cod_establo is 'FK a PC_ESTABLO -- sala/nave de incubacion (flag_tipo=I)';
comment on column CANTABRIA.PC_INCUBACION.fec_carga is 'fecha de carga de la incubadora';
comment on column CANTABRIA.PC_INCUBACION.cantidad_huevos_cargados is 'huevos aptos cargados a la incubadora';
comment on column CANTABRIA.PC_INCUBACION.fec_eclosion_prevista is 'fecha esperada de nacimiento = fec_carga + TG_ESPECIES.periodo_incubacion_dias de la especie del lote (via PC_LOTE.cod_categoria/PC_ANIMAL o directamente conocido por la especie del lote, ej. 21 dias en aves)';
comment on column CANTABRIA.PC_INCUBACION.fec_eclosion_real is 'fecha real de nacimiento';
comment on column CANTABRIA.PC_INCUBACION.cantidad_nacidos is 'pollitos/crias nacidas -- junto a cantidad_huevos_cargados da el % de eclosion';
comment on column CANTABRIA.PC_INCUBACION.cantidad_mermas is 'huevos no eclosionados (infertiles, muerte embrionaria)';
comment on column CANTABRIA.PC_INCUBACION.cod_lote_destino is 'FK a PC_LOTE -- lote de engorde formado con los nacidos (se completa al registrar la eclosion)';
comment on column CANTABRIA.PC_INCUBACION.flag_estado is '0=Anulada, 1=En incubacion, 2=Eclosionada';
comment on column CANTABRIA.PC_INCUBACION.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_INCUBACION.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_INCUBACION start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_INCUBACION
before insert on CANTABRIA.PC_INCUBACION
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_INCUBACION.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_LOTE_MORTALIDAD -- mortalidad agregada de un lote (aves, engorde
-- masivo). Analogo a PC_BAJA pero a nivel de lote, no de animal individual
-- (no existen filas PC_ANIMAL para cada ave). Un trigger descuenta
-- automaticamente PC_LOTE.cantidad_cabezas_actual.
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LOTE_MORTALIDAD
(
  reckey            NUMBER(10) not null,
  cod_origen        CHAR(2)    not null,
  cod_lote          CHAR(6)    not null,
  fec_evento        DATE       not null,
  cantidad_muertes  NUMBER(6)  not null,
  motivo            VARCHAR2(200),
  cod_usr           CHAR(6),
  fec_registro      DATE       default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_LOTE_MORTALIDAD add constraint PK_PC_LOTE_MORTALIDAD primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LOTE_MORTALIDAD add constraint FK_PC_LOTEMORT_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_LOTE_MORTALIDAD add constraint FK_PC_LOTEMORT_LOTE foreign key (cod_origen, cod_lote) references CANTABRIA.PC_LOTE(cod_origen, cod_lote);

comment on table CANTABRIA.PC_LOTE_MORTALIDAD is 'Pecuario (avicola/engorde masivo) - Mortalidad agregada de un lote, sin registro individual por cabeza';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.cod_lote is 'FK a PC_LOTE';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.fec_evento is 'fecha del registro de mortalidad';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.cantidad_muertes is 'cantidad de cabezas muertas en el periodo';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.motivo is 'causa de la mortalidad, si se conoce';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_LOTE_MORTALIDAD.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_LOTEMORT start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_LOTEMORT
before insert on CANTABRIA.PC_LOTE_MORTALIDAD
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_LOTEMORT.nextval into :new.reckey from dual;
  end if;
end;
/

-- Trigger: al registrar mortalidad, descontar automaticamente las cabezas
-- vivas actuales del lote (mismo patron que TRG_PC_BAJA_AI para PC_ANIMAL)
create or replace trigger CANTABRIA.TRG_PC_LOTEMORT_AI
after insert on CANTABRIA.PC_LOTE_MORTALIDAD
for each row
begin
  update CANTABRIA.PC_LOTE
     set cantidad_cabezas_actual = nvl(cantidad_cabezas_actual,0) - :new.cantidad_muertes
   where cod_origen = :new.cod_origen
     and cod_lote = :new.cod_lote;
end;
/


-- ============================================================================
-- 2) MAESTRO DE ANIMAL (tabla-DOCUMENTO: PK = cod_animal, una sola columna)
-- ============================================================================
create table CANTABRIA.PC_ANIMAL
(
  cod_animal          CHAR(10)      not null,
  cod_origen          CHAR(2)       not null,
  cod_interno         VARCHAR2(20),
  nom_animal          VARCHAR2(200),
  cod_raza            CHAR(4)       not null,
  flag_sexo           CHAR(1)       not null,
  fec_nacimiento      DATE          not null,
  cod_animal_padre    CHAR(10),
  cod_animal_madre    CHAR(10),
  cod_semental_padre  CHAR(10),
  color               VARCHAR2(40),
  cod_categoria       CHAR(3)       not null,
  cod_potrero         CHAR(6)       not null,
  cod_establo         CHAR(6),
  cod_lote            CHAR(6),
  flag_estado_repro   CHAR(1)       default '0',
  peso_nacimiento     NUMBER(6,2),
  peso_actual         NUMBER(6,2),
  fec_ult_pesaje      DATE,
  cod_procedencia     CHAR(1)       default 'P',
  fec_ingreso         DATE          default sysdate,
  precio_compra       NUMBER(12,2),
  flag_estado         CHAR(1)       default '1' not null,
  cod_usr             CHAR(6),
  fec_registro        DATE          default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_ANIMAL add constraint PK_PC_ANIMAL primary key (cod_animal) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ANIMAL add constraint CK_PC_ANIMAL_SEXO check (flag_sexo in ('M','H'));
alter table CANTABRIA.PC_ANIMAL add constraint CK_PC_ANIMAL_PROCED check (cod_procedencia in ('P','C'));
alter table CANTABRIA.PC_ANIMAL add constraint CK_PC_ANIMAL_EST_REPRO check (flag_estado_repro in ('0','1','2','3'));
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_RAZA foreign key (cod_raza) references CANTABRIA.PC_RAZA(cod_raza);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_CATEG foreign key (cod_categoria) references CANTABRIA.PC_CATEGORIA(cod_categoria);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_POTRERO foreign key (cod_origen, cod_potrero) references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_LOTE foreign key (cod_origen, cod_lote) references CANTABRIA.PC_LOTE(cod_origen, cod_lote);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_ESTABLO foreign key (cod_origen, cod_establo) references CANTABRIA.PC_ESTABLO(cod_origen, cod_establo);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_SEMENTAL foreign key (cod_semental_padre) references CANTABRIA.PC_SEMENTAL(cod_semental);
-- Auto-referencias (genealogia): padre y madre son animales del mismo hato
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_PADRE foreign key (cod_animal_padre) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_ANIMAL add constraint FK_PC_ANIMAL_MADRE foreign key (cod_animal_madre) references CANTABRIA.PC_ANIMAL(cod_animal);

comment on table CANTABRIA.PC_ANIMAL is 'Pecuario - Maestro de ganado (animal individual, de cualquier especie)';
comment on column CANTABRIA.PC_ANIMAL.cod_animal is 'PK -- numero de documento del animal: cod_origen(2) + correlativo(8), generado por trigger via NUM_TABLAS (ej. SU00000001). Es UNA SOLA COLUMNA; el origen ya queda embebido';
comment on column CANTABRIA.PC_ANIMAL.cod_origen is 'FK a ORIGEN -- fundo/sucursal (tambien va embebido en cod_animal)';
comment on column CANTABRIA.PC_ANIMAL.cod_interno is 'codigo interno/arete fisico que usa la empresa (libre, distinto del documento generado por el sistema)';
comment on column CANTABRIA.PC_ANIMAL.nom_animal is 'apodo, opcional';
comment on column CANTABRIA.PC_ANIMAL.cod_raza is 'raza del animal';
comment on column CANTABRIA.PC_ANIMAL.flag_sexo is 'M=Macho, H=Hembra';
comment on column CANTABRIA.PC_ANIMAL.fec_nacimiento is 'fecha de nacimiento';
comment on column CANTABRIA.PC_ANIMAL.cod_animal_padre is 'FK genealogia (auto-referencia) - padre, si es del propio hato';
comment on column CANTABRIA.PC_ANIMAL.cod_animal_madre is 'FK genealogia (auto-referencia) - madre, si es del propio hato';
comment on column CANTABRIA.PC_ANIMAL.cod_semental_padre is 'FK a PC_SEMENTAL si el padre fue por inseminacion artificial';
comment on column CANTABRIA.PC_ANIMAL.color is 'color/marcas distintivas';
comment on column CANTABRIA.PC_ANIMAL.cod_categoria is 'categoria/etapa actual (se recalcula por edad/estado)';
comment on column CANTABRIA.PC_ANIMAL.cod_potrero is 'ubicacion actual (potrero)';
comment on column CANTABRIA.PC_ANIMAL.cod_establo is 'FK opcional a PC_ESTABLO -- ubicacion cubierta actual (sala de ordeno, maternidad, cuarentena, etc.), independiente del potrero; historial completo en PC_MOVIMIENTO_ESTABLO';
comment on column CANTABRIA.PC_ANIMAL.cod_lote is 'FK opcional a PC_LOTE -- lote/cohorte de manejo al que pertenece esta cabeza (validado contra AGRI: cabezas y lotes son el mismo modelo, no ramas paralelas)';
comment on column CANTABRIA.PC_ANIMAL.flag_estado_repro is '0=vacia, 1=servida, 2=prenada confirmada, 3=recien parida';
comment on column CANTABRIA.PC_ANIMAL.peso_nacimiento is 'peso al nacer en kg';
comment on column CANTABRIA.PC_ANIMAL.peso_actual is 'ultimo peso registrado en kg';
comment on column CANTABRIA.PC_ANIMAL.fec_ult_pesaje is 'fecha del ultimo pesaje';
comment on column CANTABRIA.PC_ANIMAL.cod_procedencia is 'P=Nacido en el predio, C=Comprado';
comment on column CANTABRIA.PC_ANIMAL.fec_ingreso is 'fecha de alta al hato (nacimiento o compra)';
comment on column CANTABRIA.PC_ANIMAL.precio_compra is 'precio de compra si aplica, para costeo/activo biologico';
comment on column CANTABRIA.PC_ANIMAL.flag_estado is '1=activo en el hato, 0=de baja (ver PC_BAJA)';
comment on column CANTABRIA.PC_ANIMAL.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_ANIMAL.fec_registro is 'fecha de registro en el sistema';

-- Trigger de numeracion de documento (mismo patron que TB_ASISTENCIA_HT580,
-- pero usando la tabla generica NUM_TABLAS en vez de una tabla dedicada)
create or replace trigger CANTABRIA.TIB_PC_ANIMAL
before insert on CANTABRIA.PC_ANIMAL
for each row
declare
  ln_ult_nro  CANTABRIA.NUM_TABLAS.ult_nro%type;
  ln_count    number;
begin
  if :new.cod_animal is null then
    select count(*) into ln_count from CANTABRIA.NUM_TABLAS
     where tabla = 'PC_ANIMAL' and origen = :new.cod_origen;
    if ln_count = 0 then
      insert into CANTABRIA.NUM_TABLAS(tabla, origen, ult_nro) values ('PC_ANIMAL', :new.cod_origen, 1);
    end if;
    select ult_nro into ln_ult_nro from CANTABRIA.NUM_TABLAS
     where tabla = 'PC_ANIMAL' and origen = :new.cod_origen for update;
    :new.cod_animal := trim(:new.cod_origen) || lpad(to_char(ln_ult_nro), 8, '0');
    update CANTABRIA.NUM_TABLAS set ult_nro = ln_ult_nro + 1
     where tabla = 'PC_ANIMAL' and origen = :new.cod_origen;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_OT_ANIMAL -- vincula una Orden de Trabajo (ORDEN_TRABAJO, tabla generica
-- ya existente y compartida por todo el sistema) con el/los animal(es) que
-- cubre. Es la pieza que permite que TODO el historial de consumibles
-- (alimentacion, medicinas) de un animal se pueda reconstruir uniendo esta
-- tabla -> ORDEN_TRABAJO -> OPERACIONES -> ARTICULO_MOV (movimiento real de
-- Almacen), en vez de duplicar cantidades en tablas propias de Pecuario.
-- Una "OT Pecuaria" es, simplemente, una fila de ORDEN_TRABAJO con
-- ot_adm = 'PECU' (mismo patron que usa Campo con ot_adm = 'CAMPO'), y es
-- POR EVENTO/PERIODO operativo (ej. una semana de alimentacion, una campana
-- de vacunacion) -- NUNCA una OT de por vida del animal ni por etapa, porque
-- ORDEN_TRABAJO tiene fec_inicio/fecha_fin_estimada/costo_estimado/
-- costo_ejecutado: es una unidad de trabajo acotada y cerrable en todo el
-- ERP, no una relacion que dura anos. Por eso esta tabla es muchos-a-muchos:
-- una OT cubre varios animales, y un animal pasa por muchas OTs en su vida.
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_OT_ANIMAL
(
  reckey        NUMBER(10)  not null,
  nro_orden     CHAR(10)    not null,
  cod_origen    CHAR(2)     not null,
  cod_animal    CHAR(10)    not null,
  cod_usr       CHAR(6),
  fec_registro  DATE        default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_OT_ANIMAL add constraint PK_PC_OT_ANIMAL primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_OT_ANIMAL add constraint UQ_PC_OTANIMAL unique (nro_orden, cod_animal) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_OT_ANIMAL add constraint FK_PC_OTANIMAL_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_OT_ANIMAL add constraint FK_PC_OTANIMAL_OT foreign key (nro_orden) references CANTABRIA.ORDEN_TRABAJO(nro_orden);
alter table CANTABRIA.PC_OT_ANIMAL add constraint FK_PC_OTANIMAL_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);

comment on table CANTABRIA.PC_OT_ANIMAL is 'Pecuario - Vinculo entre una Orden de Trabajo (OT Pecuaria, ot_adm=PECU en ORDEN_TRABAJO) y los animales que cubre';
comment on column CANTABRIA.PC_OT_ANIMAL.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_OT_ANIMAL.nro_orden is 'FK a ORDEN_TRABAJO';
comment on column CANTABRIA.PC_OT_ANIMAL.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_OT_ANIMAL.cod_animal is 'FK a PC_ANIMAL, animal cubierto por esta OT';
comment on column CANTABRIA.PC_OT_ANIMAL.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_OT_ANIMAL.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_OT_ANIMAL start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_OT_ANIMAL
before insert on CANTABRIA.PC_OT_ANIMAL
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_OT_ANIMAL.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 3) REPRODUCCION
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_CELO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CELO
(
  reckey            NUMBER(10) not null,
  cod_origen        CHAR(2)   not null,
  cod_animal        CHAR(10)  not null,
  fec_celo          DATE      not null,
  hora_deteccion    DATE,
  metodo_deteccion  CHAR(1)   default 'V',
  flag_servido      CHAR(1)   default '0',
  cod_usr           CHAR(6),
  fec_registro      DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_CELO add constraint PK_PC_CELO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CELO add constraint UQ_PC_CELO unique (cod_animal, fec_celo) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CELO add constraint CK_PC_CELO_METODO check (metodo_deteccion in ('V','P','H'));
alter table CANTABRIA.PC_CELO add constraint FK_PC_CELO_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_CELO add constraint FK_PC_CELO_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);

comment on table CANTABRIA.PC_CELO is 'Pecuario - Registro de detecciones de celo';
comment on column CANTABRIA.PC_CELO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_CELO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_CELO.cod_animal is 'animal (hembra) en celo';
comment on column CANTABRIA.PC_CELO.fec_celo is 'fecha de deteccion del celo';
comment on column CANTABRIA.PC_CELO.hora_deteccion is 'hora exacta de deteccion';
comment on column CANTABRIA.PC_CELO.metodo_deteccion is 'V=Visual, P=Podometro/collar, H=Hormonal';
comment on column CANTABRIA.PC_CELO.flag_servido is '1 si este celo derivo en un servicio';
comment on column CANTABRIA.PC_CELO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_CELO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_CELO start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_CELO
before insert on CANTABRIA.PC_CELO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_CELO.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_SERVICIO (tabla-DOCUMENTO: PK = nro_servicio, una sola columna)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_SERVICIO
(
  nro_servicio        CHAR(10)  not null,
  cod_origen          CHAR(2)   not null,
  cod_animal          CHAR(10)  not null,
  fec_servicio        DATE      not null,
  flag_tipo_servicio  CHAR(1)   not null,
  cod_animal_toro     CHAR(10),
  cod_semental        CHAR(10),
  cod_tecnico         CHAR(8),
  fec_prob_parto      DATE,
  flag_estado         CHAR(1)   default '1' not null,
  cod_usr             CHAR(6),
  fec_registro        DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_SERVICIO add constraint PK_PC_SERVICIO primary key (nro_servicio) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_SERVICIO add constraint CK_PC_SERVICIO_TIPO check (flag_tipo_servicio in ('N','I'));
alter table CANTABRIA.PC_SERVICIO add constraint FK_PC_SERVICIO_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_SERVICIO add constraint FK_PC_SERVICIO_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_SERVICIO add constraint FK_PC_SERVICIO_TORO foreign key (cod_animal_toro) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_SERVICIO add constraint FK_PC_SERVICIO_SEMENTAL foreign key (cod_semental) references CANTABRIA.PC_SEMENTAL(cod_semental);
alter table CANTABRIA.PC_SERVICIO add constraint FK_PC_SERVICIO_TECNICO foreign key (cod_tecnico) references CANTABRIA.PROVEEDOR(proveedor);

comment on table CANTABRIA.PC_SERVICIO is 'Pecuario - Registro de servicio (monta natural o inseminacion artificial). Es un HISTORIAL: un mismo animal tiene tantas filas como servicios reciba en su vida';
comment on column CANTABRIA.PC_SERVICIO.nro_servicio is 'PK -- numero de documento del servicio: cod_origen(2) + correlativo(8), generado por trigger via NUM_TABLAS (ej. SU00000001). UNA SOLA COLUMNA, el origen ya va embebido';
comment on column CANTABRIA.PC_SERVICIO.cod_origen is 'FK a ORIGEN -- fundo/sucursal (tambien va embebido en nro_servicio)';
comment on column CANTABRIA.PC_SERVICIO.cod_animal is 'FK a PC_ANIMAL -- hembra servida';
comment on column CANTABRIA.PC_SERVICIO.fec_servicio is 'fecha del servicio';
comment on column CANTABRIA.PC_SERVICIO.flag_tipo_servicio is 'N=Monta natural, I=Inseminacion artificial';
comment on column CANTABRIA.PC_SERVICIO.cod_animal_toro is 'toro del propio hato (si monta natural)';
comment on column CANTABRIA.PC_SERVICIO.cod_semental is 'semental/pajilla (si inseminacion artificial)';
comment on column CANTABRIA.PC_SERVICIO.cod_tecnico is 'FK a PROVEEDOR -- responsable de la inseminacion (generalmente externo, no personal de planilla)';
comment on column CANTABRIA.PC_SERVICIO.fec_prob_parto is 'fecha probable de parto = fec_servicio + TG_ESPECIES.periodo_gestacion_dias de la especie del animal (via PC_ANIMAL.cod_raza -> PC_RAZA.cod_especie -> TG_ESPECIES); NO hardcodear 283 dias, ese valor es solo el default bovino';
comment on column CANTABRIA.PC_SERVICIO.flag_estado is '1=vigente/en curso, 0=anulado (repitio celo, no prendio)';
comment on column CANTABRIA.PC_SERVICIO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_SERVICIO.fec_registro is 'fecha de registro en el sistema';

create or replace trigger CANTABRIA.TIB_PC_SERVICIO
before insert on CANTABRIA.PC_SERVICIO
for each row
declare
  ln_ult_nro  CANTABRIA.NUM_TABLAS.ult_nro%type;
  ln_count    number;
begin
  if :new.nro_servicio is null then
    select count(*) into ln_count from CANTABRIA.NUM_TABLAS
     where tabla = 'PC_SERVICIO' and origen = :new.cod_origen;
    if ln_count = 0 then
      insert into CANTABRIA.NUM_TABLAS(tabla, origen, ult_nro) values ('PC_SERVICIO', :new.cod_origen, 1);
    end if;
    select ult_nro into ln_ult_nro from CANTABRIA.NUM_TABLAS
     where tabla = 'PC_SERVICIO' and origen = :new.cod_origen for update;
    :new.nro_servicio := trim(:new.cod_origen) || lpad(to_char(ln_ult_nro), 8, '0');
    update CANTABRIA.NUM_TABLAS set ult_nro = ln_ult_nro + 1
     where tabla = 'PC_SERVICIO' and origen = :new.cod_origen;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_DIAGNOSTICO_PRENEZ
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DIAGNOSTICO_PRENEZ
(
  reckey            NUMBER(10) not null,
  cod_origen        CHAR(2)   not null,
  nro_servicio      CHAR(10)  not null,
  cod_animal        CHAR(10)  not null,
  fec_diagnostico   DATE      not null,
  metodo            CHAR(1)   default 'T',
  resultado         CHAR(1)   not null,
  dias_gestacion    NUMBER(3),
  cod_veterinario   CHAR(8),
  cod_usr           CHAR(6),
  fec_registro      DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint PK_PC_DIAGNOSTICO_PRENEZ primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint UQ_PC_DXPRE unique (nro_servicio, fec_diagnostico) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint CK_PC_DXPRE_METODO check (metodo in ('T','E'));
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint CK_PC_DXPRE_RESULT check (resultado in ('P','V'));
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint FK_PC_DXPRE_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint FK_PC_DXPRE_SERVICIO foreign key (nro_servicio) references CANTABRIA.PC_SERVICIO(nro_servicio);
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint FK_PC_DXPRE_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ add constraint FK_PC_DXPRE_VET foreign key (cod_veterinario) references CANTABRIA.PROVEEDOR(proveedor);

comment on table CANTABRIA.PC_DIAGNOSTICO_PRENEZ is 'Pecuario - Diagnostico de prenez posterior al servicio';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.nro_servicio is 'FK a PC_SERVICIO que se esta confirmando';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_animal is 'FK a PC_ANIMAL (denormalizado desde PC_SERVICIO para consulta directa)';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.fec_diagnostico is 'fecha del diagnostico';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.metodo is 'T=Tacto rectal, E=Ecografia';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.resultado is 'P=Prenada, V=Vacia';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.dias_gestacion is 'dias de gestacion calculados';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_veterinario is 'FK a PROVEEDOR -- veterinario responsable (generalmente externo, no personal de planilla)';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_DXPRE start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_DXPRE
before insert on CANTABRIA.PC_DIAGNOSTICO_PRENEZ
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_DXPRE.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_PARTO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_PARTO
(
  reckey                   NUMBER(10) not null,
  cod_origen               CHAR(2)   not null,
  cod_animal               CHAR(10)  not null,
  fec_parto                DATE      not null,
  nro_servicio             CHAR(10),
  flag_tipo_parto          CHAR(1)   default 'E',
  flag_asistido            CHAR(1)   default '0',
  cod_animal_cria          CHAR(10),
  sexo_cria                CHAR(1),
  peso_cria                NUMBER(6,2),
  flag_cria_viva           CHAR(1)   default '1',
  flag_retencion_placenta  CHAR(1)   default '0',
  observaciones            VARCHAR2(500),
  cod_veterinario          CHAR(8),
  cod_usr                  CHAR(6),
  fec_registro             DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_PARTO add constraint PK_PC_PARTO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_PARTO add constraint UQ_PC_PARTO unique (cod_animal, fec_parto) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_PARTO add constraint CK_PC_PARTO_TIPO check (flag_tipo_parto in ('E','D'));
alter table CANTABRIA.PC_PARTO add constraint FK_PC_PARTO_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_PARTO add constraint FK_PC_PARTO_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_PARTO add constraint FK_PC_PARTO_SERVICIO foreign key (nro_servicio) references CANTABRIA.PC_SERVICIO(nro_servicio);
alter table CANTABRIA.PC_PARTO add constraint FK_PC_PARTO_CRIA foreign key (cod_animal_cria) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_PARTO add constraint FK_PC_PARTO_VET foreign key (cod_veterinario) references CANTABRIA.PROVEEDOR(proveedor);

comment on table CANTABRIA.PC_PARTO is 'Pecuario - Registro de parto';
comment on column CANTABRIA.PC_PARTO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_PARTO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_PARTO.cod_animal is 'animal (madre) que pario';
comment on column CANTABRIA.PC_PARTO.fec_parto is 'fecha del parto';
comment on column CANTABRIA.PC_PARTO.nro_servicio is 'FK a PC_SERVICIO que origino este parto (si se conoce)';
comment on column CANTABRIA.PC_PARTO.flag_tipo_parto is 'E=Eutocico (normal), D=Distocico (con complicaciones)';
comment on column CANTABRIA.PC_PARTO.flag_asistido is 'parto asistido (1=si)';
comment on column CANTABRIA.PC_PARTO.cod_animal_cria is 'FK a PC_ANIMAL - la cria recien nacida';
comment on column CANTABRIA.PC_PARTO.sexo_cria is 'sexo de la cria';
comment on column CANTABRIA.PC_PARTO.peso_cria is 'peso de la cria al nacer en kg';
comment on column CANTABRIA.PC_PARTO.flag_cria_viva is '1=viva, 0=nacio muerta';
comment on column CANTABRIA.PC_PARTO.flag_retencion_placenta is '1=hubo retencion de placenta';
comment on column CANTABRIA.PC_PARTO.observaciones is 'observaciones del parto';
comment on column CANTABRIA.PC_PARTO.cod_veterinario is 'FK a PROVEEDOR -- veterinario responsable (generalmente externo, no personal de planilla)';
comment on column CANTABRIA.PC_PARTO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_PARTO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_PARTO start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_PARTO
before insert on CANTABRIA.PC_PARTO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_PARTO.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 4) PRODUCCION DE LECHE
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_LACTANCIA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LACTANCIA
(
  reckey          NUMBER(10) not null,
  cod_origen      CHAR(2)    not null,
  cod_animal      CHAR(10)   not null,
  nro_lactancia   NUMBER(2)  not null,
  fec_parto       DATE       not null,
  fec_secado      DATE,
  dias_lactancia  NUMBER(4),
  litros_totales  NUMBER(10,2),
  flag_estado     CHAR(1)    default '1' not null,
  cod_usr         CHAR(6),
  fec_registro    DATE       default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_LACTANCIA add constraint PK_PC_LACTANCIA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LACTANCIA add constraint UQ_PC_LACTANCIA unique (cod_animal, nro_lactancia) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LACTANCIA add constraint FK_PC_LACTANCIA_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_LACTANCIA add constraint FK_PC_LACTANCIA_PARTO foreign key (cod_animal, fec_parto) references CANTABRIA.PC_PARTO(cod_animal, fec_parto);

comment on table CANTABRIA.PC_LACTANCIA is 'Pecuario - Periodos de lactancia (uno por parto)';
comment on column CANTABRIA.PC_LACTANCIA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_LACTANCIA.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_LACTANCIA.cod_animal is 'vaca en lactancia';
comment on column CANTABRIA.PC_LACTANCIA.nro_lactancia is 'correlativo de lactancia de esta vaca (1ra, 2da, ...)';
comment on column CANTABRIA.PC_LACTANCIA.fec_parto is 'FK (junto a cod_animal) al parto que inicio esta lactancia';
comment on column CANTABRIA.PC_LACTANCIA.fec_secado is 'fecha de secado (cierre de la lactancia)';
comment on column CANTABRIA.PC_LACTANCIA.dias_lactancia is 'dias de lactancia, calculado al secar';
comment on column CANTABRIA.PC_LACTANCIA.litros_totales is 'litros acumulados, recalculado desde PC_ORDENO';
comment on column CANTABRIA.PC_LACTANCIA.flag_estado is '1=en curso, 0=cerrada (seca)';
comment on column CANTABRIA.PC_LACTANCIA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_LACTANCIA.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_LACTANCIA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_LACTANCIA
before insert on CANTABRIA.PC_LACTANCIA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_LACTANCIA.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_ORDENO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ORDENO
(
  reckey          NUMBER(10) not null,
  cod_origen      CHAR(2)   not null,
  cod_animal      CHAR(10)  not null,
  fec_ordeno      DATE      not null,
  nro_turno       NUMBER(1) not null,
  litros          NUMBER(6,2) not null,
  flag_descarte   CHAR(1)   default '0',
  nro_orden       CHAR(10)  not null,
  cod_almacen     CHAR(6)   not null,
  cod_producto    CHAR(12)  not null,
  cod_usr         CHAR(6),
  fec_registro    DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_ORDENO add constraint PK_PC_ORDENO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ORDENO add constraint UQ_PC_ORDENO unique (cod_animal, fec_ordeno, nro_turno) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ORDENO add constraint CK_PC_ORDENO_TURNO check (nro_turno in (1,2,3));
alter table CANTABRIA.PC_ORDENO add constraint FK_PC_ORDENO_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_ORDENO add constraint FK_PC_ORDENO_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_ORDENO add constraint FK_PC_ORDENO_OT foreign key (nro_orden) references CANTABRIA.ORDEN_TRABAJO(nro_orden);
alter table CANTABRIA.PC_ORDENO add constraint FK_PC_ORDENO_ALMACEN foreign key (cod_almacen) references CANTABRIA.ALMACEN(almacen);
alter table CANTABRIA.PC_ORDENO add constraint FK_PC_ORDENO_PRODUCTO foreign key (cod_producto) references CANTABRIA.TIPO_PRODUCTO(cod_prod);

comment on table CANTABRIA.PC_ORDENO is 'Pecuario - Detalle diario de ordeno';
comment on column CANTABRIA.PC_ORDENO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_ORDENO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_ORDENO.cod_animal is 'vaca ordenada';
comment on column CANTABRIA.PC_ORDENO.fec_ordeno is 'fecha del ordeno';
comment on column CANTABRIA.PC_ORDENO.nro_turno is '1=manana, 2=tarde, 3=noche';
comment on column CANTABRIA.PC_ORDENO.litros is 'litros obtenidos en este ordeno';
comment on column CANTABRIA.PC_ORDENO.flag_descarte is '1 si la leche no se vende (periodo de retiro por medicamento)';
comment on column CANTABRIA.PC_ORDENO.nro_orden is 'FK a ORDEN_TRABAJO -- la misma OT usada para el consumo de alimento de ese potrero/dia; el cierre diario de la OT genera el ingreso real I09 en ARTICULO_MOV';
comment on column CANTABRIA.PC_ORDENO.cod_almacen is 'FK a ALMACEN -- almacen de destino (produccion) donde ingresa la leche';
comment on column CANTABRIA.PC_ORDENO.cod_producto is 'FK a TIPO_PRODUCTO -- producto terminado (ej. Leche cruda)';
comment on column CANTABRIA.PC_ORDENO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_ORDENO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_ORDENO start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_ORDENO
before insert on CANTABRIA.PC_ORDENO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_ORDENO.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_CONTROL_LECHERO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CONTROL_LECHERO
(
  reckey             NUMBER(10) not null,
  cod_origen         CHAR(2)   not null,
  cod_animal         CHAR(10)  not null,
  fec_control        DATE      not null,
  porc_grasa         NUMBER(4,2),
  porc_proteina      NUMBER(4,2),
  celulas_somaticas  NUMBER(10),
  litros_dia_proy    NUMBER(6,2),
  cod_usr            CHAR(6),
  fec_registro       DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_CONTROL_LECHERO add constraint PK_PC_CONTROL_LECHERO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CONTROL_LECHERO add constraint UQ_PC_CTRLLECHE unique (cod_animal, fec_control) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CONTROL_LECHERO add constraint FK_PC_CTRLLECHE_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_CONTROL_LECHERO add constraint FK_PC_CTRLLECHE_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);

comment on table CANTABRIA.PC_CONTROL_LECHERO is 'Pecuario - Control lechero mensual (calidad de leche)';
comment on column CANTABRIA.PC_CONTROL_LECHERO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_CONTROL_LECHERO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_CONTROL_LECHERO.cod_animal is 'vaca controlada';
comment on column CANTABRIA.PC_CONTROL_LECHERO.fec_control is 'fecha del muestreo';
comment on column CANTABRIA.PC_CONTROL_LECHERO.porc_grasa is 'porcentaje de grasa';
comment on column CANTABRIA.PC_CONTROL_LECHERO.porc_proteina is 'porcentaje de proteina';
comment on column CANTABRIA.PC_CONTROL_LECHERO.celulas_somaticas is 'conteo de celulas somaticas (CCS/SCC), celulas/ml';
comment on column CANTABRIA.PC_CONTROL_LECHERO.litros_dia_proy is 'litros/dia proyectados el dia del control';
comment on column CANTABRIA.PC_CONTROL_LECHERO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_CONTROL_LECHERO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_CTRLLECHE start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_CTRLLECHE
before insert on CANTABRIA.PC_CONTROL_LECHERO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_CTRLLECHE.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 5) NUTRICION
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_CONDICION_CORPORAL
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CONDICION_CORPORAL
(
  reckey          NUMBER(10)  not null,
  cod_origen      CHAR(2)     not null,
  cod_animal      CHAR(10)    not null,
  fec_evaluacion  DATE        not null,
  puntaje_bcs     NUMBER(2,1) not null,
  cod_usr         CHAR(6),
  fec_registro    DATE        default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_CONDICION_CORPORAL add constraint PK_PC_CONDICION_CORPORAL primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CONDICION_CORPORAL add constraint UQ_PC_BCS unique (cod_animal, fec_evaluacion) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_CONDICION_CORPORAL add constraint CK_PC_BCS_RANGO check (puntaje_bcs between 1 and 5);
alter table CANTABRIA.PC_CONDICION_CORPORAL add constraint FK_PC_BCS_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_CONDICION_CORPORAL add constraint FK_PC_BCS_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);

comment on table CANTABRIA.PC_CONDICION_CORPORAL is 'Pecuario - Historico de condicion corporal (BCS)';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.cod_animal is 'animal evaluado';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.fec_evaluacion is 'fecha de evaluacion';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.puntaje_bcs is 'puntaje BCS, escala 1.0 a 5.0';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_BCS start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_BCS
before insert on CANTABRIA.PC_CONDICION_CORPORAL
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_BCS.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_ALIMENTACION_CONSUMO (planificacion; el consumo REAL de insumos vive en
-- ARTICULO_MOV via la OT -- ver ORDEN_TRABAJO / OPERACIONES / ARTICULO_MOV_PROY)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ALIMENTACION_CONSUMO
(
  reckey          NUMBER(10)   not null,
  cod_origen      CHAR(2)      not null,
  cod_potrero     CHAR(6)      not null,
  fec_consumo     DATE         not null,
  cod_dieta       CHAR(6)      not null,
  cabezas_lote    NUMBER(5)    not null,
  nro_orden       CHAR(10)     not null,
  cod_usr         CHAR(6),
  fec_registro    DATE         default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_ALIMENTACION_CONSUMO add constraint PK_PC_ALIM_CONSUMO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ALIMENTACION_CONSUMO add constraint UQ_PC_ALIMCONS unique (cod_origen, cod_potrero, fec_consumo, cod_dieta) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_ALIMENTACION_CONSUMO add constraint FK_PC_ALIMCONS_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_ALIMENTACION_CONSUMO add constraint FK_PC_ALIMCONS_POTRERO foreign key (cod_origen, cod_potrero) references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);
alter table CANTABRIA.PC_ALIMENTACION_CONSUMO add constraint FK_PC_ALIMCONS_DIETA foreign key (cod_dieta) references CANTABRIA.PC_DIETA(cod_dieta);
alter table CANTABRIA.PC_ALIMENTACION_CONSUMO add constraint FK_PC_ALIMCONS_OT foreign key (nro_orden) references CANTABRIA.ORDEN_TRABAJO(nro_orden);

comment on table CANTABRIA.PC_ALIMENTACION_CONSUMO is 'Pecuario - Planificacion de alimentacion diaria por potrero/lote (dieta + cabezas); el consumo real de insumos (cod_art, cantidad) queda registrado en ARTICULO_MOV contra la OT de esta fila';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_potrero is 'potrero/lote donde se dio el alimento';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.fec_consumo is 'fecha del consumo';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_dieta is 'dieta aplicada';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cabezas_lote is 'cantidad de animales que comieron esta dieta ese dia';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.nro_orden is 'FK a ORDEN_TRABAJO -- OT (ot_adm=PECU) que agrupa el consumo real de insumos en ARTICULO_MOV para este potrero/dia; ver PC_OT_ANIMAL para saber que animales cubre';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_ALIMCONS start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_ALIMCONS
before insert on CANTABRIA.PC_ALIMENTACION_CONSUMO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_ALIMCONS.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 6) SANIDAD
-- ============================================================================
create table CANTABRIA.PC_SANIDAD_EVENTO
(
  reckey             NUMBER(10) not null,
  cod_origen         CHAR(2)   not null,
  cod_animal         CHAR(10)  not null,
  nro_evento         NUMBER(5) not null,
  fec_evento         DATE      not null,
  flag_tipo_evento   CHAR(1)   not null,
  cod_prod_san       CHAR(10),
  dosis              NUMBER(8,3),
  cod_enfermedad     CHAR(6),
  cod_veterinario    CHAR(8),
  costo              NUMBER(10,2),
  nro_orden          CHAR(10),
  nro_os             CHAR(10),
  fec_prox_refuerzo  DATE,
  fec_fin_retiro     DATE,
  observaciones      VARCHAR2(500),
  cod_usr            CHAR(6),
  fec_registro       DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint PK_PC_SANIDAD_EVENTO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint UQ_PC_SANIDAD unique (cod_animal, nro_evento) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint CK_PC_SANIDAD_TIPO check (flag_tipo_evento in ('V','D','T','X'));
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_PROD foreign key (cod_prod_san) references CANTABRIA.PC_PRODUCTO_SANITARIO(cod_prod_san);
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_ENFERM foreign key (cod_enfermedad) references CANTABRIA.PC_ENFERMEDAD(cod_enfermedad);
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_OT foreign key (nro_orden) references CANTABRIA.ORDEN_TRABAJO(nro_orden);
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_OS foreign key (cod_origen, nro_os) references CANTABRIA.ORDEN_SERVICIO(cod_origen, nro_os);
alter table CANTABRIA.PC_SANIDAD_EVENTO add constraint FK_PC_SANIDAD_VET foreign key (cod_veterinario) references CANTABRIA.PROVEEDOR(proveedor);

comment on table CANTABRIA.PC_SANIDAD_EVENTO is 'Pecuario - Eventos veterinarios (vacunas, desparasitaciones, tratamientos, diagnosticos)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_animal is 'animal atendido';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.nro_evento is 'correlativo de eventos sanitarios de este animal (unique junto a cod_animal, no PK)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_evento is 'fecha del evento';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.flag_tipo_evento is 'V=Vacuna, D=Desparasitacion, T=Tratamiento, X=Diagnostico';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_prod_san is 'producto aplicado (vacuna/medicamento)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.dosis is 'dosis aplicada';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_enfermedad is 'enfermedad diagnosticada/tratada, si aplica';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_veterinario is 'FK a PROVEEDOR -- veterinario responsable (generalmente externo, no personal de planilla)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.costo is 'costo de referencia rapida (el costo real y autorizado vive en ORDEN_SERVICIO.monto_total cuando nro_os esta presente)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.nro_orden is 'FK opcional a ORDEN_TRABAJO -- OT (ot_adm=PECU) que registra en ARTICULO_MOV el consumo real del producto sanitario (vacuna/desparasitante propio)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.nro_os is 'FK opcional a ORDEN_SERVICIO -- cuando el evento implica un servicio/costo externo (veterinario, laboratorio de terceros)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_prox_refuerzo is 'fecha calculada de proximo refuerzo (segun producto)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_fin_retiro is 'fecha calculada de fin de periodo de retiro (leche/venta)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.observaciones is 'observaciones del evento';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_SANIDAD start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_SANIDAD
before insert on CANTABRIA.PC_SANIDAD_EVENTO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_SANIDAD.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 7) RESULTADOS DE LABORATORIO
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_LABORATORIO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LABORATORIO
(
  reckey            NUMBER(10) not null,
  nro_muestra       VARCHAR2(20),
  cod_origen        CHAR(2)    not null,
  cod_animal        CHAR(10),
  cod_semental      CHAR(10),
  fec_muestra       DATE       not null,
  flag_tipo_muestra CHAR(1)    not null,
  laboratorio       VARCHAR2(200),
  cod_veterinario   CHAR(8),
  nro_evento        NUMBER(5),
  fec_resultado     DATE,
  flag_estado       CHAR(1)    default '1' not null,
  flag_origen       CHAR(1)    default 'P' not null,
  cod_cliente       CHAR(8),
  costo_analisis    NUMBER(10,2),
  flag_facturado    CHAR(1)    default '0',
  observaciones     VARCHAR2(500),
  cod_usr           CHAR(6),
  fec_registro      DATE       default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_LABORATORIO add constraint PK_PC_LABORATORIO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LABORATORIO add constraint CK_PC_LAB_TIPO_MUESTRA check (flag_tipo_muestra in ('S','L','F','M','T','O'));
alter table CANTABRIA.PC_LABORATORIO add constraint CK_PC_LAB_ESTADO check (flag_estado in ('0','1','2'));
alter table CANTABRIA.PC_LABORATORIO add constraint CK_PC_LAB_ORIGEN_TIPO check (flag_origen in ('P','C'));
alter table CANTABRIA.PC_LABORATORIO add constraint FK_PC_LAB_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_LABORATORIO add constraint FK_PC_LAB_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_LABORATORIO add constraint FK_PC_LAB_SEMENTAL foreign key (cod_semental) references CANTABRIA.PC_SEMENTAL(cod_semental);
alter table CANTABRIA.PC_LABORATORIO add constraint FK_PC_LAB_SANIDAD foreign key (cod_animal, nro_evento) references CANTABRIA.PC_SANIDAD_EVENTO(cod_animal, nro_evento);
alter table CANTABRIA.PC_LABORATORIO add constraint FK_PC_LAB_VET foreign key (cod_veterinario) references CANTABRIA.PROVEEDOR(proveedor);
alter table CANTABRIA.PC_LABORATORIO add constraint FK_PC_LAB_CLIENTE foreign key (cod_cliente) references CANTABRIA.PROVEEDOR(proveedor);

comment on table CANTABRIA.PC_LABORATORIO is 'Pecuario - Cabecera de muestras enviadas a laboratorio (sangre, leche, fecal, semen, tejido)';
comment on column CANTABRIA.PC_LABORATORIO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_LABORATORIO.nro_muestra is 'codigo de muestra del laboratorio externo (texto libre, no autogenerado, no PK)';
comment on column CANTABRIA.PC_LABORATORIO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_LABORATORIO.cod_animal is 'animal muestreado (nulo si la muestra no es de un animal puntual, ej. forraje/agua)';
comment on column CANTABRIA.PC_LABORATORIO.cod_semental is 'semental analizado, si la muestra es de control de calidad de semen';
comment on column CANTABRIA.PC_LABORATORIO.fec_muestra is 'fecha de toma de la muestra';
comment on column CANTABRIA.PC_LABORATORIO.flag_tipo_muestra is 'S=Sangre, L=Leche, F=Fecal, M=Semen, T=Tejido/necropsia, O=Otro';
comment on column CANTABRIA.PC_LABORATORIO.laboratorio is 'laboratorio externo que proceso la muestra';
comment on column CANTABRIA.PC_LABORATORIO.cod_veterinario is 'FK a PROVEEDOR -- veterinario que tomo la muestra (generalmente externo, no personal de planilla)';
comment on column CANTABRIA.PC_LABORATORIO.nro_evento is 'FK opcional (junto a cod_animal) a PC_SANIDAD_EVENTO, si la muestra es parte de un evento sanitario ya registrado';
comment on column CANTABRIA.PC_LABORATORIO.fec_resultado is 'fecha en que el laboratorio entrego el resultado';
comment on column CANTABRIA.PC_LABORATORIO.flag_estado is '0=Anulada, 1=Pendiente de resultado, 2=Con resultado';
comment on column CANTABRIA.PC_LABORATORIO.flag_origen is 'P=Propio (laboratorio/veterinario nuestro), C=Cliente (lo realiza el comprador de la leche, ej. Laive, y descuenta el costo de la factura)';
comment on column CANTABRIA.PC_LABORATORIO.cod_cliente is 'FK a PROVEEDOR (unifica proveedor/cliente via flag_clie_prov) -- cliente que realizo/solicito el analisis, si flag_origen=C';
comment on column CANTABRIA.PC_LABORATORIO.costo_analisis is 'costo del analisis; si flag_origen=C, es el monto que el cliente descuenta de la factura de venta';
comment on column CANTABRIA.PC_LABORATORIO.flag_facturado is '1 si el costo del analisis ya fue descontado/facturado';
comment on column CANTABRIA.PC_LABORATORIO.observaciones is 'observaciones de la muestra';
comment on column CANTABRIA.PC_LABORATORIO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_LABORATORIO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_LABORATORIO start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_LABORATORIO
before insert on CANTABRIA.PC_LABORATORIO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_LABORATORIO.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_LABORATORIO_DET
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LABORATORIO_DET
(
  reckey              NUMBER(10)    not null,
  lab_reckey          NUMBER(10)    not null,
  item                NUMBER(3)     not null,
  parametro           VARCHAR2(200) not null,
  valor_resultado     VARCHAR2(60),
  unidad_medida       VARCHAR2(20),
  valor_ref_min       NUMBER(12,4),
  valor_ref_max       NUMBER(12,4),
  flag_interpretacion CHAR(1)
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_LABORATORIO_DET add constraint PK_PC_LABORATORIO_DET primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LABORATORIO_DET add constraint UQ_PC_LABDET unique (lab_reckey, item) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_LABORATORIO_DET add constraint CK_PC_LABDET_INTERP check (flag_interpretacion in ('N','A') or flag_interpretacion is null);
alter table CANTABRIA.PC_LABORATORIO_DET add constraint FK_PC_LABDET_MUESTRA foreign key (lab_reckey) references CANTABRIA.PC_LABORATORIO(reckey);

comment on table CANTABRIA.PC_LABORATORIO_DET is 'Pecuario - Detalle de parametros/analitos resultantes de una muestra de laboratorio';
comment on column CANTABRIA.PC_LABORATORIO_DET.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_LABORATORIO_DET.lab_reckey is 'FK a PC_LABORATORIO.reckey -- muestra a la que pertenece';
comment on column CANTABRIA.PC_LABORATORIO_DET.item is 'item correlativo (unique junto a lab_reckey, no PK)';
comment on column CANTABRIA.PC_LABORATORIO_DET.parametro is 'nombre del parametro/analito (ej. Brucelosis - ELISA, Motilidad espermatica, Huevos por gramo)';
comment on column CANTABRIA.PC_LABORATORIO_DET.valor_resultado is 'valor del resultado (texto, admite cualitativo Positivo/Negativo o numerico)';
comment on column CANTABRIA.PC_LABORATORIO_DET.unidad_medida is 'unidad de medida del resultado, si es numerico';
comment on column CANTABRIA.PC_LABORATORIO_DET.valor_ref_min is 'limite inferior del rango de referencia, si aplica';
comment on column CANTABRIA.PC_LABORATORIO_DET.valor_ref_max is 'limite superior del rango de referencia, si aplica';
comment on column CANTABRIA.PC_LABORATORIO_DET.flag_interpretacion is 'N=Normal, A=Alterado';

create sequence CANTABRIA.SEQ_PC_LABDET start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_LABDET
before insert on CANTABRIA.PC_LABORATORIO_DET
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_LABDET.nextval into :new.reckey from dual;
  end if;
end;
/


-- ============================================================================
-- 8) MOVIMIENTOS, TRAZABILIDAD Y BAJAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_MOVIMIENTO_POTRERO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_MOVIMIENTO_POTRERO
(
  reckey               NUMBER(10) not null,
  cod_origen           CHAR(2)   not null,
  cod_animal           CHAR(10)  not null,
  fec_movimiento       DATE      not null,
  cod_potrero_origen   CHAR(6),
  cod_potrero_destino  CHAR(6)   not null,
  motivo               VARCHAR2(200),
  cod_usr              CHAR(6),
  fec_registro         DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_MOVIMIENTO_POTRERO add constraint PK_PC_MOV_POTRERO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_MOVIMIENTO_POTRERO add constraint UQ_PC_MOVPOT unique (cod_animal, fec_movimiento) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_MOVIMIENTO_POTRERO add constraint FK_PC_MOVPOT_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_MOVIMIENTO_POTRERO add constraint FK_PC_MOVPOT_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_MOVIMIENTO_POTRERO add constraint FK_PC_MOVPOT_POT_ORIG foreign key (cod_origen, cod_potrero_origen) references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);
alter table CANTABRIA.PC_MOVIMIENTO_POTRERO add constraint FK_PC_MOVPOT_POT_DEST foreign key (cod_origen, cod_potrero_destino) references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);

comment on table CANTABRIA.PC_MOVIMIENTO_POTRERO is 'Pecuario - Historico de cambios de potrero (rotacion de pastoreo)';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_animal is 'animal movido';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.fec_movimiento is 'fecha del movimiento';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_potrero_origen is 'potrero de origen';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_potrero_destino is 'potrero de destino';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.motivo is 'motivo del movimiento';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_MOVPOT start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_MOVPOT
before insert on CANTABRIA.PC_MOVIMIENTO_POTRERO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_MOVPOT.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_MOVIMIENTO_ESTABLO -- historial de cambios de establo (mismo patron que
-- PC_MOVIMIENTO_POTRERO, pero para la ubicacion cubierta). Un animal puede
-- tener movimientos de potrero y de establo el mismo dia, de forma
-- independiente (ej. se traslada de Potrero Norte a Sur, y por la tarde
-- entra al Establo de Ordeno).
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_MOVIMIENTO_ESTABLO
(
  reckey               NUMBER(10) not null,
  cod_origen           CHAR(2)   not null,
  cod_animal           CHAR(10)  not null,
  fec_movimiento       DATE      not null,
  cod_establo_origen   CHAR(6),
  cod_establo_destino  CHAR(6)   not null,
  motivo               VARCHAR2(200),
  cod_usr              CHAR(6),
  fec_registro         DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_MOVIMIENTO_ESTABLO add constraint PK_PC_MOV_ESTABLO primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_MOVIMIENTO_ESTABLO add constraint UQ_PC_MOVEST unique (cod_animal, fec_movimiento) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_MOVIMIENTO_ESTABLO add constraint FK_PC_MOVEST_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_MOVIMIENTO_ESTABLO add constraint FK_PC_MOVEST_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_MOVIMIENTO_ESTABLO add constraint FK_PC_MOVEST_EST_ORIG foreign key (cod_origen, cod_establo_origen) references CANTABRIA.PC_ESTABLO(cod_origen, cod_establo);
alter table CANTABRIA.PC_MOVIMIENTO_ESTABLO add constraint FK_PC_MOVEST_EST_DEST foreign key (cod_origen, cod_establo_destino) references CANTABRIA.PC_ESTABLO(cod_origen, cod_establo);

comment on table CANTABRIA.PC_MOVIMIENTO_ESTABLO is 'Pecuario - Historico de cambios de establo (ubicacion cubierta)';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.cod_animal is 'animal movido';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.fec_movimiento is 'fecha del movimiento';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.cod_establo_origen is 'establo de origen (nulo si venia de pastoreo/sin establo)';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.cod_establo_destino is 'establo de destino';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.motivo is 'motivo del movimiento (ej. ordeno, parto, cuarentena por enfermedad)';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_MOVIMIENTO_ESTABLO.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_MOVEST start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_MOVEST
before insert on CANTABRIA.PC_MOVIMIENTO_ESTABLO
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_MOVEST.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_DTA (Documento de Transito Animal -- DOCUMENTO EXTERNO: lo emite SENASA,
-- no lo genera nuestro sistema, por eso PK=reckey y nro_dta es texto libre)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DTA
(
  reckey                NUMBER(10)    not null,
  nro_dta                VARCHAR2(20),
  fec_emision           DATE          not null,
  cod_origen_fundo      CHAR(2)       not null,
  cod_destino_fundo     CHAR(2),
  razon_social_destino  VARCHAR2(200),
  motivo                CHAR(1)       not null,
  flag_estado           CHAR(1)       default '1' not null,
  cod_usr               CHAR(6),
  fec_registro          DATE          default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_DTA add constraint PK_PC_DTA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DTA add constraint UQ_PC_DTA_NRO unique (nro_dta) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DTA add constraint CK_PC_DTA_MOTIVO check (motivo in ('V','T','F'));
alter table CANTABRIA.PC_DTA add constraint FK_PC_DTA_ORIGEN foreign key (cod_origen_fundo) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_DTA add constraint FK_PC_DTA_DESTINO foreign key (cod_destino_fundo) references CANTABRIA.ORIGEN(cod_origen);

comment on table CANTABRIA.PC_DTA is 'Pecuario - Documento de Transito Animal (trazabilidad SENASA)';
comment on column CANTABRIA.PC_DTA.reckey is 'PK autonumerica (interna)';
comment on column CANTABRIA.PC_DTA.nro_dta is 'numero de DTA asignado por SENASA -- documento EXTERNO, texto libre, no autogenerado por este sistema';
comment on column CANTABRIA.PC_DTA.fec_emision is 'fecha de emision';
comment on column CANTABRIA.PC_DTA.cod_origen_fundo is 'FK a ORIGEN -- fundo de origen';
comment on column CANTABRIA.PC_DTA.cod_destino_fundo is 'FK a ORIGEN -- fundo de destino (si es traslado interno)';
comment on column CANTABRIA.PC_DTA.razon_social_destino is 'razon social del destino (si es venta a un tercero)';
comment on column CANTABRIA.PC_DTA.motivo is 'V=Venta, T=Traslado interno, F=Feria/exposicion';
comment on column CANTABRIA.PC_DTA.flag_estado is 'flag_estado';
comment on column CANTABRIA.PC_DTA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_DTA.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_DTA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_DTA
before insert on CANTABRIA.PC_DTA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_DTA.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_DTA_DETALLE
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DTA_DETALLE
(
  reckey       NUMBER(10) not null,
  dta_reckey   NUMBER(10) not null,
  item         NUMBER(4)  not null,
  cod_animal   CHAR(10)   not null
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_DTA_DETALLE add constraint PK_PC_DTA_DETALLE primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DTA_DETALLE add constraint UQ_PC_DTADET unique (dta_reckey, item) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_DTA_DETALLE add constraint FK_PC_DTADET_DTA foreign key (dta_reckey) references CANTABRIA.PC_DTA(reckey);
alter table CANTABRIA.PC_DTA_DETALLE add constraint FK_PC_DTADET_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);

comment on table CANTABRIA.PC_DTA_DETALLE is 'Pecuario - Animales incluidos en cada DTA';
comment on column CANTABRIA.PC_DTA_DETALLE.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_DTA_DETALLE.dta_reckey is 'FK a PC_DTA.reckey -- DTA al que pertenece';
comment on column CANTABRIA.PC_DTA_DETALLE.item is 'item correlativo (unique junto a dta_reckey, no PK)';
comment on column CANTABRIA.PC_DTA_DETALLE.cod_animal is 'animal incluido en el traslado';

create sequence CANTABRIA.SEQ_PC_DTADET start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_DTADET
before insert on CANTABRIA.PC_DTA_DETALLE
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_DTADET.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- PC_BAJA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_BAJA
(
  reckey           NUMBER(10) not null,
  cod_origen       CHAR(2)   not null,
  cod_animal       CHAR(10)  not null,
  fec_baja         DATE      not null,
  flag_motivo      CHAR(1)   not null,
  causa_muerte     VARCHAR2(200),
  precio_venta     NUMBER(12,2),
  nro_ov           CHAR(10),
  dta_reckey       NUMBER(10),
  observaciones    VARCHAR2(300),
  cod_usr          CHAR(6),
  fec_registro     DATE      default sysdate
)
tablespace CANTABRIA;

alter table CANTABRIA.PC_BAJA add constraint PK_PC_BAJA primary key (reckey) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_BAJA add constraint UQ_PC_BAJA_ANIMAL unique (cod_animal) using index tablespace CANTABRIA;
alter table CANTABRIA.PC_BAJA add constraint CK_PC_BAJA_MOTIVO check (flag_motivo in ('V','M','D'));
alter table CANTABRIA.PC_BAJA add constraint FK_PC_BAJA_ORIGEN foreign key (cod_origen) references CANTABRIA.ORIGEN(cod_origen);
alter table CANTABRIA.PC_BAJA add constraint FK_PC_BAJA_ANIMAL foreign key (cod_animal) references CANTABRIA.PC_ANIMAL(cod_animal);
alter table CANTABRIA.PC_BAJA add constraint FK_PC_BAJA_OV foreign key (nro_ov) references CANTABRIA.ORDEN_VENTA(nro_ov);
alter table CANTABRIA.PC_BAJA add constraint FK_PC_BAJA_DTA foreign key (dta_reckey) references CANTABRIA.PC_DTA(reckey);

comment on table CANTABRIA.PC_BAJA is 'Pecuario - Bajas del hato (venta, muerte o descarte)';
comment on column CANTABRIA.PC_BAJA.reckey is 'PK autonumerica';
comment on column CANTABRIA.PC_BAJA.cod_origen is 'FK a ORIGEN -- fundo/sucursal';
comment on column CANTABRIA.PC_BAJA.cod_animal is 'animal dado de baja (unique, no PK -- una baja por animal)';
comment on column CANTABRIA.PC_BAJA.fec_baja is 'fecha de la baja';
comment on column CANTABRIA.PC_BAJA.flag_motivo is 'V=Venta, M=Muerte, D=Descarte (infertil/enfermo/vejez)';
comment on column CANTABRIA.PC_BAJA.causa_muerte is 'causa de muerte, si flag_motivo=M';
comment on column CANTABRIA.PC_BAJA.precio_venta is 'precio de venta, si flag_motivo=V';
comment on column CANTABRIA.PC_BAJA.nro_ov is 'FK a ORDEN_VENTA -- orden/factura de venta real (modulo Comercializacion), si flag_motivo=V';
comment on column CANTABRIA.PC_BAJA.dta_reckey is 'FK a PC_DTA.reckey si la baja implico traslado';
comment on column CANTABRIA.PC_BAJA.observaciones is 'observaciones de la baja';
comment on column CANTABRIA.PC_BAJA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_BAJA.fec_registro is 'fecha de registro en el sistema';

create sequence CANTABRIA.SEQ_PC_BAJA start with 1 increment by 1 nocache;
create or replace trigger CANTABRIA.TIB_PC_BAJA
before insert on CANTABRIA.PC_BAJA
for each row
begin
  if :new.reckey is null then
    select SEQ_PC_BAJA.nextval into :new.reckey from dual;
  end if;
end;
/


-- ----------------------------------------------------------------------------
-- Trigger: al insertar una baja, desactivar el animal en PC_ANIMAL
-- ----------------------------------------------------------------------------
create or replace trigger CANTABRIA.TRG_PC_BAJA_AI
after insert on CANTABRIA.PC_BAJA
for each row
begin
  update CANTABRIA.PC_ANIMAL
     set flag_estado = '0'
   where cod_animal = :new.cod_animal;
end;
/

commit;


-- ============================================================================
-- 9) DATA DE PRUEBA (DEMO) -- para QA / pulir pantallas, NO usar en produccion
-- ============================================================================
-- Escenario encadenado con cod_origen = 'SU' (placeholder de 2 caracteres --
-- ajustar al codigo real de ORIGEN antes de usar; el formato de documento
-- (cod_animal, nro_servicio) es cod_origen + correlativo de 8 digitos, ej.
-- 'SU00000001'). Incluye: 2 potreros, 1 semental, 1 dieta con su componente,
-- 1 receta de concentrado, 2 Ordenes de Trabajo Pecuarias (ORDEN_TRABAJO con
-- ot_adm='PECU') vinculadas a sus animales via PC_OT_ANIMAL, 5 animales (2
-- vacas, 1 toro, 1 cria, 1 vaca de descarte) con su codigo-documento y su
-- cod_interno (arete fisico), un ciclo reproductivo completo (celo->
-- servicio->diagnostico->parto), lactancia con ordenos (con ingreso real
-- I09: almacen+producto terminado), condicion corporal, consumo de alimento
-- amarrado a la OT, eventos sanitarios (con OT para consumo propio, con
-- Orden de Servicio para costo externo), resultados de laboratorio (mastitis
-- propio + calidad de semen propio + analisis de leche del cliente Laive), y
-- el ciclo de vida completo de una baja por venta con su DTA y su orden de
-- venta.
--
-- ADVERTENCIA -- placeholders que deben ajustarse antes de ejecutar en un
-- esquema real (o comentar esas lineas si aun no aplican):
--   - 'SU' como cod_origen: reemplazar por el codigo real de ORIGEN.
--   - 'ART00000001' (PC_DIETA_COMPONENTE), 'ART00000002' (TIPO_PRODUCTO
--     leche) y 'ART00000003'/'ART00000004' (PC_RECETA_DET materia prima del
--     concentrado): deben ser codigos reales existentes en ARTICULO.
--   - '0100000099' (PC_SANIDAD_EVENTO.nro_os): debe ser una ORDEN_SERVICIO
--     real (modulo Compras, pantalla w_cm314) por el costo de la visita
--     veterinaria de Estrella.
--   - 'OV00000001' (PC_BAJA.nro_ov): debe ser una ORDEN_VENTA real (modulo
--     Comercializacion) por la venta de Estrella.
--   - Las filas de ORDEN_TRABAJO/OT_TIPO/ALMACEN/TIPO_PRODUCTO/ORIGEN de
--     este bloque son minimas para poder correr el demo end-to-end; en
--     produccion se crean desde sus pantallas estandar, no a mano.
--   - cod_animal, nro_servicio: se especifican explicitamente aqui (los
--     triggers los respetan porque solo generan el valor si viene NULL) para
--     que el resto del demo pueda referenciarlos por FK de forma legible.
-- ============================================================================

-- Origen (ajustar/omitir si ya existe en el esquema real) -- insertar solo si no existe (tabla compartida, no se trunca)
insert into CANTABRIA.ORIGEN (cod_origen, nombre)
  select 'SU','Fundo Sur (demo Pecuario)' from dual
   where not exists (select 1 from CANTABRIA.ORIGEN where cod_origen = 'SU');
commit;

-- Especies y razas ya sembradas arriba (BOVI/HOLS/BRSW, etc.)

-- Potreros
insert into CANTABRIA.PC_POTRERO (cod_origen, cod_potrero, nom_potrero, area_has, tipo_pasto, capacidad_cab) values ('SU','POT001','Potrero Norte',10,'Brachiaria brizantha',40);
insert into CANTABRIA.PC_POTRERO (cod_origen, cod_potrero, nom_potrero, area_has, tipo_pasto, capacidad_cab) values ('SU','POT002','Potrero Sur',8,'Brachiaria brizantha',30);
commit;

-- Establos (ubicacion cubierta, independiente del potrero)
insert into CANTABRIA.PC_ESTABLO (cod_origen, cod_establo, nom_establo, flag_tipo, capacidad_cab) values ('SU','EST001','Sala de ordeno','O',20);
insert into CANTABRIA.PC_ESTABLO (cod_origen, cod_establo, nom_establo, flag_tipo, capacidad_cab) values ('SU','EST002','Corral de cuarentena','C',10);
insert into CANTABRIA.PC_ESTABLO (cod_origen, cod_establo, nom_establo, flag_tipo, capacidad_cab) values ('SU','EST003','Nave de incubacion','I',10000);
commit;

-- Semental
insert into CANTABRIA.PC_SEMENTAL (cod_semental, nom_semental, cod_raza, proveedor, registro_genet) values ('SEM0000001','Toro IA Holstein 245','HOLS','Central Genetica Peru','US-12345');
commit;

-- Dieta y componente (AJUSTAR cod_art antes de ejecutar si ARTICULO no tiene este codigo)
insert into CANTABRIA.PC_DIETA (cod_dieta, nom_dieta, cod_categoria, costo_kg_prom) values ('DIE001','Dieta vacas en produccion','VPR',1.20);
commit;
insert into CANTABRIA.PC_DIETA_COMPONENTE (cod_dieta, item, cod_art, cantidad_kg) values ('DIE001',1,'ART00000001',15.000);
commit;

-- Receta de concentrado (fabricacion propia): 1000 kg de concentrado a partir
-- de maiz molido + afrecho de trigo (AJUSTAR cod_art de materia prima y del
-- producto terminado en TIPO_PRODUCTO antes de ejecutar)
insert into CANTABRIA.TIPO_PRODUCTO (cod_prod, desc_prod, cod_art, und)
  select 'CONCENT0001','Concentrado vacas en produccion','ART00000005','KG' from dual
   where not exists (select 1 from CANTABRIA.TIPO_PRODUCTO where cod_prod = 'CONCENT0001');
commit;
insert into CANTABRIA.PC_RECETA (cod_receta, nom_receta, cod_producto, rendimiento_kg) values ('REC001','Concentrado vacas en produccion','CONCENT0001',1000.000);
commit;
insert into CANTABRIA.PC_RECETA_DET (cod_receta, item, cod_art, cantidad_kg) values ('REC001',1,'ART00000003',700.000);
insert into CANTABRIA.PC_RECETA_DET (cod_receta, item, cod_art, cantidad_kg) values ('REC001',2,'ART00000004',300.000);
commit;

-- ----------------------------------------------------------------------------
-- Integracion con OT / Almacen (tablas GENERICAS y ya existentes del ERP,
-- NO exclusivas de Pecuario). Se inserta lo minimo indispensable para que el
-- resto del escenario de prueba (alimentacion, sanidad, produccion de leche)
-- pueda referenciar una OT real. En produccion estas filas se crean desde
-- sus pantallas estandar (OPE302 Ordenes de Trabajo, mantenimiento de
-- Almacenes, Tipos de Producto), NO se insertan a mano como aqui.
-- ----------------------------------------------------------------------------
insert into CANTABRIA.OT_TIPO (ot_tipo, descripcion)
  select 'PECU','Orden de Trabajo Pecuaria' from dual
   where not exists (select 1 from CANTABRIA.OT_TIPO where ot_tipo = 'PECU');
commit;
insert into CANTABRIA.ALMACEN (almacen, desc_almacen, cod_origen, flag_tipo_almacen)
  select 'ALM001','Almacen Produccion Pecuaria','SU','P' from dual
   where not exists (select 1 from CANTABRIA.ALMACEN where almacen = 'ALM001');
insert into CANTABRIA.ALMACEN (almacen, desc_almacen, cod_origen, flag_tipo_almacen)
  select 'ALM002','Almacen Concentrado','SU','P' from dual
   where not exists (select 1 from CANTABRIA.ALMACEN where almacen = 'ALM002');
commit;
-- AJUSTAR cod_art: debe ser un articulo real de tipo "producto terminado" en ARTICULO
insert into CANTABRIA.TIPO_PRODUCTO (cod_prod, desc_prod, cod_art, und)
  select 'LECHE000001','Leche cruda','ART00000002','LT' from dual
   where not exists (select 1 from CANTABRIA.TIPO_PRODUCTO where cod_prod = 'LECHE000001');
commit;

-- OT Pecuaria 1: alimentacion del potrero Norte (02-04 jul 2026) -- animales 1 y 2
insert into CANTABRIA.ORDEN_TRABAJO (cod_origen, nro_orden, titulo, ot_tipo, ot_adm, fec_solicitud, fec_inicio, flag_estado, cod_usr)
  select 'SU','SU00000001','Alimentacion potrero Norte 02-04 jul','PECU','PECU',TO_DATE('02/07/2026','DD/MM/YYYY'),TO_DATE('02/07/2026','DD/MM/YYYY'),'1','DEMO01' from dual
   where not exists (select 1 from CANTABRIA.ORDEN_TRABAJO where nro_orden = 'SU00000001');

-- OT Pecuaria 2: vacunacion/desparasitacion de febrero 2026 -- animales 1 y 2
insert into CANTABRIA.ORDEN_TRABAJO (cod_origen, nro_orden, titulo, ot_tipo, ot_adm, fec_solicitud, fec_inicio, flag_estado, cod_usr)
  select 'SU','SU00000002','Sanidad - vacunacion y desparasitacion feb','PECU','PECU',TO_DATE('01/02/2026','DD/MM/YYYY'),TO_DATE('01/02/2026','DD/MM/YYYY'),'1','DEMO01' from dual
   where not exists (select 1 from CANTABRIA.ORDEN_TRABAJO where nro_orden = 'SU00000002');

-- OT Pecuaria 3: fabricacion de concentrado (consume maiz+afrecho, produce concentrado)
insert into CANTABRIA.ORDEN_TRABAJO (cod_origen, nro_orden, titulo, ot_tipo, ot_adm, fec_solicitud, fec_inicio, flag_estado, cod_usr)
  select 'SU','SU00000003','Fabricacion concentrado - lote 1000kg','PECU','PECU',TO_DATE('25/06/2026','DD/MM/YYYY'),TO_DATE('25/06/2026','DD/MM/YYYY'),'1','DEMO01' from dual
   where not exists (select 1 from CANTABRIA.ORDEN_TRABAJO where nro_orden = 'SU00000003');
commit;

-- Lote (agrupacion de manejo, validado contra AGRI): Paloma y Luna pastan
-- juntas en el Potrero Norte, formando un lote de vacas en produccion.
insert into CANTABRIA.PC_LOTE (cod_origen, cod_lote, nom_lote, cod_potrero, cod_categoria, fec_formacion, cantidad_cabezas_inicial, cantidad_cabezas_actual, cod_usr)
  values ('SU','LOT001','Vacas en produccion - Potrero Norte','POT001','VPR',TO_DATE('01/01/2026','DD/MM/YYYY'),2,2,'DEMO01');
commit;

-- Animales (orden importa: la madre antes que la cria). cod_animal y
-- cod_interno se especifican a mano para el demo (cod_interno = arete fisico
-- que ya usa la empresa, ej. el que trae grabado en la oreja).
insert into CANTABRIA.PC_ANIMAL (cod_animal, cod_origen, cod_interno, nom_animal, cod_raza, flag_sexo, fec_nacimiento, cod_categoria, cod_potrero, cod_lote, flag_estado_repro, peso_nacimiento, peso_actual, cod_procedencia, cod_usr)
  values ('SU00000001','SU','ARE-4521','Paloma','HOLS','H',TO_DATE('15/03/2021','DD/MM/YYYY'),'VPR','POT001','LOT001','3',38,550,'P','DEMO01');
insert into CANTABRIA.PC_ANIMAL (cod_animal, cod_origen, cod_interno, nom_animal, cod_raza, flag_sexo, fec_nacimiento, cod_categoria, cod_potrero, cod_lote, flag_estado_repro, peso_nacimiento, peso_actual, cod_procedencia, cod_usr)
  values ('SU00000002','SU','ARE-4522','Luna','BRSW','H',TO_DATE('10/06/2020','DD/MM/YYYY'),'VPR','POT001','LOT001','2',40,540,'P','DEMO01');
insert into CANTABRIA.PC_ANIMAL (cod_animal, cod_origen, cod_interno, nom_animal, cod_raza, flag_sexo, fec_nacimiento, cod_categoria, cod_potrero, peso_nacimiento, peso_actual, cod_procedencia, cod_usr)
  values ('SU00000003','SU','ARE-4001','Bravo','HOLS','M',TO_DATE('20/01/2019','DD/MM/YYYY'),'TOR','POT002',42,780,'P','DEMO01');
insert into CANTABRIA.PC_ANIMAL (cod_animal, cod_origen, cod_interno, nom_animal, cod_raza, flag_sexo, fec_nacimiento, cod_animal_padre, cod_animal_madre, cod_categoria, cod_potrero, peso_nacimiento, peso_actual, cod_procedencia, cod_usr)
  values ('SU00000004','SU','ARE-4890','Cria de Paloma','HOLS','H',TO_DATE('15/06/2026','DD/MM/YYYY'),'SU00000003','SU00000001','TER','POT001',35,35,'P','DEMO01');
insert into CANTABRIA.PC_ANIMAL (cod_animal, cod_origen, cod_interno, nom_animal, cod_raza, flag_sexo, fec_nacimiento, cod_categoria, cod_potrero, cod_establo, flag_estado_repro, peso_nacimiento, peso_actual, cod_procedencia, cod_usr)
  values ('SU00000005','SU','ARE-3980','Estrella','HOLS','H',TO_DATE('02/02/2019','DD/MM/YYYY'),'VDE','POT002','EST002','0',37,520,'P','DEMO01');
commit;

-- Vinculo OT <-> animales
insert into CANTABRIA.PC_OT_ANIMAL (nro_orden, cod_origen, cod_animal, cod_usr) values ('SU00000001','SU','SU00000001','DEMO01');
insert into CANTABRIA.PC_OT_ANIMAL (nro_orden, cod_origen, cod_animal, cod_usr) values ('SU00000001','SU','SU00000002','DEMO01');
insert into CANTABRIA.PC_OT_ANIMAL (nro_orden, cod_origen, cod_animal, cod_usr) values ('SU00000002','SU','SU00000001','DEMO01');
insert into CANTABRIA.PC_OT_ANIMAL (nro_orden, cod_origen, cod_animal, cod_usr) values ('SU00000002','SU','SU00000002','DEMO01');
commit;
-- NOTA: el consumo real de insumos (cod_art, cantidad, nro_vale) de estas OT
-- queda en ARTICULO_MOV (via ORDEN_TRABAJO -> OPERACIONES -> ARTICULO_MOV),
-- que se genera desde las pantallas estandar de Almacen/OPE302, no en este
-- script -- Pecuario solo necesita el nro_orden para reconstruir el historial.

-- Ciclo reproductivo de Paloma (servicio natural con Bravo -> diagnostico -> parto -> cria)
insert into CANTABRIA.PC_SERVICIO (nro_servicio, cod_origen, cod_animal, fec_servicio, flag_tipo_servicio, cod_animal_toro, fec_prob_parto, cod_usr)
  values ('SU00000001','SU','SU00000001',TO_DATE('05/09/2025','DD/MM/YYYY'),'N','SU00000003',TO_DATE('15/06/2026','DD/MM/YYYY'),'DEMO01');
insert into CANTABRIA.PC_DIAGNOSTICO_PRENEZ (cod_origen, nro_servicio, cod_animal, fec_diagnostico, metodo, resultado, dias_gestacion, cod_veterinario, cod_usr)
  values ('SU','SU00000001','SU00000001',TO_DATE('05/12/2025','DD/MM/YYYY'),'T','P',91,'VET001','DEMO01');
insert into CANTABRIA.PC_PARTO (cod_origen, cod_animal, fec_parto, nro_servicio, flag_tipo_parto, flag_asistido, cod_animal_cria, sexo_cria, peso_cria, flag_cria_viva, flag_retencion_placenta, cod_veterinario, cod_usr)
  values ('SU','SU00000001',TO_DATE('15/06/2026','DD/MM/YYYY'),'SU00000001','E','0','SU00000004','H',35,'1','0','VET001','DEMO01');
commit;

-- Ciclo reproductivo de Luna, en curso (celo -> servicio por IA -> diagnostico positivo, sin parto todavia)
insert into CANTABRIA.PC_CELO (cod_origen, cod_animal, fec_celo, metodo_deteccion, flag_servido, cod_usr)
  values ('SU','SU00000002',TO_DATE('01/03/2026','DD/MM/YYYY'),'V','1','DEMO01');
insert into CANTABRIA.PC_SERVICIO (nro_servicio, cod_origen, cod_animal, fec_servicio, flag_tipo_servicio, cod_semental, cod_tecnico, fec_prob_parto, cod_usr)
  values ('SU00000002','SU','SU00000002',TO_DATE('01/03/2026','DD/MM/YYYY'),'I','SEM0000001','VET001',TO_DATE('09/12/2026','DD/MM/YYYY'),'DEMO01');
insert into CANTABRIA.PC_DIAGNOSTICO_PRENEZ (cod_origen, nro_servicio, cod_animal, fec_diagnostico, metodo, resultado, dias_gestacion, cod_veterinario, cod_usr)
  values ('SU','SU00000002','SU00000002',TO_DATE('15/04/2026','DD/MM/YYYY'),'E','P',45,'VET001','DEMO01');
commit;

-- Lactancia de Paloma (2da lactancia, abierta por el parto de arriba) + ordenos
-- (con ingreso real I09: almacen+producto terminado+OT) + control lechero
insert into CANTABRIA.PC_LACTANCIA (cod_origen, cod_animal, nro_lactancia, fec_parto, flag_estado, cod_usr)
  values ('SU','SU00000001',2,TO_DATE('15/06/2026','DD/MM/YYYY'),'1','DEMO01');
insert into CANTABRIA.PC_ORDENO (cod_origen, cod_animal, fec_ordeno, nro_turno, litros, nro_orden, cod_almacen, cod_producto, cod_usr) values ('SU','SU00000001',TO_DATE('02/07/2026','DD/MM/YYYY'),1,12.5,'SU00000001','ALM001','LECHE000001','DEMO01');
insert into CANTABRIA.PC_ORDENO (cod_origen, cod_animal, fec_ordeno, nro_turno, litros, nro_orden, cod_almacen, cod_producto, cod_usr) values ('SU','SU00000001',TO_DATE('02/07/2026','DD/MM/YYYY'),2,10.2,'SU00000001','ALM001','LECHE000001','DEMO01');
insert into CANTABRIA.PC_ORDENO (cod_origen, cod_animal, fec_ordeno, nro_turno, litros, nro_orden, cod_almacen, cod_producto, cod_usr) values ('SU','SU00000001',TO_DATE('03/07/2026','DD/MM/YYYY'),1,13.0,'SU00000001','ALM001','LECHE000001','DEMO01');
insert into CANTABRIA.PC_ORDENO (cod_origen, cod_animal, fec_ordeno, nro_turno, litros, nro_orden, cod_almacen, cod_producto, cod_usr) values ('SU','SU00000001',TO_DATE('03/07/2026','DD/MM/YYYY'),2,10.5,'SU00000001','ALM001','LECHE000001','DEMO01');
insert into CANTABRIA.PC_ORDENO (cod_origen, cod_animal, fec_ordeno, nro_turno, litros, nro_orden, cod_almacen, cod_producto, cod_usr) values ('SU','SU00000001',TO_DATE('04/07/2026','DD/MM/YYYY'),1,12.8,'SU00000001','ALM001','LECHE000001','DEMO01');
insert into CANTABRIA.PC_ORDENO (cod_origen, cod_animal, fec_ordeno, nro_turno, litros, nro_orden, cod_almacen, cod_producto, cod_usr) values ('SU','SU00000001',TO_DATE('04/07/2026','DD/MM/YYYY'),2,10.0,'SU00000001','ALM001','LECHE000001','DEMO01');
update CANTABRIA.PC_LACTANCIA set litros_totales = 69.0 where cod_animal='SU00000001' and nro_lactancia=2;
insert into CANTABRIA.PC_CONTROL_LECHERO (cod_origen, cod_animal, fec_control, porc_grasa, porc_proteina, celulas_somaticas, litros_dia_proy, cod_usr)
  values ('SU','SU00000001',TO_DATE('01/07/2026','DD/MM/YYYY'),3.8,3.2,180000,23.0,'DEMO01');
commit;

-- Condicion corporal
insert into CANTABRIA.PC_CONDICION_CORPORAL (cod_origen, cod_animal, fec_evaluacion, puntaje_bcs, cod_usr) values ('SU','SU00000001',TO_DATE('01/07/2026','DD/MM/YYYY'),3.0,'DEMO01');
insert into CANTABRIA.PC_CONDICION_CORPORAL (cod_origen, cod_animal, fec_evaluacion, puntaje_bcs, cod_usr) values ('SU','SU00000002',TO_DATE('01/07/2026','DD/MM/YYYY'),3.5,'DEMO01');
commit;

-- Consumo de alimento: registro zootecnico de planificacion amarrado a la OT SU00000001
insert into CANTABRIA.PC_ALIMENTACION_CONSUMO (cod_origen, cod_potrero, fec_consumo, cod_dieta, cabezas_lote, nro_orden, cod_usr)
  values ('SU','POT001',TO_DATE('03/07/2026','DD/MM/YYYY'),'DIE001',2,'SU00000001','DEMO01');
commit;

-- Eventos sanitarios: vacuna y desparasitante amarrados a la OT SU00000002
insert into CANTABRIA.PC_SANIDAD_EVENTO (cod_origen, cod_animal, nro_evento, fec_evento, flag_tipo_evento, cod_prod_san, dosis, cod_veterinario, costo, nro_orden, fec_prox_refuerzo, fec_fin_retiro, cod_usr)
  values ('SU','SU00000001',1,TO_DATE('01/02/2026','DD/MM/YYYY'),'V','VAC001',2,'VET001',15.00,'SU00000002',TO_DATE('01/08/2026','DD/MM/YYYY'),TO_DATE('22/02/2026','DD/MM/YYYY'),'DEMO01');
insert into CANTABRIA.PC_SANIDAD_EVENTO (cod_origen, cod_animal, nro_evento, fec_evento, flag_tipo_evento, cod_prod_san, dosis, cod_veterinario, costo, nro_orden, fec_prox_refuerzo, fec_fin_retiro, cod_usr)
  values ('SU','SU00000002',1,TO_DATE('01/02/2026','DD/MM/YYYY'),'D','DES001',20,'VET001',8.00,'SU00000002',TO_DATE('01/05/2026','DD/MM/YYYY'),TO_DATE('05/03/2026','DD/MM/YYYY'),'DEMO01');
-- Diagnostico de mastitis de Estrella: sin OT (no hay consumible propio), con
-- Orden de Servicio (nro_os) porque implica el costo de la visita veterinaria
-- externa -- AJUSTAR nro_os a una ORDEN_SERVICIO real (modulo Compras, w_cm314)
insert into CANTABRIA.PC_SANIDAD_EVENTO (cod_origen, cod_animal, nro_evento, fec_evento, flag_tipo_evento, cod_enfermedad, cod_veterinario, costo, nro_os, observaciones, cod_usr)
  values ('SU','SU00000005',1,TO_DATE('20/05/2026','DD/MM/YYYY'),'X','MASTI1','VET001',25.00,'0100000099','Mastitis clinica, cuartil posterior derecho','DEMO01');
commit;

-- Cliente que solicita/realiza su propio analisis de calidad de leche (Laive)
-- -- PROVEEDOR es tabla compartida (unifica proveedor/cliente/trabajador via
-- flag_clie_prov), se inserta solo si no existe. AJUSTAR flag_clie_prov segun
-- la convencion real del modulo de Compras/Proveedores antes de ejecutar.
insert into CANTABRIA.PROVEEDOR (proveedor, nom_proveedor, flag_clie_prov, flag_estado)
  select 'CLI00001','Laive S.A.','2','1' from dual
   where not exists (select 1 from CANTABRIA.PROVEEDOR where proveedor = 'CLI00001');
commit;

-- Resultados de laboratorio: cultivo de mastitis de Estrella (propio) +
-- calidad de semen del semental (propio) + analisis de calidad de leche
-- hecho por el CLIENTE (Laive), que descuenta el costo de la factura de venta
insert into CANTABRIA.PC_LABORATORIO (nro_muestra, cod_origen, cod_animal, fec_muestra, flag_tipo_muestra, laboratorio, cod_veterinario, nro_evento, fec_resultado, flag_estado, flag_origen, cod_usr)
  values ('MU-00001','SU','SU00000005',TO_DATE('20/05/2026','DD/MM/YYYY'),'L','Laboratorio Veterinario San Martin','VET001',1,TO_DATE('22/05/2026','DD/MM/YYYY'),'2','P','DEMO01');
insert into CANTABRIA.PC_LABORATORIO_DET (lab_reckey, item, parametro, valor_resultado, flag_interpretacion)
  select reckey, 1, 'Cultivo microbiologico', 'Staphylococcus aureus', 'A' from CANTABRIA.PC_LABORATORIO where nro_muestra = 'MU-00001';
insert into CANTABRIA.PC_LABORATORIO_DET (lab_reckey, item, parametro, valor_resultado, unidad_medida, valor_ref_max, flag_interpretacion)
  select reckey, 2, 'Celulas somaticas', '850000', 'cel/ml', 200000, 'A' from CANTABRIA.PC_LABORATORIO where nro_muestra = 'MU-00001';

insert into CANTABRIA.PC_LABORATORIO (nro_muestra, cod_origen, cod_semental, fec_muestra, flag_tipo_muestra, laboratorio, fec_resultado, flag_estado, flag_origen, cod_usr)
  values ('MU-00002','SU','SEM0000001',TO_DATE('10/01/2026','DD/MM/YYYY'),'M','Central Genetica Peru',TO_DATE('12/01/2026','DD/MM/YYYY'),'2','P','DEMO01');
insert into CANTABRIA.PC_LABORATORIO_DET (lab_reckey, item, parametro, valor_resultado, unidad_medida, valor_ref_min, flag_interpretacion)
  select reckey, 1, 'Motilidad espermatica', '78', '%', 60, 'N' from CANTABRIA.PC_LABORATORIO where nro_muestra = 'MU-00002';
insert into CANTABRIA.PC_LABORATORIO_DET (lab_reckey, item, parametro, valor_resultado, unidad_medida, valor_ref_min, flag_interpretacion)
  select reckey, 2, 'Concentracion', '1200', 'millones/ml', 800, 'N' from CANTABRIA.PC_LABORATORIO where nro_muestra = 'MU-00002';

insert into CANTABRIA.PC_LABORATORIO (nro_muestra, cod_origen, fec_muestra, flag_tipo_muestra, laboratorio, fec_resultado, flag_estado, flag_origen, cod_cliente, costo_analisis, flag_facturado, observaciones, cod_usr)
  values ('MU-00003','SU',TO_DATE('03/07/2026','DD/MM/YYYY'),'L','Laive S.A.',TO_DATE('04/07/2026','DD/MM/YYYY'),'2','C','CLI00001',45.00,'1','Analisis de calidad de leche del lote entregado 03/07/2026, descontado de la factura de venta','DEMO01');
insert into CANTABRIA.PC_LABORATORIO_DET (lab_reckey, item, parametro, valor_resultado, unidad_medida, flag_interpretacion)
  select reckey, 1, 'Grasa', '3.7', '%', 'N' from CANTABRIA.PC_LABORATORIO where nro_muestra = 'MU-00003';
insert into CANTABRIA.PC_LABORATORIO_DET (lab_reckey, item, parametro, valor_resultado, unidad_medida, flag_interpretacion)
  select reckey, 2, 'Antibioticos (inhibidores)', 'Negativo', null, 'N' from CANTABRIA.PC_LABORATORIO where nro_muestra = 'MU-00003';
commit;

-- Movimiento de potrero (Estrella aislada por mastitis)
insert into CANTABRIA.PC_MOVIMIENTO_POTRERO (cod_origen, cod_animal, fec_movimiento, cod_potrero_origen, cod_potrero_destino, motivo, cod_usr)
  values ('SU','SU00000005',TO_DATE('10/05/2026','DD/MM/YYYY'),'POT001','POT002','Aislamiento por mastitis','DEMO01');
commit;

-- Movimiento de establo (Estrella entra al corral de cuarentena por la misma mastitis;
-- ilustra el historial de establos, independiente del historial de potreros)
insert into CANTABRIA.PC_MOVIMIENTO_ESTABLO (cod_origen, cod_animal, fec_movimiento, cod_establo_origen, cod_establo_destino, motivo, cod_usr)
  values ('SU','SU00000005',TO_DATE('20/05/2026','DD/MM/YYYY'),null,'EST002','Cuarentena por mastitis clinica','DEMO01');
commit;

-- Ciclo de vida completo: DTA + baja por venta de Estrella (mastitis cronica
-- recidivante). nro_ov y nro_dta son documentos EXTERNOS a este script
-- (Comercializacion y SENASA respectivamente) -- AJUSTAR antes de ejecutar.
insert into CANTABRIA.ORDEN_VENTA (cod_origen, nro_ov, cliente, monto_total)
  select 'SU','OV00000001','Camal Municipal San Martin S.A.C.',2800.00 from dual
   where not exists (select 1 from CANTABRIA.ORDEN_VENTA where nro_ov = 'OV00000001');
commit;
insert into CANTABRIA.PC_DTA (nro_dta, fec_emision, cod_origen_fundo, razon_social_destino, motivo, cod_usr)
  values ('DTA-2026-001',TO_DATE('01/07/2026','DD/MM/YYYY'),'SU','Camal Municipal San Martin S.A.C.','V','DEMO01');
insert into CANTABRIA.PC_DTA_DETALLE (dta_reckey, item, cod_animal)
  select reckey, 1, 'SU00000005' from CANTABRIA.PC_DTA where nro_dta = 'DTA-2026-001';
insert into CANTABRIA.PC_BAJA (cod_origen, cod_animal, fec_baja, flag_motivo, precio_venta, nro_ov, dta_reckey, observaciones, cod_usr)
  select 'SU', 'SU00000005', TO_DATE('01/07/2026','DD/MM/YYYY'), 'V', 2800.00, 'OV00000001', reckey, 'Vendida por descarte, mastitis cronica recidivante', 'DEMO01'
    from CANTABRIA.PC_DTA where nro_dta = 'DTA-2026-001';
commit;

-- ----------------------------------------------------------------------------
-- Escenario avicola (reproductoras -> postura -> incubacion -> lote de
-- engorde -> mortalidad), independiente del escenario bovino de arriba.
-- Ilustra que PC_LOTE es la unidad de manejo en avicola (no se registra
-- cada ave individualmente en PC_ANIMAL).
-- ----------------------------------------------------------------------------

-- Lote de reproductoras (Hy-Line Brown), sin potrero (galpon = establo)
insert into CANTABRIA.PC_LOTE (cod_origen, cod_lote, nom_lote, cod_categoria, fec_formacion, cantidad_cabezas_inicial, cantidad_cabezas_actual, cod_usr)
  values ('SU','LOT002','Reproductoras Hy-Line - Galpon 1','REP',TO_DATE('01/01/2026','DD/MM/YYYY'),500,500,'DEMO01');
commit;

-- Postura diaria del lote de reproductoras
insert into CANTABRIA.PC_POSTURA (cod_origen, cod_lote, fec_postura, cantidad_huevos, cantidad_descarte, cod_usr)
  values ('SU','LOT002',TO_DATE('01/06/2026','DD/MM/YYYY'),420,8,'DEMO01');
insert into CANTABRIA.PC_POSTURA (cod_origen, cod_lote, fec_postura, cantidad_huevos, cantidad_descarte, cod_usr)
  values ('SU','LOT002',TO_DATE('02/06/2026','DD/MM/YYYY'),435,5,'DEMO01');
commit;

-- Lote de engorde que se formara con los pollitos nacidos (se cierra el
-- vinculo de trazabilidad reproductoras -> incubacion -> engorde via
-- PC_INCUBACION.cod_lote_origen / cod_lote_destino)
insert into CANTABRIA.PC_LOTE (cod_origen, cod_lote, nom_lote, cod_categoria, fec_formacion, cantidad_cabezas_inicial, cantidad_cabezas_actual, cod_usr)
  values ('SU','LOT003','Pollos de engorde - Galpon 2','ENG',TO_DATE('22/06/2026','DD/MM/YYYY'),0,0,'DEMO01');
commit;

-- Carga de incubadora con los huevos aptos del 01-02/06 (847 = 420+435-8-5+5
-- ajustado a un numero redondo para el demo) y resultado de eclosion 21 dias despues
insert into CANTABRIA.PC_INCUBACION (cod_origen, cod_lote_origen, cod_establo, fec_carga, cantidad_huevos_cargados, fec_eclosion_prevista, fec_eclosion_real, cantidad_nacidos, cantidad_mermas, cod_lote_destino, flag_estado, cod_usr)
  values ('SU','LOT002','EST003',TO_DATE('02/06/2026','DD/MM/YYYY'),840,TO_DATE('23/06/2026','DD/MM/YYYY'),TO_DATE('23/06/2026','DD/MM/YYYY'),790,50,'LOT003','2','DEMO01');
commit;

-- La eclosion forma el lote de engorde: actualizar cantidad_cabezas del LOT003
-- (en produccion esto lo haria un trigger/proceso al cerrar la incubacion;
-- aqui se deja explicito para el demo)
update CANTABRIA.PC_LOTE set cantidad_cabezas_inicial = 790, cantidad_cabezas_actual = 790
 where cod_origen = 'SU' and cod_lote = 'LOT003';
commit;

-- Mortalidad registrada durante el engorde (primera semana, la mas critica)
insert into CANTABRIA.PC_LOTE_MORTALIDAD (cod_origen, cod_lote, fec_evento, cantidad_muertes, motivo, cod_usr)
  values ('SU','LOT003',TO_DATE('30/06/2026','DD/MM/YYYY'),12,'Estres termico primera semana','DEMO01');
commit;
-- TRG_PC_LOTEMORT_AI descuenta automaticamente: LOT003 queda en 778 cabezas.

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
