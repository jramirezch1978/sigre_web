$PBExportHeader$w_pr315_programa_produccion.srw
forward
global type w_pr315_programa_produccion from w_abc_master_smpl
end type
type cb_buscar from commandbutton within w_pr315_programa_produccion
end type
type uo_fechas from u_ingreso_rango_fechas within w_pr315_programa_produccion
end type
type st_1 from statictext within w_pr315_programa_produccion
end type
type st_rows from statictext within w_pr315_programa_produccion
end type
type cbx_categorias from checkbox within w_pr315_programa_produccion
end type
type sle_categoria from singlelineedit within w_pr315_programa_produccion
end type
type cb_categoria from commandbutton within w_pr315_programa_produccion
end type
type sle_desc_categoria from singlelineedit within w_pr315_programa_produccion
end type
type cbx_origenes from checkbox within w_pr315_programa_produccion
end type
type sle_origen from singlelineedit within w_pr315_programa_produccion
end type
type cb_3 from commandbutton within w_pr315_programa_produccion
end type
type sle_1 from singlelineedit within w_pr315_programa_produccion
end type
type gb_2 from groupbox within w_pr315_programa_produccion
end type
end forward

global type w_pr315_programa_produccion from w_abc_master_smpl
integer width = 4695
integer height = 2292
string title = "[PR315] Programa de producción"
string menuname = "m_mantto_smpl"
windowstate windowstate = maximized!
event ue_retrieve ( )
event ue_retrieve_hrs_row ( long al_row )
event ue_procesar ( )
cb_buscar cb_buscar
uo_fechas uo_fechas
st_1 st_1
st_rows st_rows
cbx_categorias cbx_categorias
sle_categoria sle_categoria
cb_categoria cb_categoria
sle_desc_categoria sle_desc_categoria
cbx_origenes cbx_origenes
sle_origen sle_origen
cb_3 cb_3
sle_1 sle_1
gb_2 gb_2
end type
global w_pr315_programa_produccion w_pr315_programa_produccion

type variables
integer 	ii_copia
String	is_partes[], is_null[]
string 	is_desc_turno, is_cod_trabajador, is_nombre, is_cod_tipo_mov, is_desc_movimi, &
		 	is_cod_origen, is_salir
datetime id_entrada, id_salida

//Tipo de OT de produccion 'PROD', 'REPR', 'RPQE', 'RECL'			 
String	is_ot_tipo_prod, is_ot_tipo_repr, is_ot_tipo_rpqe, is_ot_tipo_recl



n_Cst_wait					invo_Wait
n_Cst_utilitario 			invo_util
nvo_numeradores_varios	invo_nro

end variables

forward prototypes
public subroutine of_set_modify ()
public function boolean of_getparam ()
public function boolean of_valida_fecha (u_dw_abc adw_1)
public function boolean of_validar_registro (u_dw_abc adw_1)
end prototypes

event ue_retrieve;date 		ld_desde, ld_hasta
String 	ls_origen, ls_categorias

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

//para filtrar origenes
if cbx_origenes.checked then
	
	ls_origen = '%%'
	
else
	
	if trim(sle_origen.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar un ORIGEN")
		sle_origen.setFocus()
		return
	end if
	
	ls_origen = trim(sle_origen.text) + '%'

end if

//Categorias
if cbx_categorias.checked then
	ls_categorias = '%%'
else
	if trim(sle_categoria.text) = '' then
		gnvo_app.of_mensaje_error("Debe seleccionar una categoria")
		sle_categoria.setFocus()
		return
	end if
	
	ls_categorias = trim(sle_categoria.text) + '%'
end if



dw_master.Retrieve(ld_desde, ld_hasta, ls_origen, ls_categorias)

st_rows.text = string(dw_master.RowCount( ), "###,##0")

dw_master.ii_protect = 0
dw_master.of_protect()
end event

event ue_retrieve_hrs_row(long al_row);string 	ls_codtra, ls_turno, ls_tipo_mov
date		ld_fec_mov
decimal	ldc_hrs_diu_nor, ldc_hrs_diu_ext1, ldc_hrs_diu_ext2, &
			ldc_hrs_noc_nor, ldc_hrs_noc_ext1, ldc_hrs_noc_ext2
DateTime	ldt_fec_desde			

if al_row = 0 then return

ls_codtra 		= dw_master.object.cod_trabajador[al_row]
ld_fec_mov 		= Date(dw_master.object.fec_movim[al_row])
ldt_fec_desde 	= DateTime(dw_master.object.fec_desde[al_row])
ls_turno	 		= dw_master.object.turno			[al_row]
ls_tipo_mov 	= dw_master.object.cod_tipo_mov	[al_row]

select hor_diu_nor, HOR_EXT_DIU_1, HOR_EXT_DIU_2,
		 hor_noc_nor, HOR_EXT_noc_1, HOR_EXT_noc_2
into  :ldc_hrs_diu_nor, :ldc_hrs_diu_ext1, :ldc_hrs_diu_ext2, 
		:ldc_hrs_noc_nor, :ldc_hrs_noc_ext1, :ldc_hrs_noc_ext2		 
from asistencia
where cod_trabajador = :ls_codtra
  and fec_movim		= :ld_fec_mov
  and turno				= :ls_turno
  and cod_tipo_mov	= :ls_tipo_mov
  and fec_desde		= :ldt_fec_desde;

if SQLCA.SQLCode = 100 then
	ldc_hrs_diu_nor 	= 0
	ldc_hrs_diu_ext1 	= 0
	ldc_hrs_diu_ext2 	= 0
	ldc_hrs_noc_nor	= 0
	ldc_hrs_noc_ext1	= 0
	ldc_hrs_noc_ext2	= 0
end if

dw_master.object.hor_diu_nor	[al_row] = ldc_hrs_diu_nor
dw_master.object.hor_ext_diu_1[al_row] = ldc_hrs_diu_ext1
dw_master.object.hor_ext_diu_2[al_row] = ldc_hrs_diu_ext2
dw_master.object.hor_noc_nor	[al_row] = ldc_hrs_noc_nor
dw_master.object.hor_ext_noc_1[al_row] = ldc_hrs_noc_ext1
dw_master.object.hor_ext_noc_2[al_row] = ldc_hrs_noc_ext2


		 

end event

public subroutine of_set_modify ();//idw_1.Modify("trabajador.Background.Color ='" + string(RGB(255,0,0)) + " ~t If(isnull(idw_1.object.fec_desde) = ~~'C~~'')
end subroutine

public function boolean of_getparam ();try 
	
	//Obtengo los datos del Tipo de OT
	//is_ot_tipo_prod, is_ot_tipo_repr, is_ot_tipo_rpqe, is_ot_tipo_recl
	//'PROD', 'REPR', 'RPQE', 'RECL'
	
	is_ot_tipo_prod = gnvo_app.of_get_parametro('OPER_OT_TIPO_PRODUCCION', 'PROD')
	is_ot_tipo_repr = gnvo_app.of_get_parametro('OPER_OT_TIPO_REPROCESO', 'REPR')
	is_ot_tipo_rpqe = gnvo_app.of_get_parametro('OPER_OT_TIPO_REEMPAQUE', 'RPQE')
	is_ot_tipo_recl = gnvo_app.of_get_parametro('OPER_OT_TIPO_RECLASIFICACION', 'RECL')

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al obtener parametros de produccion')
	return false
	
finally
	
end try



return true
end function

public function boolean of_valida_fecha (u_dw_abc adw_1);Long 		ll_i, ll_row
string		ls_trabajador, ls_nombre
Boolean  ll_Result = True

ll_row = adw_1.RowCount()

if ll_row < 1 then Return ll_Result

For ll_i = 1 to ll_row
	  
	 if isnull(adw_1.object.fec_desde [ll_i]) or &
	    isnull(adw_1.object.fec_hasta [ll_i]) then
		 ll_Result = False
		 Messagebox('Aistencia','Existen Horas de Entrada o de Salida Sin definir. Porfavor Verifique', StopSign!)
		 Exit
	end if
next
		 
Return ll_Result
	 
end function

public function boolean of_validar_registro (u_dw_abc adw_1);Long 				ll_i, ll_count
string				ls_trabajador, ls_nombre, ls_cod_trabajador, ls_turno, ls_tipo_mov
Date				ld_fec_movim, ld_fec_desde
dwItemStatus 	ldis_status 

if adw_1.RowCount() < 1 then Return true

For ll_i = 1 to adw_1.RowCount()
	  
	ldis_status = adw_1.GetItemStatus(ll_i, 0, Primary!)

	if ldis_status = NewModified! or ldis_status = New! then
		//PK = COD_TRABAJADOR, FEC_MOVIM, TURNO, COD_TIPO_MOV, FEC_DESDE
		
		ls_cod_trabajador = adw_1.object.cod_trabajador 	[ll_i]
		ld_fec_movim 		= Date(adw_1.object.fec_movim 	[ll_i])
		ls_turno 				= adw_1.object.turno 				[ll_i]
		ls_tipo_mov			= adw_1.object.cod_tipo_mov		[ll_i]
		ld_fec_desde 		= Date(adw_1.object.fec_desde 	[ll_i])
		
	
		select count(*)
			into :ll_count
		from asistencia
		where cod_trabajador 		= :ls_cod_trabajador
			and trunc(fec_movim)	= trunc(:ld_fec_movim)
			and turno					= :ls_turno
			and cod_tipo_mov			= :ls_tipo_mov
			and trunc(fec_desde)	= trunc(:ld_fec_desde);
		
		if ll_count > 0 then
			Messagebox('Error','Registro ya ha sido registrado. Porfavor Verifique' &
						+ '~r~nCod Trabajador: ' + ls_cod_trabajador &
						+ '~r~nFec. Movim: ' + string(ld_fec_movim, 'dd/mm/yyyy') &
						+ '~r~nTurno: ' + ls_turno &
						+ '~r~nTipo Mov.: ' + ls_tipo_mov &
						+ '~r~nFec. Desde: ' + string(ld_fec_desde, 'dd/mm/yyyy')	, StopSign!)
		 	return false
		end if
	end if
next
		 
Return true
	 
end function

on w_pr315_programa_produccion.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.st_1=create st_1
this.st_rows=create st_rows
this.cbx_categorias=create cbx_categorias
this.sle_categoria=create sle_categoria
this.cb_categoria=create cb_categoria
this.sle_desc_categoria=create sle_desc_categoria
this.cbx_origenes=create cbx_origenes
this.sle_origen=create sle_origen
this.cb_3=create cb_3
this.sle_1=create sle_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_rows
this.Control[iCurrent+5]=this.cbx_categorias
this.Control[iCurrent+6]=this.sle_categoria
this.Control[iCurrent+7]=this.cb_categoria
this.Control[iCurrent+8]=this.sle_desc_categoria
this.Control[iCurrent+9]=this.cbx_origenes
this.Control[iCurrent+10]=this.sle_origen
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.sle_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_pr315_programa_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.st_1)
destroy(this.st_rows)
destroy(this.cbx_categorias)
destroy(this.sle_categoria)
destroy(this.cb_categoria)
destroy(this.sle_desc_categoria)
destroy(this.cbx_origenes)
destroy(this.sle_origen)
destroy(this.cb_3)
destroy(this.sle_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

if not this.of_getparam() then
	post event close()
	
	return
end if

ii_lec_mst = 0

invo_nro = create nvo_numeradores_varios
invo_wait = create n_cst_wait

end event

event ue_update_pre;call super::ue_update_pre;	
ib_update_check = false

if gnvo_app.of_row_processing( dw_master ) = false then return

dw_master.of_set_flag_replicacion( )

ib_update_check = true




end event

event ue_update;//Override

Boolean  lbo_ok = TRUE
String	ls_msg
Date		ld_fecha1, ld_fecha2
Long		ll_i

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_Create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ResetUpdate()
	
	f_mensaje("Cambios guardados satisfactoriamente", "")
END IF

end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_query_retrieve;//Override
this.event ue_retrieve( )
end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_master, ls_file )
End If
end event

event close;call super::close;destroy invo_nro
destroy invo_wait
end event

event ue_delete;//Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_anular;call super::ue_anular;dw_master.event ue_Anular()
end event

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr315_programa_produccion
event ue_display ( string as_columna,  long al_row )
event ue_print_cus ( long al_row )
event ue_print_pallet ( long al_row )
integer y = 352
integer width = 4123
integer height = 1112
string dataobject = "d_abc_programa_produccion_tbl"
end type

event dw_master::ue_print_cus(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen, ls_nro_vale_ing, ls_nro_pallet
Integer			li_print_size
try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	//Corresponde a un almacen de Productos Terminados
	li_print_size 		= gnvo_app.of_get_print_size( )
	
	if li_print_size < 0 then return
	
	if li_print_size = 1 then
		lstr_rep.dw1 		= 'd_rpt_codigos_cu_pptt_lbl'
	else
		lstr_rep.dw1 		= 'd_rpt_codigos_cu2_pptt_lbl'
	end if
	
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_parte	[al_row]
	lstr_rep.tipo		= '2'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::ue_print_pallet(long al_row);// vista previa de mov. almacen
str_parametros lstr_rep
String			ls_tipo_almacen, ls_nro_pallet, ls_nro_vale_ing

try 
	
	if dw_master.rowcount() = 0 then return
	
	if dw_master.ii_update = 1 then
		MessageBox('Error', 'Hay cambios pendientes, debe guardarlos antes de imprimir', StopSign!)
		return
	end if
	
	//Valido que el registro tenga pallet y tambien tenga vale de Ingreso
	ls_nro_pallet 		= this.object.nro_pallet		[al_row]
	ls_nro_vale_ing 	= this.object.nro_vale_ing		[al_row]
	
	if IsNull(ls_nro_pallet) or trim(ls_nro_pallet) = '' then
		MessageBox('Error', 'NO puede imprimir los Codigo CU de este registro porque no tiene asignado un Nro de Pallet, por favor corrija', StopSign!)
		return
	end if

	if IsNull(ls_nro_vale_ing) or trim(ls_nro_vale_ing) = '' then
		MessageBox('Error', 'NO puede imprimir los Codigo CU de este registro porque no VALE DE INGRESO, por favor corrija', StopSign!)
		return
	end if

	//Corresponde a un almacen de Productos Terminados
	lstr_rep.dw1 		= 'd_rpt_codigos_pallet_pptt_lbl'
	lstr_rep.titulo 	= 'Previo de Códigos Unicos de CAJA'
	lstr_rep.string1 	= dw_master.object.nro_pallet	[al_row]
	lstr_rep.tipo		= '3'
	lstr_rep.dw_m		= dw_master

		
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
		
	


catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, "Error al generar reporte de movimiento de almacen")
end try
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = lower(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_anular;call super::ue_anular;String	ls_nro_Parte, ls_mensaje
Long		ll_find
if this.rowCount() = 0 then return

if this.object.flag_estado [this.getRow()] = '0' then 
	gnvo_app.of_mensaje_Error("No se puede anular el parte de empaque porque esta anulado")
	return
end if

ls_nro_parte = this.object.nro_parte [this.getRow()]

if MessageBox('PRODUCCIÓN','¿Esta seguro de ANULAR el Parte de Empaque ' + ls_nro_parte + ' esta operacion?',Question!,yesno!) = 2 then
		return
End if

//begin
//  -- Call the procedure
//  pkg_produccion.sp_anular_parte_empaque(asi_nro_parte => :asi_nro_parte);
//end;
DECLARE 	sp_anular_parte_empaque PROCEDURE FOR
			pkg_produccion.sp_anular_parte_empaque(:ls_nro_parte) ;
			
EXECUTE 	sp_anular_parte_empaque ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "Error al ejecutar pkg_produccion.sp_anular_parte_empaque. Mensaje: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE sp_anular_parte_empaque;


event ue_retrieve()

if this.RowCount() > 0 then
	ll_find = this.Find("nro_parte='" + ls_nro_parte + "'", 0, this.RowCount())
	
	if ll_find > 0 then
		this.setRow(ll_find)
		this.SelectRow(0, false)
		this.SelectRow(ll_find, true)
		this.scrollToRow(ll_find)
	end if
end if
end event

event dw_master::ue_filter_avanzado;call super::ue_filter_avanzado;st_rows.text = String(this.RowCount(), '###,##0')
end event

type cb_buscar from commandbutton within w_pr315_programa_produccion
integer x = 2309
integer y = 64
integer width = 571
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;setPointer(HourGlass!)
parent.event ue_retrieve( )
setPointer(Arrow!)
end event

type uo_fechas from u_ingreso_rango_fechas within w_pr315_programa_produccion
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 70
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type st_1 from statictext within w_pr315_programa_produccion
integer x = 3611
integer y = 68
integer width = 416
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Registros:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_rows from statictext within w_pr315_programa_produccion
integer x = 4050
integer y = 68
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "0"
boolean focusrectangle = false
end type

type cbx_categorias from checkbox within w_pr315_programa_produccion
integer x = 18
integer y = 244
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos las categorias"
boolean checked = true
end type

event clicked;if this.checked then
	sle_categoria.Text	  = '%'
	cb_categoria.enabled = false
else
	sle_categoria.Text	  = ''
	cb_categoria.enabled = true
end if
end event

type sle_categoria from singlelineedit within w_pr315_programa_produccion
integer x = 622
integer y = 244
integer width = 343
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_categoria from commandbutton within w_pr315_programa_produccion
integer x = 969
integer y = 240
integer width = 114
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "select a1.cat_art as codigo_Categoria, " &
		 + "       a1.desc_categoria as descripcion_categoria " &
		 + "from articulo_categ     a1 " &
		 + "where a1.flag_estado = '1'" 
			 

	
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	
	sle_categoria.text		= ls_codigo
	sle_Desc_categoria.text	= ls_Data
	
end if
end event

type sle_desc_categoria from singlelineedit within w_pr315_programa_produccion
integer x = 1083
integer y = 244
integer width = 891
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cbx_origenes from checkbox within w_pr315_programa_produccion
integer x = 18
integer y = 156
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.Enabled = FALSE
	sle_origen.Text	  = '%'
	cb_3.enabled = false
else
	sle_origen.Enabled = TRUE
	sle_origen.Text	  = ''
	cb_3.enabled = true
end if
end event

type sle_origen from singlelineedit within w_pr315_programa_produccion
integer x = 622
integer y = 156
integer width = 343
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_pr315_programa_produccion
integer x = 969
integer y = 152
integer width = 114
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS NOMBRE_ORIGEN " &
		  + "FROM ORIGEN " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_origen.text		= ls_codigo
end if
end event

type sle_1 from singlelineedit within w_pr315_programa_produccion
integer x = 1083
integer y = 156
integer width = 891
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_pr315_programa_produccion
integer width = 4320
integer height = 340
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtro Programa de producción"
end type

