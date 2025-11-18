$PBExportHeader$w_pr721_dias_laborados.srw
forward
global type w_pr721_dias_laborados from w_rpt
end type
type cbx_ot_adm from checkbox within w_pr721_dias_laborados
end type
type st_1 from statictext within w_pr721_dias_laborados
end type
type sle_nombre from singlelineedit within w_pr721_dias_laborados
end type
type sle_codigo from singlelineedit within w_pr721_dias_laborados
end type
type pb_1 from picturebutton within w_pr721_dias_laborados
end type
type em_tipo_t from editmask within w_pr721_dias_laborados
end type
type em_tipo from singlelineedit within w_pr721_dias_laborados
end type
type uo_fecha from ou_rango_fechas within w_pr721_dias_laborados
end type
type em_ot_adm from singlelineedit within w_pr721_dias_laborados
end type
type em_descripcion from singlelineedit within w_pr721_dias_laborados
end type
type dw_report from u_dw_rpt within w_pr721_dias_laborados
end type
type gb_1 from groupbox within w_pr721_dias_laborados
end type
type gb_2 from groupbox within w_pr721_dias_laborados
end type
type gb_3 from groupbox within w_pr721_dias_laborados
end type
type gb_4 from groupbox within w_pr721_dias_laborados
end type
end forward

global type w_pr721_dias_laborados from w_rpt
integer width = 4366
integer height = 1876
string title = "Reporte de Dias Laborados(PR721)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
cbx_ot_adm cbx_ot_adm
st_1 st_1
sle_nombre sle_nombre
sle_codigo sle_codigo
pb_1 pb_1
em_tipo_t em_tipo_t
em_tipo em_tipo
uo_fecha uo_fecha
em_ot_adm em_ot_adm
em_descripcion em_descripcion
dw_report dw_report
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_pr721_dias_laborados w_pr721_dias_laborados

event ue_query_retrieve();// Ancestor Script has been Override

SetPointer(HourGlass!)
this.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

on w_pr721_dias_laborados.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_ot_adm=create cbx_ot_adm
this.st_1=create st_1
this.sle_nombre=create sle_nombre
this.sle_codigo=create sle_codigo
this.pb_1=create pb_1
this.em_tipo_t=create em_tipo_t
this.em_tipo=create em_tipo
this.uo_fecha=create uo_fecha
this.em_ot_adm=create em_ot_adm
this.em_descripcion=create em_descripcion
this.dw_report=create dw_report
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_ot_adm
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_nombre
this.Control[iCurrent+4]=this.sle_codigo
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.em_tipo_t
this.Control[iCurrent+7]=this.em_tipo
this.Control[iCurrent+8]=this.uo_fecha
this.Control[iCurrent+9]=this.em_ot_adm
this.Control[iCurrent+10]=this.em_descripcion
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_4
end on

on w_pr721_dias_laborados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_ot_adm)
destroy(this.st_1)
destroy(this.sle_nombre)
destroy(this.sle_codigo)
destroy(this.pb_1)
destroy(this.em_tipo_t)
destroy(this.em_tipo)
destroy(this.uo_fecha)
destroy(this.em_ot_adm)
destroy(this.em_descripcion)
destroy(this.dw_report)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
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

event ue_retrieve;call super::ue_retrieve;string 	ls_ot_adm, ls_tipo, ls_cod_trabajador, ls_origen
integer 	li_ok
date 		ld_fecha_ini, ld_fecha_fin

ls_tipo      = em_tipo.text

if ls_tipo = '' or IsNull( ls_tipo) then
	MessageBox('Producción', 'El Tipo de Trabajador no ha sido Definido', StopSign!)
	return
end if

if LEN(sle_codigo.text) <> 0  and ls_tipo = 'JOR' THEN
	
	ls_cod_trabajador 	= 	string(sle_codigo.text)
	
	this.SetRedraw(false)

		ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
		ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
		idw_1.dataobject 		= 	'd_rpt_dias_laborados_tbl_1'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ls_cod_trabajador, ld_fecha_ini, ld_fecha_fin)
		idw_1.Visible = True
		idw_1.Object.p_logo.filename = gs_logo
		idw_1.Object.usuario_t.text  = gs_user
		idw_1.Object.t_fecha1.text   = string(ld_fecha_ini)
		idw_1.Object.t_fecha2.text   = string(ld_fecha_fin)
		idw_1.Object.Datawindow.Print.Orientation = '1'
		this.SetRedraw(true)

	elseIF LEN(sle_codigo.text) <> 0  and ls_tipo = 'DES' THEN
		
		ls_cod_trabajador 	= 	string(sle_codigo.text)
	
		this.SetRedraw(false)

		ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
		ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
		//idw_1.dataobject	= 'd_rpt_dias_personal_tbl_tt'
		idw_1.dataobject 		= 	'd_rpt_dias_destajo_lab_tbl_1'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_cod_trabajador)
		idw_1.Visible = True
		idw_1.Object.p_logo.filename = gs_logo
		idw_1.Object.usuario_t.text  = gs_user
		idw_1.Object.t_fecha1.text   = string(ld_fecha_ini)
		idw_1.Object.t_fecha2.text   = string(ld_fecha_fin)
		idw_1.Object.Datawindow.Print.Orientation = '1'
		this.SetRedraw(true)

		
else
	
		this.SetRedraw(false)

		ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
		ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
		ls_ot_adm	 = em_ot_adm.text
		ls_tipo      = em_tipo.text
		
				
		if cbx_ot_adm.checked = true then
			ls_ot_adm	= '%%'
		else
			ls_ot_adm	 = em_ot_adm.text
		end if
		
		if ls_ot_adm = '' or IsNull( ls_ot_adm) then
			MessageBox('Producción', 'La OT_ADM no ha sido Definica', StopSign!)
			return
		end if
		
		if ls_tipo = '' or IsNull( ls_tipo) then
			MessageBox('Producción', 'El Tipo de Trabajador no ha sido Definido', StopSign!)
			return
		end if
					
		IF ls_tipo = 'DES' THEN
			
		idw_1.dataobject 		= 	'd_rpt_dias_destajo_lab_tbl'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_tipo, ls_ot_adm)
		idw_1.Visible = True
		idw_1.Object.p_logo.filename = gs_logo
		idw_1.Object.usuario_t.text  = gs_user
		idw_1.Object.t_fecha1.text   = string(ld_fecha_ini)
		idw_1.Object.t_fecha2.text   = string(ld_fecha_fin)
		idw_1.Object.Datawindow.Print.Orientation = '1'
		this.SetRedraw(true)
		
		ELSE
			
		idw_1.dataobject 		= 	'd_rpt_dias_laborados_tbl'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ls_tipo, ls_ot_adm, ld_fecha_ini, ld_fecha_fin)
		idw_1.Visible = True
		idw_1.Object.p_logo.filename = gs_logo
		idw_1.Object.usuario_t.text  = gs_user
		idw_1.Object.t_fecha1.text   = string(ld_fecha_ini)
		idw_1.Object.t_fecha2.text   = string(ld_fecha_fin)
		idw_1.Object.Datawindow.Print.Orientation = '1'
		this.SetRedraw(true)
		END IF
end if
end event

type cbx_ot_adm from checkbox within w_pr721_dias_laborados
integer x = 1303
integer y = 116
integer width = 91
integer height = 80
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
	
	em_ot_adm.enabled = false
	em_ot_adm.text = '' 
	
else
	
	em_ot_adm.enabled = true

end if
end event

type st_1 from statictext within w_pr721_dias_laborados
integer x = 41
integer y = 260
integer width = 626
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte por Trabajador"
boolean focusrectangle = false
end type

type sle_nombre from singlelineedit within w_pr721_dias_laborados
integer x = 379
integer y = 392
integer width = 1106
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_pr721_dias_laborados
event dobleclick pbm_lbuttondblclk
integer x = 64
integer y = 392
integer width = 293
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
long textcolor = 134217746
long backcolor = 33554431
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen

ls_sql = "SELECT  cod_trabajador as codigo, " & 
		 + " apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2 AS TRABAJADOR " &
		 + "FROM maestro " &
	  	 + "WHERE flag_estado = '1' "

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

event modified;String 	ls_cod_t, ls_nombre

ls_cod_t = this.text
if ls_cod_t = '' or IsNull(ls_cod_t) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Trabajador')
	sle_nombre.text = ''
	return
end if

SELECT apel_paterno||' '||apel_materno||' '||nombre1||' '||nombre2
	INTO :ls_nombre
FROM maestro
WHERE cod_trabajador = :ls_cod_t;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Trabajador no existe')
	sle_nombre.text = ''
	return
end if

sle_nombre.text = ls_nombre
end event

type pb_1 from picturebutton within w_pr721_dias_laborados
integer x = 3794
integer y = 60
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

type em_tipo_t from editmask within w_pr721_dias_laborados
integer x = 2866
integer y = 116
integer width = 859
integer height = 76
integer taborder = 80
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

type em_tipo from singlelineedit within w_pr721_dias_laborados
event dobleclick pbm_lbuttondblclk
integer x = 2734
integer y = 116
integer width = 128
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
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  TIPO_TRABAJADOR as CODIGO, " & 
		  +"DESC_TIPO_TRA AS DESCRIPCION " &
		  + "FROM tipo_trabajador " &
		  + "WHERE FLAG_ESTADO = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = upper(ls_codigo)
	em_tipo_t.text = upper(ls_data)
end if


end event

event modified;String 	ls_tipo_traba, ls_desc_t

ls_tipo_traba = trim(this.text)

if ls_tipo_traba = '' or IsNull(ls_tipo_traba) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Trabajador')
	em_tipo_t.text = ''
	return
end if

SELECT desc_tipo_tra
	INTO :ls_desc_t
FROM tipo_trabajador
WHERE tipo_trabajador = :ls_tipo_Traba;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Tipo de Trabajador no existe')
	em_tipo_t.text = ''
	return
end if

em_tipo_t.text = ls_desc_t
end event

type uo_fecha from ou_rango_fechas within w_pr721_dias_laborados
event destroy ( )
integer x = 32
integer y = 116
integer taborder = 60
boolean bringtotop = true
end type

on uo_fecha.destroy
call ou_rango_fechas::destroy
end on

type em_ot_adm from singlelineedit within w_pr721_dias_laborados
event dobleclick pbm_lbuttondblclk
integer x = 1467
integer y = 120
integer width = 219
integer height = 68
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
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM, O.DESCRIPCION AS DESCRIPCION," &
				  + "P.COD_USR AS USUARIO " &
				  + "FROM OT_ADMINISTRACION O, OT_ADM_USUARIO P " &
				  + "WHERE O.OT_ADM = P.OT_ADM " &
				  + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

em_descripcion.text = ls_data

end if
end event

event modified;String ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT descripcion INTO :ls_desc
FROM ot_administracion
WHERE ot_adm =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe')
	em_descripcion.text = ''
	return
end if

em_descripcion.text = ls_desc


end event

type em_descripcion from singlelineedit within w_pr721_dias_laborados
integer x = 1696
integer y = 120
integer width = 969
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
string text = " "
borderstyle borderstyle = stylelowered!
end type

type dw_report from u_dw_rpt within w_pr721_dias_laborados
integer x = 23
integer y = 536
integer width = 3730
integer height = 1140
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_pr721_dias_laborados
integer x = 1225
integer y = 56
integer width = 1477
integer height = 168
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todas   OT. Administración"
end type

type gb_2 from groupbox within w_pr721_dias_laborados
integer x = 23
integer y = 56
integer width = 1175
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione rango de fechas"
end type

type gb_3 from groupbox within w_pr721_dias_laborados
integer x = 2706
integer y = 56
integer width = 1061
integer height = 168
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Trabajador"
end type

type gb_4 from groupbox within w_pr721_dias_laborados
integer x = 14
integer y = 324
integer width = 1522
integer height = 180
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
end type

