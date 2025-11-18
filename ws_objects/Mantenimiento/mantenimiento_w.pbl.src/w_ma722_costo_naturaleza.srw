$PBExportHeader$w_ma722_costo_naturaleza.srw
forward
global type w_ma722_costo_naturaleza from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ma722_costo_naturaleza
end type
type st_4 from statictext within w_ma722_costo_naturaleza
end type
type em_ot_adm from editmask within w_ma722_costo_naturaleza
end type
type st_ot_adm from statictext within w_ma722_costo_naturaleza
end type
type cbx_proy from checkbox within w_ma722_costo_naturaleza
end type
type cbx_cer from checkbox within w_ma722_costo_naturaleza
end type
type cbx_gen from checkbox within w_ma722_costo_naturaleza
end type
type cbx_anu from checkbox within w_ma722_costo_naturaleza
end type
type cb_1 from commandbutton within w_ma722_costo_naturaleza
end type
type st_1 from statictext within w_ma722_costo_naturaleza
end type
type em_tipo_ot from editmask within w_ma722_costo_naturaleza
end type
type st_tipo_ot from statictext within w_ma722_costo_naturaleza
end type
type st_3 from statictext within w_ma722_costo_naturaleza
end type
type em_cencos_rsp from editmask within w_ma722_costo_naturaleza
end type
type st_cencos_rsp from statictext within w_ma722_costo_naturaleza
end type
type st_6 from statictext within w_ma722_costo_naturaleza
end type
type em_cencos_slc from editmask within w_ma722_costo_naturaleza
end type
type st_cencos_slc from statictext within w_ma722_costo_naturaleza
end type
type cbx_maquina from checkbox within w_ma722_costo_naturaleza
end type
type cbx_fec_inicio from checkbox within w_ma722_costo_naturaleza
end type
type st_2 from statictext within w_ma722_costo_naturaleza
end type
type em_ejecutor from editmask within w_ma722_costo_naturaleza
end type
type st_desc_ejecutor from statictext within w_ma722_costo_naturaleza
end type
type gb_2 from groupbox within w_ma722_costo_naturaleza
end type
end forward

global type w_ma722_costo_naturaleza from w_report_smpl
integer width = 3525
integer height = 2116
string title = "Costo x Naturaleza de Orden de Trabajo (MA722)"
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
em_cencos_rsp em_cencos_rsp
st_cencos_rsp st_cencos_rsp
st_6 st_6
em_cencos_slc em_cencos_slc
st_cencos_slc st_cencos_slc
cbx_maquina cbx_maquina
cbx_fec_inicio cbx_fec_inicio
st_2 st_2
em_ejecutor em_ejecutor
st_desc_ejecutor st_desc_ejecutor
gb_2 gb_2
end type
global w_ma722_costo_naturaleza w_ma722_costo_naturaleza

on w_ma722_costo_naturaleza.create
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
this.em_cencos_rsp=create em_cencos_rsp
this.st_cencos_rsp=create st_cencos_rsp
this.st_6=create st_6
this.em_cencos_slc=create em_cencos_slc
this.st_cencos_slc=create st_cencos_slc
this.cbx_maquina=create cbx_maquina
this.cbx_fec_inicio=create cbx_fec_inicio
this.st_2=create st_2
this.em_ejecutor=create em_ejecutor
this.st_desc_ejecutor=create st_desc_ejecutor
this.gb_2=create gb_2
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
this.Control[iCurrent+14]=this.em_cencos_rsp
this.Control[iCurrent+15]=this.st_cencos_rsp
this.Control[iCurrent+16]=this.st_6
this.Control[iCurrent+17]=this.em_cencos_slc
this.Control[iCurrent+18]=this.st_cencos_slc
this.Control[iCurrent+19]=this.cbx_maquina
this.Control[iCurrent+20]=this.cbx_fec_inicio
this.Control[iCurrent+21]=this.st_2
this.Control[iCurrent+22]=this.em_ejecutor
this.Control[iCurrent+23]=this.st_desc_ejecutor
this.Control[iCurrent+24]=this.gb_2
end on

on w_ma722_costo_naturaleza.destroy
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
destroy(this.em_cencos_rsp)
destroy(this.st_cencos_rsp)
destroy(this.st_6)
destroy(this.em_cencos_slc)
destroy(this.st_cencos_slc)
destroy(this.cbx_maquina)
destroy(this.cbx_fec_inicio)
destroy(this.st_2)
destroy(this.em_ejecutor)
destroy(this.st_desc_ejecutor)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_ot_adm, ls_tipo_ot, ls_Cencos_rsp, &
			ls_Cencos_slc, ls_maquina, ls_fec_inicio, &
			ls_ejecutor
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

if trim(em_cencos_rsp.text) = '' then
	ls_cencos_rsp = '%%'
else
	ls_cencos_rsp = trim(em_cencos_rsp.text) + '%'
end if

if trim(em_cencos_slc.text) = '' then
	ls_cencos_slc = '%%'
else
	ls_cencos_slc = trim(em_cencos_slc.text) + '%'
end if

if trim(em_ejecutor.text) = '' then
	ls_ejecutor = '%%'
else
	ls_ejecutor = trim(em_ejecutor.text) + '%'
end if

if cbx_fec_inicio.checked = true then
	ls_fec_inicio = '1'
else
	ls_fec_inicio = '0'
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


idw_1.REtrieve( ld_fecha1, ld_fecha2, ls_tipo_ot, ls_ot_adm, ls_cencos_rsp, ls_cencos_slc, ls_estado, ls_maquina, ls_fec_inicio, ls_ejecutor )

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.datawindow.print.orientation = 1
idw_1.object.titulo_1.text = 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')
if trim(em_tipo_ot.text) = '' then
	idw_1.object.titulo_2.text = 'Todos los Tipos de OT'
else
	idw_1.object.titulo_2.text = st_tipo_ot.text
end if
if trim(em_ejecutor.text) = '' then
	idw_1.object.titulo_3.text = 'Todos los Tipos de OT'
else
	idw_1.object.titulo_3.text = st_desc_ejecutor.text
end if

end event

type dw_report from w_report_smpl`dw_report within w_ma722_costo_naturaleza
integer x = 0
integer y = 788
integer width = 2807
integer height = 1088
string dataobject = "d_rpt_costo_naturaleza_ot"
end type

type uo_fecha from u_ingreso_rango_fechas within w_ma722_costo_naturaleza
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

type st_4 from statictext within w_ma722_costo_naturaleza
integer x = 27
integer y = 132
integer width = 366
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

type em_ot_adm from editmask within w_ma722_costo_naturaleza
event ue_dobleclick pbm_lbuttondblclk
integer x = 407
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

type st_ot_adm from statictext within w_ma722_costo_naturaleza
integer x = 727
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

type cbx_proy from checkbox within w_ma722_costo_naturaleza
integer x = 2377
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

type cbx_cer from checkbox within w_ma722_costo_naturaleza
integer x = 2377
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

type cbx_gen from checkbox within w_ma722_costo_naturaleza
integer x = 1961
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

type cbx_anu from checkbox within w_ma722_costo_naturaleza
integer x = 1961
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

type cb_1 from commandbutton within w_ma722_costo_naturaleza
integer x = 2400
integer y = 292
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

type st_1 from statictext within w_ma722_costo_naturaleza
integer x = 27
integer y = 220
integer width = 366
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

type em_tipo_ot from editmask within w_ma722_costo_naturaleza
event ue_dobleclick pbm_lbuttondblclk
integer x = 407
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
		  + "a.descripcion AS descripcion_ot_adm " &
		  + "FROM ot_tipo a, " &
		  + "orden_Trabajo ot " &
		  + "where ot.ot_tipo = a.ot_tipo " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text		= ls_codigo
	st_tipo_ot.text = ls_data
end if
end event

type st_tipo_ot from statictext within w_ma722_costo_naturaleza
integer x = 727
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

type st_3 from statictext within w_ma722_costo_naturaleza
integer x = 27
integer y = 320
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "CENCOS RSP"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cencos_rsp from editmask within w_ma722_costo_naturaleza
event ue_dobleclick pbm_lbuttondblclk
integer x = 407
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

ls_sql = "SELECT distinct a.cencos AS CODIGO, " &
		  + "a.desc_cencos AS descripcion_cencos " &
		  + "FROM centros_costo a, " &
		  + "orden_Trabajo ot " &
		  + "where ot.cencos_rsp = a.cencos " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text				= ls_codigo
	st_cencos_rsp.text 	= ls_data
end if
end event

type st_cencos_rsp from statictext within w_ma722_costo_naturaleza
integer x = 727
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

type st_6 from statictext within w_ma722_costo_naturaleza
integer x = 27
integer y = 420
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "CENCOS SLC"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cencos_slc from editmask within w_ma722_costo_naturaleza
event ue_dobleclick pbm_lbuttondblclk
integer x = 407
integer y = 408
integer width = 297
integer height = 84
integer taborder = 80
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

ls_sql = "SELECT distinct a.cencos AS CODIGO, " &
		  + "a.desc_cencos AS descripcion_cencos " &
		  + "FROM centros_costo a, " &
		  + "orden_Trabajo ot " &
		  + "where ot.cencos_slc = a.cencos " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text				= ls_codigo
	st_cencos_slc.text 	= ls_data
end if
end event

type st_cencos_slc from statictext within w_ma722_costo_naturaleza
integer x = 727
integer y = 400
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

type cbx_maquina from checkbox within w_ma722_costo_naturaleza
integer x = 59
integer y = 656
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

type cbx_fec_inicio from checkbox within w_ma722_costo_naturaleza
integer x = 1595
integer y = 648
integer width = 1047
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Mostrar solo OTs sin Fecha de Inicio"
end type

type st_2 from statictext within w_ma722_costo_naturaleza
integer x = 27
integer y = 520
integer width = 366
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "EJECUTOR"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ejecutor from editmask within w_ma722_costo_naturaleza
event ue_dobleclick pbm_lbuttondblclk
integer x = 407
integer y = 508
integer width = 297
integer height = 84
integer taborder = 90
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

ls_sql = "SELECT COD_EJECUTOR AS CODIGO_ejecutor, " &
		  + "DESCRIPCION AS descripcion_ejecutor " &
		  + "FROM ejecutor " &
		  + "where flag_estado = '1' " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text				= ls_codigo
	st_desc_ejecutor.text= ls_data
end if
end event

type st_desc_ejecutor from statictext within w_ma722_costo_naturaleza
integer x = 727
integer y = 508
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

type gb_2 from groupbox within w_ma722_costo_naturaleza
integer x = 1920
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

