$PBExportHeader$w_fl031_bonificaciones.srw
forward
global type w_fl031_bonificaciones from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_fl031_bonificaciones
end type
type st_2 from statictext within w_fl031_bonificaciones
end type
end forward

global type w_fl031_bonificaciones from w_abc_mastdet_smpl
integer width = 1998
integer height = 1764
string title = "Bonificaciones Fijas Tripulantes (FL031)"
string menuname = "m_mto_smpl"
st_1 st_1
st_2 st_2
end type
global w_fl031_bonificaciones w_fl031_bonificaciones

on w_fl031_bonificaciones.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_fl031_bonificaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_dw_share;// Ancestor Script has been Override
IF ii_lec_mst = 1 THEN 
	dw_master.Retrieve()
	if dw_master.RowCount() > 0 then
		dw_master.event dynamic ue_ouput(1)
	end if
end if
end event

event resize;call super::resize;st_1.X 		= 0
st_1.width  = newwidth  - st_1.x - 10

st_2.X 		= 0
st_2.width  = newwidth  - st_2.x - 10

end event

event ue_insert;// Ancestor Script has been Override
Long  ll_row

this.event ue_update_request()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

if f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
end if

if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fl031_bonificaciones
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 116
integer width = 1815
integer height = 608
string dataobject = "d_bonificaciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "concepto"
		
		ls_sql = "SELECT CONCEP AS CODIGO, " &
				  + "DESC_CONCEP AS DESCRIPCION " &
				  + "FROM CONCEPTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.concepto			[al_row] = ls_codigo
			this.object.desc_concepto	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_prsp"

		ls_sql = "SELECT CNTA_PRSP AS CODIGO, " &
				  + "DESCRIPCION AS DESC_CUENTA " &
				  + "FROM PRESUPUESTO_CUENTA " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event dw_master::ue_output;if al_row > 0 then
	THIS.EVENT ue_retrieve_det(al_row)
end if
end event

event dw_master::ue_retrieve_det_pos;idw_det.SetRedraw(false)
idw_det.retrieve(aa_id[1])

if idw_det.Rowcount() > 0 then
	idw_det.SetRow(1)
	f_select_current_row(idw_det)
end if

this.SetFocus()
idw_det.SetRedraw(true)

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
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

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "concepto"
		
		ls_codigo = this.object.concepto[row]

		SetNull(ls_data)
		select desc_concep
			into :ls_data
		from concepto
		where concep = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('FLOTA', "CONCEPTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.concepto			[row] = ls_codigo
			this.object.desc_concepto	[row] = ls_codigo
			return 1
		end if

		this.object.desc_concepto[row] = ls_data

	case "cnta_prsp"
		
		ls_codigo = this.object.cnta_prsp[row]

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from presupuesto_cuenta
		where cnta_prsp = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('FLOTA', "CUENTA PRESUPUESTAL NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.cnta_prsp		[row] = ls_codigo
			this.object.desc_cnta_prsp	[row] = ls_codigo
			return 1
		end if

		this.object.desc_cnta_prsp		[row] = ls_data
		
end choose
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fl031_bonificaciones
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 856
integer width = 1815
integer height = 676
string dataobject = "d_bonificaciones_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tmp, ls_where
long		ll_row, ll_i
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "cargo"
		
		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				 + "DESCR_CARGO AS DESCRIPCION " &
				 + "FROM FL_CARGO_TRIPULANTES "
				 
		if this.RowCount() > 0 then
			ls_where = "WHERE "
			for ll_i = 1 to this.RowCount()
				ls_tmp = this.object.cargo[ll_i]
				if ls_tmp = '' or IsNull(ls_tmp) then continue
				ls_where = ls_where + " cargo_tripulante <> '" + ls_tmp + "'"
				
				ls_where = ls_where + " and "
			next
		end if
		
		ls_where = left( ls_where, len(ls_where) - 5 )
		
		ls_sql = ls_sql + ls_where
		
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')

		if ls_codigo <> '' then
			this.object.cargo			[al_row] = ls_codigo
			this.object.descr_cargo	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event dw_detail::itemerror;call super::itemerror;return 1
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
	if li_column <= 0 then
		return 0
	end if
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

event dw_detail::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
long		ll_found
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "cargo"
		
		ls_codigo = this.object.cargo[row]

		SetNull(ls_data)
		select descr_cargo
			into :ls_data
		from fl_cargo_tripulantes
		where cargo_tripulante = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('FLOTA', "CODIGO DE CARGO NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cargo			[row] = ls_codigo
			this.object.descr_cargo	[row] = ls_codigo
			return 1
		end if
		
		ll_found = this.Find( "cargo = '" + ls_codigo + "'", 1, this.RowCount() )
		
		if ll_found > 0 and ll_found <> row then
			Messagebox('FLOTA', "CODIGO DE CARGO YA HA SIDO INGRESADO", StopSign!)
			this.deleteRow(row)
			this.SetRow(ll_found)
			f_select_current_row(this)
			return 1

		end if

		this.object.descr_cargo[row] = ls_data
		
end choose
end event

type st_1 from statictext within w_fl031_bonificaciones
integer x = 224
integer y = 16
integer width = 1275
integer height = 64
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Bonificaciones"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl031_bonificaciones
integer x = 169
integer y = 748
integer width = 1275
integer height = 76
boolean bringtotop = true
integer textsize = -13
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Cargos segun Bonificación"
alignment alignment = center!
boolean focusrectangle = false
end type

