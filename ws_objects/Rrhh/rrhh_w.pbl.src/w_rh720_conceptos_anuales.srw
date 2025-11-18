$PBExportHeader$w_rh720_conceptos_anuales.srw
forward
global type w_rh720_conceptos_anuales from w_report_smpl
end type
type cb_1 from commandbutton within w_rh720_conceptos_anuales
end type
type em_descripcion from editmask within w_rh720_conceptos_anuales
end type
type cb_origen from commandbutton within w_rh720_conceptos_anuales
end type
type em_origen from editmask within w_rh720_conceptos_anuales
end type
type em_concepto from editmask within w_rh720_conceptos_anuales
end type
type cb_concepto from commandbutton within w_rh720_conceptos_anuales
end type
type em_desc_concepto from editmask within w_rh720_conceptos_anuales
end type
type st_1 from statictext within w_rh720_conceptos_anuales
end type
type em_year from editmask within w_rh720_conceptos_anuales
end type
type cbx_origen from checkbox within w_rh720_conceptos_anuales
end type
type cbx_concepto from checkbox within w_rh720_conceptos_anuales
end type
type gb_1 from groupbox within w_rh720_conceptos_anuales
end type
end forward

global type w_rh720_conceptos_anuales from w_report_smpl
integer width = 5115
integer height = 2152
string title = "[RH720] Conceptos Anuales por trabajador"
string menuname = "m_impresion"
cb_1 cb_1
em_descripcion em_descripcion
cb_origen cb_origen
em_origen em_origen
em_concepto em_concepto
cb_concepto cb_concepto
em_desc_concepto em_desc_concepto
st_1 st_1
em_year em_year
cbx_origen cbx_origen
cbx_concepto cbx_concepto
gb_1 gb_1
end type
global w_rh720_conceptos_anuales w_rh720_conceptos_anuales

on w_rh720_conceptos_anuales.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_descripcion=create em_descripcion
this.cb_origen=create cb_origen
this.em_origen=create em_origen
this.em_concepto=create em_concepto
this.cb_concepto=create cb_concepto
this.em_desc_concepto=create em_desc_concepto
this.st_1=create st_1
this.em_year=create em_year
this.cbx_origen=create cbx_origen
this.cbx_concepto=create cbx_concepto
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.cb_origen
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_concepto
this.Control[iCurrent+6]=this.cb_concepto
this.Control[iCurrent+7]=this.em_desc_concepto
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.em_year
this.Control[iCurrent+10]=this.cbx_origen
this.Control[iCurrent+11]=this.cbx_concepto
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh720_conceptos_anuales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_descripcion)
destroy(this.cb_origen)
destroy(this.em_origen)
destroy(this.em_concepto)
destroy(this.cb_concepto)
destroy(this.em_desc_concepto)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.cbx_origen)
destroy(this.cbx_concepto)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen, ls_concepto
Integer 	li_year

dw_report.reset( )

if cbx_origen.checked then
	ls_origen = '%%'
else
	if trim(em_origen.text) = '' then
		MessageBox('Error', 'Debes de especificar un origen, por favor corregir!', StopSign!)
		em_origen.setFocus()
		return
	end if
	ls_origen      = trim(em_origen.text) + '%'	
end if


if cbx_concepto.checked then
	ls_concepto = '%%'
else
	if trim(em_concepto.text) = '' then
		MessageBox('Error', 'Debes de especificar un Concepto, por favor corregir!', StopSign!)
		em_concepto.setFocus()
		return
	end if
	ls_concepto      = trim(em_concepto.text) + '%'
end if


li_year 			= Integer(em_year.text)


ib_preview = false
event ue_preview()

dw_report.Retrieve(ls_origen, li_year, ls_concepto)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text		= gs_user


	
end event

event ue_open_pre;call super::ue_open_pre;Integer 	li_year
Date		ld_hoy

ld_hoy = date(gnvo_app.of_fecha_Actual())

li_year = year(ld_hoy)

//Pongo el origen por defecto

em_year.text = string(li_year)




end event

type dw_report from w_report_smpl`dw_report within w_rh720_conceptos_anuales
integer x = 0
integer y = 284
integer width = 3438
integer height = 1444
integer taborder = 60
string dataobject = "d_rpt_conceptos_anual_tbl"
end type

type cb_1 from commandbutton within w_rh720_conceptos_anuales
integer x = 2839
integer y = 48
integer width = 315
integer height = 220
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_descripcion from editmask within w_rh720_conceptos_anuales
integer x = 1001
integer y = 68
integer width = 983
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_origen from commandbutton within w_rh720_conceptos_anuales
integer x = 914
integer y = 68
integer width = 87
integer height = 84
integer taborder = 20
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

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh720_conceptos_anuales
integer x = 626
integer y = 68
integer width = 283
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_concepto from editmask within w_rh720_conceptos_anuales
integer x = 626
integer y = 172
integer width = 283
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_concepto from commandbutton within w_rh720_conceptos_anuales
integer x = 914
integer y = 172
integer width = 87
integer height = 84
integer taborder = 70
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

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_year

ls_year = em_year.text

ls_sql = "select distinct " &
		 + "       hc.concep as concepto_planilla, " &
		 + "       co.desc_concep as descripcion_planilla " &
		 + "  from historico_calculo hc, " &
		 + "       concepto          co " &
		 + " where hc.concep = co.concep " &
		 + "   and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = '" + ls_year + "' " &
		 + "order by 1" 

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	em_concepto.text 			= ls_codigo
	em_desc_concepto.text 	= ls_data
end if

end event

type em_desc_concepto from editmask within w_rh720_conceptos_anuales
integer x = 1001
integer y = 172
integer width = 983
integer height = 84
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_rh720_conceptos_anuales
integer x = 2075
integer y = 80
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_rh720_conceptos_anuales
integer x = 2354
integer y = 68
integer width = 347
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "####"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

type cbx_origen from checkbox within w_rh720_conceptos_anuales
integer x = 32
integer y = 72
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos los origenes"
boolean checked = true
end type

event clicked;if this.checked then
	cb_origen.enabled = false
else
	cb_origen.enabled = true
end if
end event

type cbx_concepto from checkbox within w_rh720_conceptos_anuales
integer x = 37
integer y = 180
integer width = 576
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos los conceptos"
boolean checked = true
end type

event clicked;if this.checked then
	cb_concepto.enabled = false
	em_concepto.text = '%'
else
	cb_concepto.enabled = true
	em_concepto.text = ''
end if
end event

type gb_1 from groupbox within w_rh720_conceptos_anuales
integer width = 4686
integer height = 280
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

