$PBExportHeader$w_abc_mastdet_lstmst_sin_share.srw
$PBExportComments$abc para tablas simples que requieren ubicarse con una tabla mayor, formato tabular
forward
global type w_abc_mastdet_lstmst_sin_share from w_abc_mastdet_lstmst
end type
end forward

global type w_abc_mastdet_lstmst_sin_share from w_abc_mastdet_lstmst
end type
global w_abc_mastdet_lstmst_sin_share w_abc_mastdet_lstmst_sin_share

event ue_dw_share();call super::ue_dw_share;dw_lista.Retrieve()

//dw_lista.of_sort_lista()
end event

event ue_open_pre();call super::ue_open_pre;ii_share = 0      //deshabilita el share entre el master y la lista
ii_lec_mst = 0    //deshabilita la lectura inicial del dw_master
end event

on w_abc_mastdet_lstmst_sin_share.create
call super::create
end on

on w_abc_mastdet_lstmst_sin_share.destroy
call super::destroy
end on

type dw_master from w_abc_mastdet_lstmst`dw_master within w_abc_mastdet_lstmst_sin_share
end type

type dw_detail from w_abc_mastdet_lstmst`dw_detail within w_abc_mastdet_lstmst_sin_share
end type

type dw_lista from w_abc_mastdet_lstmst`dw_lista within w_abc_mastdet_lstmst_sin_share
end type

