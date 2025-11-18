$PBExportHeader$w_fi732_envio_informacion.srw
forward
global type w_fi732_envio_informacion from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas_horas_local within w_fi732_envio_informacion
end type
type cbx_origenes from checkbox within w_fi732_envio_informacion
end type
type cbx_usuarios from checkbox within w_fi732_envio_informacion
end type
type cb_3 from commandbutton within w_fi732_envio_informacion
end type
type sle_origen from singlelineedit within w_fi732_envio_informacion
end type
type st_2 from statictext within w_fi732_envio_informacion
end type
type cb_2 from commandbutton within w_fi732_envio_informacion
end type
type sle_user from singlelineedit within w_fi732_envio_informacion
end type
type st_1 from statictext within w_fi732_envio_informacion
end type
type cb_1 from commandbutton within w_fi732_envio_informacion
end type
type dw_report from u_dw_rpt within w_fi732_envio_informacion
end type
type gb_1 from groupbox within w_fi732_envio_informacion
end type
end forward

global type w_fi732_envio_informacion from w_rpt
integer width = 2999
integer height = 2220
string title = "Envio de Información a Caja (FI732)"
string menuname = "m_reporte"
long backcolor = 12632256
uo_1 uo_1
cbx_origenes cbx_origenes
cbx_usuarios cbx_usuarios
cb_3 cb_3
sle_origen sle_origen
st_2 st_2
cb_2 cb_2
sle_user sle_user
st_1 st_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi732_envio_informacion w_fi732_envio_informacion

on w_fi732_envio_informacion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cbx_origenes=create cbx_origenes
this.cbx_usuarios=create cbx_usuarios
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_2=create st_2
this.cb_2=create cb_2
this.sle_user=create sle_user
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cbx_origenes
this.Control[iCurrent+3]=this.cbx_usuarios
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.sle_user
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_fi732_envio_informacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cbx_origenes)
destroy(this.cbx_usuarios)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.sle_user)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = False
This.Event ue_preview()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type uo_1 from u_ingreso_rango_fechas_horas_local within w_fi732_envio_informacion
event destroy ( )
integer x = 96
integer y = 108
integer width = 1797
integer taborder = 40
end type

on uo_1.destroy
call u_ingreso_rango_fechas_horas_local::destroy
end on

event constructor;call super::constructor;Time     lt_hoy
Datetime ld_dia_hoy

lt_hoy = Time (today())
ld_dia_hoy = Datetime(today(),lt_hoy)

of_set_fecha(ld_dia_hoy,ld_dia_hoy) //para setear la fecha inicial
end event

type cbx_origenes from checkbox within w_fi732_envio_informacion
integer x = 1006
integer y = 332
integer width = 663
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos Los Origenes"
end type

event clicked;if this.checked then
	sle_origen.Enabled = FALSE
	sle_origen.Text	  = '%'
else
	sle_origen.Enabled = TRUE
	sle_origen.Text	  = ''
end if
end event

type cbx_usuarios from checkbox within w_fi732_envio_informacion
integer x = 1006
integer y = 228
integer width = 663
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos Los Usuarios"
end type

event clicked;if this.checked then
	sle_user.Enabled = FALSE
	sle_user.Text	  = '%'
else
	sle_user.Enabled = TRUE
	sle_user.Text	  = ''
end if
end event

type cb_3 from commandbutton within w_fi732_envio_informacion
integer x = 745
integer y = 332
integer width = 114
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS NOMBRE_ORIGEN " &
		  + "FROM ORIGEN " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_origen.text		= ls_codigo
end if
end event

type sle_origen from singlelineedit within w_fi732_envio_informacion
integer x = 366
integer y = 328
integer width = 343
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_fi732_envio_informacion
integer x = 37
integer y = 336
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_fi732_envio_informacion
integer x = 750
integer y = 232
integer width = 114
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_USR AS CODIGO_USUARIO, " &
		  + "NOMBRE AS NOMBRE_USUARIO " &
		  + "FROM USUARIO " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_user.text		= ls_codigo
end if
end event

type sle_user from singlelineedit within w_fi732_envio_informacion
event ue_tecla pbm_dwnkey
integer x = 361
integer y = 232
integer width = 343
integer height = 68
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi732_envio_informacion
integer x = 37
integer y = 240
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Usuario :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fi732_envio_informacion
integer x = 2464
integer y = 124
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Recuperar"
end type

event clicked;String   ls_user,ls_origen
Datetime ldt_fecha_inicio,ldt_fecha_final


//para leer las fechas
ldt_fecha_inicio = uo_1.of_get_fecha1()
ldt_fecha_final  = uo_1.of_get_fecha2()

ls_user	 		  = sle_user.text
ls_origen 		  = sle_origen.text


if cbx_origenes.checked = false then
	ls_origen = ls_origen + '%'
end if	

if cbx_usuarios.checked = false then
	ls_user = ls_user + '%'	
end if	


dw_report.Retrieve(ldt_fecha_inicio,ldt_fecha_final,ls_user,ls_origen)


end event

type dw_report from u_dw_rpt within w_fi732_envio_informacion
integer x = 18
integer y = 436
integer width = 2853
integer height = 1248
string dataobject = "d_abc_provision_x_dia_tbl"
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_fi732_envio_informacion
integer x = 27
integer y = 16
integer width = 1906
integer height = 408
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Datos"
end type

