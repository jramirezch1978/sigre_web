$PBExportHeader$w_abc_master_lstmst_sin_rtrv.srw
$PBExportComments$abc para tablas simples que requieren ubicarse con una tabla mayor, formato tabular
forward
global type w_abc_master_lstmst_sin_rtrv from w_abc_master_lstmst
end type
end forward

global type w_abc_master_lstmst_sin_rtrv from w_abc_master_lstmst
end type
global w_abc_master_lstmst_sin_rtrv w_abc_master_lstmst_sin_rtrv

event ue_dw_share();call super::ue_dw_share;Integer	li_rc

li_rc = dw_lista.ShareData (dw_master)
end event

event ue_open_pre();call super::ue_open_pre;ii_share = 0
ii_lec_mst = 0
end event

on w_abc_master_lstmst_sin_rtrv.create
call super::create
end on

on w_abc_master_lstmst_sin_rtrv.destroy
call super::destroy
end on

type dw_master from w_abc_master_lstmst`dw_master within w_abc_master_lstmst_sin_rtrv
end type

type dw_lista from w_abc_master_lstmst`dw_lista within w_abc_master_lstmst_sin_rtrv
end type

