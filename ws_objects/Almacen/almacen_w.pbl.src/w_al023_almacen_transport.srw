$PBExportHeader$w_al023_almacen_transport.srw
forward
global type w_al023_almacen_transport from w_abc_mastdet_smpl
end type
end forward

global type w_al023_almacen_transport from w_abc_mastdet_smpl
integer width = 1979
integer height = 1756
string title = "Transportistas Permitidos por Almacen (AL023)"
string menuname = "m_mantenimiento_sl"
end type
global w_al023_almacen_transport w_al023_almacen_transport

on w_al023_almacen_transport.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_al023_almacen_transport.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar( this )


end event

event ue_insert();// Override
// Fuerza a que no adicione en dw_master


Long  ll_row

if idw_1 = dw_master then return
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_dw_share();call super::ue_dw_share;dwobject dwo

dw_master.event clicked(0,0,dw_master.getrow(),dwo)
end event

event ue_update_pre;call super::ue_update_pre;dw_detail.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_al023_almacen_transport
integer x = 0
integer y = 0
integer width = 1806
integer height = 628
string dataobject = "d_list_almacen_transito_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_al023_almacen_transport
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer y = 644
integer width = 1801
integer height = 860
string dataobject = "d_abc_almacen_transport_tbl"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "proveedor"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;f_select_current_row( this)
end event

event dw_detail::itemchanged;call super::itemchanged;string ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "proveedor"
		select nom_proveedor
			into :ls_data
		from proveedor
		where proveedor = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Proveedor no existe o no está activa", StopSign!)
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			return 1
		end if

		this.object.nom_proveedor	[row] = ls_data

end choose
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_detail::keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event dw_detail::itemerror;call super::itemerror;return 1
end event

