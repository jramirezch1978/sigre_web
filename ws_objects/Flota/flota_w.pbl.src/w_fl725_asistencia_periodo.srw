$PBExportHeader$w_fl725_asistencia_periodo.srw
forward
global type w_fl725_asistencia_periodo from w_rpt
end type
type rb_detalle from radiobutton within w_fl725_asistencia_periodo
end type
type cbx_todos from checkbox within w_fl725_asistencia_periodo
end type
type sle_tripulante from singlelineedit within w_fl725_asistencia_periodo
end type
type st_nom_tripulante from statictext within w_fl725_asistencia_periodo
end type
type st_2 from statictext within w_fl725_asistencia_periodo
end type
type st_nomb_nave from statictext within w_fl725_asistencia_periodo
end type
type sle_nave from singlelineedit within w_fl725_asistencia_periodo
end type
type st_1 from statictext within w_fl725_asistencia_periodo
end type
type rb_crosstab from radiobutton within w_fl725_asistencia_periodo
end type
type rb_resumen from radiobutton within w_fl725_asistencia_periodo
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl725_asistencia_periodo
end type
type cb_1 from commandbutton within w_fl725_asistencia_periodo
end type
type dw_report from u_dw_rpt within w_fl725_asistencia_periodo
end type
end forward

global type w_fl725_asistencia_periodo from w_rpt
integer width = 4384
integer height = 2212
string title = "Asistencia de Tripulantes (FL725)"
string menuname = "m_impresion"
event ue_copiar ( )
rb_detalle rb_detalle
cbx_todos cbx_todos
sle_tripulante sle_tripulante
st_nom_tripulante st_nom_tripulante
st_2 st_2
st_nomb_nave st_nomb_nave
sle_nave sle_nave
st_1 st_1
rb_crosstab rb_crosstab
rb_resumen rb_resumen
uo_fecha uo_fecha
cb_1 cb_1
dw_report dw_report
end type
global w_fl725_asistencia_periodo w_fl725_asistencia_periodo

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ok
string 	ls_mensaje, ls_nave, ls_tripulante
date 		ld_fecha1, ld_fecha2

SetPointer(HourGlass!)

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

ls_nave = trim(sle_nave.text)

if ls_nave = '' then
	gnvo_app.of_mensaje_error("Debe indicar la nave, por favor verifique!")
	sle_nave.setFocus()
	return
end if

if cbx_todos.checked then
	ls_tripulante = '%%'
else
	if trim(sle_tripulante.text) = '' then
		gnvo_app.of_mensaje_error("Debe indicar el tripulante, por favor verifique!")
		sle_tripulante.setFocus()
		return
	end if
	
	ls_tripulante = trim(sle_tripulante.text) + '%'
end if

idw_1.SetRedraw(False)
idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_nave, ls_tripulante)
idw_1.SetRedraw(True)
idw_1.object.titulo2_t.text = 'PERIODO: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' - ' + string(ld_fecha2, 'dd/mm/yyyy') 

SetPointer(Arrow!)

end event

on w_fl725_asistencia_periodo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_detalle=create rb_detalle
this.cbx_todos=create cbx_todos
this.sle_tripulante=create sle_tripulante
this.st_nom_tripulante=create st_nom_tripulante
this.st_2=create st_2
this.st_nomb_nave=create st_nomb_nave
this.sle_nave=create sle_nave
this.st_1=create st_1
this.rb_crosstab=create rb_crosstab
this.rb_resumen=create rb_resumen
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_detalle
this.Control[iCurrent+2]=this.cbx_todos
this.Control[iCurrent+3]=this.sle_tripulante
this.Control[iCurrent+4]=this.st_nom_tripulante
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_nomb_nave
this.Control[iCurrent+7]=this.sle_nave
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.rb_crosstab
this.Control[iCurrent+10]=this.rb_resumen
this.Control[iCurrent+11]=this.uo_fecha
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.dw_report
end on

on w_fl725_asistencia_periodo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_detalle)
destroy(this.cbx_todos)
destroy(this.sle_tripulante)
destroy(this.st_nom_tripulante)
destroy(this.st_2)
destroy(this.st_nomb_nave)
destroy(this.sle_nave)
destroy(this.st_1)
destroy(this.rb_crosstab)
destroy(this.rb_resumen)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.dw_report)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
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

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.usuario_t.text 	= 'Usuario: ' + gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 1


end event

type rb_detalle from radiobutton within w_fl725_asistencia_periodo
integer x = 878
integer y = 100
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado"
end type

event clicked;dw_report.DataObject = 'd_rpt_asistencia_trip_detalle_tbl'
dw_report.setTransObject(SQLCA)
end event

type cbx_todos from checkbox within w_fl725_asistencia_periodo
integer x = 3282
integer y = 96
integer width = 411
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_tripulante.enabled = false
else
	sle_tripulante.enabled = true
end if
end event

type sle_tripulante from singlelineedit within w_fl725_asistencia_periodo
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
integer x = 1742
integer y = 92
integer width = 293
integer height = 80
integer taborder = 50
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
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_display()
end event

event ue_display();// Este evento despliega la pantalla w_seleccionar

string 	ls_codigo, ls_data, ls_sql
boolean	lb_ret
integer 	li_i

ls_sql = "select distinct fl.tripulante as codigo_tripulante, " &
		 + "m.NOM_TRABAJADOR as nombre_tripulante " &
		 + "from fl_tripulantes fl, " &
		 + "     vw_pr_trabajador m, " &
		 + "     fl_asistencia    fa " &
		 + "where fl.tripulante = fa.tripulante " &
		 + "  and fl.tripulante = m.COD_TRABAJADOR "

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	st_nom_tripulante.text = ls_data		
	this.text	 		= ls_codigo
end if



end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_display()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

select nom_trabajador
  into :ls_data
  from vw_pr_trabajador m
where m.cod_trabajador = :ls_codigo;
		
st_nom_tripulante.text = ls_data


end event

type st_nom_tripulante from statictext within w_fl725_asistencia_periodo
integer x = 2053
integer y = 92
integer width = 1221
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl725_asistencia_periodo
integer x = 1298
integer y = 96
integer width = 425
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tripulante :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nomb_nave from statictext within w_fl725_asistencia_periodo
integer x = 2053
integer width = 1221
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_nave from singlelineedit within w_fl725_asistencia_periodo
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 1742
integer width = 293
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM TG_NAVES " &
		 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.event ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

		
st_nomb_nave.text = ls_data

parent.event ue_retrieve()
end event

type st_1 from statictext within w_fl725_asistencia_periodo
integer x = 1294
integer y = 12
integer width = 425
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nave :"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_crosstab from radiobutton within w_fl725_asistencia_periodo
integer x = 485
integer y = 100
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Crosstab"
end type

event clicked;dw_report.DataObject = 'd_rpt_asistencia_crt'
dw_report.setTransObject(SQLCA)
end event

type rb_resumen from radiobutton within w_fl725_asistencia_periodo
integer x = 91
integer y = 100
integer width = 384
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

event clicked;dw_report.DataObject = 'd_rpt_asistencia_trip_tbl'
dw_report.setTransObject(SQLCA)
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl725_asistencia_periodo
event destroy ( )
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
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

type cb_1 from commandbutton within w_fl725_asistencia_periodo
integer x = 3817
integer y = 4
integer width = 343
integer height = 168
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fl725_asistencia_periodo
integer y = 188
integer width = 3483
integer height = 1688
integer taborder = 60
string dataobject = "d_rpt_asistencia_trip_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

