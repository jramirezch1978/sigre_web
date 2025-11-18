$PBExportHeader$w_al751_req_ot_pendientes_retiro.srw
forward
global type w_al751_req_ot_pendientes_retiro from w_report_smpl
end type
type sle_descrip from singlelineedit within w_al751_req_ot_pendientes_retiro
end type
type cbx_ot from checkbox within w_al751_req_ot_pendientes_retiro
end type
type cbx_almacen from checkbox within w_al751_req_ot_pendientes_retiro
end type
type cbx_origenes from checkbox within w_al751_req_ot_pendientes_retiro
end type
type pb_reporte from picturebutton within w_al751_req_ot_pendientes_retiro
end type
type sle_titulo_ot from singlelineedit within w_al751_req_ot_pendientes_retiro
end type
type sle_almacen from singlelineedit within w_al751_req_ot_pendientes_retiro
end type
type sle_nro_ot from singlelineedit within w_al751_req_ot_pendientes_retiro
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al751_req_ot_pendientes_retiro
end type
type sle_origen from singlelineedit within w_al751_req_ot_pendientes_retiro
end type
type em_descripcion from editmask within w_al751_req_ot_pendientes_retiro
end type
type gb_2 from groupbox within w_al751_req_ot_pendientes_retiro
end type
type gb_1 from groupbox within w_al751_req_ot_pendientes_retiro
end type
type gb_3 from groupbox within w_al751_req_ot_pendientes_retiro
end type
type gb_4 from groupbox within w_al751_req_ot_pendientes_retiro
end type
end forward

global type w_al751_req_ot_pendientes_retiro from w_report_smpl
integer width = 5271
integer height = 1740
string title = "[AL751] Requerimientos de OT pendientes de Salida"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
sle_descrip sle_descrip
cbx_ot cbx_ot
cbx_almacen cbx_almacen
cbx_origenes cbx_origenes
pb_reporte pb_reporte
sle_titulo_ot sle_titulo_ot
sle_almacen sle_almacen
sle_nro_ot sle_nro_ot
uo_fecha uo_fecha
sle_origen sle_origen
em_descripcion em_descripcion
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
end type
global w_al751_req_ot_pendientes_retiro w_al751_req_ot_pendientes_retiro

type variables
string is_clase, is_almacen
integer ii_opc2, ii_opc1
date id_fecha1, id_fecha2
end variables

forward prototypes
public subroutine of_procesar ()
end prototypes

public subroutine of_procesar ();

end subroutine

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al751_req_ot_pendientes_retiro.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_descrip=create sle_descrip
this.cbx_ot=create cbx_ot
this.cbx_almacen=create cbx_almacen
this.cbx_origenes=create cbx_origenes
this.pb_reporte=create pb_reporte
this.sle_titulo_ot=create sle_titulo_ot
this.sle_almacen=create sle_almacen
this.sle_nro_ot=create sle_nro_ot
this.uo_fecha=create uo_fecha
this.sle_origen=create sle_origen
this.em_descripcion=create em_descripcion
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_descrip
this.Control[iCurrent+2]=this.cbx_ot
this.Control[iCurrent+3]=this.cbx_almacen
this.Control[iCurrent+4]=this.cbx_origenes
this.Control[iCurrent+5]=this.pb_reporte
this.Control[iCurrent+6]=this.sle_titulo_ot
this.Control[iCurrent+7]=this.sle_almacen
this.Control[iCurrent+8]=this.sle_nro_ot
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.sle_origen
this.Control[iCurrent+11]=this.em_descripcion
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_4
end on

on w_al751_req_ot_pendientes_retiro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_descrip)
destroy(this.cbx_ot)
destroy(this.cbx_almacen)
destroy(this.cbx_origenes)
destroy(this.pb_reporte)
destroy(this.sle_titulo_ot)
destroy(this.sle_almacen)
destroy(this.sle_nro_ot)
destroy(this.uo_fecha)
destroy(this.sle_origen)
destroy(this.em_descripcion)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje, ls_origen, ls_nro_ot, ls_almacen
Date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()

if cbx_origenes.checked then
	ls_origen = '%%'
else
	if trim(sle_origen.text) = '' then
		gnvo_app.of_message_error('Debe ingresar un codigo de Origen, por favor verifique!')
		sle_origen.SetFocus()
		return
	end if
	ls_origen = trim(sle_origen.text) + '%'
end if

if cbx_almacen.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		gnvo_app.of_message_error('Debe ingresar un codigo de almacen, por favor verifique!')
		sle_almacen.SetFocus()
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if cbx_ot.checked then
	ls_nro_ot = '%%'
else
	if trim(sle_nro_ot.text) = '' then
		gnvo_app.of_message_error('Debe ingresar un codigo de almacen, por favor verifique!')
		sle_nro_ot.SetFocus()
		return
	end if
	ls_nro_ot = trim(sle_nro_ot.text) + '%'
end if

ib_preview=true
this.event ue_preview()

dw_report.visible = true
dw_report.SetTransObject(sqlca)
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_almacen, ls_origen, ls_nro_ot)

dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.of_set_subtitulo( 1, "Nro de Registros " + string(dw_report.RowCount()))

dw_report.Object.p_logo.filename 	= gs_logo
dw_report.Object.t_user.text  		= gs_user
dw_report.Object.t_ventana.text  	= this.ClassName()








	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al751_req_ot_pendientes_retiro
integer x = 0
integer y = 316
integer width = 3753
integer height = 988
string dataobject = "d_rpt_pendientes_atencion_ot_tbl"
end type

type sle_descrip from singlelineedit within w_al751_req_ot_pendientes_retiro
integer x = 2094
integer y = 160
integer width = 873
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_ot from checkbox within w_al751_req_ot_pendientes_retiro
integer x = 3026
integer y = 64
integer width = 1056
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos las Ordenes de Trabajo"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nro_ot.enabled = false
else
	sle_nro_ot.enabled = true
end if
end event

type cbx_almacen from checkbox within w_al751_req_ot_pendientes_retiro
integer x = 1874
integer y = 64
integer width = 1056
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type cbx_origenes from checkbox within w_al751_req_ot_pendientes_retiro
integer x = 736
integer y = 64
integer width = 1056
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos los orígenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
else
	sle_origen.enabled = true
end if
end event

type pb_reporte from picturebutton within w_al751_req_ot_pendientes_retiro
integer x = 4146
integer y = 72
integer width = 366
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
ib_preview = false
parent.event ue_preview( )
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_titulo_ot from singlelineedit within w_al751_req_ot_pendientes_retiro
integer x = 3360
integer y = 160
integer width = 745
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_al751_req_ot_pendientes_retiro
event dobleclick pbm_lbuttondblclk
integer x = 1865
integer y = 160
integer width = 224
integer height = 88
integer taborder = 30
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
textcase textcase = upper!
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
	Parent.event dynamic ue_seleccionar()
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


end event

type sle_nro_ot from singlelineedit within w_al751_req_ot_pendientes_retiro
event dobleclick pbm_lbuttondblclk
integer x = 3013
integer y = 160
integer width = 347
integer height = 88
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
boolean enabled = false
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select nro_orden as numero_ot," &
		 + "titulo as titulo_ot, " &
		 + "ot_adm as ot_adm " &
		 + "from orden_Trabajo " &
		 + "where flag_estado <> '0'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

sle_titulo_ot.text = ls_data

end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = trim(this.text)
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un numero de OT')
	sle_titulo_ot.text = ''
	return
end if

SELECT titulo 
	INTO :ls_desc
FROM orden_trabajo
WHERE nro_orden =:ls_codigo
  and flag_estado <> '0';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Orden de Trabajo ' + ls_codigo + ' no existe o no se encuentra activo, por favor verifique!')
	sle_titulo_ot.text = ''
	this.text = ''
	this.setFocus( )
	return
end if

sle_titulo_ot.text = ls_desc


end event

type uo_fecha from u_ingreso_rango_fechas_v within w_al751_req_ot_pendientes_retiro
event destroy ( )
integer x = 27
integer y = 60
integer taborder = 70
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type sle_origen from singlelineedit within w_al751_req_ot_pendientes_retiro
event dobleclick pbm_lbuttondblclk
integer x = 741
integer y = 160
integer width = 215
integer height = 88
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
boolean enabled = false
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

type em_descripcion from editmask within w_al751_req_ot_pendientes_retiro
integer x = 960
integer y = 160
integer width = 841
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_2 from groupbox within w_al751_req_ot_pendientes_retiro
integer x = 699
integer width = 1143
integer height = 308
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_al751_req_ot_pendientes_retiro
integer width = 681
integer height = 308
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_3 from groupbox within w_al751_req_ot_pendientes_retiro
integer x = 2994
integer width = 1143
integer height = 308
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Orden de Trabajo"
end type

type gb_4 from groupbox within w_al751_req_ot_pendientes_retiro
integer x = 1847
integer width = 1143
integer height = 308
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacèn"
end type

