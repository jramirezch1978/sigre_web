$PBExportHeader$w_abc_mastdet_smpl.srw
$PBExportComments$Mantenimiento maestro detalle ambos en  formato tbl
forward
global type w_abc_mastdet_smpl from w_abc_mastdet
end type
end forward

global type w_abc_mastdet_smpl from w_abc_mastdet
integer width = 3771
integer height = 1840
end type
global w_abc_mastdet_smpl w_abc_mastdet_smpl

type variables
Integer ii_lec_mst = 1
end variables

on w_abc_mastdet_smpl.create
int iCurrent
call super::create
end on

on w_abc_mastdet_smpl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;idw_query = dw_master


//ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master
end event

event ue_dw_share();call super::ue_dw_share;IF ii_lec_mst = 1 THEN dw_master.Retrieve()

end event

type p_pie from w_abc_mastdet`p_pie within w_abc_mastdet_smpl
end type

type ole_skin from w_abc_mastdet`ole_skin within w_abc_mastdet_smpl
integer x = 2272
integer y = 1376
end type

type uo_h from w_abc_mastdet`uo_h within w_abc_mastdet_smpl
end type

type st_box from w_abc_mastdet`st_box within w_abc_mastdet_smpl
end type

type phl_logonps from w_abc_mastdet`phl_logonps within w_abc_mastdet_smpl
end type

type p_mundi from w_abc_mastdet`p_mundi within w_abc_mastdet_smpl
end type

type p_logo from w_abc_mastdet`p_logo within w_abc_mastdet_smpl
end type

type st_horizontal from w_abc_mastdet`st_horizontal within w_abc_mastdet_smpl
integer x = 512
integer y = 988
end type

type st_filter from w_abc_mastdet`st_filter within w_abc_mastdet_smpl
end type

type uo_filter from w_abc_mastdet`uo_filter within w_abc_mastdet_smpl
end type

type dw_master from w_abc_mastdet`dw_master within w_abc_mastdet_smpl
integer width = 1920
integer height = 696
end type

event dw_master::constructor;call super::constructor; is_dwform = 'tabular' // tabular form

end event

type dw_detail from w_abc_mastdet`dw_detail within w_abc_mastdet_smpl
integer y = 1020
integer width = 1906
integer height = 336
end type

