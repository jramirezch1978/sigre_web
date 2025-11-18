$PBExportHeader$w_ap904_genera_oc.srw
forward
global type w_ap904_genera_oc from w_abc
end type
type dw_lista from u_dw_abc within w_ap904_genera_oc
end type
type cb_1 from commandbutton within w_ap904_genera_oc
end type
type st_nro_oc from statictext within w_ap904_genera_oc
end type
type st_7 from statictext within w_ap904_genera_oc
end type
type sle_origen from singlelineedit within w_ap904_genera_oc
end type
type st_origen from statictext within w_ap904_genera_oc
end type
type st_desc_moneda from statictext within w_ap904_genera_oc
end type
type sle_moneda from singlelineedit within w_ap904_genera_oc
end type
type st_5 from statictext within w_ap904_genera_oc
end type
type st_monto_oc from statictext within w_ap904_genera_oc
end type
type st_4 from statictext within w_ap904_genera_oc
end type
type st_nom_proveedor from statictext within w_ap904_genera_oc
end type
type sle_proveedor from singlelineedit within w_ap904_genera_oc
end type
type st_3 from statictext within w_ap904_genera_oc
end type
type st_2 from statictext within w_ap904_genera_oc
end type
type uo_fechas from u_ingreso_rango_fechas within w_ap904_genera_oc
end type
type pb_1 from picturebutton within w_ap904_genera_oc
end type
type pb_2 from picturebutton within w_ap904_genera_oc
end type
type st_1 from statictext within w_ap904_genera_oc
end type
end forward

global type w_ap904_genera_oc from w_abc
integer width = 3543
integer height = 2232
string title = "(AP904) Genera OC"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
dw_lista dw_lista
cb_1 cb_1
st_nro_oc st_nro_oc
st_7 st_7
sle_origen sle_origen
st_origen st_origen
st_desc_moneda st_desc_moneda
sle_moneda sle_moneda
st_5 st_5
st_monto_oc st_monto_oc
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
global w_ap904_genera_oc w_ap904_genera_oc

forward prototypes
public subroutine of_get_monto_selecc ()
end prototypes

event ue_aceptar;// Para actualizar los costos de ultima compra
SetPointer (HourGlass!)
 
string 	ls_mensaje, ls_moneda, ls_nro_oc, ls_proveedor, ls_origen, &
			ls_parte
date 		ld_fecha1, ld_fecha2
integer	li_i, li_item, li_count
Decimal	ldc_precio_unit

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
dw_lista.AcceptText()

li_count = 0
for li_i = 1 to dw_lista.RowCount( )
	if dw_lista.object.seleccion[li_i] = '1' then
		ls_parte 			= dw_lista.object.nro_parte			[li_i]
		li_item 				= Int(dw_lista.object.item				[li_i])
		ldc_precio_unit 	= Dec(dw_lista.object.precio_unit	[li_i])
		
		li_count ++
		insert into TT_AP_PD_SELECC(nro_parte, item, precio_unit)
		values(:ls_parte, :li_item, :ldc_precio_unit);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al insertar en tabla TT_AP_PD_SELECC. Mensaje: ' +ls_mensaje, StopSign!)
			return
		end if
		
		commit;
	end if
next

select count(*)
	into :li_count
from TT_AP_PD_SELECC;

if li_count = 0 then
	MessageBox('Error', 'No ha seleccionado ningun ticket', StopSign!)
	return
end if

//create or replace procedure USP_AP_GENERA_OC_RANGO(
//       asi_origen    IN origen.cod_origen%TYPE,
//       asi_proveedor IN proveedor.proveedor%TYPE,
//       asi_moneda    IN moneda.cod_moneda%TYPE,
//       asi_usuario   IN usuario.cod_usr%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE,
//       aso_nro_oc    OUT orden_compra.nro_oc%TYPE
//) IS

DECLARE USP_AP_GENERA_OC_RANGO PROCEDURE FOR
 				USP_AP_GENERA_OC_RANGO( :ls_origen,
				 								:ls_proveedor,
												:ls_moneda,
												:gs_user,
												:ld_fecha1, 
												:ld_fecha2);
 
EXECUTE USP_AP_GENERA_OC_RANGO;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE USP_AP_GENERA_OC_RANGO: " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 SetPointer (Arrow!)
	 RETURN 
END IF

FETCH USP_AP_GENERA_OC_RANGO into :ls_nro_oc;

st_nro_oc.text = 'Nro OC: ' + ls_nro_oc
 
CLOSE USP_AP_GENERA_OC_RANGO;

MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
 
SetPointer (Arrow!)
end event

event ue_salir();close(this)
end event

public subroutine of_get_monto_selecc ();long ll_row
decimal ldc_precio, ldc_importe, ldc_peso

dw_lista.accepttext( )

ldc_importe = 0
for ll_row = 1 to dw_lista.RowCount()
	if dw_lista.object.seleccion[ll_row] = '1' then
		ldc_precio 	= Dec(dw_lista.object.precio_unit [ll_row])
		ldc_peso 	= Dec (dw_lista.object.peso_venta [ll_row])
		ldc_importe += ldc_precio * ldc_peso
	end if
next

st_monto_oc.text = sle_moneda.text + " " + string(round(ldc_importe,2), "###,##0.00")


end subroutine

on w_ap904_genera_oc.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.dw_lista=create dw_lista
this.cb_1=create cb_1
this.st_nro_oc=create st_nro_oc
this.st_7=create st_7
this.sle_origen=create sle_origen
this.st_origen=create st_origen
this.st_desc_moneda=create st_desc_moneda
this.sle_moneda=create sle_moneda
this.st_5=create st_5
this.st_monto_oc=create st_monto_oc
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
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_nro_oc
this.Control[iCurrent+4]=this.st_7
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.st_origen
this.Control[iCurrent+7]=this.st_desc_moneda
this.Control[iCurrent+8]=this.sle_moneda
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.st_monto_oc
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.st_nom_proveedor
this.Control[iCurrent+13]=this.sle_proveedor
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_2
this.Control[iCurrent+16]=this.uo_fechas
this.Control[iCurrent+17]=this.pb_1
this.Control[iCurrent+18]=this.pb_2
this.Control[iCurrent+19]=this.st_1
end on

on w_ap904_genera_oc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.cb_1)
destroy(this.st_nro_oc)
destroy(this.st_7)
destroy(this.sle_origen)
destroy(this.st_origen)
destroy(this.st_desc_moneda)
destroy(this.sle_moneda)
destroy(this.st_5)
destroy(this.st_monto_oc)
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

this.of_get_monto_selecc( )
end event

type dw_lista from u_dw_abc within w_ap904_genera_oc
integer y = 728
integer width = 3520
integer height = 1016
integer taborder = 60
string dataobject = "d_list_ap_tickets_grd"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event losefocus;call super::losefocus;of_get_monto_selecc( )
end event

event itemchanged;call super::itemchanged;of_get_monto_selecc( )
end event

type cb_1 from commandbutton within w_ap904_genera_oc
integer x = 3017
integer y = 612
integer width = 475
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Obtener Listado"
end type

event clicked;parent.event ue_refresh( )
end event

type st_nro_oc from statictext within w_ap904_genera_oc
integer x = 1317
integer y = 1760
integer width = 727
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro OC:"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_7 from statictext within w_ap904_genera_oc
integer x = 41
integer y = 516
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

type sle_origen from singlelineedit within w_ap904_genera_oc
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 512
integer width = 352
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_proveedor
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )
ls_proveedor = sle_proveedor.text


ls_sql = "SELECT DISTINCT o.cod_origen as codigo_origen, " &
		 + "o.nombre as nombre_origen " &
		 + "FROM ap_guia_recepcion     a, " &
		 + "     ap_guia_recepcion_det b, " &
		 + "     ap_pd_descarga_det    c, " &
		 + "     origen             o " &
		 + "WHERE a.origen   	 = o.cod_origen " &
		 + "  AND a.cod_guia_rec = b.cod_guia_rec " &
		 + "  AND b.nro_parte    = c.nro_parte " &
		 + "  AND b.item_parte   = c.item " &
		 + "  AND a.flag_estado	 <> '0' " &
		 + "  AND a.nro_oc IS NULL     " &
		 + "  and to_char(c.inicio_descarga, 'yyyymmdd') between '" + &
		 	string(ld_fecha1, 'yyyymmdd') + "' and '" + &
			string(ld_fecha2, 'yyyymmdd') + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_origen.text = ls_data
	//st_monto_oc.text = string(of_get_monto_oc(), '###,##0.00')
end if

end event

type st_origen from statictext within w_ap904_genera_oc
integer x = 814
integer y = 512
integer width = 2679
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

type st_desc_moneda from statictext within w_ap904_genera_oc
integer x = 814
integer y = 412
integer width = 2679
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

type sle_moneda from singlelineedit within w_ap904_genera_oc
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 412
integer width = 352
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\CUR\taladro.cur"
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

type st_5 from statictext within w_ap904_genera_oc
integer x = 32
integer y = 416
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

type st_monto_oc from statictext within w_ap904_genera_oc
integer x = 2802
integer y = 1760
integer width = 718
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_ap904_genera_oc
integer x = 2094
integer y = 1760
integer width = 690
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Importe Seleccionado:"
boolean focusrectangle = false
end type

type st_nom_proveedor from statictext within w_ap904_genera_oc
integer x = 814
integer y = 312
integer width = 2679
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

type sle_proveedor from singlelineedit within w_ap904_genera_oc
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 312
integer width = 352
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )


ls_sql = "SELECT DISTINCT p.proveedor as codigo_proveedor, " &
		 + "p.nom_proveedor as razon_social, " &
		 + "p.ruc as ruc_proveedor " &
		 + "FROM ap_guia_recepcion     a, " &
		 + "     ap_guia_recepcion_det b, " &
		 + "     ap_pd_descarga_det    c, " &
		 + "     proveedor             p " &
		 + "WHERE a.proveedor    = p.proveedor " &
		 + "  AND a.cod_guia_rec = b.cod_guia_rec " &
		 + "  AND b.nro_parte    = c.nro_parte " &
		 + "  AND b.item_parte   = c.item " &
		 + "  AND a.flag_estado	 <> '0' " &
		 + "  AND b.amp_oc IS NULL     " &
		 + "  and to_char(c.inicio_descarga, 'yyyymmdd') between '" + &
		 	string(ld_fecha1, 'yyyymmdd') + "' and '" + &
			string(ld_fecha2, 'yyyymmdd') + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_nom_proveedor.text = ls_data
	//st_monto_oc.text = string(of_get_monto_oc(), '###,##0.00')
end if

end event

type st_3 from statictext within w_ap904_genera_oc
integer x = 32
integer y = 320
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
string text = "Proveedor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ap904_genera_oc
integer x = 110
integer y = 176
integer width = 690
integer height = 84
integer textsize = -10
integer weight = 700
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

type uo_fechas from u_ingreso_rango_fechas within w_ap904_genera_oc
integer x = 814
integer y = 172
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

type pb_1 from picturebutton within w_ap904_genera_oc
integer x = 1481
integer y = 1872
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
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
parent.event ue_refresh( )
end event

type pb_2 from picturebutton within w_ap904_genera_oc
integer x = 1810
integer y = 1872
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
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

type st_1 from statictext within w_ap904_genera_oc
integer y = 28
integer width = 3520
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Genera Ordenes de Compra en un periodo"
alignment alignment = center!
boolean focusrectangle = false
end type

