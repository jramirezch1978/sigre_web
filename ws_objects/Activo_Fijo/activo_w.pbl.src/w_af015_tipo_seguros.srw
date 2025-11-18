$PBExportHeader$w_af015_tipo_seguros.srw
forward
global type w_af015_tipo_seguros from w_abc_master_smpl
end type
end forward

global type w_af015_tipo_seguros from w_abc_master_smpl
integer width = 2208
integer height = 900
string title = "(AF015) Tipos de Seguros"
string menuname = "m_master_simple"
long backcolor = 67108864
end type
global w_af015_tipo_seguros w_af015_tipo_seguros

type variables

end variables

on w_af015_tipo_seguros.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_af015_tipo_seguros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;string ls_protect

ls_protect=dw_master.Describe("seguro_tipo.protect")

IF ls_protect='0' THEN
   dw_master.of_column_protect('seguro_tipo')
END IF

end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250

This.move(ll_x,ll_y)

end event

event ue_update_pre;
// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE

end event

event open;call super::open;ib_log = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_af015_tipo_seguros
integer x = 18
integer y = 32
integer width = 2135
integer height = 668
string dataobject = "dw_tipo_seguro_tbl"
boolean resizable = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("seguro_tipo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::itemchanged;call super::itemchanged;String ls_data, ls_null, ls_expresion
Long	 ll_found

SetNull(ls_null)

This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		
	CASE 'seguro_tipo'
		
		ls_expresion = "seguro_tipo = '" + data + "'"
		
		IF This.rowcount( ) > 1 THEN
			ll_found = This.Find(ls_expresion, 1, This.RowCount() - 1)	 
		END IF
		
		IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
			This.object.seguro_tipo[row] = ls_null
   		RETURN 1
		END IF

END CHOOSE

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

