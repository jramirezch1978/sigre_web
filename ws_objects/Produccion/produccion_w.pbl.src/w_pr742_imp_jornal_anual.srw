$PBExportHeader$w_pr742_imp_jornal_anual.srw
forward
global type w_pr742_imp_jornal_anual from w_report_smpl
end type
type st_1 from statictext within w_pr742_imp_jornal_anual
end type
type uo_rango from ou_rango_fechas within w_pr742_imp_jornal_anual
end type
type pb_1 from picturebutton within w_pr742_imp_jornal_anual
end type
type cbx_1 from checkbox within w_pr742_imp_jornal_anual
end type
type sle_ot_adm from singlelineedit within w_pr742_imp_jornal_anual
end type
type st_desc_ot_adm from statictext within w_pr742_imp_jornal_anual
end type
type cbx_2 from checkbox within w_pr742_imp_jornal_anual
end type
type sle_labor from singlelineedit within w_pr742_imp_jornal_anual
end type
type st_desc_labor from statictext within w_pr742_imp_jornal_anual
end type
type cbx_3 from checkbox within w_pr742_imp_jornal_anual
end type
type sle_lote from singlelineedit within w_pr742_imp_jornal_anual
end type
type st_desc_lote from statictext within w_pr742_imp_jornal_anual
end type
end forward

global type w_pr742_imp_jornal_anual from w_report_smpl
integer width = 4457
integer height = 1820
string title = "[pR742] Importe Jornal Anual"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
pb_1 pb_1
cbx_1 cbx_1
sle_ot_adm sle_ot_adm
st_desc_ot_adm st_desc_ot_adm
cbx_2 cbx_2
sle_labor sle_labor
st_desc_labor st_desc_labor
cbx_3 cbx_3
sle_lote sle_lote
st_desc_lote st_desc_lote
end type
global w_pr742_imp_jornal_anual w_pr742_imp_jornal_anual

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr742_imp_jornal_anual.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.pb_1=create pb_1
this.cbx_1=create cbx_1
this.sle_ot_adm=create sle_ot_adm
this.st_desc_ot_adm=create st_desc_ot_adm
this.cbx_2=create cbx_2
this.sle_labor=create sle_labor
this.st_desc_labor=create st_desc_labor
this.cbx_3=create cbx_3
this.sle_lote=create sle_lote
this.st_desc_lote=create st_desc_lote
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.sle_ot_adm
this.Control[iCurrent+6]=this.st_desc_ot_adm
this.Control[iCurrent+7]=this.cbx_2
this.Control[iCurrent+8]=this.sle_labor
this.Control[iCurrent+9]=this.st_desc_labor
this.Control[iCurrent+10]=this.cbx_3
this.Control[iCurrent+11]=this.sle_lote
this.Control[iCurrent+12]=this.st_desc_lote
end on

on w_pr742_imp_jornal_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.pb_1)
destroy(this.cbx_1)
destroy(this.sle_ot_adm)
destroy(this.st_desc_ot_adm)
destroy(this.cbx_2)
destroy(this.sle_labor)
destroy(this.st_desc_labor)
destroy(this.cbx_3)
destroy(this.sle_lote)
destroy(this.st_desc_lote)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9
dw_report.object.datawindow.print.orientation = 1

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_ot_adm, ls_titulo, ls_labor, ls_lote
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If cbx_1.Checked Then
	ls_ot_adm = '%%'
	ls_titulo = "Todos los OT_ADM"
Else
	ls_ot_adm = sle_ot_adm.text + "%"
	ls_titulo = st_desc_ot_adm.text
End If 

If cbx_2.Checked Then
	ls_labor = '%%'
Else
	ls_labor = trim(sle_labor.text) + "%"
End If 

If cbx_3.Checked Then
	ls_lote = '%%'
Else
	ls_lote = trim(sle_lote.text) + "%"
End If 

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9

//Previes
ib_preview = false
this.event ue_preview( )

//REcuperar los datos
dw_report.settransobject( sqlca )
dw_report.retrieve(ls_ot_adm, ls_labor, ld_fecha1, ld_fecha2)

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

type dw_report from w_report_smpl`dw_report within w_pr742_imp_jornal_anual
integer x = 0
integer y = 460
integer width = 3314
integer height = 940
integer taborder = 10
string dataobject = "d_rpt_imp_jornal_anual_tbl"
string is_dwform = ""
end type

type st_1 from statictext within w_pr742_imp_jornal_anual
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

type uo_rango from ou_rango_fechas within w_pr742_imp_jornal_anual
integer x = 535
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_pr742_imp_jornal_anual
integer x = 2441
integer y = 128
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
end type

event clicked;parent.event ue_retrieve()
end event

type cbx_1 from checkbox within w_pr742_imp_jornal_anual
integer x = 50
integer y = 176
integer width = 585
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
string text = "Todos los OT_ADM"
boolean checked = true
end type

event clicked;If cbx_1.Checked Then
	sle_ot_adm.enabled = false
	sle_ot_adm.text=''
Else
	sle_ot_adm.enabled = true
	sle_ot_adm.text=''
End If
end event

type sle_ot_adm from singlelineedit within w_pr742_imp_jornal_anual
event dobleclick pbm_lbuttondblclk
integer x = 686
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

ls_sql = "SELECT O.OT_ADM AS CODIGO, " &
		 + "O.DESCRIPCION AS DESCRIPCIÓN " &
		 + "FROM OT_ADMINISTRACION O, "&
		 + "OT_ADM_USUARIO P " &
		 + "WHERE O.OT_ADM = P.OT_ADM " &
		 + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_ot_adm.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT o.descripcion INTO :ls_desc
FROM ot_administracion o,
	  ot_adm_usuario u
WHERE o.ot_adm = o.ot_adm
  and u.cod_usr = :gs_user
  and o.ot_adm =:ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe o no lo tiene asignado')
	return
end if

st_desc_ot_adm.text = ls_desc
end event

type st_desc_ot_adm from statictext within w_pr742_imp_jornal_anual
integer x = 1061
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

type cbx_2 from checkbox within w_pr742_imp_jornal_anual
integer x = 50
integer y = 264
integer width = 585
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
string text = "Todos las labores"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_labor.enabled = false
	sle_labor.text=''
Else
	sle_labor.enabled = true
	sle_labor.text=''
End If
end event

type sle_labor from singlelineedit within w_pr742_imp_jornal_anual
event dobleclick pbm_lbuttondblclk
integer x = 686
integer y = 264
integer width = 357
integer height = 80
integer taborder = 80
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

ls_sql = "SELECT cod_labor AS CODIGO_labor, " &
		 + "desc_labor AS DESCRIPCIÓN_labor " &
		 + "FROM labor "&
		 + "WHERE flag_estado = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_labor.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT desc_labor INTO :ls_desc
FROM labor
WHERE cod_labor = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de labor no existe o no está activo')
	return
end if

st_desc_labor.text = ls_desc
end event

type st_desc_labor from statictext within w_pr742_imp_jornal_anual
integer x = 1061
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

type cbx_3 from checkbox within w_pr742_imp_jornal_anual
integer x = 50
integer y = 352
integer width = 585
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
string text = "Todos los lotes"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_lote.enabled = false
	sle_lote.text=''
Else
	sle_lote.enabled = true
	sle_lote.text=''
End If
end event

type sle_lote from singlelineedit within w_pr742_imp_jornal_anual
event dobleclick pbm_lbuttondblclk
integer x = 686
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

ls_sql = "SELECT nro_lote AS numero_lote, " &
		 + "descripcion AS DESCRIPCIÓN_lote " &
		 + "FROM lote_campo "&
		 + "WHERE flag_estado = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_lote.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT descripcion INTO :ls_desc
FROM lote_campo
WHERE nro_lote = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'NUMERO DE LOTE no existe o no está activo')
	return
end if

st_desc_lote.text = ls_desc
end event

type st_desc_lote from statictext within w_pr742_imp_jornal_anual
integer x = 1061
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

