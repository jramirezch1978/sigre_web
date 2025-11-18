$PBExportHeader$w_cam710_rpt_gen_credito.srw
forward
global type w_cam710_rpt_gen_credito from w_report_smpl
end type
type st_1 from statictext within w_cam710_rpt_gen_credito
end type
type uo_rango from u_ingreso_rango_fechas within w_cam710_rpt_gen_credito
end type
type pb_1 from picturebutton within w_cam710_rpt_gen_credito
end type
type cbx_1 from checkbox within w_cam710_rpt_gen_credito
end type
type sle_tipo_cred from singlelineedit within w_cam710_rpt_gen_credito
end type
type st_desc_tipo_cred from statictext within w_cam710_rpt_gen_credito
end type
type cbx_2 from checkbox within w_cam710_rpt_gen_credito
end type
type sle_benef from singlelineedit within w_cam710_rpt_gen_credito
end type
type st_desc_benef from statictext within w_cam710_rpt_gen_credito
end type
type cbx_3 from checkbox within w_cam710_rpt_gen_credito
end type
type sle_prod from singlelineedit within w_cam710_rpt_gen_credito
end type
type st_desc_prod from statictext within w_cam710_rpt_gen_credito
end type
type rb_1 from radiobutton within w_cam710_rpt_gen_credito
end type
type rb_2 from radiobutton within w_cam710_rpt_gen_credito
end type
type rb_3 from radiobutton within w_cam710_rpt_gen_credito
end type
type rb_4 from radiobutton within w_cam710_rpt_gen_credito
end type
type cbx_4 from checkbox within w_cam710_rpt_gen_credito
end type
type sle_obs from singlelineedit within w_cam710_rpt_gen_credito
end type
type gb_1 from groupbox within w_cam710_rpt_gen_credito
end type
end forward

global type w_cam710_rpt_gen_credito from w_report_smpl
integer width = 3849
integer height = 1820
string title = "[CAM710] Reporte General de Creditos"
string menuname = "m_rpt_smpl"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
pb_1 pb_1
cbx_1 cbx_1
sle_tipo_cred sle_tipo_cred
st_desc_tipo_cred st_desc_tipo_cred
cbx_2 cbx_2
sle_benef sle_benef
st_desc_benef st_desc_benef
cbx_3 cbx_3
sle_prod sle_prod
st_desc_prod st_desc_prod
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
cbx_4 cbx_4
sle_obs sle_obs
gb_1 gb_1
end type
global w_cam710_rpt_gen_credito w_cam710_rpt_gen_credito

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_cam710_rpt_gen_credito.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.uo_rango=create uo_rango
this.pb_1=create pb_1
this.cbx_1=create cbx_1
this.sle_tipo_cred=create sle_tipo_cred
this.st_desc_tipo_cred=create st_desc_tipo_cred
this.cbx_2=create cbx_2
this.sle_benef=create sle_benef
this.st_desc_benef=create st_desc_benef
this.cbx_3=create cbx_3
this.sle_prod=create sle_prod
this.st_desc_prod=create st_desc_prod
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.cbx_4=create cbx_4
this.sle_obs=create sle_obs
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.sle_tipo_cred
this.Control[iCurrent+6]=this.st_desc_tipo_cred
this.Control[iCurrent+7]=this.cbx_2
this.Control[iCurrent+8]=this.sle_benef
this.Control[iCurrent+9]=this.st_desc_benef
this.Control[iCurrent+10]=this.cbx_3
this.Control[iCurrent+11]=this.sle_prod
this.Control[iCurrent+12]=this.st_desc_prod
this.Control[iCurrent+13]=this.rb_1
this.Control[iCurrent+14]=this.rb_2
this.Control[iCurrent+15]=this.rb_3
this.Control[iCurrent+16]=this.rb_4
this.Control[iCurrent+17]=this.cbx_4
this.Control[iCurrent+18]=this.sle_obs
this.Control[iCurrent+19]=this.gb_1
end on

on w_cam710_rpt_gen_credito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.pb_1)
destroy(this.cbx_1)
destroy(this.sle_tipo_cred)
destroy(this.st_desc_tipo_cred)
destroy(this.cbx_2)
destroy(this.sle_benef)
destroy(this.st_desc_benef)
destroy(this.cbx_3)
destroy(this.sle_prod)
destroy(this.st_desc_prod)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.cbx_4)
destroy(this.sle_obs)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_tipo_cred, ls_titulo, ls_benef, ls_prod, ls_obs
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If cbx_1.Checked Then
	ls_tipo_cred = '%'
	ls_titulo = "Todos los Tipos de Crédito"
Else
	ls_tipo_cred = sle_tipo_cred.text
	ls_titulo = st_desc_tipo_cred.text
End If 

If cbx_2.Checked Then
	ls_benef = '%'
Else
	ls_benef = trim(sle_benef.text)
End If 

If cbx_3.Checked Then
	ls_prod = '%'
Else
	ls_prod = trim(sle_prod.text)
End If 

If cbx_4.Checked Then
	ls_obs = '%'
Else
	ls_obs = trim(sle_obs.text)
End If 

if rb_1.checked then
	dw_report.dataObject = "d_rpt_cred_gen_tipo_cred_tbl"
elseif rb_2.checked then
	dw_report.dataObject = "d_rpt_cred_gen_benef_tbl"
elseif rb_3.checked then
	dw_report.dataObject = "d_rpt_cred_gen_prod_tbl"
elseif rb_4.checked then
	dw_report.dataObject = "d_rpt_cred_gen_fecha_tbl"
end if

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9

//Previes
ib_preview = false
this.event ue_preview( )

//Recuperar los datos
dw_report.settransobject( sqlca )
dw_report.retrieve(ls_benef, ls_tipo_cred, ls_prod, ls_obs, ld_fecha1, ld_fecha2)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.usuario_t.text = gs_user
dw_report.object.empresa_t.text = gs_empresa
dw_report.object.titulo_t.text 	= ls_titulo
dw_report.object.fecha1_t.text 	= string(ld_fecha1, 'dd/mm/yyyy')
dw_report.object.fecha2_t.text 	= string(ld_fecha2, 'dd/mm/yyyy')
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

type dw_report from w_report_smpl`dw_report within w_cam710_rpt_gen_credito
integer x = 0
integer y = 556
integer width = 3758
integer height = 932
integer taborder = 10
string dataobject = "d_rpt_diario_jornaleros_campo_t"
string is_dwform = ""
end type

type st_1 from statictext within w_cam710_rpt_gen_credito
integer x = 50
integer y = 60
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas:"
boolean focusrectangle = false
end type

type uo_rango from u_ingreso_rango_fechas within w_cam710_rpt_gen_credito
integer x = 535
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type pb_1 from picturebutton within w_cam710_rpt_gen_credito
integer x = 3378
integer y = 100
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

type cbx_1 from checkbox within w_cam710_rpt_gen_credito
integer x = 50
integer y = 176
integer width = 846
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
string text = "Todos los Tipos de Prestamo"
boolean checked = true
end type

event clicked;If cbx_1.Checked Then
	sle_tipo_cred.enabled = false
	sle_tipo_cred.text = ''
	st_desc_tipo_cred.text = ''
Else
	sle_tipo_cred.enabled = true
End If
end event

type sle_tipo_cred from singlelineedit within w_cam710_rpt_gen_credito
event dobleclick pbm_lbuttondblclk
integer x = 923
integer y = 176
integer width = 357
integer height = 80
integer taborder = 70
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

ls_sql = "SELECT p.tipo_prestamo AS tipo_prestamo, " &
		  + "p.desc_tipo_prestamo AS descripcion_tipo_prestamo " &
		  + "FROM cam_tipo_prestamo p " &
		  + "where p.flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_tipo_cred.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo de Crédito')
	return
end if

SELECT p.desc_tipo_prestamo 
		  INTO :ls_desc
		  FROM cam_tipo_prestamo p 
		  WHERE p.tipo_prestamo = :ls_codigo 
		  	AND p.flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Tipo de Crédito no existe o no lo tiene asignado')
	return
end if

st_desc_tipo_cred.text = ls_desc
end event

type st_desc_tipo_cred from statictext within w_cam710_rpt_gen_credito
integer x = 1298
integer y = 176
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

type cbx_2 from checkbox within w_cam710_rpt_gen_credito
integer x = 50
integer y = 264
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
string text = "Todos los Beneficiarios"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_benef.enabled = false
	sle_benef.text = ''
	st_desc_benef.text = ''
Else
	sle_benef.enabled = true
End If
end event

type sle_benef from singlelineedit within w_cam710_rpt_gen_credito
event dobleclick pbm_lbuttondblclk
integer x = 923
integer y = 264
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

IF sle_tipo_cred.text = '' THEN
	ls_sql = "SELECT DISTINCT cc.proveedor AS COD_BENEF, " &
			+ "p.nom_proveedor AS NOMBRE_BENEFICIARIO " &
				+ "FROM cam_creditos cc, " &
					+ "proveedor p " &
				+ "WHERE cc.proveedor = p.proveedor " &
			+ "ORDER BY p.nom_proveedor "	
ELSE
	ls_sql = "SELECT DISTINCT cc.proveedor AS COD_BENEF, " &
			+ "p.nom_proveedor AS NOMBRE_BENEFICIARIO " &
				+ "FROM cam_creditos cc, " &
					+ "proveedor p " &
				+ "WHERE cc.proveedor = p.proveedor " &
				+ "AND cc.tipo_prestamo = '" + sle_tipo_cred.text + "' " &
			+ "ORDER BY p.nom_proveedor "	
END IF
	
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_benef.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc, ls_var

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar Un Beneficiario')
	return
end if

IF sle_tipo_cred.text = '' THEN
	SELECT DISTINCT cc.proveedor, 
		p.nom_proveedor
		INTO :ls_var, :ls_desc
		FROM cam_creditos cc, 
		proveedor p 
		WHERE cc.proveedor = p.proveedor
			AND cc.proveedor = :ls_codigo
		ORDER BY p.nom_proveedor;
ELSE
	SELECT DISTINCT cc.proveedor, 
		p.nom_proveedor
		INTO :ls_var, :ls_desc
		FROM cam_creditos cc, 
		proveedor p 
		WHERE cc.proveedor = p.proveedor
			AND cc.proveedor = :ls_codigo
			AND cc.tipo_prestamo = :sle_tipo_cred.text
		ORDER BY p.nom_proveedor;
END IF

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Beneficiario no existe o no está activo')
	return
end if

st_desc_benef.text = ls_desc
end event

type st_desc_benef from statictext within w_cam710_rpt_gen_credito
integer x = 1298
integer y = 264
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

type cbx_3 from checkbox within w_cam710_rpt_gen_credito
integer x = 50
integer y = 352
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

type sle_prod from singlelineedit within w_cam710_rpt_gen_credito
event dobleclick pbm_lbuttondblclk
integer x = 923
integer y = 352
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

ls_sql = "SELECT DISTINCT ccd.proveedor AS COD_PROVEEDOR, " &
		   + "p.nom_proveedor AS NOMBRE_PROVEEDOR " &
		   + "FROM cam_creditos_det ccd, " &
		   + "proveedor p " &
            + "WHERE ccd.proveedor = p.proveedor " &
            + "ORDER BY p.nom_proveedor"
           
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

SELECT DISTINCT p.nom_proveedor AS NOMBRE_PROVEEDOR 
	INTO :ls_desc
	FROM cam_creditos_det ccd, 
		proveedor p 
	WHERE ccd.proveedor = p.proveedor 
	ORDER BY p.nom_proveedor;
				
IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Productor no existe o no está activo')
	return
end if

st_desc_prod.text = ls_desc
end event

type st_desc_prod from statictext within w_cam710_rpt_gen_credito
integer x = 1298
integer y = 352
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

type rb_1 from radiobutton within w_cam710_rpt_gen_credito
integer x = 2683
integer y = 112
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Prestamo"
boolean checked = true
end type

type rb_2 from radiobutton within w_cam710_rpt_gen_credito
integer x = 2683
integer y = 180
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Beneficiario"
end type

type rb_3 from radiobutton within w_cam710_rpt_gen_credito
integer x = 2683
integer y = 248
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Productor"
end type

type rb_4 from radiobutton within w_cam710_rpt_gen_credito
integer x = 2683
integer y = 316
integer width = 498
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

type cbx_4 from checkbox within w_cam710_rpt_gen_credito
integer x = 50
integer y = 444
integer width = 704
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
string text = "Todas las Observaciones"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_obs.enabled = false
	sle_obs.text = ''
Else
	sle_obs.enabled = true
End If
end event

type sle_obs from singlelineedit within w_cam710_rpt_gen_credito
event dobleclick pbm_lbuttondblclk
integer x = 923
integer y = 444
integer width = 1655
integer height = 80
integer taborder = 100
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

ls_sql = "SELECT DISTINCT cc.observaciones AS OBSERVACION, cc.observaciones AS OBS " &
		+ "FROM cam_creditos cc " &
		+ "ORDER BY cc.observaciones"
           
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un Código de Productor')
	return
end if

SELECT DISTINCT p.nom_proveedor AS NOMBRE_PROVEEDOR 
	INTO :ls_desc
	FROM cam_creditos_det ccd, 
		proveedor p 
	WHERE ccd.proveedor = p.proveedor 
	ORDER BY p.nom_proveedor;
				
IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Productor no existe o no está activo')
	return
end if

st_desc_prod.text = ls_desc
end event

type gb_1 from groupbox within w_cam710_rpt_gen_credito
integer x = 2642
integer y = 60
integer width = 704
integer height = 348
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte Agrupado por"
end type

