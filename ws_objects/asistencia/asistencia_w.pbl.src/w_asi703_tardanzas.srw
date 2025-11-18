$PBExportHeader$w_asi703_tardanzas.srw
forward
global type w_asi703_tardanzas from w_rpt
end type
type sle_codigo from singlelineedit within w_asi703_tardanzas
end type
type cbx_trabajador from checkbox within w_asi703_tardanzas
end type
type st_5 from statictext within w_asi703_tardanzas
end type
type cb_1 from commandbutton within w_asi703_tardanzas
end type
type em_nombres from editmask within w_asi703_tardanzas
end type
type uo_1 from u_ingreso_rango_fechas within w_asi703_tardanzas
end type
type st_1 from statictext within w_asi703_tardanzas
end type
type st_3 from statictext within w_asi703_tardanzas
end type
type sle_ttrab from singlelineedit within w_asi703_tardanzas
end type
type sle_origen from singlelineedit within w_asi703_tardanzas
end type
type cb_2 from commandbutton within w_asi703_tardanzas
end type
type cb_5 from commandbutton within w_asi703_tardanzas
end type
type em_ttrab from editmask within w_asi703_tardanzas
end type
type em_origen from editmask within w_asi703_tardanzas
end type
type cbx_origen from checkbox within w_asi703_tardanzas
end type
type cbx_ttrab from checkbox within w_asi703_tardanzas
end type
type pb_1 from picturebutton within w_asi703_tardanzas
end type
type dw_report from u_dw_rpt within w_asi703_tardanzas
end type
type gb_4 from groupbox within w_asi703_tardanzas
end type
end forward

global type w_asi703_tardanzas from w_rpt
integer width = 4128
integer height = 2568
string title = "[ASI703] Reporte de Tardanzas"
string menuname = "m_reporte"
sle_codigo sle_codigo
cbx_trabajador cbx_trabajador
st_5 st_5
cb_1 cb_1
em_nombres em_nombres
uo_1 uo_1
st_1 st_1
st_3 st_3
sle_ttrab sle_ttrab
sle_origen sle_origen
cb_2 cb_2
cb_5 cb_5
em_ttrab em_ttrab
em_origen em_origen
cbx_origen cbx_origen
cbx_ttrab cbx_ttrab
pb_1 pb_1
dw_report dw_report
gb_4 gb_4
end type
global w_asi703_tardanzas w_asi703_tardanzas

on w_asi703_tardanzas.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_codigo=create sle_codigo
this.cbx_trabajador=create cbx_trabajador
this.st_5=create st_5
this.cb_1=create cb_1
this.em_nombres=create em_nombres
this.uo_1=create uo_1
this.st_1=create st_1
this.st_3=create st_3
this.sle_ttrab=create sle_ttrab
this.sle_origen=create sle_origen
this.cb_2=create cb_2
this.cb_5=create cb_5
this.em_ttrab=create em_ttrab
this.em_origen=create em_origen
this.cbx_origen=create cbx_origen
this.cbx_ttrab=create cbx_ttrab
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.cbx_trabajador
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_nombres
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.sle_ttrab
this.Control[iCurrent+10]=this.sle_origen
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_5
this.Control[iCurrent+13]=this.em_ttrab
this.Control[iCurrent+14]=this.em_origen
this.Control[iCurrent+15]=this.cbx_origen
this.Control[iCurrent+16]=this.cbx_ttrab
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.dw_report
this.Control[iCurrent+19]=this.gb_4
end on

on w_asi703_tardanzas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.cbx_trabajador)
destroy(this.st_5)
destroy(this.cb_1)
destroy(this.em_nombres)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.sle_ttrab)
destroy(this.sle_origen)
destroy(this.cb_2)
destroy(this.cb_5)
destroy(this.em_ttrab)
destroy(this.em_origen)
destroy(this.cbx_origen)
destroy(this.cbx_ttrab)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_4)
end on

event ue_open_pre;//Overrride

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 100

ib_preview = false
THIS.Event ue_preview()



 ii_help = 101           // help topic
end event

event ue_retrieve;call super::ue_retrieve;String ls_origen,ls_ttrab,ls_cod_trabajador
Long   ll_count
Date	 ld_fecha_inicio,ld_fecha_final	

ls_origen  			= sle_origen.text
ls_ttrab	  			= sle_ttrab.text
ls_cod_trabajador = sle_codigo.text

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

if cbx_origen.checked then
	ls_origen = '%'
else
	//debe colocar un dato
	if trim(sle_origen.text) = '' then
		Messagebox('Aviso','Debe indicar un origen valido, por favor verifique!', StopSign!)
		sle_origen.setFocus()
		Return
	end if
	
	ls_origen = trim(sle_origen.text) + '%'
end if

if cbx_ttrab.checked then
	ls_ttrab = '%'
else
	//debe colocar un dato
	if trim(sle_ttrab.text) = '' then
		Messagebox('Aviso','Debe indicar un Tipo de Trabajador valido, por favor verifique!', StopSign!)
		sle_ttrab.setFocus()
		Return
	end if
	
	ls_ttrab = trim(sle_ttrab.text) + '%'
end if

if cbx_trabajador.checked then
	ls_cod_trabajador = '%'
else
	//debe colocar un dato
	if trim(sle_codigo.text) = '' then
		Messagebox('Aviso','Debe indicar un Codigo de Trabajador valido, por favor verifique!', StopSign!)
		sle_codigo.setFocus()
		Return
	end if
	
	ls_cod_trabajador = trim(sle_codigo.text) + '%'
end if

idw_1.Retrieve(ls_origen, ls_ttrab, ls_cod_trabajador, ld_fecha_inicio, ld_fecha_final)
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.object.t_nombre.text 	= gs_empresa
idw_1.object.t_user.text 		= gs_user



this.SetRedraw(true)

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;
IF ib_preview THEN
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

type sle_codigo from singlelineedit within w_asi703_tardanzas
integer x = 379
integer y = 368
integer width = 343
integer height = 84
integer taborder = 90
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type cbx_trabajador from checkbox within w_asi703_tardanzas
integer x = 2048
integer y = 380
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_codigo.text = ''
	em_nombres.text  = ''
	sle_codigo.enabled = FALSE
else	
	sle_codigo.text = ''
	em_nombres.text  = ''
	sle_codigo.enabled = true
end if
end event

type st_5 from statictext within w_asi703_tardanzas
integer x = 32
integer y = 372
integer width = 338
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "C.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_asi703_tardanzas
integer x = 736
integer y = 368
integer width = 73
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_trabajador.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_rpt_seleccion_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2
	
	OpenWithParm( w_search, sl_param )
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_codigo.text = sl_param.field_ret[1]
		em_nombres.text = sl_param.field_ret[2]
	END IF
end if	

end event

type em_nombres from editmask within w_asi703_tardanzas
integer x = 823
integer y = 368
integer width = 1211
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type uo_1 from u_ingreso_rango_fechas within w_asi703_tardanzas
integer x = 73
integer y = 52
integer taborder = 20
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_1 from statictext within w_asi703_tardanzas
integer x = 32
integer y = 192
integer width = 338
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_asi703_tardanzas
integer x = 32
integer y = 288
integer width = 338
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trab. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ttrab from singlelineedit within w_asi703_tardanzas
integer x = 379
integer y = 276
integer width = 343
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_origen from singlelineedit within w_asi703_tardanzas
integer x = 379
integer y = 184
integer width = 343
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_asi703_tardanzas
integer x = 736
integer y = 180
integer width = 73
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_origen.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_seleccion_origen_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_origen, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_origen.text     = sl_param.field_ret[1]
		em_origen.text = sl_param.field_ret[2]
	END IF
	
end if
end event

type cb_5 from commandbutton within w_asi703_tardanzas
integer x = 736
integer y = 268
integer width = 73
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_ttrab.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_seleccion_tiptra_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_tiptra, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_ttrab.text    = sl_param.field_ret[1]
		em_ttrab.text = sl_param.field_ret[2]
	END IF
end if	

end event

type em_ttrab from editmask within w_asi703_tardanzas
integer x = 823
integer y = 276
integer width = 1211
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_asi703_tardanzas
integer x = 823
integer y = 184
integer width = 1211
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_origen from checkbox within w_asi703_tardanzas
integer x = 2048
integer y = 196
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_origen.text = ''
	sle_origen.enabled = FALSE
else	
	sle_origen.text = ''
	sle_origen.enabled = true
end if
end event

type cbx_ttrab from checkbox within w_asi703_tardanzas
integer x = 2048
integer y = 288
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_ttrab.text = ''
	em_ttrab.text  = ''
	sle_ttrab.enabled = FALSE
else	
	sle_ttrab.text = ''
	em_ttrab.text  = ''
	sle_ttrab.enabled = true
end if
end event

type pb_1 from picturebutton within w_asi703_tardanzas
integer x = 2729
integer y = 52
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_asi703_tardanzas
integer y = 488
integer width = 3730
integer height = 1384
string dataobject = "d_rpt_tardanzas_personal_tbl"
end type

type gb_4 from groupbox within w_asi703_tardanzas
integer width = 3150
integer height = 476
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

