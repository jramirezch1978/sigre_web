$PBExportHeader$w_abc_master_smpl.srw
$PBExportComments$abc para tablas simples y pequeñas, formato tabular
forward
global type w_abc_master_smpl from w_abc_master
end type
end forward

global type w_abc_master_smpl from w_abc_master
integer width = 2203
integer height = 1672
end type
global w_abc_master_smpl w_abc_master_smpl

type variables
Integer ii_sort_mst, ii_lec_mst = 1
end variables

on w_abc_master_smpl.create
int iCurrent
call super::create
end on

on w_abc_master_smpl.destroy
call super::destroy
end on

event ue_open_pre();call super::ue_open_pre;idw_query = dw_master


//ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_dw_share;call super::ue_dw_share;IF ii_lec_mst = 1 THEN 
	dw_master.Retrieve()
	uo_filter.of_set_dw( dw_master )
	uo_filter.of_retrieve_fields( )
	uo_h.of_set_title( this.title + ". ~t Nro de Registros: " + string(dw_master.RowCount()))
end if

end event

type ole_skin from w_abc_master`ole_skin within w_abc_master_smpl
end type

type uo_h from w_abc_master`uo_h within w_abc_master_smpl
end type

type st_box from w_abc_master`st_box within w_abc_master_smpl
end type

type st_filter from w_abc_master`st_filter within w_abc_master_smpl
end type

type uo_filter from w_abc_master`uo_filter within w_abc_master_smpl
end type

type dw_master from w_abc_master`dw_master within w_abc_master_smpl
integer width = 2139
integer height = 780
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;is_dwform =  'tabular'   // tabular,grid,form
end event

