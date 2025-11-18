$PBExportHeader$w_cas001_asesor_financiero.srw
forward
global type w_cas001_asesor_financiero from w_abc_master_smpl
end type
end forward

global type w_cas001_asesor_financiero from w_abc_master_smpl
integer x = 0
integer y = 0
integer width = 3465
integer height = 1340
string title = "[CAS001] Asesores Financieros"
string menuname = "m_mantto_smpl"
long backcolor = 67108864
integer ii_x = 0
boolean ib_update_check = false
end type
global w_cas001_asesor_financiero w_cas001_asesor_financiero

type variables
n_cst_utilitario 	invo_utility
end variables

forward prototypes
public function string of_get_puerto ()
public function integer of_set_numera ()
end prototypes

public function string of_get_puerto ();long 		ll_row, ll_number, ll_temp
string 	ls_puerto, ls_temp

ll_number = 0

for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.puerto[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long(mid(ls_temp,3) )
		if ll_temp > ll_number then
			ll_number = ll_temp
		end if
	end if
next

ll_number ++
ls_puerto = gs_origen + string(ll_number,'000000')

return ls_puerto

end function

public function integer of_set_numera ();long 		ll_row
String	ls_cod_asesor

if dw_master.RowCount() = 0 then return 0

for ll_row = 1 to dw_master.RowCount()
	ls_cod_asesor = dw_master.object.cod_asesor [ll_row]
	
	if dw_master.is_row_new(ll_row) or IsNull(ls_cod_asesor) or trim(ls_cod_asesor) = '' then
		dw_master.object.cod_asesor [ll_Row] = gnvo_app.utilitario.of_set_numera(dw_master.of_get_UpdateTable(), 8)
	end if
next

return 1
end function

on w_cas001_asesor_financiero.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_cas001_asesor_financiero.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if of_set_numera() = 0 then return

if gnvo_app.of_row_processing( dw_master) = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cas001_asesor_financiero
integer width = 3401
integer height = 1108
string dataobject = "d_abc_asesores_financieros_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado			[al_row] = '1'
this.object.fec_registro		[al_row] = gnvo_app.of_fecha_Actual()
this.object.cod_usr				[al_row] = gs_user
end event

event dw_master::itemchanged;call super::itemchanged;String 	 ls_desc

this.Accepttext()

CHOOSE CASE dwo.name
	case "zona_venta"

		// Verifica que codigo ingresado exista	
		select t.desc_zona_venta
			into :ls_desc
		from vta_zona_venta t
		where t.flag_estado = '1'
		  and t.zona_venta = :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Zona de Venta " + data + " no existe o no se encuentra activo, por favor verifique")
			this.object.zona_venta			[row] = gnvo_app.is_null
			this.object.desc_zona_venta	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_zona_venta			[row] = ls_desc

	case "tipo_doc_ident"

		// Verifica que codigo ingresado exista	
		select t.desc_tipo_doc_rtps
			into :ls_desc
		from RRHH_TIPO_DOC_RTPS t
		where t.flag_estado = '1'
		  and t.tipo_doc_rtps = :data;

		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Tipo de Documento de Identidad " + data + " no existe o no se encuentra activo, por favor verifique")
			this.object.tipo_doc_ident			[row] = gnvo_app.is_null
			this.object.desc_tipo_doc_ident	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_tipo_doc_ident			[row] = ls_desc
		
		
		

END CHOOSE
end event

event dw_master::itemerror;call super::itemerror;return 1
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
		
	case "tipo_doc_ident"

		ls_sql = "select t.tipo_doc_rtps as tipo_doc_rtps," &
				 + "t.desc_tipo_doc_rtps as desc_tipo_doc_rtps " &
				 + "from RRHH_TIPO_DOC_RTPS t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_doc_ident			[al_row] = ls_codigo
			this.object.desc_tipo_doc_ident	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "zona_venta"

		ls_sql = "select t.zona_venta as zona_venta, " &
				 + "       t.desc_zona_venta as desc_zona_centa " &
				 + "from VTA_ZONA_VENTA t " &
				 + "where t.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.zona_venta			[al_row] = ls_codigo
			this.object.desc_zona_venta	[al_row] = ls_data
			this.ii_update = 1
		end if
		

end choose



end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

