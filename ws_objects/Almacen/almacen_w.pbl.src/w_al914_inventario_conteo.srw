$PBExportHeader$w_al914_inventario_conteo.srw
forward
global type w_al914_inventario_conteo from w_abc_master_smpl
end type
end forward

global type w_al914_inventario_conteo from w_abc_master_smpl
end type
global w_al914_inventario_conteo w_al914_inventario_conteo

on w_al914_inventario_conteo.create
call super::create
end on

on w_al914_inventario_conteo.destroy
call super::destroy
end on

type dw_master from w_abc_master_smpl`dw_master within w_al914_inventario_conteo
string dataobject = "d_prueba"
end type

