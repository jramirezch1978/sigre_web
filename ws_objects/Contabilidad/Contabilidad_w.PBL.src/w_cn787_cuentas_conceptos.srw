$PBExportHeader$w_cn787_cuentas_conceptos.srw
forward
global type w_cn787_cuentas_conceptos from w_report_smpl
end type
type st_1 from statictext within w_cn787_cuentas_conceptos
end type
type em_ano from uo_ingreso_numerico within w_cn787_cuentas_conceptos
end type
type st_2 from statictext within w_cn787_cuentas_conceptos
end type
type sle_cnta_cntbl from singlelineedit within w_cn787_cuentas_conceptos
end type
type cb_buscar from commandbutton within w_cn787_cuentas_conceptos
end type
type rb_total from radiobutton within w_cn787_cuentas_conceptos
end type
type rb_detalle from radiobutton within w_cn787_cuentas_conceptos
end type
type cb_1 from commandbutton within w_cn787_cuentas_conceptos
end type
type rb_acum from radiobutton within w_cn787_cuentas_conceptos
end type
type gb_busqueda from groupbox within w_cn787_cuentas_conceptos
end type
end forward

global type w_cn787_cuentas_conceptos from w_report_smpl
integer width = 2999
integer height = 1008
string title = "[CN787] Cuentas por Conceptos"
string menuname = "m_abc_report_smpl"
long backcolor = 67108864
st_1 st_1
em_ano em_ano
st_2 st_2
sle_cnta_cntbl sle_cnta_cntbl
cb_buscar cb_buscar
rb_total rb_total
rb_detalle rb_detalle
cb_1 cb_1
rb_acum rb_acum
gb_busqueda gb_busqueda
end type
global w_cn787_cuentas_conceptos w_cn787_cuentas_conceptos

on w_cn787_cuentas_conceptos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.st_1=create st_1
this.em_ano=create em_ano
this.st_2=create st_2
this.sle_cnta_cntbl=create sle_cnta_cntbl
this.cb_buscar=create cb_buscar
this.rb_total=create rb_total
this.rb_detalle=create rb_detalle
this.cb_1=create cb_1
this.rb_acum=create rb_acum
this.gb_busqueda=create gb_busqueda
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_cnta_cntbl
this.Control[iCurrent+5]=this.cb_buscar
this.Control[iCurrent+6]=this.rb_total
this.Control[iCurrent+7]=this.rb_detalle
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.rb_acum
this.Control[iCurrent+10]=this.gb_busqueda
end on

on w_cn787_cuentas_conceptos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.st_2)
destroy(this.sle_cnta_cntbl)
destroy(this.cb_buscar)
destroy(this.rb_total)
destroy(this.rb_detalle)
destroy(this.cb_1)
destroy(this.rb_acum)
destroy(this.gb_busqueda)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano
string  ls_cnta_ctbl

li_ano = integer(em_ano.text)

ls_cnta_ctbl = trim(string(sle_cnta_cntbl.text))

if rb_total.checked = true then
	
	dw_report.dataobject = 'd_rpt_cuentas_concepto'
	
elseif rb_detalle.checked = true then
	
	dw_report.dataobject = 'd_rpt_cuentas_concepto_det'
	ls_cnta_ctbl = ls_cnta_ctbl + '%'
	
else
	
	dw_report.dataobject = 'd_rpt_cuentas_concepto_acum'
	ls_cnta_ctbl = ls_cnta_ctbl + '%'
	
end if

dw_report.settransobject( sqlca )
dw_report.retrieve( li_ano, ls_cnta_ctbl , gs_empresa, gs_user )
dw_report.object.p_logo.filename = gs_logo

ib_preview = false

this.event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_cn787_cuentas_conceptos
integer x = 37
integer y = 256
integer width = 2862
integer height = 452
string dataobject = "d_rpt_cuentas_concepto"
integer ii_zoom_actual = 100
end type

type st_1 from statictext within w_cn787_cuentas_conceptos
integer x = 73
integer y = 120
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from uo_ingreso_numerico within w_cn787_cuentas_conceptos
integer x = 229
integer y = 108
integer width = 242
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
string text = "2004"
string mask = "####"
double increment = 1
end type

event constructor;call super::constructor;this.text = string(today(),'yyyy')
end event

type st_2 from statictext within w_cn787_cuentas_conceptos
integer x = 498
integer y = 120
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta Contable:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_cnta_cntbl from singlelineedit within w_cn787_cuentas_conceptos
integer x = 937
integer y = 108
integer width = 425
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event losefocus;string ls_cuenta
long ll_count

if rb_total.checked = true then

	ls_cuenta = trim(this.text)
	
	if ls_cuenta = '' or isnull(ls_cuenta) then return
	
	select count(*)
	  into :ll_count
	  from cntbl_cnta
	 where cnta_ctbl = :ls_cuenta;
		
	if ll_count = 0 then
		messagebox('Aviso','Cuenta Contable no existe')
		this.text = ''
	end if
	
end if
	
end event

type cb_buscar from commandbutton within w_cn787_cuentas_conceptos
integer x = 2597
integer y = 128
integer width = 297
integer height = 100
integer taborder = 20
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

event clicked;string ls_cnta_ctbl

if rb_total.checked = true then
	
	ls_cnta_ctbl = trim(string(sle_cnta_cntbl.text))
	
	if trim(ls_cnta_ctbl) = '' or isnull(ls_cnta_ctbl) then
		messagebox('Aviso','Debe e Ingresar una Cuenta Contable Valida')
		sle_cnta_cntbl.text = ''
		return
	end if
	
end if

parent.event ue_retrieve()
end event

type rb_total from radiobutton within w_cn787_cuentas_conceptos
integer x = 1600
integer y = 48
integer width = 937
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Año y Cuenta Contable"
boolean checked = true
end type

event clicked;sle_cnta_cntbl.text = ''
sle_cnta_cntbl.limit = 10
end event

type rb_detalle from radiobutton within w_cn787_cuentas_conceptos
integer x = 1600
integer y = 112
integer width = 937
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Año y Cnta Contable a dos digitos"
end type

event clicked;sle_cnta_cntbl.text = ''
sle_cnta_cntbl.limit = 2
end event

type cb_1 from commandbutton within w_cn787_cuentas_conceptos
integer x = 1381
integer y = 108
integer width = 96
integer height = 80
integer taborder = 40
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
lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
								 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
								 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
								 +'FROM CNTBL_CNTA ' &
								 +'WHERE CNTBL_CNTA.FLAG_PERMITE_MOV = 1 AND FLAG_ESTADO <> 0 '
									  
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_cnta_cntbl.text = lstr_seleccionar.param1[1]
END IF
end event

type rb_acum from radiobutton within w_cn787_cuentas_conceptos
integer x = 1600
integer y = 176
integer width = 937
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Año Acumulado"
end type

type gb_busqueda from groupbox within w_cn787_cuentas_conceptos
integer x = 37
integer y = 32
integer width = 1504
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

