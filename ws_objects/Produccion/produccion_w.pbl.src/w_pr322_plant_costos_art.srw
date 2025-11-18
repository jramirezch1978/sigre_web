$PBExportHeader$w_pr322_plant_costos_art.srw
forward
global type w_pr322_plant_costos_art from w_abc_master_smpl
end type
end forward

global type w_pr322_plant_costos_art from w_abc_master_smpl
integer width = 2752
integer height = 932
string title = "Plantilla de Costo de Ariculo(PR322)"
end type
global w_pr322_plant_costos_art w_pr322_plant_costos_art

on w_pr322_plant_costos_art.create
call super::create
end on

on w_pr322_plant_costos_art.destroy
call super::destroy
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'PLANT_COSTO_ART'

ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr322_plant_costos_art
event ue_display ( string as_columna,  long al_row )
integer y = 16
integer width = 2670
string dataobject = "d_abc_prod_costo_art_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_ART"

		ls_sql = "SELECT COD_ART AS CODIGO, " &
				  + "DESC_ART AS DESCRIPCION " &
				  + "FROM ARTICULO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art		[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

