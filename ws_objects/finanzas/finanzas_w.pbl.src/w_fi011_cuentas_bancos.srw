$PBExportHeader$w_fi011_cuentas_bancos.srw
forward
global type w_fi011_cuentas_bancos from w_abc_master_smpl
end type
end forward

global type w_fi011_cuentas_bancos from w_abc_master_smpl
integer width = 1778
integer height = 1012
string title = "[FI011] Cuentas de Banco"
string menuname = "m_mantenimiento_cl"
boolean maxbox = false
boolean resizable = false
event ue_find_exact ( )
end type
global w_fi011_cuentas_bancos w_fi011_cuentas_bancos

type variables
String is_accion,is_col,is_tipo
end variables

forward prototypes
public subroutine of_retrieve (string as_nro_cnta)
end prototypes

public subroutine of_retrieve (string as_nro_cnta);dw_master.Retrieve(as_nro_cnta)
dw_master.ii_update = 0

dw_master.ii_protect = 0
dw_master.of_protect( )

dw_master.resetUpdate()

is_Action = 'open'

end subroutine

on w_fi011_cuentas_bancos.create
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
end on

on w_fi011_cuentas_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return

ib_update_check = true

end event

event ue_dw_share();//override
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
//str_parametros sl_param
//
//TriggerEvent ('ue_update_request')		
//
//sl_param.dw1    = ''
//sl_param.titulo = ''
//sl_param.field_ret_i[1] = 1
//
//
//OpenWithParm( w_search_datos, sl_param)
//
//sl_param = Message.PowerObjectParm
//
//IF sl_param.titulo <> 'n' THEN
//	of_retrieve(sl_param.field_ret[1])
//END IF

//override
// Asigna valores a structura 
str_parametros lstr_param

TriggerEvent ('ue_update_request')	

lstr_param.dw1    = 'd_lista_banco_cnta_tbl'
lstr_param.titulo = 'Cuentas de Banco'
lstr_param.field_ret_i[1] = 1	//Cuenta de Banco

OpenWithParm( w_lista, lstr_param)

lstr_param = Message.PowerObjectParm
IF lstr_param.titulo <> 'n' THEN
	of_retrieve(lstr_param.field_ret[1])
END IF


end event

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi011_cuentas_bancos
event ue_refresh_det ( )
integer width = 1765
integer height = 832
string dataobject = "d_abc_cnta_bco_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::clicked;//Override
idw_1 = THIS
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_accion = 'new'

this.object.flag_estado 		[al_Row] = '1'
this.object.flag_flujo_caja 	[al_Row] = '1'
this.object.flag_uso_interno 	[al_Row] = '1'
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form

ii_ck[1] = 1	
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
str_cnta_cntbl 	lstr_cnta

choose case lower(as_columna)
		
	case "cod_banco"

		ls_sql = "select cod_banco as codigo_banco, " &
				 + "nom_banco as nombre_banco " &
				 + "from banco"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_banco	[al_row] = ls_codigo
			this.object.nom_banco	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_ctbl"
		
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_ctbl [al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta [al_row] = lstr_cnta.desc_cnta
			this.ii_update = 1
		end if
		
end choose
		




end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_data
Long 		ll_count

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_banco'
		
		// Verifica que codigo ingresado exista			
		Select nom_banco
	     into :ls_data
		  from banco
		 Where cod_banco = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Banco o no se encuentra activo, por favor verifique")
			this.object.cod_banco	[row] = gnvo_app.is_null
			this.object.nom_banco	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_banco		[row] = ls_data

	CASE 'cnta_ctbl' 

		// Verifica que codigo ingresado exista			
		Select desc_cnta
	     into :ls_data
		  from cntbl_cnta
		 Where cnta_ctbl = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Cuenta Contable " + data + " no existe o no se encuentra activo, por favor verifique")
			this.object.cnta_ctbl	[row] = gnvo_app.is_null
			this.object.desc_cnta	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_cnta		[row] = ls_data


END CHOOSE
end event

