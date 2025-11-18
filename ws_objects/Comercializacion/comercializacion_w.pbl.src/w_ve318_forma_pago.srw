$PBExportHeader$w_ve318_forma_pago.srw
forward
global type w_ve318_forma_pago from w_abc
end type
type dw_forma_pago from u_dw_abc within w_ve318_forma_pago
end type
type cb_cancelar from commandbutton within w_ve318_forma_pago
end type
type cb_aceptar from commandbutton within w_ve318_forma_pago
end type
type dw_master from u_dw_abc within w_ve318_forma_pago
end type
end forward

global type w_ve318_forma_pago from w_abc
integer width = 3003
integer height = 1136
string title = "[VE318] Elija la forma de pago adecuada"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
dw_forma_pago dw_forma_pago
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_ve318_forma_pago w_ve318_forma_pago

type variables
u_dw_abc			idw_formas_pago, idw_master
string			is_tipo_doc
str_parametros	istr_param
end variables

forward prototypes
public function boolean of_valida_precio_consig ()
end prototypes

event ue_aceptar;str_parametros lstr_param
String 	ls_flag_forma_pago, ls_tipo_tarjeta, ls_nro_tj1, ls_nro_tj2, ls_nro_tj3, &
			ls_nro_tj4, ls_ccv, ls_forma_pago, ls_consignatario, ls_desc_forma_pago, &
			ls_nom_proveedor, ls_ruc_dni, ls_tipo_doc, ls_nro_doc, ls_cod_ctabco, &
			ls_nom_banco, ls_flag_tipo_credito, ls_cod_banco_cred, ls_nom_banco_cred
Date		ld_fec_vencimiento, ld_primer_vencimiento
Decimal	ldc_monto, ldc_monto_pago, ldc_nro_cuotas, ldc_porc_interes, ldc_nro_cuotas_max
Long		ll_row
Integer	li_factor

ls_flag_forma_pago 		= dw_forma_pago.object.flag_forma_pago			[1]
ls_tipo_tarjeta	 		= dw_master.object.tipo_tarjeta 					[1]
ls_nro_tj1 					= dw_master.object.nro_tj1 						[1]
ls_nro_tj2 					= dw_master.object.nro_tj2 						[1]
ls_nro_tj3 					= dw_master.object.nro_tj3 						[1]
ls_nro_tj4 					= dw_master.object.nro_tj4 						[1]
ls_ccv						= dw_master.object.ccv 								[1]
ld_fec_vencimiento 		= Date(dw_master.object.fec_vencimiento 		[1])
ld_primer_vencimiento 	= Date(dw_master.object.primer_vencimiento 	[1])
ldc_monto					= Dec(dw_master.object.monto 						[1])
ldc_monto_pago				= Dec(dw_master.object.monto_pago 				[1])
ls_forma_pago				= dw_master.object.forma_pago						[1]
ls_desc_forma_pago		= dw_master.object.desc_forma_pago				[1]
ls_consignatario			= dw_master.object.consignatario					[1]
ls_nom_proveedor			= dw_master.object.nom_proveedor					[1]
ls_ruc_dni					= dw_master.object.ruc_dni							[1]
ls_tipo_doc					= dw_master.object.tipo_doc						[1]
ls_nro_doc					= dw_master.object.nro_doc							[1]
ls_cod_ctabco				= dw_master.object.cod_ctabco						[1]
ls_nom_banco				= dw_master.object.nom_banco						[1]
ls_flag_tipo_credito		= dw_master.object.flag_tipo_credito			[1]
ldc_nro_cuotas				= Dec(dw_master.object.nro_cuotas 				[1])
ldc_porc_interes			= Dec(dw_master.object.porc_interes 			[1])
li_factor					= Int(dw_master.object.factor						[1])
//Banco para Credito Bancario
ls_cod_banco_cred			= dw_master.object.cod_banco_cred				[1]
ls_nom_banco_cred			= dw_master.object.nom_banco_cred				[1]

If IsNull(ldc_nro_cuotas) then ldc_nro_cuotas = 0
If IsNull(ldc_porc_interes) then ldc_porc_interes = 0


if IsNull(ldc_monto_pago) or ldc_monto_pago = 0 then 
	MessageBox("Error", "Debe ingresar el monto correspondiente al cobro del comprobante. Por favor verifique!", StopSign!)
	dw_master.SetColumn("monto_pago")
	return
end if

if ldc_monto_pago < ldc_monto then
	if MessageBox("Información", "El monto ingresado es menor al importe vendido. Desea continuar?", Information!, YesNo!, 2) = 2 then 
		dw_master.SetColumn("monto_pago")
		return
	end if

end if

//Si la forma de pago es consignación, el nro de cuotas no debe exceder al maximo permitido
if ls_flag_forma_pago = 'D' then
	if IsNull(ls_cod_ctabco) or trim(ls_cod_ctabco) = '' then 
		MessageBox("Error", "Debe Indicar el nro de cuenta bancaria donde se realizó el deposito. Por favor verifique!", StopSign!)
		return
	end if
	
	if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' then 
		MessageBox("Error", "Debe Indicar el Tipo de documento del deposito. Por favor verifique!", StopSign!)
		return
	end if


	if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then 
		MessageBox("Error", "Debe Indicar el NUMERO del documento del deposito. Por favor verifique!", StopSign!)
		return
	end if
end if


if ls_flag_forma_pago = 'T' then
	if IsNull(ls_tipo_tarjeta) or ls_tipo_tarjeta = '' then
		MessageBox("Error", "Debe especificar el TIPO DE TARJETA con la que esta pagando", StopSign!)
		dw_master.SetColumn("tipo_tarjeta")
		return 
	end if
	if IsNull(ls_nro_tj1) or ls_nro_tj1 = '' then
		MessageBox("Error", "Debe especificar el numero completo de la tarjeta", StopSign!)
		dw_master.SetColumn("nro_tj1")
		return 
	end if
	if IsNull(ls_nro_tj2) or ls_nro_tj2 = '' then
		MessageBox("Error", "Debe especificar el numero completo de la tarjeta", StopSign!)
		dw_master.SetColumn("nro_tj2")
		return 
	end if
	if IsNull(ls_nro_tj3) or ls_nro_tj3 = '' then
		MessageBox("Error", "Debe especificar el numero completo de la tarjeta", StopSign!)
		dw_master.SetColumn("nro_tj3")
		return 
	end if
	if IsNull(ls_nro_tj4) or ls_nro_tj4 = '' then
		MessageBox("Error", "Debe especificar el numero completo de la tarjeta", StopSign!)
		dw_master.SetColumn("nro_tj4")
		return 
	end if
	if IsNull(ls_ccv) or ls_ccv = '' then
		MessageBox("Error", "Debe especificar el numero CCV de la tarjeta", StopSign!)
		dw_master.SetColumn("ccv")
		return 
	end if
	if IsNull(ld_fec_vencimiento) then
		MessageBox("Error", "Debe especificar la fecha de vencimiento de la tarjeta", StopSign!)
		dw_master.SetColumn("fec_vencimiento")
		return 
	end if
end if

//Credito
if ls_flag_forma_pago = 'C' then
	if ISNull(ls_flag_tipo_Credito) or trim(ls_flag_tipo_credito) = "" then
		MessageBox("Error", "no ha indicado el Tipo de Credito. Por favor verifique!", StopSign!)
		dw_master.SetColumn("flag_tipo_credito")
		return
	end if
	
	if ls_flag_tipo_Credito = 'A' then
		//Credito Directo, tiene cuotas y porcentaje de interes
		if ldc_nro_cuotas = 0 then
			MessageBox("Error", "En un crédito directo debe indicar el numero de cuotas. Por favor verifique!", StopSign!)
			dw_master.SetColumn("nro_cuotas")
			return
		end if
		if ldc_porc_interes = 0 then
			if MessageBox("Error", "Ha indicado un credito directo, pro no ha indicado un porcentaje de INTERES. ¿Desea Continuar con un interes de 0.00%?", Question!, YesNo!, 2) = 2 then
				dw_master.SetColumn("porc_interes")
				return
			end if
		end if
	elseif ls_flag_tipo_Credito = 'B' then
		//Credito Bancario
		if ldc_nro_cuotas <> 1 then
			MessageBox("Error", "En un credito bancario solo esta permitido una solca cuota. Por favor verifique!", StopSign!)
			dw_master.SetColumn("nro_cuotas")
			return
		end if
		if IsNull(ls_cod_banco_cred) or trim(ls_cod_banco_cred) = '' then
			MessageBox("Error", "En un credito bancario debe indicar el banco. Por favor verifique!", StopSign!)
			dw_master.SetColumn("cod_banco_cred")
			return
		end if
	end if
end if

//Si la forma de pago es consignación, el nro de cuotas no debe exceder al maximo permitido
if ls_flag_forma_pago = 'O' then
	if IsNull(ls_consignatario) or ls_consignatario = '' then
		MessageBox("Error", "Debe Ingresar un consignatario de manera obligatoria. Por favor verifique!", StopSign!)
		return
	end if

	select nvl(nro_cuotas_max, 1)
		into :ldc_nro_cuotas_max
	from consignatarios
	where consignatario = :ls_consignatario;
	
	if SQLCA.SQLCode = 100 then
		MessageBox("Error", "El código de consignatario " + ls_consignatario + " no existe. Por favor verifique!", StopSign!)
		return
	end if
	
	if IsNull(ldc_nro_cuotas_max) or ldc_nro_cuotas_max = 0 then 
		ldc_nro_cuotas_max = 1
	end if
	
	if ldc_nro_cuotas > ldc_nro_cuotas_max then
		MessageBox("Error", "El numero de cuotas no puede exceder al maximo de " + string(ldc_nro_cuotas_max, "###,##0") + ". Por favor verifique!", StopSign!)
		return
	end if

end if


//Si todo esta bien inserto el detalle de la forma de pago
ll_row = idw_formas_pago.event ue_insert()

if ll_row > 0 then
	idw_formas_pago.object.flag_forma_pago 	[ll_row] = ls_flag_forma_pago
	idw_formas_pago.object.tipo_tarjeta 		[ll_row] = ls_tipo_tarjeta
	idw_formas_pago.object.nro_tj1 				[ll_row] = ls_nro_tj1
	idw_formas_pago.object.nro_tj2 				[ll_row] = ls_nro_tj2
	idw_formas_pago.object.nro_tj3 				[ll_row] = ls_nro_tj3
	idw_formas_pago.object.nro_tj4 				[ll_row] = ls_nro_tj4
	idw_formas_pago.object.CCV 					[ll_row] = ls_ccv
	idw_formas_pago.object.fec_vencimiento 	[ll_row] = ld_fec_vencimiento
	idw_formas_pago.object.consignatario 		[ll_row] = ls_consignatario
	idw_formas_pago.object.monto 					[ll_row] = ldc_monto
	idw_formas_pago.object.monto_pago			[ll_row] = ldc_monto_pago
	idw_formas_pago.object.desc_forma_pago		[ll_row] = ls_desc_forma_pago
	idw_formas_pago.object.nom_proveedor		[ll_row] = ls_nom_proveedor
	idw_formas_pago.object.ruc_dni				[ll_row] = ls_ruc_dni
	idw_formas_pago.object.factor					[ll_row] = 1
	idw_formas_pago.object.tipo_doc				[ll_row] = ls_tipo_doc
	idw_formas_pago.object.nro_doc				[ll_row] = ls_nro_doc
	idw_formas_pago.object.factor					[ll_row] = 1
	idw_formas_pago.object.cod_ctabco			[ll_row] = ls_cod_ctabco
	idw_formas_pago.object.nom_banco				[ll_row] = ls_nom_banco
	idw_formas_pago.object.flag_tipo_Credito	[ll_row] = ls_flag_tipo_credito
	idw_formas_pago.object.nro_cuotas			[ll_row] = ldc_nro_cuotas
	idw_formas_pago.object.porc_interes			[ll_row] = ldc_porc_interes
	idw_formas_pago.object.factor					[ll_row] = li_factor
	idw_formas_pago.object.primer_vencimiento	[ll_row] = ld_primer_vencimiento
	idw_formas_pago.object.cod_banco_Cred		[ll_row] = ls_cod_banco_cred
	idw_formas_pago.object.nom_banco_cred		[ll_row] = ls_nom_banco_cred
	
	lstr_param.b_return = true
else
	lstr_param.b_return = false
end if

CloseWithReturn(this, lstr_param)
end event

public function boolean of_valida_precio_consig ();Long 		ll_row
decimal	ldc_precio_vta_unidad, ldc_precio_vta, ldc_porc_igv
u_dw_abc	ldw_detail

ldw_detail = istr_param.dw_d

for ll_row = 1 to ldw_detail.RowCount()
	
	ldc_precio_vta 			= Dec(ldw_detail.object.precio_vta 			[ll_row])
	ldc_precio_vta_unidad 	= Dec(ldw_detail.object.precio_vta_unidad [ll_row])
	
	//Obtengo la base imponible sin IGV
	if round(ldc_precio_vta,2) < round(ldc_precio_vta_unidad,2) then
		MessageBox('Error', 'En la consignación no esta permitido cambiar el precio de venta a un precio menor al precio unitario, por favor corrija el registro ' + string(ll_row) &
								+ '~r~nPrecio Vta: ' + string(ldc_precio_vta, '###,##0.00') &
								+ '~r~nPrecio Vta Real: ' + string(ldc_precio_vta_unidad, '###,##0.00'), StopSign!)
		return false
								
	end if
	
next

return true
end function

on w_ve318_forma_pago.create
int iCurrent
call super::create
this.dw_forma_pago=create dw_forma_pago
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_forma_pago
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.cb_aceptar
this.Control[iCurrent+4]=this.dw_master
end on

on w_ve318_forma_pago.destroy
call super::destroy
destroy(this.dw_forma_pago)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;

istr_param = Message.PowerObjectparm

idw_formas_pago 	= istr_param.dw_1
idw_master 			= istr_param.dw_m
is_tipo_doc 		= idw_master.object.tipo_doc_cxc [1]

//Coloco como monto de pago el pendiente por pagar
dw_forma_pago.event ue_insert( )
dw_forma_pago.object.monto [1] = istr_param.dec2

dw_master.event ue_insert( )
dw_master.object.monto [1] = istr_param.dec2

dw_forma_pago.setColumn("flag_forma_pago")
dw_forma_pago.setFocus()

end event

type dw_forma_pago from u_dw_abc within w_ve318_forma_pago
integer x = 5
integer width = 1673
integer height = 124
string dataobject = "d_flag_forma_pago_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_forma_pago	[al_row] = 'E'

end event

event itemchanged;call super::itemchanged;String 		ls_data, ls_cliente, ls_mensaje
Long 			ll_row
Date			ld_today, ld_fec_emision
Integer		li_nro_cuotas, li_count

this.Accepttext()

dw_master.Reset()

ld_today = Date(gnvo_app.of_fecha_actual())

if this.object.flag_forma_pago [row] = 'E' then
	
	dw_master.DataObject = 'd_pago_efectivo_ff'
	
elseif this.object.flag_forma_pago [row] = 'T' then	
	
	dw_master.DataObject = 'd_pago_tarjeta_ff'
	
elseif this.object.flag_forma_pago [row] = 'Y' then	
	
	dw_master.DataObject = 'd_pago_yape_ff'

elseif this.object.flag_forma_pago [row] = 'P' then	
	
	dw_master.DataObject = 'd_pago_plin_ff'

elseif this.object.flag_forma_pago [row] = 'C' then	
	
	// Valido que tenga linea de credito
	//Obtengo los datos que necesito
	ld_fec_emision	= Date(idw_master.object.fec_movimiento [1])
	ls_cliente		= idw_master.object.cliente [1]

	// Obtengo el nro de cuotas
	select count(*)
		into :li_count
		from proveedor_linea_credito t
	where t.proveedor = :ls_cliente
	  and t.flag_estado = '1'
	  and t.usr_aprob_rech is not null
	  and trunc(:ld_fec_emision) between trunc(t.fec_ini_vigencia) and trunc(t.fec_fin_vigencia);

	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al ejecutar consulta SELECT en proveedor_linea_credito. Mensaje: ' + ls_mensaje, StopSign!)
		
		this.object.flag_forma_pago [1] = gnvo_app.is_null
		this.setColumn('flag_forma_pago')
		return 1
	end if;
		
	if li_count = 0 then
		MessageBox('Error', 'No existe una Linea de Credito ACTIVA ni APROBADA para el Cliente ' + ls_cliente &
							  + '~r~nvigente en la fecha ' + string(ld_fec_emision, 'dd/mm/yyyy') &
							  + '~r~npor favor verifique!', StopSign!)
							  
		this.object.flag_forma_pago [1] = gnvo_app.is_null
		this.setColumn('flag_forma_pago')
		return 1
	end if
		
	if li_count > 1 then
		MessageBox('Error', 'Existe mas de una Linea de Credito ACTIVA y APROBADA para el Cliente ' + ls_cliente &
							  + '~r~nvigente en la fecha ' + string(ld_fec_emision, 'dd/mm/yyyy') &
							  + '~r~npor favor verifique!', StopSign!)

		this.object.flag_forma_pago [1] = gnvo_app.is_null
		this.setColumn('flag_forma_pago')
		return 1

	end if
	
	dw_master.DataObject = 'd_pago_credito_ff'
	
elseif this.object.flag_forma_pago [row] = 'O' then
	//Pago por consignación
	
	//Valido si el precio sea el mismo que el precio unitario
	if not of_valida_precio_consig() then 
		return 2
	end if
	
	dw_master.DataObject = 'd_pago_consignatario_ff'
	
elseif this.object.flag_forma_pago [row] = 'V' then	
	
	dw_master.DataObject = 'd_pago_vale_descuento_ff'
	
elseif this.object.flag_forma_pago [row] = 'D' or this.object.flag_forma_pago [row] = 'H' then	
	
	dw_master.DataObject = 'd_pago_deposito_bancario_ff'

end if



dw_master.settransobject( SQLCA )
dw_master.Reset()
ll_row = dw_master.event ue_insert( )

dw_master.object.monto 				[ll_row] = Dec(this.object.monto [1])
dw_master.object.monto_pago 		[ll_row] = Dec(this.object.monto [1])
dw_master.object.flag_forma_pago [ll_row] = this.object.flag_forma_pago [1]

//Datos por defecto si es pago con tarjeta
if this.object.flag_forma_pago [row] = 'T' then
	
	dw_master.object.fec_vencimiento 	[ll_row] = ld_today
	
	if gnvo_app.ventas.is_datos_tarjeta_default = '1' then
		
		dw_master.object.nro_tj1 	[ll_row] = "****"
		dw_master.object.nro_tj2 	[ll_row] = "****"
		dw_master.object.nro_tj3 	[ll_row] = "****"
		dw_master.object.nro_tj4 	[ll_row] = "****"
		dw_master.object.ccv 		[ll_row] = "***"
		
	end if
	
	dw_master.SetColumn("tipo_tarjeta")
	
elseif this.object.flag_forma_pago [row] = 'C' then
	
	dw_master.object.nro_cuotas 			[ll_row] = 0
	dw_master.object.porc_interes			[ll_row] = 0.00
	dw_master.object.primer_vencimiento	[ll_row] = RelativeDate(ld_today, 30)
	
	dw_master.SetColumn("monto_pago")	
	
elseif this.object.flag_forma_pago [row] = 'O' then
	
	dw_master.object.nro_cuotas 			[ll_row] = 1
	dw_master.object.porc_interes			[ll_row] = 0.00
	dw_master.object.primer_vencimiento	[ll_row] = RelativeDate(ld_today, 30)
	
	dw_master.SetColumn("consignatario")	

end if

dw_master.SetFocus()

	
end event

type cb_cancelar from commandbutton within w_ve318_forma_pago
integer x = 2418
integer width = 567
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar( )
end event

type cb_aceptar from commandbutton within w_ve318_forma_pago
integer x = 1833
integer width = 567
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_aceptar( )
end event

type dw_master from u_dw_abc within w_ve318_forma_pago
integer y = 136
integer width = 2976
integer height = 860
string dataobject = "d_pago_efectivo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_display;call super::ue_display;boolean 			lb_ret
string 			ls_codigo, ls_data, ls_data2, ls_sql, ls_nro_cuotas, ls_porc_interes


choose case lower(as_columna)
	case "consignatario"
		ls_sql = "SELECT p.proveedor AS CODIGO_proveedor, " &
				  + "p.nom_proveedor AS nombre_proveedor, " &
				  + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, " &
				  + "c.nro_cuotas_max  as nro_cuotas, " &
				  + "c.porc_interes as porc_interes " &
				  + "FROM proveedor p, " &
				  + "consignatarios c " &
				  + "WHERE c.consignatario = p.proveedor " &
				  + "  and p.FLAG_ESTADO = '1'"

		lb_ret = f_lista_5ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_nro_cuotas, ls_porc_interes, '2')

		if ls_codigo <> '' then
			this.object.consignatario	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc_dni			[al_row] = ls_data2
			
			this.object.nro_cuotas		[al_row] = Dec(ls_nro_cuotas)
			this.object.porc_interes	[al_row] = Dec(ls_porc_interes)
			this.ii_update = 1
		end if
		
	case "forma_pago"
		ls_sql = "SELECT fp.forma_pago as forma_pago, " &
				  + "fp.desc_forma_pago as descripcion_forma_pago " &
				  + "FROM forma_pago fp " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.forma_pago			[al_row] = ls_codigo
			this.object.desc_forma_pago	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cod_banco"
		ls_sql = "select b.cod_banco as codigo_banco, " &
				 + "b.nom_banco as nombre_banco, " &
				 + "bc.cod_ctabco as nro_cuenta, " &
				 + "bc.descripcion as desc_ctabco " &
				 + "from banco_cnta bc, " &
				 + "     banco      b " &
				 + "where bc.cod_banco = b.cod_banco " &
				 + "  and bc.flag_estado = '1'" &
				 + "  and bc.flag_facturacion_simpl = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')

		if ls_codigo <> '' then
			this.object.cod_banco	[al_row] = ls_codigo
			this.object.nom_banco	[al_row] = ls_data
			this.object.cod_ctabco	[al_row] = ls_data2
			this.ii_update = 1
		end if

	case "cod_banco_cred"
		ls_sql = "select b.cod_banco as codigo_banco, " &
				 + "b.nom_banco as nombre_banco " &
				 + "from banco      b " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_banco_cred	[al_row] = ls_codigo
			this.object.nom_banco_cred	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_doc"
		ls_sql = "select dt.tipo_doc as tipo_doc, " &
				 + "       dt.desc_tipo_doc as desc_tipo_doc " &
				 + "from doc_tipo dt " &
				 + "where dt.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_insert_pre;call super::ue_insert_pre;if is_tipo_doc = 'NCC' then
	this.object.factor[al_Row] = -1
else
	this.object.factor[al_row] = 1
end if
end event

event keydwn;call super::keydwn;if KeyDown(KeyControl!) and KeyDown(KeyF!) then
	dw_forma_pago.setColumn("flag_forma_pago")
	dw_forma_pago.setFocus()
end if
end event

event itemchanged;call super::itemchanged;date		ld_fec_emision
Integer	li_nro_cuotas, li_count
String	ls_cliente, ls_mensaje

this.Accepttext()

//Obtengo los datos que necesito
ld_fec_emision	= Date(idw_master.object.fec_movimiento [1])
ls_cliente		= idw_master.object.cliente [1]

CHOOSE CASE dwo.name
	CASE 'flag_tipo_credito'
		
		this.object.primer_vencimiento [1] = ld_fec_emision
		
		// Verifica que codigo ingresado exista			
		if data = 'D' then
			
			// Obtengo el nro de cuotas
		  	select count(*)
				into :li_count
			 	from proveedor_linea_credito t
			where t.proveedor = :ls_cliente
			  and t.flag_estado = '1'
			  and t.usr_aprob_rech is not null
			  and trunc(:ld_fec_emision) between trunc(t.fec_ini_vigencia) and trunc(t.fec_fin_vigencia);
		
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al ejecutar consulta SELECT en proveedor_linea_credito. Mensaje: ' + ls_mensaje, StopSign!)
				
				this.object.flag_tipo_credito [1] = gnvo_app.is_null
				this.setColumn('flag_tipo_credito')
				return 1
			end if;
				
			if li_count = 0 then
				MessageBox('Error', 'No existe una Linea de Credito ACTIVA ni APROBADA para el Cliente ' + ls_cliente &
									  + '~r~nvigente en la fecha ' + string(ld_fec_emision, 'dd/mm/yyyy') &
									  + '~r~npor favor verifique!', StopSign!)
									  
				this.object.flag_tipo_credito [1] = gnvo_app.is_null
				this.setColumn('flag_tipo_credito')
				return 1
			end if
				
			if li_count > 1 then
				MessageBox('Error', 'Existe mas de una Linea de Credito ACTIVA y APROBADA para el Cliente ' + ls_cliente &
									  + '~r~nvigente en la fecha ' + string(ld_fec_emision, 'dd/mm/yyyy') &
									  + '~r~npor favor verifique!', StopSign!)

				this.object.flag_tipo_credito [1] = gnvo_app.is_null
				this.setColumn('flag_tipo_credito')
				return 1

			end if
	  
			select t.nro_cuotas
				into :li_nro_cuotas
				from proveedor_linea_credito t
			where t.proveedor = :ls_cliente
			  and t.flag_estado = '1'
			  and t.usr_aprob_rech is not null
			  and trunc(:ld_fec_emision) between trunc(t.fec_ini_vigencia) and trunc(t.fec_fin_vigencia);

			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Error al tratar de obtener el nro de cuotas en consulta SELECT en proveedor_linea_credito. Mensaje: ' + ls_mensaje, StopSign!)
			end if;
			
			
			this.object.nro_cuotas [1] = li_nro_cuotas
			this.object.nro_cuotas.protect = 1
			return 1
			
		else
			this.object.nro_cuotas	[1] = 0
			this.object.nro_cuotas.protect = 0
			return 1
		end if
			

END CHOOSE
end event

