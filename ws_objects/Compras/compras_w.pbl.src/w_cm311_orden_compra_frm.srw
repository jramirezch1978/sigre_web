$PBExportHeader$w_cm311_orden_compra_frm.srw
forward
global type w_cm311_orden_compra_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_cm311_orden_compra_frm
end type
end forward

global type w_cm311_orden_compra_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3598
integer height = 2356
string title = "Formato de orden de compra (CM311)"
string menuname = "m_impresion"
dw_report dw_report
end type
global w_cm311_orden_compra_frm w_cm311_orden_compra_frm

type variables
String 			is_cod_origen, is_nro_oc
n_cst_wait		invo_wait
end variables

forward prototypes
public subroutine of_retrieve ()
end prototypes

public subroutine of_retrieve ();string 			ls_ruc, ls_nom_empresa, ls_empresa, ls_dua, ls_band, &
					ls_modify, ls_flag_importacion, ls_firma, ls_proveedor
decimal			ldc_insurance, ldc_freight, ldc_other
str_parametros	lstr_param					

istr_rep = message.powerobjectparm

is_cod_origen = istr_rep.string1
is_nro_oc     = istr_rep.string2


select 	NVL(flag_solicita_dua, '0'), NVL(flag_importacion, '0'), NVL(imp_insurance, '0'),
			NVL(imp_freight, '0'), NVL(imp_other, '0')
  into :ls_dua, :ls_flag_importacion, :ldc_insurance, :ldc_freight, :ldc_other
  from orden_compra
 where cod_origen = :is_cod_origen
   and nro_oc		= :is_nro_oc;

// Si es una importación entonces pide que seleccione un language
if ls_flag_importacion = '1' then
	Open(w_abc_select_language)
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.i_Return < 1 or lstr_param.language = -1 then 
		Post Event Close()
		return
	end if
	
	if lstr_param.language = 2 then
		
		dw_report.dataObject = 'd_rpt_orden_compra_eng_cab'
	
	else
	
		if gs_empresa = 'CANTABRIA' then
			dw_report.dataObject = 'd_rpt_orden_compra_cantabria_tbl'
		else
			dw_report.dataObject = 'd_rpt_orden_compra_esp_cab'
		end if

	end if
	

else
	if gs_empresa = 'CANTABRIA' then
		dw_report.dataObject = 'd_rpt_orden_compra_cantabria_tbl'
	else
		dw_report.dataObject = 'd_rpt_orden_compra_esp_cab'
	end if
	
end if

dw_report.SetTransObject(SQLCA)
ib_preview = false
this.Event ue_preview()

ls_nom_empresa = gnvo_app.empresa.nombre()
ls_ruc			= gnvo_app.empresa.ruc()

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc
	
dw_report.Retrieve(is_cod_origen, is_nro_oc)

if dw_report.RowCount() > 0 then
	ls_proveedor = dw_report.object.proveedor[1]

	idw_1 = dw_report
	idw_1.ii_zoom_actual = 100
	idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))
	
	idw_1.Visible = True
	idw_1.Object.p_logo.filename  = gs_logo
	idw_1.object.t_direccion.text = gnvo_app.of_direccion_origen(is_cod_origen)
	idw_1.object.t_telefono.text  = gnvo_app.empresa.of_telefono(is_cod_origen)
	
	
	if dw_report.RowCount() > 0 then
		idw_1.object.t_email.text  	= gnvo_app.empresa.of_email(is_cod_origen, dw_report.object.cod_usr[1])
	else
		idw_1.object.t_email.text  	= ""
	end if
	
	idw_1.object.t_ruc.text 		= ls_ruc
	idw_1.object.t_empresa.text	= ls_nom_empresa
	
	try
		idw_1.object.t_telefono_prov.text 	= gnvo_app.logistica.of_telefono(ls_proveedor, 't')
		//ls_modify = "t_telefono_prov.Text='" + f_telefono_codrel(idw_1.object.proveedor[dw_report.getrow()], 't') + "'" 
		//dw_report.Modify(ls_modify) 
	catch (exception ex)
	end try
	
	if ls_dua = '1' then
		idw_1.object.t_dua.text = 'ADJUNTAR DUA DE IMPORTACION CON SU FACTURA COMERCIAL ' &
			+ '~r~n(no se recibirá la factura sino se adjunta el documento mencionado)'
	else
		ls_band = idw_1.Object.t_dua.Band
		idw_1.Modify( "DataWindow." + ls_band + ".Height	='0'")
	end if
	
//	if idw_1.RowCount() > 0 then
//		idw_1.object.t_subtotal.text 		= string(istr_rep.d_datos[1], '###,##0.00')
//		idw_1.object.t_descuento.text 	= string(istr_rep.d_datos[2], '###,##0.00')
//		idw_1.object.t_valor_neto.text 	= string(istr_rep.d_datos[5] + ldc_insurance + ldc_freight + ldc_other, '###,##0.00')
//		
//		if ls_flag_importacion = '0' then
//			idw_1.object.t_isc.text 	= string(istr_rep.d_datos[3], '###,##0.00')
//			idw_1.object.t_percepcion.text 	= string(istr_rep.d_datos[4], '###,##0.00')
//		end if
//	end if
	
	// Firmas
	if idw_1.of_existspicturename( "p_firma" ) and idw_1.RowCount() > 0 then
		
		ls_firma = gnvo_app.logistica.of_get_firma(gnvo_app.is_empresas_inifile, idw_1.object.cod_usr [1])
		if FileExists(ls_firma) then
			idw_1.Object.p_firma.filename  = ls_firma
		end if
		
	end if
	
	// Firmas
	if idw_1.of_existspicturename( "p_aprobador1" ) and idw_1.RowCount() > 0 then
		
		ls_firma = gnvo_app.logistica.of_get_firma(idw_1.object.aprobador1 [1])
		if FileExists(ls_firma) then
			idw_1.Object.p_aprobador1.filename  = ls_firma
		end if
		
	end if
	if idw_1.of_existspicturename( "p_aprobador2" ) and idw_1.RowCount() > 0 then
		
		ls_firma = gnvo_app.logistica.of_get_firma(idw_1.object.aprobador2 [1])
		if FileExists(ls_firma) then
			idw_1.Object.p_aprobador2.filename  = ls_firma
		end if
		
	end if
	
	//Agente de Retención
	if gnvo_app.is_agente_ret = '0' then
		if lstr_param.language = 1 then //or not gnvo_app.logistica.of_retencion_igv(ls_proveedor) then
			idw_1.object.t_importante7.visible = '0'
		end if
	end if
	
end if	

end subroutine

on w_cm311_orden_compra_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm311_orden_compra_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;invo_wait = create n_cst_wait

idw_1 = dw_report
//idw_1.Visible = False
idw_1.SetTransObject(sqlca)

ib_preview = false
this.Event ue_preview()

This.Event ue_retrieve()

if istr_rep.b_EnvioEmail = true then
	this.visible = false
	this.Post event ue_mail_send( )
end if

// ii_help = 101           // help topic


end event

event ue_retrieve;string 			ls_ruc, ls_nom_empresa, ls_empresa, ls_dua, ls_band, &
					ls_modify, ls_flag_importacion, ls_firma, ls_proveedor, &
					ls_usuario, ls_aprobador
decimal			ldc_insurance, ldc_freight, ldc_other
str_parametros	lstr_param					

istr_rep = message.powerobjectparm

is_cod_origen = istr_rep.string1
is_nro_oc     = istr_rep.string2


select 	NVL(flag_solicita_dua, '0'), NVL(flag_importacion, '0'), NVL(imp_insurance, '0'),
			NVL(imp_freight, '0'), NVL(imp_other, '0')
  into :ls_dua, :ls_flag_importacion, :ldc_insurance, :ldc_freight, :ldc_other
  from orden_compra
 where cod_origen = :is_cod_origen
   and nro_oc		= :is_nro_oc;

// Si es una importación entonces pide que seleccione un language
if ls_flag_importacion = '1' then
	Open(w_abc_select_language)
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.i_Return < 1 or lstr_param.language = -1 then 
		Post Event Close()
		return
	end if
	
	if lstr_param.language = 2 then
		
		dw_report.dataObject = 'd_rpt_orden_compra_eng_cab'
	
	else
	
		if gs_empresa = 'CANTABRIA' then
			dw_report.dataObject = 'd_rpt_orden_compra_cantabria_tbl'
		elseif gs_empresa = 'VITAL_SAC' or gs_empresa = 'OCEAN_SAC' or gs_empresa = 'GACELA_SAC'then
			dw_report.dataObject = 'd_rpt_orden_compra_vital_tbl'
		else
			dw_report.dataObject = 'd_rpt_orden_compra_esp_cab'
		end if

	end if
	

else
	if gs_empresa = 'CANTABRIA' then
		dw_report.dataObject = 'd_rpt_orden_compra_cantabria_tbl'
	elseif gs_empresa = 'VITAL_SAC' or gs_empresa = 'OCEAN_SAC' or gs_empresa = 'GACELA_SAC'then
		dw_report.dataObject = 'd_rpt_orden_compra_vital_tbl'
	else
		dw_report.dataObject = 'd_rpt_orden_compra_esp_cab'
	end if
	
end if

dw_report.SetTransObject(SQLCA)
ib_preview = false
this.Event ue_preview()

ls_nom_empresa = gnvo_app.empresa.nombre()
ls_ruc			= gnvo_app.empresa.ruc()

if not ISNULL( ls_ruc ) then  ls_ruc = 'RUC:' + ls_ruc
	
dw_report.Retrieve(is_cod_origen, is_nro_oc)

if dw_report.RowCount() > 0 then
	ls_proveedor 	= dw_report.object.proveedor	[1]
	ls_usuario 		= dw_report.object.cod_usr		[1]
	
	if dw_report.of_ExisteCampo('aprobador') then
		ls_aprobador	= dw_report.object.aprobador	[1]
	end if

	idw_1 = dw_report
	idw_1.ii_zoom_actual = 100
	idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))
	
	idw_1.Visible = True
	idw_1.Object.p_logo.filename  = gs_logo
	idw_1.object.t_direccion.text = gnvo_app.of_direccion_origen(is_cod_origen)
	idw_1.object.t_telefono.text  = gnvo_app.empresa.of_telefono(is_cod_origen)
	
	
	if dw_report.RowCount() > 0 then
		idw_1.object.t_email.text  	= gnvo_app.empresa.of_email(is_cod_origen, dw_report.object.cod_usr[1])
	else
		idw_1.object.t_email.text  	= ""
	end if
	
	idw_1.object.t_ruc.text 		= ls_ruc
	idw_1.object.t_empresa.text	= ls_nom_empresa
	
	try
		idw_1.object.t_telefono_prov.text 	= gnvo_app.logistica.of_telefono(ls_proveedor, 't')
		//ls_modify = "t_telefono_prov.Text='" + f_telefono_codrel(idw_1.object.proveedor[dw_report.getrow()], 't') + "'" 
		//dw_report.Modify(ls_modify) 
	catch (exception ex)
		
	end try
	
	if ls_dua = '1' then
		idw_1.object.t_dua.text = 'ADJUNTAR DUA DE IMPORTACION CON SU FACTURA COMERCIAL ' &
			+ '~r~n(no se recibirá la factura sino se adjunta el documento mencionado)'
	else
		ls_band = idw_1.Object.t_dua.Band
		idw_1.Modify( "DataWindow." + ls_band + ".Height	='0'")
	end if
	
//	if idw_1.RowCount() > 0 then
//		idw_1.object.t_subtotal.text 		= string(istr_rep.d_datos[1], '###,##0.00')
//		idw_1.object.t_descuento.text 	= string(istr_rep.d_datos[2], '###,##0.00')
//		idw_1.object.t_valor_neto.text 	= string(istr_rep.d_datos[5] + ldc_insurance + ldc_freight + ldc_other, '###,##0.00')
//		
//		if ls_flag_importacion = '0' then
//			idw_1.object.t_impuesto1.text 	= string(istr_rep.d_datos[3], '###,##0.00')
//			idw_1.object.t_impuesto2.text 	= string(istr_rep.d_datos[4], '###,##0.00')
//		end if
//	end if
	
	// Firmas
	if idw_1.of_existspicturename( "p_firma" ) then
		
		ls_firma = gnvo_app.logistica.of_get_firma_usuario(gs_inifile, ls_usuario)
		
		if Not IsNull(ls_firma) and trim(ls_firma) <> '' then
			if FileExists(ls_firma) then
				idw_1.Object.p_firma.filename  = ls_firma
			else
				MessageBox("Error",  "El archivo " + ls_firma + " no existe. Por Favor verifique!", StopSign! )
			end if
		end if
		
		
	end if
	
	// Firmas
	if idw_1.of_existspicturename( "p_aprobador1" ) then
		
		ls_firma = gnvo_app.logistica.of_get_firma(idw_1.object.aprobador1 [1])
		
		if Not IsNull(ls_firma) and trim(ls_firma) <> '' then
			if FileExists(ls_firma) then
				idw_1.Object.p_aprobador1.filename  = ls_firma
			else
				MessageBox ("Error", "El archivo " + ls_firma + " no existe. Por Favor verifique!", StopSign!)
			end if
		end if
		
		
		
	end if
	if idw_1.of_existspicturename( "p_aprobador2" ) and idw_1.RowCount() > 0 then
		
		ls_firma = gnvo_app.logistica.of_get_firma(idw_1.object.aprobador2 [1])
		if FileExists(ls_firma) then
			idw_1.Object.p_aprobador2.filename  = ls_firma
		else
			invo_wait.of_mensaje ( "El archivo " + ls_firma + " no existe. Por Favor verifique!" )
		end if
		
	end if
	
	if idw_1.of_existspicturename( "p_firma_autorizado" ) then
		
		ls_firma = gnvo_app.logistica.of_get_firma_autorizado(gs_inifile, ls_aprobador)
		
		if Not IsNull(ls_firma) and trim(ls_firma) <> '' then
			if FileExists(ls_firma) then
				idw_1.Object.p_firma_autorizado.filename  = ls_firma
				invo_wait.of_mensaje ( "El archivo " + ls_firma + " ha sido asignado satisfactoriamente." )
			else
				MessageBox("Error", "El archivo " + ls_firma + " no existe. Por Favor verifique!", StopSign!)
			end if
		end if
		
		
	end if

	//Agente de Retención
	if gnvo_app.is_agente_ret = '0' then
		//if lstr_param.language = 1 then //or not gnvo_app.logistica.of_retencion_igv(ls_proveedor) then
		idw_1.object.t_importante7.visible = '0'
		//end if
	end if
	
end if	

invo_Wait.of_close()

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
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

event ue_mail_send;str_parametros lstr_rep

IF dw_report.getrow() > 0 THEN
	lstr_rep.subject = 'Sirvase atender la Orden de compra Nro : ' &
						  + dw_report.object.nro_oc		[dw_report.getrow()]
	lstr_rep.dw_report = dw_report
	lstr_rep.s_proveedor = dw_report.object.proveedor	[dw_report.getrow()]
	
	openWithParm (w_preview_email, lstr_rep)
	
	if Not IsNull(Message.Powerobjectparm) and IsValid(Message.PowerObjectparm) then
		if message.powerobjectparm.classname( ) = 'str_parametros' then
				lstr_rep = Message.Powerobjectparm
				
				if lstr_rep.titulo = 's' and istr_rep.b_EnvioEmail then 
					close(this)
				end if
		end if
	end if
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

event close;call super::close;destroy invo_wait
end event

type dw_report from u_dw_rpt within w_cm311_orden_compra_frm
integer width = 3470
integer height = 2028
boolean bringtotop = true
string dataobject = "d_rpt_orden_compra_esp_cab"
end type

