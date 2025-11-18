$PBExportHeader$w_abc_master_smpl.srw
$PBExportComments$abc para tablas simples y pequeñas, formato tabular
forward
global type w_abc_master_smpl from w_abc_master
end type
end forward

global type w_abc_master_smpl from w_abc_master
integer width = 2203
integer height = 988
end type
global w_abc_master_smpl w_abc_master_smpl

type variables
Integer ii_sort_mst, ii_lec_mst = 1
end variables

on w_abc_master_smpl.create
call super::create
end on

on w_abc_master_smpl.destroy
call super::destroy
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_master


//ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_dw_share();call super::ue_dw_share;IF ii_lec_mst = 1 THEN dw_master.Retrieve()

end event

type dw_master from w_abc_master`dw_master within w_abc_master_smpl
event ue_display ( string as_columna,  long al_row )
integer width = 2139
integer height = 780
end type

event dw_master::ue_display;call super::ue_display;//boolean lb_ret
//string ls_codigo, ls_data, ls_sql
//choose case lower(as_columna)
//		
//	case "cod_motorista"
//
//		ls_sql = "SELECT t.cod_trabajador AS CODIGO_trabajador, " &
//				  + "t.nom_trabajador AS nombre_trabajador, " &
//				  + "t.DNI as documento_identidad " &
//				  + "FROM vw_pr_trabajador t, " &
//				  + "     fl_tripulantes ft " &
//				  + "where t.cod_Trabajador = ft.tripulante " & 
//				  + "  and ft.cargo_tripulante = (select cargo_motorista from fl_param where reckey = '1') " &
//				  + "  and t.flag_estado = '1'"
//				 
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.cod_motorista	[al_row] = ls_codigo
//			this.object.nom_trabajador	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//end choose
//
//
//
end event

event dw_master::constructor;call super::constructor;is_dwform =  'tabular'   // tabular,grid,form
end event

event dw_master::itemchanged;call super::itemchanged;//String 	ls_null, ls_desc1, ls_desc2
//Long 		ll_count
//
//dw_master.Accepttext()
//Accepttext()
//SetNull( ls_null)
//
//CHOOSE CASE dwo.name
//	CASE 'cod_art'
//		
//		// Verifica que codigo ingresado exista			
//		Select desc_art, und
//	     into :ls_desc1, :ls_desc2
//		  from articulo
//		 Where cod_art = :data  
//		   and flag_estado = '1';
//			
//		// Verifica que articulo solo sea de reposicion		
//		if SQLCA.SQlCode = 100 then
//			ROLLBACK;
//			MessageBox("Error", "no existe artículo o no se encuentra activo, por favor verifique")
//			this.object.cod_art	[row] = ls_null
//			this.object.desc_art	[row] = ls_null
//			this.object.und		[row] = ls_null
//			return 1
//			
//		end if
//
//		this.object.desc_art		[row] = ls_desc1
//		this.object.und			[row] = ls_desc2
//
//CASE 'cod_elemento' 
//
//		// Verifica que codigo ingresado exista			
//		Select desc_elemento
//	     into :ls_desc1
//		  from cam_elemento_quimico
//		 Where cod_elemento = :data  
//		   and flag_estado = '1';
//			
//		// Verifica que articulo solo sea de reposicion		
//		if SQLCA.SQlCode = 100 then
//			ROLLBACK;
//			MessageBox("Error", "No existe Elemento Químico o no se encuentra activo, por favor verifique")
//			this.object.cod_elemento	[row] = ls_null
//			this.object.desc_elemento	[row] = ls_null
//			return 1
//			
//		end if
//
//		this.object.desc_elemento		[row] = ls_desc1
//
//
//END CHOOSE
end event

event dw_master::doubleclicked;call super::doubleclicked;//string ls_columna
//long ll_row 
//str_seleccionar lstr_seleccionar
//
//this.AcceptText()
//If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
//ll_row = row
//
//if row > 0 then
//	ls_columna = upper(dwo.name)
//	this.event dynamic ue_display(ls_columna, ll_row)
//end if
end event

