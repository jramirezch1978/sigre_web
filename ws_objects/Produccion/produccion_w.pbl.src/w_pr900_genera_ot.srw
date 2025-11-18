$PBExportHeader$w_pr900_genera_ot.srw
forward
global type w_pr900_genera_ot from w_abc
end type
type dw_almacen_miss from datawindow within w_pr900_genera_ot
end type
type tab_art from tab within w_pr900_genera_ot
end type
type tp_sal from userobject within tab_art
end type
type dw_sal from u_dw_abc within tp_sal
end type
type tp_sal from userobject within tab_art
dw_sal dw_sal
end type
type tp_ing from userobject within tab_art
end type
type dw_ing from u_dw_abc within tp_ing
end type
type tp_ing from userobject within tab_art
dw_ing dw_ing
end type
type tab_art from tab within w_pr900_genera_ot
tp_sal tp_sal
tp_ing tp_ing
end type
type dw_det from u_dw_abc within w_pr900_genera_ot
end type
type dw_ot from u_dw_abc within w_pr900_genera_ot
end type
end forward

global type w_pr900_genera_ot from w_abc
integer width = 3355
integer height = 2344
string title = "Generación de Orden de Trabajo(PR900) "
string menuname = "m_genera_ot"
windowstate windowstate = maximized!
event ue_genera_ot ( )
dw_almacen_miss dw_almacen_miss
tab_art tab_art
dw_det dw_det
dw_ot dw_ot
end type
global w_pr900_genera_ot w_pr900_genera_ot

type variables
datawindow idw_ing, idw_sal
integer ii_update

// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[], &
			is_tabla_d, is_colname_d[], is_coltype_d[]
			
n_cst_log_diario	in_log

end variables

forward prototypes
public subroutine wf_actualiza_fecha ()
end prototypes

event ue_genera_ot();string ls_flag_dias_inicio, ls_nro_orden, ls_cod_art, ls_cod_clase, ls_almacen, ls_cons_interno, ls_cod_dolares, ls_ing_prod, ls_cod_labor, ls_cnta_prsp_insm, ls_desc_labor, ls_desc_clase, ls_tipo_error, ls_nom_articulo
long ll_ot, ll_det, ll_sal, ll_ing, ll_det_row, ll_sal_row, ll_ing_row, ll_operacion
decimal ld_cantidad_producir, ld_cant_uit, ld_cant_tot, ld_costo_prom_dol, ld_costo_tot_dol, ld_cant_proy
delete from tt_pr_genera_ot_error;
dw_ot.accepttext( )

if this.ii_update = 0 then
	ls_nro_orden = dw_ot.object.nro_orden[dw_ot.getrow( )]
	messagebox(this.title, 'La Orden de Trabajo Nº ' + trim(ls_nro_orden) + ' ya ga sido generada', StopSign!)
	return
end if

select lp.oper_cons_interno, lp.oper_ing_prod , lp.cod_dolares
	into :ls_cons_interno, :ls_ing_prod, :ls_cod_dolares
	from logparam lp
	where lp.reckey = '1';

ll_ot = dw_ot.getrow( )
ll_det = dw_det.rowcount( )

if ll_ot < 1 or ll_det < 1 then return

ld_cantidad_producir = dw_ot.object.cantidad_producir[ll_ot]

dw_det.selectrow( 0 , false)
dw_det.setrow( 0 )
dw_det.scrolltorow( 0 )

for ll_det_row = 1 to ll_det
	dw_det.selectrow( 0, false )
	dw_det.setrow( ll_det_row )
	dw_det.scrolltorow( ll_det_row )
	dw_det.selectrow( ll_det_row, true )
	
	ls_flag_dias_inicio = dw_det.object.flag_dias_inicio[ll_det_row]
	ls_cod_labor = dw_det.object.cod_labor[ll_det_row]
	ll_operacion = dw_det.object.nro_operacion[ll_det_row]
	ll_sal = idw_sal.rowcount( )
	
	if ls_flag_dias_inicio = 'V' then
		ld_cant_proy = dw_det.object.cantidad[ll_det_row]
		if isnull(ld_cant_proy) then ld_cant_proy = 0
		dw_det.object.cantidad[ll_det_row] = ld_cant_proy * ld_cantidad_producir
	end if
	
	if ll_sal > 0 then
		
		for ll_sal_row = 1 to ll_sal
			
			ld_cant_uit = idw_sal.object.cant_unit[ll_sal_row]
			
			if isnull(ld_cant_uit) then ld_cant_uit = 0
			
			if ls_flag_dias_inicio = 'V' then
				ld_cant_tot = ld_cantidad_producir * ld_cant_uit
			else
				ld_cant_tot = ld_cant_uit
			end if
			
			if isnull(ld_cant_tot) then ld_cant_tot = 0.0000
			
			ls_cod_art = idw_sal.object.cod_art[ll_sal_row]
			
			select a.cod_clase 
			   into :ls_cod_clase
				from articulo a 
				where trim(a.cod_art) = trim(:ls_cod_art);
			
			select ac.desc_clase 
				into :ls_desc_clase
				from articulo_clase ac 
				where trim(ac.cod_clase) = trim(:ls_cod_clase);
			
			select alm.almacen 
			   into :ls_almacen
				from almacen_tacito alm 
				where trim(alm.cod_origen) = trim(:gs_origen)
				   and trim(alm.cod_clase) = trim(:ls_cod_clase);
					
			if sqlca.sqlcode <> 0 then
				setnull(ls_almacen)
				select l.desc_labor 
					into :ls_desc_labor 
					from labor l 
					where trim(l.cod_labor) = trim(:ls_cod_labor);
				
				if sqlca.sqlcode <> 0 then
					ls_desc_labor = ''
				end if
				
				select a.nom_articulo 
					into :ls_nom_articulo
					from articulo a
					where trim(a.cod_art) = trim(:ls_cod_art);
					
				ls_tipo_error = 'No se pudo obtener el almacén tácito ~rLos artículos sin almacén no son considerados en la O.T.'
				insert into tt_pr_genera_ot_error 
					(tipo_error, cod_clase, desc_clase, cod_labor, ls_desc_labor, operacion, cod_articulo, desc_articulo)
					values( :ls_tipo_error, :ls_cod_clase, :ls_desc_clase, :ls_cod_labor, :ls_desc_labor, :ll_operacion, :ls_cod_art, :ls_nom_articulo);

				dw_almacen_miss.VIsible = TRUE
				dw_almacen_miss.retrieve( )
			end if
			
			select nvl(max(aa.costo_ult_compra), 0)
			   into :ld_costo_prom_dol
			   from articulo_almacen aa 
				where trim(aa.cod_art) = trim(:ls_cod_art)
				   and trim(aa.almacen) = trim(:ls_almacen);
			
			if sqlca.sqlcode <> 0 or ld_costo_prom_dol <= 0 then
				select a.costo_ult_compra 
					into :ld_costo_prom_dol
					from articulo a 
					where trim(a.cod_art) = trim(:ls_cod_art); 
					
				if sqlca.sqlcode <> 0 or ld_costo_prom_dol <= 0 then
					select a.nom_articulo 
						into :ls_nom_articulo
						from articulo a
						where trim(a.cod_art) = trim(:ls_cod_art);
					ls_tipo_error = 'No se puede obtener el precio último precio de compra para los articulos de:'
					select l.desc_labor 
						into :ls_desc_labor 
						from labor l 
						where trim(l.cod_labor) = trim(:ls_cod_labor);

					if sqlca.sqlcode <> 0 then ls_desc_labor = ''

					insert into tt_pr_genera_ot_error 
						(tipo_error, cod_clase, desc_clase, cod_labor, ls_desc_labor, operacion, cod_articulo, desc_articulo)
						values( :ls_tipo_error, :ls_cod_clase, :ls_desc_clase, :ls_cod_labor, :ls_desc_labor, :ll_operacion, :ls_cod_art, :ls_nom_articulo);
					dw_almacen_miss.VIsible = TRUE
				end if
			end if
			
			select li.cnta_prsp_insm
				into :ls_cnta_prsp_insm
				from labor_insumo li
					where trim(li.cod_labor) = trim(:ls_cod_labor)
				      and trim(li.cod_art) = trim(:ls_cod_art);
			
			if idw_sal.object.cant_unit[ll_sal_row] <= 0 then
				ls_tipo_error = 'No se ha definido el ratio para los siguientes artículos:'
				select nvl(max(a.nom_articulo),'---- ARTICULO NO DEFINIDO ----')
						into :ls_nom_articulo
						from articulo a
						where trim(a.cod_art) = trim(:ls_cod_art);
				select nvl(max(l.desc_labor), '---- LABOR NO DEFINIDA ----')
						into :ls_desc_labor 
						from labor l 
						where trim(l.cod_labor) = trim(:ls_cod_labor);
				
				insert into tt_pr_genera_ot_error 
					(tipo_error, cod_clase, desc_clase, cod_labor, ls_desc_labor, operacion, cod_articulo, desc_articulo)
					values( :ls_tipo_error, :ls_cod_clase, :ls_desc_clase, :ls_cod_labor, :ls_desc_labor, :ll_operacion, :ls_cod_art, :ls_nom_articulo);
				dw_almacen_miss.VIsible = TRUE
			end if
			ld_costo_tot_dol = ld_cant_tot * ld_costo_prom_dol
			
			idw_sal.object.cant_tot[ll_sal_row] = ld_cant_tot
			idw_sal.object.costo_prom_unit[ll_sal_row] = ld_costo_prom_dol
			idw_sal.object.costo_prom_tot[ll_sal_row] = ld_costo_tot_dol
			idw_sal.object.almacen[ll_sal_row] = ls_almacen
			idw_sal.object.tipo_mov[ll_sal_row] = trim(ls_cons_interno)
			idw_sal.object.cod_moneda[ll_sal_row] = ls_cod_dolares
			idw_sal.object.cnta_prsp[ll_sal_row] = ls_cnta_prsp_insm

			idw_sal.update( )
			
		next
		
	end if
	
	ll_ing = idw_ing.rowcount( )
	
	if ll_ing > 0 then
		
		for ll_ing_row = 1 to ll_ing
			
			ld_cant_uit = idw_ing.object.cant_unit[ll_ing_row]
			
			if isnull(ld_cant_uit) then ld_cant_uit = 0
			
			if ls_flag_dias_inicio = 'V' then
				ld_cant_tot = ld_cantidad_producir * ld_cant_uit
			else
				ld_cant_tot = ld_cant_uit
			end if
			
			if isnull(ld_cant_tot) then ld_cant_tot = 0.0000
			
			ls_cod_art = idw_ing.object.cod_art[ll_ing_row]
			
			select a.cod_clase 
			   into :ls_cod_clase
				from articulo a 
				where trim(a.cod_art) = trim(:ls_cod_art);
			
			select alm.almacen 
			   into :ls_almacen
				from almacen_tacito alm 
				where trim(alm.cod_origen) = trim(:gs_origen)
				   and trim(alm.cod_clase) = trim(:ls_cod_clase);
			
			select nvl(max(aa.costo_ult_compra), 0)
			   into :ld_costo_prom_dol
			   from articulo_almacen aa 
				where trim(aa.cod_art) = trim(:ls_cod_art)
				   and trim(aa.almacen) = trim(:ls_almacen);
					
			select li.cnta_prsp_insm
				into :ls_cnta_prsp_insm
				from labor_insumo li
					where trim(li.cod_labor) = trim(:ls_cod_labor)
				      and trim(li.cod_art) = trim(:ls_cod_art);
					
			ld_costo_tot_dol = ld_cant_tot * ld_costo_prom_dol
			
			idw_ing.object.cant_tot[ll_ing_row] = ld_cant_tot
			idw_ing.object.costo_prom_unit[ll_ing_row] = ld_costo_prom_dol
			idw_ing.object.costo_prom_tot[ll_ing_row] = ld_costo_tot_dol
			idw_ing.object.almacen[ll_ing_row] = trim(ls_almacen)
			idw_ing.object.tipo_mov[ll_ing_row] = trim(ls_ing_prod)
			idw_ing.object.cod_moneda[ll_ing_row] = trim(ls_cod_dolares)
			idw_ing.object.cnta_prsp[ll_ing_row] = trim(ls_cnta_prsp_insm)

			idw_ing.update( )
			
		next
		
	end if
	
next

this.ii_update = 1

messagebox(this.title , 'Proceso Finalizado, pero aún no se ha~rgenerado la O.T.  Haga clic en el botón~rgrabar para concluir la operación', Exclamation!)
if dw_almacen_miss.retrieve( ) > 0 then
	dw_almacen_miss.visible = true
else
	dw_almacen_miss.visible = false
end if
end event

public subroutine wf_actualiza_fecha ();long ll_det, ll_row_det, ll_nro_personas, ll_nro_precedencia, ll_find
integer li_cant_dias
datetime ld_fec_preced
string ls_flag_pre

ll_det = dw_det.rowcount( )

for ll_row_det = 1 to ll_det
	setnull(ld_fec_preced)
	
	li_cant_dias = dw_det.object.dias_duracion[ll_row_det]
	ll_nro_personas = dw_det.object.nro_personas[ll_row_det]
	
	if isnull(li_cant_dias) then dw_det.object.dias_duracion[ll_row_det] = 0
	if isnull(ll_nro_personas) then dw_det.object.nro_personas[ll_row_det] = 0
	
 	if ll_row_det = 1 then
		dw_det.object.fec_pedido[ll_row_det] = dw_ot.object.fec_estimada[dw_ot.getrow()]
	else
		ls_flag_pre = dw_det.object.flag_pre[ll_row_det]
		ll_nro_precedencia = dw_det.object.nro_precedencia[ll_row_det]
		ll_find = dw_det.find("nro_operacion = " + string(ll_nro_precedencia), 1, dw_det.rowcount())
	
		if ll_find >= 1 then ld_fec_preced = dw_det.object.fec_pedido[ll_find]
		
		if isnull(ld_fec_preced) then
			select sysdate
				into :ld_fec_preced
				from dual;
		end if
		dw_det.setrow( ll_row_det )
		dw_det.scrolltorow( ll_row_det )
		dw_det.selectrow( 0, false)
		dw_det.selectrow( ll_row_det, true)
		if ls_flag_pre = 'F' then
			dw_det.object.fec_pedido[ll_row_det] = relativedate(date(ld_fec_preced), li_cant_dias)
		else
			dw_det.object.fec_pedido[ll_row_det] = ld_fec_preced
		end if
	end if
next
end subroutine

on w_pr900_genera_ot.create
int iCurrent
call super::create
if this.MenuName = "m_genera_ot" then this.MenuID = create m_genera_ot
this.dw_almacen_miss=create dw_almacen_miss
this.tab_art=create tab_art
this.dw_det=create dw_det
this.dw_ot=create dw_ot
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_almacen_miss
this.Control[iCurrent+2]=this.tab_art
this.Control[iCurrent+3]=this.dw_det
this.Control[iCurrent+4]=this.dw_ot
end on

on w_pr900_genera_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_almacen_miss)
destroy(this.tab_art)
destroy(this.dw_det)
destroy(this.dw_ot)
end on

event ue_open_pre;call super::ue_open_pre;string ls_sql, ls_return1, ls_return2, ls_return3, ls_nombre
long ll_inserted, ll_det , ll_operacion
datetime ldt_now

ib_log = TRUE
is_tabla_m = 'ORDEN_TRABAJO'
is_tabla_d = 'PLANT_PROD_OPER'

dw_almacen_miss.settransobject( sqlca )
this.ii_update = -1

idw_ing = tab_art.tp_ing.dw_ing
idw_sal = tab_art.tp_sal.dw_sal

dw_ot.settransobject( sqlca )
dw_det.settransobject( sqlca )
idw_sal.settransobject( sqlca )
idw_ing.settransobject( sqlca )

ll_inserted = dw_ot.insertrow( 0 )

if ll_inserted < 1 then
	messagebox(this.title, 'No se pudo insertar el nuevo registro para~rel lanzamiento de la Orden de Trabajo', StopSign!)
	return
end if

dw_ot.object.fec_solicitud[ll_inserted] = datetime(today(), time('00:00'))
dw_ot.object.fec_estimada[ll_inserted] = datetime(today(), time('00:00'))
dw_ot.object.fec_inicio[ll_inserted] = datetime(today(), time('00:00'))

select upper(u.nombre)
   into :ls_nombre
   from usuario u
   where trim(u.cod_usr) = trim(:gs_user);

dw_ot.object.cod_usr[ll_inserted] = gs_user
dw_ot.object.nombre[ll_inserted] = ls_nombre

select upper(o.nombre)
   into :ls_nombre
   from origen o
   where trim(o.cod_origen) = trim(:gs_origen);

dw_ot.object.cod_origen[ll_inserted] = gs_origen
dw_ot.object.origen_nombre[ll_inserted] = ls_nombre

select sysdate 
	into :ldt_now
	from dual;

dw_ot.object.fec_registro[ll_inserted] = ldt_now

ls_sql = "select ot_adm as codigo, descripcion as administracion, flag_ctrl_aprt_ot as control from vw_pr_ot_adm_usr where cod_usr = '" + gs_user + "'"
f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')
if isnull(ls_return1) or trim(ls_return1) = '' then return
dw_ot.object.ot_adm[ll_inserted] = ls_return1
dw_ot.object.descripcion[ll_inserted] = upper(ls_return2)
dw_ot.object.flag_ctrl_aprt_ot[ll_inserted] = ls_return3

ls_sql = "select cod_plantilla as codigo, desc_plantilla as plantilla from plant_prod where flag_estado = '1' and ot_adm = '" + ls_return1 + "'"
f_lista(ls_sql, ls_return1, ls_return2, '2')
if isnull(ls_return1) or trim(ls_return1) = '' then return
dw_ot.object.plant_ratio[ll_inserted] = ls_return1
dw_ot.object.desc_plantilla[ll_inserted] = upper(ls_return2)
dw_ot.object.descripcion_ot[ll_inserted] = upper(ls_return2)

ll_det = dw_det.retrieve(ls_return1)

wf_actualiza_fecha()


delete from tt_pr_gen_ot_art;

insert into tt_pr_gen_ot_art (cod_plantilla, nro_operacion, cod_art, nom_articulo, cant_unit, cant_tot, und, desc_unidad, flag_art)
   select ppm.cod_plantilla, ppm.nro_operacion, ppm.cod_art, a.nom_articulo, ppm.cantidad, 0.0000, a.und, u.desc_unidad, 'S'
      from plant_prod_mov ppm
         inner join articulo a on ppm.cod_art = a.cod_art
         inner join unidad u on a.und = u.und
      where trim(ppm.cod_plantilla) = trim(:ls_return1);

insert into tt_pr_gen_ot_art (cod_plantilla, nro_operacion, cod_art, nom_articulo, cant_unit, cant_tot, und, desc_unidad, flag_art)
   select ppm.cod_plantilla, ppm.nro_operacion, ppm.cod_art, a.nom_articulo, ppm.cantidad, 0.0000, a.und, u.desc_unidad, 'I'
      from plant_prod_mov_ingreso ppm
         inner join articulo a on ppm.cod_art = a.cod_art
         inner join unidad u on a.und = u.und
      where trim(ppm.cod_plantilla) = trim(:ls_return1);
		
commit using sqlca;

if ll_det >= 1 then
	dw_det.selectrow( 0, false)
	dw_det.setrow( 1 )
	dw_det.scrolltorow( 1 )
	dw_det.selectrow( 1, true)
	ll_operacion = dw_det.object.nro_operacion[1]
	idw_sal.retrieve(ls_return1, ll_operacion)
	idw_ing.retrieve(ls_return1, ll_operacion)
end if

ls_sql = "select cencos as codigo, desc_cencos as centro_costo from centros_costo where flag_estado = '1'"
f_lista(ls_sql, ls_return1, ls_return2, '2')
if isnull(ls_return1) or trim(ls_return1) = '' then return
dw_ot.object.cencos_rsp[ll_inserted] = ls_return1
dw_ot.object.desc_cencos_rsp[ll_inserted] = upper(ls_return2)
dw_ot.object.cencos_slc[ll_inserted] = ls_return1
dw_ot.object.desc_cencos_slc[ll_inserted] = upper(ls_return2)

end event

event resize;call super::resize;dw_ot.width  = newwidth  - dw_ot.x - 10
dw_det.width  = newwidth  - dw_det.x - 10
tab_art.width  = newwidth  - tab_art.x - 10
tab_art.height = newheight - tab_art.y - 10

idw_ing.width  = newwidth  - tab_art.x - 10
idw_ing.height = newheight - tab_art.y - 150

idw_sal.width  = newwidth  - tab_art.x - 10
idw_sal.height = newheight - tab_art.y - 150

end event

event ue_update;//override
boolean lbo_ok
long ll_ult_nro, ll_next_nro, ll_det_row, ll_det_tot, ll_oper_procesos, ll_new_oper_procesos
long ll_nro_operacion, ll_nro_precedencia, ll_nro_personas, ll_dias_inicio, ll_dias_holgura
long ll_dias_duracion_proy, ll_ot_row, ll_sal_tot, ll_ing_tot, ll_nro_mov_proy, ll_det_sal, ll_det_ing

string ls_nro_orden, ls_flag_estado, ls_cod_labor, ls_desc_operacion, ls_cod_ejecutor
string ls_oper_procesos, ls_flag_marcador, ls_und, ls_nro_oper_sec_preced, ls_tipo_doc
string ls_cod_art, ls_tipo_mov, ls_cencos, ls_cod_moneda, ls_cnta_prsp_insm, ls_almacen
string ls_tipo_ot

datetime ldt_fec_inicio, ldt_fec_inicio_estim, ldt_registro

decimal ld_cantidad, ld_costo_unitario, ld_cant_proyectada, ld_precio_unit

ll_ot_row = dw_ot.getrow( )
ll_det_tot = dw_det.rowcount( )
ll_sal_tot = idw_sal.rowcount( )
ll_ing_tot = idw_ing.rowcount( )

// Grabo el Log de la Cabecera
IF ib_log THEN
	u_ds_base		lds_log
	lds_log = Create u_ds_base
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_ot, lds_log, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
END IF

// Grabo el Log de detalle de parte de costos
IF ib_log THEN
	u_ds_base		lds_log_d
	lds_log_d = Create u_ds_base
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_det, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF


if this.ii_update = 0 then
	ls_nro_orden = dw_ot.object.nro_orden[ll_ot_row]
	messagebox(this.title, 'La Orden de Trabajo Nº ' + trim(ls_nro_orden) + ' ya ga sido generada', StopSign!)
	return
end if

if this.ii_update = -1 then
	messagebox(this.title, 'No se puede generar la Orden de Trabajo~rdebido a que usted no ha actualizado las~rcantidades pedidas por artículo', StopSign!)
	return
end if

ls_tipo_ot = dw_ot.object.ot_tipo[ll_ot_row]

if isnull(ls_tipo_ot) or trim(ls_tipo_ot) = '' then
	messagebox(this.title, 'No puede generar la O.T. mientras no seleccione el tipo')
	return
end if

select trim(lp.doc_ot)
	into :ls_tipo_doc
	from logparam lp 
	where lp.reckey  = '1';
	
///////////////////////////////////////////////////////////////////////////////////
//////////        A C T U A L I A C I O N   D E   C A B E C E R A        //////////
///////////////////////////////////////////////////////////////////////////////////

select n.ult_nro
   into :ll_ult_nro
	from num_ord_trab n
   where trim(n.origen) = trim(:gs_origen)
   for update
	nowait;
	
select sysdate
	into :ldt_registro
	from dual;
	
ll_next_nro = ll_ult_nro + 1
	
update num_ord_trab n
   set n.ult_nro = :ll_next_nro
	where trim(n.origen) = trim(:gs_origen);
	
ls_nro_orden = gs_origen + trim(string(ll_ult_nro, '00000000'))
ls_flag_estado = trim(dw_ot.object.flag_estado[ll_ot_row])
ldt_fec_inicio = dw_ot.object.fec_inicio[ll_ot_row]
ls_cencos = trim(dw_ot.object.cencos_slc[ll_ot_row])

dw_ot.object.nro_orden [ll_ot_row] = ls_nro_orden
dw_ot.object.titulo	  [ll_ot_row] = ls_nro_orden

dw_ot.accepttext( )

dw_ot.of_protect( )
dw_det.of_protect( )
idw_sal.enabled = false
idw_ing.enabled = false

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log_d
END IF

if dw_ot.update( ) = 1 then
	commit;
	messagebox(this.title, 'Se ha creado de manera satisfacria la Orden de Trabajo Nº ' + ls_nro_orden)
else
	messagebox(this.title, 'No se pudo grabar la Orden de Trabajo Nº ' + ls_nro_orden, StopSign!)
	rollback;
	return
end if

///////////////////////////////////////////////////////////////////////////////////
//////////      A C T U A L I A C I O N   D E   O P E R A C I O N E S    //////////
///////////////////////////////////////////////////////////////////////////////////

if ll_det_tot < 1 then
	messagebox(this.title, 'Se ha creado la Orden de Trabajo Nº ' + ls_nro_orden + ', pero no se le han creado operaciones')
	rollback using sqlca;
	return;
end if

dw_det.setsort( "nro_operacion ASC" )
dw_det.sort( )

for ll_det_row = 1 to ll_det_tot
	select nop.ult_nro 
		into :ll_oper_procesos
		from num_operaciones nop 
		where trim(nop.origen) = (:gs_origen)
		for update
		nowait;

	ll_new_oper_procesos = ll_oper_procesos + 1
	
	update num_operaciones nop 
		set nop.ult_nro = :ll_new_oper_procesos
		where trim(nop.origen) = (:gs_origen);

	ls_oper_procesos = trim(gs_origen) + trim(string(ll_oper_procesos, '00000000'))
	dw_det.object.oper_sec[ll_det_row] = ls_oper_procesos
	
	ll_nro_operacion = dw_det.object.nro_operacion[ll_det_row]
	ls_cod_labor = dw_det.object.cod_labor[ll_det_row]
	ls_cod_ejecutor = dw_det.object.cod_ejecutor[ll_det_row]
	ll_nro_precedencia = dw_det.object.nro_precedencia[ll_det_row]
	ll_nro_personas = dw_det.object.nro_personas[ll_det_row]
	ls_desc_operacion = dw_det.object.desc_operacion[ll_det_row]
	ll_dias_inicio = dw_det.object.nro_dias_inicio[ll_det_row]
	ll_dias_holgura = dw_det.object.dias_holgura[ll_det_row]
	ll_dias_duracion_proy = dw_det.object.dias_duracion[ll_det_row]
	ls_flag_marcador = dw_det.object.flag_marcador[ll_det_row]
	ls_und = dw_det.object.und[ll_det_row]
	
	if isnull(ll_dias_inicio) then ll_dias_duracion_proy = 0
	if isnull(ll_dias_holgura) then ll_dias_duracion_proy = 0
	if isnull(ll_dias_duracion_proy) then ll_dias_duracion_proy = 0
	
	//miguel martín calderon su nobrega
	if isnull(ll_nro_precedencia) then
		ldt_fec_inicio_estim = ldt_fec_inicio
		setnull(ls_nro_oper_sec_preced)
	else
		select max(o.oper_sec), trunc(max(o.fec_inicio_est)) + max(o.dias_duracion_proy)
			into :ls_nro_oper_sec_preced, :ldt_fec_inicio_estim
         from operaciones o 
         where trim(o.nro_orden) = trim(:ls_nro_orden)
		      and o.nro_operacion = :ll_nro_precedencia;
	end if
	//miguel martín calderon su nobrega
//	dw_det.object.fec_pedido[ll_det_row] = ldt_fec_inicio_estim
	
	ld_cantidad = dw_det.object.cantidad[ll_det_row]
	
	select le.costo_unitario 
		into :ld_costo_unitario
		from labor_ejecutor le 
		where le.cod_labor = trim(:ls_cod_labor)
		and le.cod_ejecutor = trim(:ls_cod_ejecutor);
   

	insert into operaciones (oper_sec, nro_operacion, cod_labor, cod_ejecutor, nro_oper_preced, 
			flag_estado, nro_personas, desc_operacion, dias_para_inicio, dias_holgura, 
			dias_duracion_proy, fec_inicio_est, cant_proyect, costo_unit, nro_orden, 
			tipo_orden, flag_marcador, nro_oper_sec_preced, avance_und, flag_replicacion)
		values (:ls_oper_procesos, :ll_nro_operacion, :ls_cod_labor, :ls_cod_ejecutor, :ll_nro_precedencia, 
			:ls_flag_estado, :ll_nro_personas, :ls_desc_operacion, :ll_dias_inicio, :ll_dias_holgura, 
			:ll_dias_duracion_proy, :ldt_fec_inicio_estim, :ld_cantidad, :ld_costo_unitario, :ls_nro_orden, 
			:ls_tipo_doc, :ls_flag_marcador, :ls_nro_oper_sec_preced, :ls_und, '1');
	
	commit using sqlca;
next

///////////////////////////////////////////////////////////////////////////////////
//////////       A C T U A L I A C I O N   D E   A R T I C U L O S       //////////
///////////////////////////////////////////////////////////////////////////////////

dw_det.setrow(0)

for ll_det_row = 1 to ll_det_tot
	
	dw_det.setrow( ll_det_row )
	dw_det.scrolltorow( ll_det_row )
	dw_det.selectrow( 0, false)
	dw_det.selectrow( ll_det_row, true)
	
	ls_oper_procesos = dw_det.object.oper_sec[ll_det_row]
	ldt_fec_inicio_estim = dw_det.object.fec_pedido[ll_det_row]
	ls_cod_labor = dw_det.object.cod_labor[ll_det_row]
	ll_sal_tot = idw_sal.rowcount( )
	ll_ing_tot = idw_ing.rowcount( )
	
	//graba los ingresosos a almacén
	
	IF ll_ing_tot > 0 THEN DEBUGBREAK()
	
	for ll_det_ing = 1 to ll_ing_tot
		select seq_alm_articulo_mov_proy.nextval 
		   into :ll_nro_mov_proy
			from dual;
		
		ls_cod_art = trim(idw_ing.object.cod_art[ll_det_ing])
		ls_tipo_mov  = trim(idw_ing.object.tipo_mov[ll_det_ing])
		ld_precio_unit = idw_ing.object.costo_prom_unit[ll_det_ing]
		ls_cod_moneda = trim(idw_ing.object.cod_moneda[ll_det_ing])
		ls_almacen = trim(idw_ing.object.almacen[ll_det_ing])
		ld_cant_proyectada = idw_ing.object.cant_tot[ll_det_ing]
		ls_cnta_prsp_insm = trim(idw_ing.object.cnta_prsp[ll_det_ing])
		
		if dw_ot.object.flag_ctrl_aprt_ot[dw_ot.getrow()] = '0' then
			ls_flag_estado = '1'
		else
			ls_flag_estado = '3'
		end if
		idw_ing.object.flag_procesado[ll_det_ing] = '1'
		
		insert into articulo_mov_proy (cod_origen, nro_mov, flag_estado, cod_art, tipo_mov, tipo_doc, 
				nro_doc, fec_registro, fec_proyect, cant_proyect, precio_unit, 
				cencos, cnta_prsp, origen_ref, oper_sec, flag_crg_inm_prsp, 
				flag_modificacion, fec_crg_prsp, flag_replicacion, flag_reservado, almacen, flag_ctrl_ret_alm)
			values(:gs_origen, :ll_nro_mov_proy, :ls_flag_estado, :ls_cod_art, :ls_tipo_mov, :ls_tipo_doc,
				:ls_nro_orden, :ldt_registro, :ldt_fec_inicio_estim, :ld_cant_proyectada, :ld_precio_unit,
				:ls_cencos, :ls_cnta_prsp_insm, :gs_origen, :ls_oper_procesos, '0',
				'1', :ldt_registro, '1', '0', :ls_almacen, '0');

		commit;
		
	next
	//graba las salidas de almacén
	for ll_det_sal = 1 to ll_sal_tot
		select seq_alm_articulo_mov_proy.nextval 
		   into :ll_nro_mov_proy
			from dual;
		
		ls_cod_art = trim(idw_sal.object.cod_art[ll_det_sal])
		ls_tipo_mov  = trim(idw_sal.object.tipo_mov[ll_det_sal])
		ld_precio_unit = idw_sal.object.costo_prom_unit[ll_det_sal]
		ls_cod_moneda = trim(idw_sal.object.cod_moneda[ll_det_sal])
		ls_almacen = trim(idw_sal.object.almacen[ll_det_sal])
		ld_cant_proyectada = idw_sal.object.cant_tot[ll_det_sal]
		ls_cnta_prsp_insm = trim(idw_sal.object.cnta_prsp[ll_det_sal])
		
		if dw_ot.object.flag_ctrl_aprt_ot[dw_ot.getrow()] = '0' then
			ls_flag_estado = '1'
		else
			ls_flag_estado = '3'
		end if
		idw_sal.object.flag_procesado[ll_det_sal] = '1'
		
		insert into articulo_mov_proy (cod_origen, nro_mov, flag_estado, cod_art, tipo_mov, tipo_doc, 
				nro_doc, fec_registro, fec_proyect, cant_proyect, precio_unit, 
				cencos, cnta_prsp, origen_ref, oper_sec, flag_crg_inm_prsp, 
				flag_modificacion, fec_crg_prsp, flag_replicacion, flag_reservado, almacen, flag_ctrl_ret_alm)
			values(:gs_origen, :ll_nro_mov_proy, :ls_flag_estado, :ls_cod_art, :ls_tipo_mov, :ls_tipo_doc,
				:ls_nro_orden, :ldt_registro, :ldt_fec_inicio_estim, :ld_cant_proyectada, :ld_precio_unit,
				:ls_cencos, :ls_cnta_prsp_insm, :gs_origen, :ls_oper_procesos, '0',
				'1', :ldt_registro, '1', '0', :ls_almacen, '0');

		commit;
		
	next
next

messagebox(this.title, 'Proceso de Generación de OT Concluido')
this.ii_update = 0

end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_ot, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_det, is_colname_d, is_coltype_d)
END IF
end event

event ue_close_pre;call super::ue_close_pre;If ib_log THEN
	DESTROY n_cst_log_diario
End If
end event

type dw_almacen_miss from datawindow within w_pr900_genera_ot
boolean visible = false
integer x = 165
integer y = 128
integer width = 3154
integer height = 1944
integer taborder = 30
boolean titlebar = true
string title = "Error al generar O.T."
string dataobject = "dw_genera_ot_error"
boolean controlmenu = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean border = false
string icon = "Error!"
boolean hsplitscroll = true
boolean livescroll = true
end type

event clicked;string ls_col
ls_col = lower(trim(string(dwo.name)))
choose case ls_col
	case 'cb_print'
		this.print( )
	case 'cb_close'
		this.visible = false
end choose
if row < 1 then return

this.selectrow( 0, false)
this.selectrow( row, true)
end event

type tab_art from tab within w_pr900_genera_ot
event create ( )
event destroy ( )
integer y = 1200
integer width = 3282
integer height = 780
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tp_sal tp_sal
tp_ing tp_ing
end type

on tab_art.create
this.tp_sal=create tp_sal
this.tp_ing=create tp_ing
this.Control[]={this.tp_sal,&
this.tp_ing}
end on

on tab_art.destroy
destroy(this.tp_sal)
destroy(this.tp_ing)
end on

type tp_sal from userobject within tab_art
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3246
integer height = 652
long backcolor = 79741120
string text = "Salidas del Almacén"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Inherit!"
long picturemaskcolor = 536870912
dw_sal dw_sal
end type

on tp_sal.create
this.dw_sal=create dw_sal
this.Control[]={this.dw_sal}
end on

on tp_sal.destroy
destroy(this.dw_sal)
end on

type dw_sal from u_dw_abc within tp_sal
integer width = 3241
integer height = 412
integer taborder = 20
string dataobject = "d_genera_ot_art_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'
end event

event itemchanged;call super::itemchanged;this.accepttext( )
string ls_col, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'almacen'
		select almacen, desc_almacen 
			into :ls_return1, :ls_return2
			from almacen 
			where flag_estado = '1' 
				and trim(cod_origen) = trim(:gs_origen)
				and trim(almacen) = trim(:data);
			
		if sqlca.sqlcode <> 0 then
			messagebox('(PR900) Generación de Orden de Trabajo', 'No se encontró el almacén ingresado')
			setnull(ls_return1)
		end if
		
		this.object.almacen[row] = ls_return1
		this.update( )
		return 2
end choose

this.update( )
end event

event doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'almacen'
		ls_sql = "select almacen as codigo, desc_almacen as nombre from almacen where flag_estado = '1' and cod_origen = '" + gs_origen + "'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.almacen[row] = ls_return1
end choose


end event

type tp_ing from userobject within tab_art
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3246
integer height = 652
long backcolor = 79741120
string text = "Ingresos a Almacén"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateLibrary!"
long picturemaskcolor = 536870912
dw_ing dw_ing
end type

on tp_ing.create
this.dw_ing=create dw_ing
this.Control[]={this.dw_ing}
end on

on tp_ing.destroy
destroy(this.dw_ing)
end on

type dw_ing from u_dw_abc within tp_ing
integer width = 3241
integer height = 412
integer taborder = 30
string dataobject = "d_genera_ot_art_ing_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'
end event

event itemchanged;call super::itemchanged;this.accepttext( )
this.update( )
end event

type dw_det from u_dw_abc within w_pr900_genera_ot
integer y = 728
integer width = 3259
integer height = 468
integer taborder = 20
string dataobject = "d_ot_genera_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'
end event

event rowfocuschanged;call super::rowfocuschanged;string ls_cod_plantilla
long ll_nro_operacion

idw_ing.reset( )

if currentrow < 1 then return

ls_cod_plantilla = this.object.cod_plantilla[currentrow]
ll_nro_operacion = this.object.nro_operacion[currentrow]

idw_sal.retrieve(ls_cod_plantilla, ll_nro_operacion)
idw_ing.retrieve(ls_cod_plantilla, ll_nro_operacion)
end event

type dw_ot from u_dw_abc within w_pr900_genera_ot
integer width = 3259
integer height = 720
string dataobject = "d_pr_genera_ot_ff"
end type

event constructor;call super::constructor;ii_ck[1] = 1
end event

event doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2, ls_return3, ls_ot_adm
long ll_det, ll_operacion

ls_col = trim(string(dwo.name))

choose case ls_col
	case 'cencos_rsp'
		ls_sql = "select cencos as codigo, desc_cencos as nombre from centros_costo where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cencos_rsp[row] = ls_return1
		this.object.desc_cencos_rsp[row] = ls_return2
		this.ii_update = 1
		
	case 'cencos_slc'
		ls_sql = "select cencos as codigo, desc_cencos as nombre from centros_costo where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.cencos_slc[row] = ls_return1
		this.object.desc_cencos_slc[row] = ls_return2
		this.ii_update = 1
		
	case 'plant_ratio'
		ls_ot_adm = this.object.ot_adm[row]
		if isnull(ls_ot_adm) or trim(ls_ot_adm) = '' then 
			messagebox(this.title, 'Primero debe ingresar la Adminstiración de OT respectiva')
			return
		end if
		ls_sql = "select cod_plantilla as codigo, desc_plantilla as plantilla from plant_prod where flag_estado = '1' and ot_adm = '" + ls_ot_adm + "'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.plant_ratio[row] = ls_return1
		this.object.desc_plantilla[row] = upper(ls_return2)
		
		delete from tt_pr_gen_ot_art;

		insert into tt_pr_gen_ot_art (cod_plantilla, nro_operacion, cod_art, nom_articulo, cant_unit, cant_tot, und, desc_unidad, flag_art)
		   select ppm.cod_plantilla, ppm.nro_operacion, ppm.cod_art, a.nom_articulo, ppm.cantidad, 0.0000, a.und, u.desc_unidad, 'S'
      	from plant_prod_mov ppm
         	inner join articulo a on ppm.cod_art = a.cod_art
	         inner join unidad u on a.und = u.und
   	   where trim(ppm.cod_plantilla) = trim(:ls_return1);

		parent.ii_update = -1
		
		dw_det.reset( )
		idw_ing.reset( )
		idw_sal.reset( )
		
		ll_det = dw_det.retrieve(ls_return1)

		if ll_det >= 1 then
			dw_det.selectrow( 0, false)
			dw_det.setrow( 1 )
			dw_det.scrolltorow( 1 )
			dw_det.selectrow( 1, true)
			ll_operacion = dw_det.object.nro_operacion[1]
			idw_sal.retrieve(ls_return1, ll_operacion)
			idw_ing.retrieve(ls_return1, ll_operacion)
		end if
		this.ii_update = 1
		
	case 'ot_adm'
		ls_sql = "select ot_adm as codigo, descripcion as administracion, flag_ctrl_aprt_ot as autorizacion from vw_pr_ot_adm_usr where cod_usr = '"+gs_user+"'"
		f_lista_3ret(ls_sql, ls_return1, ls_return2, ls_return3, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.ot_adm[row] = ls_return1
		this.object.descripcion[row] = ls_return2
		this.object.flag_ctrl_aprt_ot[row] = ls_return3
		this.ii_update = 1
		
	case 'responsable'
		ls_sql = "select cod_relacion as codigo, nombre as responsable from vw_tg_trabajador_origen where cod_origen = 'CN'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.responsable[row] = ls_return1
		this.object.responsable_nombre[row] = ls_return2
		this.ii_update = 1
end choose
end event

event itemchanged;call super::itemchanged;this.accepttext( )
string ls_col, ls_sql, ls_return1, ls_return2, ls_return3
long ll_det, ll_operacion

ls_col = trim(string(dwo.name))

choose case ls_col
	case 'cencos_rsp'
		select cencos, desc_cencos 
			into :ls_return1, :ls_return2
			from centros_costo 
			where flag_estado = '1'
				and trim(cencos) = trim(:data);
				
		if sqlca.sqlcode <> 0 then 
			messagebox(this.title, 'Centro de costo responsable incorrecto')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		this.object.cencos_rsp[row] = ls_return1
		this.object.desc_cencos_rsp[row] = ls_return2
		return 2
	case 'cencos_slc'
		select cencos, desc_cencos 
			into :ls_return1, :ls_return2
			from centros_costo 
			where flag_estado = '1'
				and trim(cencos) = trim(:data);
		if sqlca.sqlcode <> 0 then 
			messagebox(this.title, 'Centro de costo solicitante incorrecto')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		this.object.cencos_slc[row] = ls_return1
		this.object.desc_cencos_slc[row] = ls_return2
		return 2
	case 'plant_ratio'
		select cod_plantilla, desc_plantilla  
			into :ls_return1, :ls_return2
			from plant_prod 
			where flag_estado = '1'
				and trim(cod_plantilla) = trim(:data);
		if sqlca.sqlcode <> 0 then 
			messagebox(this.title, 'Plantilla incorrecto')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.plant_ratio[row] = ls_return1
		this.object.desc_plantilla[row] = upper(ls_return2)
		
		delete from tt_pr_gen_ot_art;

		insert into tt_pr_gen_ot_art (cod_plantilla, nro_operacion, cod_art, nom_articulo, cant_unit, cant_tot, und, desc_unidad, flag_art)
		   select ppm.cod_plantilla, ppm.nro_operacion, ppm.cod_art, a.nom_articulo, ppm.cantidad, 0.0000, a.und, u.desc_unidad, 'S'
      	from plant_prod_mov ppm
         	inner join articulo a on ppm.cod_art = a.cod_art
	         inner join unidad u on a.und = u.und
   	   where trim(ppm.cod_plantilla) = trim(:ls_return1);

		parent.ii_update = -1
		
		dw_det.reset( )
		idw_ing.reset( )
		idw_sal.reset( )
		
		ll_det = dw_det.retrieve(ls_return1)

		if ll_det >= 1 then
			dw_det.selectrow( 0, false)
			dw_det.setrow( 1 )
			dw_det.scrolltorow( 1 )
			dw_det.selectrow( 1, true)
			ll_operacion = dw_det.object.nro_operacion[1]
			idw_sal.retrieve(ls_return1, ll_operacion)
			idw_ing.retrieve(ls_return1, ll_operacion)
		end if
		return 2
	case 'ot_adm'
		select oa.ot_adm, oa.descripcion  
			into :ls_return1, :ls_return2
			from ot_administracion oa
         inner join ot_adm_usuario oau on oa.ot_adm = oau.ot_adm
      where trim(oau.cod_usr) = trim(:gs_user)
          and trim(oa.ot_adm) = trim(:data);
			
		if sqlca.sqlcode <> 0 then 
			messagebox(this.title, 'Admisnitración de OT incorrecta')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.ot_adm[row] = ls_return1
		this.object.descripcion[row] = ls_return2
		this.object.flag_ctrl_aprt_ot[row] = ls_return3
		return 2
	case 'responsable'
		select cod_relacion, nombre  
			into :ls_return1, :ls_return2
			from vw_tg_trabajador_origen 
			where cod_origen = 'CN'
				and trim(cod_relacion) = trim(:data);
		if sqlca.sqlcode <> 0 then 
			messagebox(this.title, 'Responsable incorrecto')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		this.object.responsable[row] = ls_return1
		this.object.responsable_nombre[row] = ls_return2
		return 2
	case 'fec_estimada'
		this.object.fec_inicio[row] = this.object.fec_estimada[row]
		parent.wf_actualiza_fecha( )
end choose
end event

