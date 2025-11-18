$PBExportHeader$w_gxc_rpt_costos_agricolas_adm.srw
forward
global type w_gxc_rpt_costos_agricolas_adm from w_report_smpl
end type
type cb_1 from commandbutton within w_gxc_rpt_costos_agricolas_adm
end type
type st_3 from statictext within w_gxc_rpt_costos_agricolas_adm
end type
type st_4 from statictext within w_gxc_rpt_costos_agricolas_adm
end type
type em_ano from editmask within w_gxc_rpt_costos_agricolas_adm
end type
type em_mes from editmask within w_gxc_rpt_costos_agricolas_adm
end type
type cb_2 from commandbutton within w_gxc_rpt_costos_agricolas_adm
end type
type em_codigo from editmask within w_gxc_rpt_costos_agricolas_adm
end type
type em_descripcion from editmask within w_gxc_rpt_costos_agricolas_adm
end type
type gb_1 from groupbox within w_gxc_rpt_costos_agricolas_adm
end type
type gb_2 from groupbox within w_gxc_rpt_costos_agricolas_adm
end type
end forward

global type w_gxc_rpt_costos_agricolas_adm from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Resumen de Costos Agrícolas por Administraciones"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_3 st_3
st_4 st_4
em_ano em_ano
em_mes em_mes
cb_2 cb_2
em_codigo em_codigo
em_descripcion em_descripcion
gb_1 gb_1
gb_2 gb_2
end type
global w_gxc_rpt_costos_agricolas_adm w_gxc_rpt_costos_agricolas_adm

on w_gxc_rpt_costos_agricolas_adm.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.em_ano=create em_ano
this.em_mes=create em_mes
this.cb_2=create cb_2
this.em_codigo=create em_codigo
this.em_descripcion=create em_descripcion
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.em_codigo
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_gxc_rpt_costos_agricolas_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.cb_2)
destroy(this.em_codigo)
destroy(this.em_descripcion)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes
string  ls_adm

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)
ls_adm = string(em_codigo.text)

if isnull(ls_adm) or trim(ls_adm) = '' then ls_adm = '%'

DECLARE pb_usp_gxc_rpt_costos_administrac PROCEDURE FOR USP_GXC_RPT_COSTOS_ADMINISTRAC
        ( :li_ano, :li_mes, :ls_adm ) ;
EXECUTE pb_usp_gxc_rpt_costos_administrac ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_gxc_rpt_costos_agricolas_adm
integer x = 23
integer y = 312
integer width = 3287
integer height = 1092
integer taborder = 50
string dataobject = "d_gxc_rpt_costos_administrac_tbl"
end type

type cb_1 from commandbutton within w_gxc_rpt_costos_agricolas_adm
integer x = 2793
integer y = 116
integer width = 297
integer height = 92
integer taborder = 40
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

type st_3 from statictext within w_gxc_rpt_costos_agricolas_adm
integer x = 2359
integer y = 136
integer width = 133
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
long backcolor = 12632256
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gxc_rpt_costos_agricolas_adm
integer x = 1961
integer y = 136
integer width = 142
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
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_ano from editmask within w_gxc_rpt_costos_agricolas_adm
integer x = 2126
integer y = 128
integer width = 192
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_gxc_rpt_costos_agricolas_adm
integer x = 2528
integer y = 124
integer width = 105
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type cb_2 from commandbutton within w_gxc_rpt_costos_agricolas_adm
integer x = 791
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

sl_param.dw1 = "administracion_dddw"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_codigo from editmask within w_gxc_rpt_costos_agricolas_adm
integer x = 585
integer y = 128
integer width = 178
integer height = 72
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

type em_descripcion from editmask within w_gxc_rpt_costos_agricolas_adm
integer x = 905
integer y = 132
integer width = 869
integer height = 72
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

type gb_1 from groupbox within w_gxc_rpt_costos_agricolas_adm
integer x = 1929
integer y = 56
integer width = 782
integer height = 192
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione "
end type

type gb_2 from groupbox within w_gxc_rpt_costos_agricolas_adm
integer x = 526
integer y = 56
integer width = 1307
integer height = 192
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Administración "
end type

