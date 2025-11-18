$PBExportHeader$w_pr754_resumen_diario.srw
forward
global type w_pr754_resumen_diario from w_report_smpl
end type
type st_1 from statictext within w_pr754_resumen_diario
end type
type uo_rango from ou_rango_fechas within w_pr754_resumen_diario
end type
type pb_1 from picturebutton within w_pr754_resumen_diario
end type
type cbx_especies from checkbox within w_pr754_resumen_diario
end type
type sle_especie from singlelineedit within w_pr754_resumen_diario
end type
type st_desc_especie from statictext within w_pr754_resumen_diario
end type
type cbx_clientes from checkbox within w_pr754_resumen_diario
end type
type sle_cliente from singlelineedit within w_pr754_resumen_diario
end type
type st_nom_cliente from statictext within w_pr754_resumen_diario
end type
end forward

global type w_pr754_resumen_diario from w_report_smpl
integer width = 4457
integer height = 1820
string title = "[PR754] Total Resumen Diario Jornal y Destajo"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
pb_1 pb_1
cbx_especies cbx_especies
sle_especie sle_especie
st_desc_especie st_desc_especie
cbx_clientes cbx_clientes
sle_cliente sle_cliente
st_nom_cliente st_nom_cliente
end type
global w_pr754_resumen_diario w_pr754_resumen_diario

type variables
string is_FLAG_HORA_EXT_35
end variables

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr754_resumen_diario.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.pb_1=create pb_1
this.cbx_especies=create cbx_especies
this.sle_especie=create sle_especie
this.st_desc_especie=create st_desc_especie
this.cbx_clientes=create cbx_clientes
this.sle_cliente=create sle_cliente
this.st_nom_cliente=create st_nom_cliente
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cbx_especies
this.Control[iCurrent+5]=this.sle_especie
this.Control[iCurrent+6]=this.st_desc_especie
this.Control[iCurrent+7]=this.cbx_clientes
this.Control[iCurrent+8]=this.sle_cliente
this.Control[iCurrent+9]=this.st_nom_cliente
end on

on w_pr754_resumen_diario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.pb_1)
destroy(this.cbx_especies)
destroy(this.sle_especie)
destroy(this.st_desc_especie)
destroy(this.cbx_clientes)
destroy(this.sle_cliente)
destroy(this.st_nom_cliente)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0

select FLAG_HORA_EXT_35
	into :is_FLAG_HORA_EXT_35
from rrhhparam r
where r.reckey = '1';

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9
dw_report.object.datawindow.print.orientation = 1

end event

event ue_retrieve;call super::ue_retrieve;String 	ls_ot_adm, ls_titulo, ls_especie, ls_clientes
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

if cbx_clientes.checked then
	ls_clientes = "%%"
else
	ls_clientes = trim(sle_cliente.text) + "%"
end if

if cbx_especies.checked then
	ls_especie = "%%"
else
	ls_especie = trim(sle_especie.text) + "%"
end if

dw_report.settransobject( sqlca )

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9
dw_report.object.DataWindow.print.Orientation = 2

//Previes
ib_preview = false
this.event ue_preview( )

//REcuperar los datos
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_especie, ls_clientes)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.usuario_t.text  = gs_user
dw_report.object.empresa_t.text  = gs_empresa

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

type dw_report from w_report_smpl`dw_report within w_pr754_resumen_diario
integer x = 0
integer y = 292
integer width = 3314
integer height = 1088
integer taborder = 10
string dataobject = "d_rpt_resumen_diario_tbl"
string is_dwform = ""
end type

type st_1 from statictext within w_pr754_resumen_diario
integer x = 41
integer y = 24
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

type uo_rango from ou_rango_fechas within w_pr754_resumen_diario
integer x = 526
integer y = 12
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_pr754_resumen_diario
integer x = 2469
integer y = 20
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
string picturename = "C:\SIGRE\resources\BMP\Aceptar_dn.bmp"
end type

event clicked;parent.event ue_retrieve()
end event

type cbx_especies from checkbox within w_pr754_resumen_diario
integer x = 18
integer y = 108
integer width = 626
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
string text = "Todas las especies"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_especie.enabled = false
	sle_especie.text=''
	st_desc_especie.text = ''
Else
	sle_especie.enabled = true
	sle_especie.text=''
End If
end event

type sle_especie from singlelineedit within w_pr754_resumen_diario
event dobleclick pbm_lbuttondblclk
integer x = 645
integer y = 108
integer width = 357
integer height = 80
integer taborder = 130
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

ls_sql = "select distinct a.especie as codigo_especie, " &
	    + "a.descr_especie as descripcion_especie " &
		 + "from tg_especies a, " &
		 + "     tg_pd_destajo pd " &
		 + "where pd.cod_especie = a.especie " &
		 + "  and a.flag_estado = '1' " &
		 + "  and pd.flag_estado <> '0'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_especie.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una TAREA')
	return
end if

SELECT descr_especie
	INTO :ls_desc
FROM tg_especies
WHERE especie = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Especie no existe o no está activo')
	return
end if

st_desc_especie.text = ls_desc
end event

type st_desc_especie from statictext within w_pr754_resumen_diario
integer x = 1015
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

type cbx_clientes from checkbox within w_pr754_resumen_diario
integer x = 18
integer y = 196
integer width = 626
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
string text = "Todas los Clientes"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_cliente.enabled = false
	sle_cliente.text=''
	st_nom_cliente.text = ''
Else
	sle_cliente.enabled = true
	sle_cliente.text=''
	st_nom_cliente.text = ''
End If
end event

type sle_cliente from singlelineedit within w_pr754_resumen_diario
event dobleclick pbm_lbuttondblclk
integer x = 645
integer y = 196
integer width = 357
integer height = 80
integer taborder = 140
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

ls_sql = "select distinct p.proveedor as codigo_cliente, " &
		 + "p.nom_proveedor as descripcion_cliente, " &
		 + "p.ruc as ruc_cliente " &
		 + "from proveedor p, " &
		 + "tg_pd_destajo pd " &
		 + "where p.proveedor = pd.cod_cliente " &
		 + "  and p.flag_estado = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_nom_cliente.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un Cliente')
	return
end if

SELECT nom_proveedor
	into :ls_desc
FROM proveedor
WHERE proveedor = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de trabajador no existe o no está activo')
	return
end if

st_nom_cliente.text = ls_desc
end event

type st_nom_cliente from statictext within w_pr754_resumen_diario
integer x = 1015
integer y = 196
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

