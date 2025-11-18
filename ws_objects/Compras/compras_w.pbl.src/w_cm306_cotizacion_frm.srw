$PBExportHeader$w_cm306_cotizacion_frm.srw
forward
global type w_cm306_cotizacion_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_cm306_cotizacion_frm
end type
end forward

global type w_cm306_cotizacion_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3410
integer height = 1712
string title = "Formato de Cotizacion (CM306)"
string menuname = "m_impresion"
boolean resizable = false
long backcolor = 12632256
dw_report dw_report
end type
global w_cm306_cotizacion_frm w_cm306_cotizacion_frm

on w_cm306_cotizacion_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm306_cotizacion_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;
idw_1 = dw_report
idw_1.Visible = False
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;str_parametros lstr_rep
String ls_origen, ls_nro, ls_proveedor, ls_cotizo
String ls_dir, ls_tel, ls_ruc, ls_nom_empresa

lstr_rep 		= message.powerobjectparm
ls_origen 		= lstr_rep.string1
ls_nro 			= lstr_rep.string2
ls_proveedor 	= lstr_rep.string3

ls_dir = gnvo_app.of_direccion_origen(ls_origen)
ls_tel = f_telefono_empresa(ls_origen)



// Verifica si ya cotizo
//Select cotizo 
//	into :ls_cotizo 
//from cotizacion_provee 
// Where cod_origen = :ls_origen 
// 	and nro_cotiza = :ls_nro 
//	and proveedor = :ls_proveedor;
//
//if ls_cotizo = '1' then
//	idw_1.dataobject = "d_rpt_cotizacion_cab"
//else
//	idw_1.dataobject = "d_rpt_cotizacion_form"
//end if

idw_1.SetTransObject(sqlca)
idw_1.Retrieve(lstr_rep.string1, lstr_rep.string2, lstr_rep.string3, ls_dir, ls_tel)
idw_1.Visible = True

ls_dir = f_direccion_codrel(ls_proveedor)
ls_tel = f_telefono_codrel(ls_proveedor, 't')  // Numero de telefono
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_direccion_prov.text = ls_dir
idw_1.Object.t_telefono_prov.text 	= ls_tel

idw_1.Object.p_logo.filename  = gs_logo
idw_1.object.t_direccion.text = gnvo_app.of_direccion_origen(gs_origen)
idw_1.object.t_telefono.text  = f_telefono_empresa(gs_origen)
//idw_1.object.t_email.text  	= f_email_empresa(gs_origen)
idw_1.object.t_ruc.text 		= ls_ruc
idw_1.object.t_empresa.text	= ls_nom_empresa


ib_preview = false
this.event dynamic ue_preview()
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


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

type dw_report from u_dw_rpt within w_cm306_cotizacion_frm
integer y = 4
integer width = 3351
integer height = 1468
boolean bringtotop = true
string dataobject = "d_rpt_cotizacion_cab"
boolean hscrollbar = true
boolean vscrollbar = true
end type

