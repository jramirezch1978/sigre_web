$PBExportHeader$w_asi700_asistencia_trabajadores.srw
forward
global type w_asi700_asistencia_trabajadores from w_rpt
end type
type sle_mov from singlelineedit within w_asi700_asistencia_trabajadores
end type
type sle_seccion from singlelineedit within w_asi700_asistencia_trabajadores
end type
type sle_area from singlelineedit within w_asi700_asistencia_trabajadores
end type
type sle_ttrab from singlelineedit within w_asi700_asistencia_trabajadores
end type
type sle_origen from singlelineedit within w_asi700_asistencia_trabajadores
end type
type cb_6 from commandbutton within w_asi700_asistencia_trabajadores
end type
type cb_5 from commandbutton within w_asi700_asistencia_trabajadores
end type
type cb_3 from commandbutton within w_asi700_asistencia_trabajadores
end type
type cb_2 from commandbutton within w_asi700_asistencia_trabajadores
end type
type em_seccion from editmask within w_asi700_asistencia_trabajadores
end type
type em_area from editmask within w_asi700_asistencia_trabajadores
end type
type em_ttrab from editmask within w_asi700_asistencia_trabajadores
end type
type em_origen from editmask within w_asi700_asistencia_trabajadores
end type
type cbx_origen from checkbox within w_asi700_asistencia_trabajadores
end type
type cbx_ttrab from checkbox within w_asi700_asistencia_trabajadores
end type
type cbx_area from checkbox within w_asi700_asistencia_trabajadores
end type
type cbx_seccion from checkbox within w_asi700_asistencia_trabajadores
end type
type cbx_trabajador from checkbox within w_asi700_asistencia_trabajadores
end type
type em_nombres from editmask within w_asi700_asistencia_trabajadores
end type
type cb_1 from commandbutton within w_asi700_asistencia_trabajadores
end type
type sle_codigo from singlelineedit within w_asi700_asistencia_trabajadores
end type
type st_6 from statictext within w_asi700_asistencia_trabajadores
end type
type st_5 from statictext within w_asi700_asistencia_trabajadores
end type
type st_2 from statictext within w_asi700_asistencia_trabajadores
end type
type st_3 from statictext within w_asi700_asistencia_trabajadores
end type
type st_1 from statictext within w_asi700_asistencia_trabajadores
end type
type cbx_tmov from checkbox within w_asi700_asistencia_trabajadores
end type
type em_desc_tmov from editmask within w_asi700_asistencia_trabajadores
end type
type st_4 from statictext within w_asi700_asistencia_trabajadores
end type
type cb_4 from commandbutton within w_asi700_asistencia_trabajadores
end type
type uo_fecha from u_ingreso_rango_fechas within w_asi700_asistencia_trabajadores
end type
type pb_1 from picturebutton within w_asi700_asistencia_trabajadores
end type
type dw_report from u_dw_rpt within w_asi700_asistencia_trabajadores
end type
type gb_2 from groupbox within w_asi700_asistencia_trabajadores
end type
end forward

global type w_asi700_asistencia_trabajadores from w_rpt
integer width = 4091
integer height = 2388
string title = "Reporte de Asistencias (ASI700)"
string menuname = "m_reporte"
long backcolor = 67108864
sle_mov sle_mov
sle_seccion sle_seccion
sle_area sle_area
sle_ttrab sle_ttrab
sle_origen sle_origen
cb_6 cb_6
cb_5 cb_5
cb_3 cb_3
cb_2 cb_2
em_seccion em_seccion
em_area em_area
em_ttrab em_ttrab
em_origen em_origen
cbx_origen cbx_origen
cbx_ttrab cbx_ttrab
cbx_area cbx_area
cbx_seccion cbx_seccion
cbx_trabajador cbx_trabajador
em_nombres em_nombres
cb_1 cb_1
sle_codigo sle_codigo
st_6 st_6
st_5 st_5
st_2 st_2
st_3 st_3
st_1 st_1
cbx_tmov cbx_tmov
em_desc_tmov em_desc_tmov
st_4 st_4
cb_4 cb_4
uo_fecha uo_fecha
pb_1 pb_1
dw_report dw_report
gb_2 gb_2
end type
global w_asi700_asistencia_trabajadores w_asi700_asistencia_trabajadores

type variables
//
end variables

on w_asi700_asistencia_trabajadores.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_mov=create sle_mov
this.sle_seccion=create sle_seccion
this.sle_area=create sle_area
this.sle_ttrab=create sle_ttrab
this.sle_origen=create sle_origen
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_3=create cb_3
this.cb_2=create cb_2
this.em_seccion=create em_seccion
this.em_area=create em_area
this.em_ttrab=create em_ttrab
this.em_origen=create em_origen
this.cbx_origen=create cbx_origen
this.cbx_ttrab=create cbx_ttrab
this.cbx_area=create cbx_area
this.cbx_seccion=create cbx_seccion
this.cbx_trabajador=create cbx_trabajador
this.em_nombres=create em_nombres
this.cb_1=create cb_1
this.sle_codigo=create sle_codigo
this.st_6=create st_6
this.st_5=create st_5
this.st_2=create st_2
this.st_3=create st_3
this.st_1=create st_1
this.cbx_tmov=create cbx_tmov
this.em_desc_tmov=create em_desc_tmov
this.st_4=create st_4
this.cb_4=create cb_4
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mov
this.Control[iCurrent+2]=this.sle_seccion
this.Control[iCurrent+3]=this.sle_area
this.Control[iCurrent+4]=this.sle_ttrab
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.cb_6
this.Control[iCurrent+7]=this.cb_5
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.em_seccion
this.Control[iCurrent+11]=this.em_area
this.Control[iCurrent+12]=this.em_ttrab
this.Control[iCurrent+13]=this.em_origen
this.Control[iCurrent+14]=this.cbx_origen
this.Control[iCurrent+15]=this.cbx_ttrab
this.Control[iCurrent+16]=this.cbx_area
this.Control[iCurrent+17]=this.cbx_seccion
this.Control[iCurrent+18]=this.cbx_trabajador
this.Control[iCurrent+19]=this.em_nombres
this.Control[iCurrent+20]=this.cb_1
this.Control[iCurrent+21]=this.sle_codigo
this.Control[iCurrent+22]=this.st_6
this.Control[iCurrent+23]=this.st_5
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.st_3
this.Control[iCurrent+26]=this.st_1
this.Control[iCurrent+27]=this.cbx_tmov
this.Control[iCurrent+28]=this.em_desc_tmov
this.Control[iCurrent+29]=this.st_4
this.Control[iCurrent+30]=this.cb_4
this.Control[iCurrent+31]=this.uo_fecha
this.Control[iCurrent+32]=this.pb_1
this.Control[iCurrent+33]=this.dw_report
this.Control[iCurrent+34]=this.gb_2
end on

on w_asi700_asistencia_trabajadores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_mov)
destroy(this.sle_seccion)
destroy(this.sle_area)
destroy(this.sle_ttrab)
destroy(this.sle_origen)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.em_seccion)
destroy(this.em_area)
destroy(this.em_ttrab)
destroy(this.em_origen)
destroy(this.cbx_origen)
destroy(this.cbx_ttrab)
destroy(this.cbx_area)
destroy(this.cbx_seccion)
destroy(this.cbx_trabajador)
destroy(this.em_nombres)
destroy(this.cb_1)
destroy(this.sle_codigo)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.cbx_tmov)
destroy(this.em_desc_tmov)
destroy(this.st_4)
destroy(this.cb_4)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_2)
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

event ue_retrieve;call super::ue_retrieve;String ls_area,ls_origen,ls_seccion,ls_ttrab,ls_cod_trabajador,ls_tipo_mov
Long   ll_count
Date	 ld_fecha_inicio,ld_fecha_final	

ls_area    = sle_area.text
ls_seccion = sle_seccion.text
ls_origen  = sle_origen.text
ls_ttrab	  = sle_ttrab.text
ls_cod_trabajador = sle_codigo.text
ls_tipo_mov			= sle_mov.text
ld_fecha_inicio = uo_fecha.of_get_fecha1()
ld_fecha_final  = uo_fecha.of_get_fecha2()

IF Isnull(ls_area) or trim(ls_area) = '' THEN
	if cbx_area.checked then
		ls_area = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Area del Trabajador')
		Return
	end if
ELSE
	select Count(*) into :ll_count from area 
    where (cod_area = :ls_area) ;
	 
	if ll_count = 0 then
		Messagebox('Aviso','Area No existe ,Verifique!')
		Return
	end if

	
END IF	

IF Isnull(ls_seccion) or trim(ls_seccion) = '' THEN
	if cbx_seccion.checked then
		ls_seccion = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para la Seccion del Trabajador')
		Return

	end if
ELSE
//	messabeox
	select Count(*) into :ll_count from seccion s 
    where (s.cod_area    = :ls_area    ) and
          (s.cod_seccion = :ls_seccion ) and
          (s.flag_estado = '1'         ) ;
 
	if ll_count = 0 then
		Messagebox('Aviso','Seccion No existe ,Verifique!')
		Return
	end if
END IF	


IF Isnull(ls_origen) or trim(ls_origen) = '' THEN
	if cbx_origen.checked then
		ls_origen = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Origen del Trabajador')
		Return
		
	end if
ELSE
	select Count(*) into :ll_count from origen 
	 where (cod_origen  = :ls_origen ) and 
   	    (flag_estado = '1'        ) ;

			 
	if ll_count = 0 then
		Messagebox('Aviso','Origen No existe ,Verifique!')
		Return
	end if
			 
END IF

IF Isnull(ls_ttrab) or trim(ls_ttrab) = '' THEN
	if cbx_ttrab.checked then
		ls_ttrab = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Tipo de Trabajador')
		Return
	end if
ELSE
	Select Count(*) into :ll_count from tipo_trabajador
	 where (tipo_trabajador = :ls_ttrab ) and
	 		 (flag_estado		= '1'			);
			  
   
	if ll_count = 0 then
		Messagebox('Aviso','Tipo de Trabajador No existe ,Verifique!')
		Return
	end if
	
END IF

IF Isnull(ls_cod_trabajador) or trim(ls_cod_trabajador) = '' THEN
	if cbx_trabajador.checked then
		ls_cod_trabajador = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Codigo de Trabajador')
		Return
	end if
ELSE
	Select Count(*) into :ll_count from maestro
	 where (cod_trabajador = :ls_cod_trabajador ) ;
			  
   
	if ll_count = 0 then
		Messagebox('Aviso','Codigo de Trabajador No existe ,Verifique!')
		Return
	end if
	
END IF



IF Isnull(ls_tipo_mov) or trim(ls_tipo_mov) = '' THEN
	if cbx_tmov.checked then
		ls_tipo_mov = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Tipo de Movimiento')
		Return
	end if
ELSE
	Select Count(*) into :ll_count from tipo_mov_asistencia
	 where (cod_tipo_mov = :ls_tipo_mov ) ;
			  
   
	if ll_count = 0 then
		Messagebox('Aviso','Tipo de Movimiento No existe ,Verifique!')
		Return
	end if
	
END IF




//idw_1.dataobject 		= 	'd_rpt_detalle_asistencia_tbl'



this.SetRedraw(false)
idw_1.Retrieve(ld_fecha_inicio, ld_fecha_final,ls_origen,ls_ttrab,ls_area,ls_seccion,ls_cod_trabajador,ls_tipo_mov)
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_fecha1.text   = string(ld_fecha_inicio)
idw_1.Object.t_fecha2.text   = string(ld_fecha_final)

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

type sle_mov from singlelineedit within w_asi700_asistencia_trabajadores
integer x = 457
integer y = 696
integer width = 343
integer height = 84
integer taborder = 70
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

type sle_seccion from singlelineedit within w_asi700_asistencia_trabajadores
integer x = 457
integer y = 512
integer width = 233
integer height = 84
integer taborder = 70
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_area from singlelineedit within w_asi700_asistencia_trabajadores
integer x = 457
integer y = 420
integer width = 233
integer height = 84
integer taborder = 130
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_ttrab from singlelineedit within w_asi700_asistencia_trabajadores
integer x = 457
integer y = 328
integer width = 233
integer height = 84
integer taborder = 120
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

type sle_origen from singlelineedit within w_asi700_asistencia_trabajadores
integer x = 457
integer y = 236
integer width = 233
integer height = 84
integer taborder = 110
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

type cb_6 from commandbutton within w_asi700_asistencia_trabajadores
integer x = 699
integer y = 232
integer width = 73
integer height = 80
integer taborder = 100
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

type cb_5 from commandbutton within w_asi700_asistencia_trabajadores
integer x = 699
integer y = 320
integer width = 73
integer height = 80
integer taborder = 110
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

type cb_3 from commandbutton within w_asi700_asistencia_trabajadores
integer x = 699
integer y = 416
integer width = 73
integer height = 80
integer taborder = 120
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_area.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_abc_area_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_tiptra, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_area.text    = sl_param.field_ret[1]
		em_area.text = sl_param.field_ret[2]
	END IF
end if	

end event

type cb_2 from commandbutton within w_asi700_asistencia_trabajadores
integer x = 699
integer y = 512
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

event clicked;if cbx_seccion.checked = false then
	// Abre ventana de ayuda 
	String ls_area
	str_parametros sl_param


	ls_area = sle_area.text

	sl_param.dw1 = "d_abc_seccion_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.tipo	  = '1S'
	sl_param.string1 = ls_area
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_tiptra, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_seccion.text    = sl_param.field_ret[1]
		em_seccion.text = sl_param.field_ret[2]
	END IF
end if	

end event

type em_seccion from editmask within w_asi700_asistencia_trabajadores
integer x = 791
integer y = 512
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

type em_area from editmask within w_asi700_asistencia_trabajadores
integer x = 791
integer y = 420
integer width = 1211
integer height = 80
integer taborder = 120
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

type em_ttrab from editmask within w_asi700_asistencia_trabajadores
integer x = 791
integer y = 328
integer width = 1211
integer height = 80
integer taborder = 110
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

type em_origen from editmask within w_asi700_asistencia_trabajadores
integer x = 791
integer y = 236
integer width = 1211
integer height = 80
integer taborder = 100
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

type cbx_origen from checkbox within w_asi700_asistencia_trabajadores
integer x = 2039
integer y = 248
integer width = 288
integer height = 56
integer textsize = -7
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

type cbx_ttrab from checkbox within w_asi700_asistencia_trabajadores
integer x = 2039
integer y = 340
integer width = 288
integer height = 56
integer textsize = -7
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

type cbx_area from checkbox within w_asi700_asistencia_trabajadores
integer x = 2039
integer y = 432
integer width = 288
integer height = 56
integer textsize = -7
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
	sle_area.text = ''
	em_area.text  = ''
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_area.enabled    = FALSE
	sle_seccion.enabled = FALSE
	cbx_seccion.enabled = FALSE
	cbx_seccion.checked = TRUE
else	
	sle_area.text = ''
	em_area.text  = ''
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_area.enabled    = true
	sle_seccion.enabled = true
	cbx_seccion.enabled = true
	cbx_seccion.checked = FALSE
end if
end event

type cbx_seccion from checkbox within w_asi700_asistencia_trabajadores
integer x = 2039
integer y = 524
integer width = 288
integer height = 56
integer textsize = -7
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
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_seccion.enabled = FALSE
else	
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_seccion.enabled = true
end if
end event

type cbx_trabajador from checkbox within w_asi700_asistencia_trabajadores
integer x = 2126
integer y = 624
integer width = 288
integer height = 56
integer textsize = -7
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

type em_nombres from editmask within w_asi700_asistencia_trabajadores
integer x = 901
integer y = 608
integer width = 1202
integer height = 80
integer taborder = 80
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

type cb_1 from commandbutton within w_asi700_asistencia_trabajadores
integer x = 814
integer y = 608
integer width = 73
integer height = 80
integer taborder = 70
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

type sle_codigo from singlelineedit within w_asi700_asistencia_trabajadores
integer x = 457
integer y = 604
integer width = 343
integer height = 84
integer taborder = 60
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

type st_6 from statictext within w_asi700_asistencia_trabajadores
integer x = 119
integer y = 608
integer width = 306
integer height = 72
boolean bringtotop = true
integer textsize = -7
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

type st_5 from statictext within w_asi700_asistencia_trabajadores
integer x = 123
integer y = 516
integer width = 306
integer height = 72
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Sección :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi700_asistencia_trabajadores
integer x = 123
integer y = 424
integer width = 306
integer height = 72
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Area :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_asi700_asistencia_trabajadores
integer x = 123
integer y = 340
integer width = 306
integer height = 80
boolean bringtotop = true
integer textsize = -7
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

type st_1 from statictext within w_asi700_asistencia_trabajadores
integer x = 123
integer y = 244
integer width = 306
integer height = 80
boolean bringtotop = true
integer textsize = -7
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

type cbx_tmov from checkbox within w_asi700_asistencia_trabajadores
integer x = 2126
integer y = 700
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Todos"
end type

event clicked;if this.checked then
	sle_mov.text = ''
	em_desc_tmov.text  = ''
	sle_mov.enabled = FALSE
else	
	sle_mov.text = ''
	em_desc_tmov.text  = ''
	sle_mov.enabled = TRUE
end if
end event

type em_desc_tmov from editmask within w_asi700_asistencia_trabajadores
integer x = 901
integer y = 700
integer width = 1202
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

type st_4 from statictext within w_asi700_asistencia_trabajadores
integer x = 119
integer y = 712
integer width = 306
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "T.Movimiento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_asi700_asistencia_trabajadores
integer x = 814
integer y = 700
integer width = 73
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_tmov.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_seleccion_tipmov_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_origen, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_mov.text      = sl_param.field_ret[1]
		em_desc_tmov.text = sl_param.field_ret[2]
	END IF
end if	

end event

type uo_fecha from u_ingreso_rango_fechas within w_asi700_asistencia_trabajadores
integer x = 114
integer y = 116
integer width = 1312
integer taborder = 90
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(),today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type pb_1 from picturebutton within w_asi700_asistencia_trabajadores
integer x = 2738
integer y = 88
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
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_asi700_asistencia_trabajadores
integer x = 64
integer y = 848
integer width = 3730
integer height = 1052
string dataobject = "d_rpt_detalle_asistencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_asi700_asistencia_trabajadores
integer x = 69
integer y = 32
integer width = 3022
integer height = 784
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

