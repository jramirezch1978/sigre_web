$PBExportHeader$w_cam711_rpt_productor_base.srw
forward
global type w_cam711_rpt_productor_base from w_report_smpl
end type
type pb_1 from picturebutton within w_cam711_rpt_productor_base
end type
type cbx_1 from checkbox within w_cam711_rpt_productor_base
end type
type sle_base from singlelineedit within w_cam711_rpt_productor_base
end type
type st_desc_base from statictext within w_cam711_rpt_productor_base
end type
type cbx_2 from checkbox within w_cam711_rpt_productor_base
end type
type sle_prod from singlelineedit within w_cam711_rpt_productor_base
end type
type st_desc_prod from statictext within w_cam711_rpt_productor_base
end type
end forward

global type w_cam711_rpt_productor_base from w_report_smpl
integer width = 3465
integer height = 1820
string title = "[CAM711] Reporte de Productores y Bases"
string menuname = "m_rpt_smpl"
event ue_query_retrieve ( )
pb_1 pb_1
cbx_1 cbx_1
sle_base sle_base
st_desc_base st_desc_base
cbx_2 cbx_2
sle_prod sle_prod
st_desc_prod st_desc_prod
end type
global w_cam711_rpt_productor_base w_cam711_rpt_productor_base

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_cam711_rpt_productor_base.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.pb_1=create pb_1
this.cbx_1=create cbx_1
this.sle_base=create sle_base
this.st_desc_base=create st_desc_base
this.cbx_2=create cbx_2
this.sle_prod=create sle_prod
this.st_desc_prod=create st_desc_prod
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.sle_base
this.Control[iCurrent+4]=this.st_desc_base
this.Control[iCurrent+5]=this.cbx_2
this.Control[iCurrent+6]=this.sle_prod
this.Control[iCurrent+7]=this.st_desc_prod
end on

on w_cam711_rpt_productor_base.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.cbx_1)
destroy(this.sle_base)
destroy(this.st_desc_base)
destroy(this.cbx_2)
destroy(this.sle_prod)
destroy(this.st_desc_prod)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_base, ls_prod


If cbx_1.Checked Then
	ls_base = '%'
Else
	ls_base = trim(sle_base.text)+'%'
End If 

If cbx_2.Checked Then
	ls_prod = '%'
Else
	ls_prod = trim(sle_prod.text)+'%'
End If 

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9

//Previes
ib_preview = false
this.event ue_preview( )

//Recuperar los datos
dw_report.settransobject( sqlca )
dw_report.retrieve(ls_base, ls_prod)
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

type dw_report from w_report_smpl`dw_report within w_cam711_rpt_productor_base
integer x = 0
integer y = 244
integer width = 3337
integer height = 1244
integer taborder = 10
string dataobject = "d_rpt_prov_base_tbl"
string is_dwform = ""
end type

type pb_1 from picturebutton within w_cam711_rpt_productor_base
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

type cbx_1 from checkbox within w_cam711_rpt_productor_base
integer x = 50
integer y = 20
integer width = 663
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
string text = "Todos las Bases"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_base.enabled = false
	sle_base.text = ''
	st_desc_base.text = ''
Else
	sle_base.enabled = true
End If
end event

type sle_base from singlelineedit within w_cam711_rpt_productor_base
event dobleclick pbm_lbuttondblclk
integer x = 923
integer y = 20
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
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT ap.cod_base AS COD_BASE, " &
			+ " ap.desc_base AS DESCRIPCION_BASE " &
			+ "FROM ap_bases ap " &
			+ "WHERE ap.flag_estado = '1' "

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_base.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc, ls_var

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar Un Beneficiario')
	return
end if

	SELECT ap.desc_base 
	  INTO :ls_desc
       FROM ap_bases ap
       WHERE ap.flag_estado = '1' AND
		 ap.cod_base = :ls_codigo ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Beneficiario no existe o no está activo')
	return
end if

st_desc_base.text = ls_desc
end event

type st_desc_base from statictext within w_cam711_rpt_productor_base
integer x = 1298
integer y = 20
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

type cbx_2 from checkbox within w_cam711_rpt_productor_base
integer x = 50
integer y = 108
integer width = 658
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
string text = "Todos los Productores"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_prod.enabled = false
	sle_prod.text = ''
	st_desc_prod.text = ''
Else
	sle_prod.enabled = true
End If
end event

type sle_prod from singlelineedit within w_cam711_rpt_productor_base
event dobleclick pbm_lbuttondblclk
integer x = 923
integer y = 108
integer width = 357
integer height = 80
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT apm.proveedor AS COD_PRODUCTOR, " &
		+ " p.nom_proveedor AS NOMBRE_PRODUCTOR" &
		+ " FROM ap_proveedor_mp apm, " &
		+ "   proveedor p " &
			+ " WHERE apm.proveedor = p.proveedor  " &
			+ " ORDER BY p.nom_proveedor "
           
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_prod.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un Código de Productor')
	return
end if

SELECT p.nom_proveedor
	INTO :ls_desc
       FROM ap_proveedor_mp apm,
            proveedor p
       WHERE apm.proveedor = p.proveedor
       ORDER BY p.nom_proveedor;
				
IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Productor no existe o no está activo')
	return
end if

st_desc_prod.text = ls_desc
end event

type st_desc_prod from statictext within w_cam711_rpt_productor_base
integer x = 1298
integer y = 108
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

