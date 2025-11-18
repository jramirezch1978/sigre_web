$PBExportHeader$w_al310_asignar_factura.srw
forward
global type w_al310_asignar_factura from w_abc_master_smpl
end type
type st_1 from statictext within w_al310_asignar_factura
end type
type sle_guia from singlelineedit within w_al310_asignar_factura
end type
type cb_1 from commandbutton within w_al310_asignar_factura
end type
type dw_2 from u_dw_abc within w_al310_asignar_factura
end type
type st_2 from statictext within w_al310_asignar_factura
end type
type st_3 from statictext within w_al310_asignar_factura
end type
type st_4 from statictext within w_al310_asignar_factura
end type
end forward

global type w_al310_asignar_factura from w_abc_master_smpl
integer width = 1765
integer height = 1148
string title = "Asignacion de factura [AL310]"
string menuname = "m_mantenimiento_sl"
st_1 st_1
sle_guia sle_guia
cb_1 cb_1
dw_2 dw_2
st_2 st_2
st_3 st_3
st_4 st_4
end type
global w_al310_asignar_factura w_al310_asignar_factura

on w_al310_asignar_factura.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_1=create st_1
this.sle_guia=create sle_guia
this.cb_1=create cb_1
this.dw_2=create dw_2
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_guia
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
end on

on w_al310_asignar_factura.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_guia)
destroy(this.cb_1)
destroy(this.dw_2)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
end on

event ue_open_pre();call super::ue_open_pre;of_center_window()

ii_lec_mst = 0
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_al310_asignar_factura
integer x = 1134
integer y = 56
integer width = 567
integer height = 112
integer taborder = 20
string dataobject = "d_abc_asigna_factura"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'
end event

type st_1 from statictext within w_al310_asignar_factura
integer x = 9
integer y = 48
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Guia:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_guia from singlelineedit within w_al310_asignar_factura
integer x = 229
integer y = 44
integer width = 398
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ln_count
string ls_nrovale, ls_tipo, ls_nro

// Busca numero de guia
Select count(*) into :ln_count from guia 
   where nro_guia = :sle_guia.text;
	
if ln_count = 0 then
	Messagebox( "Error", "Nro de guia no existe")
	sle_guia.text = ''
	return
end if

dw_master.retrieve( sle_guia.text)
dw_2.retrieve( sle_guia.text)

if not isnull(dw_master.object.tipo_doc[dw_master.getrow()]) then
	messagebox( "Atencion", "Guia ya tiene referencia")
	sle_guia.text = ''
	dw_master.reset()
	dw_2.reset()
	return
end if
end event

type cb_1 from commandbutton within w_al310_asignar_factura
integer x = 635
integer y = 48
integer width = 69
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_parametros sl_param

sl_param.dw1    = 'd_dddw_guias'
sl_param.titulo = 'Guias de Remision'
sl_param.field_ret_i[1] = 2

OpenWithParm( w_search, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	sle_guia.text = sl_param.field_ret[1]
	dw_2.retrieve( sle_guia.text)
	dw_master.retrieve(sle_guia.text)
END IF
end event

type dw_2 from u_dw_abc within w_al310_asignar_factura
integer x = 338
integer y = 212
integer width = 1015
integer height = 532
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_sel_factura_oventa"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ii_ck[1] = 1	
this.setTransObject(sqlca)

is_dwform = 'tabular'
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	dw_master.retrieve(sle_guia.text)
	dw_master.object.tipo_doc[dw_master.getrow()] = this.object.tipo_doc[row]
	dw_master.object.nro_doc [dw_master.getrow()] = this.object.nro_doc[row]	
	dw_master.ii_update = 1
end if
end event

type st_2 from statictext within w_al310_asignar_factura
integer x = 718
integer y = 60
integer width = 389
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Doc. Asignado:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_al310_asignar_factura
integer x = 59
integer y = 796
integer width = 1591
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese nro. de guia, de doble click sobre el documento que "
boolean focusrectangle = false
end type

type st_4 from statictext within w_al310_asignar_factura
integer x = 59
integer y = 856
integer width = 923
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "desea asignar, y grabe la operacion."
boolean focusrectangle = false
end type

