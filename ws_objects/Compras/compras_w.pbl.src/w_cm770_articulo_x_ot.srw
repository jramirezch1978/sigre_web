$PBExportHeader$w_cm770_articulo_x_ot.srw
forward
global type w_cm770_articulo_x_ot from w_report_smpl
end type
type st_1 from statictext within w_cm770_articulo_x_ot
end type
type cb_1 from commandbutton within w_cm770_articulo_x_ot
end type
type em_nro_ot from u_sle_codigo within w_cm770_articulo_x_ot
end type
end forward

global type w_cm770_articulo_x_ot from w_report_smpl
integer width = 3643
integer height = 1628
string title = "cm770_articulos_x_ot"
string menuname = "m_impresion"
long backcolor = 134217750
st_1 st_1
cb_1 cb_1
em_nro_ot em_nro_ot
end type
global w_cm770_articulo_x_ot w_cm770_articulo_x_ot

on w_cm770_articulo_x_ot.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.cb_1=create cb_1
this.em_nro_ot=create em_nro_ot
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.em_nro_ot
end on

on w_cm770_articulo_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.em_nro_ot)
end on

event ue_retrieve;call super::ue_retrieve;String ls_doc_ot, ls_nro_ot
select doc_ot 
  into :ls_doc_ot 
  from logparam 
 where reckey='1' ;
 
 ls_nro_ot = em_nro_ot.text
 dw_report.retrieve(ls_doc_ot, ls_nro_ot)
 
 
dw_report.Visible = True
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_user.text     = gs_user
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_objeto.text   = dw_report.dataobject
dw_report.object.t_texto.text   = ls_nro_ot

 
end event

type dw_report from w_report_smpl`dw_report within w_cm770_articulo_x_ot
integer x = 46
integer y = 224
integer width = 3525
integer height = 1200
string dataobject = "d_rpt_articulos_x_ot_tbl"
end type

type st_1 from statictext within w_cm770_articulo_x_ot
integer x = 87
integer y = 76
integer width = 681
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
string text = "Nro de orden de Trabajo :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cm770_articulo_x_ot
integer x = 1253
integer y = 52
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Parent.event ue_retrieve()


end event

type em_nro_ot from u_sle_codigo within w_cm770_articulo_x_ot
integer x = 777
integer y = 60
integer width = 402
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

