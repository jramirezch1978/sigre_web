$PBExportHeader$w_ap909_genera_os.srw
forward
global type w_ap909_genera_os from w_abc
end type
type dw_lista from u_dw_abc within w_ap909_genera_os
end type
type cb_1 from commandbutton within w_ap909_genera_os
end type
type st_nro_os from statictext within w_ap909_genera_os
end type
type st_7 from statictext within w_ap909_genera_os
end type
type sle_origen from singlelineedit within w_ap909_genera_os
end type
type st_origen from statictext within w_ap909_genera_os
end type
type st_desc_moneda from statictext within w_ap909_genera_os
end type
type sle_moneda from singlelineedit within w_ap909_genera_os
end type
type st_5 from statictext within w_ap909_genera_os
end type
type st_monto_oc from statictext within w_ap909_genera_os
end type
type st_4 from statictext within w_ap909_genera_os
end type
type st_nom_proveedor from statictext within w_ap909_genera_os
end type
type sle_proveedor from singlelineedit within w_ap909_genera_os
end type
type st_3 from statictext within w_ap909_genera_os
end type
type st_2 from statictext within w_ap909_genera_os
end type
type uo_fechas from u_ingreso_rango_fechas within w_ap909_genera_os
end type
type pb_1 from picturebutton within w_ap909_genera_os
end type
type pb_2 from picturebutton within w_ap909_genera_os
end type
type st_1 from statictext within w_ap909_genera_os
end type
end forward

global type w_ap909_genera_os from w_abc
integer width = 3497
integer height = 2232
string title = "[AP909] Generación de OS de Transporte"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
dw_lista dw_lista
cb_1 cb_1
st_nro_os st_nro_os
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
global w_ap909_genera_os w_ap909_genera_os

forward prototypes
public subroutine of_get_monto_selecc ()
end prototypes

event ue_aceptar();// Para actualizar los costos de ultima compra
SetPointer (HourGlass!)
 
string 	ls_mensaje, ls_moneda, ls_nro_os, ls_proveedor, ls_origen, &
			ls_parte
date 		ld_fecha1, ld_fecha2
integer	li_i, li_item, li_count

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

li_count = 0
for li_i = 1 to dw_lista.RowCount( )
	if dw_lista.object.seleccion[li_i] = '1' then
		ls_parte = dw_lista.object.nro_parte[li_i]
		li_item = Int(dw_lista.object.item[li_i])
		
		li_count ++
		insert into TT_AP_PD_SELECC(nro_parte, item)
		values(:ls_parte, :li_item);
	end if
next

if li_count = 0 then
	MessageBox('Error', 'No ha seleccionado ningun ticket')
	return
end if

//create or replace procedure USP_AP_GENERA_OS_RANGO(
//       asi_origen    IN origen.cod_origen%TYPE,
//       asi_proveedor IN proveedor.proveedor%TYPE,
//       asi_moneda    IN moneda.cod_moneda%TYPE,
//       asi_usuario   IN usuario.cod_usr%TYPE,
//       adi_fecha1    IN DATE,
//       adi_fecha2    IN DATE,
//       aso_nro_os    OUT VARCHAR2
//) IS

DECLARE USP_AP_GENERA_OS_RANGO PROCEDURE FOR
 				USP_AP_GENERA_OS_RANGO( :ls_origen,
				 								:ls_proveedor,
												:ls_moneda,
												:gs_user,
												:ld_fecha1, 
												:ld_fecha2);
 
EXECUTE USP_AP_GENERA_OS_RANGO;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE USP_AP_GENERA_OS_RANGO: " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 SetPointer (Arrow!)
	 RETURN 
END IF

FETCH USP_AP_GENERA_OS_RANGO into :ls_nro_os;

CLOSE USP_AP_GENERA_OS_RANGO;

st_nro_os.text = 'Nro OS: ' + ls_nro_os
 
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
		ldc_precio 	= Dec(dw_lista.object.precio_flete [ll_row])
		ldc_importe += ldc_precio
	end if
next

st_monto_oc.text = sle_moneda.text + " " + string(ldc_importe, "###,##0.000")


end subroutine

on w_ap909_genera_os.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.dw_lista=create dw_lista
this.cb_1=create cb_1
this.st_nro_os=create st_nro_os
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
this.Control[iCurrent+3]=this.st_nro_os
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

on w_ap909_genera_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.cb_1)
destroy(this.st_nro_os)
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

event resize;call super::resize;dw_lista.width  = newwidth  - dw_lista.x - 10
st_1.width		 = dw_lista.width
end event

type dw_lista from u_dw_abc within w_ap909_genera_os
integer y = 836
integer width = 3456
integer height = 800
integer taborder = 60
string dataobject = "d_list_ap_pd_para_os_grd"
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

type cb_1 from commandbutton within w_ap909_genera_os
integer x = 2683
integer y = 704
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

type st_nro_os from statictext within w_ap909_genera_os
integer x = 55
integer y = 1684
integer width = 727
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro OS:"
boolean focusrectangle = false
end type

type st_7 from statictext within w_ap909_genera_os
integer x = 41
integer y = 588
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

type sle_origen from singlelineedit within w_ap909_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 584
integer width = 352
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
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
		 + "FROM ap_pd_descarga     a, " &
		 + "     ap_pd_descarga_det b, " &
		 + "     origen             o " &
		 + "WHERE a.cod_origen   = o.cod_origen " &
		 + "  AND a.nro_parte    = b.nro_parte " &
		 + "  AND b.nro_os is null " &
		 + "  AND b.item_os is null " &
		 + "  and to_char(b.inicio_descarga, 'yyyymmdd') between '" + &
		 	string(ld_fecha1, 'yyyymmdd') + "' and '" + &
			string(ld_fecha2, 'yyyymmdd') + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_origen.text = ls_data
end if

end event

type st_origen from statictext within w_ap909_genera_os
integer x = 814
integer y = 584
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

type st_desc_moneda from statictext within w_ap909_genera_os
integer x = 814
integer y = 448
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

type sle_moneda from singlelineedit within w_ap909_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 448
integer y = 448
integer width = 352
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\SOURCE\CUR\taladro.cur"
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

type st_5 from statictext within w_ap909_genera_os
integer x = 32
integer y = 452
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

type st_monto_oc from statictext within w_ap909_genera_os
integer x = 2226
integer y = 1684
integer width = 718
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_ap909_genera_os
integer x = 1518
integer y = 1684
integer width = 690
integer height = 64
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

type st_nom_proveedor from statictext within w_ap909_genera_os
integer x = 814
integer y = 312
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

type sle_proveedor from singlelineedit within w_ap909_genera_os
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
string pointer = "H:\SOURCE\CUR\taladro.cur"
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
		 + "FROM ap_pd_descarga_det    a, " &
		 + "     proveedor             p, " &
		 + "     ap_transp_prov			 t " &
		 + "WHERE a.PROV_TRANSPORTE    = p.proveedor " &
		 + "  and t.proveedor			 = p.proveedor " &
		 + "  AND a.nro_os IS NULL     " &
		 + "  AND a.item_os IS NULL     " &
		 + "  and t.FLAG_GEN_OS = '1' " &
		 + "  and to_char(a.inicio_descarga, 'yyyymmdd') between '" + &
		 	string(ld_fecha1, 'yyyymmdd') + "' and '" + &
			string(ld_fecha2, 'yyyymmdd') + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_nom_proveedor.text = ls_data
end if

end event

type st_3 from statictext within w_ap909_genera_os
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

type st_2 from statictext within w_ap909_genera_os
integer x = 50
integer y = 176
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

type uo_fechas from u_ingreso_rango_fechas within w_ap909_genera_os
integer x = 786
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

type pb_1 from picturebutton within w_ap909_genera_os
integer x = 741
integer y = 1796
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

event clicked;parent.event dynamic ue_aceptar()
parent.event ue_refresh( )
end event

type pb_2 from picturebutton within w_ap909_genera_os
integer x = 1998
integer y = 1784
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

type st_1 from statictext within w_ap909_genera_os
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
string text = "Generar Orden de Servicio de Transporte de Mat. Prima"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

