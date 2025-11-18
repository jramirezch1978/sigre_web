$PBExportHeader$w_pt712_rpt_presup_mat_x_ot_adm.srw
forward
global type w_pt712_rpt_presup_mat_x_ot_adm from w_report_smpl
end type
type sle_ano from singlelineedit within w_pt712_rpt_presup_mat_x_ot_adm
end type
type st_1 from statictext within w_pt712_rpt_presup_mat_x_ot_adm
end type
type st_2 from statictext within w_pt712_rpt_presup_mat_x_ot_adm
end type
type sle_ot_adm from singlelineedit within w_pt712_rpt_presup_mat_x_ot_adm
end type
type cb_1 from commandbutton within w_pt712_rpt_presup_mat_x_ot_adm
end type
type pb_1 from picturebutton within w_pt712_rpt_presup_mat_x_ot_adm
end type
type gb_1 from groupbox within w_pt712_rpt_presup_mat_x_ot_adm
end type
end forward

global type w_pt712_rpt_presup_mat_x_ot_adm from w_report_smpl
integer width = 3163
integer height = 1740
string title = "Presupuesto de materiales por administrador de ord.trabajo (PT712)"
string menuname = "m_impresion"
long backcolor = 67108864
sle_ano sle_ano
st_1 st_1
st_2 st_2
sle_ot_adm sle_ot_adm
cb_1 cb_1
pb_1 pb_1
gb_1 gb_1
end type
global w_pt712_rpt_presup_mat_x_ot_adm w_pt712_rpt_presup_mat_x_ot_adm

on w_pt712_rpt_presup_mat_x_ot_adm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_ano=create sle_ano
this.st_1=create st_1
this.st_2=create st_2
this.sle_ot_adm=create sle_ot_adm
this.cb_1=create cb_1
this.pb_1=create pb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_ot_adm
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_pt712_rpt_presup_mat_x_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_ot_adm)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.gb_1)
end on

type dw_report from w_report_smpl`dw_report within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 18
integer y = 284
integer width = 3090
integer height = 1292
integer taborder = 30
string dataobject = "d_rpt_presup_mat_x_ot_adm_tbl"
end type

type sle_ano from singlelineedit within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 256
integer y = 116
integer width = 160
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 64
integer y = 116
integer width = 183
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 567
integer y = 116
integer width = 672
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Administrador de OT:"
boolean focusrectangle = false
end type

type sle_ot_adm from singlelineedit within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 1202
integer y = 116
integer width = 343
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 1815
integer y = 108
integer width = 306
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_ano, ls_ot_adm

ls_ano = sle_ano.text
ls_ot_adm = sle_ot_adm.text 
idw_1.Visible = true
idw_1.retrieve(trim(ls_ano), trim(ls_ot_adm))

idw_1.object.t_texto.text = 'Año: ' + trim(ls_ano) + ' - OT_ADM ' + trim(ls_ot_adm)
idw_1.object.t_empresa.text = gs_empresa
idw_1.Object.p_logo.filename = gs_logo
end event

type pb_1 from picturebutton within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 1573
integer y = 104
integer width = 128
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;// Asigna valores a structura 
Long ll_ano
str_parametros sl_param

if trim( sle_ano.text) = '' then
	Messagebox( "Atencion", "Ingrese Año")
	sle_ano.Setfocus()
	return
end if
	
sl_param.dw1 = "d_lista_ot_adm_tbl"
sl_param.titulo = "Administradores de OT"
sl_param.field_ret_i[1] = 1
sl_param.tipo = '1N'
//sl_param.Long1 = ll_ano

OpenWithParm( w_search, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then			
	sle_ot_adm.text = sl_param.field_ret[1]
END IF

end event

type gb_1 from groupbox within w_pt712_rpt_presup_mat_x_ot_adm
integer x = 23
integer y = 48
integer width = 1733
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

