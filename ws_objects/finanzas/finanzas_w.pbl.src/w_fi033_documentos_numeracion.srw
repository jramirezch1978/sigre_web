$PBExportHeader$w_fi033_documentos_numeracion.srw
forward
global type w_fi033_documentos_numeracion from w_abc_master_smpl
end type
end forward

global type w_fi033_documentos_numeracion from w_abc_master_smpl
integer width = 2459
integer height = 1604
string title = "[FI033] Numeracion de Documentos"
string menuname = "m_mantenimiento_sl"
end type
global w_fi033_documentos_numeracion w_fi033_documentos_numeracion

on w_fi033_documentos_numeracion.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi033_documentos_numeracion.destroy
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
ib_log = TRUE

idw_1.Retrieve()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi033_documentos_numeracion
integer width = 2373
integer height = 1220
string dataobject = "d_abc_documentos_numeracion_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("tipo_doc.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.flag_tipo_impresion 	[al_row] = '0'
this.object.flag_tipo_email	 	[al_row] = '0'
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemchanged;call super::itemchanged;// Busco descripcion del documento

String 	ls_desc

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
			MessageBox("Error", "no existe artículo o no se encuentra activo, por favor verifique")
			this.object.tipo_doc			[row] = gnvo_app.is_null
			this.object.desc_tipo_doc	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_tipo_doc		[row] = ls_desc

END CHOOSE
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "tipo_doc"

		ls_sql = "select tipo_doc as tipo_doc, " &
				 + "desc_tipo_doc as desc_tipo_doc " &
				 + "from doc_tipo " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
end event

event dw_master::buttonclicked;call super::buttonclicked;str_parametros	lstr_param

if row = 0 then return

if lower(dwo.name) = 'b_comentarios' then
	
	If this.is_protect("comentarios", row) then RETURN
	
	// Para la descripcion de la Factura
	lstr_param.string1   = 'Ingrese comentarios del registro'
	lstr_param.string2	 = this.object.comentarios [row]

	OpenWithParm( w_descripcion_fac, lstr_param)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
	IF lstr_param.titulo = 's' THEN
			This.object.comentarios [row] = left(lstr_param.string3, 2000)
			this.ii_update = 1
	END IF	
end if
end event

