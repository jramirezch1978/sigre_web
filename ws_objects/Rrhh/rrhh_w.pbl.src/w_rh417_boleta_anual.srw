$PBExportHeader$w_rh417_boleta_anual.srw
forward
global type w_rh417_boleta_anual from w_report_smpl
end type
type cb_1 from commandbutton within w_rh417_boleta_anual
end type
type st_3 from statictext within w_rh417_boleta_anual
end type
type em_descripcion from editmask within w_rh417_boleta_anual
end type
type cb_3 from commandbutton within w_rh417_boleta_anual
end type
type em_origen from editmask within w_rh417_boleta_anual
end type
type em_cod_trabajador from editmask within w_rh417_boleta_anual
end type
type cb_4 from commandbutton within w_rh417_boleta_anual
end type
type em_nom_trabajador from editmask within w_rh417_boleta_anual
end type
type st_5 from statictext within w_rh417_boleta_anual
end type
type st_1 from statictext within w_rh417_boleta_anual
end type
type em_year from editmask within w_rh417_boleta_anual
end type
type gb_1 from groupbox within w_rh417_boleta_anual
end type
end forward

global type w_rh417_boleta_anual from w_report_smpl
integer width = 5115
integer height = 2152
string title = "(RH417) Boletas Anuales del Trabajador"
string menuname = "m_impresion"
cb_1 cb_1
st_3 st_3
em_descripcion em_descripcion
cb_3 cb_3
em_origen em_origen
em_cod_trabajador em_cod_trabajador
cb_4 cb_4
em_nom_trabajador em_nom_trabajador
st_5 st_5
st_1 st_1
em_year em_year
gb_1 gb_1
end type
global w_rh417_boleta_anual w_rh417_boleta_anual

on w_rh417_boleta_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_3=create st_3
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.em_origen=create em_origen
this.em_cod_trabajador=create em_cod_trabajador
this.cb_4=create cb_4
this.em_nom_trabajador=create em_nom_trabajador
this.st_5=create st_5
this.st_1=create st_1
this.em_year=create em_year
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.em_origen
this.Control[iCurrent+6]=this.em_cod_trabajador
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.em_nom_trabajador
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.em_year
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh417_boleta_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.em_origen)
destroy(this.em_cod_trabajador)
destroy(this.cb_4)
destroy(this.em_nom_trabajador)
destroy(this.st_5)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen, ls_desc_origen, ls_codigo, &
			ls_msg, ls_mensaje
Integer 	li_msg, li_year


dw_report.reset( )

ls_origen      = trim(em_origen.text) + '%'
ls_codigo      = trim(em_cod_trabajador.text) + '%'
ls_desc_origen = trim(em_descripcion.text)
li_year 			= Integer(em_year.text)


If isnull(ls_origen)  Or trim(ls_origen)  = '' Then 
	MessageBox('Atención','Debe Ingresar el Origen')
	return
end if

ib_preview = false
event ue_preview()

dw_report.Retrieve(ls_origen, li_year, ls_codigo)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gnvo_app.empresa.is_nom_empresa
dw_report.object.t_ruc.text    	= 'RUC: ' + gnvo_app.empresa.is_ruc
dw_report.object.t_periodo.text	= 'PERIODO: ' + string(li_year)
dw_report.object.t_user.text		= gs_user


	
end event

event ue_open_pre;call super::ue_open_pre;Integer 	li_year
Date		ld_hoy

ld_hoy = date(gnvo_app.of_fecha_Actual())

li_year = year(ld_hoy)

//Pongo el origen por defecto
em_origen.text = gs_origen
em_year.text = string(li_year)




end event

type dw_report from w_report_smpl`dw_report within w_rh417_boleta_anual
integer x = 0
integer y = 324
integer width = 3438
integer height = 1444
integer taborder = 60
string dataobject = "d_rpt_boleta_anual_tbl"
end type

type cb_1 from commandbutton within w_rh417_boleta_anual
integer x = 2405
integer y = 56
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

type st_3 from statictext within w_rh417_boleta_anual
integer x = 14
integer y = 64
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_descripcion from editmask within w_rh417_boleta_anual
integer x = 859
integer y = 52
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

type cb_3 from commandbutton within w_rh417_boleta_anual
integer x = 773
integer y = 52
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

type em_origen from editmask within w_rh417_boleta_anual
integer x = 485
integer y = 52
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
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_cod_trabajador from editmask within w_rh417_boleta_anual
integer x = 485
integer y = 228
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

type cb_4 from commandbutton within w_rh417_boleta_anual
integer x = 773
integer y = 228
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
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabajador

ls_origen = trim(em_origen.text)

ls_sql = "SELECT distinct m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
		 + "m.DNI as dni " &
		 + "from vw_pr_trabajador m, "&
		 + "     historico_calculo hc " &
		 + "where m.cod_trabajador = hc.cod_trabajador " &
		 + "  and hc.cod_origen = '" + ls_origen + "'" 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cod_trabajador.text = ls_codigo
	em_nom_trabajador.text = ls_data
end if

end event

type em_nom_trabajador from editmask within w_rh417_boleta_anual
integer x = 859
integer y = 228
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

type st_5 from statictext within w_rh417_boleta_anual
integer x = 14
integer y = 240
integer width = 466
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Código Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh417_boleta_anual
integer x = 14
integer y = 152
integer width = 466
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

type em_year from editmask within w_rh417_boleta_anual
integer x = 485
integer y = 140
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

type gb_1 from groupbox within w_rh417_boleta_anual
integer width = 4686
integer height = 316
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

