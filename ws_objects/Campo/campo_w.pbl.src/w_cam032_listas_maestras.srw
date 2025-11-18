$PBExportHeader$w_cam032_listas_maestras.srw
forward
global type w_cam032_listas_maestras from w_abc_master_smpl
end type
end forward

global type w_cam032_listas_maestras from w_abc_master_smpl
integer width = 2487
integer height = 1064
string title = "[CAM032] Listas Maestras"
string menuname = "m_abc_master_smpl"
end type
global w_cam032_listas_maestras w_cam032_listas_maestras

type variables

end variables

on w_cam032_listas_maestras.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam032_listas_maestras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam032_listas_maestras
integer width = 2368
string dataobject = "d_abc_sic_listas_maestras"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;integer li_id, li_item = 0, li_row

select max(procedimiento_id)
	into :li_id
from sic_procedimientos;

if dw_master.RowCount( ) > 0 then
	for li_row = 1 to dw_master.RowCount( )
			if li_item < Int(dw_master.object.procedimiento_id[li_row]) then
				li_item = Int(dw_master.object.procedimiento_id[li_row])
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

this.object.procedimiento_id[al_row] = li_id
this.object.flag_estado[al_row] = '1'
this.object.flag_tipo[al_row] = '3'
this.object.cod_usr[al_row] = gs_user
this.object.fec_registro [ al_row] = f_fecha_actual()
this.setcolumn('cod_procedimiento')
end event

event dw_master::clicked;call super::clicked;String	ls_docname, ls_named, ls_cod
integer	li_Result
str_seleccionar lstr_seleccionar
n_cst_upload_file	lnvo_Master

if lower(dwo.name) = 'b_upload' or lower(dwo.name) = 'b_view'  then
	ls_cod = string(dw_master.object.procedimiento_id[dw_master.getRow()])
end if


choose case lower(dwo.name)
	case 'b_upload'
		li_result = GetFileOpenName("Seleccione Archivo", &
						ls_docname, ls_named, "DOC", &
						"Documentos de Word 97-2003 (*.DOC),*.DOC")
	
		if li_result = 1 then
				
				if ls_cod = "" or IsNull(ls_cod) then
					MessageBox('Error', 'El codigo del Productor está en Blanco, '&
											+ 'asegurese de grabar los datos antes de asignar la foto')
					return
				end if

				lnvo_Master = create n_cst_upload_file
				lnvo_Master.of_grabar_foto( ls_docname, ls_cod, '',date('01/01/2012'),'2')
				destroy lnvo_Master
		end if
		this.retrieve()
	case 'b_view'
			lstr_seleccionar.s_column = ls_cod
			lstr_seleccionar.s_sql       = ''
			lstr_seleccionar.s_seleccion = '2'
			OpenWithParm(w_documento, lstr_seleccionar)
END CHOOSE
end event

