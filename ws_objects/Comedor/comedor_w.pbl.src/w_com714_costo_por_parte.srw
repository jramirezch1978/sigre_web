$PBExportHeader$w_com714_costo_por_parte.srw
forward
global type w_com714_costo_por_parte from w_rpt
end type
type pb_1 from picturebutton within w_com714_costo_por_parte
end type
type st_1 from statictext within w_com714_costo_por_parte
end type
type em_descripcion from editmask within w_com714_costo_por_parte
end type
type em_origen from singlelineedit within w_com714_costo_por_parte
end type
type uo_fecha from u_ingreso_rango_fechas within w_com714_costo_por_parte
end type
type dw_report from u_dw_rpt within w_com714_costo_por_parte
end type
type gb_2 from groupbox within w_com714_costo_por_parte
end type
end forward

global type w_com714_costo_por_parte from w_rpt
integer width = 2747
integer height = 1660
string title = "Costo de Parte de Ración(COM714)"
string menuname = "m_rpt"
long backcolor = 67108864
pb_1 pb_1
st_1 st_1
em_descripcion em_descripcion
em_origen em_origen
uo_fecha uo_fecha
dw_report dw_report
gb_2 gb_2
end type
global w_com714_costo_por_parte w_com714_costo_por_parte

on w_com714_costo_por_parte.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.pb_1=create pb_1
this.st_1=create st_1
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_2
end on

on w_com714_costo_por_parte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string ls_origen

ls_origen	= em_origen.text
ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ld_fecha2 < ld_fecha1 then
	MessageBox('COMEDORES', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

idw_1.Retrieve(ls_origen, ld_fecha1, ld_fecha2)
idw_1.Object.DataWindow.Print.Orientation = '1'
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Visible = True

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type pb_1 from picturebutton within w_com714_costo_por_parte
integer x = 2331
integer y = 36
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type st_1 from statictext within w_com714_costo_por_parte
integer x = 951
integer y = 16
integer width = 457
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
boolean focusrectangle = false
end type

type em_descripcion from editmask within w_com714_costo_por_parte
integer x = 238
integer y = 80
integer width = 663
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_com714_costo_por_parte
event dobleclick pbm_lbuttondblclk
integer x = 96
integer y = 80
integer width = 128
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type uo_fecha from u_ingreso_rango_fechas within w_com714_costo_por_parte
integer x = 960
integer y = 76
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999') ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_com714_costo_por_parte
integer x = 64
integer y = 228
integer width = 2578
integer height = 1188
string dataobject = "d_rpt_costo_parte_cpm"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_com714_costo_por_parte
integer x = 55
integer y = 16
integer width = 2245
integer height = 184
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

