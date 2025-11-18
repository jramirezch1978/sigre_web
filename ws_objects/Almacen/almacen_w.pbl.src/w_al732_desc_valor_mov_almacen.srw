$PBExportHeader$w_al732_desc_valor_mov_almacen.srw
forward
global type w_al732_desc_valor_mov_almacen from w_report_smpl
end type
type cb_reporte from commandbutton within w_al732_desc_valor_mov_almacen
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al732_desc_valor_mov_almacen
end type
type sle_almacen from singlelineedit within w_al732_desc_valor_mov_almacen
end type
type sle_descrip from singlelineedit within w_al732_desc_valor_mov_almacen
end type
type st_2 from statictext within w_al732_desc_valor_mov_almacen
end type
type cb_procesar from commandbutton within w_al732_desc_valor_mov_almacen
end type
type cbx_1 from checkbox within w_al732_desc_valor_mov_almacen
end type
type hpb_1 from hprogressbar within w_al732_desc_valor_mov_almacen
end type
type st_progreso from statictext within w_al732_desc_valor_mov_almacen
end type
type st_left_time from statictext within w_al732_desc_valor_mov_almacen
end type
type cb_ciclo from commandbutton within w_al732_desc_valor_mov_almacen
end type
type cbx_proc_transf from checkbox within w_al732_desc_valor_mov_almacen
end type
type cbx_clases from checkbox within w_al732_desc_valor_mov_almacen
end type
type cb_clases from commandbutton within w_al732_desc_valor_mov_almacen
end type
type gb_fechas from groupbox within w_al732_desc_valor_mov_almacen
end type
type gb_1 from groupbox within w_al732_desc_valor_mov_almacen
end type
type gb_2 from groupbox within w_al732_desc_valor_mov_almacen
end type
end forward

global type w_al732_desc_valor_mov_almacen from w_report_smpl
integer width = 4791
integer height = 1740
string title = "[AL732] Descuadres de Valorizacion en Movimientos de Almacen"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
event ue_select_clases ( )
cb_reporte cb_reporte
uo_fecha uo_fecha
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cb_procesar cb_procesar
cbx_1 cbx_1
hpb_1 hpb_1
st_progreso st_progreso
st_left_time st_left_time
cb_ciclo cb_ciclo
cbx_proc_transf cbx_proc_transf
cbx_clases cbx_clases
cb_clases cb_clases
gb_fechas gb_fechas
gb_1 gb_1
gb_2 gb_2
end type
global w_al732_desc_valor_mov_almacen w_al732_desc_valor_mov_almacen

type variables

end variables

forward prototypes
public subroutine of_procesar ()
public subroutine of_proceso_ciclico ()
public function boolean of_retrieve_ds ()
end prototypes

event ue_select_clases();Date	ld_fecha1, ld_fecha2
str_parametros lstr_param

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

// Si es una salida x consumo interno
lstr_param.titulo    = 'Listado de Clases'
lstr_param.dw1			= 'd_lista_clases_tbl'
lstr_param.tipo		= '1D2D'
lstr_param.date1		= ld_fecha1
lstr_param.date2		= ld_fecha2
lstr_param.opcion    = 16


OpenWithParm( w_abc_seleccion, lstr_param)
end event

public subroutine of_procesar ();Long 		ll_row, ll_nro_am, ll_rows
String 	ls_org_am, ls_nro_Vale, ls_cod_art
Decimal	ldc_precio_real, ldc_tiempo, ldc_acum_tiempo, ldc_prom_tiempo, &
			ldc_time_left
DateTime	ldt_inicio, ldt_fin

try 
	hpb_1.visible = true
	
	ll_rows = dw_report.RowCount()
	
	if ll_rows = 0 then return
	
	ldc_acum_tiempo = 0
	
	for ll_row = 1 to ll_rows
		
		//Tomo la hora de inicio
		select sysdate
			into :ldt_inicio
		from dual;
		
		yield()
		
		ls_org_am 			= dw_report.object.org_am 						[ll_row]
		ll_nro_am 			= Long(dw_report.object.nro_am				[ll_row])
		ldc_precio_real 	= Dec(dw_report.object.precio_unit_real	[ll_row])
		ls_nro_Vale 		= dw_report.object.nro_Vale					[ll_row]
		ls_cod_art 			= dw_report.object.cod_art						[ll_row]
		
		yield()
		
		if ISNull(ls_org_am) or IsNull(ll_nro_am) or trim(ls_org_am) = '' then
			update articulo_mov am
				set am.precio_unit = :ldc_precio_real
			where am.nro_Vale 	= :ls_nro_Vale
			  and am.cod_art		= :ls_cod_Art
			  and am.flag_estado <> '0';
		else
			update articulo_mov am
				set am.precio_unit = :ldc_precio_real
			where am.cod_origen 	= :ls_org_am
			  and am.nro_mov		= :ll_nro_am
			  and am.flag_estado <> '0';
		end if
		
		if gnvo_app.of_existserror( SQLCA, "update ARTICULO_MOV") then 
			ROLLBACK;
			return
		end if
		
		commit;
		
		//Tomo la hora de fin
		select sysdate
			into :ldt_fin
		from dual;
		
		//Obtengo el promedio de tiempo
		select (:ldt_fin - :ldt_inicio) * 24 * 60 * 60
			into :ldc_tiempo
		from dual;
		
		ldc_acum_tiempo += ldc_tiempo
		ldc_prom_tiempo = ldc_acum_tiempo / ll_row
		
		//Obtengo el tiempo que queda
		ldc_time_left = (ll_rows - ll_row) * ldc_prom_tiempo
		
		yield()
		st_progreso.Text = "Procesando " + string(ll_row,"###,##0") + " de " &
							  + string(ll_rows,"###,##0") + ". Avance: " &
							  + string(ll_row / ll_rows * 100,"###,##0.00") + " %"
		
		hpb_1.Position = ll_row / ll_rows * 100
		
		st_left_time.Text = "Tiempo medio: " + string(ldc_prom_tiempo, "###0.0000") + " seg."
		
		if ldc_time_left > 0 then
			//Agrego el tiempo que queda, en dias, horas, minutos y segundos
			st_left_time.Text += " - " + gnvo_app.utilitario.of_left_time_to_string(ldc_time_left)
		end if
		
		yield()
		
	next
	
	


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage())
finally
	hpb_1.visible = false
end try


end subroutine

public subroutine of_proceso_ciclico ();Long 			ll_row, ll_nro_am, ll_rows, ll_ciclo
String 		ls_org_am, ls_nro_Vale, ls_cod_art, ls_flag_cierre_mes, ls_flag_almacen
Decimal		ldc_precio_real, ldc_tiempo, ldc_acum_tiempo, ldc_prom_tiempo, &
				ldc_time_left
DateTime		ldt_inicio, ldt_fin, ldt_inicio_ciclo, ldt_fin_ciclo, ldt_fec_registro
u_ds_base	lds_base
n_cst_wait	lnvo_wait

try 
	//Genero el datastore
	lnvo_Wait = create n_Cst_wait
	
	lds_base = create u_ds_base
	
//	if upper(gs_empresa) = 'SEAFROST' or upper(gs_empresa) = 'TEST_SEAFROST' then
//		lds_base.DataObject = 'd_rpt_precio_mov_seafrost_tbl'
//	else
//		lds_base.DataObject = 'd_rpt_precio_mov_cab'
//	end if
	
	lds_base.DataObject = 'd_rpt_precio_mov_seafrost_tbl'
	
	lds_base.SetTransobject( SQLCA )
	
	ll_ciclo = 1
	
	ldt_inicio_ciclo = gnvo_app.of_fecha_actual()
	lnvo_wait.of_mensaje("Procesando CICLO " + string(ll_ciclo))
	if not of_retrieve_ds() then return 
	lds_base.Retrieve()
	
	DO while lds_base.RowCount() > 0
		gnvo_app.of_add_mensaje_error( ll_ciclo, "of_procesa_ciclico()", classname(), &
												"Proceso Ciclo " + string(ll_ciclo) + " nro registros: " &
												+ string(lds_base.RowCount(), '###,##0'))
		
		hpb_1.visible = true
		
		ll_rows = lds_base.RowCount()
		
		if ll_rows = 0 then return
		
		ldc_acum_tiempo = 0
		
		for ll_row = 1 to ll_rows
			
			//Tomo la hora de inicio
			select sysdate
				into :ldt_inicio
			from dual;
			
			yield()
			
			ls_org_am 			= lds_base.object.org_am 							[ll_row]
			ll_nro_am 			= Long(lds_base.object.nro_am						[ll_row])
			ldc_precio_real 	= Dec(lds_base.object.precio_unit_real			[ll_row])
			ldt_fec_registro	= DateTime(lds_base.object.precio_unit_real	[ll_row])
			
			ls_nro_Vale 		= lds_base.object.nro_vale 				[ll_row]
			ls_cod_art 			= lds_base.object.cod_art 					[ll_row]
			
			select cc.flag_cierre_mes, cc.flag_almacen
        		into :ls_flag_cierre_mes, :ls_flag_almacen
        	from cntbl_cierre cc
       	where trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) = to_char(:ldt_fec_registro, 'yyyymm');
      
			update cntbl_cierre cc
				set cc.flag_almacen = '1',
					 cc.flag_cierre_mes = '1'
			 where trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) = to_char(:ldt_fec_registro, 'yyyymm');
				
			
			yield()
			
			if ISNull(ls_org_am) or IsNull(ll_nro_am) or trim(ls_org_am) = '' then
				update articulo_mov am
					set am.precio_unit = :ldc_precio_real
				where am.nro_Vale 	= :ls_nro_Vale
				  and am.cod_art		= :ls_cod_Art
				  and am.flag_estado <> '0';
			else
				update articulo_mov am
					set am.precio_unit = :ldc_precio_real
				where am.cod_origen 	= :ls_org_am
				  and am.nro_mov		= :ll_nro_am
				  and am.flag_estado <> '0';
			end if
			
			if gnvo_app.of_existserror( SQLCA, "update ARTICULO_MOV") then 
				ROLLBACK;
				return
			end if
			
			update cntbl_cierre cc
				set cc.flag_almacen = :ls_flag_almacen,
					 cc.flag_cierre_mes = :ls_flag_cierre_mes
			 where trim(to_char(cc.ano, '0000')) || trim(to_char(cc.mes, '00')) = to_char(:ldt_fec_registro, 'yyyymm');
			
			commit;
			
			//Tomo la hora de fin
			select sysdate
				into :ldt_fin
			from dual;
			
			//Obtengo el promedio de tiempo
			select (:ldt_fin - :ldt_inicio) * 24 * 60 * 60
				into :ldc_tiempo
			from dual;
			
			ldc_acum_tiempo += ldc_tiempo
			ldc_prom_tiempo = ldc_acum_tiempo / ll_row
			
			//Obtengo el tiempo que queda
			ldc_time_left = (ll_rows - ll_row) * ldc_prom_tiempo
			
			yield()
			st_progreso.Text = "Procesando " + string(ll_row,"###,##0") + " de " &
								  + string(ll_rows,"###,##0") + ". Avance: " &
								  + string(ll_row / ll_rows * 100,"###,##0.00") + " %"
			
			hpb_1.Position = ll_row / ll_rows * 100
			
			st_left_time.Text = "Tiempo medio: " + string(ldc_prom_tiempo, "###0.0000") + " seg."
			
			if ldc_time_left > 0 then
				//Agrego el tiempo que queda, en dias, horas, minutos y segundos
				st_left_time.Text += " - " + gnvo_app.utilitario.of_left_time_to_string(ldc_time_left)
			end if
			
			yield()
			
		next
		
		ldt_fin_ciclo = gnvo_app.of_fecha_Actual()
		
		//Obtengo el tiempo del ciclo
		select (:ldt_fin_ciclo - :ldt_inicio_ciclo) * 24 * 60 * 60
			into :ldc_tiempo
		from dual;
			
		gnvo_app.of_add_mensaje_error( ll_ciclo, "of_procesa_ciclico()", classname(), &
												"Terminado Ciclo " + string(ll_ciclo) + " Tiempo Total: " &
												+  gnvo_app.utilitario.of_time_to_string(ldc_tiempo))
		
		ll_ciclo ++
		ldt_inicio_ciclo = gnvo_app.of_fecha_actual()
		lnvo_wait.of_mensaje("Procesando CICLO " + string(ll_ciclo))
		if not of_retrieve_ds() then return 
		lds_base.Retrieve()
		
	LOOP

	
	
	


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage())
finally
	lnvo_wait.of_close()
	hpb_1.visible = false
	
	destroy lds_base
	destroy lnvo_wait
end try


end subroutine

public function boolean of_retrieve_ds ();string	ls_mensaje, ls_almacen, ls_flag_proc_transf
Date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return false
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if cbx_proc_transf.checked then
	ls_flag_proc_transf = '1'
else
	ls_flag_proc_transf = '0'
end if

//create or replace procedure USP_ALM_RPT_PRECIO_MOV(
//       asi_almacen          in almacen.almacen%TYPE,
//       adi_fecha1           in date,
//       adi_fecha2           in date,
//       asi_flag_only_transf in varchar2
//) is

DECLARE USP_ALM_RPT_PRECIO_MOV PROCEDURE FOR
	USP_ALM_RPT_PRECIO_MOV( :ls_almacen,
									:ld_fecha1,
									:ld_fecha2,
									:ls_flag_proc_transf);

EXECUTE USP_ALM_RPT_PRECIO_MOV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_RPT_PRECIO_MOV:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return false
END IF

CLOSE USP_ALM_RPT_PRECIO_MOV;

return true


	

end function

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al732_desc_valor_mov_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_reporte=create cb_reporte
this.uo_fecha=create uo_fecha
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cb_procesar=create cb_procesar
this.cbx_1=create cbx_1
this.hpb_1=create hpb_1
this.st_progreso=create st_progreso
this.st_left_time=create st_left_time
this.cb_ciclo=create cb_ciclo
this.cbx_proc_transf=create cbx_proc_transf
this.cbx_clases=create cbx_clases
this.cb_clases=create cb_clases
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_procesar
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.hpb_1
this.Control[iCurrent+9]=this.st_progreso
this.Control[iCurrent+10]=this.st_left_time
this.Control[iCurrent+11]=this.cb_ciclo
this.Control[iCurrent+12]=this.cbx_proc_transf
this.Control[iCurrent+13]=this.cbx_clases
this.Control[iCurrent+14]=this.cb_clases
this.Control[iCurrent+15]=this.gb_fechas
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
end on

on w_al732_desc_valor_mov_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.uo_fecha)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cb_procesar)
destroy(this.cbx_1)
destroy(this.hpb_1)
destroy(this.st_progreso)
destroy(this.st_left_time)
destroy(this.cb_ciclo)
destroy(this.cbx_proc_transf)
destroy(this.cbx_clases)
destroy(this.cb_clases)
destroy(this.gb_fechas)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje, ls_almacen, ls_flag_proc_transf
Date 		ld_fecha1, ld_fecha2
Long		ll_count

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if cbx_proc_transf.checked then
	ls_flag_proc_transf = '1'
else
	ls_flag_proc_transf = '0'
end if

if cbx_clases.checked then
	//Ingreso todas las clases
	delete tt_alm_seleccion;

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error al eliminar registros en la tabla tt_alm_seleccion. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if

	insert into tt_alm_seleccion(cod_clase)
	select distinct
				 ac.cod_clase
		from articulo_clase ac,
			  articulo       a,
			  vale_mov       vm,
			  articulo_mov   am
		where vm.nro_vale = am.nro_vale
		  and am.cod_art  = a.cod_art
		  and ac.cod_clase = a.cod_clase
		  and vm.flag_estado <> '0'
		  and am.flag_estado <> '0'
		  and trunc(vm.fec_registro) between trunc(:ld_fecha1) and trunc(:ld_fecha2)
		order by ac.cod_clase;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error al insertar el registro en la tabla tt_alm_seleccion. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
else
	select count(*)
		into :ll_count
	from tt_alm_seleccion;
	
	if ll_count = 0 then
		ROLLBACK;
		MEssageBox('Error', 'No ha seleccionado ninguna clase de ARTICULO, por favor corrija!', StopSign!)
		return
	end if
end if

//create or replace procedure USP_ALM_RPT_PRECIO_MOV(
//       asi_almacen          in almacen.almacen%TYPE,
//       adi_fecha1           in date,
//       adi_fecha2           in date,
//       asi_flag_only_transf in varchar2
//) is

DECLARE USP_ALM_RPT_PRECIO_MOV PROCEDURE FOR
	USP_ALM_RPT_PRECIO_MOV( :ls_almacen,
									:ld_fecha1,
									:ld_fecha2,
									:ls_flag_proc_transf);

EXECUTE USP_ALM_RPT_PRECIO_MOV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_RPT_PRECIO_MOV:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_ALM_RPT_PRECIO_MOV;


dw_report.visible = true
dw_report.retrieve()	

dw_report.object.t_fechas.text = string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' AL ' + string(ld_fecha2, 'dd/mm/yyyy')
dw_report.object.t_almacen.text = 'ALMACEN: ' + sle_descrip.text
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_ventana.text 	= this.classname( )
dw_report.Object.p_logo.filename = gs_logo

	

end event

event ue_open_pre;call super::ue_open_pre;//if upper(gs_empresa) = 'SEAFROST' or upper(gs_empresa) = 'TEST_SEAFROST' then
//	dw_report.DataObject = 'd_rpt_precio_mov_seafrost_tbl'
//else
//	dw_report.DataObject = 'd_rpt_precio_mov_cab'
//end if

//dw_report.setTransObject(SQLCA)

dw_report.Object.DataWindow.Print.Orientation = 1

ib_preview=false
this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al732_desc_valor_mov_almacen
integer x = 0
integer y = 312
integer width = 3429
integer height = 1128
string dataobject = "d_rpt_precio_mov_seafrost_tbl"
end type

type cb_reporte from commandbutton within w_al732_desc_valor_mov_almacen
integer x = 3141
integer width = 471
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Genera Reporte"
end type

event clicked;SetPointer(HourGlass!)

cb_procesar.enabled 	= false
cb_reporte.enabled 	= false
cb_ciclo.enabled 		= false

st_left_time.Text = ""
st_progreso.text = ""
Parent.Event ue_retrieve()

cb_procesar.enabled 	= true
cb_reporte.enabled 	= true
cb_ciclo.enabled 		= true

SetPointer(Arrow!)
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_al732_desc_valor_mov_almacen
event destroy ( )
integer x = 18
integer y = 60
integer taborder = 30
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type sle_almacen from singlelineedit within w_al732_desc_valor_mov_almacen
event dobleclick pbm_lbuttondblclk
integer x = 1015
integer y = 48
integer width = 224
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al732_desc_valor_mov_almacen
integer x = 1243
integer y = 48
integer width = 1157
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al732_desc_valor_mov_almacen
integer x = 709
integer y = 60
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_al732_desc_valor_mov_almacen
integer x = 3616
integer width = 471
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;setPointer(HourGlass!)

cb_reporte.enabled = false
cb_procesar.enabled = false
cb_ciclo.enabled 		= false

parent.of_procesar( )

cb_reporte.enabled = true
cb_procesar.enabled = true
cb_ciclo.enabled 		= true

setPointer(Arrow!)
end event

type cbx_1 from checkbox within w_al732_desc_valor_mov_almacen
integer x = 722
integer y = 136
integer width = 969
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type hpb_1 from hprogressbar within w_al732_desc_valor_mov_almacen
boolean visible = false
integer x = 3141
integer y = 228
integer width = 1499
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 10
end type

type st_progreso from statictext within w_al732_desc_valor_mov_almacen
integer x = 3141
integer y = 116
integer width = 1499
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_left_time from statictext within w_al732_desc_valor_mov_almacen
integer x = 3141
integer y = 172
integer width = 1499
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_ciclo from commandbutton within w_al732_desc_valor_mov_almacen
integer x = 4096
integer width = 471
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Proceso Ciclico"
end type

event clicked;setPointer(HourGlass!)

cb_reporte.enabled = false
cb_procesar.enabled = false
cb_ciclo.enabled 		= false

parent.of_proceso_ciclico( )

cb_reporte.enabled = true
cb_procesar.enabled = true
cb_ciclo.enabled 		= true

setPointer(Arrow!)
end event

type cbx_proc_transf from checkbox within w_al732_desc_valor_mov_almacen
integer x = 722
integer y = 208
integer width = 969
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Solo procesar transferencias Internas"
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type cbx_clases from checkbox within w_al732_desc_valor_mov_almacen
integer x = 2450
integer y = 60
integer width = 658
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos las clases de ART."
boolean checked = true
end type

event clicked;if this.checked then
	cb_clases.enabled = false
else
	cb_clases.enabled = true
end if
end event

type cb_clases from commandbutton within w_al732_desc_valor_mov_almacen
integer x = 2469
integer y = 160
integer width = 631
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "&Seleccionar las clases"
end type

event clicked;SetPointer(HourGlass!)

cb_procesar.enabled 	= false
cb_reporte.enabled 	= false
cb_ciclo.enabled 		= false

st_left_time.Text = ""
st_progreso.text = ""
Parent.Event ue_Select_clases()

cb_procesar.enabled 	= true
cb_reporte.enabled 	= true
cb_ciclo.enabled 		= true

SetPointer(Arrow!)
end event

type gb_fechas from groupbox within w_al732_desc_valor_mov_almacen
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_1 from groupbox within w_al732_desc_valor_mov_almacen
integer x = 2432
integer width = 704
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type gb_2 from groupbox within w_al732_desc_valor_mov_almacen
integer x = 677
integer width = 1746
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

