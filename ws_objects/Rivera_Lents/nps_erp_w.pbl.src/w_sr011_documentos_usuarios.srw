$PBExportHeader$w_sr011_documentos_usuarios.srw
forward
global type w_sr011_documentos_usuarios from w_abc_master_smpl
end type
end forward

global type w_sr011_documentos_usuarios from w_abc_master_smpl
integer width = 2592
integer height = 1756
string title = "Documentos x usuario [SR011]"
string menuname = "m_mtto_smpl"
end type
global w_sr011_documentos_usuarios w_sr011_documentos_usuarios

on w_sr011_documentos_usuarios.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr011_documentos_usuarios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.tipo_doc.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_doc.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;//f_centrar( this )
ii_pregunta_delete = 1 

ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

idw_1.Retrieve(gnvo_app.invo_empresa.is_empresa)

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

type p_pie from w_abc_master_smpl`p_pie within w_sr011_documentos_usuarios
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_sr011_documentos_usuarios
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr011_documentos_usuarios
end type

type st_box from w_abc_master_smpl`st_box within w_sr011_documentos_usuarios
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_sr011_documentos_usuarios
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_sr011_documentos_usuarios
end type

type p_logo from w_abc_master_smpl`p_logo within w_sr011_documentos_usuarios
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr011_documentos_usuarios
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr011_documentos_usuarios
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr011_documentos_usuarios
integer x = 503
integer y = 280
integer width = 2501
integer height = 840
string dataobject = "d_abc_documento_usuario"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("tipo_doc.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.cod_empresa [al_row] = gnvo_app.invo_empresa.is_empresa
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::itemchanged;call super::itemchanged;// Busco descripcion del documento
string ls_column, ls_tipo_doc, ls_desc_tipo_doc, ls_cod_usr, ls_nombre
long ll_nro_serie

this.accepttext()

ls_column = lower(string(dwo.name))


choose case ls_column
	case 'tipo_doc'
		ls_tipo_doc = this.object.tipo_doc[row]
		declare busca_doc_tipo procedure for 
			usp_fin_busca_doc_tipo(:ls_tipo_doc);
		execute busca_doc_tipo;
		fetch busca_doc_tipo into :ls_tipo_doc, :ls_desc_tipo_doc;
		close busca_doc_tipo;
		this.object.tipo_doc[row] = ls_tipo_doc
		this.object.desc_tipo_doc[row] = ls_desc_tipo_doc
		
	case 'nro_serie'
		ls_tipo_doc = this.object.tipo_doc[row]
		ll_nro_serie = this.object.nro_serie[row]
		declare busca_nro_serie procedure for 
			usp_fin_busca_nro_serie(:ls_tipo_doc, :ll_nro_serie);
		execute busca_nro_serie;
		fetch busca_nro_serie into :ll_nro_serie;
		close busca_nro_serie;
		this.object.nro_serie[row] = ll_nro_serie 
		
	case 'cod_usr'
		ls_cod_usr = this.object.cod_usr[row]
		declare busca_usuario procedure for 
			usp_tg_busca_usuario(:ls_cod_usr);
		execute busca_usuario;
		fetch busca_usuario into :ls_cod_usr, :ls_nombre;
		close busca_usuario;
		this.object.cod_usr[row] = ls_cod_usr
		this.object.nombre[row] = ls_nombre
end choose


end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_column, ls_sql, ls_return1, ls_return2, ls_tipo_doc
long ll_serie
ls_column = lower(string(dwo.name))


choose case ls_column
	case 'tipo_doc'
		setnull(ll_serie)
		ls_sql = "select tipo_doc as id, desc_tipo_doc as descripcion from doc_tipo"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return 2
		this.object.tipo_doc[row] = ls_return1
		this.object.desc_tipo_doc[row] = ls_return2
		this.object.nro_serie[row] = ll_serie
	case 'nro_serie'
		ls_tipo_doc = this.object.tipo_doc[row]
		ls_sql = "select desc_tipo_doc as documento, nro_serie as serie from wv_fin_num_doc_serie where trim(tipo_doc) = trim('" +ls_tipo_doc+"')"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return2) or trim(ls_return2) = '' then return 2
		this.object.nro_serie[row] = long(ls_return2)
	
	case 'cod_usr'
		ls_sql = "select cod_usr as id, nombre as descripcion from usuario"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return 2
		this.object.cod_usr[row] = ls_return1
		this.object.nombre[row] = ls_return2
end choose
end event

