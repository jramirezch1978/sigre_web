$PBExportHeader$w_cam715_rpt_formato_credito.srw
forward
global type w_cam715_rpt_formato_credito from w_report_smpl
end type
type pb_1 from picturebutton within w_cam715_rpt_formato_credito
end type
type sle_proveedor from singlelineedit within w_cam715_rpt_formato_credito
end type
type st_nom_proveedor from statictext within w_cam715_rpt_formato_credito
end type
type sle_tipo_doc from singlelineedit within w_cam715_rpt_formato_credito
end type
type sle_nro_doc from singlelineedit within w_cam715_rpt_formato_credito
end type
type st_1 from statictext within w_cam715_rpt_formato_credito
end type
end forward

global type w_cam715_rpt_formato_credito from w_report_smpl
integer width = 3465
integer height = 1820
string title = "[CAM715] Reporte de Crédito"
string menuname = "m_rpt_smpl"
event ue_query_retrieve ( )
pb_1 pb_1
sle_proveedor sle_proveedor
st_nom_proveedor st_nom_proveedor
sle_tipo_doc sle_tipo_doc
sle_nro_doc sle_nro_doc
st_1 st_1
end type
global w_cam715_rpt_formato_credito w_cam715_rpt_formato_credito

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_cam715_rpt_formato_credito.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.pb_1=create pb_1
this.sle_proveedor=create sle_proveedor
this.st_nom_proveedor=create st_nom_proveedor
this.sle_tipo_doc=create sle_tipo_doc
this.sle_nro_doc=create sle_nro_doc
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.sle_proveedor
this.Control[iCurrent+3]=this.st_nom_proveedor
this.Control[iCurrent+4]=this.sle_tipo_doc
this.Control[iCurrent+5]=this.sle_nro_doc
this.Control[iCurrent+6]=this.st_1
end on

on w_cam715_rpt_formato_credito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.sle_proveedor)
destroy(this.st_nom_proveedor)
destroy(this.sle_tipo_doc)
destroy(this.sle_nro_doc)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_tipo_doc, ls_nro_doc

ls_tipo_doc = sle_tipo_doc.text
ls_nro_doc = sle_nro_doc.text

if sle_proveedor.text = '' then
	MessageBox("Aviso", "Debe Seleccionar un Crédito")
	return
end if

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9

//Previes
ib_preview = false
this.event ue_preview( )

//Recuperar los datos
dw_report.settransobject( sqlca )
dw_report.retrieve(ls_tipo_doc, ls_nro_doc)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.empresa_t.text = gs_empresa
dw_report.object.t_fecha.text = string(f_fecha_actual())
dw_report.object.t_usr.text = gs_user

end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If

//string 		ls_separador, ls_origen, ls_file, ls_path, ls_especie, ls_ot_adm
//long			ll_i, ll_rc
//date 			ld_ini, ld_fin
//
//u_ds_base	lds_datos
//u_ds_base	lds_datos_1
//
//ld_ini = uo_rango.of_get_fecha1( )
//ld_fin = uo_rango.of_get_fecha2( )
//
//ls_ot_adm = trim(em_ot_adm_n.text)
//
//if isnull(ls_ot_adm) or trim(ls_ot_adm) = '' then
//
//lds_datos 				= create u_ds_base
//lds_datos.Dataobject = 'd_jornal_horas_resumen_ctb'
//lds_datos.SetTransObject(SQLCA)
//
//lds_datos.Retrieve(gs_user, gs_origen, ld_ini, ld_fin)
//
//if lds_datos.RowCount() = 0 then
//	MessageBox('Error', 'No hay datos para exportar')
//	destroy lds_datos
//	return
//end if
//
//ll_rc = GetFileSaveName ( "Grabar Archivo", ls_path, ls_file, 'XLS', &
//    'XLS Files (*.XLS), *.XLS', "C:\",  32770)
// 
//IF ll_rc <> 1 Then
//	return
//End If
//
//ll_rc = lds_datos.SaveAs(ls_path, Excel!, TRUE)
//
//if ll_rc = -1 then
//	MessageBox('Error', 'Ha ocurrido un error al exportar los datos a excel')
//	destroy lds_datos
//	return
//end if
//destroy lds_datos
//
//else
//
//lds_datos_1 				= create u_ds_base
//lds_datos_1.Dataobject = 'd_jornal_horas_resumen_otadm_ctb'
//lds_datos_1.SetTransObject(SQLCA)
//ls_origen = right(ls_ot_adm,2)
//
//lds_datos_1.Retrieve(ls_ot_adm, ls_origen, ld_ini, ld_fin)
//
//if lds_datos_1.RowCount() = 0 then
//	MessageBox('Error', 'No hay datos para exportar')
//	destroy lds_datos_1
//	return
//end if
//
//ll_rc = GetFileSaveName ( "Grabar Archivo", ls_path, ls_file, 'XLS', &
//    'XLS Files (*.XLS), *.XLS', "C:\",  32770)
// 
//IF ll_rc <> 1 Then
//	return
//End If
//
//ll_rc = lds_datos_1.SaveAs(ls_path, Excel!, TRUE)
//
//if ll_rc = -1 then
//	MessageBox('Error', 'Ha ocurrido un error al exportar los datos a excel')
//	destroy lds_datos_1
//	return
//end if
//destroy lds_datos_1
//
//end if
//
end event

type dw_report from w_report_smpl`dw_report within w_cam715_rpt_formato_credito
integer x = 0
integer y = 244
integer width = 3337
integer height = 1244
integer taborder = 10
string dataobject = "d_rpt_credito_tbl"
string is_dwform = ""
end type

type pb_1 from picturebutton within w_cam715_rpt_formato_credito
integer x = 3022
integer y = 24
integer width = 329
integer height = 176
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
boolean map3dcolors = true
end type

event clicked;parent.event ue_retrieve()
end event

type sle_proveedor from singlelineedit within w_cam715_rpt_formato_credito
event dobleclick pbm_lbuttondblclk
integer x = 489
integer y = 8
integer width = 357
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_data2, ls_data3, ls_sql

ls_sql = "select p.proveedor as cod_productor , p.nom_proveedor as nom_productor,  " &
	+ " ccd.tipo_doc_cxp as tipo_doc, ccd.nro_doc_cxp as nro_doc, ccd.monto_prestamo as monto_prestamo, " &
     + " cc.fec_prestamo as fec_prestamo,  cc.observaciones  as observacion" &
	+ "   from  cam_creditos_det ccd, " &
      + "   cam_creditos        cc, " &
       + "  proveedor p " &
	+ "   where ccd.proveedor   = p.proveedor " &
   + "  and ccd.nro_credito = cc.nro_credito " &
	+ " and cc.flag_estado <> '0' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_nom_proveedor.text = ls_data
	sle_tipo_doc.text = ls_data2
	sle_nro_doc.text = ls_data3
end if
end event

type st_nom_proveedor from statictext within w_cam715_rpt_formato_credito
integer x = 864
integer y = 8
integer width = 1285
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type sle_tipo_doc from singlelineedit within w_cam715_rpt_formato_credito
integer x = 654
integer y = 124
integer width = 192
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217732
boolean displayonly = true
end type

type sle_nro_doc from singlelineedit within w_cam715_rpt_formato_credito
integer x = 864
integer y = 124
integer width = 599
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217732
boolean displayonly = true
end type

type st_1 from statictext within w_cam715_rpt_formato_credito
integer x = 69
integer y = 8
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Productor "
alignment alignment = right!
boolean border = true
long bordercolor = 67108864
boolean focusrectangle = false
end type

