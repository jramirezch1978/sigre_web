$PBExportHeader$w_pt765_planilla.srw
forward
global type w_pt765_planilla from w_report_smpl
end type
type cb_1 from commandbutton within w_pt765_planilla
end type
type em_ano from editmask within w_pt765_planilla
end type
type em_mes from editmask within w_pt765_planilla
end type
type st_1 from statictext within w_pt765_planilla
end type
type st_2 from statictext within w_pt765_planilla
end type
type sle_cencos from singlelineedit within w_pt765_planilla
end type
type sle_descripcion from singlelineedit within w_pt765_planilla
end type
type cb_2 from commandbutton within w_pt765_planilla
end type
type cbx_1 from checkbox within w_pt765_planilla
end type
type st_3 from statictext within w_pt765_planilla
end type
type dw_1 from datawindow within w_pt765_planilla
end type
type gb_2 from groupbox within w_pt765_planilla
end type
type gb_1 from groupbox within w_pt765_planilla
end type
end forward

global type w_pt765_planilla from w_report_smpl
integer width = 2670
integer height = 1040
string title = "(PT765] Reporte de Planilla"
string menuname = "m_impresion"
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
sle_cencos sle_cencos
sle_descripcion sle_descripcion
cb_2 cb_2
cbx_1 cbx_1
st_3 st_3
dw_1 dw_1
gb_2 gb_2
gb_1 gb_1
end type
global w_pt765_planilla w_pt765_planilla

on w_pt765_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.sle_cencos=create sle_cencos
this.sle_descripcion=create sle_descripcion
this.cb_2=create cb_2
this.cbx_1=create cbx_1
this.st_3=create st_3
this.dw_1=create dw_1
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_cencos
this.Control[iCurrent+7]=this.sle_descripcion
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.dw_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
end on

on w_pt765_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_cencos)
destroy(this.sle_descripcion)
destroy(this.cb_2)
destroy(this.cbx_1)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes
string  ls_cencos, ls_origen

if cbx_1.checked = true then
	ls_cencos = string(sle_cencos.text)
	if ls_cencos = '' or isnull(ls_cencos) then
		messagebox("Aviso","Debe de ingresar un Centro de Costo")
		return
	end if
else
	ls_cencos = '%%'
end if

li_ano = integer(em_ano.text)

if li_ano = 0 or isnull(li_ano) then
	messagebox("Aviso","Debe de ingresar un Año Valido")
	return
end if

li_mes = integer(em_mes.text)

if li_mes = 0 or isnull(li_mes) then
	messagebox("Aviso","Debe de ingresar un Mes Valido")
	return
end if

ls_origen = dw_1.object.cod_origen[1]

if ls_origen = '' or isnull(ls_origen) then
	messagebox("Aviso","Debe de ingresar un Origen Valido")
	return
end if

idw_1.retrieve(li_ano, li_mes, ls_origen, ls_cencos )
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text	= gs_empresa
idw_1.object.t_usuario.text	= 'Usuario: ' + gs_user
end event

event ue_open_pre;call super::ue_open_pre;dw_1.InsertRow(0)
end event

type dw_report from w_report_smpl`dw_report within w_pt765_planilla
integer x = 37
integer y = 384
integer width = 2528
integer height = 420
integer taborder = 50
string dataobject = "d_rpt_planilla"
end type

event dw_report::doubleclicked;call super::doubleclicked;if row = 0 then return

str_parametros sgt_parametros

integer li_ano, li_mes
string  ls_cencos, ls_origen

ls_cencos = this.object.cencos[row]
if ls_cencos = '' then messagebox("JD","aviso")

li_ano = integer(em_ano.text)

if li_ano = 0 or isnull(li_ano) then
	messagebox("Aviso","Debe de ingresar un Año Valido")
	return
end if

li_mes = integer(em_mes.text)

if li_mes = 0 or isnull(li_mes) then
	messagebox("Aviso","Debe de ingresar un Mes Valido")
	return
end if

ls_origen = dw_1.object.cod_origen[1]

if ls_origen = '' or isnull(ls_origen) then
	messagebox("Aviso","Debe de ingresar un Origen Valido")
	return
end if

sgt_parametros.int1 = li_ano
sgt_parametros.int2 = li_mes
sgt_parametros.string1 = ls_origen
sgt_parametros.string2 = ls_cencos

opensheetwithparm(w_pt765_planilla_det, sgt_parametros, parent,0,lAYERED!)
end event

type cb_1 from commandbutton within w_pt765_planilla
integer x = 951
integer y = 256
integer width = 297
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Parent.Event ue_retrieve()

end event

type em_ano from editmask within w_pt765_planilla
integer x = 238
integer y = 120
integer width = 233
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_pt765_planilla
integer x = 677
integer y = 120
integer width = 174
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "xx"
end type

type st_1 from statictext within w_pt765_planilla
integer x = 110
integer y = 128
integer width = 128
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt765_planilla
integer x = 544
integer y = 128
integer width = 128
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes :"
boolean focusrectangle = false
end type

type sle_cencos from singlelineedit within w_pt765_planilla
integer x = 987
integer y = 116
integer width = 270
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_descripcion from singlelineedit within w_pt765_planilla
integer x = 1371
integer y = 116
integer width = 1157
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_pt765_planilla
integer x = 1271
integer y = 116
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;
// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_cencos_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_cencos, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cencos.text      = sl_param.field_ret[1]
	sle_descripcion.text = sl_param.field_ret[2]
END IF

end event

type cbx_1 from checkbox within w_pt765_planilla
integer x = 1426
integer y = 24
integer width = 73
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	cb_2.enabled = true
else
	cb_2.enabled = false
end if
end event

type st_3 from statictext within w_pt765_planilla
integer x = 55
integer y = 248
integer width = 201
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_pt765_planilla
integer x = 261
integer y = 240
integer width = 503
integer height = 88
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_origent_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;InsertRow(0)
this.settransobject(Sqlca)
this.retrieve()
end event

type gb_2 from groupbox within w_pt765_planilla
integer x = 37
integer y = 32
integer width = 882
integer height = 324
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Opciones"
end type

type gb_1 from groupbox within w_pt765_planilla
integer x = 951
integer y = 32
integer width = 1614
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Centro de Costo "
end type

