$PBExportHeader$w_cm007_articulo_clase.srw
forward
global type w_cm007_articulo_clase from w_abc_master_smpl
end type
end forward

global type w_cm007_articulo_clase from w_abc_master_smpl
integer width = 2642
integer height = 1764
string title = "Clases [CM007]"
string menuname = "m_mtto_smpl"
boolean maxbox = false
end type
global w_cm007_articulo_clase w_cm007_articulo_clase

on w_cm007_articulo_clase.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_cm007_articulo_clase.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
end event

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.cod_clase.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_clase.Protect = 1
END IF 
end event

event ue_open_pre;call super::ue_open_pre;//f_centrar( this )		// Centrando pantallas
ii_pregunta_delete = 1

end event

type ole_skin from w_abc_master_smpl`ole_skin within w_cm007_articulo_clase
end type

type st_filter from w_abc_master_smpl`st_filter within w_cm007_articulo_clase
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_cm007_articulo_clase
end type

type st_box from w_abc_master_smpl`st_box within w_cm007_articulo_clase
end type

type uo_h from w_abc_master_smpl`uo_h within w_cm007_articulo_clase
end type

type dw_master from w_abc_master_smpl`dw_master within w_cm007_articulo_clase
integer x = 503
integer y = 276
integer width = 1783
integer height = 804
string dataobject = "d_abc_articulo_clase_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_clase.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this )
end event

