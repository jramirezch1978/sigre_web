$PBExportHeader$w_cm320_no_atender.srw
forward
global type w_cm320_no_atender from w_abc_mastdet_smpl
end type
type pb_1 from picturebutton within w_cm320_no_atender
end type
type pb_2 from picturebutton within w_cm320_no_atender
end type
end forward

global type w_cm320_no_atender from w_abc_mastdet_smpl
integer width = 1984
integer height = 1976
string title = "Items que no se atenderan (CM320)"
string menuname = "m_master"
boolean toolbarvisible = false
event ue_anular ( )
pb_1 pb_1
pb_2 pb_2
end type
global w_cm320_no_atender w_cm320_no_atender

type variables
String is_tipo_doc
Int il_opcion
end variables

on w_cm320_no_atender.create
int iCurrent
call super::create
if this.MenuName = "m_master" then this.MenuID = create m_master
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.pb_2
end on

on w_cm320_no_atender.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
if f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;il_opcion = message.Doubleparm
f_centrar( this )

this.title = "Articulos a no Atenderse"
CHOOSE CASE il_opcion
	CASE 1	// Solcitud de compra		
		dw_master.title = "SOLICITUDES DE COMPRA"
		dw_master.dataobject = "d_sel_no_atender_solicitud_compra"
		dw_detail.title = "DETALLE DE SOLICITUDES DE COMPRA"
		dw_detail.dataobject = "d_sel_no_atender_solicitud_compra_det"
	CASE 2	// Solcitud de servicio
		dw_master.title = "SOLICITUDES DE SERVICIO"
		dw_master.dataobject = "d_dddw_solicitud_servicio_tbl"
		dw_detail.title = "DETALLE DE SOLICITUDES DE SERVICIO"
		dw_detail.dataobject = "d_abc_sol_serv_detalle1_tbl"
	CASE 3	// Programa de compras
		dw_master.title = "PROGRAMA DE COMPRAS"
		dw_master.dataobject = "d_list_prog_compras_tbl"
		dw_detail.title = "DETALLE DE PROGRAMA DE COMPRAS"
		dw_detail.dataobject = "d_abc_programa_compras_det"
	CASE 4	// Orden de compras
		// Busca el documento orden de compra
		Select doc_oc 
			into :is_tipo_doc 
		from logparam 
		where reckey = 1;
		
		dw_master.title = "ORDEN DE COMPRAS"
		dw_master.dataobject = "d_sel_no_atender_oc"
		
		dw_detail.title = "DETALLE DE ORDEN DE COMPRAS"
		dw_detail.dataobject = "d_sel_no_atender_oc_det"
		
	CASE 5	// Orden de servicio		
		dw_master.title = "ORDEN DE SERVICIO"
		dw_master.dataobject = "d_dddw_orden_servicio_tbl"
		dw_detail.title = "DETALLE DE ORDEN DE SERVICIO"
		dw_detail.dataobject = "d_abc_orden_servicio_det1_cm209"
END CHOOSE
dw_master.SetTransObject(SQLCA)
dw_detail.SetTransObject(SQLCA)
dw_master.Retrieve()
end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 60
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm320_no_atender
integer x = 0
integer y = 0
integer width = 1879
integer height = 788
boolean titlebar = true
string dataobject = "d_blanco_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;if il_opcion = 4 then
	idw_det.retrieve(aa_id[1], is_tipo_doc, aa_id[2])
elseif il_opcion = 2 then
	idw_det.retrieve(aa_id[1])
elseif il_opcion = 3 then  //Programa de compras
	idw_det.retrieve(aa_id[2])
else
	idw_det.retrieve(aa_id[1], aa_id[2])
end if
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow > 0 then
	f_select_current_row( this )
	THIS.EVENT ue_retrieve_det(currentrow)
end if
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm320_no_atender
integer x = 0
integer y = 796
integer width = 1879
integer height = 732
boolean titlebar = true
string dataobject = "d_blanco_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1	      // columnas que recibimos del master

end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(This)
end event

event dw_detail::doubleclicked;call super::doubleclicked;Integer li_opcion 

Accepttext()

IF row = 0 THEN Return

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

type pb_1 from picturebutton within w_cm320_no_atender
integer x = 681
integer y = 1576
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.triggerevent ("ue_update")
end event

type pb_2 from picturebutton within w_cm320_no_atender
integer x = 1019
integer y = 1580
integer width = 315
integer height = 180
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;Close ( parent )
end event

