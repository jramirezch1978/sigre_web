$PBExportHeader$w_al707_mov_sin_numero_serie.srw
forward
global type w_al707_mov_sin_numero_serie from w_report_smpl
end type
type sle_almacen from singlelineedit within w_al707_mov_sin_numero_serie
end type
type sle_descrip from singlelineedit within w_al707_mov_sin_numero_serie
end type
type cb_reporte from commandbutton within w_al707_mov_sin_numero_serie
end type
type gb_1 from groupbox within w_al707_mov_sin_numero_serie
end type
end forward

global type w_al707_mov_sin_numero_serie from w_report_smpl
integer height = 1688
string title = "[AL706] Stock por Numero de Serie"
string menuname = "m_impresion"
sle_almacen sle_almacen
sle_descrip sle_descrip
cb_reporte cb_reporte
gb_1 gb_1
end type
global w_al707_mov_sin_numero_serie w_al707_mov_sin_numero_serie

on w_al707_mov_sin_numero_serie.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.cb_reporte=create cb_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_almacen
this.Control[iCurrent+2]=this.sle_descrip
this.Control[iCurrent+3]=this.cb_reporte
this.Control[iCurrent+4]=this.gb_1
end on

on w_al707_mov_sin_numero_serie.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.cb_reporte)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_almacen

ls_almacen = sle_almacen.text

if ls_almacen = "" then
	MessageBox('Error', 'Debe especificar un almacen')
	sle_almacen.SetFocus()
	return
end if

dw_report.Retrieve(ls_almacen)

dw_report.visible = true
dw_report.Object.p_logo.filename = gnvo_app.is_logo
//dw_report.Object.DAtaWindow.Print.Orientation = 1
end event

type p_pie from w_report_smpl`p_pie within w_al707_mov_sin_numero_serie
end type

type ole_skin from w_report_smpl`ole_skin within w_al707_mov_sin_numero_serie
end type

type uo_h from w_report_smpl`uo_h within w_al707_mov_sin_numero_serie
end type

type st_box from w_report_smpl`st_box within w_al707_mov_sin_numero_serie
end type

type phl_logonps from w_report_smpl`phl_logonps within w_al707_mov_sin_numero_serie
end type

type p_mundi from w_report_smpl`p_mundi within w_al707_mov_sin_numero_serie
end type

type p_logo from w_report_smpl`p_logo within w_al707_mov_sin_numero_serie
end type

type uo_filter from w_report_smpl`uo_filter within w_al707_mov_sin_numero_serie
end type

type st_filtro from w_report_smpl`st_filtro within w_al707_mov_sin_numero_serie
end type

type dw_report from w_report_smpl`dw_report within w_al707_mov_sin_numero_serie
integer x = 507
integer y = 488
integer height = 860
string dataobject = "d_rpt_mov_sin_ns_tbl"
end type

type sle_almacen from singlelineedit within w_al707_mov_sin_numero_serie
event dobleclick pbm_lbuttondblclk
integer x = 571
integer y = 348
integer width = 224
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O' "  &
		 + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O'
  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de la empresa')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al707_mov_sin_numero_serie
integer x = 800
integer y = 348
integer width = 1211
integer height = 88
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_reporte from commandbutton within w_al707_mov_sin_numero_serie
integer x = 2080
integer y = 344
integer width = 402
integer height = 112
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

type gb_1 from groupbox within w_al707_mov_sin_numero_serie
integer x = 544
integer y = 272
integer width = 1518
integer height = 208
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Almacen:"
end type

