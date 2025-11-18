$PBExportHeader$w_rh402_rpt_av_compensacion_variable.srw
forward
global type w_rh402_rpt_av_compensacion_variable from w_report_smpl
end type
type cb_1 from commandbutton within w_rh402_rpt_av_compensacion_variable
end type
type em_ano from editmask within w_rh402_rpt_av_compensacion_variable
end type
type em_mes from editmask within w_rh402_rpt_av_compensacion_variable
end type
type st_1 from statictext within w_rh402_rpt_av_compensacion_variable
end type
type st_2 from statictext within w_rh402_rpt_av_compensacion_variable
end type
type cb_2 from commandbutton within w_rh402_rpt_av_compensacion_variable
end type
type em_origen from editmask within w_rh402_rpt_av_compensacion_variable
end type
type em_descripcion from editmask within w_rh402_rpt_av_compensacion_variable
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh402_rpt_av_compensacion_variable
end type
type gb_1 from groupbox within w_rh402_rpt_av_compensacion_variable
end type
type gb_2 from groupbox within w_rh402_rpt_av_compensacion_variable
end type
end forward

global type w_rh402_rpt_av_compensacion_variable from w_report_smpl
integer width = 3502
integer height = 1516
string title = "(RH402) Relación de Pagos por Compensación Variable"
string menuname = "m_impresion"
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
uo_1 uo_1
gb_1 gb_1
gb_2 gb_2
end type
global w_rh402_rpt_av_compensacion_variable w_rh402_rpt_av_compensacion_variable

on w_rh402_rpt_av_compensacion_variable.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.uo_1=create uo_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_rh402_rpt_av_compensacion_variable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes
string  ls_origen, ls_tipo_trabaj

ls_origen = string(em_origen.text)
li_ano 	 = integer(em_ano.text)
li_mes 	 = integer(em_mes.text)

ls_tipo_trabaj = uo_1.of_get_value()

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE pb_usp_rh_av_rpt_relacion_pago PROCEDURE FOR USP_RH_AV_RPT_RELACION_PAGO
	     ( :ls_origen, :ls_tipo_trabaj, :li_ano, :li_mes ) ;
EXECUTE pb_usp_rh_av_rpt_relacion_pago ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rh402_rpt_av_compensacion_variable
integer x = 0
integer y = 260
integer width = 3433
integer height = 992
integer taborder = 50
string dataobject = "d_rpt_av_pago_compensacion_tbl"
end type

type cb_1 from commandbutton within w_rh402_rpt_av_compensacion_variable
integer x = 3150
integer y = 116
integer width = 293
integer height = 76
integer taborder = 40
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

type em_ano from editmask within w_rh402_rpt_av_compensacion_variable
integer x = 2501
integer y = 128
integer width = 233
integer height = 76
integer taborder = 20
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
string mask = "####"
end type

type em_mes from editmask within w_rh402_rpt_av_compensacion_variable
integer x = 2894
integer y = 128
integer width = 165
integer height = 76
integer taborder = 30
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
string mask = "##"
end type

type st_1 from statictext within w_rh402_rpt_av_compensacion_variable
integer x = 2363
integer y = 132
integer width = 119
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

type st_2 from statictext within w_rh402_rpt_av_compensacion_variable
integer x = 2761
integer y = 132
integer width = 119
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

type cb_2 from commandbutton within w_rh402_rpt_av_compensacion_variable
integer x = 384
integer y = 128
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

type em_origen from editmask within w_rh402_rpt_av_compensacion_variable
integer x = 206
integer y = 128
integer width = 151
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

type em_descripcion from editmask within w_rh402_rpt_av_compensacion_variable
integer x = 498
integer y = 128
integer width = 805
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh402_rpt_av_compensacion_variable
integer x = 1385
integer y = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh402_rpt_av_compensacion_variable
integer x = 2322
integer y = 52
integer width = 786
integer height = 196
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

type gb_2 from groupbox within w_rh402_rpt_av_compensacion_variable
integer x = 155
integer y = 52
integer width = 1202
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

