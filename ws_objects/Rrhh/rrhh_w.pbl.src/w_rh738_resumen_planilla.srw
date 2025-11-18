$PBExportHeader$w_rh738_resumen_planilla.srw
forward
global type w_rh738_resumen_planilla from w_abc
end type
type em_descripcion from editmask within w_rh738_resumen_planilla
end type
type em_origen from editmask within w_rh738_resumen_planilla
end type
type st_3 from statictext within w_rh738_resumen_planilla
end type
type st_4 from statictext within w_rh738_resumen_planilla
end type
type em_desc_tipo_planilla from editmask within w_rh738_resumen_planilla
end type
type cb_tipo_planilla from commandbutton within w_rh738_resumen_planilla
end type
type em_tipo_planilla from editmask within w_rh738_resumen_planilla
end type
type st_tipo_planilla from statictext within w_rh738_resumen_planilla
end type
type cb_2 from commandbutton within w_rh738_resumen_planilla
end type
type em_tipo from editmask within w_rh738_resumen_planilla
end type
type em_desc_tipo from editmask within w_rh738_resumen_planilla
end type
type st_1 from statictext within w_rh738_resumen_planilla
end type
type cb_3 from commandbutton within w_rh738_resumen_planilla
end type
type em_fec_proceso from editmask within w_rh738_resumen_planilla
end type
type gb_1 from groupbox within w_rh738_resumen_planilla
end type
type cb_1 from commandbutton within w_rh738_resumen_planilla
end type
type tab_1 from tab within w_rh738_resumen_planilla
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_rpt within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_rpt within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from u_dw_rpt within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from u_dw_rpt within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from u_dw_rpt within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_6 from u_dw_rpt within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tab_1 from tab within w_rh738_resumen_planilla
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
end forward

global type w_rh738_resumen_planilla from w_abc
integer width = 4887
integer height = 2380
string title = "[RH738] Resumen Planilla Calculada"
string menuname = "m_impresion"
event ue_retrieve ( )
event ue_preview ( )
event ue_zoom ( integer ai_zoom )
em_descripcion em_descripcion
em_origen em_origen
st_3 st_3
st_4 st_4
em_desc_tipo_planilla em_desc_tipo_planilla
cb_tipo_planilla cb_tipo_planilla
em_tipo_planilla em_tipo_planilla
st_tipo_planilla st_tipo_planilla
cb_2 cb_2
em_tipo em_tipo
em_desc_tipo em_desc_tipo
st_1 st_1
cb_3 cb_3
em_fec_proceso em_fec_proceso
gb_1 gb_1
cb_1 cb_1
tab_1 tab_1
end type
global w_rh738_resumen_planilla w_rh738_resumen_planilla

type variables
u_dw_rpt idw_r1, idw_r2, idw_r3, idw_r4, idw_r5, idw_r6, idw_rdefault

end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

event ue_retrieve();string 			ls_origen, ls_tipo_trabaj, ls_mensaje, ls_desc_tipo_trabaj, ls_tipo_planilla
date 				ld_fec_proceso
str_parametros	lstr_param

if trim(em_origen.text) = '' then
	MessageBox('Error', 'Debe especificar un origen valido', StopSign!)
	em_origen.setFocus()
	return
end if

if trim(em_tipo.text) = '' then
	MessageBox('Error', 'Debe especificar un Tipo de Trabajador valido', StopSign!)
	em_tipo.setFocus()
	return
end if

if trim(em_tipo_planilla.text) = '' then
	MessageBox('Error', 'Debe especificar un Tipo de Planilla valido', StopSign!)
	em_tipo_planilla.setFocus()
	return
end if

ls_origen = string(em_origen.text)
ld_fec_proceso = date(em_fec_proceso.text)

ls_tipo_trabaj = trim(em_tipo.text) + '%'
ls_tipo_planilla = trim(em_tipo_planilla.text)


if trim(em_tipo.text) = '%' then
	ls_mensaje = 'Todos los trabajadores'
else
	ls_mensaje = em_desc_tipo.text
end if

idw_r1.setTransObject(SQLCA)
idw_r1.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)

idw_r2.setTransObject(SQLCA)
idw_r2.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)

idw_r3.setTransObject(SQLCA)
idw_r3.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)

idw_r4.setTransObject(SQLCA)
idw_r4.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)

idw_r5.setTransObject(SQLCA)
idw_r5.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)

idw_r6.setTransObject(SQLCA)
idw_r6.retrieve(ls_origen, ls_tipo_Trabaj, ld_fec_proceso, ls_tipo_planilla)

idw_r1.Object.p_logo.filename 	= gs_logo
idw_r1.Object.t_user.text  		= gs_user
idw_r1.Object.t_nombre.text  		= gs_empresa
idw_r1.object.t_titulo2.Text 		= ls_mensaje

idw_r2.Object.p_logo.filename 	= gs_logo
idw_r2.Object.t_user.text  		= gs_user
idw_r2.Object.t_nombre.text  		= gs_empresa
idw_r2.object.t_titulo2.Text 		= ls_mensaje

idw_r3.Object.p_logo.filename 	= gs_logo
idw_r3.Object.t_user.text  		= gs_user
idw_r3.Object.t_nombre.text  		= gs_empresa
idw_r3.object.t_titulo2.Text 		= ls_mensaje

idw_r4.Object.p_logo.filename 	= gs_logo
idw_r4.Object.t_user.text  		= gs_user
idw_r4.Object.t_nombre.text  		= gs_empresa
idw_r4.object.t_titulo2.Text 		= ls_mensaje

idw_r5.Object.p_logo.filename 	= gs_logo
idw_r5.Object.t_user.text  		= gs_user
idw_r5.Object.t_nombre.text  		= gs_empresa
idw_r5.object.t_titulo2.Text 		= ls_mensaje

idw_r6.Object.p_logo.filename 	= gs_logo
idw_r6.Object.t_user.text  		= gs_user
idw_r6.Object.t_nombre.text  		= gs_empresa
idw_r6.object.t_titulo2.Text 		= ls_mensaje


idw_r2.Modify("DataWindow.Print.Preview=Yes")
idw_r2.Modify("datawindow.print.preview.zoom = " + String(idw_r2.ii_zoom_actual))
idw_r2.title = "Reporte " + " (Zoom: " + String(idw_r2.ii_zoom_actual) + "%)"
idw_r2.ib_preview = TRUE

idw_r3.Modify("DataWindow.Print.Preview=Yes")
idw_r3.Modify("datawindow.print.preview.zoom = " + String(idw_r3.ii_zoom_actual))
idw_r3.title = "Reporte " + " (Zoom: " + String(idw_r3.ii_zoom_actual) + "%)"
idw_r3.ib_preview = TRUE

idw_r4.Modify("DataWindow.Print.Preview=Yes")
idw_r4.Modify("datawindow.print.preview.zoom = " + String(idw_r4.ii_zoom_actual))
idw_r4.title = "Reporte " + " (Zoom: " + String(idw_r4.ii_zoom_actual) + "%)"
idw_r4.ib_preview = TRUE

idw_r5.Modify("DataWindow.Print.Preview=Yes")
idw_r5.Modify("datawindow.print.preview.zoom = " + String(idw_r5.ii_zoom_actual))
idw_r5.title = "Reporte " + " (Zoom: " + String(idw_r5.ii_zoom_actual) + "%)"
idw_r5.ib_preview = TRUE

idw_r6.Modify("DataWindow.Print.Preview=Yes")
idw_r6.Modify("datawindow.print.preview.zoom = " + String(idw_r6.ii_zoom_actual))
idw_r6.title = "Reporte " + " (Zoom: " + String(idw_r6.ii_zoom_actual) + "%)"
idw_r6.ib_preview = TRUE

end event

event ue_preview();IF idw_rdefault.ib_preview THEN
	idw_rdefault.Modify("DataWindow.Print.Preview=No")
	idw_rdefault.Modify("datawindow.print.preview.zoom = " + String(idw_rdefault.ii_zoom_actual))
	idw_rdefault.title = "Reporte " + " (Zoom: " + String(idw_rdefault.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	idw_rdefault.ib_preview = FALSE
ELSE
	idw_rdefault.Modify("DataWindow.Print.Preview=Yes")
	idw_rdefault.Modify("datawindow.print.preview.zoom = " + String(idw_rdefault.ii_zoom_actual))
	idw_rdefault.title = "Reporte " + " (Zoom: " + String(idw_rdefault.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	idw_rdefault.ib_preview = TRUE
END IF
end event

event ue_zoom(integer ai_zoom);idw_rdefault.EVENT ue_zoom(ai_zoom)
end event

public subroutine of_asigna_dws ();idw_r1 = tab_1.tabpage_1.dw_1
idw_r2 = tab_1.tabpage_2.dw_2
idw_r3 = tab_1.tabpage_3.dw_3
idw_r4 = tab_1.tabpage_4.dw_4
idw_r5 = tab_1.tabpage_5.dw_5
idw_r6 = tab_1.tabpage_6.dw_6
end subroutine

on w_rh738_resumen_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.st_3=create st_3
this.st_4=create st_4
this.em_desc_tipo_planilla=create em_desc_tipo_planilla
this.cb_tipo_planilla=create cb_tipo_planilla
this.em_tipo_planilla=create em_tipo_planilla
this.st_tipo_planilla=create st_tipo_planilla
this.cb_2=create cb_2
this.em_tipo=create em_tipo
this.em_desc_tipo=create em_desc_tipo
this.st_1=create st_1
this.cb_3=create cb_3
this.em_fec_proceso=create em_fec_proceso
this.gb_1=create gb_1
this.cb_1=create cb_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_descripcion
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.em_desc_tipo_planilla
this.Control[iCurrent+6]=this.cb_tipo_planilla
this.Control[iCurrent+7]=this.em_tipo_planilla
this.Control[iCurrent+8]=this.st_tipo_planilla
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.em_tipo
this.Control[iCurrent+11]=this.em_desc_tipo
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.cb_3
this.Control[iCurrent+14]=this.em_fec_proceso
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.cb_1
this.Control[iCurrent+17]=this.tab_1
end on

on w_rh738_resumen_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_desc_tipo_planilla)
destroy(this.cb_tipo_planilla)
destroy(this.em_tipo_planilla)
destroy(this.st_tipo_planilla)
destroy(this.cb_2)
destroy(this.em_tipo)
destroy(this.em_desc_tipo)
destroy(this.st_1)
destroy(this.cb_3)
destroy(this.em_fec_proceso)
destroy(this.gb_1)
destroy(this.cb_1)
destroy(this.tab_1)
end on

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_r1.width  = tab_1.tabpage_1.width  - idw_r1.x - 10
idw_r1.height = tab_1.tabpage_1.height - idw_r1.y - 10

idw_r2.width  = tab_1.tabpage_2.width  - idw_r2.x - 10
idw_r2.height = tab_1.tabpage_2.height - idw_r2.y - 10


idw_r3.width  = tab_1.tabpage_3.width  - idw_r3.x - 10
idw_r3.height = tab_1.tabpage_3.height - idw_r3.y - 10

idw_r4.width  = tab_1.tabpage_4.width  - idw_r4.x - 10
idw_r4.height = tab_1.tabpage_4.height - idw_r4.y - 10

idw_r5.width  = tab_1.tabpage_5.width  - idw_r5.x - 10
idw_r5.height = tab_1.tabpage_5.height - idw_r5.y - 10

idw_r6.width  = tab_1.tabpage_6.width  - idw_r6.x - 10
idw_r6.height = tab_1.tabpage_6.height - idw_r6.y - 10
end event

event open;call super::open;of_Asigna_dws()

idw_rdefault = idw_r1

idw_rdefault.setFocus()
end event

event ue_saveas;call super::ue_saveas;idw_rdefault.EVENT ue_saveas()
end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_rdefault, ls_file )
End If
end event

event ue_saveas_pdf;call super::ue_saveas_pdf;string ls_path, ls_file
int li_rc
n_cst_email	lnv_email

ls_file = idw_rdefault.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnv_email = CREATE n_cst_email
	try
		if not lnv_email.of_create_pdf( idw_rdefault, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnv_email
		
	end try
	
End If
end event

event ue_filter_avanzado;call super::ue_filter_avanzado;if Not IsNull(idw_rdefault) and IsValid(idw_rdefault) then
	idw_rdefault.Event ue_filter_avanzado()
end if

end event

event ue_filter;call super::ue_filter;
if Not IsNull(idw_rdefault) and IsValid(idw_rdefault) then
	idw_rdefault.Event ue_filter()
end if


end event

event ue_mail_send;//Overriding
String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, ls_note, ls_path
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api
try
	ls_subject = THIS.Title
	ls_path = 'c:\report.html'
	ls_file = 'report.html'
	
	//lnv_mail.of_create_html(idw_1, ls_path)
	idw_rdefault.SaveAs(ls_path, HTMLTable!, True)
	
	lnv_mail.of_logon()
	lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
	lnv_mail.of_logoff()
	lnv_api.of_file_delete(ls_path)

catch(Exception ex)
	MessageBox('Error al intentar email', 'Exception: ' + ex.getMessage())
finally
	DESTROY lnv_mail
	DESTROY lnv_api	
end try

end event

event ue_print;call super::ue_print;idw_rdefault.EVENT ue_print()
end event

type em_descripcion from editmask within w_rh738_resumen_planilla
integer x = 759
integer y = 44
integer width = 983
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh738_resumen_planilla
integer x = 485
integer y = 44
integer width = 183
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_3 from statictext within w_rh738_resumen_planilla
integer x = 50
integer y = 60
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh738_resumen_planilla
integer x = 50
integer y = 136
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_desc_tipo_planilla from editmask within w_rh738_resumen_planilla
integer x = 759
integer y = 212
integer width = 983
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_tipo_planilla from commandbutton within w_rh738_resumen_planilla
integer x = 672
integer y = 212
integer width = 87
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabaj
Date		ld_fec_proceso

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error( "Debe especificar primero el origen. Por favor verifique!")
	em_origen.SetFocus()
	return
end if

ls_tipo_trabaj = trim(em_tipo.text) + '%'

ls_sql = "select distinct " &
		 + "       r.tipo_planilla as tipo_planilla, " &
		 + "       usp_sigre_rrhh.of_tipo_planilla(r.tipo_planilla) as desc_tipo_planilla " &
		 + "from rrhh_param_org r " &
		 + "where r.origen = '" + ls_origen + "'" &
		 + "  and r.tipo_trabajador like '" + ls_tipo_trabaj + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo_planilla.text = ls_codigo
	em_desc_tipo_planilla.text = ls_data
	


end if
end event

type em_tipo_planilla from editmask within w_rh738_resumen_planilla
integer x = 485
integer y = 212
integer width = 183
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "N"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

event modified;string ls_data, ls_tipo_planilla, ls_origen

ls_origen = em_origen.text

if IsNull(ls_origen) or trim(ls_origen) = '' then
	gnvo_app.of_message_error("Debe especificar un origen. Por favor verifique!")
	em_origen.setFocus()
	return
end if

ls_tipo_planilla = this.text

select usp_sigre_rrhh.of_tipo_planilla(:ls_tipo_planilla)
	into :ls_data
from dual;

em_desc_tipo_planilla.text = ls_data


end event

type st_tipo_planilla from statictext within w_rh738_resumen_planilla
integer x = 50
integer y = 220
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Tipo Planilla :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_rh738_resumen_planilla
integer x = 672
integer y = 128
integer width = 87
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen

ls_origen = trim(em_origen.text) + '%'

ls_sql = "SELECT distinct tt.TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "tt.DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador tt," &
		  + "     maestro			  m " &
		  + "WHERE m.tipo_Trabajador = tt.tipo_trabajador " &
		  + "  and m.cod_origen like '" + ls_origen + "'" &
		  + "  and m.flag_estado = '1'" &
		  + "  and tt.FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo.text = ls_codigo
	em_desc_tipo.text = ls_data
end if

end event

type em_tipo from editmask within w_rh738_resumen_planilla
integer x = 485
integer y = 128
integer width = 183
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh738_resumen_planilla
integer x = 759
integer y = 128
integer width = 983
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_1 from statictext within w_rh738_resumen_planilla
integer x = 1765
integer y = 48
integer width = 448
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_3 from commandbutton within w_rh738_resumen_planilla
integer x = 672
integer y = 44
integer width = 87
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_fec_proceso from editmask within w_rh738_resumen_planilla
integer x = 1765
integer y = 128
integer width = 448
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type gb_1 from groupbox within w_rh738_resumen_planilla
integer width = 3506
integer height = 304
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

type cb_1 from commandbutton within w_rh738_resumen_planilla
integer x = 2254
integer y = 44
integer width = 293
integer height = 172
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type tab_1 from tab within w_rh738_resumen_planilla
integer y = 344
integer width = 3360
integer height = 1704
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanged;of_asigna_dws()

if newindex = 1 then
	idw_r1.setFocus()
elseif newindex = 2 then
	idw_r2.setFocus()
elseif newindex = 3 then
	idw_r3.setFocus()
elseif newindex = 4 then
	idw_r4.setFocus()
elseif newindex = 5 then
	idw_r5.setFocus()	
end if
	
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3323
integer height = 1528
long backcolor = 79741120
string text = "Resumen ~r~nde planilla"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_rpt within tabpage_1
integer width = 3273
integer height = 1560
integer taborder = 90
string dataobject = "d_rpt_resumen_planilla_cmp"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_rdefault.BorderStyle = StyleRaised!
idw_rdefault = THIS
idw_rdefault.BorderStyle = StyleLowered!

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3323
integer height = 1528
long backcolor = 79741120
string text = "Resumen de ~r~nGanancias Variables"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_rpt within tabpage_2
integer width = 3273
integer height = 1560
string dataobject = "d_rpt_resumen_variables_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_rdefault.BorderStyle = StyleRaised!
idw_rdefault = THIS
idw_rdefault.BorderStyle = StyleLowered!

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3323
integer height = 1528
long backcolor = 79741120
string text = "Reporte de~r~nCuenta Corriente"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from u_dw_rpt within tabpage_3
integer width = 3273
integer height = 1560
string dataobject = "d_rpt_resumen_cuenta_crrte_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_rdefault.BorderStyle = StyleRaised!
idw_rdefault = THIS
idw_rdefault.BorderStyle = StyleLowered!

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3323
integer height = 1528
long backcolor = 79741120
string text = "Reporte de ~r~nDescuento Judicial"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from u_dw_rpt within tabpage_4
integer width = 3273
integer height = 1560
string dataobject = "d_rpt_resumen_judicial_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_rdefault.BorderStyle = StyleRaised!
idw_rdefault = THIS
idw_rdefault.BorderStyle = StyleLowered!

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3323
integer height = 1528
long backcolor = 79741120
string text = "Reporte de ~r~nDescuento RIMAC"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw_rpt within tabpage_5
integer width = 3273
integer height = 1560
string dataobject = "d_rpt_resumen_rimac_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_rdefault.BorderStyle = StyleRaised!
idw_rdefault = THIS
idw_rdefault.BorderStyle = StyleLowered!

end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 160
integer width = 3323
integer height = 1528
long backcolor = 79741120
string text = "Reporte de Descuento ~r~nPACIFICO VIDA"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from u_dw_rpt within tabpage_6
integer width = 3273
integer height = 1560
string dataobject = "d_rpt_resumen_pacifico_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_rdefault.BorderStyle = StyleRaised!
idw_rdefault = THIS
idw_rdefault.BorderStyle = StyleLowered!

end event

