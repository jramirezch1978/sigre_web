$PBExportHeader$w_fi703_cntas_pagar_tesoreria.srw
forward
global type w_fi703_cntas_pagar_tesoreria from w_rpt
end type
type dw_reporte from u_dw_rpt within w_fi703_cntas_pagar_tesoreria
end type
type cb_reporte from commandbutton within w_fi703_cntas_pagar_tesoreria
end type
type st_1 from statictext within w_fi703_cntas_pagar_tesoreria
end type
type st_2 from statictext within w_fi703_cntas_pagar_tesoreria
end type
type em_year from editmask within w_fi703_cntas_pagar_tesoreria
end type
type ddlb_mes from dropdownlistbox within w_fi703_cntas_pagar_tesoreria
end type
type gb_1 from groupbox within w_fi703_cntas_pagar_tesoreria
end type
end forward

global type w_fi703_cntas_pagar_tesoreria from w_rpt
boolean visible = false
integer width = 3337
integer height = 2188
string title = "[FI703] Analisis detallado mensual de los medios de pago"
string menuname = "m_reporte"
boolean resizable = false
event ue_save_rep_sunat ( )
dw_reporte dw_reporte
cb_reporte cb_reporte
st_1 st_1
st_2 st_2
em_year em_year
ddlb_mes ddlb_mes
gb_1 gb_1
end type
global w_fi703_cntas_pagar_tesoreria w_fi703_cntas_pagar_tesoreria

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

event ue_save_rep_sunat();//string ls_path, ls_file
//int li_rc
//
//IF cbx_sunat.checked = FALSE THEN RETURN
//IF dw_export.rowcount() < 1 THEN RETURN
//
//li_rc = GetFileSaveName ( "Select File", &
//   ls_path, ls_file, "XLS", &
//   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)
//
//IF li_rc = 1 Then
//   uf_save_dw_as_excel ( dw_export, ls_file )
//End If
end event

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//

IF len(em_year.text) < 4 OR em_year.text = '0000' THEN 
	Messagebox('EL INGRESO DEL AÑO ESTA MAL','EL AÑO DEBE SER DE 4 DIGITOS')
	em_year.SetFocus()
	RETURN FALSE
END IF 

IF ddlb_mes.text = 'none' or IsNull(ddlb_mes.text) THEN
	Messagebox('EL INGRESO DEL MES ESTA MAL','EL MES DEBE SER DE 2 DIGITOS')
	ddlb_mes.SetFocus()
	RETURN FALSE
END IF	

RETURN TRUE
end function

on w_fi703_cntas_pagar_tesoreria.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_reporte=create dw_reporte
this.cb_reporte=create cb_reporte
this.st_1=create st_1
this.st_2=create st_2
this.em_year=create em_year
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_reporte
this.Control[iCurrent+2]=this.cb_reporte
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.em_year
this.Control[iCurrent+6]=this.ddlb_mes
this.Control[iCurrent+7]=this.gb_1
end on

on w_fi703_cntas_pagar_tesoreria.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_reporte)
destroy(this.cb_reporte)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.ddlb_mes)
destroy(this.gb_1)
end on

event ue_retrieve;Long   	ll_year, ll_mes
String	ls_nombre_mes

ll_year   = Long(em_year.text)
ll_mes    = Long(LEFT(ddlb_mes.text,2))


CHOOSE CASE trim(string(ll_mes, '00'))

	CASE '01'
		  ls_nombre_mes = '01 ENERO'
	CASE '02'
		  ls_nombre_mes = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes = '03 MARZO'
	CASE '04'
		  ls_nombre_mes = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes = '05 MAYO'
	CASE '06'
		  ls_nombre_mes = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes = '07 JULIO'
	CASE '08'
		  ls_nombre_mes = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes = '12 DICIEMBRE'
END CHOOSE
//--

dw_reporte.SetTransObject(SQLCA)

dw_reporte.object.p_logo.filename 		= gs_logo
dw_reporte.object.t_user.text     		= gs_user
dw_reporte.object.t_ano.text      		= string(ll_year, '0000')
dw_reporte.object.t_mes.text      		= ls_nombre_mes

dw_reporte.object.t_razon_social.text 	= gnvo_app.empresa.nombre()

dw_reporte.retrieve(ll_year, ll_mes)
	
dw_reporte.Object.DataWindow.Print.Paper.Size = 5
dw_reporte.Object.DataWindow.Print.Orientation = 1

//ib_preview = false
//event ue_preview()

end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10

end event

event ue_preview;call super::ue_preview;idw_1.ii_zoom_actual = 100
IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Registro de Compras " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Registro de Compras " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
Trigger Event ue_preview()

em_year.text = string(gnvo_app.of_fecha_actual(), 'yyyy')

/*idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
*/

ib_preview = true
THIS.Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

type dw_reporte from u_dw_rpt within w_fi703_cntas_pagar_tesoreria
integer y = 336
integer width = 3250
integer height = 1472
integer taborder = 30
string dataobject = "d_rpt_cntas_pagar_tesoreria_tbl"
boolean livescroll = false
end type

type cb_reporte from commandbutton within w_fi703_cntas_pagar_tesoreria
integer x = 1253
integer y = 48
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Event ue_retrieve()
end event

type st_1 from statictext within w_fi703_cntas_pagar_tesoreria
integer x = 41
integer y = 68
integer width = 210
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi703_cntas_pagar_tesoreria
integer x = 471
integer y = 68
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_fi703_cntas_pagar_tesoreria
integer x = 274
integer y = 56
integer width = 174
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_fi703_cntas_pagar_tesoreria
integer x = 704
integer y = 56
integer width = 517
integer height = 856
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_fi703_cntas_pagar_tesoreria
integer width = 3296
integer height = 308
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

