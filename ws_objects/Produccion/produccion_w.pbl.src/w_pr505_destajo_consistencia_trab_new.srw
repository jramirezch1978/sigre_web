$PBExportHeader$w_pr505_destajo_consistencia_trab_new.srw
forward
global type w_pr505_destajo_consistencia_trab_new from w_rpt
end type
type st_1 from statictext within w_pr505_destajo_consistencia_trab_new
end type
type sle_nombre from singlelineedit within w_pr505_destajo_consistencia_trab_new
end type
type sle_codigo from singlelineedit within w_pr505_destajo_consistencia_trab_new
end type
type cbx_trabajador from checkbox within w_pr505_destajo_consistencia_trab_new
end type
type em_descripcion from singlelineedit within w_pr505_destajo_consistencia_trab_new
end type
type em_ot_adm from singlelineedit within w_pr505_destajo_consistencia_trab_new
end type
type pb_1 from picturebutton within w_pr505_destajo_consistencia_trab_new
end type
type dw_report from u_dw_rpt within w_pr505_destajo_consistencia_trab_new
end type
type uo_rango from ou_rango_fechas within w_pr505_destajo_consistencia_trab_new
end type
type gb_2 from groupbox within w_pr505_destajo_consistencia_trab_new
end type
type gb_3 from groupbox within w_pr505_destajo_consistencia_trab_new
end type
type gb_4 from groupbox within w_pr505_destajo_consistencia_trab_new
end type
end forward

global type w_pr505_destajo_consistencia_trab_new from w_rpt
integer width = 2830
integer height = 1932
string title = "Consistencia de Destajo por Trabajador(PR505) "
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
st_1 st_1
sle_nombre sle_nombre
sle_codigo sle_codigo
cbx_trabajador cbx_trabajador
em_descripcion em_descripcion
em_ot_adm em_ot_adm
pb_1 pb_1
dw_report dw_report
uo_rango uo_rango
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_pr505_destajo_consistencia_trab_new w_pr505_destajo_consistencia_trab_new

event ue_query_retrieve();// Ancestor Script has been Override

SetPointer(HourGlass!)
this.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

on w_pr505_destajo_consistencia_trab_new.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.sle_nombre=create sle_nombre
this.sle_codigo=create sle_codigo
this.cbx_trabajador=create cbx_trabajador
this.em_descripcion=create em_descripcion
this.em_ot_adm=create em_ot_adm
this.pb_1=create pb_1
this.dw_report=create dw_report
this.uo_rango=create uo_rango
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_nombre
this.Control[iCurrent+3]=this.sle_codigo
this.Control[iCurrent+4]=this.cbx_trabajador
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.em_ot_adm
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.uo_rango
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
this.Control[iCurrent+12]=this.gb_4
end on

on w_pr505_destajo_consistencia_trab_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_nombre)
destroy(this.sle_codigo)
destroy(this.cbx_trabajador)
destroy(this.em_descripcion)
destroy(this.em_ot_adm)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.uo_rango)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
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

event ue_retrieve;call super::ue_retrieve;string ls_nro_parte, ls_fecha, ls_ot_adm, ls_cod_trabajador
date ld_fecha_1, ld_fecha_2

ld_fecha_1 = uo_rango.of_get_fecha1( )
ld_fecha_2 = uo_rango.of_get_fecha2( )
ls_ot_adm  = trim(em_ot_adm.text)

if cbx_trabajador.checked = true then
			ls_cod_trabajador	= '%%'
 	else
			ls_cod_trabajador	= trim(sle_codigo.text)
end if
		
if ls_cod_trabajador = '' or IsNull(ls_cod_trabajador) then
			MessageBox('Producción', 'No ha definido ningún Trabajador', StopSign!)
return
end if

idw_1.Retrieve(ld_fecha_1, ld_fecha_2, ls_ot_adm, ls_cod_trabajador)

if idw_1.rowcount( ) < 1 then return

select to_char(sysdate, 'dd/mm/yyyy hh24:mi') 
   into :ls_fecha
	from dual;
	
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = 'Impreso por: ' + trim(gs_user)
idw_1.object.t_date.text = 'Fecha de impresión: ' + trim(ls_fecha)
idw_1.Visible = True

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

type st_1 from statictext within w_pr505_destajo_consistencia_trab_new
integer x = 41
integer y = 220
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

type sle_nombre from singlelineedit within w_pr505_destajo_consistencia_trab_new
integer x = 590
integer y = 352
integer width = 901
integer height = 72
integer taborder = 80
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

type sle_codigo from singlelineedit within w_pr505_destajo_consistencia_trab_new
event dobleclick pbm_lbuttondblclk
integer x = 293
integer y = 352
integer width = 279
integer height = 72
integer taborder = 70
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
string  ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen

ls_sql = "SELECT  distinct m.cod_relacion as codigo, " & 
		 + "m.nombre AS TRABAJADOR " &
		 + "FROM CODIGO_RELACION m "

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

event modified;String 	ls_nombre, ls_codigo

ls_codigo = this.text


SELECT distinct m.nombre
	INTO :ls_nombre
FROM CODIGO_RELACION m
where m.cod_relacion =:ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Producción', 'Codigo de Trabajador no existe')
	this.text = ''
	sle_nombre.text = ''
	return
else
	sle_nombre.text = ls_nombre
end if

	

end event

type cbx_trabajador from checkbox within w_pr505_destajo_consistencia_trab_new
integer x = 110
integer y = 348
integer width = 82
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean lefttext = true
end type

event clicked;if this.checked = true then
	
	sle_codigo.enabled = false
	sle_codigo.text = ''
	sle_nombre.text = ''
	
else
	
	sle_codigo.enabled = true

end if
end event

type em_descripcion from singlelineedit within w_pr505_destajo_consistencia_trab_new
integer x = 293
integer y = 88
integer width = 1189
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
borderstyle borderstyle = stylelowered!
end type

type em_ot_adm from singlelineedit within w_pr505_destajo_consistencia_trab_new
event dobleclick pbm_lbuttondblclk
integer x = 59
integer y = 88
integer width = 219
integer height = 72
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
boolean autohscroll = false
textcase textcase = upper!
integer limit = 2
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

event modified;//String ls_origen, ls_desc
//
//ls_origen = this.text
//if ls_origen = '' or IsNull(ls_origen) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
//	return
//end if
//
//SELECT descripcion INTO :ls_desc
//FROM ot_administracion
//WHERE ot_adm =:ls_origen;
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Origen no existe')
//	return
//end if
//
//em_descripcion.text = ls_desc


end event

type pb_1 from picturebutton within w_pr505_destajo_consistencia_trab_new
integer x = 1888
integer y = 284
integer width = 608
integer height = 176
integer taborder = 60
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

type dw_report from u_dw_rpt within w_pr505_destajo_consistencia_trab_new
integer x = 18
integer y = 504
integer width = 2720
integer height = 1208
integer taborder = 60
string dataobject = "d_destajo_consistencia_trab_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type uo_rango from ou_rango_fechas within w_pr505_destajo_consistencia_trab_new
event destroy ( )
integer x = 1563
integer y = 104
integer taborder = 50
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type gb_2 from groupbox within w_pr505_destajo_consistencia_trab_new
integer x = 1545
integer y = 8
integer width = 1175
integer height = 220
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione rango de fechas"
end type

type gb_3 from groupbox within w_pr505_destajo_consistencia_trab_new
integer x = 18
integer y = 4
integer width = 1513
integer height = 220
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT. Administración"
end type

type gb_4 from groupbox within w_pr505_destajo_consistencia_trab_new
integer x = 14
integer y = 284
integer width = 1513
integer height = 180
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Todos   Seleccione Trabajador "
end type

