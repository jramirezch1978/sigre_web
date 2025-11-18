$PBExportHeader$w_com713_conciliacion_pvsf_rpt.srw
forward
global type w_com713_conciliacion_pvsf_rpt from w_rpt_general
end type
type em_descripcion from editmask within w_com713_conciliacion_pvsf_rpt
end type
type em_origen from singlelineedit within w_com713_conciliacion_pvsf_rpt
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_com713_conciliacion_pvsf_rpt
end type
type pb_1 from picturebutton within w_com713_conciliacion_pvsf_rpt
end type
type gb_2 from groupbox within w_com713_conciliacion_pvsf_rpt
end type
end forward

global type w_com713_conciliacion_pvsf_rpt from w_rpt_general
integer width = 3424
integer height = 2652
string title = "Facturas por Fechas(COM713)"
em_descripcion em_descripcion
em_origen em_origen
uo_fecha uo_fecha
pb_1 pb_1
gb_2 gb_2
end type
global w_com713_conciliacion_pvsf_rpt w_com713_conciliacion_pvsf_rpt

on w_com713_conciliacion_pvsf_rpt.create
int iCurrent
call super::create
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_descripcion
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.gb_2
end on

on w_com713_conciliacion_pvsf_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.gb_2)
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

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_mensaje, ls_nombre_origen
integer 	li_ok
date ld_fecha_ini, ld_fecha_fin

this.SetRedraw(false)

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
ls_origen	= em_origen.text

select nombre 
into :ls_nombre_origen
from origen
where cod_origen = :ls_origen;

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

idw_1.Retrieve(ls_origen, ld_fecha_ini, ld_fecha_fin)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_origen.text  = ls_nombre_origen
idw_1.Object.t_fecha1.text  = string(ld_fecha_ini)
idw_1.Object.t_fecha2.text  = string(ld_fecha_fin)
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
end event

type dw_report from w_rpt_general`dw_report within w_com713_conciliacion_pvsf_rpt
integer x = 155
integer y = 320
integer width = 3159
integer height = 1628
string dataobject = "d_rpt_factura_conciliacion_cpm"
end type

type em_descripcion from editmask within w_com713_conciliacion_pvsf_rpt
integer x = 1015
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

type em_origen from singlelineedit within w_com713_conciliacion_pvsf_rpt
event dobleclick pbm_lbuttondblclk
integer x = 873
integer y = 116
integer width = 128
integer height = 72
integer taborder = 20
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

type uo_fecha from u_ingreso_rango_fechas_v within w_com713_conciliacion_pvsf_rpt
integer x = 169
integer y = 56
integer taborder = 40
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

type pb_1 from picturebutton within w_com713_conciliacion_pvsf_rpt
integer x = 2793
integer y = 32
integer width = 425
integer height = 184
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
end type

event clicked;parent.event ue_retrieve()
end event

type gb_2 from groupbox within w_com713_conciliacion_pvsf_rpt
integer x = 832
integer y = 32
integer width = 910
integer height = 216
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

