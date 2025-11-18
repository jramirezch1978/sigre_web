$PBExportHeader$w_pr728_reporte_detalle_lav_os.srw
forward
global type w_pr728_reporte_detalle_lav_os from w_rpt
end type
type em_descripcion from editmask within w_pr728_reporte_detalle_lav_os
end type
type em_origen from singlelineedit within w_pr728_reporte_detalle_lav_os
end type
type pb_1 from picturebutton within w_pr728_reporte_detalle_lav_os
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr728_reporte_detalle_lav_os
end type
type em_proveedor from singlelineedit within w_pr728_reporte_detalle_lav_os
end type
type em_nombre from editmask within w_pr728_reporte_detalle_lav_os
end type
type dw_report from u_dw_rpt within w_pr728_reporte_detalle_lav_os
end type
type gb_2 from groupbox within w_pr728_reporte_detalle_lav_os
end type
type gb_3 from groupbox within w_pr728_reporte_detalle_lav_os
end type
end forward

global type w_pr728_reporte_detalle_lav_os from w_rpt
integer width = 3415
integer height = 1964
string title = "Resumen de Raciones Por Comprobante(COM708)"
string menuname = "m_reporte"
long backcolor = 67108864
em_descripcion em_descripcion
em_origen em_origen
pb_1 pb_1
uo_fecha uo_fecha
em_proveedor em_proveedor
em_nombre em_nombre
dw_report dw_report
gb_2 gb_2
gb_3 gb_3
end type
global w_pr728_reporte_detalle_lav_os w_pr728_reporte_detalle_lav_os

on w_pr728_reporte_detalle_lav_os.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.pb_1=create pb_1
this.uo_fecha=create uo_fecha
this.em_proveedor=create em_proveedor
this.em_nombre=create em_nombre
this.dw_report=create dw_report
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_descripcion
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.em_proveedor
this.Control[iCurrent+6]=this.em_nombre
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_pr728_reporte_detalle_lav_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.pb_1)
destroy(this.uo_fecha)
destroy(this.em_proveedor)
destroy(this.em_nombre)
destroy(this.dw_report)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

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

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_mensaje, ls_nombre_origen, ls_proveedor, ls_nombre_p
integer 	li_ok
date ld_fecha_ini, ld_fecha_fin

this.SetRedraw(false)

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
ls_origen	= em_origen.text
ls_proveedor	= em_proveedor.text

select nombre 
into :ls_nombre_origen
from origen
where cod_origen = :ls_origen;

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

select nom_proveedor
into :ls_nombre_p
from proveedor
where proveedor = :ls_proveedor;

if ls_proveedor = '' or IsNull( ls_proveedor) then
	MessageBox('COMEDORES', 'PROVEEDOR NO ESTA DEFINIDO', StopSign!)
	return
end if


idw_1.Retrieve(ls_origen, ld_fecha_ini, ld_fecha_fin, ls_proveedor)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_origen.text  = ls_nombre_origen
idw_1.Object.t_proveedor.text  = ls_proveedor
idw_1.Object.t_nombre_p.text  = ls_nombre_p
idw_1.Object.t_fecha1.text  = string(ld_fecha_ini)
idw_1.Object.t_fecha2.text  = string(ld_fecha_fin)
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
end event

event ue_sort;call super::ue_sort;idw_1.EVENT ue_sort()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type em_descripcion from editmask within w_pr728_reporte_detalle_lav_os
integer x = 242
integer y = 116
integer width = 663
integer height = 72
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

type em_origen from singlelineedit within w_pr728_reporte_detalle_lav_os
event dobleclick pbm_lbuttondblclk
integer x = 101
integer y = 116
integer width = 128
integer height = 72
integer taborder = 30
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

type pb_1 from picturebutton within w_pr728_reporte_detalle_lav_os
integer x = 2830
integer y = 44
integer width = 315
integer height = 180
integer taborder = 40
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

type uo_fecha from u_ingreso_rango_fechas_v within w_pr728_reporte_detalle_lav_os
integer x = 2149
integer y = 52
integer height = 188
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type em_proveedor from singlelineedit within w_pr728_reporte_detalle_lav_os
event dobleclick pbm_lbuttondblclk
integer x = 1010
integer y = 108
integer width = 261
integer height = 72
integer taborder = 10
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
		  + "WHERE flag_estado = '1' "
				  
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

type em_nombre from editmask within w_pr728_reporte_detalle_lav_os
integer x = 1280
integer y = 108
integer width = 763
integer height = 72
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

type dw_report from u_dw_rpt within w_pr728_reporte_detalle_lav_os
integer x = 50
integer y = 284
integer width = 3072
integer height = 1460
integer taborder = 20
string dataobject = "d_com_resumen_raciones_cmp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_pr728_reporte_detalle_lav_os
integer x = 983
integer y = 28
integer width = 1111
integer height = 216
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

type gb_3 from groupbox within w_pr728_reporte_detalle_lav_os
integer x = 55
integer y = 32
integer width = 910
integer height = 216
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

