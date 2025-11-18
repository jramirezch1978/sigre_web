$PBExportHeader$w_sr015_codrel_tipo.srw
forward
global type w_sr015_codrel_tipo from w_abc_master_smpl
end type
end forward

global type w_sr015_codrel_tipo from w_abc_master_smpl
integer width = 2633
integer height = 1216
string title = "[SR015] Tipos de Código de Relación"
string menuname = "m_mtto_smpl"
end type
global w_sr015_codrel_tipo w_sr015_codrel_tipo

on w_sr015_codrel_tipo.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sr015_codrel_tipo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pos;call super::ue_open_pos;dw_master.SetFocus()
idw_1 = dw_master
end event

event ue_update_pre;call super::ue_update_pre;long ll_row
string ls_cod

ib_update_check = true

dw_master.AcceptText()

// validacion maestro

if dw_master.rowcount() = 0 then 
   ib_update_check = false
   return
end if

for ll_row = 1 to dw_master.rowcount()
	 ls_cod = dw_master.object.tipo_codrel[ll_row]
	 if ls_cod = '' or isnull(ls_cod) then
		messagebox('Aviso', 'Debe de Ingresar un TIPO de CODIGO de RELACION valido')
		dw_master.SetFocus()
		dw_master.ScrolltoRow(ll_row)
		dw_master.SetColumn('tipo_codrel')
		ib_update_check = false
   		return
	end if
next
end event

event ue_modify;call super::ue_modify;dw_master.object.tipo_codrel.protect = 1
end event

type ole_skin from w_abc_master_smpl`ole_skin within w_sr015_codrel_tipo
end type

type st_filter from w_abc_master_smpl`st_filter within w_sr015_codrel_tipo
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sr015_codrel_tipo
end type

type st_box from w_abc_master_smpl`st_box within w_sr015_codrel_tipo
end type

type uo_h from w_abc_master_smpl`uo_h within w_sr015_codrel_tipo
end type

type dw_master from w_abc_master_smpl`dw_master within w_sr015_codrel_tipo
string dataobject = "d_abc_aux_codrel_tipo_grd"
string is_dwform = "Grid"
end type

event dw_master::constructor;call super::constructor;SetTransObject(sqlca)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Modify("tipo_codrel.protect='1~tif(isrownew(),0,1)'")
end event

