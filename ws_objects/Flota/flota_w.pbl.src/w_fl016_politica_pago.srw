$PBExportHeader$w_fl016_politica_pago.srw
forward
global type w_fl016_politica_pago from w_abc_mastdet_smpl
end type
end forward

global type w_fl016_politica_pago from w_abc_mastdet_smpl
integer width = 2290
integer height = 1932
string title = "Políticas de Pago Tripulantes (FL016)"
string menuname = "m_mto_smpl"
end type
global w_fl016_politica_pago w_fl016_politica_pago

on w_fl016_politica_pago.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl016_politica_pago.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;ib_update_check = true

if gnvo_app.of_row_processing( dw_master ) = false then
	ib_update_check = false
	return
end if

if gnvo_app.of_row_processing( dw_detail ) = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl016_politica_pago
integer x = 0
integer y = 0
integer width = 1979
integer height = 684
string dataobject = "d_tipo_politica_pago_grid"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
this.object.fecha_vigencia[al_row] = Today()

end event

event dw_master::constructor;call super::constructor;ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(1)

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF CurrentRow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl016_politica_pago
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 700
integer width = 1984
integer height = 832
string dataobject = "d_polit_pago_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cargo_tripulante"
		
		ls_sql = "SELECT cargo_tripulante AS codigo_cargo, " &
				  + "descr_cargo AS DESCRIPCION_cargo " &
				  + "FROM fl_cargo_tripulantes " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cargo_tripulante	[al_row] = ls_codigo
			this.object.descr_cargo			[al_row] = ls_data
			this.ii_update = 1
		end if

end choose

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;IF CurrentRow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::itemchanged;call super::itemchanged;string ls_desc
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cargo_tripulante"
		
		select DESCR_CARGO
			into :ls_desc
		from fl_cargo_tripulantes
		where cargo_tripulante = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Codigo de Tripulante es invalido, Verifique", StopSign!)
			SetNull(ls_desc)
			this.object.cargo_Tripulante	[row] = ls_desc
			this.object.descr_cargo			[row] = ls_desc
			return 1
		end if

		this.object.descr_cargo	[row] = ls_desc
		
end choose

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return

this.object.tipo_pol_pago[al_row] = dw_master.object.tipo_pol_pago[dw_master.GetRow()]
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

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

