$PBExportHeader$w_cam308_transporte_cana.srw
forward
global type w_cam308_transporte_cana from w_abc_master_smpl
end type
end forward

global type w_cam308_transporte_cana from w_abc_master_smpl
integer width = 2519
integer height = 672
string title = "[CAM308] Transporte de Caña"
string menuname = "m_abc_anular_lista"
boolean maxbox = false
boolean resizable = false
end type
global w_cam308_transporte_cana w_cam308_transporte_cana

type variables
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro)
end prototypes

public function integer of_set_numera ();integer li_id

if is_action = 'new' then
	select NVL(max(reckey),0) + 1
		into :li_id
	from campo_formulas;
	
	idw_1.object.reckey[idw_1.getRow()] = li_id
end if

return 1

end function

public subroutine of_retrieve (string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_nro)
is_action = 'open'

return 
end subroutine

on w_cam308_transporte_cana.create
call super::create
if this.MenuName = "m_abc_anular_lista" then this.MenuID = create m_abc_anular_lista
end on

on w_cam308_transporte_cana.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

ib_update_check = true

dw_master.of_set_flag_replicacion()


end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_transporte_cana_tbl'
sl_param.titulo = 'Transporte de Caña'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0 
end event

type dw_master from w_abc_master_smpl`dw_master within w_cam308_transporte_cana
integer x = 0
integer y = 0
integer width = 2482
integer height = 464
string dataobject = "d_abc_transporte_cana_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_Actual()
this.object.fec_transporte	[al_row] = Date(f_fecha_Actual())
this.object.cantidad			[al_row] = 0.000
this.object.und				[al_row] = 'TON'

is_action = "new"

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ruc
choose case lower(as_columna)
	case "cod_campo"
		ls_sql = "SELECT cod_campo AS codigo_campo, " &
				  + "desc_campo AS descripcion_campo " &
				  + "FROM campo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_campo	[al_row] = ls_codigo
			this.object.desc_campo	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "prov_transporte"
		ls_sql = "SELECT p.proveedor AS proveedor, " &
				  + "p.nom_proveedor AS razon_social, " &
				  + "p.ruc AS ruc " &
				  + "FROM proveedor p " &
				  + "WHERE p.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')

		if ls_codigo <> '' then
			this.object.prov_transporte	[al_row] = ls_codigo
			this.object.nom_proveedor		[al_row] = ls_data
			this.object.ruc					[al_row] = ls_ruc
			this.ii_update = 1
		end if

	case "und"
		ls_sql = "SELECT und AS unidad, " &
				  + "desc_unidad AS descripcion_unidad " &
				  + "FROM unidad " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.und	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_campo'
		
		// Verifica que codigo ingresado exista			
		Select desc_campo
	     into :ls_desc1
		  from campo
		 Where cod_campo = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Campo o no se encuentra activo, por favor verifique")
			this.object.cod_campo	[row] = ls_null
			this.object.desc_campo	[row] = ls_null
			return 1
			
		end if

		this.object.desc_campo		[row] = ls_desc1

	CASE 'prov_transporte'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor, ruc
	     into :ls_desc1, :ls_desc2
		  from proveedor
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de proveedor o no se encuentra activo, por favor verifique")
			this.object.prov_transporte	[row] = ls_null
			this.object.nom_proveedor		[row] = ls_null
			this.object.ruc					[row] = ls_null
			return 1
			
		end if

		this.object.nom_proveedor		[row] = ls_desc1
		this.object.ruc					[row] = ls_desc2

	CASE 'und'
		
		// Verifica que codigo ingresado exista			
		Select desc_unidad
	     into :ls_desc1
		  from unidad
		 Where und = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Codigo de Unidad o no se encuentra activo, por favor verifique")
			this.object.und	[row] = ls_null
			return 1
		end if

END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

