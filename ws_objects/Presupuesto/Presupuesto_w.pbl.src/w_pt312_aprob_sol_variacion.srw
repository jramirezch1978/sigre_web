$PBExportHeader$w_pt312_aprob_sol_variacion.srw
forward
global type w_pt312_aprob_sol_variacion from w_abc
end type
type rb_2 from radiobutton within w_pt312_aprob_sol_variacion
end type
type rb_1 from radiobutton within w_pt312_aprob_sol_variacion
end type
type dw_master from u_dw_abc within w_pt312_aprob_sol_variacion
end type
type pb_salir from picturebutton within w_pt312_aprob_sol_variacion
end type
type pb_aceptar from picturebutton within w_pt312_aprob_sol_variacion
end type
type st_help from statictext within w_pt312_aprob_sol_variacion
end type
type p_help from picture within w_pt312_aprob_sol_variacion
end type
type st_1 from statictext within w_pt312_aprob_sol_variacion
end type
type sle_origen from singlelineedit within w_pt312_aprob_sol_variacion
end type
type cb_1 from commandbutton within w_pt312_aprob_sol_variacion
end type
end forward

global type w_pt312_aprob_sol_variacion from w_abc
integer width = 3579
integer height = 2008
string title = "Aprobación de Solicitudes de Variación (PT312)"
string menuname = "m_only_exit"
boolean center = true
rb_2 rb_2
rb_1 rb_1
dw_master dw_master
pb_salir pb_salir
pb_aceptar pb_aceptar
st_help st_help
p_help p_help
st_1 st_1
sle_origen sle_origen
cb_1 cb_1
end type
global w_pt312_aprob_sol_variacion w_pt312_aprob_sol_variacion

type variables
String      		is_tabla, is_colname[], is_coltype[]
//Boolean				ib_log = FALSE
n_cst_log_diario	in_log
end variables

on w_pt312_aprob_sol_variacion.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_master=create dw_master
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
this.st_help=create st_help
this.p_help=create p_help
this.st_1=create st_1
this.sle_origen=create sle_origen
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.pb_salir
this.Control[iCurrent+5]=this.pb_aceptar
this.Control[iCurrent+6]=this.st_help
this.Control[iCurrent+7]=this.p_help
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_origen
this.Control[iCurrent+10]=this.cb_1
end on

on w_pt312_aprob_sol_variacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_master)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
destroy(this.st_help)
destroy(this.p_help)
destroy(this.st_1)
destroy(this.sle_origen)
destroy(this.cb_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 20
dw_master.height = newheight - dw_master.y - 300
pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
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
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	cb_1.TriggerEvent( clicked! )
END IF
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

event close;call super::close;Destroy in_log
end event

type rb_2 from radiobutton within w_pt312_aprob_sol_variacion
integer x = 1079
integer y = 32
integer width = 462
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobadas"
end type

event clicked;dw_master.Dataobject = 'd_lista_prsp_solic_var_aprobadas'
dw_master.SetTransObject(SQLCA)

IF ib_log THEN											
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

type rb_1 from radiobutton within w_pt312_aprob_sol_variacion
integer x = 571
integer y = 32
integer width = 462
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desaprobadas"
boolean checked = true
end type

event clicked;dw_master.Dataobject = 'd_lista_prsp_solic_var_pend_aprob'
dw_master.SetTransObject(SQLCA)

IF ib_log THEN											
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

type dw_master from u_dw_abc within w_pt312_aprob_sol_variacion
integer y = 136
integer width = 3502
integer height = 1212
integer taborder = 30
string dataobject = "d_lista_prsp_solic_var_pend_aprob"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event doubleclicked;call super::doubleclicked;Integer 	li_opcion
String  	ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user, ls_origen, &
			ls_solicitud, ls_mensaje
DateTime	ldt_Fecha			

this.Accepttext()


IF row = 0 THEN Return

ls_estado_act = This.Object.flag_estado 	[row]
ls_aprobacion = This.Object.usr_aprobacion[row]
ls_solicitud  = this.object.nro_solicitud	[row]

IF ls_estado_act 	= '1' THEN //Generado Pasara Aprobarse
	ls_estado_pos 	= 'Aprobar'
	ls_estado_act 	= '2'
	ls_user			= gs_user
	ldt_fecha 		= f_fecha_Actual()
	
ELSEIF ls_estado_act = '2' THEN //Aprobado Pasar a Generado
	IF Trim(ls_aprobacion) <> Trim(gs_user) THEN
	 	Messagebox('Aviso','Usted No Puede Revertir Aprobacion, Verifique !')
		 Return
	END IF
		 
	ls_estado_pos = 'Revertir Aprobacion de'	
 	ls_estado_act = '1'
	 
	SetNull(ldt_fecha)
	SetNull(ls_user)
END IF	

li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' la Solicitud?', Question!, YesNo!, 2)

IF li_opcion = 1 THEN
	This.Object.flag_estado 		[row] = ls_estado_act
	This.Object.usr_aprobacion		[row] = ls_user
	This.Object.fecha_aprobacion	[row] = ldt_fecha
	This.ii_update = 1
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type pb_salir from picturebutton within w_pt312_aprob_sol_variacion
integer x = 3013
integer y = 1448
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type pb_aceptar from picturebutton within w_pt312_aprob_sol_variacion
integer x = 2624
integer y = 1448
integer width = 325
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_update')
end event

type st_help from statictext within w_pt312_aprob_sol_variacion
integer x = 165
integer y = 1412
integer width = 1394
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para Cambiar de Estado a Solicitud "
boolean focusrectangle = false
end type

type p_help from picture within w_pt312_aprob_sol_variacion
integer x = 41
integer y = 1404
integer width = 110
integer height = 76
string picturename = "h:\Source\Bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt312_aprob_sol_variacion
integer x = 82
integer y = 40
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_pt312_aprob_sol_variacion
event ue_dblclick pbm_lbuttondblclk
integer x = 306
integer y = 28
integer width = 219
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\Cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
	    + "nombre AS DESCRIPCION_origen " &
		 + "FROM origen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text	= ls_codigo
end if

end event

type cb_1 from commandbutton within w_pt312_aprob_sol_variacion
integer x = 1710
integer y = 12
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;dw_master.retrieve(trim(sle_origen.text))
end event

