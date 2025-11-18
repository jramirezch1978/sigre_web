$PBExportHeader$w_cn738_rpt_libro_taller_det.srw
forward
global type w_cn738_rpt_libro_taller_det from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn738_rpt_libro_taller_det
end type
type sle_mes from singlelineedit within w_cn738_rpt_libro_taller_det
end type
type cb_1 from commandbutton within w_cn738_rpt_libro_taller_det
end type
type st_3 from statictext within w_cn738_rpt_libro_taller_det
end type
type st_4 from statictext within w_cn738_rpt_libro_taller_det
end type
type sle_cencos from singlelineedit within w_cn738_rpt_libro_taller_det
end type
type sle_descripcion from singlelineedit within w_cn738_rpt_libro_taller_det
end type
type cb_2 from commandbutton within w_cn738_rpt_libro_taller_det
end type
type rb_1 from radiobutton within w_cn738_rpt_libro_taller_det
end type
type rb_2 from radiobutton within w_cn738_rpt_libro_taller_det
end type
type gb_1 from groupbox within w_cn738_rpt_libro_taller_det
end type
type gb_2 from groupbox within w_cn738_rpt_libro_taller_det
end type
type gb_3 from groupbox within w_cn738_rpt_libro_taller_det
end type
end forward

global type w_cn738_rpt_libro_taller_det from w_report_smpl
integer width = 3662
integer height = 1604
string title = "Detalle de las Operaciones de Talleres por Centro de Costos (CN738)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
sle_cencos sle_cencos
sle_descripcion sle_descripcion
cb_2 cb_2
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_cn738_rpt_libro_taller_det w_cn738_rpt_libro_taller_det

on w_cn738_rpt_libro_taller_det.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.sle_cencos=create sle_cencos
this.sle_descripcion=create sle_descripcion
this.cb_2=create cb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_cencos
this.Control[iCurrent+7]=this.sle_descripcion
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.rb_2
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_cn738_rpt_libro_taller_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_cencos)
destroy(this.sle_descripcion)
destroy(this.cb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve();call super::ue_retrieve;String  ls_cencos, ls_ano, ls_mes

ls_cencos = String(sle_cencos.text)
ls_ano    = String(sle_ano.text)
ls_mes    = String(sle_mes.text)

if isnull(ls_cencos) or trim(ls_cencos) = '' then ls_cencos = '%'

DECLARE pb_usp_cntbl_rpt_libro_taller_det PROCEDURE FOR USP_CNTBL_RPT_LIBRO_TALLER_DET
        ( :ls_ano, :ls_mes, :ls_cencos ) ;
Execute pb_usp_cntbl_rpt_libro_taller_det ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn738_rpt_libro_taller_det
integer x = 23
integer y = 288
integer width = 3579
integer height = 1116
integer taborder = 50
string dataobject = "d_cntbl_libro_taller_det_tbl"
end type

type sle_ano from singlelineedit within w_cn738_rpt_libro_taller_det
integer x = 2679
integer y = 112
integer width = 192
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn738_rpt_libro_taller_det
integer x = 3054
integer y = 112
integer width = 105
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn738_rpt_libro_taller_det
integer x = 3269
integer y = 96
integer width = 297
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_cn738_rpt_libro_taller_det
integer x = 2889
integer y = 120
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn738_rpt_libro_taller_det
integer x = 2514
integer y = 120
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_cencos from singlelineedit within w_cn738_rpt_libro_taller_det
integer x = 649
integer y = 112
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_descripcion from singlelineedit within w_cn738_rpt_libro_taller_det
integer x = 1106
integer y = 112
integer width = 1257
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_cn738_rpt_libro_taller_det
integer x = 997
integer y = 112
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;
// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_taller_matriz_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cencos.text      = sl_param.field_ret[1]
	sle_descripcion.text = sl_param.field_ret[2]
END IF

end event

type rb_1 from radiobutton within w_cn738_rpt_libro_taller_det
integer x = 82
integer y = 80
integer width = 430
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Costo"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_1.checked = true then
	sle_cencos.enabled      = true
	cb_2.enabled            = true
	sle_descripcion.enabled = true
end if

end event

type rb_2 from radiobutton within w_cn738_rpt_libro_taller_det
integer x = 82
integer y = 148
integer width = 430
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_2.checked = true then
	sle_cencos.enabled      = false
	cb_2.enabled            = false
	sle_descripcion.enabled = false
	sle_cencos.text         = ' '
	sle_descripcion.text    = ' '
end if

end event

type gb_1 from groupbox within w_cn738_rpt_libro_taller_det
integer x = 2478
integer y = 36
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_cn738_rpt_libro_taller_det
integer x = 585
integer y = 36
integer width = 1851
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Centro de Costo "
end type

type gb_3 from groupbox within w_cn738_rpt_libro_taller_det
integer x = 41
integer y = 16
integer width = 507
integer height = 228
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Opción "
end type

