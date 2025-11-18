$PBExportHeader$w_cd303_acepta_transf_doc.srw
forward
global type w_cd303_acepta_transf_doc from w_abc
end type
type pb_3 from picturebutton within w_cd303_acepta_transf_doc
end type
type p_help from picture within w_cd303_acepta_transf_doc
end type
type st_help from statictext within w_cd303_acepta_transf_doc
end type
type pb_2 from picturebutton within w_cd303_acepta_transf_doc
end type
type pb_1 from picturebutton within w_cd303_acepta_transf_doc
end type
type dw_master from u_dw_abc within w_cd303_acepta_transf_doc
end type
end forward

global type w_cd303_acepta_transf_doc from w_abc
integer width = 3474
integer height = 2020
string title = "[CD303] Aceptacion de documentos transferidos"
string menuname = "m_consulta"
pb_3 pb_3
p_help p_help
st_help st_help
pb_2 pb_2
pb_1 pb_1
dw_master dw_master
end type
global w_cd303_acepta_transf_doc w_cd303_acepta_transf_doc

on w_cd303_acepta_transf_doc.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.pb_3=create pb_3
this.p_help=create p_help
this.st_help=create st_help
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_3
this.Control[iCurrent+2]=this.p_help
this.Control[iCurrent+3]=this.st_help
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.dw_master
end on

on w_cd303_acepta_transf_doc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_3)
destroy(this.p_help)
destroy(this.st_help)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_master)
end on

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

event ue_retrieve_list;call super::ue_retrieve_list;String ls_estado[]

ls_estado [1] = '1'
ls_estado [2] = '2'

idw_1.retrieve(gs_user)

IF idw_1.Rowcount() > 0 THEN
	idw_1.SelectRow(0,FALSE)
	idw_1.SelectRow(1,TRUE)
END IF
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

//dw_master.retrieve(gs_user)

TriggerEvent('ue_retrieve_list')
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
//270
dw_master.height = newheight - dw_master.y - 300

pb_1.y	  = newheight -  200
pb_2.y		  = newheight -  200
p_help.y			  = newheight -  105
st_help.y		  = newheight -  105

end event

type pb_3 from picturebutton within w_cd303_acepta_transf_doc
integer x = 1970
integer y = 1616
integer width = 315
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\rechazar.bmp"
alignment htextalign = left!
end type

event clicked;String ls_null
DateTime ldt_fecha_null 
Integer i, li_item

isnull(ls_null)
isnull(ldt_fecha_null)

FOR i=1 TO dw_master.GetRow() 
	IF dw_master.object.flag_transfer[i]='1' THEN 
		dw_master.ii_update=1
		dw_master.object.flag_transfer[i]='1'
		dw_master.object.cod_user_transfer[i]=ls_null
		dw_master.object.fecha_transfer_ini[i]=ldt_fecha_null
	END IF 
NEXT

Parent.TriggerEvent('ue_update')
Parent.TriggerEvent('ue_retrieve_list')

end event

type p_help from picture within w_cd303_acepta_transf_doc
integer x = 50
integer y = 1636
integer width = 110
integer height = 84
string picturename = "h:\Source\Bmp\Chkmark.bmp"
boolean border = true
boolean focusrectangle = false
end type

type st_help from statictext within w_cd303_acepta_transf_doc
integer x = 192
integer y = 1644
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
string text = "Dar Doble Click Para Aceptar Documento"
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_cd303_acepta_transf_doc
integer x = 3031
integer y = 1616
integer width = 315
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close(Parent)
end event

type pb_1 from picturebutton within w_cd303_acepta_transf_doc
integer x = 1559
integer y = 1616
integer width = 315
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\Source\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;String ls_null, ls_org_destino, ls_area_destino, ls_seccion_destino
Datetime ldt_fecha_null
Integer i, li_item

isnull(ls_null)
isnull(ldt_fecha_null)

FOR i=1 TO dw_master.RowCount() 
	IF dw_master.object.flag_transfer[i]='1' THEN 
		dw_master.ii_update=1
		li_item = dw_master.object.item[i] 
		dw_master.object.item[i] = li_item + 1
		
		SELECT cod_origen, cod_area, cod_seccion 
		  INTO :ls_org_destino, :ls_area_destino, :ls_seccion_destino
		  FROM cd_usuario_seccion 
		 WHERE cod_usr = :gs_user and flag_estado='1' ;
		 
		dw_master.object.usr_destino[i]=gs_user
		dw_master.object.org_destino[i]=ls_org_destino
		dw_master.object.area_destino[i]=ls_area_destino
		dw_master.object.seccion_destino[i]=ls_seccion_destino
		dw_master.object.flag_transfer[i]='1'
		dw_master.object.cod_user_transfer[i]=ls_null
		dw_master.object.fecha_transfer_ini[i]=ldt_fecha_null
	END IF 
NEXT

Parent.TriggerEvent('ue_update')
Parent.TriggerEvent('ue_retrieve_list')

end event

type dw_master from u_dw_abc within w_cd303_acepta_transf_doc
integer x = 23
integer y = 32
integer width = 3387
integer height = 1552
string dataobject = "d_aceptar_transferencia_grd"
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

idw_mst  = dw_master		// dw_master

end event

event doubleclicked;call super::doubleclicked;Integer li_opcion,li_return
Long    ll_count
String  ls_estado_act,ls_estado_pos,ls_aprobacion,ls_user,ls_nom_usuario,&
		  ls_origen,ls_nro_sg,ls_doc_sol_giro,ls_cencos

Accepttext()

IF row = 0 THEN Return

ls_estado_act = This.Object.flag_transfer [row]
ls_nro_sg	  = This.Object.nro_registro  [row]

IF 	 ls_estado_act = '2' THEN //De Generado a Aprobado
		 This.Object.flag_transfer [row] = '1'
		 //This.ii_update = 1
ELSEIF ls_estado_act = '1' THEN 
  		 This.Object.flag_transfer [row] = '2'
END IF	

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

