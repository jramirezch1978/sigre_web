$PBExportHeader$w_fi030_documentos_usuarios.srw
forward
global type w_fi030_documentos_usuarios from w_abc_master_smpl
end type
end forward

global type w_fi030_documentos_usuarios from w_abc_master_smpl
integer width = 2592
integer height = 1756
string title = "[FI030] Documentos x usuario"
string menuname = "m_mantenimiento_sl"
end type
global w_fi030_documentos_usuarios w_fi030_documentos_usuarios

on w_fi030_documentos_usuarios.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi030_documentos_usuarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_doc.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_doc.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 

idw_1.Retrieve()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion ()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi030_documentos_usuarios
integer width = 2501
integer height = 840
string dataobject = "d_abc_documento_usuario"
end type

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("tipo_doc.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc, ls_tipo_doc

dw_master.Accepttext()
Accepttext()

CHOOSE CASE dwo.name
	CASE 'tipo_doc'
		
		// Verifica que codigo ingresado exista			
		Select desc_tipo_doc
	     into :ls_desc
		  from doc_tipo
		 Where tipo_doc = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Documento o no se encuentra activo, por favor verifique")
			this.object.tipo_doc			[row] = gnvo_app.is_null
			this.object.desc_tipo_doc	[row] = gnvo_app.is_null
			this.object.nro_serie		[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_tipo_doc	[row] = ls_desc
		this.object.nro_serie		[row] = gnvo_app.is_null

	CASE 'nro_serie' 
		
		ls_tipo_doc = this.object.tipo_doc [row]
		
		if IsNull(ls_tipo_doc) or ls_tipo_doc = '' then
			MessageBox('Error', 'Debe ingresar primero tipo de documento, por favor verifique!', Exclamation!)
			this.object.nro_serie [row] = gnvo_app.is_null
			this.setColumn('tipo_doc')
			
			return 1
		end if

		// Verifica que codigo ingresado exista			
		Select n.nro_serie
	     into :ls_Desc
		  from num_doc_tipo 	n,
		  		 doc_tipo		dt
		 Where n.tipo_doc			= dt.tipo_doc
		   and n.tipo_doc 		= :ls_tipo_doc
		   and n.nro_serie		=:data  
		   and dt.flag_estado 	= '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Numero de Serie o no se encuentra activo, por favor verifique")
			this.object.nro_serie	[row] = gnvo_app.is_null
			return 1
			
		end if

	CASE 'cod_usr'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from usuario
		 Where cod_usr = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Usuario o no se encuentra activo, por favor verifique")
			this.object.cod_usr	[row] = gnvo_app.is_null
			this.object.nombre	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nombre	[row] = ls_desc
END CHOOSE


end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo_doc
choose case lower(as_columna)
		
	case "tipo_doc"

		ls_sql = "select tipo_doc as tipo_Doc, " &
				 + "desc_tipo_doc as descripcion "&
				 + "from doc_tipo " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
			this.object.nro_serie		[al_row] = gnvo_app.is_null
			this.ii_update = 1
		end if

	case "nro_serie"
		ls_tipo_doc = this.object.tipo_doc[al_row]
		
		if IsNull(ls_tipo_doc) or ls_tipo_doc = '' then
			f_mensaje("Debe Ingresar un tipo de documento, por favor verifique!", "")
			this.setColumn( "tipo_Doc")
			return 
		end if
		
		ls_sql = "select dt.desc_tipo_doc as desc_tipo_doc, " &
				 + "t.nro_serie as nro_Serie " &
				 + "from num_doc_tipo t, " &
				 + "     doc_tipo     dt " &
				 + "where dt.tipo_doc = t.tipo_doc" &
				 + "  and trim(t.tipo_doc) = trim('" +ls_tipo_doc+"')" &
				 + "  and dt.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nro_serie		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_usr"

		ls_sql = "select cod_usr as cod_usr, " &
				 + "nombre as descripcion " &
				 + "from usuario " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_usr	[al_row] = ls_codigo
			this.object.nombre	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
end event

