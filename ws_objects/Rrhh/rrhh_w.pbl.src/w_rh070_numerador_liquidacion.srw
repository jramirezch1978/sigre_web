$PBExportHeader$w_rh070_numerador_liquidacion.srw
forward
global type w_rh070_numerador_liquidacion from w_abc_master_smpl
end type
end forward

global type w_rh070_numerador_liquidacion from w_abc_master_smpl
integer width = 1979
integer height = 1140
string title = "(RH070) Numerador de Liquidaciones"
string menuname = "m_master_simple"
end type
global w_rh070_numerador_liquidacion w_rh070_numerador_liquidacion

on w_rh070_numerador_liquidacion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh070_numerador_liquidacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("origen.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('origen')
END IF
end event

event ue_open_pre();call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 250
This.move(ll_x,ll_y)

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;string  ls_origen
integer li_row, li_verifica

li_row = dw_master.GetRow()

if li_row > 0 then 
	ls_origen = trim(dw_master.GetItemString(li_row,"origen"))
	if len(ls_origen) = 0 or isnull(ls_origen) then
		dw_master.ii_update = 0
		MessageBox("Sistema de Validación","Ingrese código de origen")
		dw_master.SetColumn("origen")
		dw_master.SetFocus()
	else
		select count(*)
		  into :li_verifica
		  from origen
		  where cod_origen = :ls_origen ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			MessageBox("Sistema de Validación","Código de origen no existe")
			dw_master.SetColumn("origen")
			dw_master.SetFocus()
		end if	  
	end if	
end if	

dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh070_numerador_liquidacion
integer x = 46
integer y = 40
integer width = 1851
integer height = 880
string dataobject = "d_num_liq_credito_laboral_tbl"
boolean hscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemchanged;call super::itemchanged;string ls_origen, ls_descripcion

accepttext()
choose case dwo.name 
	case 'origen'
		ls_origen = dw_master.object.origen[row]	
		select nombre
		  into :ls_descripcion
		  from origen
		  where cod_origen = :ls_origen ;
		dw_master.object.nombre[row] = ls_descripcion
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("origen.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("ult_nro.Protect='1~tIf(IsRowNew(),0,1)'")
end event

