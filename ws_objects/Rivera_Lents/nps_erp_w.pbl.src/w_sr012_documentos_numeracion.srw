$PBExportHeader$w_sr012_documentos_numeracion.srw
forward
global type w_sr012_documentos_numeracion from w_abc_master_smpl
end type
end forward

global type w_sr012_documentos_numeracion from w_abc_master_smpl
integer width = 2459
integer height = 1604
string title = "[SR012] Numeracion de Documentos"
string menuname = "m_mtto_smpl"
end type
global w_sr012_documentos_numeracion w_sr012_documentos_numeracion

on w_sr012_documentos_numeracion.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr012_documentos_numeracion.destroy
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
ib_log = TRUE
ii_lec_mst = 0 

idw_1.Retrieve(gnvo_app.invo_empresa.is_empresa)

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
end event

type p_pie from w_abc_master_smpl`p_pie within w_sr012_documentos_numeracion
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_sr012_documentos_numeracion
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr012_documentos_numeracion
end type

type st_box from w_abc_master_smpl`st_box within w_sr012_documentos_numeracion
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_sr012_documentos_numeracion
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_sr012_documentos_numeracion
end type

type p_logo from w_abc_master_smpl`p_logo within w_sr012_documentos_numeracion
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr012_documentos_numeracion
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr012_documentos_numeracion
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr012_documentos_numeracion
integer x = 503
integer y = 276
integer width = 2373
integer height = 1220
string dataobject = "d_abc_documentos_numeracion"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.Modify("tipo_doc.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.ultimo_numero 	[al_row] = 1
this.object.cod_empresa 	[al_row] = gnvo_app.invo_empresa.is_empresa
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;// Busco descripcion del documento
String ls_desc, ls_null
this.AcceptText()

SetNull(ls_null)

if row <= 0 then return

choose case lower(dwo.name)
	case "tipo_doc"
		
		Select desc_tipo_doc 
			into :ls_desc 
		from doc_tipo 
		where tipo_doc = :data
		  and flag_estado = '1';

		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Tipo de Documento no existe o no esta activo", StopSign!)
			this.object.tipo_doc	 		[row] = ls_null
			this.object.desc_tipo_doc	[row] = ls_null
			return 1
		end if

		this.object.desc_tipo_doc[row] = ls_desc
	
end choose

end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "tipo_doc"
		ls_sql = "SELECT tipo_doc AS tipo_documento, " &
				  + "desc_tipo_doc AS descripcion_tipo_doc " &
				  + "FROM doc_tipo " &
				  + "where flag_Estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_doc			[al_row] = ls_codigo
			this.object.desc_tipo_doc	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

