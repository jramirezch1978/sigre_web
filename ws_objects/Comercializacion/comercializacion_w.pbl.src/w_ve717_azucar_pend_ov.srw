$PBExportHeader$w_ve717_azucar_pend_ov.srw
forward
global type w_ve717_azucar_pend_ov from w_report_smpl
end type
type cb_4 from commandbutton within w_ve717_azucar_pend_ov
end type
type sle_clase from singlelineedit within w_ve717_azucar_pend_ov
end type
type cb_1 from commandbutton within w_ve717_azucar_pend_ov
end type
type sle_desc_clase from singlelineedit within w_ve717_azucar_pend_ov
end type
type gb_1 from groupbox within w_ve717_azucar_pend_ov
end type
end forward

global type w_ve717_azucar_pend_ov from w_report_smpl
integer width = 1865
integer height = 1104
string title = "Ordenes de Venta Pendientes por Codigo de Clase (VE717)"
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
cb_4 cb_4
sle_clase sle_clase
cb_1 cb_1
sle_desc_clase sle_desc_clase
gb_1 gb_1
end type
global w_ve717_azucar_pend_ov w_ve717_azucar_pend_ov

type variables
Integer ii_index
end variables

on w_ve717_azucar_pend_ov.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_4=create cb_4
this.sle_clase=create sle_clase
this.cb_1=create cb_1
this.sle_desc_clase=create sle_desc_clase
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.sle_clase
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_desc_clase
this.Control[iCurrent+5]=this.gb_1
end on

on w_ve717_azucar_pend_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.sle_clase)
destroy(this.cb_1)
destroy(this.sle_desc_clase)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_doc_ov, ls_clase

select doc_ov
  into :ls_doc_ov
  from logparam
 where reckey = '1';

ls_clase = sle_clase.text

if isnull(ls_clase) or ls_clase = '' then
	messagebox('Aviso','Debe de Ingresar una clase valida')
	return
end if

dw_report.retrieve( ls_doc_ov , ls_clase )
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_objeto.text = dw_report.dataobject
dw_report.object.t_texto.text = ls_clase + ' - ' + sle_desc_clase.text
end event

event ue_open_pre;call super::ue_open_pre;string ls_clase, ls_Desc

select clase_prod_term
  into :ls_clase
  from sig_agricola
 where reckey = '1';

sle_clase.text = ls_clase

select desc_clase
  into :ls_desc
  from articulo_clase
 where cod_clase = :ls_clase;

sle_desc_clase.text = ls_desc
end event

type dw_report from w_report_smpl`dw_report within w_ve717_azucar_pend_ov
integer x = 37
integer y = 256
integer width = 1723
integer height = 580
string dataobject = "d_rpt_pend_entrega_azuc_tbl"
end type

type cb_4 from commandbutton within w_ve717_azucar_pend_ov
integer x = 1426
integer y = 128
integer width = 334
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Parent.event ue_retrieve()

end event

type sle_clase from singlelineedit within w_ve717_azucar_pend_ov
integer x = 73
integer y = 104
integer width = 347
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ve717_azucar_pend_ov
integer x = 434
integer y = 104
integer width = 105
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT COD_CLASE AS CODIGO, '&
								 +'DESC_CLASE AS CIENTIFICO '&
								 +'FROM ARTICULO_CLASE '&
								 +"WHERE NVL(FLAG_ESTADO,'1') = '1'"

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_clase.text = trim( lstr_seleccionar.param1[1])
	sle_desc_clase.text = trim( lstr_seleccionar.param2[1])
END IF
end event

type sle_desc_clase from singlelineedit within w_ve717_azucar_pend_ov
integer x = 553
integer y = 104
integer width = 809
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_ve717_azucar_pend_ov
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Codigo de Clase"
end type

