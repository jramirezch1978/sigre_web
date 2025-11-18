$PBExportHeader$w_pt011_cencos_cnta_prsp.srw
forward
global type w_pt011_cencos_cnta_prsp from w_abc_master_smpl
end type
end forward

global type w_pt011_cencos_cnta_prsp from w_abc_master_smpl
integer height = 1064
string title = "Cencos - Cuenta Presupuestal (PT011)"
string menuname = "m_mantenimiento_sl"
end type
global w_pt011_cencos_cnta_prsp w_pt011_cencos_cnta_prsp

on w_pt011_cencos_cnta_prsp.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_pt011_cencos_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then	
	return
end if	
ib_update_check = true

end event

type dw_master from w_abc_master_smpl`dw_master within w_pt011_cencos_cnta_prsp
event ue_display ( string as_columna,  long al_row )
string dataobject = "d_abc_cencos_cnta_prsp_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos

this.AcceptText()


choose case lower(as_columna)
		
	case "cencos"
		ls_sql = "SELECT DISTINCT cc.cencos AS CODIGO_cencos, " &
				  + "cc.desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo cc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cencos = cc.cencos " &
				  + "and pp.flag_estado <> '0' " &
  				  + "order by cc.cencos " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "cnta_prsp"
		ls_cencos = this.object.cencos[al_row]
		
		if IsNull(ls_Cencos) or ls_cencos = '' then
			MessageBox('Aviso', 'Debe indicar primero el centro de costo ')
			this.SetColumn('cencos')
			return
		end if
		
		ls_sql = "SELECT DISTINCT pc.cnta_prsp AS CODIGO_cnta_prsp, " &
				  + "pc.descripcion AS descripcion_cnta_prsp " &
				  + "FROM presupuesto_cuenta pc, " &
				  + "presupuesto_partida pp " &
				  + "where pp.cnta_prsp = pc.cnta_prsp " &
				  + "and pp.cencos = '" + ls_Cencos + "' " &
				  + "and pp.flag_estado <> '0' " &
  				  + "order by pc.cnta_prsp " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_null

SetNull(ls_null)
this.AcceptText()


choose case lower(dwo.name)
		
	case "cencos"
		SELECT desc_cencos 
			into :ls_data
		FROM centros_costo cc
 		where cencos = :data;
	 	
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Centro de Costo no existe')
			this.object.cencos 		[row] = ls_null
			this.object.desc_cencos [row] = ls_null
			return
			
		end if
		 
	 	this.object.desc_cencos	[row] = ls_data

		
	case "cnta_prsp"
		
		SELECT descripcion 
			into :ls_data
		FROM presupuesto_cuenta
 		where cnta_prsp = :data;
	 	
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'Cuenta presupuestal no existe')
			this.object.cnta_prsp 		[row] = ls_null
			this.object.desc_cnta_prsp [row] = ls_null
			return
			
		end if
		 
	 	this.object.desc_cnta_prsp	[row] = ls_data
		
end choose
end event

