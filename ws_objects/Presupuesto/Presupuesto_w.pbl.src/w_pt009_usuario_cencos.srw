$PBExportHeader$w_pt009_usuario_cencos.srw
forward
global type w_pt009_usuario_cencos from w_abc_master_smpl
end type
end forward

global type w_pt009_usuario_cencos from w_abc_master_smpl
string title = "Usuarios Vs Centros Costo (PT009)"
string menuname = "m_mantenimiento_simple"
end type
global w_pt009_usuario_cencos w_pt009_usuario_cencos

on w_pt009_usuario_cencos.create
call super::create
if this.MenuName = "m_mantenimiento_simple" then this.MenuID = create m_mantenimiento_simple
end on

on w_pt009_usuario_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_pt009_usuario_cencos
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
string dataobject = "d_abc_usuario_cencos_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cod_usr"
		ls_sql = "SELECT cod_usr AS CODIGO_usuario, " &
				  + "nombre AS nombre_usuario " &
				  + "FROM usuario " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_usr		[al_row] = ls_codigo
			this.object.nom_usuario	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cencos"
		ls_sql = "SELECT cencos AS codigo_Cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3				// columnas de lectrua de este dw

end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_Replicacion[al_row] = '1'
end event

