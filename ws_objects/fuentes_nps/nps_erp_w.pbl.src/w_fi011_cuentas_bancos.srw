$PBExportHeader$w_fi011_cuentas_bancos.srw
forward
global type w_fi011_cuentas_bancos from w_abc_master_smpl
end type
type st_1 from statictext within w_fi011_cuentas_bancos
end type
type dw_1 from datawindow within w_fi011_cuentas_bancos
end type
type rb_2 from radiobutton within w_fi011_cuentas_bancos
end type
type rb_1 from radiobutton within w_fi011_cuentas_bancos
end type
end forward

global type w_fi011_cuentas_bancos from w_abc_master_smpl
integer width = 2363
integer height = 1752
string title = "[FI011] Cuentas de Banco"
string menuname = "m_mtto_lista"
event ue_find_exact ( )
st_1 st_1
dw_1 dw_1
rb_2 rb_2
rb_1 rb_1
end type
global w_fi011_cuentas_bancos w_fi011_cuentas_bancos

type variables
String is_accion,is_col,is_tipo
end variables

on w_fi011_cuentas_bancos.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
this.st_1=create st_1
this.dw_1=create dw_1
this.rb_2=create rb_2
this.rb_1=create rb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
end on

on w_fi011_cuentas_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.rb_2)
destroy(this.rb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0



end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
String ls_where,ls_old_select,ls_new_select
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_lista_banco_cnta_tbl'
sl_param.titulo = 'Cuentas de Banco'
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	ls_where   = ' WHERE BANCO_CNTA.COD_CTABCO = '+"'"+sl_param.field_ret[1]+"'"
	ls_old_select = dw_master.GetSQLSelect()
	ls_new_select = ls_old_select + ls_where
	dw_master.SetSQLSelect(ls_new_select)
	dw_master.Retrieve()
	dw_master.SetSQLSelect(ls_old_select)
	dw_master.ii_update = 0
	TriggerEvent('ue_modify')
END IF
end event

type ole_skin from w_abc_master_smpl`ole_skin within w_fi011_cuentas_bancos
end type

type uo_h from w_abc_master_smpl`uo_h within w_fi011_cuentas_bancos
end type

type st_box from w_abc_master_smpl`st_box within w_fi011_cuentas_bancos
end type

type st_filter from w_abc_master_smpl`st_filter within w_fi011_cuentas_bancos
boolean visible = false
boolean enabled = false
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_fi011_cuentas_bancos
boolean visible = false
boolean enabled = false
end type

type dw_master from w_abc_master_smpl`dw_master within w_fi011_cuentas_bancos
event ue_refresh_det ( )
integer x = 503
integer y = 332
integer width = 1728
integer height = 668
string dataobject = "d_abc_cnta_bco_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_accion = 'new'
this.object.flag_estado [al_row] = '1'
end event

event dw_master::itemchanged;call super::itemchanged;AcceptText()
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'
end event

type st_1 from statictext within w_fi011_cuentas_bancos
integer x = 544
integer y = 176
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda por :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_fi011_cuentas_bancos
event dwnenter pbm_dwnprocessenter
integer x = 942
integer y = 168
integer width = 1307
integer height = 76
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnenter;String ls_cta_ctbl ,ls_cta_bco ,ls_old_select,ls_new_select,ls_where

dw_1.Accepttext()


IF rb_1.checked THEN
	ls_cta_ctbl = dw_1.object.campo [1]
	ls_where   = ' WHERE BANCO_CNTA.CNTA_CTBL = '+"'"+ls_cta_ctbl+"'"
ELSE
	ls_cta_bco = dw_1.object.campo [1]
	ls_where   = ' WHERE BANCO_CNTA.COD_CTABCO = '+"'"+ls_cta_bco+"'"
END IF

//ls_where   = ' WHERE BANCO_CNTA.COD_CTABCO = '+"'"+ls_cta_bco+"'"
ls_old_select = dw_master.GetSQLSelect()
ls_new_select = ls_old_select + ls_where
dw_master.SetSQLSelect(ls_new_select)
dw_master.Retrieve()
dw_master.SetSQLSelect(ls_old_select)


return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

type rb_2 from radiobutton within w_fi011_cuentas_bancos
integer x = 983
integer y = 264
integer width = 343
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta. Banco"
end type

type rb_1 from radiobutton within w_fi011_cuentas_bancos
integer x = 558
integer y = 264
integer width = 343
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cta. Ctble"
boolean checked = true
end type

