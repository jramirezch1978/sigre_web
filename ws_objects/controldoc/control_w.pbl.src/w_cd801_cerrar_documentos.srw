$PBExportHeader$w_cd801_cerrar_documentos.srw
forward
global type w_cd801_cerrar_documentos from w_abc
end type
type cb_1 from commandbutton within w_cd801_cerrar_documentos
end type
type sle_user from singlelineedit within w_cd801_cerrar_documentos
end type
type rb_2 from radiobutton within w_cd801_cerrar_documentos
end type
type rb_1 from radiobutton within w_cd801_cerrar_documentos
end type
type pb_aceptar from picturebutton within w_cd801_cerrar_documentos
end type
type pb_salir from picturebutton within w_cd801_cerrar_documentos
end type
type st_help from statictext within w_cd801_cerrar_documentos
end type
type p_help from picture within w_cd801_cerrar_documentos
end type
type dw_master from u_dw_abc within w_cd801_cerrar_documentos
end type
type gb_1 from groupbox within w_cd801_cerrar_documentos
end type
end forward

global type w_cd801_cerrar_documentos from w_abc
integer width = 2441
integer height = 2312
string title = "[CD801] - Cerrar Documentos"
string menuname = "m_consulta"
cb_1 cb_1
sle_user sle_user
rb_2 rb_2
rb_1 rb_1
pb_aceptar pb_aceptar
pb_salir pb_salir
st_help st_help
p_help p_help
dw_master dw_master
gb_1 gb_1
end type
global w_cd801_cerrar_documentos w_cd801_cerrar_documentos

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
//270
dw_master.height = newheight - dw_master.y - 300

pb_aceptar.y	  = newheight -  200
pb_salir.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

sle_user.text = gs_user

TriggerEvent('ue_retrieve_list')
end event

event ue_retrieve_list;call super::ue_retrieve_list;String ls_estado[], ls_user

ls_user = sle_user.text 

ls_estado [1] = '1'
ls_estado [2] = '2'

idw_1.retrieve(gs_origen, gs_user)

IF idw_1.Rowcount() > 0 THEN
	idw_1.SelectRow(0,FALSE)
	idw_1.SelectRow(1,TRUE)
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
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

on w_cd801_cerrar_documentos.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cb_1=create cb_1
this.sle_user=create sle_user
this.rb_2=create rb_2
this.rb_1=create rb_1
this.pb_aceptar=create pb_aceptar
this.pb_salir=create pb_salir
this.st_help=create st_help
this.p_help=create p_help
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_user
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.pb_aceptar
this.Control[iCurrent+6]=this.pb_salir
this.Control[iCurrent+7]=this.st_help
this.Control[iCurrent+8]=this.p_help
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.gb_1
end on

on w_cd801_cerrar_documentos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_user)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.pb_aceptar)
destroy(this.pb_salir)
destroy(this.st_help)
destroy(this.p_help)
destroy(this.dw_master)
destroy(this.gb_1)
end on

type cb_1 from commandbutton within w_cd801_cerrar_documentos
integer x = 827
integer y = 108
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recupera"
end type

event clicked;String ls_user

ls_user = TRIM(sle_user.text)+'%'

idw_1.retrieve(gs_origen, ls_user)

end event

type sle_user from singlelineedit within w_cd801_cerrar_documentos
integer x = 507
integer y = 112
integer width = 247
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_cd801_cerrar_documentos
integer x = 69
integer y = 152
integer width = 325
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;sle_user.text = '%'
end event

type rb_1 from radiobutton within w_cd801_cerrar_documentos
integer x = 69
integer y = 68
integer width = 384
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por usuario"
boolean checked = true
end type

type pb_aceptar from picturebutton within w_cd801_cerrar_documentos
integer x = 1609
integer y = 1804
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;Integer i
FOR i=1 TO dw_master.GetRow() 
	dw_master.ii_update=1
NEXT
Parent.TriggerEvent('ue_update')
Parent.TriggerEvent('ue_retrieve_list')

end event

type pb_salir from picturebutton within w_cd801_cerrar_documentos
integer x = 1934
integer y = 1804
integer width = 315
integer height = 180
integer taborder = 20
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

type st_help from statictext within w_cd801_cerrar_documentos
integer x = 155
integer y = 1956
integer width = 1038
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dar Doble Click Para Cerrar Documento"
boolean focusrectangle = false
end type

type p_help from picture within w_cd801_cerrar_documentos
integer x = 14
integer y = 1948
integer width = 110
integer height = 76
string picturename = "h:\Source\Bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cd801_cerrar_documentos
integer x = 37
integer y = 272
integer width = 2318
integer height = 1488
string dataobject = "d_cerrar_documento"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

/////**************///
Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color, ls_etiqueta
Long 	  ll_row


li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'_T')

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

// Si el evento es disparado desde otro objeto que esta activo, este evento no recono

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

idw_mst  = dw_master		// dw_master

end event

event doubleclicked;call super::doubleclicked;Integer li_opcion,li_return
Long    ll_count
String  ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user,ls_nom_usuario,&
		  ls_origen,ls_nro_sg,ls_doc_sol_giro,ls_cencos

Accepttext()

IF row = 0 THEN Return

ls_estado_act = This.Object.flag_estado [row]
//ls_nro_sg	  = This.Object.nro_remesa  [row]

IF 	 ls_estado_act = '1' THEN //Generado Pasara Cerrarse
		 ls_estado_pos = 'Archivado'
		 ls_estado_act = '2'
		 This.Object.flag_estado [row] = '2'
		 ls_user			= gs_user

		 IF li_return = 0 THEN
			 Return	
		 END IF
		 
ELSEIF ls_estado_act = '2' THEN //Cerrar Pasar a Generado
//		 IF Trim(ls_aprobacion) <> Trim(gs_user) THEN
//			 Messagebox('Aviso','Usted No Puede Revertir Aprobacion, Verifique !')
//			 Return
//		 END IF
		 
		 ls_estado_pos = 'Revertir Cerrado de'	
		 ls_user			= ''
 		 ls_estado_act = '1'		 
  		 This.Object.flag_estado [row] = '2'
		
END IF	

li_opcion = MessageBox('Pregunta' ,'Desea '+ls_estado_pos+' el Documento ?', Question!, YesNo!, 2)

IF li_opcion = 1 THEN
	This.Object.flag_estado [row] = '1'
//	This.Object.cd_remesa_flag_estado [row] = ls_estado_act
//	This.Object.aprobacion  			 [row] = ls_user
	This.ii_update = 1
END IF
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

type gb_1 from groupbox within w_cd801_cerrar_documentos
integer x = 23
integer y = 12
integer width = 782
integer height = 232
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Paramétros"
end type

