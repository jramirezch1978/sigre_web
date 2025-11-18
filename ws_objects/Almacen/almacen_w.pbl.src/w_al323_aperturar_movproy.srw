$PBExportHeader$w_al323_aperturar_movproy.srw
forward
global type w_al323_aperturar_movproy from w_abc_master
end type
type st_1 from statictext within w_al323_aperturar_movproy
end type
type st_2 from statictext within w_al323_aperturar_movproy
end type
type sle_1 from singlelineedit within w_al323_aperturar_movproy
end type
type sle_2 from singlelineedit within w_al323_aperturar_movproy
end type
type cb_1 from commandbutton within w_al323_aperturar_movproy
end type
end forward

global type w_al323_aperturar_movproy from w_abc_master
integer width = 3657
integer height = 1544
string title = "Apertura de Movimientos Proyectados Cerrados (AL323)"
string menuname = "m_mantto_anular"
windowstate windowstate = maximized!
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
st_1 st_1
st_2 st_2
sle_1 sle_1
sle_2 sle_2
cb_1 cb_1
end type
global w_al323_aperturar_movproy w_al323_aperturar_movproy

type variables
string is_doc_ot, is_salir
end variables

forward prototypes
public function integer of_get_param ()
public function integer of_proc_dw ()
end prototypes

event ue_anular();Integer j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF
// Anulando 
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1


end event

public function integer of_get_param ();// Evalua parametros
Int li_ret = 1

// busca tipos de movimiento definidos
SELECT doc_ot
  INTO :is_doc_ot
FROM logparam  
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return 0
end if

if sqlca.sqlcode < 0 then
	Messagebox( "Error en busqueda parametros", sqlca.sqlerrtext)
	return 0	
end if

if ISNULL( is_doc_ot ) or TRIM( is_doc_ot ) = '' then
	Messagebox("Error de parametros", "Defina DOC_OT en logparam")
	return 0
end if

return 1

end function

public function integer of_proc_dw ();Long 		ll_i
string	ls_oper_sec, ls_nro_ot, ls_mensaje

for ll_i = 1 to dw_master.RowCount()
	if dw_master.object.tipo_doc [ll_i] = is_doc_ot &
		and dw_master.object.flag_estado [ll_i] = '1' then
		
		ls_oper_sec = dw_master.object.oper_sec[ll_i]
		ls_nro_ot	= dw_master.object.nro_doc	[ll_i]
		
		update operaciones
		   set flag_estado = '1',
				 flag_replicacion = '1'
		where oper_sec = :ls_oper_sec;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Alerta OPERACIONES', ls_mensaje)
			return 0
		end if
		
		update orden_trabajo
		   set flag_estado = '1',
				 flag_replicacion = '1'
		where nro_orden = :ls_nro_ot;

		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Alerta ORDEN_TRABAJO', ls_mensaje)
			return 0
		end if
				
	end if
next

return 1
end function

on w_al323_aperturar_movproy.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_anular" then this.MenuID = create m_mantto_anular
this.st_1=create st_1
this.st_2=create st_2
this.sle_1=create sle_1
this.sle_2=create sle_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.sle_2
this.Control[iCurrent+5]=this.cb_1
end on

on w_al323_aperturar_movproy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_1)
destroy(this.sle_2)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;//ii_help = 101           					// help topic
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
end if
ib_log = TRUE
	
//idw_1.Retrieve()


end event

event ue_update_pre;call super::ue_update_pre;if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()

end event

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_update;//Override

Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

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

IF lbo_ok THEN
	if of_proc_dw() = 0 then return
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
END IF

end event

type dw_master from w_abc_master`dw_master within w_al323_aperturar_movproy
integer x = 0
integer y = 292
integer width = 3442
integer height = 820
string dataobject = "d_abc_apertura_movproy"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,                    	
is_dwform = 'tabular'	
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_opcion

if row = 0 then return 
IF This.Object.flag_estado [row] = '1' THEN //
	li_opcion = MessageBox('Aviso' ,'Desea no atender este item?', Question!, YesNo!, 2)
	if li_opcion = 1 then
		This.Object.flag_estado [row] = '2'
		This.ii_update = 1
	end if
elseif This.Object.flag_estado [row] = '2' THEN //
	li_opcion = MessageBox('Aviso' ,'Desea atender este item?', Question!, YesNo!, 2)
	if li_opcion = 1 then
		This.Object.flag_estado [row] = '1'
		This.ii_update = 1
	end if
end if
end event

type st_1 from statictext within w_al323_aperturar_movproy
integer x = 585
integer y = 44
integer width = 1801
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Apertura de Movimientos Proyectados Cerrados"
boolean focusrectangle = false
end type

type st_2 from statictext within w_al323_aperturar_movproy
integer x = 101
integer y = 172
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento:"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_al323_aperturar_movproy
event ue_dobleclick pbm_lbuttondblclk
integer x = 475
integer y = 160
integer width = 169
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct a.tipo_doc AS codigo_tipo_doc, " &
		  + "a.DESC_tipo_doc AS DESCRIPCION_tipo_doc " &
		  + "FROM doc_tipo a, " &
		  + "articulo_mov_proy amp " &
		  + "where amp.tipo_doc = a.tipo_doc " &
		  + "and amp.flag_estado = '2' "
		  
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type sle_2 from singlelineedit within w_al323_aperturar_movproy
event ue_dobleclick pbm_lbuttondblclk
integer x = 654
integer y = 160
integer width = 457
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo_doc

ls_tipo_doc = sle_1.text

if ls_tipo_doc = '' or IsNull(ls_tipo_doc) then
	MessageBox('Aviso', 'Ingrese primero un tipo de documento')
	return
end if

ls_sql = "SELECT distinct cod_origen AS origen, " &
		 +	"NRO_DOC AS NUMERO_DOC " &
		 + "FROM ARTICULO_MOV_PROY AMP " &
		 + "WHERE FLAG_ESTADO = '2' " &
		 + "AND TIPO_DOC = '" +ls_tipo_doc + "' " &
		 + "AND CANT_PROCESADA < CANT_PROYECT"

				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_data
end if

end event

type cb_1 from commandbutton within w_al323_aperturar_movproy
integer x = 1115
integer y = 148
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;dw_master.retrieve( sle_1.text, sle_2.text)
end event

