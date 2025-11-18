$PBExportHeader$w_pr902_genera_os.srw
forward
global type w_pr902_genera_os from w_abc
end type
type em_monto_os from editmask within w_pr902_genera_os
end type
type em_monto_fac from editmask within w_pr902_genera_os
end type
type em_dif from editmask within w_pr902_genera_os
end type
type st_9 from statictext within w_pr902_genera_os
end type
type st_8 from statictext within w_pr902_genera_os
end type
type st_7 from statictext within w_pr902_genera_os
end type
type st_origen from statictext within w_pr902_genera_os
end type
type st_proveedor from statictext within w_pr902_genera_os
end type
type st_moneda from statictext within w_pr902_genera_os
end type
type st_servicio from statictext within w_pr902_genera_os
end type
type cb_1 from commandbutton within w_pr902_genera_os
end type
type rb_2 from radiobutton within w_pr902_genera_os
end type
type rb_1 from radiobutton within w_pr902_genera_os
end type
type em_origen from singlelineedit within w_pr902_genera_os
end type
type st_1 from statictext within w_pr902_genera_os
end type
type em_servicio from singlelineedit within w_pr902_genera_os
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr902_genera_os
end type
type st_2 from statictext within w_pr902_genera_os
end type
type st_3 from statictext within w_pr902_genera_os
end type
type sle_proveedor from singlelineedit within w_pr902_genera_os
end type
type st_4 from statictext within w_pr902_genera_os
end type
type sle_desc from singlelineedit within w_pr902_genera_os
end type
type st_5 from statictext within w_pr902_genera_os
end type
type st_os from statictext within w_pr902_genera_os
end type
type st_nro_os from statictext within w_pr902_genera_os
end type
type cb_aceptar from picturebutton within w_pr902_genera_os
end type
type st_6 from statictext within w_pr902_genera_os
end type
type sle_moneda from singlelineedit within w_pr902_genera_os
end type
type cbx_igv from checkbox within w_pr902_genera_os
end type
type gb_3 from groupbox within w_pr902_genera_os
end type
type gb_1 from groupbox within w_pr902_genera_os
end type
end forward

global type w_pr902_genera_os from w_abc
integer width = 2121
integer height = 2100
string title = "Genera OS de Trasnporte(PR902)"
string menuname = "m_impresion_1"
event ue_generar_os ( )
em_monto_os em_monto_os
em_monto_fac em_monto_fac
em_dif em_dif
st_9 st_9
st_8 st_8
st_7 st_7
st_origen st_origen
st_proveedor st_proveedor
st_moneda st_moneda
st_servicio st_servicio
cb_1 cb_1
rb_2 rb_2
rb_1 rb_1
em_origen em_origen
st_1 st_1
em_servicio em_servicio
uo_fecha uo_fecha
st_2 st_2
st_3 st_3
sle_proveedor sle_proveedor
st_4 st_4
sle_desc sle_desc
st_5 st_5
st_os st_os
st_nro_os st_nro_os
cb_aceptar cb_aceptar
st_6 st_6
sle_moneda sle_moneda
cbx_igv cbx_igv
gb_3 gb_3
gb_1 gb_1
end type
global w_pr902_genera_os w_pr902_genera_os

forward prototypes
public subroutine of_verificar_monto_os ()
end prototypes

event ue_generar_os();// Para Generer la Orden de Servicio Usando el Procedimiento

string 	ls_servicio, ls_proveedor, ls_descripcion, &
			ls_mensaje, ls_nro_os, ls_moneda, ls_igv, ls_flag_o_e, &
			ls_origen
Decimal	ldec_monto_os,ldec_monto_fac			
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

ls_servicio			= em_servicio.text
ls_origen			= em_origen.text
ls_proveedor		= sle_proveedor.text
ls_descripcion		= sle_desc.text
ls_moneda			= sle_moneda.text

if cbx_igv.checked = true then
	ls_igv = 'CON_IGV'
ELSE
	ls_igv = 'SIN_IGV'
END IF

IF rb_1.checked THEN
	ls_flag_o_e = 'E'
ELSE
	ls_flag_o_e = 'O'
END IF

if IsNull(ls_origen) or ls_origen = '' then
	MessageBox('PRODUCCIÓN', 'NO HA SELECCIONADO UN ORIGEN',StopSign!)
	return
end if

if IsNull(ls_servicio) or ls_servicio = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UN SERVICIO VALIDO',StopSign!)
	return
end if

if IsNull(ls_proveedor) or ls_proveedor = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UN PROVEEDOR VALIDO',StopSign!)
	return
end if

if IsNull(ls_descripcion) or ls_descripcion = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UNA DESCRIPCIÓN VALIDA',StopSign!)
	return
end if

if MessageBox('PRODUCCIÓN','¿Esta seguro de realizar esta operacion?',Question!,yesno!) = 2 then
		return
End if

//CREATE OR REPLACE PROCEDURE USP_PROD_OS_TRANSPORTE(
//    asi_origen              IN   origen.cod_origen%Type,
//    adi_fecha_ini           IN   date,
//    adi_fecha_fin           IN   date,
//    asi_servicio            IN   servicios.servicio%Type,
//    asi_usuario             IN   usuario.cod_usr%Type,
//    asi_descripcion         IN   orden_servicio.descripcion%Type,
//    asi_proveedor           IN   orden_servicio.proveedor%Type,
//    asi_cod_moneda          IN   com_parte_rac.cod_moneda%Type,
//    asi_con_igv             IN   VARCHAR2,
//    asi_flag_o_e            IN   varchar2,
//    ani_monto_os            IN   orden_servicio_det.importe%TYPE,
//    ani_monto_fac           IN   orden_servicio_det.importe%TYPE,
//    aso_nro_os              OUT  orden_servicio.nro_os%TYPE   


//Verifica que la diferencia no sea mayor o menor a la especificada
em_monto_os.getdata	( ldec_monto_os)
em_monto_fac.getdata	( ldec_monto_fac)

DECLARE 	USP_PROD_OS_TRANSPORTE PROCEDURE FOR
			USP_PROD_OS_TRANSPORTE( :ls_origen, 
									 		:ld_fecha_ini, 
									 		:ld_fecha_fin, 
									 		:ls_servicio, 
									 		:gs_user, 
									 		:ls_descripcion, 
									 		:ls_proveedor, 
									 		:ls_moneda,
									 		:ls_igv,
											:ls_flag_o_e,
											:ldec_monto_os,
											:ldec_monto_fac) ;
EXECUTE 	USP_PROD_OS_TRANSPORTE ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_OS_TRANSPORTE: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_PROD_OS_TRANSPORTE INTO :ls_nro_os;
CLOSE USP_PROD_OS_TRANSPORTE;

MessageBox('PRODUCCIÓN', 'PROCESO REALIZADO DE MANERASATISFACTORIA', Information!)
st_nro_os.visible = true
st_nro_os.text 	= trim(ls_nro_os)
return
end event

public subroutine of_verificar_monto_os ();//funcion para verificar el monto de la OS
// Para Generer la Orden de Servicio Usando el Procedimiento

string 	ls_proveedor, ls_igv, ls_flag_o_e, ls_origen, ls_mensaje
Decimal  ld_monto_os			
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 		= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 		= date(uo_fecha.of_get_fecha2( ))

ls_origen			= em_origen.text
ls_proveedor		= sle_proveedor.text

if cbx_igv.checked = true then
	ls_igv = 'CON_IGV'
ELSE
	ls_igv = 'SIN_IGV'
END IF

IF rb_1.checked THEN
	ls_flag_o_e = 'E'
ELSE
	ls_flag_o_e = 'O'
END IF

if IsNull(ls_origen) or ls_origen = '' then
	MessageBox('PRODUCCIÓN', 'NO HA SELECCIONADO UN ORIGEN',StopSign!)
	return
end if


if IsNull(ls_proveedor) or ls_proveedor = '' then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UN PROVEEDOR VALIDO',StopSign!)
	return
end if

//CREATE OR REPLACE PROCEDURE USP_PROD_OS_VERIF_MONTO (
//    asi_origen              IN   origen.cod_origen%Type,
//    adi_fecha_ini           IN   date,
//    adi_fecha_fin           IN   date,
//    asi_proveedor           IN   orden_servicio.proveedor%Type,
//    asi_con_igv             IN   VARCHAR2,
//    asi_flag_o_e            IN   varchar2,
//    ado_monto_os            OUT  orden_servicio.monto_total%TYPE)  

DECLARE 	USP_PROD_OS_VERIF_MONTO PROCEDURE FOR
			USP_PROD_OS_VERIF_MONTO( :ls_origen, 
									 		:ld_fecha_ini, 
									 		:ld_fecha_fin, 
									 		:ls_proveedor, 
									 		:ls_igv,
											:ls_flag_o_e) ;

EXECUTE 	USP_PROD_OS_VERIF_MONTO ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_OS_VERIF_MONTO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_PROD_OS_VERIF_MONTO INTO :ld_monto_os;
CLOSE USP_PROD_OS_VERIF_MONTO;

em_monto_os.text 	= String(ld_monto_os)

end subroutine

on w_pr902_genera_os.create
int iCurrent
call super::create
if this.MenuName = "m_impresion_1" then this.MenuID = create m_impresion_1
this.em_monto_os=create em_monto_os
this.em_monto_fac=create em_monto_fac
this.em_dif=create em_dif
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.st_origen=create st_origen
this.st_proveedor=create st_proveedor
this.st_moneda=create st_moneda
this.st_servicio=create st_servicio
this.cb_1=create cb_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.em_origen=create em_origen
this.st_1=create st_1
this.em_servicio=create em_servicio
this.uo_fecha=create uo_fecha
this.st_2=create st_2
this.st_3=create st_3
this.sle_proveedor=create sle_proveedor
this.st_4=create st_4
this.sle_desc=create sle_desc
this.st_5=create st_5
this.st_os=create st_os
this.st_nro_os=create st_nro_os
this.cb_aceptar=create cb_aceptar
this.st_6=create st_6
this.sle_moneda=create sle_moneda
this.cbx_igv=create cbx_igv
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_monto_os
this.Control[iCurrent+2]=this.em_monto_fac
this.Control[iCurrent+3]=this.em_dif
this.Control[iCurrent+4]=this.st_9
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.st_7
this.Control[iCurrent+7]=this.st_origen
this.Control[iCurrent+8]=this.st_proveedor
this.Control[iCurrent+9]=this.st_moneda
this.Control[iCurrent+10]=this.st_servicio
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.rb_2
this.Control[iCurrent+13]=this.rb_1
this.Control[iCurrent+14]=this.em_origen
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.em_servicio
this.Control[iCurrent+17]=this.uo_fecha
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.st_3
this.Control[iCurrent+20]=this.sle_proveedor
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.sle_desc
this.Control[iCurrent+23]=this.st_5
this.Control[iCurrent+24]=this.st_os
this.Control[iCurrent+25]=this.st_nro_os
this.Control[iCurrent+26]=this.cb_aceptar
this.Control[iCurrent+27]=this.st_6
this.Control[iCurrent+28]=this.sle_moneda
this.Control[iCurrent+29]=this.cbx_igv
this.Control[iCurrent+30]=this.gb_3
this.Control[iCurrent+31]=this.gb_1
end on

on w_pr902_genera_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_monto_os)
destroy(this.em_monto_fac)
destroy(this.em_dif)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.st_origen)
destroy(this.st_proveedor)
destroy(this.st_moneda)
destroy(this.st_servicio)
destroy(this.cb_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.em_origen)
destroy(this.st_1)
destroy(this.em_servicio)
destroy(this.uo_fecha)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_proveedor)
destroy(this.st_4)
destroy(this.sle_desc)
destroy(this.st_5)
destroy(this.st_os)
destroy(this.st_nro_os)
destroy(this.cb_aceptar)
destroy(this.st_6)
destroy(this.sle_moneda)
destroy(this.cbx_igv)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;string ls_servicio, ls_desc_servicio

select s.servicio, s.descripcion
	into :ls_servicio, :ls_desc_servicio
from servicios s, costo_param c
	where s.servicio = c.servicio_transp;
	
em_servicio.text = ls_servicio
st_servicio.text = ls_desc_servicio
end event

event ue_print;call super::ue_print;STRING ls_cod_rel, ls_nro_os

str_parametros lstr_rep

ls_cod_rel = st_nro_os.text
ls_nro_os  = st_nro_os.text

lstr_rep.string1 = ls_cod_rel
lstr_rep.string2 = ls_nro_os
OpenSheetWithParm(w_cm314_orden_servicio_frm, lstr_rep, This, 2, layered!)
end event

type em_monto_os from editmask within w_pr902_genera_os
integer x = 594
integer y = 1392
integer width = 366
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type em_monto_fac from editmask within w_pr902_genera_os
integer x = 594
integer y = 1496
integer width = 366
integer height = 80
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type em_dif from editmask within w_pr902_genera_os
integer x = 1755
integer y = 1388
integer width = 169
integer height = 80
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean enabled = false
string text = "0.10"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type st_9 from statictext within w_pr902_genera_os
integer x = 1001
integer y = 1400
integer width = 750
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Diferencia Max/Min Permitida:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_8 from statictext within w_pr902_genera_os
integer x = 165
integer y = 1508
integer width = 393
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Monto Factura :"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_7 from statictext within w_pr902_genera_os
integer x = 215
integer y = 1404
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Monto OS :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_origen from statictext within w_pr902_genera_os
integer x = 283
integer y = 260
integer width = 658
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_proveedor from statictext within w_pr902_genera_os
integer x = 933
integer y = 812
integer width = 1070
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_moneda from statictext within w_pr902_genera_os
integer x = 933
integer y = 728
integer width = 1070
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_servicio from statictext within w_pr902_genera_os
integer x = 933
integer y = 640
integer width = 1070
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr902_genera_os
integer x = 137
integer y = 1252
integer width = 425
integer height = 96
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Verificar Datos"
end type

event clicked;//Llamar a la funcion para calcular el monto de la OS 
of_verificar_monto_os()
end event

type rb_2 from radiobutton within w_pr902_genera_os
integer x = 123
integer y = 452
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Obreros"
end type

type rb_1 from radiobutton within w_pr902_genera_os
integer x = 123
integer y = 380
integer width = 379
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Empleados"
boolean checked = true
end type

type em_origen from singlelineedit within w_pr902_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 133
integer y = 260
integer width = 128
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_origen.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	this.text = ''
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	this.text = ''
	st_origen.text = ''
	return
end if

st_origen.text = ls_desc

end event

type st_1 from statictext within w_pr902_genera_os
integer x = 398
integer y = 52
integer width = 1458
integer height = 92
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Detalle de la OS de Transporte"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_servicio from singlelineedit within w_pr902_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 626
integer y = 640
integer width = 283
integer height = 72
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT S.SERVICIO as Código, " & 
		  +"S.DESCRIPCION AS DESCRIPCION " &
		  + "FROM SERVICIOS S " &
		  + "WHERE flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_servicio.text = ls_data
end if

end event

event modified;String 	ls_servi, ls_desc

ls_servi = this.text
if ls_servi = '' or IsNull(ls_servi) then
	MessageBox('Aviso', 'Debe Ingresar un Servicio')
	return
end if

SELECT 	DESCRIPCION INTO :ls_desc
FROM 		SERVICIOS
WHERE 	SERVICIO =:ls_servi;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Servicio no existe')
	return
end if

st_servicio.text = ls_desc

end event

type uo_fecha from u_ingreso_rango_fechas_v within w_pr902_genera_os
event destroy ( )
integer x = 1198
integer y = 324
integer height = 220
integer taborder = 90
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type st_2 from statictext within w_pr902_genera_os
integer x = 1189
integer y = 240
integer width = 622
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pr902_genera_os
integer x = 142
integer y = 640
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Servicio"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_proveedor from singlelineedit within w_pr902_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 626
integer y = 812
integer width = 283
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT P.PROVEEDOR as Código, " & 
		  +"P.NOM_PROVEEDOR AS Nombre " &
		  + "FROM PROVEEDOR P " &
		  + "WHERE P.flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_proveedor.text = ls_data
end if

end event

event modified;String 	ls_pro, ls_desc

ls_pro = this.text
if ls_pro = '' or IsNull(ls_pro) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Proveedor')
	return
end if

SELECT NOM_PROVEEDOR INTO :ls_desc
FROM 	 PROVEEDOR	
WHERE  PROVEEDOR =:ls_pro;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Proveedor no existe')
	This.text 			= ''
	st_proveedor.text = ''
	return
end if

st_proveedor.text = ls_desc

end event

type st_4 from statictext within w_pr902_genera_os
integer x = 142
integer y = 808
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Proveedor"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_desc from singlelineedit within w_pr902_genera_os
integer x = 142
integer y = 988
integer width = 1815
integer height = 208
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_pr902_genera_os
integer x = 142
integer y = 904
integer width = 1815
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Descripción"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_os from statictext within w_pr902_genera_os
integer x = 827
integer y = 1728
integer width = 457
integer height = 136
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro. De Orden de Servico:"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_nro_os from statictext within w_pr902_genera_os
boolean visible = false
integer x = 1394
integer y = 1756
integer width = 539
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type cb_aceptar from picturebutton within w_pr902_genera_os
integer x = 169
integer y = 1728
integer width = 530
integer height = 132
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar OS"
string picturename = "H:\source\BMP\ACEPTARE.BMP"
alignment htextalign = right!
end type

event clicked;Decimal	ldec_monto_os, ldec_dif, ldec_monto_fac, ldec_resta

//Verifica que la diferencia no sea mayor o menor a la especificada
em_monto_os.getdata	( ldec_monto_os)
em_dif.getdata			( ldec_dif)
em_monto_fac.getdata	( ldec_monto_fac)

IF ldec_monto_os = 0 THEN
	messagebox('Aviso', "Por favor click en boton 'Verificar Datos'")
	RETURN
ELSEIF ldec_monto_fac = 0 THEN
	messagebox('Aviso', 'Ingrese monto de Factura')
	RETURN
END IF

ldec_resta = ABS(ldec_monto_os - ldec_monto_fac)

IF ldec_Resta > ldec_dif THEN
	messagebox('Aviso', 'La diferencia de montos no es permitida')
	RETURN
END IF

//Llama al procedimiento para generar la OS
parent.event ue_generar_os()
end event

type st_6 from statictext within w_pr902_genera_os
integer x = 142
integer y = 728
integer width = 471
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Moneda"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_moneda from singlelineedit within w_pr902_genera_os
event dobleclick pbm_lbuttondblclk
integer x = 626
integer y = 728
integer width = 283
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 12
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT M.COD_MONEDA AS CODIGO, " & 
		  +"M.DESCRIPCION AS MONEDA " &
		  + "FROM MONEDA M " &
		  + "WHERE M.flag_estado = '1' "
		  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_moneda.text = ls_data
end if


end event

event modified;String 	ls_moneda, ls_desc

ls_moneda = this.text
if ls_moneda = '' or IsNull(ls_moneda) then
	MessageBox('Aviso', 'Debe Ingresar una Moneda')
	return
end if

SELECT DESCRIPCION INTO :ls_desc
FROM 	 MONEDA	
WHERE  COD_MONEDA =:ls_moneda;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Moneda no existe')
	This.Text 		= ''
	st_moneda.text = ''
	return
end if
		  
st_moneda.text = ls_desc

end event

type cbx_igv from checkbox within w_pr902_genera_os
integer x = 133
integer y = 536
integer width = 485
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Considera IGV"
boolean checked = true
end type

type gb_3 from groupbox within w_pr902_genera_os
integer x = 105
integer y = 200
integer width = 882
integer height = 164
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_pr902_genera_os
integer x = 78
integer y = 152
integer width = 1957
integer height = 1492
integer taborder = 70
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

