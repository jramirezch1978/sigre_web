-- ============================================================================
-- MODULO PECUARIO (PC_*) -- San Martin (Agro Industrial)
-- Compatible con Oracle 11g R2. Ejecutar como el usuario/esquema correspondiente
-- (ajustar el nombre de esquema si no es CANTABRIA -- buscar/reemplazar
-- "CANTABRIA." por el esquema de la empresa destino antes de correr).
--
-- Orden de creacion respeta dependencias de FK:
--   1) Catalogos (PC_RAZA, PC_POTRERO, PC_CATEGORIA, PC_SEMENTAL,
--      PC_PRODUCTO_SANITARIO, PC_ENFERMEDAD, PC_DIETA, PC_DIETA_COMPONENTE)
--   2) Maestro de animal (PC_ANIMAL)
--   3) Reproduccion (PC_CELO, PC_SERVICIO, PC_DIAGNOSTICO_PRENEZ, PC_PARTO)
--   4) Produccion de leche (PC_LACTANCIA, PC_ORDENO, PC_CONTROL_LECHERO)
--   5) Nutricion (PC_CONDICION_CORPORAL, PC_ALIMENTACION_CONSUMO)
--   6) Sanidad (PC_SANIDAD_EVENTO)
--   7) Resultados de laboratorio (PC_LABORATORIO, PC_LABORATORIO_DET)
--   8) Movimientos / trazabilidad / bajas (PC_MOVIMIENTO_POTRERO, PC_DTA,
--      PC_DTA_DETALLE, PC_BAJA)
--
-- NOTA: ARTICULO se asume ya existente (modulo Almacen). PC_DIETA_COMPONENTE
-- y PC_ALIMENTACION_CONSUMO referencian CANTABRIA.ARTICULO(cod_art).
--
-- NOTA SOBRE VENTANAS: las tablas usan el prefijo PC_* (Pecuario), pero las
-- VENTANAS PowerBuilder usan el prefijo real de Campo (CAM###), numeradas por
-- TIPO de opcion (igual regla que el resto del sistema): Tablas 000-299,
-- Operaciones 300-499, Consultas 500-699, Reportes 700-899, Procesos 900-999.
-- Bloques asignados a Pecuario (libres de colision con Campo/cana):
--   Tablas      CAM100-CAM106
--   Operaciones CAM440-CAM454
--   Consultas   CAM500-CAM505
--   Reportes    CAM800-CAM806
--   Procesos    CAM900-CAM905
-- Detalle completo: Source ERPs/metadata SIGRE/pecuario/pecuario_modulo_diseno.md
-- ============================================================================


-- ============================================================================
-- 1) CATALOGOS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_RAZA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_RAZA
(
  cod_raza      CHAR(4)       not null,
  nom_raza      VARCHAR2(60)  not null,
  flag_tipo     CHAR(1)       default 'L' not null,
  flag_estado   CHAR(1)       default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_RAZA
  add constraint PK_PC_RAZA primary key (cod_raza)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_RAZA
  add constraint CK_PC_RAZA_TIPO check (flag_tipo in ('L','C','M'));

comment on table CANTABRIA.PC_RAZA is 'Pecuario - Catalogo de razas bovinas';
comment on column CANTABRIA.PC_RAZA.cod_raza is 'codigo de raza';
comment on column CANTABRIA.PC_RAZA.nom_raza is 'nombre de la raza';
comment on column CANTABRIA.PC_RAZA.flag_tipo is 'L=Lechera, C=Carne, M=Doble proposito';
comment on column CANTABRIA.PC_RAZA.flag_estado is 'flag_estado';


-- ----------------------------------------------------------------------------
-- PC_POTRERO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_POTRERO
(
  cod_origen     CHAR(2)       not null,
  cod_potrero    CHAR(6)       not null,
  nom_potrero    VARCHAR2(80)  not null,
  area_has       NUMBER(8,2),
  tipo_pasto     VARCHAR2(60),
  capacidad_cab  NUMBER(6),
  flag_estado    CHAR(1)       default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_POTRERO
  add constraint PK_PC_POTRERO primary key (cod_origen, cod_potrero)
  using index tablespace CANTABRIA;

comment on table CANTABRIA.PC_POTRERO is 'Pecuario - Potreros/lotes de pastoreo por fundo';
comment on column CANTABRIA.PC_POTRERO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_POTRERO.cod_potrero is 'codigo de potrero';
comment on column CANTABRIA.PC_POTRERO.nom_potrero is 'nombre del potrero';
comment on column CANTABRIA.PC_POTRERO.area_has is 'area en hectareas';
comment on column CANTABRIA.PC_POTRERO.tipo_pasto is 'tipo de pasto';
comment on column CANTABRIA.PC_POTRERO.capacidad_cab is 'capacidad de carga en numero de cabezas';
comment on column CANTABRIA.PC_POTRERO.flag_estado is 'flag_estado';


-- ----------------------------------------------------------------------------
-- PC_CATEGORIA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CATEGORIA
(
  cod_categoria   CHAR(3)       not null,
  nom_categoria   VARCHAR2(60)  not null,
  flag_sexo       CHAR(1),
  edad_min_meses  NUMBER(4),
  edad_max_meses  NUMBER(4),
  flag_estado     CHAR(1)       default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_CATEGORIA
  add constraint PK_PC_CATEGORIA primary key (cod_categoria)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_CATEGORIA
  add constraint CK_PC_CATEGORIA_SEXO check (flag_sexo in ('M','H') or flag_sexo is null);

comment on table CANTABRIA.PC_CATEGORIA is 'Pecuario - Catalogo de categorias/etapas del animal';
comment on column CANTABRIA.PC_CATEGORIA.cod_categoria is 'codigo de categoria (TER, VAQ, NOV, VPR, VSC, VDE, TOR, TDE)';
comment on column CANTABRIA.PC_CATEGORIA.nom_categoria is 'nombre de la categoria';
comment on column CANTABRIA.PC_CATEGORIA.flag_sexo is 'M/H/null=ambos';
comment on column CANTABRIA.PC_CATEGORIA.edad_min_meses is 'edad minima en meses';
comment on column CANTABRIA.PC_CATEGORIA.edad_max_meses is 'edad maxima en meses';
comment on column CANTABRIA.PC_CATEGORIA.flag_estado is 'flag_estado';

-- Datos iniciales sugeridos
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo, edad_min_meses, edad_max_meses) values ('TER','Ternero(a)', null, 0, 3);
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo, edad_min_meses, edad_max_meses) values ('VAQ','Vaquillona de reemplazo','H', 3, 12);
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo, edad_min_meses, edad_max_meses) values ('NOV','Novilla / vaquillona de vientre','H', 12, 24);
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('VPR','Vaca en produccion','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('VSC','Vaca seca','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('VDE','Vaca de descarte','H');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('TOR','Toro reproductor','M');
insert into CANTABRIA.PC_CATEGORIA (cod_categoria, nom_categoria, flag_sexo) values ('TDE','Toro de descarte','M');
commit;


-- ----------------------------------------------------------------------------
-- PC_SEMENTAL
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_SEMENTAL
(
  cod_semental    CHAR(10)      not null,
  nom_semental    VARCHAR2(80)  not null,
  cod_raza        CHAR(4)       not null,
  proveedor       VARCHAR2(100),
  registro_genet  VARCHAR2(40),
  flag_estado     CHAR(1)       default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_SEMENTAL
  add constraint PK_PC_SEMENTAL primary key (cod_semental)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_SEMENTAL
  add constraint FK_PC_SEMENTAL_RAZA foreign key (cod_raza)
  references CANTABRIA.PC_RAZA(cod_raza);

comment on table CANTABRIA.PC_SEMENTAL is 'Pecuario - Catalogo de sementales/pajillas para inseminacion artificial';
comment on column CANTABRIA.PC_SEMENTAL.cod_semental is 'codigo del semental/pajilla';
comment on column CANTABRIA.PC_SEMENTAL.nom_semental is 'nombre del semental';
comment on column CANTABRIA.PC_SEMENTAL.cod_raza is 'raza del semental';
comment on column CANTABRIA.PC_SEMENTAL.proveedor is 'proveedor / central de inseminacion';
comment on column CANTABRIA.PC_SEMENTAL.registro_genet is 'registro genealogico / codigo de catalogo del proveedor';
comment on column CANTABRIA.PC_SEMENTAL.flag_estado is 'flag_estado';


-- ----------------------------------------------------------------------------
-- PC_PRODUCTO_SANITARIO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_PRODUCTO_SANITARIO
(
  cod_prod_san    CHAR(10)       not null,
  nom_producto    VARCHAR2(100)  not null,
  flag_tipo       CHAR(1)        not null,
  dias_refuerzo   NUMBER(4),
  periodo_retiro  NUMBER(3),
  unidad_medida   CHAR(3),
  flag_estado     CHAR(1)        default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_PRODUCTO_SANITARIO
  add constraint PK_PC_PRODUCTO_SANITARIO primary key (cod_prod_san)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_PRODUCTO_SANITARIO
  add constraint CK_PC_PRODSAN_TIPO check (flag_tipo in ('V','D','M','S'));

comment on table CANTABRIA.PC_PRODUCTO_SANITARIO is 'Pecuario - Catalogo de vacunas, medicamentos e insumos veterinarios';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.cod_prod_san is 'codigo de producto sanitario';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.nom_producto is 'nombre del producto';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.flag_tipo is 'V=Vacuna, D=Desparasitante, M=Medicamento, S=Suplemento';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.dias_refuerzo is 'dias hasta la proxima dosis de refuerzo (si aplica)';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.periodo_retiro is 'dias de retiro de leche/carne tras aplicar';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.unidad_medida is 'unidad de medida de la dosis';
comment on column CANTABRIA.PC_PRODUCTO_SANITARIO.flag_estado is 'flag_estado';


-- ----------------------------------------------------------------------------
-- PC_ENFERMEDAD
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ENFERMEDAD
(
  cod_enfermedad     CHAR(6)        not null,
  nom_enfermedad     VARCHAR2(100)  not null,
  flag_reproductiva  CHAR(1)        default '0',
  flag_estado        CHAR(1)        default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_ENFERMEDAD
  add constraint PK_PC_ENFERMEDAD primary key (cod_enfermedad)
  using index tablespace CANTABRIA;

comment on table CANTABRIA.PC_ENFERMEDAD is 'Pecuario - Catalogo de enfermedades/diagnosticos';
comment on column CANTABRIA.PC_ENFERMEDAD.cod_enfermedad is 'codigo de enfermedad';
comment on column CANTABRIA.PC_ENFERMEDAD.nom_enfermedad is 'nombre de la enfermedad';
comment on column CANTABRIA.PC_ENFERMEDAD.flag_reproductiva is 'afecta el ciclo reproductivo (1=si)';
comment on column CANTABRIA.PC_ENFERMEDAD.flag_estado is 'flag_estado';


-- ----------------------------------------------------------------------------
-- PC_DIETA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DIETA
(
  cod_dieta       CHAR(6)       not null,
  nom_dieta       VARCHAR2(80)  not null,
  cod_categoria   CHAR(3)       not null,
  costo_kg_prom   NUMBER(10,4),
  flag_estado     CHAR(1)       default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_DIETA
  add constraint PK_PC_DIETA primary key (cod_dieta)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_DIETA
  add constraint FK_PC_DIETA_CATEG foreign key (cod_categoria)
  references CANTABRIA.PC_CATEGORIA(cod_categoria);

comment on table CANTABRIA.PC_DIETA is 'Pecuario - Catalogo de dietas/raciones por categoria';
comment on column CANTABRIA.PC_DIETA.cod_dieta is 'codigo de dieta';
comment on column CANTABRIA.PC_DIETA.nom_dieta is 'nombre de la dieta';
comment on column CANTABRIA.PC_DIETA.cod_categoria is 'categoria de animal a la que aplica';
comment on column CANTABRIA.PC_DIETA.costo_kg_prom is 'costo promedio por kg, para costeo';
comment on column CANTABRIA.PC_DIETA.flag_estado is 'flag_estado';


-- ----------------------------------------------------------------------------
-- PC_DIETA_COMPONENTE (referencia ARTICULO del modulo Almacen)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DIETA_COMPONENTE
(
  cod_dieta       CHAR(6)        not null,
  item            NUMBER(3)      not null,
  cod_art         CHAR(12)       not null,
  cantidad_kg     NUMBER(8,3)    not null,
  flag_estado     CHAR(1)        default '1' not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_DIETA_COMPONENTE
  add constraint PK_PC_DIETA_COMPONENTE primary key (cod_dieta, item)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_DIETA_COMPONENTE
  add constraint FK_PC_DIETACOMP_DIETA foreign key (cod_dieta)
  references CANTABRIA.PC_DIETA(cod_dieta);

alter table CANTABRIA.PC_DIETA_COMPONENTE
  add constraint FK_PC_DIETACOMP_ART foreign key (cod_art)
  references CANTABRIA.ARTICULO(cod_art);

comment on table CANTABRIA.PC_DIETA_COMPONENTE is 'Pecuario - Detalle de insumos que componen cada dieta';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.cod_dieta is 'dieta a la que pertenece';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.item is 'item correlativo';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.cod_art is 'articulo de almacen (forraje/concentrado/mineral)';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.cantidad_kg is 'cantidad en kg por animal/dia';
comment on column CANTABRIA.PC_DIETA_COMPONENTE.flag_estado is 'flag_estado';


-- ============================================================================
-- 2) MAESTRO DE ANIMAL
-- ============================================================================

create table CANTABRIA.PC_ANIMAL
(
  cod_origen          CHAR(2)       not null,
  cod_animal          CHAR(12)      not null,
  nom_animal          VARCHAR2(60),
  cod_raza            CHAR(4)       not null,
  flag_sexo           CHAR(1)       not null,
  fec_nacimiento      DATE          not null,
  cod_animal_padre    CHAR(12),
  cod_animal_madre    CHAR(12),
  cod_semental_padre  CHAR(10),
  color               VARCHAR2(40),
  cod_categoria       CHAR(3)       not null,
  cod_potrero         CHAR(6)       not null,
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
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 256K
    next 256K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_ANIMAL
  add constraint PK_PC_ANIMAL primary key (cod_origen, cod_animal)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_ANIMAL
  add constraint CK_PC_ANIMAL_SEXO check (flag_sexo in ('M','H'));

alter table CANTABRIA.PC_ANIMAL
  add constraint CK_PC_ANIMAL_PROCED check (cod_procedencia in ('P','C'));

alter table CANTABRIA.PC_ANIMAL
  add constraint CK_PC_ANIMAL_EST_REPRO check (flag_estado_repro in ('0','1','2','3'));

alter table CANTABRIA.PC_ANIMAL
  add constraint FK_PC_ANIMAL_RAZA foreign key (cod_raza)
  references CANTABRIA.PC_RAZA(cod_raza);

alter table CANTABRIA.PC_ANIMAL
  add constraint FK_PC_ANIMAL_CATEG foreign key (cod_categoria)
  references CANTABRIA.PC_CATEGORIA(cod_categoria);

alter table CANTABRIA.PC_ANIMAL
  add constraint FK_PC_ANIMAL_POTRERO foreign key (cod_origen, cod_potrero)
  references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);

alter table CANTABRIA.PC_ANIMAL
  add constraint FK_PC_ANIMAL_SEMENTAL foreign key (cod_semental_padre)
  references CANTABRIA.PC_SEMENTAL(cod_semental);

-- Auto-referencias (genealogia): padre y madre son animales del mismo hato
alter table CANTABRIA.PC_ANIMAL
  add constraint FK_PC_ANIMAL_PADRE foreign key (cod_origen, cod_animal_padre)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_ANIMAL
  add constraint FK_PC_ANIMAL_MADRE foreign key (cod_origen, cod_animal_madre)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_ANIMAL is 'Pecuario - Maestro de ganado (animal individual)';
comment on column CANTABRIA.PC_ANIMAL.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_ANIMAL.cod_animal is 'arete/chapa oficial (identificacion fisica)';
comment on column CANTABRIA.PC_ANIMAL.nom_animal is 'apodo, opcional';
comment on column CANTABRIA.PC_ANIMAL.cod_raza is 'raza del animal';
comment on column CANTABRIA.PC_ANIMAL.flag_sexo is 'M=Macho, H=Hembra';
comment on column CANTABRIA.PC_ANIMAL.fec_nacimiento is 'fecha de nacimiento';
comment on column CANTABRIA.PC_ANIMAL.cod_animal_padre is 'FK genealogia - padre (si es del propio hato)';
comment on column CANTABRIA.PC_ANIMAL.cod_animal_madre is 'FK genealogia - madre (si es del propio hato)';
comment on column CANTABRIA.PC_ANIMAL.cod_semental_padre is 'FK a PC_SEMENTAL si el padre fue por inseminacion artificial';
comment on column CANTABRIA.PC_ANIMAL.color is 'color/marcas distintivas';
comment on column CANTABRIA.PC_ANIMAL.cod_categoria is 'categoria/etapa actual (se recalcula por edad/estado)';
comment on column CANTABRIA.PC_ANIMAL.cod_potrero is 'ubicacion actual (potrero)';
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


-- ============================================================================
-- 3) REPRODUCCION
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_CELO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CELO
(
  cod_origen        CHAR(2)   not null,
  cod_animal        CHAR(12)  not null,
  fec_celo          DATE      not null,
  hora_deteccion    DATE,
  metodo_deteccion  CHAR(1)   default 'V',
  flag_servido      CHAR(1)   default '0',
  cod_usr           CHAR(6),
  fec_registro      DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_CELO
  add constraint PK_PC_CELO primary key (cod_origen, cod_animal, fec_celo)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_CELO
  add constraint CK_PC_CELO_METODO check (metodo_deteccion in ('V','P','H'));

alter table CANTABRIA.PC_CELO
  add constraint FK_PC_CELO_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_CELO is 'Pecuario - Registro de detecciones de celo';
comment on column CANTABRIA.PC_CELO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_CELO.cod_animal is 'animal (hembra) en celo';
comment on column CANTABRIA.PC_CELO.fec_celo is 'fecha de deteccion del celo';
comment on column CANTABRIA.PC_CELO.hora_deteccion is 'hora exacta de deteccion';
comment on column CANTABRIA.PC_CELO.metodo_deteccion is 'V=Visual, P=Podometro/collar, H=Hormonal';
comment on column CANTABRIA.PC_CELO.flag_servido is '1 si este celo derivo en un servicio';
comment on column CANTABRIA.PC_CELO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_CELO.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_SERVICIO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_SERVICIO
(
  cod_origen          CHAR(2)   not null,
  cod_animal          CHAR(12)  not null,
  nro_servicio        NUMBER(3) not null,
  fec_servicio        DATE      not null,
  flag_tipo_servicio  CHAR(1)   not null,
  cod_animal_toro     CHAR(12),
  cod_semental        CHAR(10),
  cod_tecnico         CHAR(6),
  fec_prob_parto      DATE,
  flag_estado         CHAR(1)   default '1' not null,
  cod_usr             CHAR(6),
  fec_registro        DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_SERVICIO
  add constraint PK_PC_SERVICIO primary key (cod_origen, cod_animal, nro_servicio)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_SERVICIO
  add constraint CK_PC_SERVICIO_TIPO check (flag_tipo_servicio in ('N','I'));

alter table CANTABRIA.PC_SERVICIO
  add constraint FK_PC_SERVICIO_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_SERVICIO
  add constraint FK_PC_SERVICIO_TORO foreign key (cod_origen, cod_animal_toro)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_SERVICIO
  add constraint FK_PC_SERVICIO_SEMENTAL foreign key (cod_semental)
  references CANTABRIA.PC_SEMENTAL(cod_semental);

comment on table CANTABRIA.PC_SERVICIO is 'Pecuario - Registro de servicio (monta natural o inseminacion artificial)';
comment on column CANTABRIA.PC_SERVICIO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_SERVICIO.cod_animal is 'hembra servida';
comment on column CANTABRIA.PC_SERVICIO.nro_servicio is 'correlativo de servicios de este animal';
comment on column CANTABRIA.PC_SERVICIO.fec_servicio is 'fecha del servicio';
comment on column CANTABRIA.PC_SERVICIO.flag_tipo_servicio is 'N=Monta natural, I=Inseminacion artificial';
comment on column CANTABRIA.PC_SERVICIO.cod_animal_toro is 'toro del propio hato (si monta natural)';
comment on column CANTABRIA.PC_SERVICIO.cod_semental is 'semental/pajilla (si inseminacion artificial)';
comment on column CANTABRIA.PC_SERVICIO.cod_tecnico is 'responsable de la inseminacion';
comment on column CANTABRIA.PC_SERVICIO.fec_prob_parto is 'fecha probable de parto (fec_servicio + 283 dias)';
comment on column CANTABRIA.PC_SERVICIO.flag_estado is '1=vigente/en curso, 0=anulado (repitio celo, no prendio)';
comment on column CANTABRIA.PC_SERVICIO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_SERVICIO.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_DIAGNOSTICO_PRENEZ
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DIAGNOSTICO_PRENEZ
(
  cod_origen        CHAR(2)   not null,
  cod_animal        CHAR(12)  not null,
  nro_servicio      NUMBER(3) not null,
  fec_diagnostico   DATE      not null,
  metodo            CHAR(1)   default 'T',
  resultado         CHAR(1)   not null,
  dias_gestacion    NUMBER(3),
  cod_veterinario   CHAR(6),
  cod_usr           CHAR(6),
  fec_registro      DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ
  add constraint PK_PC_DIAGNOSTICO_PRENEZ primary key (cod_origen, cod_animal, nro_servicio, fec_diagnostico)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ
  add constraint CK_PC_DXPRE_METODO check (metodo in ('T','E'));

alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ
  add constraint CK_PC_DXPRE_RESULT check (resultado in ('P','V'));

alter table CANTABRIA.PC_DIAGNOSTICO_PRENEZ
  add constraint FK_PC_DXPRE_SERVICIO foreign key (cod_origen, cod_animal, nro_servicio)
  references CANTABRIA.PC_SERVICIO(cod_origen, cod_animal, nro_servicio);

comment on table CANTABRIA.PC_DIAGNOSTICO_PRENEZ is 'Pecuario - Diagnostico de prenez posterior al servicio';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_animal is 'animal diagnosticado';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.nro_servicio is 'FK al servicio que se esta confirmando';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.fec_diagnostico is 'fecha del diagnostico';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.metodo is 'T=Tacto rectal, E=Ecografia';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.resultado is 'P=Prenada, V=Vacia';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.dias_gestacion is 'dias de gestacion calculados';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_veterinario is 'veterinario responsable';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_DIAGNOSTICO_PRENEZ.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_PARTO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_PARTO
(
  cod_origen               CHAR(2)   not null,
  cod_animal               CHAR(12)  not null,
  fec_parto                DATE      not null,
  nro_servicio             NUMBER(3),
  flag_tipo_parto          CHAR(1)   default 'E',
  flag_asistido            CHAR(1)   default '0',
  cod_animal_cria          CHAR(12),
  sexo_cria                CHAR(1),
  peso_cria                NUMBER(6,2),
  flag_cria_viva           CHAR(1)   default '1',
  flag_retencion_placenta  CHAR(1)   default '0',
  observaciones            VARCHAR2(500),
  cod_veterinario          CHAR(6),
  cod_usr                  CHAR(6),
  fec_registro             DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_PARTO
  add constraint PK_PC_PARTO primary key (cod_origen, cod_animal, fec_parto)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_PARTO
  add constraint CK_PC_PARTO_TIPO check (flag_tipo_parto in ('E','D'));

alter table CANTABRIA.PC_PARTO
  add constraint FK_PC_PARTO_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_PARTO
  add constraint FK_PC_PARTO_SERVICIO foreign key (cod_origen, cod_animal, nro_servicio)
  references CANTABRIA.PC_SERVICIO(cod_origen, cod_animal, nro_servicio);

alter table CANTABRIA.PC_PARTO
  add constraint FK_PC_PARTO_CRIA foreign key (cod_origen, cod_animal_cria)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_PARTO is 'Pecuario - Registro de parto';
comment on column CANTABRIA.PC_PARTO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_PARTO.cod_animal is 'animal (madre) que pario';
comment on column CANTABRIA.PC_PARTO.fec_parto is 'fecha del parto';
comment on column CANTABRIA.PC_PARTO.nro_servicio is 'FK al servicio que origino este parto (si se conoce)';
comment on column CANTABRIA.PC_PARTO.flag_tipo_parto is 'E=Eutocico (normal), D=Distocico (con complicaciones)';
comment on column CANTABRIA.PC_PARTO.flag_asistido is 'parto asistido (1=si)';
comment on column CANTABRIA.PC_PARTO.cod_animal_cria is 'FK a PC_ANIMAL - la cria recien nacida';
comment on column CANTABRIA.PC_PARTO.sexo_cria is 'sexo de la cria';
comment on column CANTABRIA.PC_PARTO.peso_cria is 'peso de la cria al nacer en kg';
comment on column CANTABRIA.PC_PARTO.flag_cria_viva is '1=viva, 0=nacio muerta';
comment on column CANTABRIA.PC_PARTO.flag_retencion_placenta is '1=hubo retencion de placenta';
comment on column CANTABRIA.PC_PARTO.observaciones is 'observaciones del parto';
comment on column CANTABRIA.PC_PARTO.cod_veterinario is 'veterinario responsable';
comment on column CANTABRIA.PC_PARTO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_PARTO.fec_registro is 'fecha de registro en el sistema';


-- ============================================================================
-- 4) PRODUCCION DE LECHE
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_LACTANCIA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LACTANCIA
(
  cod_origen      CHAR(2)    not null,
  cod_animal      CHAR(12)   not null,
  nro_lactancia   NUMBER(2)  not null,
  fec_parto       DATE       not null,
  fec_secado      DATE,
  dias_lactancia  NUMBER(4),
  litros_totales  NUMBER(10,2),
  flag_estado     CHAR(1)    default '1' not null,
  cod_usr         CHAR(6),
  fec_registro    DATE       default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_LACTANCIA
  add constraint PK_PC_LACTANCIA primary key (cod_origen, cod_animal, nro_lactancia)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_LACTANCIA
  add constraint FK_PC_LACTANCIA_PARTO foreign key (cod_origen, cod_animal, fec_parto)
  references CANTABRIA.PC_PARTO(cod_origen, cod_animal, fec_parto);

comment on table CANTABRIA.PC_LACTANCIA is 'Pecuario - Periodos de lactancia (uno por parto)';
comment on column CANTABRIA.PC_LACTANCIA.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_LACTANCIA.cod_animal is 'vaca en lactancia';
comment on column CANTABRIA.PC_LACTANCIA.nro_lactancia is 'correlativo de lactancia de esta vaca (1ra, 2da, ...)';
comment on column CANTABRIA.PC_LACTANCIA.fec_parto is 'FK al parto que inicio esta lactancia';
comment on column CANTABRIA.PC_LACTANCIA.fec_secado is 'fecha de secado (cierre de la lactancia)';
comment on column CANTABRIA.PC_LACTANCIA.dias_lactancia is 'dias de lactancia, calculado al secar';
comment on column CANTABRIA.PC_LACTANCIA.litros_totales is 'litros acumulados, recalculado desde PC_ORDENO';
comment on column CANTABRIA.PC_LACTANCIA.flag_estado is '1=en curso, 0=cerrada (seca)';
comment on column CANTABRIA.PC_LACTANCIA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_LACTANCIA.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_ORDENO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ORDENO
(
  cod_origen      CHAR(2)   not null,
  cod_animal      CHAR(12)  not null,
  fec_ordeno      DATE      not null,
  nro_turno       NUMBER(1) not null,
  litros          NUMBER(6,2) not null,
  flag_descarte   CHAR(1)   default '0',
  cod_usr         CHAR(6),
  fec_registro    DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 512K
    next 512K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_ORDENO
  add constraint PK_PC_ORDENO primary key (cod_origen, cod_animal, fec_ordeno, nro_turno)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_ORDENO
  add constraint CK_PC_ORDENO_TURNO check (nro_turno in (1,2,3));

alter table CANTABRIA.PC_ORDENO
  add constraint FK_PC_ORDENO_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_ORDENO is 'Pecuario - Detalle diario de ordeno';
comment on column CANTABRIA.PC_ORDENO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_ORDENO.cod_animal is 'vaca ordenada';
comment on column CANTABRIA.PC_ORDENO.fec_ordeno is 'fecha del ordeno';
comment on column CANTABRIA.PC_ORDENO.nro_turno is '1=manana, 2=tarde, 3=noche';
comment on column CANTABRIA.PC_ORDENO.litros is 'litros obtenidos en este ordeno';
comment on column CANTABRIA.PC_ORDENO.flag_descarte is '1 si la leche no se vende (periodo de retiro por medicamento)';
comment on column CANTABRIA.PC_ORDENO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_ORDENO.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_CONTROL_LECHERO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CONTROL_LECHERO
(
  cod_origen         CHAR(2)   not null,
  cod_animal         CHAR(12)  not null,
  fec_control        DATE      not null,
  porc_grasa         NUMBER(4,2),
  porc_proteina      NUMBER(4,2),
  celulas_somaticas  NUMBER(10),
  litros_dia_proy    NUMBER(6,2),
  cod_usr            CHAR(6),
  fec_registro       DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_CONTROL_LECHERO
  add constraint PK_PC_CONTROL_LECHERO primary key (cod_origen, cod_animal, fec_control)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_CONTROL_LECHERO
  add constraint FK_PC_CTRLLECHE_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_CONTROL_LECHERO is 'Pecuario - Control lechero mensual (calidad de leche)';
comment on column CANTABRIA.PC_CONTROL_LECHERO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_CONTROL_LECHERO.cod_animal is 'vaca controlada';
comment on column CANTABRIA.PC_CONTROL_LECHERO.fec_control is 'fecha del muestreo';
comment on column CANTABRIA.PC_CONTROL_LECHERO.porc_grasa is 'porcentaje de grasa';
comment on column CANTABRIA.PC_CONTROL_LECHERO.porc_proteina is 'porcentaje de proteina';
comment on column CANTABRIA.PC_CONTROL_LECHERO.celulas_somaticas is 'conteo de celulas somaticas (CCS/SCC), celulas/ml';
comment on column CANTABRIA.PC_CONTROL_LECHERO.litros_dia_proy is 'litros/dia proyectados el dia del control';
comment on column CANTABRIA.PC_CONTROL_LECHERO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_CONTROL_LECHERO.fec_registro is 'fecha de registro en el sistema';


-- ============================================================================
-- 5) NUTRICION
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_CONDICION_CORPORAL
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_CONDICION_CORPORAL
(
  cod_origen      CHAR(2)     not null,
  cod_animal      CHAR(12)    not null,
  fec_evaluacion  DATE        not null,
  puntaje_bcs     NUMBER(2,1) not null,
  cod_usr         CHAR(6),
  fec_registro    DATE        default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_CONDICION_CORPORAL
  add constraint PK_PC_CONDICION_CORPORAL primary key (cod_origen, cod_animal, fec_evaluacion)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_CONDICION_CORPORAL
  add constraint CK_PC_BCS_RANGO check (puntaje_bcs between 1 and 5);

alter table CANTABRIA.PC_CONDICION_CORPORAL
  add constraint FK_PC_BCS_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_CONDICION_CORPORAL is 'Pecuario - Historico de condicion corporal (BCS)';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.cod_animal is 'animal evaluado';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.fec_evaluacion is 'fecha de evaluacion';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.puntaje_bcs is 'puntaje BCS, escala 1.0 a 5.0';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_CONDICION_CORPORAL.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_ALIMENTACION_CONSUMO (referencia ARTICULO del modulo Almacen)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_ALIMENTACION_CONSUMO
(
  cod_origen      CHAR(2)      not null,
  cod_potrero     CHAR(6)      not null,
  fec_consumo     DATE         not null,
  cod_dieta       CHAR(6)      not null,
  cabezas_lote    NUMBER(5)    not null,
  cod_art         CHAR(12)     not null,
  cantidad_kg     NUMBER(10,3) not null,
  costo_total     NUMBER(12,2),
  cod_usr         CHAR(6),
  fec_registro    DATE         default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 256K
    next 256K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_ALIMENTACION_CONSUMO
  add constraint PK_PC_ALIM_CONSUMO primary key (cod_origen, cod_potrero, fec_consumo, cod_dieta, cod_art)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_ALIMENTACION_CONSUMO
  add constraint FK_PC_ALIMCONS_POTRERO foreign key (cod_origen, cod_potrero)
  references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);

alter table CANTABRIA.PC_ALIMENTACION_CONSUMO
  add constraint FK_PC_ALIMCONS_DIETA foreign key (cod_dieta)
  references CANTABRIA.PC_DIETA(cod_dieta);

alter table CANTABRIA.PC_ALIMENTACION_CONSUMO
  add constraint FK_PC_ALIMCONS_ART foreign key (cod_art)
  references CANTABRIA.ARTICULO(cod_art);

comment on table CANTABRIA.PC_ALIMENTACION_CONSUMO is 'Pecuario - Consumo diario de alimento por potrero/lote';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_potrero is 'potrero/lote donde se dio el alimento';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.fec_consumo is 'fecha del consumo';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_dieta is 'dieta aplicada';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cabezas_lote is 'cantidad de animales que comieron esta dieta ese dia';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_art is 'insumo consumido (FK a ARTICULO)';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cantidad_kg is 'cantidad total consumida en kg';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.costo_total is 'costo total del consumo, para costeo de produccion';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_ALIMENTACION_CONSUMO.fec_registro is 'fecha de registro en el sistema';


-- ============================================================================
-- 6) SANIDAD
-- ============================================================================

create table CANTABRIA.PC_SANIDAD_EVENTO
(
  cod_origen         CHAR(2)   not null,
  cod_animal         CHAR(12)  not null,
  nro_evento         NUMBER(5) not null,
  fec_evento         DATE      not null,
  flag_tipo_evento   CHAR(1)   not null,
  cod_prod_san       CHAR(10),
  dosis              NUMBER(8,3),
  cod_enfermedad     CHAR(6),
  cod_veterinario    CHAR(6),
  costo              NUMBER(10,2),
  fec_prox_refuerzo  DATE,
  fec_fin_retiro     DATE,
  observaciones      VARCHAR2(500),
  cod_usr            CHAR(6),
  fec_registro       DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 256K
    next 256K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_SANIDAD_EVENTO
  add constraint PK_PC_SANIDAD_EVENTO primary key (cod_origen, cod_animal, nro_evento)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_SANIDAD_EVENTO
  add constraint CK_PC_SANIDAD_TIPO check (flag_tipo_evento in ('V','D','T','X'));

alter table CANTABRIA.PC_SANIDAD_EVENTO
  add constraint FK_PC_SANIDAD_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_SANIDAD_EVENTO
  add constraint FK_PC_SANIDAD_PROD foreign key (cod_prod_san)
  references CANTABRIA.PC_PRODUCTO_SANITARIO(cod_prod_san);

alter table CANTABRIA.PC_SANIDAD_EVENTO
  add constraint FK_PC_SANIDAD_ENFERM foreign key (cod_enfermedad)
  references CANTABRIA.PC_ENFERMEDAD(cod_enfermedad);

comment on table CANTABRIA.PC_SANIDAD_EVENTO is 'Pecuario - Eventos veterinarios (vacunas, desparasitaciones, tratamientos, diagnosticos)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_animal is 'animal atendido';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.nro_evento is 'correlativo de eventos sanitarios de este animal';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_evento is 'fecha del evento';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.flag_tipo_evento is 'V=Vacuna, D=Desparasitacion, T=Tratamiento, X=Diagnostico';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_prod_san is 'producto aplicado (vacuna/medicamento)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.dosis is 'dosis aplicada';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_enfermedad is 'enfermedad diagnosticada/tratada, si aplica';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_veterinario is 'veterinario responsable';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.costo is 'costo del evento';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_prox_refuerzo is 'fecha calculada de proximo refuerzo (segun producto)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_fin_retiro is 'fecha calculada de fin de periodo de retiro (leche/venta)';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.observaciones is 'observaciones del evento';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_SANIDAD_EVENTO.fec_registro is 'fecha de registro en el sistema';


-- ============================================================================
-- 7) RESULTADOS DE LABORATORIO
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_LABORATORIO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LABORATORIO
(
  nro_muestra       CHAR(12)   not null,
  cod_origen        CHAR(2)    not null,
  cod_animal        CHAR(12),
  cod_semental      CHAR(10),
  fec_muestra       DATE       not null,
  flag_tipo_muestra CHAR(1)    not null,
  laboratorio       VARCHAR2(100),
  cod_veterinario   CHAR(6),
  nro_evento        NUMBER(5),
  fec_resultado     DATE,
  flag_estado       CHAR(1)    default '1' not null,
  observaciones     VARCHAR2(500),
  cod_usr           CHAR(6),
  fec_registro      DATE       default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_LABORATORIO
  add constraint PK_PC_LABORATORIO primary key (nro_muestra)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_LABORATORIO
  add constraint CK_PC_LAB_TIPO_MUESTRA check (flag_tipo_muestra in ('S','L','F','M','T','O'));

alter table CANTABRIA.PC_LABORATORIO
  add constraint CK_PC_LAB_ESTADO check (flag_estado in ('0','1','2'));

alter table CANTABRIA.PC_LABORATORIO
  add constraint FK_PC_LAB_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_LABORATORIO
  add constraint FK_PC_LAB_SEMENTAL foreign key (cod_semental)
  references CANTABRIA.PC_SEMENTAL(cod_semental);

alter table CANTABRIA.PC_LABORATORIO
  add constraint FK_PC_LAB_SANIDAD foreign key (cod_origen, cod_animal, nro_evento)
  references CANTABRIA.PC_SANIDAD_EVENTO(cod_origen, cod_animal, nro_evento);

comment on table CANTABRIA.PC_LABORATORIO is 'Pecuario - Cabecera de muestras enviadas a laboratorio (sangre, leche, fecal, semen, tejido)';
comment on column CANTABRIA.PC_LABORATORIO.nro_muestra is 'numero de muestra (correlativo/codigo de laboratorio)';
comment on column CANTABRIA.PC_LABORATORIO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_LABORATORIO.cod_animal is 'animal muestreado (nulo si la muestra no es de un animal puntual, ej. forraje/agua)';
comment on column CANTABRIA.PC_LABORATORIO.cod_semental is 'semental analizado, si la muestra es de control de calidad de semen';
comment on column CANTABRIA.PC_LABORATORIO.fec_muestra is 'fecha de toma de la muestra';
comment on column CANTABRIA.PC_LABORATORIO.flag_tipo_muestra is 'S=Sangre, L=Leche, F=Fecal, M=Semen, T=Tejido/necropsia, O=Otro';
comment on column CANTABRIA.PC_LABORATORIO.laboratorio is 'laboratorio externo que proceso la muestra';
comment on column CANTABRIA.PC_LABORATORIO.cod_veterinario is 'veterinario que tomo la muestra';
comment on column CANTABRIA.PC_LABORATORIO.nro_evento is 'FK opcional a PC_SANIDAD_EVENTO, si la muestra es parte de un evento sanitario ya registrado';
comment on column CANTABRIA.PC_LABORATORIO.fec_resultado is 'fecha en que el laboratorio entrego el resultado';
comment on column CANTABRIA.PC_LABORATORIO.flag_estado is '0=Anulada, 1=Pendiente de resultado, 2=Con resultado';
comment on column CANTABRIA.PC_LABORATORIO.observaciones is 'observaciones de la muestra';
comment on column CANTABRIA.PC_LABORATORIO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_LABORATORIO.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_LABORATORIO_DET
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_LABORATORIO_DET
(
  nro_muestra        CHAR(12)      not null,
  item               NUMBER(3)     not null,
  parametro          VARCHAR2(100) not null,
  valor_resultado    VARCHAR2(60),
  unidad_medida      VARCHAR2(20),
  valor_ref_min      NUMBER(12,4),
  valor_ref_max      NUMBER(12,4),
  flag_interpretacion CHAR(1)
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_LABORATORIO_DET
  add constraint PK_PC_LABORATORIO_DET primary key (nro_muestra, item)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_LABORATORIO_DET
  add constraint CK_PC_LABDET_INTERP check (flag_interpretacion in ('N','A') or flag_interpretacion is null);

alter table CANTABRIA.PC_LABORATORIO_DET
  add constraint FK_PC_LABDET_MUESTRA foreign key (nro_muestra)
  references CANTABRIA.PC_LABORATORIO(nro_muestra);

comment on table CANTABRIA.PC_LABORATORIO_DET is 'Pecuario - Detalle de parametros/analitos resultantes de una muestra de laboratorio';
comment on column CANTABRIA.PC_LABORATORIO_DET.nro_muestra is 'muestra a la que pertenece';
comment on column CANTABRIA.PC_LABORATORIO_DET.item is 'item correlativo';
comment on column CANTABRIA.PC_LABORATORIO_DET.parametro is 'nombre del parametro/analito (ej. Brucelosis - ELISA, Motilidad espermatica, Huevos por gramo)';
comment on column CANTABRIA.PC_LABORATORIO_DET.valor_resultado is 'valor del resultado (texto, admite cualitativo Positivo/Negativo o numerico)';
comment on column CANTABRIA.PC_LABORATORIO_DET.unidad_medida is 'unidad de medida del resultado, si es numerico';
comment on column CANTABRIA.PC_LABORATORIO_DET.valor_ref_min is 'limite inferior del rango de referencia, si aplica';
comment on column CANTABRIA.PC_LABORATORIO_DET.valor_ref_max is 'limite superior del rango de referencia, si aplica';
comment on column CANTABRIA.PC_LABORATORIO_DET.flag_interpretacion is 'N=Normal, A=Alterado';


-- ============================================================================
-- 8) MOVIMIENTOS, TRAZABILIDAD Y BAJAS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- PC_MOVIMIENTO_POTRERO
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_MOVIMIENTO_POTRERO
(
  cod_origen           CHAR(2)   not null,
  cod_animal           CHAR(12)  not null,
  fec_movimiento       DATE      not null,
  cod_potrero_origen   CHAR(6),
  cod_potrero_destino  CHAR(6)   not null,
  motivo               VARCHAR2(200),
  cod_usr              CHAR(6),
  fec_registro         DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 256K
    next 256K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_MOVIMIENTO_POTRERO
  add constraint PK_PC_MOV_POTRERO primary key (cod_origen, cod_animal, fec_movimiento)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_MOVIMIENTO_POTRERO
  add constraint FK_PC_MOVPOT_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_MOVIMIENTO_POTRERO
  add constraint FK_PC_MOVPOT_POT_ORIG foreign key (cod_origen, cod_potrero_origen)
  references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);

alter table CANTABRIA.PC_MOVIMIENTO_POTRERO
  add constraint FK_PC_MOVPOT_POT_DEST foreign key (cod_origen, cod_potrero_destino)
  references CANTABRIA.PC_POTRERO(cod_origen, cod_potrero);

comment on table CANTABRIA.PC_MOVIMIENTO_POTRERO is 'Pecuario - Historico de cambios de potrero (rotacion de pastoreo)';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_animal is 'animal movido';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.fec_movimiento is 'fecha del movimiento';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_potrero_origen is 'potrero de origen';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_potrero_destino is 'potrero de destino';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.motivo is 'motivo del movimiento';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_MOVIMIENTO_POTRERO.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_DTA (Documento de Transito Animal)
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DTA
(
  nro_dta               CHAR(15)      not null,
  fec_emision           DATE          not null,
  cod_origen_fundo      CHAR(2)       not null,
  cod_destino_fundo     CHAR(2),
  razon_social_destino  VARCHAR2(150),
  motivo                CHAR(1)       not null,
  flag_estado           CHAR(1)       default '1' not null,
  cod_usr               CHAR(6),
  fec_registro          DATE          default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_DTA
  add constraint PK_PC_DTA primary key (nro_dta)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_DTA
  add constraint CK_PC_DTA_MOTIVO check (motivo in ('V','T','F'));

comment on table CANTABRIA.PC_DTA is 'Pecuario - Documento de Transito Animal (trazabilidad SENASA)';
comment on column CANTABRIA.PC_DTA.nro_dta is 'numero de DTA';
comment on column CANTABRIA.PC_DTA.fec_emision is 'fecha de emision';
comment on column CANTABRIA.PC_DTA.cod_origen_fundo is 'fundo de origen';
comment on column CANTABRIA.PC_DTA.cod_destino_fundo is 'fundo de destino (si es traslado interno)';
comment on column CANTABRIA.PC_DTA.razon_social_destino is 'razon social del destino (si es venta a un tercero)';
comment on column CANTABRIA.PC_DTA.motivo is 'V=Venta, T=Traslado interno, F=Feria/exposicion';
comment on column CANTABRIA.PC_DTA.flag_estado is 'flag_estado';
comment on column CANTABRIA.PC_DTA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_DTA.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- PC_DTA_DETALLE
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_DTA_DETALLE
(
  nro_dta      CHAR(15)  not null,
  item         NUMBER(4) not null,
  cod_origen   CHAR(2)   not null,
  cod_animal   CHAR(12)  not null
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 64K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_DTA_DETALLE
  add constraint PK_PC_DTA_DETALLE primary key (nro_dta, item)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_DTA_DETALLE
  add constraint FK_PC_DTADET_DTA foreign key (nro_dta)
  references CANTABRIA.PC_DTA(nro_dta);

alter table CANTABRIA.PC_DTA_DETALLE
  add constraint FK_PC_DTADET_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

comment on table CANTABRIA.PC_DTA_DETALLE is 'Pecuario - Animales incluidos en cada DTA';
comment on column CANTABRIA.PC_DTA_DETALLE.nro_dta is 'DTA al que pertenece';
comment on column CANTABRIA.PC_DTA_DETALLE.item is 'item correlativo';
comment on column CANTABRIA.PC_DTA_DETALLE.cod_origen is 'fundo/sucursal del animal';
comment on column CANTABRIA.PC_DTA_DETALLE.cod_animal is 'animal incluido en el traslado';


-- ----------------------------------------------------------------------------
-- PC_BAJA
-- ----------------------------------------------------------------------------
create table CANTABRIA.PC_BAJA
(
  cod_origen       CHAR(2)   not null,
  cod_animal       CHAR(12)  not null,
  fec_baja         DATE      not null,
  flag_motivo      CHAR(1)   not null,
  causa_muerte     VARCHAR2(200),
  precio_venta     NUMBER(12,2),
  nro_dta          CHAR(15),
  observaciones    VARCHAR2(300),
  cod_usr          CHAR(6),
  fec_registro     DATE      default sysdate
)
tablespace CANTABRIA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 128K
    next 128K
    minextents 1
    maxextents unlimited
  );

alter table CANTABRIA.PC_BAJA
  add constraint PK_PC_BAJA primary key (cod_origen, cod_animal)
  using index tablespace CANTABRIA;

alter table CANTABRIA.PC_BAJA
  add constraint CK_PC_BAJA_MOTIVO check (flag_motivo in ('V','M','D'));

alter table CANTABRIA.PC_BAJA
  add constraint FK_PC_BAJA_ANIMAL foreign key (cod_origen, cod_animal)
  references CANTABRIA.PC_ANIMAL(cod_origen, cod_animal);

alter table CANTABRIA.PC_BAJA
  add constraint FK_PC_BAJA_DTA foreign key (nro_dta)
  references CANTABRIA.PC_DTA(nro_dta);

comment on table CANTABRIA.PC_BAJA is 'Pecuario - Bajas del hato (venta, muerte o descarte)';
comment on column CANTABRIA.PC_BAJA.cod_origen is 'fundo/sucursal';
comment on column CANTABRIA.PC_BAJA.cod_animal is 'animal dado de baja';
comment on column CANTABRIA.PC_BAJA.fec_baja is 'fecha de la baja';
comment on column CANTABRIA.PC_BAJA.flag_motivo is 'V=Venta, M=Muerte, D=Descarte (infertil/enfermo/vejez)';
comment on column CANTABRIA.PC_BAJA.causa_muerte is 'causa de muerte, si flag_motivo=M';
comment on column CANTABRIA.PC_BAJA.precio_venta is 'precio de venta, si flag_motivo=V';
comment on column CANTABRIA.PC_BAJA.nro_dta is 'FK al DTA si la baja implico traslado';
comment on column CANTABRIA.PC_BAJA.observaciones is 'observaciones de la baja';
comment on column CANTABRIA.PC_BAJA.cod_usr is 'usuario que registro';
comment on column CANTABRIA.PC_BAJA.fec_registro is 'fecha de registro en el sistema';


-- ----------------------------------------------------------------------------
-- Trigger: al insertar una baja, desactivar el animal en PC_ANIMAL
-- ----------------------------------------------------------------------------
create or replace trigger CANTABRIA.TRG_PC_BAJA_AI
after insert on CANTABRIA.PC_BAJA
for each row
begin
  update CANTABRIA.PC_ANIMAL
     set flag_estado = '0'
   where cod_origen = :new.cod_origen
     and cod_animal = :new.cod_animal;
end;
/

commit;

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
