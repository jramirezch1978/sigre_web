$PBExportHeader$w_al020_logparam.srw
forward
global type w_al020_logparam from w_abc_master
end type
end forward

global type w_al020_logparam from w_abc_master
integer width = 3227
integer height = 1864
string title = "[AL020] Parámetros de Logística"
string menuname = "m_save_exit"
end type
global w_al020_logparam w_al020_logparam

on w_al020_logparam.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
end on

on w_al020_logparam.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

idw_1.Retrieve()

uo_filter.of_set_dw( dw_master )
uo_filter.of_retrieve_fields( )
	
uo_h.of_set_title( this.title + ". Nro de Registros: " + string(dw_master.RowCount()))
end event

type p_pie from w_abc_master`p_pie within w_al020_logparam
end type

type ole_skin from w_abc_master`ole_skin within w_al020_logparam
end type

type uo_h from w_abc_master`uo_h within w_al020_logparam
end type

type st_box from w_abc_master`st_box within w_al020_logparam
end type

type phl_logonps from w_abc_master`phl_logonps within w_al020_logparam
end type

type p_mundi from w_abc_master`p_mundi within w_al020_logparam
end type

type p_logo from w_abc_master`p_logo within w_al020_logparam
end type

type st_filter from w_abc_master`st_filter within w_al020_logparam
end type

type uo_filter from w_abc_master`uo_filter within w_al020_logparam
end type

type dw_master from w_abc_master`dw_master within w_al020_logparam
integer width = 3141
integer height = 1640
string dataobject = "d_logparam"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
end event

