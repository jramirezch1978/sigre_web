$PBExportHeader$w_al733_stock_mensual_valorizado.srw
forward
global type w_al733_stock_mensual_valorizado from w_report_smpl
end type
type st_1 from statictext within w_al733_stock_mensual_valorizado
end type
type cb_1 from commandbutton within w_al733_stock_mensual_valorizado
end type
type sle_alm from singlelineedit within w_al733_stock_mensual_valorizado
end type
type cb_alm from commandbutton within w_al733_stock_mensual_valorizado
end type
type st_desc_alm from statictext within w_al733_stock_mensual_valorizado
end type
type sle_mes from singlelineedit within w_al733_stock_mensual_valorizado
end type
type sle_anio from singlelineedit within w_al733_stock_mensual_valorizado
end type
type st_3 from statictext within w_al733_stock_mensual_valorizado
end type
type st_4 from statictext within w_al733_stock_mensual_valorizado
end type
type gb_1 from groupbox within w_al733_stock_mensual_valorizado
end type
end forward

global type w_al733_stock_mensual_valorizado from w_report_smpl
integer width = 2478
integer height = 1180
string title = "Stock Mensual Valorizado por Almacen [AL733]"
string menuname = "m_impresion"
long backcolor = 67108864
st_1 st_1
cb_1 cb_1
sle_alm sle_alm
cb_alm cb_alm
st_desc_alm st_desc_alm
sle_mes sle_mes
sle_anio sle_anio
st_3 st_3
st_4 st_4
gb_1 gb_1
end type
global w_al733_stock_mensual_valorizado w_al733_stock_mensual_valorizado

type variables

end variables

on w_al733_stock_mensual_valorizado.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_alm=create sle_alm
this.cb_alm=create cb_alm
this.st_desc_alm=create st_desc_alm
this.sle_mes=create sle_mes
this.sle_anio=create sle_anio
this.st_3=create st_3
this.st_4=create st_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_alm
this.Control[iCurrent+4]=this.cb_alm
this.Control[iCurrent+5]=this.st_desc_alm
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.sle_anio
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.gb_1
end on

on w_al733_stock_mensual_valorizado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_alm)
destroy(this.cb_alm)
destroy(this.st_desc_alm)
destroy(this.sle_mes)
destroy(this.sle_anio)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_almacen, ls_mensaje
date ld_date, ld_date1
double ln_mes, ln_tc
ln_mes = double(sle_mes.text) + 1

ld_date = date('01/'+string(ln_mes) +'/'+sle_anio.text)

ld_date1 = RelativeDate(ld_date , -1)

ls_almacen = sle_alm.text

ln_tc = f_get_tipo_cambio_vta(ld_date1)

//messagebox('fecha', string(ld_date1))

idw_1.Retrieve(double(sle_anio.text), double(sle_mes.text), ls_almacen, ln_tc)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_windows.text = this.classname()
idw_1.object.t_fechas.text   = 'Año : '+sle_anio.text+'  Mes :  '+string(sle_mes.text)+'  -  Almacen: ' + st_desc_alm.text+'  -  T.C. '+string(ln_tc)




end event

type dw_report from w_report_smpl`dw_report within w_al733_stock_mensual_valorizado
integer x = 14
integer y = 316
integer width = 2409
integer height = 664
integer taborder = 60
string dataobject = "d_rpt_saldo_mensual_artic_tbl"
end type

type st_1 from statictext within w_al733_stock_mensual_valorizado
integer x = 50
integer y = 192
integer width = 265
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacen :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_al733_stock_mensual_valorizado
integer x = 2071
integer y = 124
integer width = 338
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.Event ue_retrieve()
end event

type sle_alm from singlelineedit within w_al733_stock_mensual_valorizado
integer x = 329
integer y = 180
integer width = 325
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
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event losefocus;// Verifica que el almacen exista
String ls_alm
Long ll_count

ls_alm = sle_alm.text

if TRIM( ls_alm ) <> '' then
	Select count(*) into :ll_count from almacen where almacen = :ls_alm;
	if ll_count = 0 then
		Messagebox( "Error", "Codigo de almacen no existe")
		sle_alm.text = ''
		sle_alm.SetFocus()
		return 
	end if
end if
end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_alm.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

st_desc_alm.text = ls_desc
end event

type cb_alm from commandbutton within w_al733_stock_mensual_valorizado
integer x = 663
integer y = 180
integer width = 87
integer height = 80
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

event clicked;string ls_sql, ls_almacen, ls_data
boolean lb_ret

ls_sql = "SELECT ALMACEN AS CODIGO_ALMACEN, " &
		  + "DESC_ALMACEN AS DESCRIPCION_ALMACEN " &
		  + "FROM ALMACEN " 
			 
lb_ret = f_lista(ls_sql, ls_almacen, &
			ls_data, '1')
	
if ls_almacen <> '' then
	sle_alm.text		= ls_almacen
	st_desc_alm.text 	= ls_data
end if

end event

type st_desc_alm from statictext within w_al733_stock_mensual_valorizado
integer x = 759
integer y = 180
integer width = 1257
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
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_al733_stock_mensual_valorizado
integer x = 759
integer y = 72
integer width = 165
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type sle_anio from singlelineedit within w_al733_stock_mensual_valorizado
integer x = 325
integer y = 80
integer width = 197
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_al733_stock_mensual_valorizado
integer x = 165
integer y = 100
integer width = 160
integer height = 64
boolean bringtotop = true
integer textsize = -8
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

type st_4 from statictext within w_al733_stock_mensual_valorizado
integer x = 599
integer y = 88
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_al733_stock_mensual_valorizado
integer x = 18
integer y = 12
integer width = 2025
integer height = 288
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

