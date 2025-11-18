$PBExportHeader$w_rh401_rpt_av_evaluaciones.srw
forward
global type w_rh401_rpt_av_evaluaciones from w_report_smpl
end type
type cb_3 from commandbutton within w_rh401_rpt_av_evaluaciones
end type
type em_descripcion from editmask within w_rh401_rpt_av_evaluaciones
end type
type em_origen from editmask within w_rh401_rpt_av_evaluaciones
end type
type cb_1 from commandbutton within w_rh401_rpt_av_evaluaciones
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh401_rpt_av_evaluaciones
end type
type sle_codigo from singlelineedit within w_rh401_rpt_av_evaluaciones
end type
type sle_nombres from singlelineedit within w_rh401_rpt_av_evaluaciones
end type
type cb_4 from commandbutton within w_rh401_rpt_av_evaluaciones
end type
type cb_2 from commandbutton within w_rh401_rpt_av_evaluaciones
end type
type em_desc_seccion from editmask within w_rh401_rpt_av_evaluaciones
end type
type em_seccion from editmask within w_rh401_rpt_av_evaluaciones
end type
type pb_1 from picturebutton within w_rh401_rpt_av_evaluaciones
end type
type em_ano from editmask within w_rh401_rpt_av_evaluaciones
end type
type em_mes from editmask within w_rh401_rpt_av_evaluaciones
end type
type st_1 from statictext within w_rh401_rpt_av_evaluaciones
end type
type st_2 from statictext within w_rh401_rpt_av_evaluaciones
end type
type gb_2 from groupbox within w_rh401_rpt_av_evaluaciones
end type
type gb_4 from groupbox within w_rh401_rpt_av_evaluaciones
end type
type gb_3 from groupbox within w_rh401_rpt_av_evaluaciones
end type
type gb_1 from groupbox within w_rh401_rpt_av_evaluaciones
end type
end forward

global type w_rh401_rpt_av_evaluaciones from w_report_smpl
integer width = 3488
integer height = 1500
string title = "(RH401) Constancia de Evaluaciones"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
uo_1 uo_1
sle_codigo sle_codigo
sle_nombres sle_nombres
cb_4 cb_4
cb_2 cb_2
em_desc_seccion em_desc_seccion
em_seccion em_seccion
pb_1 pb_1
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
gb_2 gb_2
gb_4 gb_4
gb_3 gb_3
gb_1 gb_1
end type
global w_rh401_rpt_av_evaluaciones w_rh401_rpt_av_evaluaciones

on w_rh401_rpt_av_evaluaciones.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.uo_1=create uo_1
this.sle_codigo=create sle_codigo
this.sle_nombres=create sle_nombres
this.cb_4=create cb_4
this.cb_2=create cb_2
this.em_desc_seccion=create em_desc_seccion
this.em_seccion=create em_seccion
this.pb_1=create pb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.gb_2=create gb_2
this.gb_4=create gb_4
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.sle_codigo
this.Control[iCurrent+7]=this.sle_nombres
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.em_desc_seccion
this.Control[iCurrent+11]=this.em_seccion
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.em_ano
this.Control[iCurrent+14]=this.em_mes
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_4
this.Control[iCurrent+19]=this.gb_3
this.Control[iCurrent+20]=this.gb_1
end on

on w_rh401_rpt_av_evaluaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.sle_codigo)
destroy(this.sle_nombres)
destroy(this.cb_4)
destroy(this.cb_2)
destroy(this.em_desc_seccion)
destroy(this.em_seccion)
destroy(this.pb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_4)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_codigo, ls_seccion
integer li_ano, li_mes

ls_origen = string(em_origen.text)
ls_codigo = string(sle_codigo.text)
ls_seccion = string(em_seccion.text)
li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

ls_tiptra = uo_1.of_get_value()

if isnull(ls_origen)  or trim(ls_origen)  = '' then MessageBox('Atención','Debe Ingresar el Origen')
if isnull(ls_tiptra)  or trim(ls_tiptra)  = '' then ls_tiptra  = '%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%'
if isnull(ls_codigo)  or trim(ls_codigo)  = '' then ls_codigo  = '%'

DECLARE pb_usp_rh_av_rpt_evaluaciones PROCEDURE FOR usp_rh_av_rpt_evaluaciones
        ( :ls_tiptra, :ls_origen, :ls_codigo, :ls_seccion, :li_ano, :li_mes ) ;
EXECUTE pb_usp_rh_av_rpt_evaluaciones ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rh401_rpt_av_evaluaciones
integer x = 0
integer y = 400
integer width = 3438
integer height = 788
integer taborder = 70
string dataobject = "d_rpt_av_evaluaciones_tbl"
end type

type cb_3 from commandbutton within w_rh401_rpt_av_evaluaciones
integer x = 174
integer y = 84
integer width = 87
integer height = 68
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

type em_descripcion from editmask within w_rh401_rpt_av_evaluaciones
integer x = 288
integer y = 84
integer width = 635
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh401_rpt_av_evaluaciones
integer x = 50
integer y = 84
integer width = 96
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_rh401_rpt_av_evaluaciones
integer x = 2839
integer y = 264
integer width = 293
integer height = 76
integer taborder = 60
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh401_rpt_av_evaluaciones
integer x = 1033
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type sle_codigo from singlelineedit within w_rh401_rpt_av_evaluaciones
integer x = 41
integer y = 276
integer width = 274
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_nombres from singlelineedit within w_rh401_rpt_av_evaluaciones
integer x = 462
integer y = 276
integer width = 1106
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_rh401_rpt_av_evaluaciones
integer x = 343
integer y = 276
integer width = 87
integer height = 68
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

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_select_codigo_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo.text  = sl_param.field_ret[1]
	sle_nombres.text = sl_param.field_ret[2]
END IF

end event

type cb_2 from commandbutton within w_rh401_rpt_av_evaluaciones
integer x = 2190
integer y = 84
integer width = 87
integer height = 68
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

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_seccion.text      = sl_param.field_ret[1]
	em_desc_seccion.text = sl_param.field_ret[2]
END IF

end event

type em_desc_seccion from editmask within w_rh401_rpt_av_evaluaciones
integer x = 2304
integer y = 84
integer width = 859
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_seccion from editmask within w_rh401_rpt_av_evaluaciones
integer x = 2034
integer y = 84
integer width = 128
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type pb_1 from picturebutton within w_rh401_rpt_av_evaluaciones
integer x = 2510
integer y = 248
integer width = 247
integer height = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\Gif\arrowl.gif"
string powertiptext = "Limpiar"
end type

event clicked;em_seccion.text = ''
em_desc_seccion.text = ''
sle_codigo.text = ''
sle_nombres.text = ''
end event

type em_ano from editmask within w_rh401_rpt_av_evaluaciones
integer x = 1879
integer y = 272
integer width = 197
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_rh401_rpt_av_evaluaciones
integer x = 2240
integer y = 272
integer width = 128
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_1 from statictext within w_rh401_rpt_av_evaluaciones
integer x = 1742
integer y = 280
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh401_rpt_av_evaluaciones
integer x = 2112
integer y = 280
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh401_rpt_av_evaluaciones
integer y = 20
integer width = 997
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_4 from groupbox within w_rh401_rpt_av_evaluaciones
integer y = 208
integer width = 1614
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
end type

type gb_3 from groupbox within w_rh401_rpt_av_evaluaciones
integer x = 1984
integer y = 20
integer width = 1225
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Sección "
end type

type gb_1 from groupbox within w_rh401_rpt_av_evaluaciones
integer x = 1691
integer y = 208
integer width = 731
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

