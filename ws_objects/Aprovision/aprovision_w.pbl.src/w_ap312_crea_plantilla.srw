$PBExportHeader$w_ap312_crea_plantilla.srw
forward
global type w_ap312_crea_plantilla from w_abc_mastdet_smpl
end type
end forward

global type w_ap312_crea_plantilla from w_abc_mastdet_smpl
integer width = 2875
end type
global w_ap312_crea_plantilla w_ap312_crea_plantilla

on w_ap312_crea_plantilla.create
call super::create
end on

on w_ap312_crea_plantilla.destroy
call super::destroy
end on

type dw_master from w_abc_mastdet_smpl`dw_master within w_ap312_crea_plantilla
integer width = 2811
integer height = 372
string dataobject = "d_ap_plant_presup_ff"
end type

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ap312_crea_plantilla
integer x = 0
integer y = 384
integer width = 2811
integer height = 500
string dataobject = "d_ap_plant_presup_tbl"
end type

