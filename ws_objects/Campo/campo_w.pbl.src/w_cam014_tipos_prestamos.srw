$PBExportHeader$w_cam014_tipos_prestamos.srw
forward
global type w_cam014_tipos_prestamos from w_abc_master_smpl
end type
end forward

global type w_cam014_tipos_prestamos from w_abc_master_smpl
integer height = 1064
string title = "[CAM014] Tipos de Prestamos"
string menuname = "m_abc_master_smpl"
end type
global w_cam014_tipos_prestamos w_cam014_tipos_prestamos

on w_cam014_tipos_prestamos.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam014_tipos_prestamos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam014_tipos_prestamos
string dataobject = "d_abc_tipo_prestamo_tbl"
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
	case "tipo_doc"
		ls_sql = "SELECT tipo_doc AS tipo_documento, " &
				  + "desc_tipo_doc AS descripcion_tipo_documento " &
				  + "FROM doc_tipo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
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
	CASE 'tipo_doc'
		
		// Verifica que codigo ingresado exista			
		Select desc_tipo_doc
	     into :ls_desc1
		  from doc_tipo
		 Where tipo_doc = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de documento o no se encuentra activo, por favor verifique")
			this.object.tipo_doc			[row] = ls_null
			this.object.desc_tipo_doc	[row] = ls_null
			return 1
			
		end if

		this.object.desc_tipo_doc		[row] = ls_desc1

END CHOOSE
end event

