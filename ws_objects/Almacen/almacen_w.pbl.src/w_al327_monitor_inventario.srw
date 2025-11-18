$PBExportHeader$w_al327_monitor_inventario.srw
forward
global type w_al327_monitor_inventario from w_abc_mastdet
end type
type st_2 from statictext within w_al327_monitor_inventario
end type
type sle_almacen from singlelineedit within w_al327_monitor_inventario
end type
type sle_descrip from singlelineedit within w_al327_monitor_inventario
end type
type dp_fecha from datepicker within w_al327_monitor_inventario
end type
type st_1 from statictext within w_al327_monitor_inventario
end type
type st_3 from statictext within w_al327_monitor_inventario
end type
type em_conteo from editmask within w_al327_monitor_inventario
end type
type cb_retrieve from commandbutton within w_al327_monitor_inventario
end type
type st_4 from statictext within w_al327_monitor_inventario
end type
type st_avance from statictext within w_al327_monitor_inventario
end type
type st_5 from statictext within w_al327_monitor_inventario
end type
type st_cantidad from statictext within w_al327_monitor_inventario
end type
type rb_todos from radiobutton within w_al327_monitor_inventario
end type
type rb_usuario from radiobutton within w_al327_monitor_inventario
end type
type uo_search from n_cst_search within w_al327_monitor_inventario
end type
type tab_1 from tab within w_al327_monitor_inventario
end type
type tabpage_1 from userobject within tab_1
end type
type dw_res_ubicacion from u_dw_abc within tabpage_1
end type
type dw_inventario from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_res_ubicacion dw_res_ubicacion
dw_inventario dw_inventario
end type
type tabpage_2 from userobject within tab_1
end type
type dw_ubicacion from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_ubicacion dw_ubicacion
end type
type tabpage_3 from userobject within tab_1
end type
type dw_resumen from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_resumen dw_resumen
end type
type tab_1 from tab within w_al327_monitor_inventario
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type gb_1 from groupbox within w_al327_monitor_inventario
end type
end forward

global type w_al327_monitor_inventario from w_abc_mastdet
integer width = 4942
integer height = 2064
string title = "[AL327] Monitor de Inventario por conteo"
string menuname = "m_mantenimiento_filter"
event ue_save_excel ( )
event ue_saveas_pdf ( )
event ue_saveas ( )
event type boolean ue_procesar_time_line ( string asi_almacen,  integer aii_nro_conteo,  date adi_fec_conteo,  date adi_time_line )
st_2 st_2
sle_almacen sle_almacen
sle_descrip sle_descrip
dp_fecha dp_fecha
st_1 st_1
st_3 st_3
em_conteo em_conteo
cb_retrieve cb_retrieve
st_4 st_4
st_avance st_avance
st_5 st_5
st_cantidad st_cantidad
rb_todos rb_todos
rb_usuario rb_usuario
uo_search uo_search
tab_1 tab_1
gb_1 gb_1
end type
global w_al327_monitor_inventario w_al327_monitor_inventario

type variables
Boolean 	ib_retorno = TRUE
String 	is_col, is_tipo, is_old_color, is_empresa, is_desc_empresa
u_dw_abc	idw_inventario, idw_ubicacion, idw_resumen, idw_res_ubicacion



end variables

forward prototypes
public function boolean of_verifica_conteo_inv (string as_almacen, integer ai_conteo)
public function boolean of_generar (string as_almacen, integer ai_conteo, date ad_fec_conteo)
public subroutine of_activar_buttons ()
public function integer of_retrieve (string as_almacen, integer ai_conteo, date ad_fec_conteo, string as_usuario)
public subroutine of_set_dws ()
end prototypes

event ue_save_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

event ue_saveas_pdf();string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = idw_1.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( idw_1, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

event ue_saveas();idw_1.EVENT ue_saveas()
end event

event type Boolean ue_procesar_time_line(string asi_almacen, integer aii_nro_conteo, date adi_fec_conteo, date adi_time_line);string  ls_mensaje
integer li_ok

//PROCEDURE sp_ajusta_inv_time_line(asi_almacen    inventario_conteo.almacen%TYPE, 
//											ani_conteo     inventario_conteo.nro_conteo%TYPE, 
//											adi_fec_conteo inventario_conteo.fec_conteo%TYPE,
//											adi_time_line  date,
//											asi_cod_usr    usuario.cod_usr%TYPE
//) is

DECLARE sp_ajusta_inv_time_line PROCEDURE FOR
	pkg_almacen.sp_ajusta_inv_time_line( :asi_almacen,
									 :aii_nro_conteo,
									 :adi_fec_conteo,
									 :adi_time_line,
									 :gs_user);

EXECUTE sp_ajusta_inv_time_line;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE pkg_almacen.sp_ajusta_inv_time_line:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje, StopSign!)
	Return false
END IF

CLOSE sp_ajusta_inv_time_line;

return true
end event

public function boolean of_verifica_conteo_inv (string as_almacen, integer ai_conteo);Long    	ll_count
integer	li_delete = 0
string 	ls_mensaje

SELECT COUNT(*)  
	INTO   :ll_count  
FROM  INVENTARIO_CONTEO  
WHERE almacen 		= :as_almacen
  and NRO_CONTEO 	= :ai_conteo;

// Ahora lo unico que queda es refrescar la información
if ll_count > 0 then
	dw_master.Retrieve( as_almacen, ai_conteo )
	//dw_master.object.fec_conteo.protect = 1
end if

RETURN true
end function

public function boolean of_generar (string as_almacen, integer ai_conteo, date ad_fec_conteo);Integer 	li_delete, li_count
String	ls_mensaje

SELECT COUNT(*)  
	INTO   :li_count  
FROM  INVENTARIO_CONTEO  
WHERE almacen 		= :as_almacen
  and NRO_CONTEO 	= :ai_conteo
  and fec_conteo	= :ad_fec_conteo;

IF li_count > 0 THEN
	if MessageBox('Aviso', 'Existen registros de este conteo para este almacen, ' &
	 				+ '¿Desea eliminarlos?', Information!, Yesno!, 2) = 1 then
		li_delete = 1
	end if
END IF

//create or replace procedure USP_ALM_ADD_SALDO_INVENTARIO(
//       asi_almacen          IN almacen.almacen%TYPE,
//       ani_conteo           IN inventario_conteo.nro_conteo%TYPE,
//       adi_fec_conteo       IN DATE,
//       ani_delete           IN INTEGER,
//       asi_usuario          in usuario.cod_usr%TYPE
//) is

DECLARE 	USP_ALM_ADD_SALDO_INVENTARIO PROCEDURE FOR
			USP_ALM_ADD_SALDO_INVENTARIO( :as_almacen,
													:ai_conteo,
													:ad_fec_conteo,
													:li_delete);

EXECUTE 	USP_ALM_ADD_SALDO_INVENTARIO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = SQLCA.SQLErrText
	Rollback ;
	MessageBox('PROCEDURE USP_ALM_ADD_SALDO_INVENTARIO', ls_mensaje, StopSign!)	
	return false
END IF

CLOSE USP_ALM_ADD_SALDO_INVENTARIO;

return true

end function

public subroutine of_activar_buttons ();string 	ls_almacen
Integer	li_conteo, li_count
Date		ld_fec_conteo

ls_almacen 		= trim(sle_almacen.text)
li_conteo  		= Integer(em_conteo.text)
ld_fec_conteo	= Date(dp_fecha.Value)

if IsNull(ls_almacen) or trim(ls_almacen) = '' then return

if IsNull(li_conteo) or li_conteo = 0 then return

if IsNull(ld_fec_conteo) then return 

select count(*)
	into :li_count
from INVENTARIO_CONTEO
where trunc(fec_conteo) = :ld_fec_conteo
  and almacen				= :ls_almacen
  and nro_conteo			= :li_conteo;

if li_count = 0 then
	cb_retrieve.enabled = false
else
	cb_retrieve.enabled = true
end if
  

end subroutine

public function integer of_retrieve (string as_almacen, integer ai_conteo, date ad_fec_conteo, string as_usuario);Long ll_rows, ll_i, ll_total_rows, ll_row1, ll_row2, ll_row3
Decimal	ldc_saldo_conteo1, ldc_total_saldo_conteo1
this.event ue_update_request( )

ll_row1 = idw_inventario.getRow()
ll_row2 = idw_ubicacion.getRow()
ll_row3 = idw_resumen.getRow()

idw_inventario.Retrieve(as_almacen, ai_conteo, ad_fec_conteo, as_usuario)
idw_ubicacion.Retrieve(as_almacen, ai_conteo, ad_fec_conteo)
idw_resumen.Retrieve(as_almacen, ai_conteo, ad_fec_conteo)
idw_res_ubicacion.Retrieve(as_almacen, ai_conteo, ad_fec_conteo)

idw_inventario.ii_update = 0
idw_inventario.ii_protect = 0
idw_inventario.of_protect()

ll_total_rows = idw_inventario.RowCount()

if ll_total_rows > 0 then
	ll_rows = 0
	ldc_total_saldo_conteo1 = 0
	
	for ll_i = 1 to ll_total_rows 
		ldc_saldo_conteo1 = Dec(idw_inventario.object.stock_conteo [ll_i])
		
		if not isNull(ldc_saldo_conteo1) and ldc_saldo_conteo1 > 0 then ll_rows ++
		
		ldc_total_saldo_conteo1 += ldc_saldo_conteo1
	next
	
	st_avance.text = string(ll_rows /  ll_total_rows * 100, "0.00") + " %" 
	st_cantidad.text = string(ldc_total_saldo_conteo1, '###,##0.00')
	
	if ll_row1 < ll_total_rows and ll_row1 > 0 then
		idw_inventario.setRow( ll_row1 )
		idw_inventario.SelectRow( 0, false )
		idw_inventario.SelectRow( ll_row1, true )
		idw_inventario.ScrollToRow( ll_row1 )
	end if
else
	st_avance.text = '0.00 %'
	st_cantidad.text = '0.00'
end if

if ll_row2 < idw_ubicacion.RowCount() and ll_row2 > 0 then
	idw_ubicacion.setRow( ll_row2 )
	idw_ubicacion.SelectRow( 0, false )
	idw_ubicacion.SelectRow( ll_row2, true )
	idw_ubicacion.ScrollToRow( ll_row2 )
end if

if ll_row3 < idw_resumen.RowCount() and ll_row3 > 0  then
	idw_resumen.setRow( ll_row3 )
	idw_resumen.SelectRow( 0, false )
	idw_resumen.SelectRow( ll_row3, true )
	idw_resumen.ScrollToRow( ll_row3 )
end if

return 1
end function

public subroutine of_set_dws ();idw_inventario 	= tab_1.tabpage_1.dw_inventario
idw_ubicacion 		= tab_1.tabpage_2.dw_ubicacion
idw_resumen 		= tab_1.tabpage_3.dw_resumen
idw_res_ubicacion	= tab_1.tabpage_1.dw_res_ubicacion

end subroutine

on w_al327_monitor_inventario.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_filter" then this.MenuID = create m_mantenimiento_filter
this.st_2=create st_2
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.dp_fecha=create dp_fecha
this.st_1=create st_1
this.st_3=create st_3
this.em_conteo=create em_conteo
this.cb_retrieve=create cb_retrieve
this.st_4=create st_4
this.st_avance=create st_avance
this.st_5=create st_5
this.st_cantidad=create st_cantidad
this.rb_todos=create rb_todos
this.rb_usuario=create rb_usuario
this.uo_search=create uo_search
this.tab_1=create tab_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.dp_fecha
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_conteo
this.Control[iCurrent+8]=this.cb_retrieve
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_avance
this.Control[iCurrent+11]=this.st_5
this.Control[iCurrent+12]=this.st_cantidad
this.Control[iCurrent+13]=this.rb_todos
this.Control[iCurrent+14]=this.rb_usuario
this.Control[iCurrent+15]=this.uo_search
this.Control[iCurrent+16]=this.tab_1
this.Control[iCurrent+17]=this.gb_1
end on

on w_al327_monitor_inventario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.dp_fecha)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.em_conteo)
destroy(this.cb_retrieve)
destroy(this.st_4)
destroy(this.st_avance)
destroy(this.st_5)
destroy(this.st_cantidad)
destroy(this.rb_todos)
destroy(this.rb_usuario)
destroy(this.uo_search)
destroy(this.tab_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_columna

try 
	
	of_set_dws()
	
	ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
	// ii_help = 101     
	
	is_col = 'fec_registro'
	is_tipo = LEFT( idw_inventario.Describe(is_col + ".ColType"),1)	
	ls_columna = idw_inventario.describe(is_col + "_t.text")
	is_old_color = idw_inventario.Describe(is_col + "_t.Background.Color")
	idw_inventario.Modify(is_col + "_t.Background.Color = 255")
	
	//Quito las doble comillas
	ls_columna = gnvo_utility.of_replace(ls_columna, '"', "")
	ls_columna = gnvo_utility.of_replace(ls_columna, "~r~n", " ")
	
	//st_campo.text = "Buscar por: " + ls_columna
	
	
	dp_fecha.Value = gnvo_app.of_fecha_actual( )
	
	idw_1 = idw_inventario
	idw_1.SetFocus()
	
	uo_search.of_set_dw(idw_inventario)
	
	idw_inventario.SetTransObject(SQLCA)
	idw_ubicacion.setTransObject(SQLCA)
	idw_resumen.setTransObject(SQLCA)
	idw_res_ubicacion.setTransObject(SQLCA)
	
	timer(20)

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Exception al momento de levantar ventana')
	
finally
	/*statementBlock*/
end try
end event

event ue_update_pre;call super::ue_update_pre;Long ll_i
date ld_fec_conteo

ib_update_check = False

ld_fec_conteo = Date(dp_fecha.Value)

if IsNull(ld_fec_conteo) then
	MessageBox('Aviso', 'Debe especificar una fecha de conteo')
	return
end if

IF idw_inventario.Rowcount() = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Algun Articulo', StopSign!)
	RETURN
END IF

// Verifica que campos son requeridos y tengan valores
SetMicrohelp( 'Ejecutando el f_row_processing')
if gnvo_app.of_row_Processing( idw_inventario ) <> true then return

SetMicrohelp( 'Actualizando la fecha de conteo')
for ll_i = 1 to idw_inventario.RowCount( )
	idw_inventario.object.fec_conteo[ll_i] = ld_fec_conteo
next

SetMicrohelp( 'Actualizando El flag de replicacion')
idw_inventario.of_set_flag_replicacion()

ib_update_check = true

end event

event ue_update;//Overriding
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf


ls_crlf = char(13) + char(10)

idw_inventario.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	idw_inventario.of_create_log()
END IF

SetMicrohelp( 'Grabando los cambios del detalle')
IF idw_inventario.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_inventario.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	lbo_ok = idw_inventario.of_save_log()
END IF

IF lbo_ok THEN
	SetMicrohelp( 'Guardando los cambios en la base de datos')
	COMMIT using SQLCA;
	idw_inventario.ii_update = 0
	idw_inventario.il_totdel = 0
	
	idw_inventario.ResetUpdate()
	
	cb_retrieve.event clicked( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event open;call super::open;IF ib_retorno = FALSE THEN
   Close(This)
END IF
end event

event ue_delete;//Overriding
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_inventario.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_cancelar;call super::ue_cancelar;this.event ue_update_request()

idw_inventario.Reset()
idw_ubicacion.Reset()

idw_inventario.ii_update = 0
idw_ubicacion.ii_update = 0




end event

event ue_update_request;//Overriding
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_inventario.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_inventario.ii_update = 0
	END IF
END IF

end event

event ue_insert;//Override
Long  ll_row

ll_row = idw_inventario.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_refresh;call super::ue_refresh;string 	ls_almacen, ls_usuario
Integer	li_conteo
Date		ld_fec_conteo

ls_almacen 		= trim(sle_almacen.text)
li_conteo  		= Integer(em_conteo.text)
ld_fec_conteo	= Date(dp_fecha.Value)

if IsNull(ls_almacen) or trim(ls_almacen) = '' then
	MessageBox('Aviso', 'Debe indicar un almacen')
	sle_Almacen.setFocus()
	return
end if

if IsNull(li_conteo) or li_conteo = 0 then
	MessageBox('Aviso', 'Debe indicar un nro de conteo')
	em_conteo.setFocus()
	return
end if

if IsNull(ld_fec_conteo) then
	MessageBox('Aviso', 'Debe indicar una fecha de conteo')
	dp_fecha.setFocus()
	return
end if


if rb_todos.checked then
	ls_usuario = '%%'
else
	ls_usuario = trim(gs_user) + '%'
end if

of_retrieve( ls_almacen, li_conteo, ld_fec_conteo, ls_usuario)	
end event

event resize;//Override

of_set_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_inventario.width  = tab_1.tabpage_1.width / 2  - idw_inventario.x - 10
idw_inventario.height = tab_1.tabpage_1.height  - idw_inventario.y - 10

idw_res_ubicacion.x 	 		= idw_inventario.x + idw_inventario.width + 10
idw_res_ubicacion.width  	= tab_1.tabpage_1.width  - idw_res_ubicacion.x - 10
idw_res_ubicacion.height 	= tab_1.tabpage_1.height  - idw_res_ubicacion.y - 10

idw_ubicacion.width  = tab_1.tabpage_2.width  - idw_ubicacion.x - 10
idw_ubicacion.height = tab_1.tabpage_2.height  - idw_ubicacion.y - 10

idw_resumen.width  = tab_1.tabpage_3.width  - idw_resumen.x - 10
idw_resumen.height = tab_1.tabpage_3.height  - idw_resumen.y - 10

uo_search.event ue_resize(sizetype, tab_1.width, tab_1.height)

end event

event ue_retrieve_list;// Asigna valores a structura 
Long 		ll_row
String	ls_usuario
str_parametros sl_param

sl_param.dw1 = "d_lista_inv_conteo_tbl"
sl_param.titulo = "Conteo de Inventario"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3

OpenWithParm( w_search, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
	
if sl_param.titulo <> 'n' then		
	if rb_todos.checked then
		ls_usuario = '%%'
	else
		ls_usuario = trim(gs_user) + '%'
	end if
	
	sle_almacen.text 	= sl_param.field_ret[1]
	em_conteo.text		= sl_param.field_ret[2]
	dp_fecha.value		= DateTime(Date(sl_param.field_ret[3]), now())
	
	of_retrieve(sl_param.field_ret[1], Integer(sl_param.field_ret[2]), Date(sl_param.field_ret[3]), ls_usuario )
END IF

end event

event ue_modify;//Override
idw_inventario.of_protect()

end event

event ue_print;call super::ue_print;idw_ubicacion.print()
end event

event timer;call super::timer;this.event ue_refresh()
end event

type dw_master from w_abc_mastdet`dw_master within w_al327_monitor_inventario
event ue_display ( string as_columna,  long al_row )
boolean visible = false
integer x = 3365
integer y = 420
integer width = 137
integer height = 108
boolean enabled = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "desc_almacen AS DESCRIPCION_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event dw_master::constructor;//Override

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return(1)
end event

event dw_master::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_insert;//override

Parent.Event ue_update_request()


IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

THIS.RESET()

ll_row = THIS.InsertRow(0)				// insertar registro maestro

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_conteo[al_row] = date(f_fecha_actual())
this.SetColumn('almacen')
end event

type dw_detail from w_abc_mastdet`dw_detail within w_al327_monitor_inventario
event ue_display ( string as_columna,  long al_row )
boolean visible = false
integer x = 3529
integer y = 424
integer width = 142
integer height = 68
boolean enabled = false
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;//Override
end event

type st_2 from statictext within w_al327_monitor_inventario
integer x = 18
integer y = 68
integer width = 315
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_almacen from singlelineedit within w_al327_monitor_inventario
event dobleclick pbm_lbuttondblclk
integer x = 347
integer y = 68
integer width = 256
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
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

parent.of_activar_buttons( )
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
where almacen = :ls_almacen 
  and FLAG_TIPO_ALMACEN <> 'T';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

parent.of_activar_buttons( )

end event

type sle_descrip from singlelineedit within w_al327_monitor_inventario
integer x = 613
integer y = 68
integer width = 1623
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
boolean border = false
textcase textcase = upper!
boolean displayonly = true
end type

type dp_fecha from datepicker within w_al327_monitor_inventario
integer x = 1797
integer y = 176
integer width = 439
integer height = 88
integer taborder = 80
boolean bringtotop = true
boolean allowedit = true
boolean dropdownright = true
string customformat = "dd/mm/yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2018-07-31"), Time("00:01:46.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

event valuechanged;parent.of_activar_buttons( )
end event

type st_1 from statictext within w_al327_monitor_inventario
integer x = 18
integer y = 176
integer width = 315
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro Conteo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_al327_monitor_inventario
integer x = 1385
integer y = 176
integer width = 379
integer height = 88
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Conteo:"
boolean focusrectangle = false
end type

type em_conteo from editmask within w_al327_monitor_inventario
integer x = 347
integer y = 176
integer width = 256
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###"
end type

event modified;parent.of_activar_buttons( )
end event

type cb_retrieve from commandbutton within w_al327_monitor_inventario
integer x = 2263
integer y = 208
integer width = 576
integer height = 100
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_refresh()
SetPointer(Arrow!)
end event

type st_4 from statictext within w_al327_monitor_inventario
integer x = 3346
integer y = 56
integer width = 457
integer height = 124
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porcentaje Avance"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_avance from statictext within w_al327_monitor_inventario
integer x = 3835
integer y = 56
integer width = 530
integer height = 124
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_al327_monitor_inventario
integer x = 3346
integer y = 188
integer width = 480
integer height = 124
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Suma Cantidad:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_cantidad from statictext within w_al327_monitor_inventario
integer x = 3835
integer y = 188
integer width = 530
integer height = 124
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 16777215
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_todos from radiobutton within w_al327_monitor_inventario
integer x = 2281
integer y = 64
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos Lo usuarios"
boolean checked = true
end type

type rb_usuario from radiobutton within w_al327_monitor_inventario
integer x = 2281
integer y = 136
integer width = 480
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ingresados por mi"
end type

type uo_search from n_cst_search within w_al327_monitor_inventario
event destroy ( )
integer y = 344
integer taborder = 90
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type tab_1 from tab within w_al327_monitor_inventario
integer y = 448
integer width = 4178
integer height = 1440
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4142
integer height = 1312
long backcolor = 79741120
string text = "Inventario por Conteo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_res_ubicacion dw_res_ubicacion
dw_inventario dw_inventario
end type

on tabpage_1.create
this.dw_res_ubicacion=create dw_res_ubicacion
this.dw_inventario=create dw_inventario
this.Control[]={this.dw_res_ubicacion,&
this.dw_inventario}
end on

on tabpage_1.destroy
destroy(this.dw_res_ubicacion)
destroy(this.dw_inventario)
end on

type dw_res_ubicacion from u_dw_abc within tabpage_1
integer x = 1934
integer width = 1915
integer height = 1092
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cns_resumen_inventario_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			
ii_ck[2] = 2 	      
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5


end event

event doubleclicked;call super::doubleclicked;string 	ls_columna, ls_color
long		ll_row
Integer	li_col, li_pos

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

if row = 0 then
	li_col = this.GetColumn()
	
	ls_columna = upper(dwo.name)
	
	IF right(ls_columna, 2) = '_T' THEN
		//A la antigua columna le regreso el color anterior
		this.Modify(is_col + "_t.Background.Color = " + is_old_color)
		
		//Ahora obtengo la nueva columna
		is_col  = UPPER( mid(ls_columna,1,len(ls_columna) - 2) )	
		is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
		ls_columna = this.Describe(is_col + "_t.text")
		is_old_color = this.Describe(is_col + "_t.Background.Color")
		this.Modify(is_col + "_t.Background.Color = 255")
		
		//Quito las doble comillas
		ls_columna = gnvo_utility.of_replace(ls_columna, '"', "")
		ls_columna = gnvo_utility.of_replace(ls_columna, "~r~n", " ")

		//st_campo.text = "Buscar por: " + ls_columna
		//dw_3.reset()
		//dw_3.InsertRow(0)
		//dw_3.SetFocus()
		
		this.setRow(row)
		this.scrolltoRow(row)
	end if
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert;call super::ue_insert;//override
long ll_row

if trim(sle_almacen.text) = '' then
	MessageBox('Error', 'Debe especificar el almacen. Por favor Verifique!', StopSign!)
	sle_almacen.setFocus()
	return -1
end if

if trim(em_conteo.text) = '' then
	MessageBox('Error', 'Debe especificar el Nro de Conteo. Por favor Verifique!', StopSign!)
	em_conteo.setFocus()
	return -1
end if

ll_row = THIS.InsertRow(0)				// insertar registro maestro

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event ue_insert_pre;call super::ue_insert_pre;//Override
dateTime ldt_now

ldt_now = gnvo_app.of_fecha_Actual()

this.object.sldo_total			[al_row] = 0
this.object.sldo_total_und2	[al_row] = 0
this.object.sldo_conteo1		[al_row] = 0
this.object.sldo_conteo1_und2	[al_row] = 0
this.object.sldo_conteo2		[al_row] = 0
this.object.sldo_conteo2_und2	[al_row] = 0

//DAtos para insertar
this.object.almacen				[al_row] = sle_almacen.text
this.object.nro_conteo			[al_row] = Integer(em_conteo.text)
this.object.fec_conteo			[al_row] = Date(dp_fecha.Value)
this.object.fec_registro		[al_row] = ldt_now
this.object.cod_usr				[al_row] = gs_user
this.object.ubicacion			[al_row] = "S/R"
this.object.nro_lote				[al_row] = "NO TIENE"

This.SetColumn( "cod_art")
This.SetFocus()
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event buttonclicked;call super::buttonclicked;String 	ls_almacen, ls_ubicacion, ls_mensaje
Integer	li_nro_conteo
Date		ld_fec_conteo

if row = 0 then return

this.Accepttext()


CHOOSE CASE lower(dwo.name)
	CASE 'b_delete_ubicacion'
		ls_almacen 		= this.object.almacen 			[row]
		li_nro_conteo 	= Int(this.object.nro_Conteo 	[row])	
		ld_fec_conteo	= DAte(this.object.fec_conteo	[row])
		
		ls_ubicacion 	= this.object.ubicacion			[row]
		
		if MessageBox('Aviso', 'Desea eliminar todos los registros de la ubicacion ' &
			+ ls_ubicacion + '?', Information!, YesNo!, 2) = 2 then return
			
		//Elimino la ubicacion completos de la base de datos
		delete inventario_conteo
		where almacen 		= :ls_almacen
		  and nro_conteo 	= :li_nro_conteo
		  and trunc(fec_conteo) = trunc(:ld_fec_conteo)
		  and ubicacion	= :ls_ubicacion;
		 
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_mensaje_error("Ha ocurrido un error al eliminar registro de la tabla INVENTARIO_CONTEO. Mensaje: " + ls_mensaje)
			return
		end if
		
		commit;
		
		event ue_refresh();
		

	

END CHOOSE
end event

type dw_inventario from u_dw_abc within tabpage_1
integer width = 1915
integer height = 1092
integer taborder = 20
string dataobject = "d_cns_monitor_inventario_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			
ii_ck[2] = 2 	      
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5


end event

event doubleclicked;call super::doubleclicked;string 	ls_columna, ls_color
long		ll_row
Integer	li_col, li_pos

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

if row = 0 then
	li_col = this.GetColumn()
	
	ls_columna = upper(dwo.name)
	
	IF right(ls_columna, 2) = '_T' THEN
		//A la antigua columna le regreso el color anterior
		this.Modify(is_col + "_t.Background.Color = " + is_old_color)
		
		//Ahora obtengo la nueva columna
		is_col  = UPPER( mid(ls_columna,1,len(ls_columna) - 2) )	
		is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
		ls_columna = this.Describe(is_col + "_t.text")
		is_old_color = this.Describe(is_col + "_t.Background.Color")
		this.Modify(is_col + "_t.Background.Color = 255")
		
		//Quito las doble comillas
		ls_columna = gnvo_utility.of_replace(ls_columna, '"', "")
		ls_columna = gnvo_utility.of_replace(ls_columna, "~r~n", " ")

		//st_campo.text = "Buscar por: " + ls_columna
		//dw_3.reset()
		//dw_3.InsertRow(0)
		//dw_3.SetFocus()
		
		this.setRow(row)
		this.scrolltoRow(row)
	end if
END IF
end event

event itemchanged;call super::itemchanged;this.Accepttext()
String 	ls_des_art,ls_und
DEcimal 	ldc_conteo, ldc_conteo_und2, ldc_factor



CHOOSE CASE dwo.name
	CASE 'saldo_conteo'
		ldc_conteo = dec(data)
		ldc_factor = dec(this.object.factor_conv_und [row])
		if IsNull(ldc_factor) then ldc_factor = 0
		this.object.sldo_conteo_und2 [row] = ldc_conteo * ldc_factor
		

	CASE 'cod_art'
		IF of_val_duplicado('cod_art',data) = FALSE THEN
			Messagebox('Aviso','Codigo Articulo Duplicado')
			This.object.cod_art[row] = gnvo_app.is_null
			RETURN 1					
		END IF
		
		
		SELECT DESC_ART,UND
		INTO   :ls_des_art,:ls_und
		FROM   ARTICULO
		WHERE  COD_ART  = :data 
		  and flag_estado = '1';
		
		IF SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Debe Ingresar Un Codigo de Articulo Valido')
			This.object.cod_art	[row] = gnvo_app.is_null
			This.object.desc_art	[row] = gnvo_app.is_null
			This.object.und		[row] = gnvo_app.is_null
			RETURN 1
		End if
		
		This.object.desc_art [row] = ls_des_art
		This.object.und 		[row] = ls_und

END CHOOSE
end event

event ue_insert;call super::ue_insert;//override
long ll_row

if trim(sle_almacen.text) = '' then
	MessageBox('Error', 'Debe especificar el almacen. Por favor Verifique!', StopSign!)
	sle_almacen.setFocus()
	return -1
end if

if trim(em_conteo.text) = '' then
	MessageBox('Error', 'Debe especificar el Nro de Conteo. Por favor Verifique!', StopSign!)
	em_conteo.setFocus()
	return -1
end if

ll_row = THIS.InsertRow(0)				// insertar registro maestro

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event ue_insert_pre;call super::ue_insert_pre;//Override
dateTime ldt_now

ldt_now = gnvo_app.of_fecha_Actual()

this.object.sldo_total			[al_row] = 0
this.object.sldo_total_und2	[al_row] = 0
this.object.sldo_conteo1		[al_row] = 0
this.object.sldo_conteo1_und2	[al_row] = 0
this.object.sldo_conteo2		[al_row] = 0
this.object.sldo_conteo2_und2	[al_row] = 0

//DAtos para insertar
this.object.almacen				[al_row] = sle_almacen.text
this.object.nro_conteo			[al_row] = Integer(em_conteo.text)
this.object.fec_conteo			[al_row] = Date(dp_fecha.Value)
this.object.fec_registro		[al_row] = ldt_now
this.object.cod_usr				[al_row] = gs_user
this.object.ubicacion			[al_row] = "S/R"
this.object.nro_lote				[al_row] = "NO TIENE"

This.SetColumn( "cod_art")
This.SetFocus()
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event ue_display;call super::ue_display;str_articulo	lstr_articulo

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_art"

		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
	
		if lstr_articulo.b_Return then
				this.object.cod_art				[al_row] = lstr_articulo.cod_art
				this.object.full_desc_art		[al_row] = lstr_articulo.desc_art
				this.object.und					[al_row] = lstr_articulo.und
				this.object.cod_sku				[al_row] = lstr_articulo.cod_sku
			
				this.ii_update = 1
		end if
		
		
		return
end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4142
integer height = 1312
long backcolor = 79741120
string text = "Resumen por Ubicación"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_ubicacion dw_ubicacion
end type

on tabpage_2.create
this.dw_ubicacion=create dw_ubicacion
this.Control[]={this.dw_ubicacion}
end on

on tabpage_2.destroy
destroy(this.dw_ubicacion)
end on

type dw_ubicacion from u_dw_abc within tabpage_2
integer width = 3721
integer height = 1224
integer taborder = 100
string dataobject = "d_rpt_ubicaciones_inventario_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4142
integer height = 1312
long backcolor = 79741120
string text = "Resumen por Articulos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_resumen dw_resumen
end type

on tabpage_3.create
this.dw_resumen=create dw_resumen
this.Control[]={this.dw_resumen}
end on

on tabpage_3.destroy
destroy(this.dw_resumen)
end on

type dw_resumen from u_dw_abc within tabpage_3
integer width = 3721
integer height = 1224
string dataobject = "d_rpt_resumen_articulos_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type gb_1 from groupbox within w_al327_monitor_inventario
integer width = 4859
integer height = 340
integer taborder = 100
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "none"
end type

