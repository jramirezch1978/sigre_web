$PBExportHeader$w_fi728_pagos_serv_financ.srw
forward
global type w_fi728_pagos_serv_financ from w_rpt
end type
type sle_confin from singlelineedit within w_fi728_pagos_serv_financ
end type
type st_1 from statictext within w_fi728_pagos_serv_financ
end type
type uo_fechas from u_ingreso_rango_fechas within w_fi728_pagos_serv_financ
end type
type dw_reporte from u_dw_rpt within w_fi728_pagos_serv_financ
end type
type cb_1 from commandbutton within w_fi728_pagos_serv_financ
end type
type gb_1 from groupbox within w_fi728_pagos_serv_financ
end type
end forward

global type w_fi728_pagos_serv_financ from w_rpt
boolean visible = false
integer width = 3337
integer height = 2188
string title = "[FI728] Reporte Pagos Servicio Financiero"
string menuname = "m_reporte"
boolean resizable = false
event ue_save_rep_sunat ( )
sle_confin sle_confin
st_1 st_1
uo_fechas uo_fechas
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_fi728_pagos_serv_financ w_fi728_pagos_serv_financ

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

event ue_save_rep_sunat();string ls_path, ls_file
int li_rc


IF dw_reporte.rowcount() < 1 THEN RETURN

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_reporte, ls_file )
End If
end event

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//

//IF len(em_year.text) < 4 OR em_year.text = '0000' THEN 
//	Messagebox('EL INGRESO DEL AÑO ESTA MAL','EL AÑO DEBE SER DE 4 DIGITOS')
//	em_year.SetFocus()
//	RETURN FALSE
//END IF 
//
//IF ddlb_mes.text = 'none' or IsNull(ddlb_mes.text) THEN
//	Messagebox('EL INGRESO DEL MES ESTA MAL','EL MES DEBE SER DE 2 DIGITOS')
//	ddlb_mes.SetFocus()
//	RETURN FALSE
//END IF	

RETURN TRUE
end function

on w_fi728_pagos_serv_financ.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_confin=create sle_confin
this.st_1=create st_1
this.uo_fechas=create uo_fechas
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_confin
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_fechas
this.Control[iCurrent+4]=this.dw_reporte
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.gb_1
end on

on w_fi728_pagos_serv_financ.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_confin)
destroy(this.st_1)
destroy(this.uo_fechas)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;String 	ls_mensaje, ls_confin
Date		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

ls_confin = sle_confin.text

dw_reporte.setTransObject(SQLCA)


dw_reporte.object.p_logo.filename 		= gs_logo
dw_reporte.object.t_user.text     		= gs_user

dw_reporte.retrieve(ld_Fecha1, ld_Fecha2, ls_confin)

dw_reporte.Object.DataWindow.Print.Paper.Size = 5
dw_reporte.Object.DataWindow.Print.Orientation = 1


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

event ue_open_pre;call super::ue_open_pre;try 
	
	idw_1 = dw_reporte
	Trigger Event ue_preview()
	
	
	sle_confin.text = gnvo_app.of_get_parametro('FIN_CONFIN_COMISION_BANCARIA', 'FI-548')
	
	/*idw_1 = dw_report
	idw_1.Visible = False
	idw_1.SetTransObject(sqlca)
	*/
	
	ib_preview = true
	THIS.Event ue_preview()
	//This.Event ue_retrieve()
	
	// ii_help = 101           // help topic

catch ( Exception ex )
	gnvo_app.of_Catch_exception(ex, 'Error en event ue_open_pre')
finally
	/*statementBlock*/
end try



end event

type sle_confin from singlelineedit within w_fi728_pagos_serv_financ
integer x = 521
integer y = 180
integer width = 343
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi728_pagos_serv_financ
integer x = 64
integer y = 188
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Concepto Finan. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_fi728_pagos_serv_financ
event destroy ( )
integer x = 64
integer y = 80
integer taborder = 50
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual())

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy)
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type dw_reporte from u_dw_rpt within w_fi728_pagos_serv_financ
integer y = 292
integer width = 3250
integer height = 1472
integer taborder = 30
string dataobject = "d_rpt_pagos_serfin_tbl"
boolean livescroll = false
end type

type cb_1 from commandbutton within w_fi728_pagos_serv_financ
integer x = 2917
integer y = 44
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

type gb_1 from groupbox within w_fi728_pagos_serv_financ
integer width = 3296
integer height = 280
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtros"
end type

