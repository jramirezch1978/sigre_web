$PBExportHeader$w_cm340_aprueba_solicitud_confor_os.srw
forward
global type w_cm340_aprueba_solicitud_confor_os from w_abc
end type
type cb_1 from commandbutton within w_cm340_aprueba_solicitud_confor_os
end type
type sle_origen from singlelineedit within w_cm340_aprueba_solicitud_confor_os
end type
type st_1 from statictext within w_cm340_aprueba_solicitud_confor_os
end type
type rb_1 from radiobutton within w_cm340_aprueba_solicitud_confor_os
end type
type rb_2 from radiobutton within w_cm340_aprueba_solicitud_confor_os
end type
type p_help from picture within w_cm340_aprueba_solicitud_confor_os
end type
type dw_master from u_dw_abc within w_cm340_aprueba_solicitud_confor_os
end type
type pb_salir from picturebutton within w_cm340_aprueba_solicitud_confor_os
end type
type pb_aceptar from picturebutton within w_cm340_aprueba_solicitud_confor_os
end type
type st_help from statictext within w_cm340_aprueba_solicitud_confor_os
end type
end forward

global type w_cm340_aprueba_solicitud_confor_os from w_abc
integer width = 3671
integer height = 2112
string title = "Aprobacion de Actas de Conformidad de OS[CM340]"
string menuname = "m_save_exit"
cb_1 cb_1
sle_origen sle_origen
st_1 st_1
rb_1 rb_1
rb_2 rb_2
p_help p_help
dw_master dw_master
pb_salir pb_salir
pb_aceptar pb_aceptar
st_help st_help
end type
global w_cm340_aprueba_solicitud_confor_os w_cm340_aprueba_solicitud_confor_os

type variables
String is_col
integer ii_ik[]
String      		is_tabla, is_colname[], is_coltype[]
n_cst_log_diario	in_log
end variables

on w_cm340_aprueba_solicitud_confor_os.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.cb_1=create cb_1
this.sle_origen=create sle_origen
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.p_help=create p_help
this.dw_master=create dw_master
this.pb_salir=create pb_salir
this.pb_aceptar=create pb_aceptar
this.st_help=create st_help
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.p_help
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.pb_salir
this.Control[iCurrent+9]=this.pb_aceptar
this.Control[iCurrent+10]=this.st_help
end on

on w_cm340_aprueba_solicitud_confor_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.p_help)
destroy(this.dw_master)
destroy(this.pb_salir)
destroy(this.pb_aceptar)
destroy(this.st_help)
end on

event close;call super::close;Destroy in_log
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 20
dw_master.height = newheight - dw_master.y - 300
pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

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

type cb_1 from commandbutton within w_cm340_aprueba_solicitud_confor_os
integer x = 1701
integer y = 36
integer width = 402
integer height = 112
integer taborder = 20
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

type sle_origen from singlelineedit within w_cm340_aprueba_solicitud_confor_os
event ue_dblclick pbm_lbuttondblclk
integer x = 297
integer y = 52
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

type st_1 from statictext within w_cm340_aprueba_solicitud_confor_os
integer x = 73
integer y = 64
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

type rb_1 from radiobutton within w_cm340_aprueba_solicitud_confor_os
integer x = 562
integer y = 56
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
string text = "Generadas"
boolean checked = true
end type

event clicked;dw_master.Dataobject = 'd_lista_dar_conformidad_acta_tbl'
dw_master.SetTransObject(SQLCA)

IF ib_log THEN											
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF

STRING ls_origen

ls_origen = sle_origen.text

if ls_origen = "" or isnull(ls_origen) then
	Messagebox('Aviso','Debe de Elegir un origen')
	Return
End if

dw_master.retrieve(trim(sle_origen.text))
end event

type rb_2 from radiobutton within w_cm340_aprueba_solicitud_confor_os
integer x = 1070
integer y = 56
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

event clicked;dw_master.Dataobject = 'd_lista_dar_conformidad_acta_desap_tbl'
dw_master.SetTransObject(SQLCA)

IF ib_log THEN											
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF

STRING ls_origen

ls_origen = sle_origen.text

if ls_origen = "" or isnull(ls_origen) then
	Messagebox('Aviso','Debe de Elegir un origen')
	Return
End if

dw_master.retrieve(trim(sle_origen.text))
end event

type p_help from picture within w_cm340_aprueba_solicitud_confor_os
integer x = 59
integer y = 1488
integer width = 110
integer height = 76
string picturename = "C:\SIGRE\resources\BMP\CHKMARK.BMP"
boolean border = true
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cm340_aprueba_solicitud_confor_os
integer x = 55
integer y = 208
integer width = 3323
integer height = 1100
integer taborder = 30
string dataobject = "d_lista_dar_conformidad_acta_tbl"
end type

event clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

///////**************///
//Integer li_pos, li_col, j
//String  ls_column , ls_report, ls_color, ls_etiqueta
//Long 	  ll_row
//
//
//li_col = dw_master.GetColumn()
//ls_column = THIS.GetObjectAtPointer()
//li_pos = pos(upper(ls_column),'_T')
//
//IF li_pos > 0 THEN
//	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
//	ls_column   = mid(ls_column,1,li_pos - 1) + "_t.text"
//	ls_report   = mid(ls_column,1,li_pos - 1) + "_t.tag"
//	ls_color    = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
//	
//	ls_etiqueta = This.Describe(ls_report)	
//	
//	st_search.text = "Busca Por : " + ls_etiqueta
//	dw_1.reset()
//	dw_1.InsertRow(0)
//	dw_1.SetFocus()
//END  IF
//
//// Si el evento es disparado desde otro objeto que esta activo, este evento no recono
//
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event doubleclicked;call super::doubleclicked;Integer  li_opcion,li_return
Long     ll_count
String   ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user,ls_nom_usuario,&
		   ls_origen,ls_nro_sg,ls_doc_sol_giro,ls_cencos, ls_set_fecha_null
DateTime ld_fec_aprobacion

this.Accepttext()

IF row = 0 THEN Return

ls_estado_act = This.Object.flag_estado   [row]

IF 	 ls_estado_act = '1' THEN 		 
		 
		 ls_estado_pos = 'Aprobar'
		 ls_estado_act = '2'
		 ls_user			= gs_user
		 
		 li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' Acta de Conformidad ?', Question!, YesNo!, 2)
		 
       This.Object.flag_estado    [row] = ls_estado_act
		 This.Object.usr_aprobador  [row] = ls_user
		 This.Object.fec_aprobacion [row] = f_fecha_actual()
		 This.ii_update = 1
		 
ELSEIF ls_estado_act = '2' THEN //Aprobado
		 
		 ls_estado_pos = 'Revertir Aprobacion de'	
		 ls_user			= ''
 		 ls_estado_act = '1'
		  
		 li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' Acta de Conformidad ?', Question!, YesNo!, 2)
		 
		 This.Object.flag_estado    [row] = ls_estado_act
		 This.Object.usr_aprobador  [row] = ls_user
		 setnull(ld_fec_aprobacion)
		 This.Object.fec_aprobacion [row] = ld_fec_aprobacion
		 This.ii_update = 1
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type pb_salir from picturebutton within w_cm340_aprueba_solicitud_confor_os
integer x = 3045
integer y = 1372
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type pb_aceptar from picturebutton within w_cm340_aprueba_solicitud_confor_os
integer x = 2656
integer y = 1372
integer width = 325
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Parent.TriggerEvent('ue_update')
//Parent.TriggerEvent('ue_retrieve_list')
end event

type st_help from statictext within w_cm340_aprueba_solicitud_confor_os
integer x = 197
integer y = 1496
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
string text = "Dar Doble Click Para Cambiar de Estado a Conformidad de OS."
alignment alignment = center!
boolean focusrectangle = false
end type

