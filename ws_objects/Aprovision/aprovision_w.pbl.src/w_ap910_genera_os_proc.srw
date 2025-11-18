$PBExportHeader$w_ap910_genera_os_proc.srw
forward
global type w_ap910_genera_os_proc from w_abc
end type
type st_8 from statictext within w_ap910_genera_os_proc
end type
type st_total_venta from statictext within w_ap910_genera_os_proc
end type
type st_12 from statictext within w_ap910_genera_os_proc
end type
type st_11 from statictext within w_ap910_genera_os_proc
end type
type st_importe_igv from statictext within w_ap910_genera_os_proc
end type
type st_9 from statictext within w_ap910_genera_os_proc
end type
type st_nro_cajas from statictext within w_ap910_genera_os_proc
end type
type st_peso from statictext within w_ap910_genera_os_proc
end type
type st_6 from statictext within w_ap910_genera_os_proc
end type
type dw_lista from u_dw_abc within w_ap910_genera_os_proc
end type
type cb_1 from commandbutton within w_ap910_genera_os_proc
end type
type st_nro_os from statictext within w_ap910_genera_os_proc
end type
type st_7 from statictext within w_ap910_genera_os_proc
end type
type sle_origen from singlelineedit within w_ap910_genera_os_proc
end type
type st_origen from statictext within w_ap910_genera_os_proc
end type
type st_desc_moneda from statictext within w_ap910_genera_os_proc
end type
type sle_moneda from singlelineedit within w_ap910_genera_os_proc
end type
type st_5 from statictext within w_ap910_genera_os_proc
end type
type st_base_imponible from statictext within w_ap910_genera_os_proc
end type
type st_4 from statictext within w_ap910_genera_os_proc
end type
type st_nom_proveedor from statictext within w_ap910_genera_os_proc
end type
type sle_proveedor from singlelineedit within w_ap910_genera_os_proc
end type
type st_3 from statictext within w_ap910_genera_os_proc
end type
type st_2 from statictext within w_ap910_genera_os_proc
end type
type uo_fechas from u_ingreso_rango_fechas within w_ap910_genera_os_proc
end type
type pb_1 from picturebutton within w_ap910_genera_os_proc
end type
type pb_2 from picturebutton within w_ap910_genera_os_proc
end type
type st_1 from statictext within w_ap910_genera_os_proc
end type
end forward

global type w_ap910_genera_os_proc from w_abc
integer width = 3497
integer height = 2368
string title = "[AP910] Generación de Orden de Servicio de Procesamiento"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
st_8 st_8
st_total_venta st_total_venta
st_12 st_12
st_11 st_11
st_importe_igv st_importe_igv
st_9 st_9
st_nro_cajas st_nro_cajas
st_peso st_peso
st_6 st_6
dw_lista dw_lista
cb_1 cb_1
st_nro_os st_nro_os
st_7 st_7
sle_origen sle_origen
st_origen st_origen
st_desc_moneda st_desc_moneda
sle_moneda sle_moneda
st_5 st_5
st_base_imponible st_base_imponible
st_4 st_4
st_nom_proveedor st_nom_proveedor
sle_proveedor sle_proveedor
st_3 st_3
st_2 st_2
uo_fechas uo_fechas
pb_1 pb_1
pb_2 pb_2
st_1 st_1
end type
global w_ap910_genera_os_proc w_ap910_genera_os_proc

forward prototypes
public subroutine of_refresh_seleccionado ()
end prototypes

event ue_aceptar;string 	ls_mensaje, ls_moneda, ls_nro_os, ls_proveedor, ls_origen, &
			ls_especie, ls_cat_art, ls_cod_sub_cat, ls_der, ls_und, &
			ls_flag_exo_igv_proceso, ls_flag_incluye_igv_proceso, ls_servicio_proc
date 		ld_fecha1, ld_fecha2, ld_inicio_descarga
Decimal	ldc_precio_proceso
integer	li_i, li_item, li_count

// Para generar la Orden de Servicio
ls_proveedor = sle_proveedor.text
if ls_proveedor = '' then
	MessageBox('Error', 'Debe seleccionar un proveedor')
	sle_proveedor.setFocus( )
	return
end if

ls_origen = sle_origen.text
if ls_origen = '' then
	MessageBox('Error', 'Debe seleccionar un origen')
	sle_origen.setFocus( )
	return
end if

ls_moneda = sle_moneda.text
if ls_moneda = '' then
	MessageBox('Error', 'Debe seleccionar una moneda')
	sle_moneda.setFocus( )
	return
end if

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

//Busco si ha marcado algun ticket
delete TT_AP_PD_SELECC;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	MessageBox('Error', 'Error al eliminar los registros de la tabla TT_AP_PD_SELECC. Mensaje: ' + ls_mensaje, StopSign!)
	return
end if

li_count = 0
for li_i = 1 to dw_lista.RowCount( )
	if dw_lista.object.seleccion[li_i] = '1' then
		
		//Obtengo los datos que necesito de acuerdo a los datos seleccionados
		ld_inicio_descarga			= date(dw_lista.object.inicio_descarga 			[li_i])
		ls_especie						= dw_lista.object.especie 								[li_i]
		ls_cat_art						= dw_lista.object.cat_art 								[li_i]
		ls_cod_sub_cat					= dw_lista.object.cod_sub_cat 						[li_i]
		ls_der							= dw_lista.object.der 									[li_i]
		ls_und							= dw_lista.object.und 									[li_i]
		ls_flag_exo_igv_proceso		= dw_lista.object.flag_exo_igv_proceso 			[li_i]
		ls_flag_incluye_igv_proceso= dw_lista.object.flag_incluye_igv_proceso		[li_i]
		ls_servicio_proc				= dw_lista.object.servicio_proc						[li_i]
		ldc_precio_proceso			= Dec(dw_lista.object.precio_proceso				[li_i])
		
		li_count ++
		
		insert into TT_AP_PD_SELECC(nro_parte, item)
		select distinct
				 pd.nro_parte,
				 pd.item
		from  ap_pd_descarga_det   pd,
				ap_pd_descarga       p,
				articulo             a,
			  	articulo_sub_categ   a2,
			 	articulo_categ       a1
		where pd.nro_parte      = p.nro_parte
		  and pd.especie        = :ls_especie
		  and pd.cod_art        = a.cod_art     
		  and a.sub_Cat_art     = a2.cod_sub_cat  
		  and a2.cat_art        = a1.cat_art    
		  and a1.cat_Art        = :ls_cat_Art
		  and a2.cod_sub_cat    = :ls_cod_sub_cat
		  and pd.facturador     = :ls_proveedor
		  and trunc(pd.inicio_descarga) = trunc(:ld_inicio_descarga)
		  and pd.nro_os_proc is null
		  and nvl(pd.precio_proceso, 0) > 0
		  and pd.moneda_proceso 	= :ls_moneda
		  and p.cod_origen    		= :ls_origen
		  and pd.precio_proceso		= :ldc_precio_proceso
		  and nvl(pd.der, 'XXX') 	= nvl(:ls_der, 'XXX')
		  and pd.und					= :ls_und
		  and pd.servicio_proc		= :ls_servicio_proc
		  and nvl(pd.flag_exo_igv_proceso, '0') 		= nvl(:ls_flag_exo_igv_proceso, '0')
		  and nvl(pd.flag_incluye_igv_proceso, '0') 	= nvl(:ls_flag_incluye_igv_proceso, '0')
		  and p.flag_estado   		<> '0';

		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			MessageBox('Error', 'Error al insertar registro en tabla TT_AP_PD_SELECC. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if

	end if
next

if li_count = 0 then
	MessageBox('Error', 'No ha seleccionado ningun REGISTRO para procesar, por favor verfirique!', StopSign!)
	return
end if

//create or replace procedure USP_AP_GENERA_OS_PROCESO(
//       asi_origen    IN origen.cod_origen%TYPE,
//       asi_proveedor IN proveedor.proveedor%TYPE,
//       asi_moneda    IN moneda.cod_moneda%TYPE,
//       asi_usuario   IN usuario.cod_usr%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE,
//       aso_nro_os    OUT VARCHAR2
//) IS

DECLARE USP_AP_GENERA_OS_PROCESO PROCEDURE FOR
 				USP_AP_GENERA_OS_PROCESO( :ls_origen,
				 								  :ls_proveedor,
												  :ls_moneda,
												  :gs_user,
												  :ld_fecha1, 
												  :ld_fecha2);
 
EXECUTE USP_AP_GENERA_OS_PROCESO;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE USP_AP_GENERA_OS_PROCESO: " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 SetPointer (Arrow!)
	 RETURN 
END IF

FETCH USP_AP_GENERA_OS_PROCESO into :ls_nro_os;

CLOSE USP_AP_GENERA_OS_PROCESO;

st_nro_os.text = ls_nro_os
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente', Information!)
 
SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public subroutine of_refresh_seleccionado ();long ll_row
decimal ldc_nro_Cajas, ldc_peso_bruto, ldc_base_imponible, ldc_importe_igv, ldc_total_venta

dw_lista.accepttext( )

ldc_nro_Cajas = 0 
ldc_peso_bruto = 0 
ldc_base_imponible = 0 
ldc_importe_igv = 0 
ldc_total_venta = 0

for ll_row = 1 to dw_lista.RowCount()
	if dw_lista.object.seleccion[ll_row] = '1' then
		ldc_nro_Cajas 			+= Dec(dw_lista.object.nro_cajas 		[ll_row])
		ldc_peso_bruto 		+= Dec(dw_lista.object.peso_bruto 		[ll_row])
		ldc_base_imponible 	+= Dec(dw_lista.object.base_imponible 	[ll_row])
		ldc_importe_igv		+= Dec(dw_lista.object.importe_igv 		[ll_row])
		ldc_total_venta 		+= Dec(dw_lista.object.total_venta 		[ll_row])
		
	end if
next

st_peso.text 				= string(ldc_peso_bruto, "###,##0.000")
st_nro_Cajas.text 		= string(ldc_nro_Cajas, "###,##0.000")
st_base_imponible.text 	= sle_moneda.text + " " + string(ldc_base_imponible, "###,##0.000")
st_importe_igv.text 		= sle_moneda.text + " " + string(ldc_importe_igv, "###,##0.000")
st_total_venta.text 		= sle_moneda.text + " " + string(ldc_total_venta, "###,##0.000")

end subroutine

on w_ap910_genera_os_proc.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_8=create st_8
this.st_total_venta=create st_total_venta
this.st_12=create st_12
this.st_11=create st_11
this.st_importe_igv=create st_importe_igv
this.st_9=create st_9
this.st_nro_cajas=create st_nro_cajas
this.st_peso=create st_peso
this.st_6=create st_6
this.dw_lista=create dw_lista
this.cb_1=create cb_1
this.st_nro_os=create st_nro_os
this.st_7=create st_7
this.sle_origen=create sle_origen
this.st_origen=create st_origen
this.st_desc_moneda=create st_desc_moneda
this.sle_moneda=create sle_moneda
this.st_5=create st_5
this.st_base_imponible=create st_base_imponible
this.st_4=create st_4
this.st_nom_proveedor=create st_nom_proveedor
this.sle_proveedor=create sle_proveedor
this.st_3=create st_3
this.st_2=create st_2
this.uo_fechas=create uo_fechas
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_8
this.Control[iCurrent+2]=this.st_total_venta
this.Control[iCurrent+3]=this.st_12
this.Control[iCurrent+4]=this.st_11
this.Control[iCurrent+5]=this.st_importe_igv
this.Control[iCurrent+6]=this.st_9
this.Control[iCurrent+7]=this.st_nro_cajas
this.Control[iCurrent+8]=this.st_peso
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.dw_lista
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_nro_os
this.Control[iCurrent+13]=this.st_7
this.Control[iCurrent+14]=this.sle_origen
this.Control[iCurrent+15]=this.st_origen
this.Control[iCurrent+16]=this.st_desc_moneda
this.Control[iCurrent+17]=this.sle_moneda
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.st_base_imponible
this.Control[iCurrent+20]=this.st_4
this.Control[iCurrent+21]=this.st_nom_proveedor
this.Control[iCurrent+22]=this.sle_proveedor
this.Control[iCurrent+23]=this.st_3
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.uo_fechas
this.Control[iCurrent+26]=this.pb_1
this.Control[iCurrent+27]=this.pb_2
this.Control[iCurrent+28]=this.st_1
end on

on w_ap910_genera_os_proc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_8)
destroy(this.st_total_venta)
destroy(this.st_12)
destroy(this.st_11)
destroy(this.st_importe_igv)
destroy(this.st_9)
destroy(this.st_nro_cajas)
destroy(this.st_peso)
destroy(this.st_6)
destroy(this.dw_lista)
destroy(this.cb_1)
destroy(this.st_nro_os)
destroy(this.st_7)
destroy(this.sle_origen)
destroy(this.st_origen)
destroy(this.st_desc_moneda)
destroy(this.sle_moneda)
destroy(this.st_5)
destroy(this.st_base_imponible)
destroy(this.st_4)
destroy(this.st_nom_proveedor)
destroy(this.sle_proveedor)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.uo_fechas)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
end on

event ue_refresh;call super::ue_refresh;string ls_proveedor, ls_origen, ls_moneda
date ld_Fecha1, ld_Fecha2

ls_proveedor = sle_proveedor.text
if ls_proveedor = '' then
	MessageBox('Error', 'Debe seleccionar un proveedor')
	sle_proveedor.setFocus( )
	return
end if

ls_origen = sle_origen.text
if ls_origen = '' then
	MessageBox('Error', 'Debe seleccionar un origen')
	sle_origen.setFocus( )
	return
end if

ls_moneda = sle_moneda.text
if ls_origen = '' then
	MessageBox('Error', 'Debe seleccionar una moneda')
	sle_moneda.setFocus( )
	return
end if

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

dw_lista.setTransobject( SQLCA )
dw_lista.retrieve(ls_proveedor, ls_origen, ld_Fecha1, ld_Fecha2, ls_moneda)

this.of_refresh_seleccionado()
end event

event resize;call super::resize;dw_lista.width  = newwidth  - dw_lista.x - 10
st_1.width		 = dw_lista.width
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

type st_8 from statictext within w_ap910_genera_os_proc
integer x = 2295
integer y = 128
integer width = 485
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OS Generado :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_total_venta from statictext within w_ap910_genera_os_proc
integer x = 2226
integer y = 1876
integer width = 718
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_12 from statictext within w_ap910_genera_os_proc
integer x = 1518
integer y = 1880
integer width = 690
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Importe total :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_11 from statictext within w_ap910_genera_os_proc
integer x = 1518
integer y = 1792
integer width = 690
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "IGV :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_importe_igv from statictext within w_ap910_genera_os_proc
integer x = 2226
integer y = 1792
integer width = 718
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_9 from statictext within w_ap910_genera_os_proc
integer x = 9
integer y = 1792
integer width = 690
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Cajas :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nro_cajas from statictext within w_ap910_genera_os_proc
integer x = 718
integer y = 1792
integer width = 718
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_peso from statictext within w_ap910_genera_os_proc
integer x = 718
integer y = 1708
integer width = 718
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_6 from statictext within w_ap910_genera_os_proc
integer x = 9
integer y = 1708
integer width = 690
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Peso Seleccionado :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_lista from u_dw_abc within w_ap910_genera_os_proc
integer y = 652
integer width = 3456
integer height = 1044
integer taborder = 60
string dataobject = "d_lista_pd_ap_os_proc_grd"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event losefocus;call super::losefocus;of_refresh_seleccionado( )
end event

event itemchanged;call super::itemchanged;this.acceptText()
of_refresh_seleccionado()
end event

type cb_1 from commandbutton within w_ap910_genera_os_proc
integer x = 2944
integer y = 544
integer width = 475
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Obtener Listado"
end type

event clicked;parent.event ue_refresh( )
end event

type st_nro_os from statictext within w_ap910_genera_os_proc
integer x = 2802
integer y = 128
integer width = 581
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_ap910_genera_os_proc
integer x = 32
integer y = 448
integer width = 370
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_ap910_genera_os_proc
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 444
integer width = 352
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_proveedor
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )
ls_proveedor = sle_proveedor.text


ls_sql = "select distinct " &
		 + "       o.cod_origen as codigo_origen, " &
		 + "       o.nombre as nom_origen " &
		 + "from  ap_pd_descarga_det    pd, " &
		 + "      ap_pd_descarga        p, " &
		 + "      origen                o " &
		 + "where pd.nro_parte      = p.nro_parte " &
		 + "  and p.cod_origen      = o.cod_origen " &
		 + "  and trunc(p.fecha_descarga) between to_date('" + string(ld_fecha1, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fecha2, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') " &
		 + "  and pd.nro_os_proc is null " &
		 + "  and nvl(pd.precio_proceso, 0) > 0 " 

		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_origen.text = ls_data
end if

end event

type st_origen from statictext within w_ap910_genera_os_proc
integer x = 805
integer y = 444
integer width = 2345
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_desc_moneda from statictext within w_ap910_genera_os_proc
integer x = 805
integer y = 340
integer width = 2345
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_moneda from singlelineedit within w_ap910_genera_os_proc
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 340
integer width = 352
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_moneda as codigo_moneda, " &
		 + "descripcion as descripcion_moneda " &
		 + "FROM moneda " &
		 + "WHERE flag_estado = '1' "
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_desc_moneda.text = ls_data
	//st_monto_oc.text = string(of_get_monto_oc(), '###,##0.00')
end if

end event

type st_5 from statictext within w_ap910_genera_os_proc
integer x = 23
integer y = 344
integer width = 370
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_base_imponible from statictext within w_ap910_genera_os_proc
integer x = 2226
integer y = 1708
integer width = 718
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_ap910_genera_os_proc
integer x = 1518
integer y = 1708
integer width = 690
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Base Imponible :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nom_proveedor from statictext within w_ap910_genera_os_proc
integer x = 805
integer y = 240
integer width = 2345
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_proveedor from singlelineedit within w_ap910_genera_os_proc
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 240
integer width = 352
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;string ls_codigo, ls_data, ls_sql
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )


ls_sql = "select distinct " &
		 + "       pd.facturador as cod_facturador, " &
		 + "       p1.nom_proveedor as nom_facturador, " &
		 + "       decode(p1.tipo_doc_ident, '6', p1.ruc, p1.nro_doc_ident) as ruc_dni " &
		 + "from  ap_pd_descarga_det    pd, " &
		 + "      ap_pd_descarga        p, " &
		 + "      proveedor             p1 " &
		 + "where pd.nro_parte      = p.nro_parte " &
		 + "  and pd.facturador     = p1.proveedor " &
		 + "  and trunc(p.fecha_descarga) between to_date('" + string(ld_fecha1, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') and to_date('" + string(ld_fecha2, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') " &
		 + "  and pd.nro_os_proc is null " &
		 + "  and nvl(pd.precio_proceso, 0) > 0 " 

		 

		 
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text = ls_codigo
	st_nom_proveedor.text = ls_data
end if

end event

type st_3 from statictext within w_ap910_genera_os_proc
integer x = 23
integer y = 248
integer width = 370
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Facturador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ap910_genera_os_proc
integer x = 41
integer y = 128
integer width = 498
integer height = 84
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_fechas from u_ingreso_rango_fechas within w_ap910_genera_os_proc
integer x = 777
integer y = 124
integer taborder = 10
end type

on uo_fechas.destroy
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

type pb_1 from picturebutton within w_ap910_genera_os_proc
integer x = 741
integer y = 1980
integer width = 315
integer height = 180
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "c:\sigre\resources\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;SetPointer (HourGlass!)
parent.event dynamic ue_aceptar()
parent.event ue_refresh( )
SetPointer (Arrow!)
end event

type pb_2 from picturebutton within w_ap910_genera_os_proc
integer x = 1998
integer y = 1980
integer width = 315
integer height = 180
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "c:\sigre\resources\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type st_1 from statictext within w_ap910_genera_os_proc
integer width = 3456
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16777215
long backcolor = 8388608
string text = "GENERAR ORDEN DE SERVICIO DE PROCESAMIENTO EN UN PERIODO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

