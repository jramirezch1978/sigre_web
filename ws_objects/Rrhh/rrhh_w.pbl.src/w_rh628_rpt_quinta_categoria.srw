$PBExportHeader$w_rh628_rpt_quinta_categoria.srw
forward
global type w_rh628_rpt_quinta_categoria from w_rpt
end type
type em_ano from editmask within w_rh628_rpt_quinta_categoria
end type
type st_1 from statictext within w_rh628_rpt_quinta_categoria
end type
type cbx_origen from checkbox within w_rh628_rpt_quinta_categoria
end type
type cbx_ttrab from checkbox within w_rh628_rpt_quinta_categoria
end type
type cb_3 from commandbutton within w_rh628_rpt_quinta_categoria
end type
type sle_origen from singlelineedit within w_rh628_rpt_quinta_categoria
end type
type st_3 from statictext within w_rh628_rpt_quinta_categoria
end type
type sle_ttrabajador from singlelineedit within w_rh628_rpt_quinta_categoria
end type
type st_2 from statictext within w_rh628_rpt_quinta_categoria
end type
type cb_2 from commandbutton within w_rh628_rpt_quinta_categoria
end type
type cb_1 from commandbutton within w_rh628_rpt_quinta_categoria
end type
type dw_report from u_dw_rpt within w_rh628_rpt_quinta_categoria
end type
type gb_1 from groupbox within w_rh628_rpt_quinta_categoria
end type
end forward

global type w_rh628_rpt_quinta_categoria from w_rpt
integer width = 3771
integer height = 2356
string title = "Cuadro de Retención de Quinta  (RH628)"
string menuname = "m_reporte"
long backcolor = 67108864
em_ano em_ano
st_1 st_1
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
global w_rh628_rpt_quinta_categoria w_rh628_rpt_quinta_categoria

on w_rh628_rpt_quinta_categoria.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.em_ano=create em_ano
this.st_1=create st_1
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
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_origen
this.Control[iCurrent+4]=this.cbx_ttrab
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.sle_origen
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_ttrabajador
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.dw_report
this.Control[iCurrent+13]=this.gb_1
end on

on w_rh628_rpt_quinta_categoria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_1)
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

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel (dw_report, ls_file )
End If

end event

type em_ano from editmask within w_rh628_rpt_quinta_categoria
integer x = 594
integer y = 96
integer width = 251
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_rh628_rpt_quinta_categoria
integer x = 73
integer y = 116
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_origen from checkbox within w_rh628_rpt_quinta_categoria
integer x = 978
integer y = 292
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_origen.text	 = ''
	sle_origen.enabled = false
else
	sle_origen.enabled = true
end if	
end event

type cbx_ttrab from checkbox within w_rh628_rpt_quinta_categoria
integer x = 978
integer y = 192
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_ttrabajador.enabled = false
	sle_ttrabajador.text 	= ''
else
	sle_ttrabajador.enabled = true
end if	
end event

type cb_3 from commandbutton within w_rh628_rpt_quinta_categoria
integer x = 814
integer y = 296
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

type sle_origen from singlelineedit within w_rh628_rpt_quinta_categoria
integer x = 594
integer y = 292
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

type st_3 from statictext within w_rh628_rpt_quinta_categoria
integer x = 78
integer y = 304
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ttrabajador from singlelineedit within w_rh628_rpt_quinta_categoria
integer x = 594
integer y = 192
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

type st_2 from statictext within w_rh628_rpt_quinta_categoria
integer x = 73
integer y = 208
integer width = 507
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh628_rpt_quinta_categoria
integer x = 809
integer y = 192
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

type cb_1 from commandbutton within w_rh628_rpt_quinta_categoria
integer x = 3319
integer y = 56
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
Long    ll_count, ll_year


dw_report.reset()

/**/
ll_year			  = Long(em_ano.text)
ls_ttrab			  = sle_ttrabajador.text
ls_origen		  = sle_origen.text

 
/*Recupera concepto de Remuneraciones*/ 
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
		  
		  

dw_report.Retrieve(ll_year,ls_origen,ls_ttrab)



dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text	  = gs_user




end event

type dw_report from u_dw_rpt within w_rh628_rpt_quinta_categoria
integer x = 23
integer y = 440
integer width = 3675
integer height = 1456
string dataobject = "d_rpt_cuadro_retenciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_rh628_rpt_quinta_categoria
integer x = 37
integer y = 20
integer width = 1371
integer height = 388
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Datos"
end type

