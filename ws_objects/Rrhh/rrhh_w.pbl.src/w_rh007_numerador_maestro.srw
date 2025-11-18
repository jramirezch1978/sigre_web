$PBExportHeader$w_rh007_numerador_maestro.srw
forward
global type w_rh007_numerador_maestro from w_abc_master_smpl
end type
end forward

global type w_rh007_numerador_maestro from w_abc_master_smpl
integer width = 1856
integer height = 728
string title = "(RH007) Numerador de Código de Trabajador"
string menuname = "m_modifica_graba"
end type
global w_rh007_numerador_maestro w_rh007_numerador_maestro

on w_rh007_numerador_maestro.create
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
end on

on w_rh007_numerador_maestro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

ii_lec_mst = 0

long ll_num_act
string ls_origen

ls_origen = trim(gs_origen)

if dw_master.retrieve(ls_origen) <> 1 then
	dw_master.reset( )
	
   select nvl(max(m.cod_trabajador), 0)
		into :ll_num_act 
		from maestro m 
		where trim(m.cod_origen) = trim(:gs_origen);

	insert into num_maestro (origen, ult_nro) 
   values (:ls_origen, :ll_num_act);
	
	if sqlca.sqlcode = -1 then 
		messagebox(this.title, 'No existe numerador, ni se puede insertar')
		rollback using sqlca;
		return
	end if
	
	commit using sqlca;
	
	if sqlca.sqlcode = -1 then 
		messagebox(this.title, 'No existe numerador, ni se puede insertar')
		return
	end if
	
	dw_master.retrieve(gs_origen)
end if
end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh007_numerador_maestro
integer x = 64
integer y = 64
integer width = 1687
integer height = 428
string dataobject = "d_numerador_maestro_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_dwform =  'form'
ii_ck[1] = 1
end event

