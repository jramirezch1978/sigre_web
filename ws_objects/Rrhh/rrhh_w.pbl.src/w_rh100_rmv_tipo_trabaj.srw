$PBExportHeader$w_rh100_rmv_tipo_trabaj.srw
$PBExportComments$abc Maestro detalle con pop window para la busqueda del maestro, ff para el Maestro, tbl para el detalle
forward
global type w_rh100_rmv_tipo_trabaj from w_abc_master_smpl
end type
end forward

global type w_rh100_rmv_tipo_trabaj from w_abc_master_smpl
integer width = 2528
integer height = 1716
string title = "Remuneración Mínima x Tipo de Trabjador (RH100)"
string menuname = "m_master_simple"
end type
global w_rh100_rmv_tipo_trabaj w_rh100_rmv_tipo_trabaj

on w_rh100_rmv_tipo_trabaj.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh100_rmv_tipo_trabaj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh100_rmv_tipo_trabaj
event ue_display ( string as_columna,  long al_row )
integer width = 2459
integer height = 1504
string dataobject = "d_abc_rmv_x_tipo_trabaj_grd"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "tipo_trabajador"
		ls_sql = "select tipo_trabajador as tipo_trabajador, " &
				 + "desc_tipo_tra as descripcion_tipo_trabajador " &
				 + "from tipo_trabajador " &
				 + "where flag_estado = '1'" 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_trabajador		[al_row] = ls_codigo
			this.object.desc_tipo_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemchanged;call super::itemchanged;string ls_data, ls_null
SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "tipo_trabajador"
		
		select desc_tipo_tra
			into :ls_data
		from tipo_trabajador
		where tipo_trabajador = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			Messagebox('RRHH', "TIPO DE TRABAJADOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.tipo_trabajador		[row] = ls_null
			this.object.desc_tipo_trabajador	[row] = ls_null
			return 1
		end if

		this.object.desc_tipo_trabajador	[row] = ls_data

end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.rmv[al_row] = 0.00
end event

