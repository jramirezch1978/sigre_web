$PBExportHeader$w_pt018_prsp_caja_seccion.srw
forward
global type w_pt018_prsp_caja_seccion from w_abc_mastdet_smpl
end type
end forward

global type w_pt018_prsp_caja_seccion from w_abc_mastdet_smpl
integer width = 1870
integer height = 2340
string title = "[PT018] Secciones para Presupuesto de Caja"
string menuname = "m_mantenimiento_simple"
end type
global w_pt018_prsp_caja_seccion w_pt018_prsp_caja_seccion

on w_pt018_prsp_caja_seccion.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_pt018_prsp_caja_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if gnvo_app.of_row_Processing( dw_master ) <> true then return

if gnvo_app.of_row_Processing( dw_detail ) <> true then return
	

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

ib_update_check = True
end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pt018_prsp_caja_seccion
integer x = 0
integer y = 0
integer width = 1755
integer height = 1080
string dataobject = "d_abc_prsp_caja_seccion_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_output;call super::ue_output;dw_detail.REtrieve(dw_master.object.cod_seccion[al_row] )
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr			[al_row] = gs_user
this.object.flag_estado		[al_row] = '1'
end event

event dw_master::rowfocuschanged;//Override
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pt018_prsp_caja_seccion
integer x = 0
integer y = 1092
integer width = 1659
integer height = 780
string dataobject = "d_abc_prsp_caja_seccion_det_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 2 	      // columnas que recibimos del master

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr			[al_row] = gs_user
this.object.flag_estado		[al_row] = '1'
this.object.cod_seccion		[al_row] = dw_master.object.cod_seccion [dw_master.getRow()]
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_detail::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cnta_prsp"

		ls_sql = "SELECT t.cnta_prsp AS cuenta_prsp, " &
				  + "t.descripcion AS descripcion_cnta_prsp " &
				  + "FROM presupuesto_cuenta t " &
				  + "where t.flag_estado = '1' " &
				  + "order by descripcion_cnta_prsp "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_prsp_cnta	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc
Long 		ll_count

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cnta_prsp'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc
		  from presupuesto_cuenta
		 Where cnta_prsp = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Cuenta Presupuestal o no se encuentra activo, por favor verifique")
			this.object.cnta_prsp		[row] = gnvo_app.is_null
			this.object.desc_prsp_cnta	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_prsp_cnta		[row] = ls_desc

END CHOOSE
end event

