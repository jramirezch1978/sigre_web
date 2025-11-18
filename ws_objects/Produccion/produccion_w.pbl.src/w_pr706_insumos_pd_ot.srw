$PBExportHeader$w_pr706_insumos_pd_ot.srw
forward
global type w_pr706_insumos_pd_ot from w_rpt_general
end type
type cb_buscar from cb_aceptar within w_pr706_insumos_pd_ot
end type
type sle_parte from singlelineedit within w_pr706_insumos_pd_ot
end type
type st_1 from statictext within w_pr706_insumos_pd_ot
end type
end forward

global type w_pr706_insumos_pd_ot from w_rpt_general
integer width = 1888
integer height = 1744
string title = "Insumos por Parte Diario( PR706)"
cb_buscar cb_buscar
sle_parte sle_parte
st_1 st_1
end type
global w_pr706_insumos_pd_ot w_pr706_insumos_pd_ot

on w_pr706_insumos_pd_ot.create
int iCurrent
call super::create
this.cb_buscar=create cb_buscar
this.sle_parte=create sle_parte
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.sle_parte
this.Control[iCurrent+3]=this.st_1
end on

on w_pr706_insumos_pd_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.sle_parte)
destroy(this.st_1)
end on

type dw_report from w_rpt_general`dw_report within w_pr706_insumos_pd_ot
integer y = 144
integer width = 1829
integer height = 1380
string dataobject = "d_rpt_pd_ot_insumos_tbl"
end type

type cb_buscar from cb_aceptar within w_pr706_insumos_pd_ot
integer x = 905
integer y = 28
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
boolean default = true
end type

event ue_procesar;call super::ue_procesar;parent.event dynamic ue_retrieve()
end event

type sle_parte from singlelineedit within w_pr706_insumos_pd_ot
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 475
integer y = 28
integer width = 416
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
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

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Asigna valores a structura 
str_parametros sl_param

sl_param.dw1    = 'd_abc_lista_pd_ot_tbl'
sl_param.titulo = "Partes Diario de Orden de Trabajo"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = '1SQL'
sl_param.string1 =  ' WHERE ("VW_OPE_PT_X_ADM"."COD_USR" = '+"'"+gs_user+"'"+')    '&
						 +'ORDER BY "VW_OPE_PT_X_ADM"."NRO_PARTE" DESC  '


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
				
	This.Text = sl_param.field_ret[1]
	parent.event dynamic ue_retrieve()
			
END IF

end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

event modified;//string ls_codigo, ls_data
//
//ls_codigo = trim(this.text)
//
//SetNull(ls_data)
//select descr_especie
//	into :ls_data
//from tg_especies
//where especie = :ls_codigo;
//
//if ls_data = "" or IsNull(ls_data) then
//	Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
//	this.text = ""
//	st_especie.text = ""
//	this.event dynamic ue_reset( )
//	return
//end if
//		
//st_especie.text = ls_data
//
//parent.event dynamic ue_retrieve()
end event

type st_1 from statictext within w_pr706_insumos_pd_ot
integer x = 110
integer y = 40
integer width = 343
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Nro Parte:"
alignment alignment = right!
boolean focusrectangle = false
end type

