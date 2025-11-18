$PBExportHeader$w_rh408_rpt_onomasticos.srw
forward
global type w_rh408_rpt_onomasticos from w_rpt
end type
type cb_retrieve from commandbutton within w_rh408_rpt_onomasticos
end type
type st_2 from statictext within w_rh408_rpt_onomasticos
end type
type rb_inactivos from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_activos from radiobutton within w_rh408_rpt_onomasticos
end type
type sle_1 from singlelineedit within w_rh408_rpt_onomasticos
end type
type rb_year from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_dic from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_nov from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_oct from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_sep from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_ago from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_jul from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_jun from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_may from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_abr from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_mar from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_feb from radiobutton within w_rh408_rpt_onomasticos
end type
type rb_ene from radiobutton within w_rh408_rpt_onomasticos
end type
type cbx_tipo from checkbox within w_rh408_rpt_onomasticos
end type
type dw_report from u_dw_rpt within w_rh408_rpt_onomasticos
end type
type em_tipo from singlelineedit within w_rh408_rpt_onomasticos
end type
type em_origen from singlelineedit within w_rh408_rpt_onomasticos
end type
type em_descripcion from editmask within w_rh408_rpt_onomasticos
end type
type gb_1 from groupbox within w_rh408_rpt_onomasticos
end type
type gb_2 from groupbox within w_rh408_rpt_onomasticos
end type
end forward

global type w_rh408_rpt_onomasticos from w_rpt
integer width = 3995
integer height = 1700
string title = "(RH408) Lista de Onomásticos"
string menuname = "m_impresion"
windowstate windowstate = maximized!
event ue_query_retrieve ( )
cb_retrieve cb_retrieve
st_2 st_2
rb_inactivos rb_inactivos
rb_activos rb_activos
sle_1 sle_1
rb_year rb_year
rb_dic rb_dic
rb_nov rb_nov
rb_oct rb_oct
rb_sep rb_sep
rb_ago rb_ago
rb_jul rb_jul
rb_jun rb_jun
rb_may rb_may
rb_abr rb_abr
rb_mar rb_mar
rb_feb rb_feb
rb_ene rb_ene
cbx_tipo cbx_tipo
dw_report dw_report
em_tipo em_tipo
em_origen em_origen
em_descripcion em_descripcion
gb_1 gb_1
gb_2 gb_2
end type
global w_rh408_rpt_onomasticos w_rh408_rpt_onomasticos

event ue_query_retrieve();This.Event ue_retrieve()
end event

on w_rh408_rpt_onomasticos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_retrieve=create cb_retrieve
this.st_2=create st_2
this.rb_inactivos=create rb_inactivos
this.rb_activos=create rb_activos
this.sle_1=create sle_1
this.rb_year=create rb_year
this.rb_dic=create rb_dic
this.rb_nov=create rb_nov
this.rb_oct=create rb_oct
this.rb_sep=create rb_sep
this.rb_ago=create rb_ago
this.rb_jul=create rb_jul
this.rb_jun=create rb_jun
this.rb_may=create rb_may
this.rb_abr=create rb_abr
this.rb_mar=create rb_mar
this.rb_feb=create rb_feb
this.rb_ene=create rb_ene
this.cbx_tipo=create cbx_tipo
this.dw_report=create dw_report
this.em_tipo=create em_tipo
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_retrieve
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.rb_inactivos
this.Control[iCurrent+4]=this.rb_activos
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.rb_year
this.Control[iCurrent+7]=this.rb_dic
this.Control[iCurrent+8]=this.rb_nov
this.Control[iCurrent+9]=this.rb_oct
this.Control[iCurrent+10]=this.rb_sep
this.Control[iCurrent+11]=this.rb_ago
this.Control[iCurrent+12]=this.rb_jul
this.Control[iCurrent+13]=this.rb_jun
this.Control[iCurrent+14]=this.rb_may
this.Control[iCurrent+15]=this.rb_abr
this.Control[iCurrent+16]=this.rb_mar
this.Control[iCurrent+17]=this.rb_feb
this.Control[iCurrent+18]=this.rb_ene
this.Control[iCurrent+19]=this.cbx_tipo
this.Control[iCurrent+20]=this.dw_report
this.Control[iCurrent+21]=this.em_tipo
this.Control[iCurrent+22]=this.em_origen
this.Control[iCurrent+23]=this.em_descripcion
this.Control[iCurrent+24]=this.gb_1
this.Control[iCurrent+25]=this.gb_2
end on

on w_rh408_rpt_onomasticos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_retrieve)
destroy(this.st_2)
destroy(this.rb_inactivos)
destroy(this.rb_activos)
destroy(this.sle_1)
destroy(this.rb_year)
destroy(this.rb_dic)
destroy(this.rb_nov)
destroy(this.rb_oct)
destroy(this.rb_sep)
destroy(this.rb_ago)
destroy(this.rb_jul)
destroy(this.rb_jun)
destroy(this.rb_may)
destroy(this.rb_abr)
destroy(this.rb_mar)
destroy(this.rb_feb)
destroy(this.rb_ene)
destroy(this.cbx_tipo)
destroy(this.dw_report)
destroy(this.em_tipo)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_tipo_trabajador, ls_desc_origen, ls_tipo, &
			ls_mes, ls_nombre_mes, ls_txt, ls_txt_1, ls_estado

IF cbx_tipo.Checked THEN
	ls_tipo_trabajador	= '%%' //Todos los trabajadores
	ls_tipo		=	'TODOS LOS TRABAJADORES'
	ls_txt		=  'DE:'
	
	
ELSE
	   	ls_tipo_trabajador 		=  upper(em_tipo.text)//Un solo tipo de trabajador
			ls_txt = 'DE LOS:'
			
			ls_tipo			=  sle_1.text
			IF em_tipo.Text = '' THEN
			messagebox('Recursos Humanos', 'Por favor seleccione un Tipo de Trabajador')
		 	return
		 	END IF
end if 	

	   ls_desc_origen	=  em_descripcion.text
		ls_origen		= 	em_origen.text
		
		
		IF em_origen.Text = '' THEN
			messagebox('Recursos Humanos', 'Por favor seleccione un Origen')
	 	 return
		END IF


IF rb_ene.checked = true THEN     					//Flota Propia
	ls_mes = '01'
	ls_nombre_mes = 'ENERO'
end if

IF rb_feb.checked = true THEN     					//Flota Propia
	ls_mes = '02'
	ls_nombre_mes = 'FEBRERO'
end if
IF rb_mar.checked = true THEN     					//Flota Propia
	ls_mes = '03'
	ls_nombre_mes = 'MARZO'
end if
IF rb_abr.checked = true THEN     					//Flota Propia
	ls_mes = '04'
	ls_nombre_mes = 'ABRIL'
end if
IF rb_may.checked = true THEN     					//Flota Propia
	ls_mes = '05'
	ls_nombre_mes = 'MAYO'
end if
IF rb_jun.checked = true THEN     					//Flota Propia
	ls_mes = '06'
	ls_nombre_mes = 'JUNIO'
end if
IF rb_jul.checked = true THEN     					//Flota Propia
	ls_mes = '07'
	ls_nombre_mes = 'JULIO'
end if
IF rb_ago.checked = true THEN     					//Flota Propia
	ls_mes = '08'
	ls_nombre_mes = 'AGOSTO'
end if
IF rb_sep.checked = true THEN     					//Flota Propia
	ls_mes = '09'
	ls_nombre_mes = 'SEPTIEMBRE'
end if
IF rb_oct.checked = true THEN     					//Flota Propia
	ls_mes = '10'
	ls_nombre_mes = 'OCTUBRE'
end if
IF rb_nov.checked = true THEN     					//Flota Propia
	ls_mes = '11'
	ls_nombre_mes = 'NOVIEMBRE'
end if
IF rb_dic.checked = true THEN     					//Flota Propia
	ls_mes = '12'
	ls_nombre_mes = 'DICIEMBRE'
end if

IF rb_activos.Checked = true THEN
	ls_estado = '1'
END IF

IF rb_inactivos.Checked = true THEN
	ls_estado = '0'
END IF

//	IF rb_activos.Checked = false AND rb_activos.Checked 		= true then 
//			messagebox('Recursos Humanos', 'Por favor seleccione estado de los Trabajadores')
//	return
//	if rb_inactivos.Checked = true and rb_activos.Checked = false THEN
//				messagebox('Recursos Humanos', 'Por favor seleccione estado de los Trabajadores')
//	return
//	End if 
//	END IF 
		
IF rb_year.checked = true THEN
	ls_nombre_mes = 'TODO EL AÑO'
	idw_1.dataobject 				= 	'd_genera_onomasticos_rpt_2'
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(ls_origen, ls_tipo_trabajador, ls_estado)
	
	idw_1.Visible = True
	
	idw_1.Object.p_logo.filename 	= gs_logo
	idw_1.object.t_origen.text 	= ls_desc_origen
	idw_1.object.t_3.text 			= ls_txt
	idw_1.object.t_tipo.text 		= ls_tipo
		
else
	ls_txt_1 = 'DEL MES DE:'
	idw_1.dataobject 				= 	'd_genera_onomasticos_rpt'
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(ls_origen, ls_tipo_trabajador, ls_mes, ls_estado)
	
	idw_1.Visible = True
	
	idw_1.Object.p_logo.filename 	= gs_logo
	idw_1.object.t_origen.text 	= ls_desc_origen
	idw_1.object.t_tipo.text 		= ls_tipo
	idw_1.object.t_3.text 			= ls_txt
	idw_1.object.t_4.text 			= ls_txt_1
	idw_1.object.t_mes.text 		= ls_nombre_mes

end if




end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = True
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
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

type cb_retrieve from commandbutton within w_rh408_rpt_onomasticos
integer x = 3163
integer y = 44
integer width = 402
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

type st_2 from statictext within w_rh408_rpt_onomasticos
integer x = 2601
integer y = 8
integer width = 215
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Estado "
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_inactivos from radiobutton within w_rh408_rpt_onomasticos
integer x = 2821
integer y = 72
integer width = 293
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Inactivos"
end type

type rb_activos from radiobutton within w_rh408_rpt_onomasticos
integer x = 2546
integer y = 72
integer width = 274
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Activos"
boolean checked = true
end type

type sle_1 from singlelineedit within w_rh408_rpt_onomasticos
integer x = 1170
integer y = 72
integer width = 1349
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type rb_year from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 200
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todo el año"
boolean checked = true
boolean lefttext = true
end type

type rb_dic from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 1256
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Diciembre"
boolean lefttext = true
end type

type rb_nov from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 1168
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Novienbre"
boolean lefttext = true
end type

type rb_oct from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 1080
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Octubre"
boolean lefttext = true
end type

type rb_sep from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 992
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Septiembre"
boolean lefttext = true
end type

type rb_ago from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 904
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Agosto"
boolean lefttext = true
end type

type rb_jul from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 816
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Julio"
boolean lefttext = true
end type

type rb_jun from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 728
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Junio"
boolean lefttext = true
end type

type rb_may from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 640
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mayo"
boolean lefttext = true
end type

type rb_abr from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 552
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Abril"
boolean lefttext = true
end type

type rb_mar from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 464
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Marzo"
boolean lefttext = true
end type

type rb_feb from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 376
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Febrero"
boolean lefttext = true
end type

type rb_ene from radiobutton within w_rh408_rpt_onomasticos
integer x = 41
integer y = 288
integer width = 347
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Enero"
boolean lefttext = true
end type

type cbx_tipo from checkbox within w_rh408_rpt_onomasticos
integer x = 1723
integer width = 274
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

event clicked;IF THIS.CHECKED THEN
	em_tipo.Enabled 	= False
	em_tipo.Text 		= ''
	sle_1.Text = ''
ELSE
	em_tipo.Enabled = True
END IF
end event

type dw_report from u_dw_rpt within w_rh408_rpt_onomasticos
integer x = 416
integer y = 200
integer width = 2711
integer height = 1184
integer taborder = 90
string dataobject = "d_genera_onomasticos_rpt"
end type

type em_tipo from singlelineedit within w_rh408_rpt_onomasticos
event dobleclick pbm_lbuttondblclk
integer x = 1015
integer y = 72
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
boolean enabled = false
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
	sle_1.text = upper(ls_data)
end if


end event

event modified;String 	ls_tipo_traba, ls_desc

ls_tipo_traba = this.text
if ls_tipo_traba = '' or IsNull(ls_tipo_traba) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Trabajador')
	return
end if

SELECT desc_tipo_tra
	INTO :ls_desc
FROM tipo_trabajador
WHERE tipo_trabajador = :ls_tipo_Traba;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Tipo de Trabajador no existe')
	return
end if

sle_1.text = ls_desc
end event

type em_origen from singlelineedit within w_rh408_rpt_onomasticos
event dobleclick pbm_lbuttondblclk
integer x = 41
integer y = 72
integer width = 128
integer height = 76
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

type em_descripcion from editmask within w_rh408_rpt_onomasticos
integer x = 183
integer y = 72
integer width = 663
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_1 from groupbox within w_rh408_rpt_onomasticos
integer y = 4
integer width = 901
integer height = 176
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_2 from groupbox within w_rh408_rpt_onomasticos
integer x = 942
integer y = 4
integer width = 2208
integer height = 176
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Seleccione Tipo de Trabajador "
end type

