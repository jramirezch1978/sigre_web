$PBExportHeader$w_pr045_tuneles_frio.srw
forward
global type w_pr045_tuneles_frio from w_abc_master_smpl
end type
end forward

global type w_pr045_tuneles_frio from w_abc_master_smpl
integer width = 3383
integer height = 2172
string title = "[PR045] Tuneles de Frio"
string menuname = "m_mantto_smpl"
end type
global w_pr045_tuneles_frio w_pr045_tuneles_frio

on w_pr045_tuneles_frio.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr045_tuneles_frio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr045_tuneles_frio
integer width = 3269
integer height = 1860
string dataobject = "d_abc_tuneles_frio_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "lugar_empaque"

		ls_sql = "select lugar_empaque as lugar_empaque," &
				 + "desc_sala as desc_lugar_empaque " &
				 + "from tg_lugar_empaque te " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.lugar_empaque	[al_row] = ls_codigo
			this.object.desc_sala		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose



end event

