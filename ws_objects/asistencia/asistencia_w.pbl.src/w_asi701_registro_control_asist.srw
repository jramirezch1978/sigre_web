$PBExportHeader$w_asi701_registro_control_asist.srw
forward
global type w_asi701_registro_control_asist from w_rpt
end type
type cbx_trabajador from checkbox within w_asi701_registro_control_asist
end type
type em_nom_trabajador from editmask within w_asi701_registro_control_asist
end type
type cb_trabajador from commandbutton within w_asi701_registro_control_asist
end type
type em_trabajador from editmask within w_asi701_registro_control_asist
end type
type st_1 from statictext within w_asi701_registro_control_asist
end type
type uo_fechas from u_ingreso_rango_fechas within w_asi701_registro_control_asist
end type
type cb_2 from commandbutton within w_asi701_registro_control_asist
end type
type cbx_todos_origenes from checkbox within w_asi701_registro_control_asist
end type
type em_desc_origen from editmask within w_asi701_registro_control_asist
end type
type cb_3 from commandbutton within w_asi701_registro_control_asist
end type
type em_origen from editmask within w_asi701_registro_control_asist
end type
type st_2 from statictext within w_asi701_registro_control_asist
end type
type st_3 from statictext within w_asi701_registro_control_asist
end type
type em_ttrab from editmask within w_asi701_registro_control_asist
end type
type em_desc_ttrab from editmask within w_asi701_registro_control_asist
end type
type cbx_todos_ttrab from checkbox within w_asi701_registro_control_asist
end type
type pb_1 from picturebutton within w_asi701_registro_control_asist
end type
type dw_report from u_dw_rpt within w_asi701_registro_control_asist
end type
type gb_2 from groupbox within w_asi701_registro_control_asist
end type
end forward

global type w_asi701_registro_control_asist from w_rpt
integer width = 4128
integer height = 2568
string title = "[ASI701] Registro de Control de Ingresos y Salidas"
string menuname = "m_reporte"
cbx_trabajador cbx_trabajador
em_nom_trabajador em_nom_trabajador
cb_trabajador cb_trabajador
em_trabajador em_trabajador
st_1 st_1
uo_fechas uo_fechas
cb_2 cb_2
cbx_todos_origenes cbx_todos_origenes
em_desc_origen em_desc_origen
cb_3 cb_3
em_origen em_origen
st_2 st_2
st_3 st_3
em_ttrab em_ttrab
em_desc_ttrab em_desc_ttrab
cbx_todos_ttrab cbx_todos_ttrab
pb_1 pb_1
dw_report dw_report
gb_2 gb_2
end type
global w_asi701_registro_control_asist w_asi701_registro_control_asist

on w_asi701_registro_control_asist.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_trabajador=create cbx_trabajador
this.em_nom_trabajador=create em_nom_trabajador
this.cb_trabajador=create cb_trabajador
this.em_trabajador=create em_trabajador
this.st_1=create st_1
this.uo_fechas=create uo_fechas
this.cb_2=create cb_2
this.cbx_todos_origenes=create cbx_todos_origenes
this.em_desc_origen=create em_desc_origen
this.cb_3=create cb_3
this.em_origen=create em_origen
this.st_2=create st_2
this.st_3=create st_3
this.em_ttrab=create em_ttrab
this.em_desc_ttrab=create em_desc_ttrab
this.cbx_todos_ttrab=create cbx_todos_ttrab
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_trabajador
this.Control[iCurrent+2]=this.em_nom_trabajador
this.Control[iCurrent+3]=this.cb_trabajador
this.Control[iCurrent+4]=this.em_trabajador
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.uo_fechas
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cbx_todos_origenes
this.Control[iCurrent+9]=this.em_desc_origen
this.Control[iCurrent+10]=this.cb_3
this.Control[iCurrent+11]=this.em_origen
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.em_ttrab
this.Control[iCurrent+15]=this.em_desc_ttrab
this.Control[iCurrent+16]=this.cbx_todos_ttrab
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.dw_report
this.Control[iCurrent+19]=this.gb_2
end on

on w_asi701_registro_control_asist.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_trabajador)
destroy(this.em_nom_trabajador)
destroy(this.cb_trabajador)
destroy(this.em_trabajador)
destroy(this.st_1)
destroy(this.uo_fechas)
destroy(this.cb_2)
destroy(this.cbx_todos_origenes)
destroy(this.em_desc_origen)
destroy(this.cb_3)
destroy(this.em_origen)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_ttrab)
destroy(this.em_desc_ttrab)
destroy(this.cbx_todos_ttrab)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_2)
end on

event ue_open_pre;//Overrride

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
ib_preview = false
THIS.Event ue_preview()



 ii_help = 101           // help topic
end event

event ue_retrieve;call super::ue_retrieve;Date   ld_fecha1, ld_fecha2
String ls_tip_trab,ls_origen,ls_empresa,ls_nom_empresa,ls_ruc, ls_trabajador

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

ls_tip_trab		= trim(em_ttrab.text)
ls_origen		= trim(em_origen.text)
ls_trabajador 	= trim(em_trabajador.text)

if ls_tip_trab = 'JOR' then
	idw_1.DataObject = 'd_rpt_asistencia_jor_tbl'
elseif ls_tip_trab = 'DES' then
	if upper(gs_empresa) = 'ARCOPA' then
		idw_1.DataObject = 'd_rpt_asistencia_des_arcopa_tbl'	
	else
		idw_1.DataObject = 'd_rpt_asistencia_des_tbl'	
	end if
else
	idw_1.DataObject = 'd_report_asistencia_tbl'
end if

idw_1.setTransObject(SQLCA)

if cbx_todos_origenes.checked then
	ls_origen = '%'
else
	if Isnull(ls_origen) or Trim(ls_origen) = '' then
		Messagebox('Aviso','Debe Ingresar Origen a Recuperar ,Verifique!', StopSign!)
		Return
	end if
	
	ls_origen += '%'
end if	


if cbx_todos_ttrab.checked then
	ls_tip_trab = '%'
else
	if Isnull(ls_tip_trab) or Trim(ls_tip_trab) = '' then
		Messagebox('Aviso','Debe Ingresar Tipo de Trabajador, Verifique!', StopSign!)
		Return
	end if
	ls_tip_trab += '%'
end if	

if cbx_trabajador.checked then
	ls_trabajador = '%'
else
	if Isnull(ls_trabajador) or Trim(ls_trabajador) = '' then
		Messagebox('Aviso','Debe seleccionar un trabajador, por favor Verifique!', StopSign!)
		Return
	end if
	ls_trabajador += '%'
end if	
	
this.SetRedraw(false)

select cod_empresa
  into :ls_empresa
  from genparam
 where reckey = '1';

Select nombre, ruc 
	into :ls_nom_empresa, :ls_ruc
from empresa
where cod_empresa = :ls_empresa;

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc



idw_1.Retrieve(ls_origen, ls_tip_trab, ls_trabajador, ld_fecha1, ld_fecha2)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.Datawindow.Print.Orientation = '1'

idw_1.Object.p_logo.filename  = gs_logo
idw_1.object.t_direccion.text = f_direccion_empresa(gs_origen)
idw_1.object.t_ruc.text 		= ls_ruc
idw_1.object.t_empresa.text	= ls_nom_empresa
idw_1.object.t_nombre.text		= gs_empresa


this.SetRedraw(true)
		

idw_1.ii_zoom_actual = 100
ib_preview = false
THIS.Event ue_preview()
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

type cbx_trabajador from checkbox within w_asi701_registro_control_asist
integer x = 2199
integer y = 316
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
boolean checked = true
end type

event clicked;
if this.checked then
	em_trabajador.enabled = false
	cb_trabajador.enabled = false
else
	em_trabajador.enabled = true
	cb_trabajador.enabled = true
end if
end event

type em_nom_trabajador from editmask within w_asi701_registro_control_asist
integer x = 923
integer y = 316
integer width = 1202
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_trabajador from commandbutton within w_asi701_registro_control_asist
integer x = 827
integer y = 312
integer width = 87
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_origen, ls_tipo_trabaj, ls_codigo, ls_data

if cbx_todos_origenes.checked then
	ls_origen = '%'
else
	if trim(em_origen.text) = '' then
		MessageBox('Error', 'Debe Elegir un origen primero, Por favor verifique!', StopSign!)
		em_origen.setFocus()
		return
	end if
	ls_origen = trim(em_origen.text) + '%'
end if

if cbx_todos_ttrab.checked then
	ls_tipo_trabaj = '%'
else
	if trim(em_ttrab.text) = '' then
		MessageBox('Error', 'Debe Elegir un tipo de Trabajador primero, Por favor verifique!', StopSign!)
		em_ttrab.setFocus()
		return
	end if
	ls_tipo_trabaj = trim(em_ttrab.text) + '%'
end if


ls_sql = "select m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "       m.NOM_TRABAJADOR as nombre_trabajador, " &
		 + "       m.NRO_DOC_IDENT_RTPS as dni " &
		 + "from vw_pr_trabajador m " &
		 + "where m.cod_origen like '" + ls_origen + "'" &
		 + "  and m.TIPO_TRABAJADOR like '" + ls_tipo_trabaj + "' " &
		 + "order by m.nom_trabajador"

if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
	em_trabajador.text		= ls_codigo
	em_nom_trabajador.text 	= ls_data
end if

end event

type em_trabajador from editmask within w_asi701_registro_control_asist
integer x = 471
integer y = 312
integer width = 338
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_asi701_registro_control_asist
integer x = 23
integer y = 312
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_asi701_registro_control_asist
event destroy ( )
integer x = 41
integer y = 60
integer taborder = 20
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cb_2 from commandbutton within w_asi701_registro_control_asist
integer x = 827
integer y = 236
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text      = sl_param.field_ret[1]
	em_desc_ttrab.text = sl_param.field_ret[2]
END IF

end event

type cbx_todos_origenes from checkbox within w_asi701_registro_control_asist
integer x = 2199
integer y = 160
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;
if this.checked then
	em_origen.enabled = false
else
	em_origen.enabled = true
end if
end event

type em_desc_origen from editmask within w_asi701_registro_control_asist
integer x = 923
integer y = 160
integer width = 1202
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_asi701_registro_control_asist
integer x = 827
integer y = 160
integer width = 87
integer height = 72
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

event clicked;// Abre ventana de ayuda 
String	ls_origen
str_parametros lstr_param

ls_origen = em_origen.text

lstr_param.dw1 				= "d_rpt_select_codigo_todos_tbl"
lstr_param.titulo 			= "Seleccionar Búsqueda"
lstr_param.field_ret_i[1] 	= 1
lstr_param.field_ret_i[2] 	= 2
lstr_param.string1 		  	= ls_origen
lstr_param.tipo			  	= '1S'

OpenWithParm( w_search, lstr_param)		
lstr_param = MESSAGE.POWEROBJECTPARM
IF lstr_param.titulo <> 'n' THEN
	em_trabajador.text  		= lstr_param.field_ret[1]
	em_nom_trabajador.text 	= lstr_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_asi701_registro_control_asist
integer x = 471
integer y = 160
integer width = 338
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_2 from statictext within w_asi701_registro_control_asist
integer x = 23
integer y = 168
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_asi701_registro_control_asist
integer x = 23
integer y = 244
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ttrab from editmask within w_asi701_registro_control_asist
integer x = 471
integer y = 236
integer width = 338
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_ttrab from editmask within w_asi701_registro_control_asist
integer x = 923
integer y = 236
integer width = 1202
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_todos_ttrab from checkbox within w_asi701_registro_control_asist
boolean visible = false
integer x = 2199
integer y = 236
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
boolean enabled = false
string text = "Todos"
end type

event clicked;
if this.checked then
	em_ttrab.enabled = false
else
	em_ttrab.enabled = true
end if
end event

type pb_1 from picturebutton within w_asi701_registro_control_asist
integer x = 2670
integer y = 56
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
boolean map3dcolors = true
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_asi701_registro_control_asist
integer y = 420
integer width = 3730
integer height = 1328
string dataobject = "d_report_asistencia_tbl"
end type

type gb_2 from groupbox within w_asi701_registro_control_asist
integer width = 3589
integer height = 416
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Busqueda"
end type

