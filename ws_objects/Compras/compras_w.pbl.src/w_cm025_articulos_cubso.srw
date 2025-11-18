$PBExportHeader$w_cm025_articulos_cubso.srw
forward
global type w_cm025_articulos_cubso from w_abc_master_smpl
end type
type uo_search from n_cst_search within w_cm025_articulos_cubso
end type
end forward

global type w_cm025_articulos_cubso from w_abc_master_smpl
integer width = 4869
integer height = 1552
string title = "[CM025] Articulos vs CUBSO del Estado"
string menuname = "m_save_exit"
event ue_saveas_excel ( )
event ue_saveas ( )
uo_search uo_search
end type
global w_cm025_articulos_cubso w_cm025_articulos_cubso

type variables
String  is_col = 'cod_art'
Integer ii_ik[]
str_parametros ist_datos
end variables

forward prototypes
public function boolean of_calcula (long al_row)
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
Decimal 	ldc_costo_ult_compra, ldc_dscto_compra1, ldc_dscto_compra2, ldc_tasa_cambio, ldc_porc_vta_unidad, &
			ldc_porc_vta_mayor, ldc_precio_vta_unidad, ldc_precio_vta_mayor

ls_moneda_compra 		= dw_master.object.moneda_compra 			[al_row]
ldc_costo_ult_compra = Dec(dw_master.object.costo_ult_compra 	[al_row])
ldc_dscto_compra1 	= Dec(dw_master.object.dscto_compra1 		[al_row])
ldc_dscto_compra2 	= Dec(dw_master.object.dscto_compra2 		[al_row])
ldc_tasa_cambio 		= Dec(dw_master.object.tasa_cambio 			[al_row])
ldc_porc_vta_unidad	= Dec(dw_master.object.porc_vta_unidad 	[al_row])
ldc_porc_vta_mayor 	= Dec(dw_master.object.porc_vta_mayor 		[al_row])

//Validaciones
if IsNull(ls_moneda_compra) or trim(ls_moneda_compra) = "" then
	MessageBox("Error", "Debe especificar una moneda de compra", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	return false
end if

if IsNull(ldc_costo_ult_compra) or ldc_costo_ult_compra = 0 then
	MessageBox("Error", "Debe especificar un costo de ultima compra", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	return false
end if

if IsNull(ldc_dscto_compra1) then ldc_dscto_compra1 = 0;
if IsNull(ldc_dscto_compra2) then ldc_dscto_compra2 = 0;

if ls_moneda_compra = gnvo_app.is_dolares and (IsNull(ldc_tasa_cambio) or ldc_tasa_cambio = 0) then
	MessageBox("Error", "Debe especificar una tasa de cambio para una moneda diferente a la moneda nacional", StopSign!)
	dw_master.object.precio_vta_unidad	[al_row] = 0.00
	dw_master.object.precio_vta_mayor	[al_row] = 0.00
	return false
end if

if IsNull(ldc_porc_vta_unidad) then ldc_porc_vta_unidad = 0;
if IsNull(ldc_porc_vta_mayor) then ldc_porc_vta_mayor = 0;

//Paso a soles el precio de ultima compra
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
ldc_precio_vta_unidad = round(ldc_costo_ult_compra * (1 + ldc_porc_vta_unidad / 100),1) + 0.1
ldc_precio_vta_mayor = round(ldc_costo_ult_compra * (1 + ldc_porc_vta_mayor / 100),1) + 0.1



dw_master.object.precio_vta_unidad		[al_row] = ldc_precio_vta_unidad
dw_master.object.precio_vta_mayor		[al_row] = ldc_precio_vta_mayor

dw_master.ii_update = 1

return true

end function

on w_cm025_articulos_cubso.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_search
end on

on w_cm025_articulos_cubso.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
ib_log = TRUE

dw_master.of_protect( )

uo_search.of_set_dw(dw_master)

ii_lec_mst = 0 

dw_master.Retrieve('%%')

idw_1 = dw_master


end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

uo_search.event ue_resize(sizetype, uo_search.width, uo_search.height)
end event

type dw_master from w_abc_master_smpl`dw_master within w_cm025_articulos_cubso
event ue_saveas ( )
integer y = 100
integer width = 2935
integer height = 1136
string dataobject = "d_abc_articulos_cubso_tbl"
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
		
	case "cod_cubso"
		ls_sql = "select cod_cubso as codigo_cubso, " &
				 + "desc_bien_serv_obra as descripcion_bien_Servicio_obra " &
				 + "from sunat_cubso " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_cubso				[al_row] = ls_codigo
			this.object.desc_bien_serv_obra	[al_row] = ls_data
			this.ii_update = 1
		end if
		return

end choose



end event

event dw_master::itemchanged;call super::itemchanged;String	ls_desc

dw_master.Accepttext()


CHOOSE CASE lower(dwo.name)
	CASE "cod_cubso"
		
		select desc_bien_serv_obra
			into :ls_desc
		from sunat_cubso
		where cod_cubso = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe CÓDIGO UNICO DE BIEN, SERVICIO U OBRA DEL ESTADO, o no se encuentra activo, por favor verifique', Exclamation!)
			this.object.cod_cubso 				[row] = gnvo_app.is_null
			this.object.desc_bien_serv_obra 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_bien_serv_obra 		[row] = ls_desc
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type uo_search from n_cst_search within w_cm025_articulos_cubso
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_filtro

ls_filtro = this.of_get_filtro( )

dw_master.Retrieve( ls_filtro )


end event

