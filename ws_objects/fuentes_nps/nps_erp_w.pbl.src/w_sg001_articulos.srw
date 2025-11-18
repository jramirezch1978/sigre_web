$PBExportHeader$w_sg001_articulos.srw
forward
global type w_sg001_articulos from w_abc_master_smpl
end type
end forward

global type w_sg001_articulos from w_abc_master_smpl
integer width = 3323
integer height = 2308
string title = "[SG001] Maestro de Artículos"
string menuname = "m_mtto_smpl"
end type
global w_sg001_articulos w_sg001_articulos

type variables
string is_soles
end variables

on w_sg001_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sg001_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pos;call super::ue_update_pos;this.event ue_query_retrieve( )
end event

event ue_query_retrieve;//Ancestor Overriding
dw_master.retrieve(gnvo_app.invo_empresa.is_empresa)
dw_master.setcolumn("codigo_serie")
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0 
this.event ue_query_retrieve( )

select cod_soles
	into :is_soles
from logparam
where reckey = '1';

if gnvo_app.of_valida_transaccion( "No se ha encontrado parametros en LOGPARAM", SQLCA) then
	return	
end if
end event

type p_pie from w_abc_master_smpl`p_pie within w_sg001_articulos
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_sg001_articulos
end type

type uo_h from w_abc_master_smpl`uo_h within w_sg001_articulos
end type

type st_box from w_abc_master_smpl`st_box within w_sg001_articulos
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_sg001_articulos
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_sg001_articulos
end type

type p_logo from w_abc_master_smpl`p_logo within w_sg001_articulos
end type

type st_filter from w_abc_master_smpl`st_filter within w_sg001_articulos
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sg001_articulos
end type

type dw_master from w_abc_master_smpl`dw_master within w_sg001_articulos
integer width = 2469
integer height = 1436
string dataobject = "d_abc_articulos_grd"
end type

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cat_art, ls_null

setNull(ls_null)

choose case lower(as_columna)
		
	case "cat_art"
		ls_sql = "SELECT cat_art AS codigo_categoria, " &
				  + "desc_categoria AS descripcion_categoria " &
				  + "FROM articulo_categ " &
				  + "where flag_Estado = '1' " &
				  + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cat_art			[al_row] = ls_codigo
			this.object.desc_categoria	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "sub_cat_art"
		ls_cat_art = this.object.cat_art			[al_row] 
		
		if IsNull(ls_cat_art) or ls_cat_art = '' then
			gnvo_app.of_showmessagedialog( "No ha especificado la categoría del artículo")
			this.object.sub_cat_art 	[al_row] = ls_null
			this.object.desc_sub_cat 	[al_row] = ls_null
			this.setColumn("cat_art")
			return 
		end if
		
		ls_sql = "SELECT COD_SUB_CAT AS codigo_sub_categoria, " &
				  + "DESC_SUB_CAT AS descripcion_sub_categoria " &
				  + "FROM articulo_sub_categ " &
				  + "where cat_art = '" + ls_cat_art + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "1")
		
		if ls_codigo <> "" then
			this.object.sub_cat_art		[al_row] = ls_codigo
			this.object.desc_sub_cat	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_marca"
		ls_sql = "SELECT cod_marca AS codigo_marca, " &
				  + "nom_marca AS descripcion_marca " &
				  + "FROM marca " &
				  + "where flag_Estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_marca	[al_row] = ls_codigo
			this.object.nom_marca	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "und"
		ls_sql = "SELECT UND AS unidad, " &
				  + "DESC_UNIDAD AS descripcion_unidad " &
				  + "FROM unidad " &
				  + "where flag_Estado = '1' " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "moneda_vta"
		ls_sql = "SELECT COD_MONEDA AS codigo_moneda, " &
				  + "DESCRIPCION AS descripcion_moneda " &
				  + "FROM moneda " &
				  + "where flag_Estado = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.moneda_vta	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		

end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 			[al_row] = '1'
this.object.flag_reposicion		[al_row] = '0'
this.object.flag_critico 			[al_row] = '0'
this.object.moneda_vta				[al_row] = is_soles
this.object.flag_inventariable	[al_row] = '1'
this.object.precio_venta			[al_row] = 0.00
this.object.garantia_cliente		[al_row] = 0.00
this.object.cod_empresa				[al_row] = gnvo_app.invo_empresa.is_empresa

this.setColumn("codigo_serie")


end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc, ls_mensaje, ls_cat_art

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE lower(dwo.name)
	CASE 'cat_art'
		// Verifica que codigo ingresado exista			
		Select desc_categoria
	     into :ls_desc
		  from articulo_Categ
		 Where cat_art = :data
		   and flag_estado = '1'
			and cod_empresa = :gnvo_app.invo_empresa.is_empresa;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Categoría ingresado " + data &
						+ " no existe, no esta activo o no le corresponde a su empresa, "&
						+ "por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.cat_art			[row] = ls_null
			this.object.desc_categoria	[row] = ls_null
			return 1
		end if

		this.object.desc_categoria		[row] = ls_desc
		
	case "sub_cat_art"
		ls_cat_art = this.object.cat_art			[row] 
		
		if IsNull(ls_cat_art) or ls_cat_art = '' then
			gnvo_app.of_showmessagedialog( "No ha especificado la categoría del artículo")
			this.object.sub_cat_art 	[row] = ls_null
			this.object.desc_sub_cat 	[row] = ls_null
			this.setColumn("cat_art")
			return 
		end if

		// Verifica que centro_costo exista
		Select DESC_SUB_CAT
	     into :ls_desc
		  from articulo_sub_categ
		  Where COD_SUB_CAT = :data 
		    and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Sub Categoría ingresado " + data &
						+ " no existe o no esta activo, por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)

			this.object.sub_cat_art		[row] = ls_null
			this.object.desc_sub_cat	[row] = ls_null			
			return 1
		end if

		this.object.desc_sub_cat[row] = ls_desc
		
	case "cod_marca"
		// Verifica que codigo ingresado exista			
		Select nom_marca
	     into :ls_desc
		  from marca
		 Where cod_marca = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Marca ingresado " + data &
						+ " no existe o no esta activo, "&
						+ "por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.cod_marca	[row] = ls_null
			this.object.nom_marca	[row] = ls_null
			return 1
		end if

		this.object.nom_marca		[row] = ls_desc
		
	case "und"
		SELECT DESC_UNIDAD 
			into :ls_desc
		FROM unidad 
		where und = :data
		  and flag_Estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Unidad ingresado " + data &
						+ " no existe o no esta activo, "&
						+ "por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.und	[row] = ls_null
			return 1
		end if
		
	case "moneda_vta"
		SELECT DESCRIPCION 
			into :ls_desc
		FROM moneda 
		where COD_MONEDA = :data
		  and flag_Estado = '1';
				 
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			ls_mensaje = "Código de Moneda ingresado " + data &
						+ " no existe o no esta activo, "&
						+ "por favor verifique"
			gnvo_log.of_errorlog( ls_mensaje )
			gnvo_app.of_showmessagedialog( ls_mensaje)
			
			this.object.moneda_vta	[row] = ls_null
			return 1
		end if
		
END CHOOSE



//
//		
//
//end choose
end event

