$PBExportHeader$w_abc_seleccion.srw
forward
global type w_abc_seleccion from w_abc_list
end type
type st_campo from statictext within w_abc_seleccion
end type
type dw_text from datawindow within w_abc_seleccion
end type
type cb_1 from commandbutton within w_abc_seleccion
end type
end forward

global type w_abc_seleccion from w_abc_list
integer width = 2994
integer height = 1352
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_campo st_campo
dw_text dw_text
cb_1 cb_1
end type
global w_abc_seleccion w_abc_seleccion

type variables
String  	is_col = '', is_tipo, is_type, is_soles, is_tipo_alm, &
			is_oper_cons_int, is_almacen
Date id_fecha
Double in_tipo_cambio
str_parametros 			ist_datos

end variables

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
end prototypes

public function boolean of_opcion1 ();// Agregar los registros en el detalle de la Guia de recepcion
Long   	ll_row, ll_i, ll_find
Decimal	ldc_precio_venta, ldc_importe
string	ls_mon_grmp, ls_mon_pdd, ls_alm_dest, ls_origen
DateTime ldt_fecha

u_dw_abc ldw_detail, ldw_master

ldw_detail = ist_datos.dw_d	// detail
ldw_master = ist_datos.dw_m	// master

ll_row = ldw_master.GetRow()
if ll_row = 0 then return false

ls_mon_grmp = ldw_master.object.cod_moneda[ll_row]

if ls_mon_grmp = '' or IsNull(ls_mon_grmp) then
	MessageBox('Aviso', 'La cabecera de la Guia no tiene codigo de moneda, por favor verifique')
	return false
end if

// obtener el almacen de destino por codigo de origen
ls_origen = ldw_master.object.origen [ll_row]
select almacen
 into :ls_alm_dest
from ap_param
where origen = :ls_origen;

FOR ll_i = 1 TO dw_2.RowCount()								
	ll_find = ldw_detail.find("nro_parte = '" + trim(dw_2.Object.nro_parte[ll_i]) + &
										 "' and item_parte = " + string(dw_2.Object.item[ll_i]), 1, ldw_detail.rowcount( ) )
	IF ll_find <= 0 THEN
		ll_row = ldw_detail.event ue_insert()
		IF ll_row > 0 THEN
			ldw_detail.ii_update = 1
			ldw_detail.Object.item 		   	[ll_row] = ll_row
			ldw_detail.Object.nro_parte		[ll_row] = dw_2.Object.nro_parte			[ll_i]
			ldw_detail.Object.item_parte  	[ll_row] = dw_2.Object.item				[ll_i]
			ldw_detail.Object.inicio_descarga[ll_row] = dw_2.object.inicio_descarga [ll_i]
			ldw_detail.Object.descr_especie  [ll_row] = dw_2.Object.descr_especie	[ll_i]
			ldw_detail.Object.peso_bruto  	[ll_row] = dw_2.Object.peso_bruto		[ll_i]
			ldw_detail.Object.peso_variacion	[ll_row] = dw_2.Object.peso_variacion	[ll_i]
			IF dw_2.object.flag_variacion		[ll_i] = 'R' THEN
				ldw_detail.Object.peso_venta  [ll_row] = Dec(dw_2.Object.peso_bruto  [ll_i]) + Dec(dw_2.Object.peso_variacion	[ll_i])
			ELSE
				ldw_detail.Object.peso_venta  [ll_row] = Dec(dw_2.Object.peso_bruto  [ll_i]) - Dec(dw_2.Object.peso_variacion	[ll_i])
			END IF	
			ldw_detail.Object.nro_ticket   	[ll_row] = dw_2.Object.nro_ticket		[ll_i]
			ldw_detail.Object.und				[ll_row] = dw_2.Object.und					[ll_i]		
			ldw_detail.Object.desc_maq  		[ll_row] = dw_2.object.desc_maq			[ll_i]
			ldw_detail.Object.cod_moneda  	[ll_row] = dw_2.object.cod_moneda		[ll_i]  
			ldw_detail.Object.precio_venta	[ll_row] = dw_2.object.precio_venta		[ll_i]
			ldw_detail.Object.descr_usos		[ll_row] = dw_2.Object.descr_usos		[ll_i]
			
			//Agrega el almacen de destino y el flag de Reporte al Dw_detalle
			IF Not IsNull(ls_alm_dest) THEN
				ldw_detail.object.almacen_dst [ll_row] = ls_alm_dest
				ldw_detail.object.flag_reporte[ll_row] = '1'  // Por defecto declara
			END IF
			
			ls_mon_pdd  = dw_2.object.cod_moneda		[ll_i]  
			ldc_importe = Dec(dw_2.object.precio_venta[ll_i])
			
			//obtengo la fecha de inicio de descarga
			ldt_fecha = dw_2.object.inicio_descarga[ll_i]
			//DateTime(ldw_master.object.fecha_registro[ll_row])
			
			select usf_fl_conv_mon(:ldc_importe, :ls_mon_pdd, :ls_mon_grmp, :ldt_fecha)
				into :ldc_precio_venta
			from dual;
			
			ldw_detail.Object.precio_unitario [ll_row] = ldc_precio_venta
			
			ist_datos.w1.function dynamic of_set_total() //actualiza el monto de la guia
			
		END IF
		
	END IF					
NEXT				

RETURN TRUE

end function

public function boolean of_opcion2 ();// Concatenar las especies

String 	ls_especie, ls_separador
Integer  ll_i

							
For ll_i = 1 To dw_2.RowCount()
	
		if ls_especie <>'' THEN ls_separador = ', '
		ls_especie = ls_especie + ls_separador + dw_2.Object.especie[ll_i]
Next

ist_datos.field_ret[1]   = ls_especie

return true

end function

on w_abc_seleccion.create
int iCurrent
call super::create
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
end on

on w_abc_seleccion.destroy
call super::destroy
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;Long 		ll_row
string 	ls_articulo
date		ld_fecha
u_dw_abc	ldw_master

ii_access = 1   // sin menu

// Recoge parametro enviado
//if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
//	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
//	return
//end if
//
//If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
//	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
//	return
//end if
//
//ist_datos = MESSAGE.POWEROBJECTPARM	

is_tipo = ist_datos.tipo
dw_1.DataObject = ist_datos.dw1
dw_2.DataObject = ist_datos.dw1
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve( ist_datos.string1 )
		CASE '2S'				
			ll_row = dw_1.Retrieve( ist_datos.string1, ist_datos.string2)
	END CHOOSE
END IF

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")
st_campo.text = "Orden: " + is_col


end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion
event type integer ue_selected_row_now ( long al_row )
integer x = 0
integer y = 140
integer width = 1362
boolean hscrollbar = true
boolean vscrollbar = true
end type

event type integer dw_1::ue_selected_row_now(long al_row);Long			ll_row, ll_rc, ll_nro_mov, j, ll_count
Any			la_id
Integer		li_x

// Valida codigo

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT
	
return 1

end event

event dw_1::constructor;call super::constructor;
// Recoge parametro enviado

IF ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	Return
END IF

IF Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	Return
END IF

ist_datos = MESSAGE.POWEROBJECTPARM

is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

CHOOSE CASE ist_datos.opcion 
	 CASE 1 //Parte Diario de Descarga
		   ii_ck[1] = 1			// columnas de lectrua de este dw
			ii_ck[2] = 2
			ii_ss = 0
			
	CASE 2 //Para elegir Especies en Reporte
			ii_ck[1] = 1							
			ii_ss = 0
			
END CHOOSE


	
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)	
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row();//
Long	ll_row, ll_y

dw_2.ii_update = 1

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	// si retorna 0 (fallo en el row_now), deselecciona
	if THIS.EVENT ue_selected_row_now(ll_row) = 0 then
		this.selectRow(ll_row, false);
	end if
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()


end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion
integer x = 1600
integer y = 144
integer width = 1362
integer taborder = 50
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;CHOOSE CASE ist_datos.opcion 
	 CASE 1 //Parte Diario de Descarga
		   ii_ck[1] = 1			// columnas de lectrua de este dw
			ii_ck[2] = 2
			ii_ss = 0
			
	CASE 2 //Para elegir Especies en Reporte
			ii_ck[1] = 1							
			ii_ss = 0
			
END CHOOSE


end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT
	
idw_det.ScrollToRow(ll_row)


end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion
integer x = 1426
integer y = 440
integer taborder = 30
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion
integer x = 1417
integer y = 980
integer taborder = 40
end type

type st_campo from statictext within w_abc_seleccion
integer x = 23
integer y = 20
integer width = 713
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_abc_seleccion
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 745
integer y = 16
integer width = 1449
integer height = 80
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
	   
		IF UPPER( is_type) = 'D' then
			ls_comando = "UPPER(LEFT(STRING(" + is_col +")," + String(li_longitud) + "))='" + ls_item + "'"
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF	

//		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_abc_seleccion
integer x = 2583
integer y = 24
integer width = 338
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 
CHOOSE CASE ist_datos.opcion
	
	CASE 1 // Partes Diarios de descarga
		if of_opcion1() then 
			ist_datos.titulo = 's'
		else
			return
		end if
		
	CASE 2
		
		if of_opcion2() then 
			ist_datos.titulo = 's'
		else
			return
		end if

END CHOOSE
CloseWithReturn( parent, ist_datos)
end event

