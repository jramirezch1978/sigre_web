$PBExportHeader$w_pr751_destajo_tipo_trabaj.srw
forward
global type w_pr751_destajo_tipo_trabaj from w_report_smpl
end type
type st_1 from statictext within w_pr751_destajo_tipo_trabaj
end type
type uo_rango from ou_rango_fechas within w_pr751_destajo_tipo_trabaj
end type
type pb_1 from picturebutton within w_pr751_destajo_tipo_trabaj
end type
type cbx_4 from checkbox within w_pr751_destajo_tipo_trabaj
end type
type sle_trabajador from singlelineedit within w_pr751_destajo_tipo_trabaj
end type
type st_nom_trabajador from statictext within w_pr751_destajo_tipo_trabaj
end type
type cbx_tarea from checkbox within w_pr751_destajo_tipo_trabaj
end type
type sle_tarea from singlelineedit within w_pr751_destajo_tipo_trabaj
end type
type st_desc_tarea from statictext within w_pr751_destajo_tipo_trabaj
end type
type cbx_clientes from checkbox within w_pr751_destajo_tipo_trabaj
end type
type sle_cliente from singlelineedit within w_pr751_destajo_tipo_trabaj
end type
type st_nom_cliente from statictext within w_pr751_destajo_tipo_trabaj
end type
end forward

global type w_pr751_destajo_tipo_trabaj from w_report_smpl
integer width = 4457
integer height = 1820
string title = "[PR751] Total Destajo por Tipo de Trabajador"
string menuname = "m_reporte"
event ue_query_retrieve ( )
st_1 st_1
uo_rango uo_rango
pb_1 pb_1
cbx_4 cbx_4
sle_trabajador sle_trabajador
st_nom_trabajador st_nom_trabajador
cbx_tarea cbx_tarea
sle_tarea sle_tarea
st_desc_tarea st_desc_tarea
cbx_clientes cbx_clientes
sle_cliente sle_cliente
st_nom_cliente st_nom_cliente
end type
global w_pr751_destajo_tipo_trabaj w_pr751_destajo_tipo_trabaj

type variables
string is_FLAG_HORA_EXT_35
end variables

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr751_destajo_tipo_trabaj.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.uo_rango=create uo_rango
this.pb_1=create pb_1
this.cbx_4=create cbx_4
this.sle_trabajador=create sle_trabajador
this.st_nom_trabajador=create st_nom_trabajador
this.cbx_tarea=create cbx_tarea
this.sle_tarea=create sle_tarea
this.st_desc_tarea=create st_desc_tarea
this.cbx_clientes=create cbx_clientes
this.sle_cliente=create sle_cliente
this.st_nom_cliente=create st_nom_cliente
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_rango
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.cbx_4
this.Control[iCurrent+5]=this.sle_trabajador
this.Control[iCurrent+6]=this.st_nom_trabajador
this.Control[iCurrent+7]=this.cbx_tarea
this.Control[iCurrent+8]=this.sle_tarea
this.Control[iCurrent+9]=this.st_desc_tarea
this.Control[iCurrent+10]=this.cbx_clientes
this.Control[iCurrent+11]=this.sle_cliente
this.Control[iCurrent+12]=this.st_nom_cliente
end on

on w_pr751_destajo_tipo_trabaj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.pb_1)
destroy(this.cbx_4)
destroy(this.sle_trabajador)
destroy(this.st_nom_trabajador)
destroy(this.cbx_tarea)
destroy(this.sle_tarea)
destroy(this.st_desc_tarea)
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

event ue_retrieve;call super::ue_retrieve;String 	ls_ot_adm, ls_titulo, ls_labor, ls_lote, ls_trabajador, ls_tarea, &
			ls_cliente
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If cbx_4.Checked Then
	ls_trabajador = '%%'
Else
	ls_trabajador = trim(sle_trabajador.text) + "%"
End If 

If cbx_tarea.Checked Then
	ls_tarea = '%%'
Else
	ls_tarea = trim(sle_tarea.text) + "%"
End If 

If cbx_clientes.Checked Then
	ls_cliente = '%%'
Else
	ls_cliente = trim(sle_cliente.text) + "%"
End If 

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9

//Previes
ib_preview = false
this.event ue_preview( )

if is_FLAG_HORA_EXT_35 = '1' then
	dw_report.dataobject = 'd_rpt_detalle_prod_trab_he35_tbl'
else
	dw_report.dataobject = 'd_rpt_detalle_prod_trab_tbl'
end if

//REcuperar los datos
dw_report.settransobject( sqlca )
dw_report.retrieve(ls_trabajador, ls_tarea, ls_cliente, ld_fecha1, ld_fecha2)

ib_preview = false
this.event ue_preview()

//Papel A-4
dw_report.object.datawindow.print.paper.size = 9
dw_report.object.datawindow.print.orientation = 1

dw_report.object.p_logo.filename = gs_logo
dw_report.object.usuario_t.text = gs_user
dw_report.object.empresa_t.text = gs_empresa

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

type dw_report from w_report_smpl`dw_report within w_pr751_destajo_tipo_trabaj
integer x = 0
integer y = 440
integer width = 3314
integer height = 960
integer taborder = 10
string dataobject = "d_rpt_detalle_prod_trab_tbl"
string is_dwform = ""
end type

type st_1 from statictext within w_pr751_destajo_tipo_trabaj
integer x = 50
integer y = 48
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

type uo_rango from ou_rango_fechas within w_pr751_destajo_tipo_trabaj
integer x = 535
integer y = 36
integer taborder = 20
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_pr751_destajo_tipo_trabaj
integer x = 2391
integer y = 32
integer width = 343
integer height = 200
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\BMP\Aceptar.bmp"
boolean map3dcolors = true
end type

event clicked;parent.event ue_retrieve()
end event

type cbx_4 from checkbox within w_pr751_destajo_tipo_trabaj
integer x = 18
integer y = 136
integer width = 677
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
string text = "Todos los trabajadores"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_trabajador.enabled = false
	sle_trabajador.text=''
	st_nom_trabajador.text = ''
Else
	sle_trabajador.enabled = true
	sle_trabajador.text=''
	st_nom_trabajador.text = ''	
End If
end event

type sle_trabajador from singlelineedit within w_pr751_destajo_tipo_trabaj
event dobleclick pbm_lbuttondblclk
integer x = 699
integer y = 136
integer width = 357
integer height = 80
integer taborder = 110
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

ls_sql = "select vw.cod_trabajador as codigo_trabajador, " &
		 		 + "vw.nom_trabajador as nombre_trabajador " &
		 		 + "from vw_pr_trabajador vw " &
		 		 + "where vw.flag_estado = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_nom_trabajador.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	return
end if

SELECT apel_paterno || ' ' || apel_materno || ', ' || nombre1 INTO :ls_desc
FROM maestro
WHERE cod_trabajador = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de trabajador no existe o no está activo')
	return
end if

st_nom_trabajador.text = ls_desc
end event

type st_nom_trabajador from statictext within w_pr751_destajo_tipo_trabaj
integer x = 1070
integer y = 136
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

type cbx_tarea from checkbox within w_pr751_destajo_tipo_trabaj
integer x = 18
integer y = 224
integer width = 677
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
string text = "Todas las tareas"
boolean checked = true
end type

event clicked;If this.Checked Then
	sle_tarea.enabled = false
	sle_tarea.text=''
	st_desc_tarea.text = ''
Else
	sle_tarea.enabled = true
	sle_tarea.text=''
	st_desc_tarea.text = ''
End If
end event

type sle_tarea from singlelineedit within w_pr751_destajo_tipo_trabaj
event dobleclick pbm_lbuttondblclk
integer x = 699
integer y = 224
integer width = 357
integer height = 80
integer taborder = 120
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

ls_sql = "select cod_tarea as codigo_tarea, " &
		 + "desc_tarea as descripcion_trabajador " &
		 + "from tg_tareas t " &
		 + "where t.flag_estado = '1' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	st_desc_tarea.text = ls_data
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una TAREA')
	return
end if

SELECT desc_tarea
	INTO :ls_desc
FROM tg_tareas
WHERE cod_tarea = :ls_codigo
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Tarea no existe o no está activo')
	return
end if

st_desc_tarea.text = ls_desc
end event

type st_desc_tarea from statictext within w_pr751_destajo_tipo_trabaj
integer x = 1070
integer y = 224
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

type cbx_clientes from checkbox within w_pr751_destajo_tipo_trabaj
integer x = 18
integer y = 312
integer width = 677
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

type sle_cliente from singlelineedit within w_pr751_destajo_tipo_trabaj
event dobleclick pbm_lbuttondblclk
integer x = 699
integer y = 312
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

type st_nom_cliente from statictext within w_pr751_destajo_tipo_trabaj
integer x = 1070
integer y = 312
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

