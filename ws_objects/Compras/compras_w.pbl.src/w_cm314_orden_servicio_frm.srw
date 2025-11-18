$PBExportHeader$w_cm314_orden_servicio_frm.srw
forward
global type w_cm314_orden_servicio_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_cm314_orden_servicio_frm
end type
end forward

global type w_cm314_orden_servicio_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1680
string title = "Formato de orden de servicio (CM314)"
string menuname = "m_impresion"
dw_report dw_report
end type
global w_cm314_orden_servicio_frm w_cm314_orden_servicio_frm

type variables
n_cst_wait invo_wait
end variables

on w_cm314_orden_servicio_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm314_orden_servicio_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;invo_wait = create n_cst_Wait
idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String 	ls_cod_origen, ls_nro_os, ls_acta, ls_band,  ls_nom_empresa, &
			ls_ruc, ls_firma, ls_proveedor, ls_aprobador, ls_usuario

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_cod_origen = lstr_rep.string1
ls_nro_os     = lstr_rep.string2

select NVL(flag_solicita_acta,'0')
	into :ls_acta
from orden_servicio
where nro_os = :ls_nro_os;

ls_nom_empresa = gnvo_app.empresa.nombre()
ls_ruc			= gnvo_app.empresa.ruc()

if gs_empresa = 'CANTABRIA' then
	dw_report.dataObject = 'd_rpt_orden_servicio_cantabria_tbl'
else
	dw_report.dataObject = 'd_rpt_orden_servicio'
end if

idw_1.Object.p_logo.filename  = gs_logo

idw_1.object.t_direccion.text = gnvo_app.of_direccion_origen(ls_cod_origen)
idw_1.object.t_telefono.text  = gnvo_app.empresa.of_telefono(ls_cod_origen)

dw_report.SetTransObject(SQLCA)
ib_preview = false
this.Event ue_preview()

idw_1.Retrieve(ls_cod_origen, ls_nro_os)
idw_1.object.DataWindow.Print.Paper.Size = 9 //A4
idw_1.Visible = True


if dw_report.RowCount() > 0 then
	idw_1.object.t_email.text  	= gnvo_app.empresa.of_email(ls_cod_origen, dw_report.object.cod_usr[1])
else
	idw_1.object.t_email.text  	= ""
end if

idw_1.object.t_ruc.text 		= ls_ruc
	
IF idw_1.RowCount() > 0 then
	ls_proveedor 	= dw_report.object.proveedor	[1]
	ls_usuario	 	= dw_report.object.cod_usr		[1]
	
	if dw_report.of_ExisteCampo('aprobador') then
		ls_aprobador	= dw_report.object.aprobador	[1]
	end if
	
	idw_1.object.t_empresa.text	= ls_nom_empresa
	
	if ls_acta = '1' then
		idw_1.object.t_acta.text = 'ADJUNTAR ACTA DE CONFORMIDAD CON SU FACTURA COMERCIAL ' &
			+ '~r~n(no se recibirá la factura sino se adjunta el documento mencionado)'
	else
		ls_band = idw_1.Object.t_acta.Band
		//MessageBox('', ls_band)
		idw_1.Modify( "DataWindow." + ls_band + ".Height	='180'")
	end if

	// Firmas
	if idw_1.of_existspicturename( "p_firma" ) then
		
		ls_firma = gnvo_app.logistica.of_get_firma_usuario(gs_inifile, ls_usuario)
		
		if Not IsNull(ls_firma) and trim(ls_firma) <> '' then
			if FileExists(ls_firma) then
				idw_1.Object.p_firma.filename  = ls_firma
				invo_wait.of_mensaje ( "El archivo " + ls_firma + " ha sido asignado satisfactoriamente." )
				
				invo_wait.of_close()
				
			else
				MessageBox ("Error", "El archivo " + ls_firma + " no existe. Por Favor verifique!", StopSign! )
			end if
		end if
	end if
	
	
	if idw_1.of_existspicturename( "p_firma_autorizado" ) then
		
		ls_firma = gnvo_app.logistica.of_get_firma_autorizado(gs_inifile, ls_aprobador)
		
		if Not IsNull(ls_firma) and trim(ls_firma) <> '' then
			if FileExists(ls_firma) then
				idw_1.Object.p_firma_autorizado.filename  = ls_firma
				invo_wait.of_mensaje ( "El archivo " + ls_firma + " ha sido asignado satisfactoriamente." )
				
				invo_wait.of_close()
				
			else
				MessageBox ("Error", "El archivo " + ls_firma + " no existe. Por Favor verifique!", StopSign! )
			end if
		
		end if
		
	end if
	
	try
		idw_1.object.t_tel_prov.text 	= gnvo_app.logistica.of_telefono(ls_proveedor, 't')
		//ls_modify = "t_telefono_prov.Text='" + f_telefono_codrel(idw_1.object.proveedor[dw_report.getrow()], 't') + "'" 
		//dw_report.Modify(ls_modify) 
	catch (exception ex)
	end try
end if


end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event close;call super::close;destroy invo_Wait
end event

type dw_report from u_dw_rpt within w_cm314_orden_servicio_frm
integer width = 3273
integer height = 1424
boolean bringtotop = true
string dataobject = "d_rpt_orden_servicio"
end type

