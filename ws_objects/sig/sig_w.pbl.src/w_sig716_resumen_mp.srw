$PBExportHeader$w_sig716_resumen_mp.srw
forward
global type w_sig716_resumen_mp from w_report_smpl
end type
type st_1 from statictext within w_sig716_resumen_mp
end type
type cb_proc from commandbutton within w_sig716_resumen_mp
end type
type sle_moneda from singlelineedit within w_sig716_resumen_mp
end type
type st_2 from statictext within w_sig716_resumen_mp
end type
type uo_rango from u_ingreso_rango_fechas within w_sig716_resumen_mp
end type
end forward

global type w_sig716_resumen_mp from w_report_smpl
integer width = 3995
integer height = 1740
string title = "[SIG716] Resumen Compra Materia Prima"
string menuname = "m_rpt_simple"
event ue_query_retrieve ( )
st_1 st_1
cb_proc cb_proc
sle_moneda sle_moneda
st_2 st_2
uo_rango uo_rango
end type
global w_sig716_resumen_mp w_sig716_resumen_mp

type variables
string 	is_soles
boolean 	ib_retrieve = false
end variables

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_sig716_resumen_mp.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.st_1=create st_1
this.cb_proc=create cb_proc
this.sle_moneda=create sle_moneda
this.st_2=create st_2
this.uo_rango=create uo_rango
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_proc
this.Control[iCurrent+3]=this.sle_moneda
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_rango
end on

on w_sig716_resumen_mp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_proc)
destroy(this.sle_moneda)
destroy(this.st_2)
destroy(this.uo_rango)
end on

event ue_open_pre;//ii_lec_mst = 0

select cod_soles
	into :is_soles
from logparam
where reckey = '1';

sle_moneda.text = is_soles

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
idw_1.Visible = False
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_moneda
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If sle_moneda.text = '' Then
	MessageBox('Error', 'Debe elegir un tipo de moneda')
	sle_moneda.setFocus()
	return
End If 
ls_moneda = sle_moneda.text

dw_report.Object.Datawindow.Print.Orientation = 1
//dw_report.Object.DataWindow.Print.Paper.Size	= 1

dw_report.settransobject( sqlca )
dw_report.retrieve(ld_fecha1, ld_fecha2, ls_moneda )


dw_report.object.p_logo.filename = gs_logo
dw_report.object.st_usuario.text = gs_user
dw_report.object.st_empresa.text = gs_empresa
dw_report.object.st_desde.text 	= string(ld_fecha1, 'dd/mm/yyyy')
dw_report.object.st_hasta.text 	= string(ld_fecha2, 'dd/mm/yyyy')


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


end event

type dw_report from w_report_smpl`dw_report within w_sig716_resumen_mp
event ue_display ( string as_columna,  long al_row )
event ue_filter_init ( )
integer x = 0
integer y = 184
integer width = 3771
integer height = 1132
integer taborder = 10
string dataobject = "d_rpt_resumen_compra_mp_tbl"
string is_dwform = ""
end type

event dw_report::ue_filter_init();//cbx_PowerFilter.of_setdw(this)
end event

event dw_report::doubleclicked;call super::doubleclicked;str_parametros lstr_param
w_cns_general	lw_cns

choose case lower(dwo.name)
		
	case "cant_cajas"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.cod_cuadrilla [row]
		lstr_param.dw1 	 = 'd_cns_cajas_x_empacadora_tbl'
		lstr_param.tipo 	 = '1S1D2S3S'
		lstr_param.titulo	 = 'Cajas producidas por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
					
	case "costo_mp"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.cod_cuadrilla [row]
		lstr_param.dw1 	 = 'd_cns_costo_mp_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S'
		lstr_param.titulo	 = 'Costo x Consumo de Materia Prima por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_mat"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_mat_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo x Consumo de Materiales por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_jor"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_jor_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo x Jornal por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_dst"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_dst_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo x Destajo por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_eve"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_eve_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo Eventual por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_trans"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_transp_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo Transporte por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_serv"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_serv_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo x Servicios de Terceros por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
		
	case "costo_mo_ind"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_mo_ind_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo Mano de Obra Indirecto'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_mat_ind"
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.dw1 	 = 'd_cns_costo_mat_ind_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S'
		lstr_param.titulo	 = 'Costo x Consumo de Materiales Indirectos'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_serv_ind"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_serv_ind_x_empac_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo x Servicios Indirectos de Terceros por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_emp"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_emp_dia_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo Empleado Fijo Diario'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)


	case "costo_mat_fijo"
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.dw1 	 = 'd_cns_costo_mat_fijo_tbl'
		lstr_param.tipo 	 = '1S1D2S'
		lstr_param.titulo	 = 'Costo x Consumo de Materiales Fijos'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_serv_fijo"
		
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string1 = sle_moneda.text
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_serv_fijo_tbl'
		lstr_param.tipo 	 = '1D1S1N'
		lstr_param.titulo	 = 'Costo x Servicios Fijos de Terceros por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_gd"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_gasto_directo_fijo_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Gatos Directos por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "costo_social"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_costo_social_fijo_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Costo Sociales Fijos por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
	
	case 'gasto_financiero'
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_gasto_finan_fijo_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Gastos Financieros Fijos por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)
		
	case "costo_importacion"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_gastos_ventas_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Gastos de Ventas por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

	case "depreciacion"
		
		lstr_param.string1 = this.object.cod_empacadora [row]
		lstr_param.fecha1  = Date(this.object.fec_corte [row])
		lstr_param.string2 = sle_moneda.text
		lstr_param.string3 = this.object.nro_orden [row]
		lstr_param.decimal1 = Dec(this.object.cant_cajas [row])
		lstr_param.dw1 	 = 'd_cns_depreciacion_tbl'
		lstr_param.tipo 	 = '1S1D2S3S1N'
		lstr_param.titulo	 = 'Depreciación por empacadoras y Cuadrilla'
		
		OpenSheetWithParm(lw_cns, lstr_param, w_main, 0, Layered!)

end choose
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;SelectRow(0, false)
SelectRow(currentRow, true)
end event

event dw_report::resize;call super::resize;//if ib_retrieve then
//	cbx_PowerFilter.event ue_positionbuttons()
//end if
end event

event dw_report::ue_leftbuttonup;call super::ue_leftbuttonup;//if ib_retrieve then
//	cbx_PowerFilter.event post ue_buttonclicked(dwo.type, dwo.name)
//end if
end event

type st_1 from statictext within w_sig716_resumen_mp
integer x = 50
integer y = 60
integer width = 475
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

type cb_proc from commandbutton within w_sig716_resumen_mp
integer x = 2473
integer y = 12
integer width = 343
integer height = 164
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type sle_moneda from singlelineedit within w_sig716_resumen_mp
event dobleclick pbm_lbuttondblclk
integer x = 2098
integer y = 52
integer width = 288
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_moneda as codigo_moneda, "&
			+"m.descripcion as descripcion_moneda "&
  			+"from moneda m Where m.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una Empacadora')
	return
end if

end event

type st_2 from statictext within w_sig716_resumen_mp
integer x = 1833
integer y = 60
integer width = 261
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
string text = "Moneda:"
boolean focusrectangle = false
end type

type uo_rango from u_ingreso_rango_fechas within w_sig716_resumen_mp
integer x = 535
integer y = 44
integer taborder = 70
boolean bringtotop = true
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual())

this.of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
this.of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(date(ld_fecha_actual))) //para setear la fecha inicial
this.of_set_rango_inicio(date('01/01/1900')) // rango inicial
this.of_set_rango_fin(date('31/12/9999')) // rango final
end event

