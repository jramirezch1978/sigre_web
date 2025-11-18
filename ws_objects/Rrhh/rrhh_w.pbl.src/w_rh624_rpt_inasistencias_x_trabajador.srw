$PBExportHeader$w_rh624_rpt_inasistencias_x_trabajador.srw
forward
global type w_rh624_rpt_inasistencias_x_trabajador from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_rh624_rpt_inasistencias_x_trabajador
end type
type cbx_origen from checkbox within w_rh624_rpt_inasistencias_x_trabajador
end type
type cbx_ttrab from checkbox within w_rh624_rpt_inasistencias_x_trabajador
end type
type cb_3 from commandbutton within w_rh624_rpt_inasistencias_x_trabajador
end type
type sle_origen from singlelineedit within w_rh624_rpt_inasistencias_x_trabajador
end type
type st_3 from statictext within w_rh624_rpt_inasistencias_x_trabajador
end type
type sle_ttrabajador from singlelineedit within w_rh624_rpt_inasistencias_x_trabajador
end type
type st_2 from statictext within w_rh624_rpt_inasistencias_x_trabajador
end type
type cb_2 from commandbutton within w_rh624_rpt_inasistencias_x_trabajador
end type
type cb_1 from commandbutton within w_rh624_rpt_inasistencias_x_trabajador
end type
type dw_report from u_dw_rpt within w_rh624_rpt_inasistencias_x_trabajador
end type
type gb_1 from groupbox within w_rh624_rpt_inasistencias_x_trabajador
end type
end forward

global type w_rh624_rpt_inasistencias_x_trabajador from w_rpt
integer width = 3392
integer height = 2176
string title = "Inasistencia Por Trabajador (RH624)"
string menuname = "m_reporte"
long backcolor = 12632256
uo_1 uo_1
cbx_origen cbx_origen
cbx_ttrab cbx_ttrab
cb_3 cb_3
sle_origen sle_origen
st_3 st_3
sle_ttrabajador sle_ttrabajador
st_2 st_2
cb_2 cb_2
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_rh624_rpt_inasistencias_x_trabajador w_rh624_rpt_inasistencias_x_trabajador

on w_rh624_rpt_inasistencias_x_trabajador.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cbx_origen=create cbx_origen
this.cbx_ttrab=create cbx_ttrab
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_3=create st_3
this.sle_ttrabajador=create sle_ttrabajador
this.st_2=create st_2
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cbx_origen
this.Control[iCurrent+3]=this.cbx_ttrab
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.sle_ttrabajador
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_rh624_rpt_inasistencias_x_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cbx_origen)
destroy(this.cbx_ttrab)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_3)
destroy(this.sle_ttrabajador)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()

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

type uo_1 from u_ingreso_rango_fechas within w_rh624_rpt_inasistencias_x_trabajador
integer x = 64
integer y = 128
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cbx_origen from checkbox within w_rh624_rpt_inasistencias_x_trabajador
integer x = 978
integer y = 380
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos"
end type

event clicked;if this.checked then
	sle_origen.text	 = ''
	sle_origen.enabled = false
else
	sle_origen.enabled = true
end if	
end event

type cbx_ttrab from checkbox within w_rh624_rpt_inasistencias_x_trabajador
integer x = 978
integer y = 280
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Todos"
end type

event clicked;if this.checked then
	sle_ttrabajador.enabled = false
	sle_ttrabajador.text 	= ''
else
	sle_ttrabajador.enabled = true
end if	
end event

type cb_3 from commandbutton within w_rh624_rpt_inasistencias_x_trabajador
integer x = 814
integer y = 384
integer width = 110
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO      , '&
								       +'ORIGEN.NOMBRE     AS DESCRIPCION   '&
				   				 	 +'FROM ORIGEN '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_origen.text = lstr_seleccionar.param1[1]
END IF														 

end event

type sle_origen from singlelineedit within w_rh624_rpt_inasistencias_x_trabajador
integer x = 594
integer y = 380
integer width = 183
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_rh624_rpt_inasistencias_x_trabajador
integer x = 78
integer y = 392
integer width = 507
integer height = 56
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

type sle_ttrabajador from singlelineedit within w_rh624_rpt_inasistencias_x_trabajador
integer x = 594
integer y = 280
integer width = 183
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_rh624_rpt_inasistencias_x_trabajador
integer x = 73
integer y = 296
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Tipo de Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh624_rpt_inasistencias_x_trabajador
integer x = 809
integer y = 280
integer width = 110
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT TIPO_TRABAJADOR.TIPO_TRABAJADOR AS TTRABAJADOR , '&
								       +'TIPO_TRABAJADOR.DESC_TIPO_TRA   AS DESCRIPCION , '&
										 +'TIPO_TRABAJADOR.LIBRO_PLANILLA  AS NRO_LIBRO  '&
				   				 	 +'FROM TIPO_TRABAJADOR '&

														 
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_ttrabajador.text = lstr_seleccionar.param1[1]
END IF														 

end event

type cb_1 from commandbutton within w_rh624_rpt_inasistencias_x_trabajador
integer x = 2985
integer y = 28
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String  ls_origen,ls_ttrab
Date    ld_fecha_inicial,ld_fecha_final
Long    ll_count

	

/**/
ld_fecha_inicial = uo_1.of_get_fecha1()
ld_fecha_final   = uo_1.of_get_fecha2()
ls_ttrab			  = sle_ttrabajador.text
ls_origen		  = sle_origen.text


if cbx_ttrab.checked then
	ls_ttrab = '%'
else
	select count(*) into :ll_count 
	  from tipo_trabajador
	 where tipo_trabajador = :ls_ttrab and
 			 flag_estado	  = '1'		  ;
		  
	if ll_count = 0 then
		Messagebox('Aviso','Codigo de Trabajador No Existe ,Verifique!')
		sle_ttrabajador.text = ''
		Return	
	end if	
end if	


if cbx_origen.checked then
	ls_origen = '%'
else	
	select count(*) into :ll_count 
  	  from origen
	 where cod_origen  = :ls_origen and
 			 flag_estado = '1'		  ;
		  
	if ll_count = 0 then
		Messagebox('Aviso','Codigo de Origen No Existe ,Verifique!')
		sle_origen.text = ''
		Return	
	end if	
end if	
		  
		  

dw_report.Retrieve(gs_user,ls_origen,ls_ttrab,ld_fecha_inicial,ld_fecha_final)



dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text	  = gs_user



end event

type dw_report from u_dw_rpt within w_rh624_rpt_inasistencias_x_trabajador
integer x = 23
integer y = 536
integer width = 3305
integer height = 1360
string dataobject = "d_rpt_inasistencia_x_fecha_x_trab_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_rh624_rpt_inasistencias_x_trabajador
integer x = 37
integer y = 20
integer width = 1362
integer height = 480
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Ingrese Datos"
end type

