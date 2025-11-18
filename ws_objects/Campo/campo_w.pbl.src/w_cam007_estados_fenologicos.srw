$PBExportHeader$w_cam007_estados_fenologicos.srw
forward
global type w_cam007_estados_fenologicos from w_abc_master_smpl
end type
end forward

global type w_cam007_estados_fenologicos from w_abc_master_smpl
integer height = 1064
string title = "[CAM007] Estados Fenológicos"
string menuname = "m_abc_master_smpl"
end type
global w_cam007_estados_fenologicos w_cam007_estados_fenologicos

on w_cam007_estados_fenologicos.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam007_estados_fenologicos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam007_estados_fenologicos
string dataobject = "d_abc_estado_fenologicos_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
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
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_etapa_feno"
		ls_sql = "SELECT cod_etapa_feno AS etapa_fenologica, " &
				  + "desc_etapa_feno AS descripcion_etapa " &
				  + "FROM cam_etapa_fenologica " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_etapa_feno		[al_row] = ls_codigo
			this.object.desc_etapa_feno	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_etapa_feno'
		
		// Verifica que codigo ingresado exista			
		Select desc_etapa_feno
	     into :ls_desc1
		  from cam_etapa_fenologica
		 Where cod_etapa_feno = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Etapa Fenológica o no se encuentra activo, por favor verifique")
			this.object.cod_etapa_feno		[row] = ls_null
			this.object.desc_etapa_feno	[row] = ls_null
			return 1
			
		end if

		this.object.desc_etapa_feno		[row] = ls_desc1

END CHOOSE
end event

