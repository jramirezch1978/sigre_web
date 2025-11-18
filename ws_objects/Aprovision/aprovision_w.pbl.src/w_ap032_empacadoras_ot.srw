$PBExportHeader$w_ap032_empacadoras_ot.srw
forward
global type w_ap032_empacadoras_ot from w_abc_mastdet_smpl
end type
end forward

global type w_ap032_empacadoras_ot from w_abc_mastdet_smpl
integer width = 2286
integer height = 1904
string title = "[AP032] OT por empacadoras"
string menuname = "m_mantto_smpl"
end type
global w_ap032_empacadoras_ot w_ap032_empacadoras_ot

on w_ap032_empacadoras_ot.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap032_empacadoras_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_insert;//Override
Long  ll_row

//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF

if idw_1 = dw_master then
	MessageBox('Error', 'No se ingresan registros en este panel!!!')
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;//Override
dw_detail.of_protect()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap032_empacadoras_ot
integer x = 0
integer y = 0
integer width = 2208
integer height = 896
string dataobject = "d_list_empacadoras_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle


end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap032_empacadoras_ot
integer x = 0
integer y = 908
integer width = 2117
integer height = 644
string dataobject = "d_abc_empacadora_ot_tbl"
end type

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "nro_orden"

		ls_sql = "select nro_orden as numero_orden, " &
				 + "titulo as titulo_ot, " &
				 + "to_char(fec_estimada, 'dd/mm/yyyy') as fec_estimada " &
				 + "from orden_trabajo " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.titulo_ot	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master


end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'nro_orden'
		
		// Verifica que codigo ingresado exista			
		Select titulo
	     into :ls_desc1
		  from orden_trabajo
		 Where nro_orden = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Orden de Trabajo o no se encuentra activo, por favor verifique")
			this.object.titulo_ot	[row] = ls_null
			this.object.nro_orden	[row] = ls_null
			return 1
			
		end if

		this.object.titulo_ot		[row] = ls_desc1

END CHOOSE
end event

