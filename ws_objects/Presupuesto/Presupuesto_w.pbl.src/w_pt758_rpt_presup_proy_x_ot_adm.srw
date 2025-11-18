$PBExportHeader$w_pt758_rpt_presup_proy_x_ot_adm.srw
forward
global type w_pt758_rpt_presup_proy_x_ot_adm from w_report_smpl
end type
type sle_ano from singlelineedit within w_pt758_rpt_presup_proy_x_ot_adm
end type
type st_1 from statictext within w_pt758_rpt_presup_proy_x_ot_adm
end type
type st_2 from statictext within w_pt758_rpt_presup_proy_x_ot_adm
end type
type sle_codigo from singlelineedit within w_pt758_rpt_presup_proy_x_ot_adm
end type
type cb_1 from commandbutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type pb_1 from picturebutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type rb_ot_adm from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type rb_cen_ben from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type rb_cencos from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type rb_cnta_prsp from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type rb_todos from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type cbx_res from checkbox within w_pt758_rpt_presup_proy_x_ot_adm
end type
type cbx_det from checkbox within w_pt758_rpt_presup_proy_x_ot_adm
end type
type rb_ot from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
end type
type cbx_servicio from checkbox within w_pt758_rpt_presup_proy_x_ot_adm
end type
type gb_1 from groupbox within w_pt758_rpt_presup_proy_x_ot_adm
end type
end forward

global type w_pt758_rpt_presup_proy_x_ot_adm from w_report_smpl
integer width = 3163
integer height = 1740
string title = "(PT758) Presupuesto proyectado por administrador de ord.trabajo "
string menuname = "m_impresion"
long backcolor = 67108864
sle_ano sle_ano
st_1 st_1
st_2 st_2
sle_codigo sle_codigo
cb_1 cb_1
pb_1 pb_1
rb_ot_adm rb_ot_adm
rb_cen_ben rb_cen_ben
rb_cencos rb_cencos
rb_cnta_prsp rb_cnta_prsp
rb_todos rb_todos
cbx_res cbx_res
cbx_det cbx_det
rb_ot rb_ot
cbx_servicio cbx_servicio
gb_1 gb_1
end type
global w_pt758_rpt_presup_proy_x_ot_adm w_pt758_rpt_presup_proy_x_ot_adm

on w_pt758_rpt_presup_proy_x_ot_adm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_ano=create sle_ano
this.st_1=create st_1
this.st_2=create st_2
this.sle_codigo=create sle_codigo
this.cb_1=create cb_1
this.pb_1=create pb_1
this.rb_ot_adm=create rb_ot_adm
this.rb_cen_ben=create rb_cen_ben
this.rb_cencos=create rb_cencos
this.rb_cnta_prsp=create rb_cnta_prsp
this.rb_todos=create rb_todos
this.cbx_res=create cbx_res
this.cbx_det=create cbx_det
this.rb_ot=create rb_ot
this.cbx_servicio=create cbx_servicio
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_codigo
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rb_ot_adm
this.Control[iCurrent+8]=this.rb_cen_ben
this.Control[iCurrent+9]=this.rb_cencos
this.Control[iCurrent+10]=this.rb_cnta_prsp
this.Control[iCurrent+11]=this.rb_todos
this.Control[iCurrent+12]=this.cbx_res
this.Control[iCurrent+13]=this.cbx_det
this.Control[iCurrent+14]=this.rb_ot
this.Control[iCurrent+15]=this.cbx_servicio
this.Control[iCurrent+16]=this.gb_1
end on

on w_pt758_rpt_presup_proy_x_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_codigo)
destroy(this.cb_1)
destroy(this.pb_1)
destroy(this.rb_ot_adm)
destroy(this.rb_cen_ben)
destroy(this.rb_cencos)
destroy(this.rb_cnta_prsp)
destroy(this.rb_todos)
destroy(this.cbx_res)
destroy(this.cbx_det)
destroy(this.rb_ot)
destroy(this.cbx_servicio)
destroy(this.gb_1)
end on

event ue_filter;call super::ue_filter;idw_1.GroupCalc()
end event

event ue_open_pre;call super::ue_open_pre;sle_codigo.enabled = false
pb_1.enabled = false
sle_ano.text = string(today(),'yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 18
integer y = 512
integer width = 3090
integer height = 1064
integer taborder = 30
string dataobject = "d_rpt_ppto_proy_res_general_grd"
end type

type sle_ano from singlelineedit within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 329
integer y = 340
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

type st_1 from statictext within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 137
integer y = 340
integer width = 183
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 640
integer y = 340
integer width = 599
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 1275
integer y = 340
integer width = 411
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

type cb_1 from commandbutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 2533
integer y = 332
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

event clicked;String ls_servicio, ls_codigo, ls_texto, ls_ano
Long ll_ano

ls_ano = sle_ano.text
ll_ano = LONG(sle_ano.text)

IF cbx_res.checked=TRUE AND cbx_det.checked=TRUE THEN
	MessageBox('Aviso','Elija modelo de reporte: Resumen o Detalle, ambos activos')
	Return
END IF

IF cbx_res.checked=FALSE AND cbx_det.checked=FALSE THEN
	MessageBox('Aviso','Elija modelo de reporte: Resumen o Detalle, ambos inactivos')
	Return
END IF


IF cbx_servicio.checked=TRUE THEN
	ls_servicio = '1'
ELSE
	ls_servicio = '0'
END IF

DECLARE PB_USP_proc PROCEDURE FOR USP_PTO_PROY_PRESUP_X_OT_ADM
(:ll_ano, :ls_servicio);

EXECUTE PB_USP_PROC;

IF sqlca.sqlcode = -1 then
	messagebox("Error", sqlca.sqlerrtext)
	return 0
END IF 


IF cbx_res.checked THEN
	IF rb_todos.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_res_general_grd'
		ls_texto = 'Resumen general del año ' + ls_ano
	ELSEIF rb_ot_adm.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_res_ot_adm_grd'
		ls_texto = 'Resumen del OT_ADM ' + ls_codigo + ' del año ' + ls_ano
	ELSEIF rb_cen_ben.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_res_cen_ben_grd'
		ls_texto = 'Resumen del centro de beneficio ' + ls_codigo + ' del año ' + ls_ano
	ELSEIF rb_cencos.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_res_cencos_grd'
		ls_texto = 'Resumen del centro de costo ' + ls_codigo + ' del año ' + ls_ano
	ELSEIF rb_cnta_prsp.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_res_cnta_prsp_grd'
		ls_texto = 'Resumen de la cuenta presupuestal ' + ls_codigo + ' del año ' + ls_ano
	ELSEIF rb_ot.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_res_ot_grd'
		ls_texto = 'Resumen de la orden de trabajo ' + ls_codigo + ' del año ' + ls_ano
	END IF
ELSE
	IF rb_todos.checked = TRUE THEN
		idw_1.DataObject='d_rpt_ppto_proy_det_general_grd'
		ls_texto = 'Detalle general del año ' + ls_ano
	ELSEIF rb_ot_adm.checked = TRUE THEN
//		idw_1.DataObject='d_rpt_ppto_proy_det_ot_adm_grd'
		ls_texto = 'Detalle del OT_ADM ' + ls_codigo + ' del año ' + ls_ano		
	ELSEIF rb_cen_ben.checked = TRUE THEN
//		idw_1.DataObject='d_rpt_ppto_proy_det_cen_ben_grd'
		ls_texto = 'Detalle del centro de beneficio ' + ls_codigo + ' del año ' + ls_ano		
	ELSEIF rb_cencos.checked = TRUE THEN
//		idw_1.DataObject='d_rpt_ppto_proy_det_cencos_grd'
		ls_texto = 'Detalle del centro de costo ' + ls_codigo + ' del año ' + ls_ano		
	ELSEIF rb_cnta_prsp.checked = TRUE THEN
//		idw_1.DataObject='d_rpt_ppto_proy_det_cnta_prsp_grd'
		ls_texto = 'Detalle de la cuenta presupuestal ' + ls_codigo + ' del año ' + ls_ano		
	ELSEIF rb_ot.checked = TRUE THEN
//		idw_1.DataObject='d_rpt_ppto_proy_det_ot_grd'
		ls_texto = 'Detalle de la orden de trabajo ' + ls_codigo + ' del año ' + ls_ano		
	END IF
END IF

idw_1.SetTransObject(sqlca)

idw_1.Visible = true
IF rb_todos.checked = TRUE THEN
	idw_1.retrieve()
ELSE
	ls_codigo = TRIM(sle_codigo.text)
	idw_1.retrieve(ls_codigo)	
END IF

idw_1.object.t_texto.text = ls_texto
idw_1.object.t_empresa.text = gs_empresa
idw_1.Object.p_logo.filename = gs_logo
end event

type pb_1 from picturebutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 1714
integer y = 328
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
string disabledname = "H:\Source\BMP\file_open.bmp"
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
	sle_codigo.text = sl_param.field_ret[1]
END IF

end event

type rb_ot_adm from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 759
integer y = 136
integer width = 800
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por Administrador de OT "
end type

event clicked;st_2.text = 'OT ADM :'
sle_codigo.enabled = true
pb_1.enabled = true

end event

type rb_cen_ben from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 759
integer y = 216
integer width = 709
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por centro de beneficio "
end type

event clicked;st_2.text = 'Centro Beneficio :'
sle_codigo.enabled = true
pb_1.enabled = true

end event

type rb_cencos from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 1641
integer y = 56
integer width = 603
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por centro de costo"
end type

event clicked;st_2.text = 'Centro de Costo :'
sle_codigo.enabled = true
pb_1.enabled = true

end event

type rb_cnta_prsp from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 1641
integer y = 136
integer width = 727
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por cuenta presupuestal"
end type

event clicked;st_2.text = 'Cuenta Presupuestal :'
sle_codigo.enabled = true
pb_1.enabled = true

end event

type rb_todos from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 759
integer y = 56
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;sle_codigo.enabled = false
pb_1.enabled = false

end event

type cbx_res from checkbox within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 137
integer y = 76
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

type cbx_det from checkbox within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 137
integer y = 172
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type rb_ot from radiobutton within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 1641
integer y = 216
integer width = 617
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Por orden de trabajo"
end type

event clicked;st_2.text = 'Por Orden Trabaj. :'
sle_codigo.enabled = true
pb_1.enabled = true

end event

type cbx_servicio from checkbox within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 2496
integer y = 84
integer width = 512
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incluye Servicios"
boolean checked = true
end type

type gb_1 from groupbox within w_pt758_rpt_presup_proy_x_ot_adm
integer x = 96
integer y = 16
integer width = 2322
integer height = 456
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

