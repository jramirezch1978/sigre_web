$PBExportHeader$w_ve764_ventas_mensuales.srw
forward
global type w_ve764_ventas_mensuales from w_report_smpl
end type
type cbx_origenes from checkbox within w_ve764_ventas_mensuales
end type
type sle_origen from singlelineedit within w_ve764_ventas_mensuales
end type
type sle_desc from singlelineedit within w_ve764_ventas_mensuales
end type
type cb_1 from commandbutton within w_ve764_ventas_mensuales
end type
type st_4 from statictext within w_ve764_ventas_mensuales
end type
type sle_year from singlelineedit within w_ve764_ventas_mensuales
end type
type st_3 from statictext within w_ve764_ventas_mensuales
end type
type sle_mes1 from singlelineedit within w_ve764_ventas_mensuales
end type
type st_1 from statictext within w_ve764_ventas_mensuales
end type
type sle_mes2 from singlelineedit within w_ve764_ventas_mensuales
end type
type gb_1 from groupbox within w_ve764_ventas_mensuales
end type
end forward

global type w_ve764_ventas_mensuales from w_report_smpl
integer width = 3973
integer height = 2036
string title = "[VE764] Registro de ventas mensual detallado"
string menuname = "m_reporte"
cbx_origenes cbx_origenes
sle_origen sle_origen
sle_desc sle_desc
cb_1 cb_1
st_4 st_4
sle_year sle_year
st_3 st_3
sle_mes1 sle_mes1
st_1 st_1
sle_mes2 sle_mes2
gb_1 gb_1
end type
global w_ve764_ventas_mensuales w_ve764_ventas_mensuales

on w_ve764_ventas_mensuales.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_origenes=create cbx_origenes
this.sle_origen=create sle_origen
this.sle_desc=create sle_desc
this.cb_1=create cb_1
this.st_4=create st_4
this.sle_year=create sle_year
this.st_3=create st_3
this.sle_mes1=create sle_mes1
this.st_1=create st_1
this.sle_mes2=create sle_mes2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_origenes
this.Control[iCurrent+2]=this.sle_origen
this.Control[iCurrent+3]=this.sle_desc
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_mes1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_mes2
this.Control[iCurrent+11]=this.gb_1
end on

on w_ve764_ventas_mensuales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_origenes)
destroy(this.sle_origen)
destroy(this.sle_desc)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.sle_year)
destroy(this.st_3)
destroy(this.sle_mes1)
destroy(this.st_1)
destroy(this.sle_mes2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen
Integer	li_mes1, li_mes2, li_year


if cbx_origenes.checked then
	ls_origen = '%'
else
	if trim(sle_origen.text) = '' then
		MessageBox('Error', 'Debe seleccionar un origen, por favor verifique!', StopSign!)
		return
	end if
	ls_origen =  sle_origen.text + "%"

end if

li_mes1 = Integer(sle_mes1.text)
li_mes2 = Integer(sle_mes2.text)
li_year = Integer(sle_year.text)

ib_preview = true
event ue_preview()

dw_report.retrieve(li_year, li_mes1, li_mes2, ls_origen)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


end event

event ue_open_pre;call super::ue_open_pre;date 	ld_hoy

ld_hoy = Date(gnvo_app.of_fecha_Actual())

sle_year.text = string(ld_hoy, 'yyyy')
sle_mes1.text = string(ld_hoy, 'mm')
sle_mes2.text = string(ld_hoy, 'mm')

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)


end event

type dw_report from w_report_smpl`dw_report within w_ve764_ventas_mensuales
integer x = 14
integer y = 312
integer width = 3438
integer height = 1496
integer taborder = 40
string dataobject = "d_rpt_ventas_detalladas_mensual_tbl"
end type

type cbx_origenes from checkbox within w_ve764_ventas_mensuales
integer x = 27
integer y = 188
integer width = 599
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes "
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
	sle_origen.text = ""
	sle_desc.text = "TODAS"
else
	sle_origen.enabled = true
	sle_desc.text = ""
end if
end event

type sle_origen from singlelineedit within w_ve764_ventas_mensuales
event dobleclick pbm_lbuttondblclk
integer x = 640
integer y = 180
integer width = 233
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO ,'&
				      				 +'ORIGEN.NOMBRE AS DESCRIPCION '&
				   					 +'FROM ORIGEN '

														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   this.text 		 =  lstr_seleccionar.param1[1]
   sle_desc.text   =  lstr_seleccionar.param2[1]
END IF

end event

event modified;String ls_origen,ls_desc
Long   ll_count


ls_origen = this.text


select count(*) into :ll_count 
  from origen 
 where cod_origen = :ls_origen ;
 
IF ll_count > 0 THEN
	select nombre into :ls_desc from origen 
	 where cod_origen = :ls_origen ;
	 
	sle_desc.text = ls_desc
ELSE
	Setnull(ls_desc)
	sle_desc.text = ls_desc
END IF
 

end event

type sle_desc from singlelineedit within w_ve764_ventas_mensuales
integer x = 887
integer y = 180
integer width = 942
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_ve764_ventas_mensuales
integer x = 1888
integer y = 72
integer width = 448
integer height = 168
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type st_4 from statictext within w_ve764_ventas_mensuales
integer x = 32
integer y = 84
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_ve764_ventas_mensuales
integer x = 201
integer y = 76
integer width = 192
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_ve764_ventas_mensuales
integer x = 416
integer y = 84
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes1 from singlelineedit within w_ve764_ventas_mensuales
integer x = 736
integer y = 76
integer width = 105
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ve764_ventas_mensuales
integer x = 882
integer y = 84
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_ve764_ventas_mensuales
integer x = 1175
integer y = 76
integer width = 105
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_ve764_ventas_mensuales
integer width = 3442
integer height = 296
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

