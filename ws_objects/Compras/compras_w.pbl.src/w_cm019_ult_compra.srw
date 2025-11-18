$PBExportHeader$w_cm019_ult_compra.srw
forward
global type w_cm019_ult_compra from w_abc_master_smpl
end type
type cb_1 from commandbutton within w_cm019_ult_compra
end type
type st_1 from statictext within w_cm019_ult_compra
end type
end forward

global type w_cm019_ult_compra from w_abc_master_smpl
integer width = 2281
integer height = 1480
string title = "Modificar Ult Compra (CM019)"
string menuname = "m_mantto_smpl"
boolean maxbox = false
event ue_subcateg ( )
cb_1 cb_1
st_1 st_1
end type
global w_cm019_ult_compra w_cm019_ult_compra

type variables
string is_null[], is_subcateg[]
end variables

event ue_subcateg();str_parametros sl_param

sl_param.dw1 		= "d_list_articulo_sub_categ_tbl"
sl_param.titulo 	= "Sub Categorías"
sl_param.dw_m 		= dw_master
sl_param.opcion 	= 1
OpenWithParm( w_abc_seleccion, sl_param)

end event

on w_cm019_ult_compra.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
end on

on w_cm019_ult_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_delete;// Ancestor Script has been Override
MessageBox('Aviso', 'Opcion no disponible en esta ventana')

end event

type dw_master from w_abc_master_smpl`dw_master within w_cm019_ult_compra
integer y = 140
integer width = 2190
integer height = 1132
string dataobject = "d_abc_art_ult_compra"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_clase.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

type cb_1 from commandbutton within w_cm019_ult_compra
integer x = 23
integer y = 24
integer width = 425
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sub Categorias"
end type

event clicked;parent.event dynamic ue_subcateg()

end event

type st_1 from statictext within w_cm019_ult_compra
integer x = 503
integer y = 16
integer width = 1600
integer height = 108
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En Esta ventana modificas el precio de ultima compra de la Tabla ARTICULO de aquellos artículos que no tienen Precio Ult Compra"
boolean focusrectangle = false
end type

