$PBExportHeader$w_ve024_consignatarios.srw
forward
global type w_ve024_consignatarios from w_abc_master_smpl
end type
end forward

global type w_ve024_consignatarios from w_abc_master_smpl
integer x = 0
integer y = 0
integer width = 3465
integer height = 1340
string title = "[VE024] Consignatarios"
string menuname = "m_mantenimiento_sl"
long backcolor = 67108864
integer ii_x = 0
boolean ib_update_check = false
end type
global w_ve024_consignatarios w_ve024_consignatarios

forward prototypes
public function string of_get_puerto ()
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

on w_ve024_consignatarios.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve024_consignatarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_ve024_consignatarios
integer width = 3401
integer height = 1108
string dataobject = "d_abc_consignatarios_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_puerto

ls_puerto = of_get_puerto()

this.object.puerto		[al_row] = ls_puerto
this.object.profundidad [al_row] = 0
this.object.flag_estado	[al_row] = '1'
end event

event dw_master::itemchanged;call super::itemchanged;String 	 ls_nom_proveedor, ls_ruc_dni
Long 		ll_count

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		select p.nom_proveedor, decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) 
			into :ls_nom_proveedor, :ls_ruc_dni
		from 	proveedor      p
		where p.proveedor			= :data
		  and p.flag_estado 		= '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "Codigo de Proveedor no existe o no se encuentra activo, por favor verifique")
			this.object.consignatario	[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			this.object.ruc_dni			[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_proveedor	[row] = ls_nom_proveedor
		this.object.ruc_dni			[row] = ls_ruc_dni

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
string ls_codigo, ls_data, ls_sql, ls_data2
choose case lower(as_columna)
		
	case "consignatario"

		ls_sql = "select p.proveedor as proveedor, " &
				 + "p.nom_proveedor as nombre_proveedor, " &
				 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
				 + "from proveedor p " &
				 + "where p.flag_estado = '1'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')
		
		if ls_codigo <> '' then
			this.object.consignatario	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.object.ruc_dni			[al_row] = ls_data2
			this.ii_update = 1
		end if

end choose



end event

