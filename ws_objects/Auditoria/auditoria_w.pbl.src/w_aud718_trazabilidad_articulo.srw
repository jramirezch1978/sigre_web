$PBExportHeader$w_aud718_trazabilidad_articulo.srw
forward
global type w_aud718_trazabilidad_articulo from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_aud718_trazabilidad_articulo
end type
type cb_3 from commandbutton within w_aud718_trazabilidad_articulo
end type
type em_origen from singlelineedit within w_aud718_trazabilidad_articulo
end type
type em_descripcion from editmask within w_aud718_trazabilidad_articulo
end type
type cbx_origen from checkbox within w_aud718_trazabilidad_articulo
end type
type gb_1 from groupbox within w_aud718_trazabilidad_articulo
end type
type gb_2 from groupbox within w_aud718_trazabilidad_articulo
end type
end forward

global type w_aud718_trazabilidad_articulo from w_report_smpl
integer width = 3424
integer height = 1856
string title = "[AUD718] Trazabilidad de articulo"
string menuname = "m_reporte"
uo_1 uo_1
cb_3 cb_3
em_origen em_origen
em_descripcion em_descripcion
cbx_origen cbx_origen
gb_1 gb_1
gb_2 gb_2
end type
global w_aud718_trazabilidad_articulo w_aud718_trazabilidad_articulo

on w_aud718_trazabilidad_articulo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_3=create cb_3
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cbx_origen=create cbx_origen
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_descripcion
this.Control[iCurrent+5]=this.cbx_origen
this.Control[iCurrent+6]=this.gb_1
this.Control[iCurrent+7]=this.gb_2
end on

on w_aud718_trazabilidad_articulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cbx_origen)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;//Override

date 		ld_fec_desde, ld_fec_hasta
String	ls_origen, ls_mensaje

ld_fec_desde	=uo_1.of_get_fecha1()
ld_fec_hasta	=uo_1.of_get_fecha2()

if cbx_origen.checked = true then
	ls_origen = '%%'
else
	ls_origen    = trim(em_origen.text)	
	if ls_origen = '' or isnull(ls_origen) then
		messagebox('Aviso', 'Debe de Seleccionar un Origen')
		idw_1.Visible = false
		Return 
	end if
end if

ib_preview = true
event ue_preview()

idw_1.Retrieve(ls_origen, ld_fec_desde, ld_fec_hasta)
idw_1.Visible = True

dw_report.object.t_empresa.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_aud718_trazabilidad_articulo
integer x = 0
integer y = 200
integer width = 3346
integer height = 1384
integer taborder = 30
string dataobject = "d_rpt_traza_articulo_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type uo_1 from u_ingreso_rango_fechas within w_aud718_trazabilidad_articulo
integer x = 50
integer y = 60
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_inicio
uo_1.of_set_label('Desde','Hasta')

// obtenemos el primer dia del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

type cb_3 from commandbutton within w_aud718_trazabilidad_articulo
integer x = 2811
integer y = 24
integer width = 343
integer height = 152
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type em_origen from singlelineedit within w_aud718_trazabilidad_articulo
event dobleclick pbm_lbuttondblclk
integer x = 1582
integer y = 88
integer width = 128
integer height = 72
integer taborder = 40
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

type em_descripcion from editmask within w_aud718_trazabilidad_articulo
integer x = 1723
integer y = 88
integer width = 1006
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cbx_origen from checkbox within w_aud718_trazabilidad_articulo
integer x = 1463
integer y = 80
integer width = 105
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean checked = true
end type

event clicked;if this.checked then
	
	em_origen.enabled = false
	em_origen.text = '' 
	
else
	
	em_origen.enabled = true

end if
end event

type gb_1 from groupbox within w_aud718_trazabilidad_articulo
integer width = 1381
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = " Ingrese Rango de Fechas "
end type

type gb_2 from groupbox within w_aud718_trazabilidad_articulo
integer x = 1403
integer width = 1376
integer height = 184
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos   -   Seleccione Origen "
end type

