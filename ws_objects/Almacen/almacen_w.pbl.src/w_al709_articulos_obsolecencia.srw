$PBExportHeader$w_al709_articulos_obsolecencia.srw
forward
global type w_al709_articulos_obsolecencia from w_report_smpl
end type
type cb_1 from commandbutton within w_al709_articulos_obsolecencia
end type
type st_1 from statictext within w_al709_articulos_obsolecencia
end type
type em_dias from editmask within w_al709_articulos_obsolecencia
end type
type sle_almacen from singlelineedit within w_al709_articulos_obsolecencia
end type
type sle_descrip from singlelineedit within w_al709_articulos_obsolecencia
end type
type cbx_1 from checkbox within w_al709_articulos_obsolecencia
end type
type cb_2 from commandbutton within w_al709_articulos_obsolecencia
end type
type sle_1 from singlelineedit within w_al709_articulos_obsolecencia
end type
type cbx_2 from checkbox within w_al709_articulos_obsolecencia
end type
end forward

global type w_al709_articulos_obsolecencia from w_report_smpl
integer width = 3643
integer height = 2084
string title = "Articulos en Obsolecencia (AL709)"
string menuname = "m_impresion"
long backcolor = 79741120
cb_1 cb_1
st_1 st_1
em_dias em_dias
sle_almacen sle_almacen
sle_descrip sle_descrip
cbx_1 cbx_1
cb_2 cb_2
sle_1 sle_1
cbx_2 cbx_2
end type
global w_al709_articulos_obsolecencia w_al709_articulos_obsolecencia

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al709_articulos_obsolecencia.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_1=create st_1
this.em_dias=create em_dias
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.cbx_1=create cbx_1
this.cb_2=create cb_2
this.sle_1=create sle_1
this.cbx_2=create cbx_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_dias
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.cbx_2
end on

on w_al709_articulos_obsolecencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_dias)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.cbx_1)
destroy(this.cb_2)
destroy(this.sle_1)
destroy(this.cbx_2)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_almacen
Date		ld_fecha

ld_fecha = Date(f_fecha_actual())

idw_1.Visible = True
if cbx_2.checked = false then
	if cbx_1.checked then
		idw_1.dataobject = 'd_rpt_articulo_obsolecencia'
		idw_1.SetTransObject(SQLCA)
		idw_1.Retrieve(gd_fecha,long(em_dias.text))
	else
		ls_almacen = trim(sle_almacen.text)
		if ls_almacen = '' then
			MessageBox('Error', 'Debe ingresar un almacen')
			return
		end if
		
		idw_1.dataobject = 'd_rpt_articulo_obsol_x_alm'
		idw_1.SetTransObject(SQLCA)
		idw_1.Retrieve(gd_fecha,long(em_dias.text), ls_almacen)
	end if
else
	if cbx_1.checked then
		idw_1.dataobject = 'd_rpt_articulo_obsoletos_am'
		idw_1.SetTransObject(SQLCA)
		idw_1.Retrieve(gd_fecha,long(em_dias.text))
	else
		ls_almacen = trim(sle_almacen.text)
		if ls_almacen = '' then
			MessageBox('Error', 'Debe ingresar un almacen')
			return
		end if
		
		idw_1.dataobject = 'd_rpt_articulo_obsol_x_alm_am'
		idw_1.SetTransObject(SQLCA)
		idw_1.Retrieve(gd_fecha,long(em_dias.text), ls_almacen)
	end if
end if

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.empresa_t.text = gs_empresa
idw_1.Object.usuario_t.text = gs_user
idw_1.Object.objeto_t.text = this.ClassName( )

ib_preview = false
idw_1.ii_zoom_actual = 100
this.event ue_preview()


end event

type dw_report from w_report_smpl`dw_report within w_al709_articulos_obsolecencia
integer x = 0
integer y = 308
integer width = 3035
integer height = 1112
string dataobject = "d_rpt_articulo_obsolecencia"
boolean hscrollbar = false
end type

type cb_1 from commandbutton within w_al709_articulos_obsolecencia
integer x = 2002
integer y = 124
integer width = 471
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Genera Reporte"
end type

event clicked;
Parent.Event ue_retrieve()
end event

type st_1 from statictext within w_al709_articulos_obsolecencia
integer x = 73
integer y = 40
integer width = 635
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dias sin movimiento:"
boolean focusrectangle = false
end type

type em_dias from editmask within w_al709_articulos_obsolecencia
integer x = 73
integer y = 128
integer width = 402
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "#######"
end type

type sle_almacen from singlelineedit within w_al709_articulos_obsolecencia
event dobleclick pbm_lbuttondblclk
integer x = 745
integer y = 132
integer width = 224
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
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
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()

end event

type sle_descrip from singlelineedit within w_al709_articulos_obsolecencia
integer x = 974
integer y = 132
integer width = 992
integer height = 88
integer taborder = 50
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

type cbx_1 from checkbox within w_al709_articulos_obsolecencia
integer x = 777
integer y = 24
integer width = 654
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los Almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type cb_2 from commandbutton within w_al709_articulos_obsolecencia
boolean visible = false
integer x = 2487
integer y = 116
integer width = 215
integer height = 120
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "PDF"
end type

event clicked;string ls_path, ls_file, ls_print
int li_rc

li_rc = GetFileSaveName ( "Select File", ls_path, ls_file, &
		"PDF", "All Files (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc <> 1 Then return

//idw_1.Modify("Export.PDF.Method = XSLFOP! ") 

ls_print = sle_1.text

idw_1.Object.DataWindow.Export.PDF.Method = Distill! 
idw_1.Object.DataWindow.Printer = ls_print
idw_1.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
//idw_1.Object.DataWindow.Export.PDF.xslfop.print='Yes'
idw_1.saveAs(ls_file, PDF!, true)
end event

type sle_1 from singlelineedit within w_al709_articulos_obsolecencia
boolean visible = false
integer x = 2162
integer width = 603
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Sybase DataWindow PS"
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_al709_articulos_obsolecencia
integer x = 73
integer y = 224
integer width = 1166
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
string text = "Considera Movimientos de Almacén"
boolean checked = true
end type

