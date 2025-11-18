$PBExportHeader$w_pr724_costo_trans_os.srw
forward
global type w_pr724_costo_trans_os from w_rpt
end type
type cbx_tipo_m from checkbox within w_pr724_costo_trans_os
end type
type ddlb_tipo_t from dropdownlistbox within w_pr724_costo_trans_os
end type
type st_1 from statictext within w_pr724_costo_trans_os
end type
type em_nombre from editmask within w_pr724_costo_trans_os
end type
type em_proveedor from singlelineedit within w_pr724_costo_trans_os
end type
type pb_2 from picturebutton within w_pr724_costo_trans_os
end type
type em_descripcion from editmask within w_pr724_costo_trans_os
end type
type em_origen from singlelineedit within w_pr724_costo_trans_os
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr724_costo_trans_os
end type
type dw_report from u_dw_rpt within w_pr724_costo_trans_os
end type
type gb_2 from groupbox within w_pr724_costo_trans_os
end type
type gb_1 from groupbox within w_pr724_costo_trans_os
end type
type gb_3 from groupbox within w_pr724_costo_trans_os
end type
end forward

global type w_pr724_costo_trans_os from w_rpt
integer width = 4402
integer height = 2092
string title = "Resumen de OS de Transporte(PR724)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
cbx_tipo_m cbx_tipo_m
ddlb_tipo_t ddlb_tipo_t
st_1 st_1
em_nombre em_nombre
em_proveedor em_proveedor
pb_2 pb_2
em_descripcion em_descripcion
em_origen em_origen
uo_fecha uo_fecha
dw_report dw_report
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_pr724_costo_trans_os w_pr724_costo_trans_os

event ue_query_retrieve();// Ancestor Script has been Override

SetPointer(HourGlass!)
this.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

on w_pr724_costo_trans_os.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_tipo_m=create cbx_tipo_m
this.ddlb_tipo_t=create ddlb_tipo_t
this.st_1=create st_1
this.em_nombre=create em_nombre
this.em_proveedor=create em_proveedor
this.pb_2=create pb_2
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_tipo_m
this.Control[iCurrent+2]=this.ddlb_tipo_t
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_nombre
this.Control[iCurrent+5]=this.em_proveedor
this.Control[iCurrent+6]=this.pb_2
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_3
end on

on w_pr724_costo_trans_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_tipo_m)
destroy(this.ddlb_tipo_t)
destroy(this.st_1)
destroy(this.em_nombre)
destroy(this.em_proveedor)
destroy(this.pb_2)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
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

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string 	ls_origen, ls_proveedor, ls_desc_o, ls_nombre_p, ls_flag_tipo

ls_origen		= em_origen.text
ls_proveedor	= em_proveedor.text
ld_fecha1 		= uo_fecha.of_get_fecha1( )
ld_fecha2 		= uo_fecha.of_get_fecha2( )


if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('PRODUCCIÓN', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCIÓN', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if cbx_tipo_m.checked = true then
	ls_flag_tipo = '%%'
else
	ls_flag_tipo 	= left(ddlb_tipo_t.text,1)

	IF ls_flag_tipo = '' or isnull(ls_flag_tipo) then
		Messagebox('Producción', 'Debe de Indicar un Tipo de Trabajador')
		Return
	end if
	
end if

select nom_proveedor 
  into :ls_nombre_p
  from proveedor
  where proveedor = :ls_proveedor;

select nombre
  into :ls_desc_o
from origen
where cod_origen = :ls_origen;

idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_origen, ls_proveedor, ls_flag_tipo)
idw_1.Object.t_fecha1.text = string(ld_fecha1)
idw_1.Object.t_fecha2.text = string(ld_fecha2)
idw_1.Object.t_cod_proveedor.text = ls_proveedor
idw_1.Object.t_nombre_proveedor.text = ls_nombre_p
idw_1.Object.t_o.text = ls_origen
idw_1.Object.t_desc_o.text = ls_desc_o
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.DataWindow.Print.Orientation = '1'
idw_1.Visible = True


end event

type cbx_tipo_m from checkbox within w_pr724_costo_trans_os
integer x = 1723
integer y = 296
integer width = 91
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	
	ddlb_tipo_t.enabled = false
	
else
	
	ddlb_tipo_t.enabled = true

end if
end event

type ddlb_tipo_t from dropdownlistbox within w_pr724_costo_trans_os
integer x = 1824
integer y = 300
integer width = 457
integer height = 352
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean hscrollbar = true
boolean vscrollbar = true
string item[] = {"E - Empleado","O - Obrero"}
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pr724_costo_trans_os
integer x = 1755
integer y = 236
integer width = 457
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo de Empleado"
boolean focusrectangle = false
end type

type em_nombre from editmask within w_pr724_costo_trans_os
integer x = 325
integer y = 304
integer width = 1312
integer height = 76
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_proveedor from singlelineedit within w_pr724_costo_trans_os
event dobleclick pbm_lbuttondblclk
integer x = 55
integer y = 304
integer width = 261
integer height = 76
integer taborder = 70
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
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT proveedor as codigo, " & 
		  +"nom_proveedor AS nombre " &
		  + "FROM proveedor " &
		  + "WHERE flag_estado = '1' and proveedor in (Select p.proveedor from prod_parte_transp p)"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_nombre.text = ls_data
end if

end event

event modified;String 	ls_proveedor, ls_desc

ls_proveedor = this.text
if ls_proveedor = '' or IsNull(ls_proveedor) then
	MessageBox('Aviso', 'Debe Ingresar un Proveedor')
	return
end if

SELECT nom_proveedor INTO :ls_desc
FROM proveedor
WHERE proveedor =:ls_proveedor;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	return
end if

em_nombre.text = ls_desc

end event

type pb_2 from picturebutton within w_pr724_costo_trans_os
integer x = 2875
integer y = 120
integer width = 315
integer height = 172
integer taborder = 30
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

type em_descripcion from editmask within w_pr724_costo_trans_os
integer x = 1554
integer y = 104
integer width = 663
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_pr724_costo_trans_os
event dobleclick pbm_lbuttondblclk
integer x = 1403
integer y = 108
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

type uo_fecha from u_ingreso_rango_fechas within w_pr724_costo_trans_os
event destroy ( )
integer x = 55
integer y = 92
integer taborder = 50
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

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

type dw_report from u_dw_rpt within w_pr724_costo_trans_os
integer x = 23
integer y = 436
integer width = 3730
integer height = 1440
string dataobject = "d_rpt_costo_trans_x_os_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_pr724_costo_trans_os
integer x = 27
integer y = 36
integer width = 1335
integer height = 184
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Rango de Fechas"
end type

type gb_1 from groupbox within w_pr724_costo_trans_os
integer x = 27
integer y = 224
integer width = 1664
integer height = 184
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Proveedor"
end type

type gb_3 from groupbox within w_pr724_costo_trans_os
integer x = 1371
integer y = 36
integer width = 901
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

