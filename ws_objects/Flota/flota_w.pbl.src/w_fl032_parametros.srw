$PBExportHeader$w_fl032_parametros.srw
forward
global type w_fl032_parametros from w_abc
end type
type dw_master from u_dw_abc within w_fl032_parametros
end type
end forward

global type w_fl032_parametros from w_abc
integer width = 2039
integer height = 596
string title = "Parametros Flota (FL032)"
string menuname = "m_mto_smpl"
boolean maxbox = false
boolean resizable = false
boolean center = true
dw_master dw_master
end type
global w_fl032_parametros w_fl032_parametros

on w_fl032_parametros.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fl032_parametros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_query_retrieve;// Ancestor Script has been Override
idw_1.Retrieve(gs_origen)
idw_1.ii_protect = 0
idw_1.of_protect()         			// bloquear modificaciones 
if idw_1.RowCount() = 0 then 
	idw_1.event ue_insert()
end if

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente

this.event ue_query_retrieve()


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF
end event

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1.RowCount() > 0 then
	MessageBox('Aviso', 'Ya existen un registro, no puede ingresar mas parametros ',StopSign!)
	return
end if
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

type dw_master from u_dw_abc within w_fl032_parametros
event ue_display ( string as_columna,  long al_row )
integer y = 8
integer width = 2002
integer height = 340
string dataobject = "d_param_flota_ff"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

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
		
end choose

end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event ue_insert_pre;call super::ue_insert_pre;this.object.origen[al_row] = gs_origen
end event

event itemerror;call super::itemerror;return 1
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data
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
			Messagebox('FLOTa', "CONCEPTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.concepto			[row] = ls_codigo
			this.object.desc_concepto	[row] = ls_codigo
			return 1
		end if

		this.object.desc_concepto[row] = ls_data
		
end choose
end event

