$PBExportHeader$w_fl006_bancos.srw
forward
global type w_fl006_bancos from w_abc_master_smpl
end type
end forward

global type w_fl006_bancos from w_abc_master_smpl
integer width = 1897
integer height = 1100
string title = "Bancos para Detraccion (FL006)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl006_bancos w_fl006_bancos

forward prototypes
public function string of_get_cod_banco ()
end prototypes

public function string of_get_cod_banco ();long 		ll_row, ll_number, ll_temp
string 	ls_codigo, ls_temp

ll_number = 0

for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.codigo_banco[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long( mid(ls_temp,3) )
		if ll_temp > ll_number then
			ll_number = ll_temp
		end if
	end if
next

ll_number ++
ls_codigo = gs_origen + string(ll_number,'00000000')

return ls_codigo
end function

on w_fl006_bancos.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl006_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()


end event

type dw_master from w_abc_master_smpl`dw_master within w_fl006_bancos
integer width = 1829
integer height = 824
string dataobject = "d_bancos_grid"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_codigo

ls_codigo = of_get_cod_banco()

this.object.codigo_banco	[al_row] = ls_codigo
this.object.flag_estado		[al_row] = '1'


end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
long		ll_find

this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "nombre_banco"
		
		ls_codigo = this.object.nombre_banco[row]
		ll_find = this.find("nombre_banco = '" + ls_codigo &
			+ "'", 1, this.RowCount() )
			
		if ll_find > 0 and ll_find <> row then
			MessageBox('Aviso', 'Nombre del Banco ya existe', StopSign!)
			SetNull(ls_codigo)
			this.object.nombre_banco[row] = ls_codigo
			return 1
		end if
		
end choose

end event

