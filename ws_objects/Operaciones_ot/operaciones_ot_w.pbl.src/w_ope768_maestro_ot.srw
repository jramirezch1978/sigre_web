$PBExportHeader$w_ope768_maestro_ot.srw
forward
global type w_ope768_maestro_ot from w_report_smpl
end type
type sle_descrip from singlelineedit within w_ope768_maestro_ot
end type
type cbx_ot_adm from checkbox within w_ope768_maestro_ot
end type
type cbx_almacen from checkbox within w_ope768_maestro_ot
end type
type cbx_origenes from checkbox within w_ope768_maestro_ot
end type
type pb_reporte from picturebutton within w_ope768_maestro_ot
end type
type sle_descrip_ot_adm from singlelineedit within w_ope768_maestro_ot
end type
type sle_almacen from singlelineedit within w_ope768_maestro_ot
end type
type em_ot_adm from singlelineedit within w_ope768_maestro_ot
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ope768_maestro_ot
end type
type em_origen from singlelineedit within w_ope768_maestro_ot
end type
type em_descripcion from editmask within w_ope768_maestro_ot
end type
type gb_2 from groupbox within w_ope768_maestro_ot
end type
type gb_1 from groupbox within w_ope768_maestro_ot
end type
type gb_3 from groupbox within w_ope768_maestro_ot
end type
type gb_4 from groupbox within w_ope768_maestro_ot
end type
end forward

global type w_ope768_maestro_ot from w_report_smpl
integer width = 5125
integer height = 2264
string title = "[OPE768] Listado de Ordenes de Trabajo"
string menuname = "m_impresion"
sle_descrip sle_descrip
cbx_ot_adm cbx_ot_adm
cbx_almacen cbx_almacen
cbx_origenes cbx_origenes
pb_reporte pb_reporte
sle_descrip_ot_adm sle_descrip_ot_adm
sle_almacen sle_almacen
em_ot_adm em_ot_adm
uo_fecha uo_fecha
em_origen em_origen
em_descripcion em_descripcion
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
end type
global w_ope768_maestro_ot w_ope768_maestro_ot

on w_ope768_maestro_ot.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_descrip=create sle_descrip
this.cbx_ot_adm=create cbx_ot_adm
this.cbx_almacen=create cbx_almacen
this.cbx_origenes=create cbx_origenes
this.pb_reporte=create pb_reporte
this.sle_descrip_ot_adm=create sle_descrip_ot_adm
this.sle_almacen=create sle_almacen
this.em_ot_adm=create em_ot_adm
this.uo_fecha=create uo_fecha
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_descrip
this.Control[iCurrent+2]=this.cbx_ot_adm
this.Control[iCurrent+3]=this.cbx_almacen
this.Control[iCurrent+4]=this.cbx_origenes
this.Control[iCurrent+5]=this.pb_reporte
this.Control[iCurrent+6]=this.sle_descrip_ot_adm
this.Control[iCurrent+7]=this.sle_almacen
this.Control[iCurrent+8]=this.em_ot_adm
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.em_origen
this.Control[iCurrent+11]=this.em_descripcion
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_4
end on

on w_ope768_maestro_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_descrip)
destroy(this.cbx_ot_adm)
destroy(this.cbx_almacen)
destroy(this.cbx_origenes)
destroy(this.pb_reporte)
destroy(this.sle_descrip_ot_adm)
destroy(this.sle_almacen)
destroy(this.em_ot_adm)
destroy(this.uo_fecha)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_mensaje, ls_nombre_origen, ls_ot_adm, &
			ls_almacen
integer 	li_ok
date ld_fecha_ini, ld_fecha_fin

this.SetRedraw(false)

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

if cbx_origenes.checked then
	ls_origen		= "%%"
else
	if trim(em_origen.text) = "" then
		gnvo_app.of_mensaje_error('Debe indicar un origen')
		em_origen.setfocus( )
		return
	end if
	
	ls_origen		= em_origen.text + "%"
end if

if cbx_ot_adm.checked then
	ls_ot_adm	 	= "%%"
else
	if trim(em_ot_adm.text) = "" then
		gnvo_app.of_mensaje_error('Debe indicar un OT_ADM')
		em_ot_adm.setfocus( )
		return
	end if
	ls_ot_adm	 	= em_ot_adm.text + "%"
end if

if cbx_almacen.checked then
	ls_almacen		= "%%"
else
	if trim(sle_almacen.text) = "" then
		gnvo_app.of_mensaje_error('Debe indicar un almacen')
		sle_almacen.setfocus( )
		return
	end if
	ls_almacen		= sle_almacen.text + "%"
end if


idw_1.Retrieve(ls_ot_adm, ls_almacen, ls_origen, ld_fecha_ini, ld_fecha_fin)
idw_1.Visible = True
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_user.text  		= gs_user
idw_1.Object.t_stitulo1.text  = 'DESDE: ' + string(ld_fecha_ini) + ' HASTA ' + string(ld_fecha_fin)
//idw_1.Object.Datawindow.Print.Orientation = '1'
this.SetRedraw(true)
end event

type dw_report from w_report_smpl`dw_report within w_ope768_maestro_ot
integer x = 0
integer y = 324
integer width = 3525
integer height = 1640
string dataobject = "d_rpt_maestro_ot_tbl"
end type

type sle_descrip from singlelineedit within w_ope768_maestro_ot
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

type cbx_ot_adm from checkbox within w_ope768_maestro_ot
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
string text = "Todos los OT ADM"
boolean checked = true
end type

event clicked;if this.checked then
	em_ot_adm.enabled = false
else
	em_ot_adm.enabled = true
end if
end event

type cbx_almacen from checkbox within w_ope768_maestro_ot
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

type cbx_origenes from checkbox within w_ope768_maestro_ot
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
	em_origen.enabled = false
else
	em_origen.enabled = true
end if
end event

type pb_reporte from picturebutton within w_ope768_maestro_ot
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

type sle_descrip_ot_adm from singlelineedit within w_ope768_maestro_ot
integer x = 3241
integer y = 160
integer width = 873
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

type sle_almacen from singlelineedit within w_ope768_maestro_ot
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

type em_ot_adm from singlelineedit within w_ope768_maestro_ot
event dobleclick pbm_lbuttondblclk
integer x = 3013
integer y = 160
integer width = 215
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

ls_sql = "SELECT O.OT_ADM AS CODIGO, O.DESCRIPCION AS DESCRIPCION " &
			+ "FROM OT_ADMINISTRACION O"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

sle_descrip_ot_adm.text = ls_data

end if
end event

event modified;String ls_almacen, ls_desc

ls_almacen = trim(this.text)
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	sle_descrip_ot_adm.text = ''
	return
end if

SELECT descripcion INTO :ls_desc
FROM ot_administracion
WHERE ot_adm =:ls_almacen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM ' + ls_almacen + ' no existe')
	sle_descrip_ot_adm.text = ''
	this.text = ''
	this.setFocus( )
	return
end if

sle_descrip_ot_adm.text = ls_desc


end event

type uo_fecha from u_ingreso_rango_fechas_v within w_ope768_maestro_ot
integer x = 27
integer y = 60
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

type em_origen from singlelineedit within w_ope768_maestro_ot
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

type em_descripcion from editmask within w_ope768_maestro_ot
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

type gb_2 from groupbox within w_ope768_maestro_ot
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

type gb_1 from groupbox within w_ope768_maestro_ot
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

type gb_3 from groupbox within w_ope768_maestro_ot
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
string text = "OT. Administración"
end type

type gb_4 from groupbox within w_ope768_maestro_ot
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

