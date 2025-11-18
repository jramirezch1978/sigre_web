$PBExportHeader$w_sr300_proforma.srw
forward
global type w_sr300_proforma from w_abc_mastdet_smpl
end type
end forward

global type w_sr300_proforma from w_abc_mastdet_smpl
integer height = 2368
string title = "[SR300] Proformas"
string menuname = "m_mtto_lista"
event ue_preview ( )
end type
global w_sr300_proforma w_sr300_proforma

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve_doc (string as_param1)
end prototypes

event ue_preview();// vista previa de guia
str_parametros lstr_rep
string ls_nro_proforma

if dw_master.rowcount() = 0 then return

ls_nro_proforma = dw_master.object.nro_proforma[dw_master.GetRow()]

lstr_rep.dw1 = 'd_rpt_proforma_tbl'

lstr_rep.titulo = 'Proforma'
lstr_rep.string1 = ls_nro_proforma
lstr_rep.tipo 	  = '1S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_proforma
	where cod_origen = :gnvo_app.is_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE num_proforma IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_proforma(cod_origen, ult_nro)
		values( :gnvo_app.is_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_proforma
	where cod_origen = :gnvo_app.is_origen for update;
	
	update num_proforma
		set ult_nro = ult_nro + 1
	where cod_origen = :gnvo_app.is_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gnvo_app.is_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_proforma[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_proforma[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_proforma[ll_j] = ls_next_nro
next

return 1
end function

public subroutine of_retrieve_doc (string as_param1);String ls_periodo,ls_expresion,ls_doc_gr,ls_cod_art,ls_flag_mercado
Long 	 ll_inicio


dw_master.retrieve(as_param1)
dw_master.ii_update = 0

dw_detail.retrieve(as_param1)
dw_detail.ii_update = 0


dw_master.il_row = 1


is_action = 'fileopen'
end subroutine

on w_sr300_proforma.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mtto_lista" then this.MenuID = create m_mtto_lista
end on

on w_sr300_proforma.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_update_pos;call super::ue_update_pos;is_Action = 'open'
end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_proformas_tbl'
sl_param.titulo = 'Proformas'
sl_param.field_ret_i[1] = 1  //NRO_PROFORMA
sl_param.tipo = '1S'
sl_param.string1 = gnvo_app.invo_empresa.is_empresa


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
   of_retrieve_doc(sl_param.field_ret[1])
	TriggerEvent('ue_modify')
END IF

end event

type p_pie from w_abc_mastdet_smpl`p_pie within w_sr300_proforma
end type

type ole_skin from w_abc_mastdet_smpl`ole_skin within w_sr300_proforma
integer x = 2903
integer y = 80
end type

type uo_h from w_abc_mastdet_smpl`uo_h within w_sr300_proforma
end type

type st_box from w_abc_mastdet_smpl`st_box within w_sr300_proforma
end type

type phl_logonps from w_abc_mastdet_smpl`phl_logonps within w_sr300_proforma
end type

type p_mundi from w_abc_mastdet_smpl`p_mundi within w_sr300_proforma
end type

type p_logo from w_abc_mastdet_smpl`p_logo within w_sr300_proforma
end type

type st_horizontal from w_abc_mastdet_smpl`st_horizontal within w_sr300_proforma
integer x = 494
integer y = 1200
end type

type st_filter from w_abc_mastdet_smpl`st_filter within w_sr300_proforma
integer x = 599
integer y = 68
end type

type uo_filter from w_abc_mastdet_smpl`uo_filter within w_sr300_proforma
integer x = 923
integer y = 44
end type

type dw_master from w_abc_mastdet_smpl`dw_master within w_sr300_proforma
integer x = 494
integer y = 236
integer height = 964
string dataobject = "d_abc_proforma_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen 	[al_row] = gnvo_app.is_origen
this.object.empresa		[al_row] = gnvo_app.invo_empresa.is_empresa
this.object.flag_estado	[al_row] = '1'

this.object.vendedor			[al_row] = gnvo_app.is_user
this.object.nom_vendedor	[al_row] = gnvo_app.invo_usuario.is_nom_usuario

this.object.fec_registro	[al_row] = f_fecha_actual(0)
this.object.fec_expiracion	[al_row] = RelativeDate (date(f_fecha_actual(0)),7)

This.Object.tasa_cambio 	[al_row] = f_tasa_cambio_x_arg(date(f_fecha_actual(0)))

is_action = 'new'

dw_detail.Reset()
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc

choose case lower(as_columna)
		
	case "cliente"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "ruc AS ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_Estado = '1' " &
				  + "  and flag_clie_prov in ('0', '2') "
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
		
		if ls_codigo <> '' then
			this.object.cliente		[al_row] = ls_codigo
			this.object.nom_cliente	[al_row] = ls_data
			this.object.ruc			[al_row] = ls_ruc
			this.ii_update = 1
		end if
		
	case "vendedor"
		ls_sql = "SELECT cod_usr AS codigo_usuario, " &
				  + "nombre AS nombre_vendedor " &
				  + "FROM usuario " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.vendedor			[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_moneda"
		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				  + "descripcion AS descripcion_moneda " &
				  + "FROM moneda " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda			[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "forma_pago"
		ls_sql = "SELECT forma_pago AS forma_pago, " &
				  + "desc_forma_pago AS descripcion_forma_pago " &
				  + "FROM forma_pago " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.forma_pago			[al_row] = ls_codigo
			this.object.desc_forma_pago	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_sr300_proforma
integer x = 494
integer y = 1236
integer width = 2583
integer height = 796
string dataobject = "d_abc_proforma_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc, ls_nro_serie
decimal	ldc_precio_vta
str_parametros lstr_param

choose case lower(as_columna)
		
	case "cod_art"
		
		OpenWithParm (w_pop_articulos_stock, parent)
		lstr_param = MESSAGE.POWEROBJECTPARM
		
		IF lstr_param.titulo <> 'n' then
			this.object.cod_art			[al_row] = lstr_param.field_ret[1]
			this.object.descripcion		[al_row] = lstr_param.field_ret[2]
			this.object.und				[al_row] = lstr_param.field_ret[3]
			this.object.almacen			[al_row] = lstr_param.field_ret[5]
			
			ls_nro_serie = lstr_param.field_ret[4]
			
			if not IsNull(ls_nro_serie) and ls_nro_serie <> '' then
				this.object.cantidad				[al_row] = 1
			end if
			
			//Obtengo el precio de venta del articulo
			ls_codigo = lstr_param.field_ret[1]
			
			select precio_venta
				into :ldc_precio_vta
			from articulo
			where cod_art = :ls_codigo;
			
			this.object.precio_vta				[al_row] = ldc_precio_vta
			
			this.ii_update = 1

		END IF
		
		
end choose
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.nro_item	[al_row] = f_numera_item(this)
this.object.igv		[al_row] = 0
end event

