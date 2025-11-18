$PBExportHeader$w_rh621_rpt_promedio_evaluacion.srw
forward
global type w_rh621_rpt_promedio_evaluacion from w_report_smpl
end type
type cb_1 from commandbutton within w_rh621_rpt_promedio_evaluacion
end type
type cb_2 from commandbutton within w_rh621_rpt_promedio_evaluacion
end type
type cb_3 from commandbutton within w_rh621_rpt_promedio_evaluacion
end type
type uo_1 from u_ingreso_rango_fechas within w_rh621_rpt_promedio_evaluacion
end type
type st_1 from statictext within w_rh621_rpt_promedio_evaluacion
end type
type st_2 from statictext within w_rh621_rpt_promedio_evaluacion
end type
type em_area from editmask within w_rh621_rpt_promedio_evaluacion
end type
type em_desc_area from editmask within w_rh621_rpt_promedio_evaluacion
end type
type em_seccion from editmask within w_rh621_rpt_promedio_evaluacion
end type
type em_desc_seccion from editmask within w_rh621_rpt_promedio_evaluacion
end type
type em_desde from editmask within w_rh621_rpt_promedio_evaluacion
end type
type em_hasta from editmask within w_rh621_rpt_promedio_evaluacion
end type
type gb_1 from groupbox within w_rh621_rpt_promedio_evaluacion
end type
type gb_2 from groupbox within w_rh621_rpt_promedio_evaluacion
end type
type gb_4 from groupbox within w_rh621_rpt_promedio_evaluacion
end type
type gb_5 from groupbox within w_rh621_rpt_promedio_evaluacion
end type
end forward

global type w_rh621_rpt_promedio_evaluacion from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(RH621) Reporte de Promedio General de las Evaluaciones"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
uo_1 uo_1
st_1 st_1
st_2 st_2
em_area em_area
em_desc_area em_desc_area
em_seccion em_seccion
em_desc_seccion em_desc_seccion
em_desde em_desde
em_hasta em_hasta
gb_1 gb_1
gb_2 gb_2
gb_4 gb_4
gb_5 gb_5
end type
global w_rh621_rpt_promedio_evaluacion w_rh621_rpt_promedio_evaluacion

type variables
string is_codigo
end variables

on w_rh621_rpt_promedio_evaluacion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.uo_1=create uo_1
this.st_1=create st_1
this.st_2=create st_2
this.em_area=create em_area
this.em_desc_area=create em_desc_area
this.em_seccion=create em_seccion
this.em_desc_seccion=create em_desc_seccion
this.em_desde=create em_desde
this.em_hasta=create em_hasta
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.uo_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.em_area
this.Control[iCurrent+8]=this.em_desc_area
this.Control[iCurrent+9]=this.em_seccion
this.Control[iCurrent+10]=this.em_desc_seccion
this.Control[iCurrent+11]=this.em_desde
this.Control[iCurrent+12]=this.em_hasta
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_4
this.Control[iCurrent+16]=this.gb_5
end on

on w_rh621_rpt_promedio_evaluacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_area)
destroy(this.em_desc_area)
destroy(this.em_seccion)
destroy(this.em_desc_seccion)
destroy(this.em_desde)
destroy(this.em_hasta)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_5)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_area, ls_seccion
date    ld_fec_desde, ld_fec_hasta
integer li_desde, li_hasta

ls_area    = string (em_area.text)
ls_seccion = string (em_seccion.text)

ld_fec_desde = uo_1.of_get_fecha1()
ld_fec_hasta = uo_1.of_get_fecha2()

li_desde = integer(em_desde.text)
li_hasta = integer(em_hasta.text)

if isnull(li_desde) or (li_desde = 0 or li_desde > 5) then
	MessageBox('Aviso','Puntaje DESDE es incorrecto. Verifique')
	return
end if

if isnull(li_hasta) or (li_hasta = 0 or li_hasta > 5) then
	MessageBox('Aviso','Puntaje HASTA es incorrecto. Verifique')
	return
end if

if li_desde > li_hasta then
	MessageBox('Aviso','Rango de puntaje es incorrecto. Verifique')
	return
end if

if isnull(ls_area) or trim(ls_area) = '' then ls_area = '%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%'

DECLARE pb_usp_rpt_promedio_evaluacion PROCEDURE FOR USP_RPT_PROMEDIO_EVALUACION
        ( :ls_area, :ls_seccion, :ld_fec_desde, :ld_fec_hasta, :li_desde, :li_hasta) ;
EXECUTE pb_usp_rpt_promedio_evaluacion ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user


end event

type dw_report from w_report_smpl`dw_report within w_rh621_rpt_promedio_evaluacion
integer x = 9
integer y = 536
integer width = 3451
integer height = 900
integer taborder = 70
string dataobject = "d_rpt_promedio_evaluacion_tbl"
end type

type cb_1 from commandbutton within w_rh621_rpt_promedio_evaluacion
integer x = 2848
integer y = 340
integer width = 279
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type cb_2 from commandbutton within w_rh621_rpt_promedio_evaluacion
integer x = 347
integer y = 112
integer width = 87
integer height = 80
integer taborder = 10
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

sl_param.dw1 = "d_rpt_rh_area_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_area.text = sl_param.field_ret[1]
	em_desc_area.text = sl_param.field_ret[2]
END IF

end event

type cb_3 from commandbutton within w_rh621_rpt_promedio_evaluacion
integer x = 2030
integer y = 112
integer width = 87
integer height = 80
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

sl_param.dw1 = "d_seleccion_seccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_seccion.text = sl_param.field_ret[1]
	em_desc_seccion.text = sl_param.field_ret[2]
END IF

end event

type uo_1 from u_ingreso_rango_fechas within w_rh621_rpt_promedio_evaluacion
integer x = 178
integer y = 336
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_inicio, ls_fec 
date ld_fec
uo_1.of_set_label('Desde','Hasta')

//Obtenemos el Primer dia del Mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 uo_1.of_set_fecha(date(ls_inicio),today())
 uo_1.of_set_rango_inicio(date('01/01/1900')) // rango inicial
 uo_1.of_set_rango_fin(date('31/12/9999')) // rango final

end event

type st_1 from statictext within w_rh621_rpt_promedio_evaluacion
integer x = 1819
integer y = 344
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh621_rpt_promedio_evaluacion
integer x = 2281
integer y = 344
integer width = 146
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type em_area from editmask within w_rh621_rpt_promedio_evaluacion
integer x = 119
integer y = 112
integer width = 192
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_area from editmask within w_rh621_rpt_promedio_evaluacion
integer x = 466
integer y = 112
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_seccion from editmask within w_rh621_rpt_promedio_evaluacion
integer x = 1710
integer y = 112
integer width = 283
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_seccion from editmask within w_rh621_rpt_promedio_evaluacion
integer x = 2153
integer y = 112
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desde from editmask within w_rh621_rpt_promedio_evaluacion
integer x = 2025
integer y = 340
integer width = 197
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type em_hasta from editmask within w_rh621_rpt_promedio_evaluacion
integer x = 2482
integer y = 340
integer width = 197
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type gb_1 from groupbox within w_rh621_rpt_promedio_evaluacion
integer x = 55
integer y = 36
integer width = 1518
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Area "
end type

type gb_2 from groupbox within w_rh621_rpt_promedio_evaluacion
integer x = 1646
integer y = 36
integer width = 1609
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Sección "
end type

type gb_4 from groupbox within w_rh621_rpt_promedio_evaluacion
integer x = 114
integer y = 264
integer width = 1399
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Ingrese Rango de Fechas "
end type

type gb_5 from groupbox within w_rh621_rpt_promedio_evaluacion
integer x = 1751
integer y = 264
integer width = 1015
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Selecione Puntaje Promedio "
end type

