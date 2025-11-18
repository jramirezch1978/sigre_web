$PBExportHeader$w_fl024_empresa_general.srw
forward
global type w_fl024_empresa_general from w_abc_master_smpl
end type
end forward

global type w_fl024_empresa_general from w_abc_master_smpl
integer width = 3662
integer height = 1380
string title = "Empresas Pesquera del Litoral Peruano (FL024)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl024_empresa_general w_fl024_empresa_general

forward prototypes
public function string of_cod_empresa ()
end prototypes

public function string of_cod_empresa ();long 		ll_row, ll_number, ll_temp
string 	ls_codigo, ls_temp

ll_number = 0

for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.empresa[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long( mid(ls_temp,3) )
		if ll_temp > ll_number then
			ll_number = ll_temp
		end if
	end if
next

ll_number ++
ls_codigo = gs_origen + string(ll_number,'000000')

return ls_codigo
end function

on w_fl024_empresa_general.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl024_empresa_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl024_empresa_general
integer x = 0
integer width = 3611
integer height = 1096
string dataobject = "d_empresa_general_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_master

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string 	ls_cod_empresa

ls_cod_empresa = of_cod_empresa()

this.object.empresa[al_row] = ls_cod_empresa

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

