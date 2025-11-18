$PBExportHeader$w_fl727_detalle_pesca.srw
forward
global type w_fl727_detalle_pesca from w_rpt
end type
type st_2 from statictext within w_fl727_detalle_pesca
end type
type st_nom_tripulante from statictext within w_fl727_detalle_pesca
end type
type sle_tripulante from singlelineedit within w_fl727_detalle_pesca
end type
type cbx_todos from checkbox within w_fl727_detalle_pesca
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl727_detalle_pesca
end type
type cb_refrescar from commandbutton within w_fl727_detalle_pesca
end type
type dw_report from u_dw_rpt within w_fl727_detalle_pesca
end type
end forward

global type w_fl727_detalle_pesca from w_rpt
integer width = 3090
integer height = 2212
string title = "Detalle de Pesca x Periodo (FL727)"
string menuname = "m_impresion"
event ue_copiar ( )
st_2 st_2
st_nom_tripulante st_nom_tripulante
sle_tripulante sle_tripulante
cbx_todos cbx_todos
uo_fecha uo_fecha
cb_refrescar cb_refrescar
dw_report dw_report
end type
global w_fl727_detalle_pesca w_fl727_detalle_pesca

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ok
string 	ls_mensaje, ls_tripulante
date 		ld_fecha1, ld_fecha2

SetPointer(HourGlass!)

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

if cbx_todos.checked then
	ls_tripulante = '%%'
else
	if trim(sle_tripulante.text) = '' then
		MessageBox('Error', 'Debe Seleccionar un tripulante, por favor verifique!', StopSign!)
		sle_tripulante.setFocus()
		return
	end if
end if

ls_tripulante = trim(sle_tripulante.text) + '%'

idw_1.SetRedraw(False)
idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_tripulante)
idw_1.SetRedraw(True)
idw_1.object.titulo2_t.text = 'PERIODO: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' - ' + string(ld_fecha2, 'dd/mm/yyyy') 

SetPointer(Arrow!)

end event

on w_fl727_detalle_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_2=create st_2
this.st_nom_tripulante=create st_nom_tripulante
this.sle_tripulante=create sle_tripulante
this.cbx_todos=create cbx_todos
this.uo_fecha=create uo_fecha
this.cb_refrescar=create cb_refrescar
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_nom_tripulante
this.Control[iCurrent+3]=this.sle_tripulante
this.Control[iCurrent+4]=this.cbx_todos
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.cb_refrescar
this.Control[iCurrent+7]=this.dw_report
end on

on w_fl727_detalle_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_nom_tripulante)
destroy(this.sle_tripulante)
destroy(this.cbx_todos)
destroy(this.uo_fecha)
destroy(this.cb_refrescar)
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

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type st_2 from statictext within w_fl727_detalle_pesca
integer y = 104
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

type st_nom_tripulante from statictext within w_fl727_detalle_pesca
integer x = 754
integer y = 100
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

type sle_tripulante from singlelineedit within w_fl727_detalle_pesca
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
integer x = 443
integer y = 100
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

type cbx_todos from checkbox within w_fl727_detalle_pesca
integer x = 1984
integer y = 104
integer width = 265
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

type uo_fecha from u_ingreso_rango_fechas within w_fl727_detalle_pesca
event destroy ( )
integer y = 4
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

type cb_refrescar from commandbutton within w_fl727_detalle_pesca
integer x = 2258
integer width = 398
integer height = 176
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

type dw_report from u_dw_rpt within w_fl727_detalle_pesca
integer y = 196
integer width = 2720
integer height = 1252
integer taborder = 60
string dataobject = "d_rpt_pesca_periodo_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

