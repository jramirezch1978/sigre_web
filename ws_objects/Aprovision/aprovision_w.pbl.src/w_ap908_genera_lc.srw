$PBExportHeader$w_ap908_genera_lc.srw
forward
global type w_ap908_genera_lc from w_abc
end type
type st_forma from statictext within w_ap908_genera_lc
end type
type sle_forma_pago from singlelineedit within w_ap908_genera_lc
end type
type st_forma_pago from statictext within w_ap908_genera_lc
end type
type st_impuesto from statictext within w_ap908_genera_lc
end type
type sle_impuesto from singlelineedit within w_ap908_genera_lc
end type
type st_8 from statictext within w_ap908_genera_lc
end type
type sle_serie from singlelineedit within w_ap908_genera_lc
end type
type st_4 from statictext within w_ap908_genera_lc
end type
type st_7 from statictext within w_ap908_genera_lc
end type
type sle_origen from singlelineedit within w_ap908_genera_lc
end type
type st_origen from statictext within w_ap908_genera_lc
end type
type st_desc_moneda from statictext within w_ap908_genera_lc
end type
type sle_moneda from singlelineedit within w_ap908_genera_lc
end type
type st_5 from statictext within w_ap908_genera_lc
end type
type st_confin from statictext within w_ap908_genera_lc
end type
type sle_confin from singlelineedit within w_ap908_genera_lc
end type
type st_3 from statictext within w_ap908_genera_lc
end type
type st_2 from statictext within w_ap908_genera_lc
end type
type uo_fechas from u_ingreso_rango_fechas within w_ap908_genera_lc
end type
type pb_1 from picturebutton within w_ap908_genera_lc
end type
type pb_2 from picturebutton within w_ap908_genera_lc
end type
type st_1 from statictext within w_ap908_genera_lc
end type
end forward

global type w_ap908_genera_lc from w_abc
integer width = 3497
integer height = 1624
string title = "[AP908] GENERA LIQUIDACION DE COMPRAS PARA LOS PRODUCTORES"
string menuname = "m_salir"
boolean resizable = false
event ue_aceptar ( )
event ue_salir ( )
st_forma st_forma
sle_forma_pago sle_forma_pago
st_forma_pago st_forma_pago
st_impuesto st_impuesto
sle_impuesto sle_impuesto
st_8 st_8
sle_serie sle_serie
st_4 st_4
st_7 st_7
sle_origen sle_origen
st_origen st_origen
st_desc_moneda st_desc_moneda
sle_moneda sle_moneda
st_5 st_5
st_confin st_confin
sle_confin sle_confin
st_3 st_3
st_2 st_2
uo_fechas uo_fechas
pb_1 pb_1
pb_2 pb_2
st_1 st_1
end type
global w_ap908_genera_lc w_ap908_genera_lc

forward prototypes
public subroutine of_get_monto_selecc ()
end prototypes

event ue_aceptar();// Para actualizar los costos de ultima compra

string 	ls_mensaje, ls_moneda, ls_proveedor, ls_origen, &
			ls_parte, ls_confin, ls_impuesto, ls_serie, ls_forma_pago
date 		ld_fecha1, ld_fecha2
integer	li_i

try 
	
	SetPointer (HourGlass!)
	
	ls_confin = sle_confin.text
	if ls_confin = '' then
		MessageBox('Error', 'Debe seleccionar un Concepto Financiero')
		sle_confin.setFocus( )
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
	
	ls_forma_pago = sle_forma_pago.text
	if ls_forma_pago = '' then
		MessageBox('Error', 'Debe seleccionar una Forma de Pago')
		sle_forma_pago.setFocus( )
		return
	end if
	
	ls_serie = sle_serie.text
	if ls_serie = '' then
		MessageBox('Error', 'Debe seleccionar una Serie')
		sle_serie.setFocus( )
		return
	end if
	
	ld_fecha1 = uo_fechas.of_get_fecha1( )
	ld_fecha2 = uo_fechas.of_get_fecha2( )
	
	//create or replace procedure USP_AP_GEN_LC_COS(
	//       adi_fecha1        in date,
	//       adi_Fecha2        in date,
	//       asi_origen        in origen.cod_origen%TYPE,
	//       asi_confin        in concepto_financiero.confin%TYPE,
	//       asi_serie         in string,
	//       asi_moneda        in moneda.cod_moneda%TYPE,
	//       asi_impuesto      in impuestos_tipo.tipo_impuesto%TYPE,
	//       asi_cod_usr       in usuario.cod_usr%TYPE,
	//       asi_forma_pago    in forma_pago.forma_pago%TYPE
	//) is
	
	DECLARE USP_AP_GEN_LC_COS PROCEDURE FOR
					USP_AP_GEN_LC_COS( :ld_fecha1,
											 :ld_Fecha2,
											 :ls_origen,
											 :ls_confin,
											 :ls_serie,
											 :ls_moneda,
											 :ls_impuesto,
											 :gs_user,
											 :ls_forma_pago);
	 
	EXECUTE USP_AP_GEN_LC_COS;
	 
	IF SQLCA.sqlcode = -1 THEN
		 ls_mensaje = "Error al ejecutar PROCEDURE USP_AP_GEN_LC_COS: " + SQLCA.SQLErrText
		 ROLLBACK ;
		 MessageBox('SQL error', ls_mensaje, StopSign!) 
		 RETURN 
	END IF
	
	CLOSE USP_AP_GEN_LC_COS;
	
	MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')
	 
	
catch ( Exception ex)
	gnvo_app.of_catch_exception( ex, '')
	
finally
	SetPointer (Arrow!)
	
end try


end event

event ue_salir();close(this)
end event

public subroutine of_get_monto_selecc ();
end subroutine

on w_ap908_genera_lc.create
int iCurrent
call super::create
if this.MenuName = "m_salir" then this.MenuID = create m_salir
this.st_forma=create st_forma
this.sle_forma_pago=create sle_forma_pago
this.st_forma_pago=create st_forma_pago
this.st_impuesto=create st_impuesto
this.sle_impuesto=create sle_impuesto
this.st_8=create st_8
this.sle_serie=create sle_serie
this.st_4=create st_4
this.st_7=create st_7
this.sle_origen=create sle_origen
this.st_origen=create st_origen
this.st_desc_moneda=create st_desc_moneda
this.sle_moneda=create sle_moneda
this.st_5=create st_5
this.st_confin=create st_confin
this.sle_confin=create sle_confin
this.st_3=create st_3
this.st_2=create st_2
this.uo_fechas=create uo_fechas
this.pb_1=create pb_1
this.pb_2=create pb_2
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_forma
this.Control[iCurrent+2]=this.sle_forma_pago
this.Control[iCurrent+3]=this.st_forma_pago
this.Control[iCurrent+4]=this.st_impuesto
this.Control[iCurrent+5]=this.sle_impuesto
this.Control[iCurrent+6]=this.st_8
this.Control[iCurrent+7]=this.sle_serie
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_7
this.Control[iCurrent+10]=this.sle_origen
this.Control[iCurrent+11]=this.st_origen
this.Control[iCurrent+12]=this.st_desc_moneda
this.Control[iCurrent+13]=this.sle_moneda
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.st_confin
this.Control[iCurrent+16]=this.sle_confin
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.uo_fechas
this.Control[iCurrent+20]=this.pb_1
this.Control[iCurrent+21]=this.pb_2
this.Control[iCurrent+22]=this.st_1
end on

on w_ap908_genera_lc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_forma)
destroy(this.sle_forma_pago)
destroy(this.st_forma_pago)
destroy(this.st_impuesto)
destroy(this.sle_impuesto)
destroy(this.st_8)
destroy(this.sle_serie)
destroy(this.st_4)
destroy(this.st_7)
destroy(this.sle_origen)
destroy(this.st_origen)
destroy(this.st_desc_moneda)
destroy(this.sle_moneda)
destroy(this.st_5)
destroy(this.st_confin)
destroy(this.sle_confin)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.uo_fechas)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.st_1)
end on

type st_forma from statictext within w_ap908_genera_lc
integer x = 32
integer y = 996
integer width = 389
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Forma Pago:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_forma_pago from singlelineedit within w_ap908_genera_lc
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 992
integer width = 352
integer height = 92
integer taborder = 50
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

ls_sql = "select forma_pago as forma_pago, " &
		 + "desc_forma_pago as descripcion_forma_pago " &
		 + "from forma_pago " &
		 + "where flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_forma_pago.text = ls_data
end if
end event

type st_forma_pago from statictext within w_ap908_genera_lc
integer x = 805
integer y = 992
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

type st_impuesto from statictext within w_ap908_genera_lc
integer x = 805
integer y = 856
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

type sle_impuesto from singlelineedit within w_ap908_genera_lc
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 856
integer width = 352
integer height = 92
integer taborder = 50
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

ls_sql = "select tipo_impuesto as tipo_impuesto, " &
		 + "desc_impuesto as descripcion_impuesto " &
		 + "from impuestos_tipo"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_impuesto.text = ls_data
end if
end event

type st_8 from statictext within w_ap908_genera_lc
integer x = 32
integer y = 860
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
string text = "Impuesto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_serie from singlelineedit within w_ap908_genera_lc
event dobleclick pbm_lbuttondblclk
integer x = 439
integer y = 720
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
string ls_codigo, ls_data, ls_sql

ls_sql = "select n.tipo_doc as tipo_doc, lpad(n.nro_serie, 4, '0') as serie " &
		 + "from num_doc_tipo n, " &
		 + "     doc_tipo_usuario dtu " &
		 + "where dtu.tipo_doc = n.tipo_doc " &
		 + "  and n.tipo_doc = (Select ap.doc_lc from ap_param ap where ap.origen = 'XX')" &
		 + "  and dtu.cod_usr = '" + gs_user + "'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_data
end if
end event

type st_4 from statictext within w_ap908_genera_lc
integer x = 27
integer y = 724
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
string text = "Serie:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_ap908_genera_lc
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

type sle_origen from singlelineedit within w_ap908_genera_lc
event dobleclick pbm_lbuttondblclk
integer x = 439
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
string ls_codigo, ls_data, ls_sql

ls_sql = "select cod_origen as codigo_origen, " &
		 + "nombre as nombre_origen " &
		 + "from origen " &
		 + "where flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_origen.text = ls_data
end if

end event

type st_origen from statictext within w_ap908_genera_lc
integer x = 805
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

type st_desc_moneda from statictext within w_ap908_genera_lc
integer x = 805
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

type sle_moneda from singlelineedit within w_ap908_genera_lc
event dobleclick pbm_lbuttondblclk
integer x = 439
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

type st_5 from statictext within w_ap908_genera_lc
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

type st_confin from statictext within w_ap908_genera_lc
integer x = 805
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

type sle_confin from singlelineedit within w_ap908_genera_lc
event dobleclick pbm_lbuttondblclk
integer x = 439
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

ls_sql = "select confin as concepto_financiero, " &
		 + "descripcion as descripcion_confin " &
		 + "from concepto_financiero " &
		 + "where flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
	st_confin.text = ls_data
end if

end event

type st_3 from statictext within w_ap908_genera_lc
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
string text = "Con. Fin:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ap908_genera_lc
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

type uo_fechas from u_ingreso_rango_fechas within w_ap908_genera_lc
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

type pb_1 from picturebutton within w_ap908_genera_lc
integer x = 1138
integer y = 1116
integer width = 503
integer height = 296
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
parent.event ue_refresh( )
end event

type pb_2 from picturebutton within w_ap908_genera_lc
integer x = 1637
integer y = 1116
integer width = 503
integer height = 296
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

type st_1 from statictext within w_ap908_genera_lc
integer x = 55
integer y = 40
integer width = 3099
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
string text = "GENERA LIQUIDACION DE COMPRAS PARA LOS PRODUCTORES"
alignment alignment = center!
boolean focusrectangle = false
end type

