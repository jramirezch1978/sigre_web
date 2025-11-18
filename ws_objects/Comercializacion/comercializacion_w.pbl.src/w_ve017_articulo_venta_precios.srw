$PBExportHeader$w_ve017_articulo_venta_precios.srw
forward
global type w_ve017_articulo_venta_precios from w_abc_master_smpl
end type
type uo_search from n_cst_search within w_ve017_articulo_venta_precios
end type
type cb_1 from commandbutton within w_ve017_articulo_venta_precios
end type
type cb_procesar from commandbutton within w_ve017_articulo_venta_precios
end type
end forward

global type w_ve017_articulo_venta_precios from w_abc_master_smpl
integer width = 4869
integer height = 1552
string title = "[VE017] Precios de Venta de Articulos"
string menuname = "m_only_save"
event ue_saveas_excel ( )
event ue_saveas ( )
uo_search uo_search
cb_1 cb_1
cb_procesar cb_procesar
end type
global w_ve017_articulo_venta_precios w_ve017_articulo_venta_precios

type variables
String  is_col = 'cod_art'
Integer ii_ik[]
str_parametros ist_datos
end variables

forward prototypes
public function boolean of_calcula (long al_row)
public function boolean of_calculo_sin_mensaje (long al_row)
end prototypes

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

event ue_saveas();dw_master.EVENT dynamic ue_saveas()
end event

public function boolean of_calcula (long al_row);String 	ls_moneda_compra
Decimal 	ldc_costo_ult_compra, ldc_dscto_compra1, ldc_dscto_compra2, ldc_tasa_cambio, &
			ldc_porc_vta_unidad, ldc_porc_vta_mayor, ldc_precio_vta_unidad, &
			ldc_precio_vta_mayor, ldc_porc_vta_oferta, ldc_precio_vta_oferta, &
			ldc_precio_vta_min, ldc_porc_vta_min

ls_moneda_compra 		= dw_master.object.moneda_compra 			[al_row]
ldc_costo_ult_compra = Dec(dw_master.object.costo_ult_compra 	[al_row])
ldc_dscto_compra1 	= Dec(dw_master.object.dscto_compra1 		[al_row])
ldc_dscto_compra2 	= Dec(dw_master.object.dscto_compra2 		[al_row])
ldc_tasa_cambio 		= Dec(dw_master.object.tasa_cambio 			[al_row])
ldc_porc_vta_unidad	= Dec(dw_master.object.porc_vta_unidad 	[al_row])
ldc_porc_vta_mayor 	= Dec(dw_master.object.porc_vta_mayor 		[al_row])
ldc_porc_vta_oferta 	= Dec(dw_master.object.porc_vta_oferta		[al_row])
ldc_porc_vta_min 		= Dec(dw_master.object.porc_vta_min			[al_row])

//Validaciones
if IsNull(ls_moneda_compra) or trim(ls_moneda_compra) = "" then
	MessageBox("Error", "Debe especificar una moneda de compra", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	dw_master.object.precio_vta_oferta	[al_row] = 0.00
	dw_master.object.precio_vta_min		[al_row] = 0.00
	return false
end if

if IsNull(ldc_costo_ult_compra) or ldc_costo_ult_compra = 0 then
	MessageBox("Error", "Debe especificar un costo de ultima compra", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	dw_master.object.precio_vta_oferta	[al_row] = 0.00
	dw_master.object.precio_vta_min		[al_row] = 0.00
	return false
end if

if IsNull(ldc_dscto_compra1) then ldc_dscto_compra1 = 0;
if IsNull(ldc_dscto_compra2) then ldc_dscto_compra2 = 0;

if ls_moneda_compra = gnvo_app.is_dolares and (IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0) then
	MessageBox("Error", "Debe especificar una tasa de cambio para una moneda diferente a la moneda nacional", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	dw_master.object.precio_vta_oferta	[al_row] = 0.00
	dw_master.object.precio_vta_min		[al_row] = 0.00
	return false
end if

if IsNull(ldc_porc_vta_unidad) then ldc_porc_vta_unidad 	= 0;
if IsNull(ldc_porc_vta_mayor) then 	ldc_porc_vta_mayor 	= 0;
if IsNull(ldc_porc_vta_oferta) then ldc_porc_vta_oferta 	= 0;
if IsNull(ldc_porc_vta_min) then ldc_porc_vta_min 	= 0;

//Paso a soles el precio de ultima compra
if ldc_costo_ult_compra > 0 then
	
	if ls_moneda_compra <> gnvo_app.is_soles then
		ldc_costo_ult_compra = ldc_costo_ult_compra * ldc_tasa_cambio
	end if
	
	//Calculo el descuento 1
	if ldc_dscto_compra1 > 0 then
		ldc_costo_ult_compra = ldc_costo_ult_compra * (1 - ldc_dscto_compra1/100)
	end if
	
	//Calculo el descuento 2
	if ldc_dscto_compra2 > 0 then
		ldc_costo_ult_compra = ldc_costo_ult_compra * (1 - ldc_dscto_compra2/100)
	end if
	
	//Calculo los precios
	ldc_precio_vta_unidad 	= truncate(ldc_costo_ult_compra * (1 + ldc_porc_vta_unidad / 100), 0) + 1
	ldc_precio_vta_mayor 	= round(ldc_costo_ult_compra * (1 + ldc_porc_vta_mayor  / 100), 2) //+ 0.1
	ldc_precio_vta_min 		= round(ldc_costo_ult_compra * (1 + ldc_porc_vta_min  / 100), 2) //+ 0.1
	
	if ldc_porc_vta_oferta > 0.00 then
		ldc_precio_vta_oferta 	= round(ldc_costo_ult_compra * (1 + ldc_porc_vta_oferta / 100), 2) //+ 0.1
	else
		ldc_precio_vta_oferta 	= 0.00
	end if
	
	
	dw_master.object.precio_vta_unidad		[al_row] = ldc_precio_vta_unidad
	dw_master.object.precio_vta_mayor		[al_row] = ldc_precio_vta_mayor
	dw_master.object.precio_vta_oferta		[al_row] = ldc_precio_vta_oferta
	dw_master.object.precio_vta_min			[al_row] = ldc_precio_vta_min
	
	dw_master.ii_update = 1
end if

return true

end function

public function boolean of_calculo_sin_mensaje (long al_row);String 	ls_moneda_compra
Decimal 	ldc_costo_ult_compra, ldc_dscto_compra1, ldc_dscto_compra2, ldc_tasa_cambio, &
			ldc_porc_vta_unidad, ldc_porc_vta_mayor, ldc_precio_vta_unidad, &
			ldc_precio_vta_mayor, ldc_porc_vta_oferta, ldc_precio_vta_oferta, &
			ldc_precio_vta_min, ldc_porc_vta_min

ls_moneda_compra 		= dw_master.object.moneda_compra 			[al_row]
ldc_costo_ult_compra = Dec(dw_master.object.costo_ult_compra 	[al_row])
ldc_dscto_compra1 	= Dec(dw_master.object.dscto_compra1 		[al_row])
ldc_dscto_compra2 	= Dec(dw_master.object.dscto_compra2 		[al_row])
ldc_tasa_cambio 		= Dec(dw_master.object.tasa_cambio 			[al_row])
ldc_porc_vta_unidad	= Dec(dw_master.object.porc_vta_unidad 	[al_row])
ldc_porc_vta_mayor 	= Dec(dw_master.object.porc_vta_mayor 		[al_row])
ldc_porc_vta_oferta 	= Dec(dw_master.object.porc_vta_oferta		[al_row])
ldc_porc_vta_min 		= Dec(dw_master.object.porc_vta_min			[al_row])

//Validaciones
if IsNull(ls_moneda_compra) or trim(ls_moneda_compra) = "" then
	//MessageBox("Error", "Debe especificar una moneda de compra", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	dw_master.object.precio_vta_oferta	[al_row] = 0.00
	dw_master.object.precio_vta_min		[al_row] = 0.00
	return false
end if

if IsNull(ldc_costo_ult_compra) or ldc_costo_ult_compra = 0 then
	//MessageBox("Error", "Debe especificar un costo de ultima compra", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	dw_master.object.precio_vta_oferta	[al_row] = 0.00
	dw_master.object.precio_vta_min		[al_row] = 0.00
	return false
end if

if IsNull(ldc_dscto_compra1) then ldc_dscto_compra1 = 0;
if IsNull(ldc_dscto_compra2) then ldc_dscto_compra2 = 0;

if ls_moneda_compra = gnvo_app.is_dolares and (IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0) then
	//MessageBox("Error", "Debe especificar una tasa de cambio para una moneda diferente a la moneda nacional", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	dw_master.object.precio_vta_oferta	[al_row] = 0.00
	dw_master.object.precio_vta_min		[al_row] = 0.00
	return false
end if

if IsNull(ldc_porc_vta_unidad) then ldc_porc_vta_unidad 	= 0;
if IsNull(ldc_porc_vta_mayor) then 	ldc_porc_vta_mayor 	= 0;
if IsNull(ldc_porc_vta_oferta) then ldc_porc_vta_oferta 	= 0;
if IsNull(ldc_porc_vta_min) then ldc_porc_vta_min 	= 0;

//Paso a soles el precio de ultima compra
if ldc_costo_ult_compra > 0 then
	
	if ls_moneda_compra <> gnvo_app.is_soles then
		ldc_costo_ult_compra = ldc_costo_ult_compra * ldc_tasa_cambio
	end if
	
	//Calculo el descuento 1
	if ldc_dscto_compra1 > 0 then
		ldc_costo_ult_compra = ldc_costo_ult_compra * (1 - ldc_dscto_compra1/100)
	end if
	
	//Calculo el descuento 2
	if ldc_dscto_compra2 > 0 then
		ldc_costo_ult_compra = ldc_costo_ult_compra * (1 - ldc_dscto_compra2/100)
	end if
	
	//Calculo los precios
	ldc_precio_vta_unidad 	= truncate(ldc_costo_ult_compra * (1 + ldc_porc_vta_unidad / 100), 0) + 1
	ldc_precio_vta_mayor 	= round(ldc_costo_ult_compra * (1 + ldc_porc_vta_mayor  / 100), 2) //+ 0.1
	ldc_precio_vta_min 		= round(ldc_costo_ult_compra * (1 + ldc_porc_vta_min  / 100), 2) //+ 0.1
	
	if ldc_porc_vta_oferta > 0.00 then
		ldc_precio_vta_oferta 	= round(ldc_costo_ult_compra * (1 + ldc_porc_vta_oferta / 100), 2) //+ 0.1
	else
		ldc_precio_vta_oferta 	= 0.00
	end if
	
	
	dw_master.object.precio_vta_unidad		[al_row] = ldc_precio_vta_unidad
	dw_master.object.precio_vta_mayor		[al_row] = ldc_precio_vta_mayor
	dw_master.object.precio_vta_oferta		[al_row] = ldc_precio_vta_oferta
	dw_master.object.precio_vta_min			[al_row] = ldc_precio_vta_min
	
	dw_master.ii_update = 1
end if

return true

end function

on w_ve017_articulo_venta_precios.create
int iCurrent
call super::create
if this.MenuName = "m_only_save" then this.MenuID = create m_only_save
this.uo_search=create uo_search
this.cb_1=create cb_1
this.cb_procesar=create cb_procesar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_procesar
end on

on w_ve017_articulo_venta_precios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
destroy(this.cb_1)
destroy(this.cb_procesar)
end on

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
ib_log = TRUE

ii_lec_mst = 0 

try 
	if trim(gs_empresa) = "CROMOPLASTIC" or trim(gs_empresa) = "FRANCIS" or gnvo_app.of_get_parametro( "PRECIO_VENTA_ART_F2", "1") = "1" then
		if gnvo_app.of_get_parametro("VTAS_FILTRAR_PRECIOS_VENTA_USUARIO", "0") = "1" then
			dw_master.dataObject = 'd_abc_precios_venta_usuario_tbl'
		else
			dw_master.dataObject = 'd_abc_precios_venta_cromoplastic_tbl'
		end if
	else
		dw_master.dataObject = 'd_abc_articulo_venta_precios_tbl'
	end if
	
	dw_master.setTransobject( SQLCA )
	
	dw_master.of_protect( )
	
	uo_search.of_set_dw(dw_master)
	
	//dw_master.Retrieve('silla rey%')
	uo_search.event ue_buscar( )
	
	idw_1 = dw_master
	
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
end try


end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

uo_search.event ue_resize(sizetype, uo_search.width, uo_search.height)
end event

type dw_master from w_abc_master_smpl`dw_master within w_ve017_articulo_venta_precios
event ue_saveas ( )
integer y = 100
integer width = 2935
integer height = 1136
string dataobject = "d_abc_precios_venta_cromoplastic_tbl"
end type

event dw_master::ue_saveas();THIS.saveas()
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;if this.of_existecampo( "costo_ult_compra" ) then this.object.costo_ult_compra 	[al_row] = 0.00
if this.of_existecampo( "moneda_compra" ) then this.object.moneda_compra 			[al_row] = gnvo_app.is_soles
if this.of_existecampo( "dscto_compra" ) then this.object.dscto_compra 				[al_row] = 0.00
if this.of_existecampo( "tasa_cambio" ) then this.object.tasa_cambio 				[al_row] = 0.00
if this.of_existecampo( "porc_vta_unidad" ) then this.object.porc_vta_unidad 		[al_row] = 0.00
if this.of_existecampo( "precio_vta_unidad" ) then this.object.precio_vta_unidad [al_row] = 0.00
if this.of_existecampo( "porc_vta_mayor" ) then this.object.porc_vta_mayor 		[al_row] = 0.00
if this.of_existecampo( "precio_vta_mayor" ) then this.object.precio_vta_mayor 	[al_row] = 0.00
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "moneda_compra"

		ls_sql = "select m.cod_moneda as codigo_moneda, " &
				 + "m.descripcion as descripcion_moneda " &
				 + "from moneda m " &
				 + "where m.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.moneda_compra	[al_row] = ls_codigo
			of_calcula(al_row)
			this.ii_update = 1
		end if

		
	case "bien_serv"

		ls_sql = "select bien_serv as bien_serv, " &
				 + "descripcion as desc_bien_serv " &
				 + "from DETR_BIEN_SERV d " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.bien_serv		[al_row] = ls_codigo
			this.object.desc_bien_serv	[al_row] = ls_Data
			this.ii_update = 1
		end if
end choose



end event

event dw_master::itemchanged;call super::itemchanged;String	ls_data


dw_master.Accepttext()


CHOOSE CASE lower(dwo.name)
	CASE 	"moneda_compra", "costo_ult_compra", "dscto_compra1", "dscto_compra2", &
			"tasa_cambio", "porc_vta_unidad", "porc_vta_mayor", "porc_vta_oferta"
			
		of_calcula(row)
	
	CASE 	"bien_serv"
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from DETR_BIEN_SERV
		 Where bien_serv = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe el codigo de Bien / Servicio " + data + ", por favor verifique")
			this.object.bien_serv		[row] = gnvo_app.is_null
			this.object.desc_bien_serv	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_bien_serv	[row] = ls_data
END CHOOSE
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type uo_search from n_cst_search within w_ve017_articulo_venta_precios
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_filtro

ls_filtro = this.of_get_filtro( )

//MessageBox('', ls_filtro)

this.idw_master.Retrieve(ls_filtro)

if this.idw_master.RowCount( ) > 0 then
	MessageBox('Aviso', 'Total registros mostrados: ' + string(this.idw_master.RowCount( )) + '.', Information!)
end if
end event

type cb_1 from commandbutton within w_ve017_articulo_venta_precios
integer x = 2953
integer width = 471
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Datos comunes"
end type

event clicked;Str_parametros lstr_param
long				ll_row
boolean			lb_flag = false

open(w_datos_Comunes)

lstr_param = Message.Powerobjectparm

if not lstr_param.b_return then return

if trim(lstr_param.string1) <> '' then
	if MessageBox('Aviso', 'Desea aplicar el tipo de moneda a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.moneda_compra [ll_row] = lstr_param.string1
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if


if lstr_param.tipo_cambio > 0 then
	if MessageBox('Aviso', 'Desea aplicar la tasa de cambios a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.tasa_cambio [ll_row] = lstr_param.tipo_cambio
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.porc_mayorista > 0 then
	if MessageBox('Aviso', 'Desea aplicar el porcentaje mayorista a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.porc_vta_mayor [ll_row] = lstr_param.porc_mayorista
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.porc_minorista > 0 then
	if MessageBox('Aviso', 'Desea aplicar el porcentaje minorista a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.porc_vta_unidad [ll_row] = lstr_param.porc_minorista
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.precio_unidad > 0 then
	if MessageBox('Aviso', 'Desea aplicar el PRECIO MINORISTA a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.precio_vta_unidad [ll_row] = lstr_param.precio_unidad
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.porc_prec_min > 0 then
	if MessageBox('Aviso', 'Desea aplicar el porcentaje de Precio Minimo a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.porc_vta_min [ll_row] = lstr_param.porc_prec_min
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.porc_oferta > 0 then
	if MessageBox('Aviso', 'Desea aplicar el porcentaje de OFERTA a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.porc_vta_oferta [ll_row] = lstr_param.porc_oferta
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.dec1 > 0 then
	if MessageBox('Aviso', 'Desea aplicar el Primer Descuento a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.dscto_compra1 [ll_row] = lstr_param.dec1
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if

if lstr_param.dec2 > 0 then
	if MessageBox('Aviso', 'Desea aplicar el Segundo Descuento a todos los registros?', Information!, Yesno!, 2) = 1 then
		for ll_row = 1 to dw_master.RowCount()
			dw_master.object.dscto_compra2 [ll_row] = lstr_param.dec2
			of_calculo_sin_mensaje(ll_row)
			dw_master.ii_update = 1
			lb_flag = true
		next
	end if
end if


if lb_flag and dw_master.RowCount() > 0 then
	MessageBox('Aviso', 'Se han actualizado ' + trim(string(dw_master.RowCount(), "###,##0")) + ' registros satisfactoriamente.', Information!)
end if
end event

type cb_procesar from commandbutton within w_ve017_articulo_venta_precios
integer x = 3433
integer width = 471
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;long ll_row

for ll_row = 1 to dw_master.RowCount()
	of_calculo_sin_mensaje(ll_row)
	dw_master.ii_update = 1
next

end event

