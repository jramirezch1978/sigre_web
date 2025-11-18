$PBExportHeader$w_ma731_consumos_cenbef.srw
forward
global type w_ma731_consumos_cenbef from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma731_consumos_cenbef
end type
type st_4 from statictext within w_ma731_consumos_cenbef
end type
type em_ot_adm from editmask within w_ma731_consumos_cenbef
end type
type st_ot_adm from statictext within w_ma731_consumos_cenbef
end type
type cbx_proy from checkbox within w_ma731_consumos_cenbef
end type
type cbx_cer from checkbox within w_ma731_consumos_cenbef
end type
type cbx_gen from checkbox within w_ma731_consumos_cenbef
end type
type cbx_anu from checkbox within w_ma731_consumos_cenbef
end type
type cb_1 from commandbutton within w_ma731_consumos_cenbef
end type
type st_1 from statictext within w_ma731_consumos_cenbef
end type
type em_tipo_ot from editmask within w_ma731_consumos_cenbef
end type
type st_tipo_ot from statictext within w_ma731_consumos_cenbef
end type
type st_3 from statictext within w_ma731_consumos_cenbef
end type
type em_cenbef from editmask within w_ma731_consumos_cenbef
end type
type st_cenbef from statictext within w_ma731_consumos_cenbef
end type
type cbx_maquina from checkbox within w_ma731_consumos_cenbef
end type
type rb_consumo from radiobutton within w_ma731_consumos_cenbef
end type
type rb_servicios from radiobutton within w_ma731_consumos_cenbef
end type
type gb_2 from groupbox within w_ma731_consumos_cenbef
end type
type gb_1 from groupbox within w_ma731_consumos_cenbef
end type
end forward

global type w_ma731_consumos_cenbef from w_report_smpl
integer width = 3634
integer height = 2656
string title = "Consumos/Servicios por Centro de Beneficio (MA731)"
string menuname = "m_impresion"
long backcolor = 67108864
uo_fecha uo_fecha
st_4 st_4
em_ot_adm em_ot_adm
st_ot_adm st_ot_adm
cbx_proy cbx_proy
cbx_cer cbx_cer
cbx_gen cbx_gen
cbx_anu cbx_anu
cb_1 cb_1
st_1 st_1
em_tipo_ot em_tipo_ot
st_tipo_ot st_tipo_ot
st_3 st_3
em_cenbef em_cenbef
st_cenbef st_cenbef
cbx_maquina cbx_maquina
rb_consumo rb_consumo
rb_servicios rb_servicios
gb_2 gb_2
gb_1 gb_1
end type
global w_ma731_consumos_cenbef w_ma731_consumos_cenbef

on w_ma731_consumos_cenbef.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.st_4=create st_4
this.em_ot_adm=create em_ot_adm
this.st_ot_adm=create st_ot_adm
this.cbx_proy=create cbx_proy
this.cbx_cer=create cbx_cer
this.cbx_gen=create cbx_gen
this.cbx_anu=create cbx_anu
this.cb_1=create cb_1
this.st_1=create st_1
this.em_tipo_ot=create em_tipo_ot
this.st_tipo_ot=create st_tipo_ot
this.st_3=create st_3
this.em_cenbef=create em_cenbef
this.st_cenbef=create st_cenbef
this.cbx_maquina=create cbx_maquina
this.rb_consumo=create rb_consumo
this.rb_servicios=create rb_servicios
this.gb_2=create gb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.em_ot_adm
this.Control[iCurrent+4]=this.st_ot_adm
this.Control[iCurrent+5]=this.cbx_proy
this.Control[iCurrent+6]=this.cbx_cer
this.Control[iCurrent+7]=this.cbx_gen
this.Control[iCurrent+8]=this.cbx_anu
this.Control[iCurrent+9]=this.cb_1
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.em_tipo_ot
this.Control[iCurrent+12]=this.st_tipo_ot
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.em_cenbef
this.Control[iCurrent+15]=this.st_cenbef
this.Control[iCurrent+16]=this.cbx_maquina
this.Control[iCurrent+17]=this.rb_consumo
this.Control[iCurrent+18]=this.rb_servicios
this.Control[iCurrent+19]=this.gb_2
this.Control[iCurrent+20]=this.gb_1
end on

on w_ma731_consumos_cenbef.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.st_4)
destroy(this.em_ot_adm)
destroy(this.st_ot_adm)
destroy(this.cbx_proy)
destroy(this.cbx_cer)
destroy(this.cbx_gen)
destroy(this.cbx_anu)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_tipo_ot)
destroy(this.st_tipo_ot)
destroy(this.st_3)
destroy(this.em_cenbef)
destroy(this.st_cenbef)
destroy(this.cbx_maquina)
destroy(this.rb_consumo)
destroy(this.rb_servicios)
destroy(this.gb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_ot_adm, ls_tipo_ot, ls_Cenbef, &
			ls_maquina
String 	ls_estado[]
DAte		ld_fecha1, ld_Fecha2

ld_Fecha1 = uo_fecha.of_get_fecha1()
ld_Fecha2 = uo_fecha.of_get_fecha2()

if trim(em_ot_adm.text) = '' then
	ls_ot_adm = '%%'
else
	ls_ot_adm = trim(em_ot_adm.text) + '%'
end if

if trim(em_tipo_ot.text) = '' then
	ls_tipo_ot = '%%'
else
	ls_tipo_ot = trim(em_tipo_ot.text) + '%'
end if

if trim(em_cenbef.text) = '' then
	ls_cenbef = '%%'
else
	ls_cenbef = trim(em_cenbef.text) + '%'
end if

if cbx_anu.checked = true then
	ls_estado[1] = '0'
else
	ls_estado[1] = ''
end if

if cbx_gen.checked = true then
	ls_estado[2] = '1'
else
	ls_estado[2] = ''
end if

if cbx_cer.checked = true then
	ls_estado[3] = '2'
else
	ls_estado[3] = ''
end if

if cbx_proy.checked = true then
	ls_estado[4] = '3'
else
	ls_estado[4] = ''
end if


if cbx_maquina.checked = true then
	ls_maquina = '1'
else
	ls_maquina = '0'
end if

if rb_consumo.checked then
	idw_1.DataObject = 'd_rpt_consumo_cenbef_ot'
elseif rb_servicios.checked then
	if cbx_maquina.checked then
		idw_1.DataObject = 'd_rpt_servicios_cenbef_maq_ot'
	else
		idw_1.dataobject = 'd_rpt_servicios_cenbef_ot'
	end if
end if

idw_1.SetTransobject( SQLCA )

idw_1.Retrieve( ld_fecha1, ld_fecha2, ls_tipo_ot, ls_ot_adm, ls_cenbef, ls_estado, ls_maquina )

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.datawindow.print.orientation = 1
idw_1.object.titulo_1.text = 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')
if trim(em_tipo_ot.text) = '' then
	idw_1.object.titulo_2.text = 'Todos los Tipos de OT'
else
	idw_1.object.titulo_2.text = st_tipo_ot.text
end if

end event

type dw_report from w_report_smpl`dw_report within w_ma731_consumos_cenbef
integer x = 0
integer y = 552
integer width = 2807
integer height = 1528
string dataobject = "d_rpt_consumo_cenbef_ot"
end type

type uo_fecha from u_ingreso_rango_fechas within w_ma731_consumos_cenbef
integer x = 5
integer y = 20
integer taborder = 30
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 
of_set_rango_fin(date('31/12/9999')) 
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_4 from statictext within w_ma731_consumos_cenbef
integer x = 14
integer y = 132
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT ADM"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ot_adm from editmask within w_ma731_consumos_cenbef
event ue_dobleclick pbm_lbuttondblclk
integer x = 462
integer y = 112
integer width = 297
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

event ue_dobleclick;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

ls_sql = "SELECT distinct a.ot_adm AS CODIGO, " &
		  + "a.descripcion AS descripcion_ot_adm " &
		  + "FROM ot_Administracion a, " &
		  + "orden_Trabajo ot " &
		  + "where ot.ot_adm = a.ot_adm " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text		= ls_codigo
	st_ot_adm.text = ls_data
end if


end event

type st_ot_adm from statictext within w_ma731_consumos_cenbef
integer x = 768
integer y = 116
integer width = 1175
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_proy from checkbox within w_ma731_consumos_cenbef
integer x = 2455
integer y = 184
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Proyectado"
boolean checked = true
end type

type cbx_cer from checkbox within w_ma731_consumos_cenbef
integer x = 2455
integer y = 96
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cerrado"
boolean checked = true
end type

type cbx_gen from checkbox within w_ma731_consumos_cenbef
integer x = 2039
integer y = 184
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Aprobado"
boolean checked = true
end type

type cbx_anu from checkbox within w_ma731_consumos_cenbef
integer x = 2039
integer y = 96
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Anulado"
boolean checked = true
end type

type cb_1 from commandbutton within w_ma731_consumos_cenbef
integer x = 2875
integer y = 64
integer width = 343
integer height = 100
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type st_1 from statictext within w_ma731_consumos_cenbef
integer x = 14
integer y = 220
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "TIPO DE OT"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_tipo_ot from editmask within w_ma731_consumos_cenbef
event ue_dobleclick pbm_lbuttondblclk
integer x = 462
integer y = 208
integer width = 297
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

event ue_dobleclick;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

ls_sql = "SELECT distinct a.ot_tipo AS CODIGO, " &
		  + "a.descripcion AS descripcion_ot_tipo " &
		  + "FROM ot_tipo a, " &
		  + "orden_Trabajo ot " &
		  + "where ot.ot_tipo = a.ot_tipo " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text		= ls_codigo
	st_tipo_ot.text = ls_data
end if
end event

type st_tipo_ot from statictext within w_ma731_consumos_cenbef
integer x = 768
integer y = 208
integer width = 1175
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_ma731_consumos_cenbef
integer x = 14
integer y = 320
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "CENTRO BENEF"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cenbef from editmask within w_ma731_consumos_cenbef
event ue_dobleclick pbm_lbuttondblclk
integer x = 462
integer y = 308
integer width = 297
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

event ue_dobleclick;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

ls_sql = "SELECT distinct a.centro_benef AS CODIGO_centro_beneficio, " &
		  + "a.desc_centro AS descripcion_centro_beneficio " &
		  + "FROM centro_beneficio a, " &
		  + "orden_Trabajo ot " &
		  + "where ot.centro_benef = a.centro_benef " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text				= ls_codigo
	st_cenbef.text 	= ls_data
end if
end event

type st_cenbef from statictext within w_ma731_consumos_cenbef
integer x = 768
integer y = 304
integer width = 1175
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cbx_maquina from checkbox within w_ma731_consumos_cenbef
integer x = 59
integer y = 452
integer width = 1513
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Solo mostrar Aquellos que tienen codigo de equipo"
boolean checked = true
end type

type rb_consumo from radiobutton within w_ma731_consumos_cenbef
integer x = 2048
integer y = 336
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Consumo Artículos"
boolean checked = true
end type

type rb_servicios from radiobutton within w_ma731_consumos_cenbef
integer x = 2048
integer y = 412
integer width = 558
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Servicios"
end type

type gb_2 from groupbox within w_ma731_consumos_cenbef
integer x = 1998
integer y = 32
integer width = 832
integer height = 240
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Estado Doc."
end type

type gb_1 from groupbox within w_ma731_consumos_cenbef
integer x = 1989
integer y = 288
integer width = 841
integer height = 220
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

