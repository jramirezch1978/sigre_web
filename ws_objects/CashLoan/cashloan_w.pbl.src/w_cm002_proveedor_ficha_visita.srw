$PBExportHeader$w_cm002_proveedor_ficha_visita.srw
forward
global type w_cm002_proveedor_ficha_visita from w_report_smpl
end type
type rb_1 from radiobutton within w_cm002_proveedor_ficha_visita
end type
type rb_2 from radiobutton within w_cm002_proveedor_ficha_visita
end type
type gb_1 from groupbox within w_cm002_proveedor_ficha_visita
end type
end forward

global type w_cm002_proveedor_ficha_visita from w_report_smpl
integer width = 2299
integer height = 1936
string title = "[CM002] Formato de Visitas de Cliente/Proveedor"
string menuname = "m_impresion"
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_cm002_proveedor_ficha_visita w_cm002_proveedor_ficha_visita

type variables
str_parametros istr_parametros
end variables

on w_cm002_proveedor_ficha_visita.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.gb_1
end on

on w_cm002_proveedor_ficha_visita.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event open;call super::open;if isvalid(message.powerobjectparm) then
	
	istr_parametros = message.powerobjectparm
	
	if istr_parametros.string2 = '0' then
		rb_1.checked = false
		rb_1.enabled = false
		rb_2.checked = true
	elseif istr_parametros.string2 = '1' then
		rb_2.enabled = false
	end if
	
end if
end event

event ue_open_pre;call super::ue_open_pre;post event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;string ls_titulo, ls_codigo, ls_version, ls_fecha
dw_report.reset()
dw_report.insertrow(0)

dw_report.object.nombre_cliente[1] = istr_parametros.string1

if rb_2.checked then
	ls_titulo ='VISITA A CLIENTE'
	ls_codigo = 'CANT.FO.08.3'
	ls_version = 'VERSION: 00'
	ls_fecha = 'FECHA: 24/03/2014'
else
	ls_titulo ='VISITA A PROVEEDOR'
	ls_codigo = 'CANT.FO.07.3'
	ls_version = 'VERSION: 00'
	ls_fecha = 'FECHA: 06/03/2014'
end if

dw_report.object.t_titulobasc1.text = ls_titulo
dw_report.object.t_codigobasc.text = ls_codigo
dw_report.object.t_versionbasc.text = ls_version
dw_report.object.t_fecha.text = ls_fecha
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_cm002_proveedor_ficha_visita
integer x = 0
integer y = 252
integer width = 2267
integer height = 1440
string dataobject = "d_rpt_proveedor_basc_visista_tbl"
end type

type rb_1 from radiobutton within w_cm002_proveedor_ficha_visita
integer x = 55
integer y = 96
integer width = 393
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor"
boolean checked = true
end type

event clicked;parent.event ue_retrieve()
end event

type rb_2 from radiobutton within w_cm002_proveedor_ficha_visita
integer x = 466
integer y = 96
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente"
end type

event clicked;parent.event ue_retrieve()
end event

type gb_1 from groupbox within w_cm002_proveedor_ficha_visita
integer width = 823
integer height = 236
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

