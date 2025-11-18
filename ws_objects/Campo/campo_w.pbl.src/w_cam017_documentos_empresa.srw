$PBExportHeader$w_cam017_documentos_empresa.srw
forward
global type w_cam017_documentos_empresa from w_abc_master_smpl
end type
end forward

global type w_cam017_documentos_empresa from w_abc_master_smpl
integer width = 2487
integer height = 1064
string title = "[CAM030] Instructivos de Trabajo"
string menuname = "m_abc_master_smpl"
end type
global w_cam017_documentos_empresa w_cam017_documentos_empresa

type variables

end variables

on w_cam017_documentos_empresa.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam017_documentos_empresa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam017_documentos_empresa
integer width = 2368
string dataobject = "d_abc_sic_doc_empresa_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer li_id, li_item = 0, li_row

select max(doc_id)
	into :li_id
from SIC_DOCUMENTOS_EMPRESA;

if dw_master.RowCount( ) > 0 then
	for li_row = 1 to dw_master.RowCount( )
			if li_item < Int(dw_master.object.doc_id[li_row]) then
				li_item = Int(dw_master.object.doc_id[li_row])
			end if
	next
end if

if isNull(li_id) then
	li_id = 0
end if

if li_item > li_id then
	li_id = li_item
end if
li_id = li_id +1

this.object.doc_id[al_row] = li_id
this.object.cod_usr[al_row] = gs_user
this.object.fec_registro	[al_row] = f_fecha_actual()
end event

event dw_master::clicked;call super::clicked;String	ls_docname, ls_named, ls_cod
integer	li_Result
str_seleccionar lstr_seleccionar
n_cst_upload_file	lnvo_Master

if lower(dwo.name) = 'b_upload' or lower(dwo.name) = 'b_view'  then
	ls_cod = string(dw_master.object.doc_id[dw_master.getRow()])
end if


choose case lower(dwo.name)
	case 'b_upload'
		li_result = GetFileOpenName("Seleccione Archivo", &
						ls_docname, ls_named, "DOC", &
						"Documentos de Word 97-2003 (*.DOC),*.DOC, Archivos Acrobat PDF (*.PDF),*.PDF, Archivos GIF (*.GIF),*.GIF,Archivos BMP (*.BMP),*.BMP,Archivos JPG (*.JPG),*.JPG")
	
		if li_result = 1 then
				
				if ls_cod = "" or IsNull(ls_cod) then
					MessageBox('Error', 'Asegurese de grabar los datos antes de Subir el Archivo')
					return
				end if

				lnvo_Master = create n_cst_upload_file
				lnvo_Master.of_grabar_foto( ls_docname, ls_cod, "",date('01/01/2012'),'4')
				destroy lnvo_Master
		end if
		this.retrieve(ls_cod)
	case 'b_view'
			lstr_seleccionar.s_column = ls_cod
			lstr_seleccionar.s_seleccion = '4'
			OpenWithParm(w_documento, lstr_seleccionar)

END CHOOSE

end event

