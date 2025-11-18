$PBExportHeader$w_pr036_ot_usuario_prod.srw
forward
global type w_pr036_ot_usuario_prod from w_abc_mastdet_smpl
end type
end forward

global type w_pr036_ot_usuario_prod from w_abc_mastdet_smpl
integer width = 2949
integer height = 1860
string title = "[PR036] OT_ADM por usuario - Producción"
string menuname = "m_master_sin_lista"
end type
global w_pr036_ot_usuario_prod w_pr036_ot_usuario_prod

on w_pr036_ot_usuario_prod.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_pr036_ot_usuario_prod.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)
//ii_help = 101           					// help topic

idw_1 = dw_detail

dw_detail.setfocus( )
end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect = dw_master.Describe("ot_adm.protect")
If ls_protect = '0' Then
   dw_master.object.ot_adm.protect = 1
End if	

ls_protect = dw_detail.Describe("cod_usr.protect")
If ls_protect = '0' Then
   dw_detail.object.cod_usr.protect = 1
End if	
end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION DE usuario
if f_row_Processing( dw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

dw_detail.of_set_flag_replicacion()
end event

event ue_insert;//Override

Long  ll_row

//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF

if idw_1 = dw_master then return

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr036_ot_usuario_prod
integer x = 0
integer y = 8
integer width = 2871
integer height = 796
string dataobject = "d_abc_ot_administracion_tbl"
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle
idw_mst  = dw_master

end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event dw_master::clicked;//Override
IF row = 0 OR is_dwform = 'form' THEN RETURN

il_row = row              // fila corriente

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	THIS.Event ue_output(row)
	RETURN
END IF


string	  ls_KeyDownType	 //  solo para seleccion multiple

If Keydown(KeyShift!) then  // seleccionar multiples filas usando la tecla shift
	of_Set_Shift_row(row)	
Else
	If this.IsSelected(row) Then
		il_LastRow = row
		ib_action_on_buttonup = true
	Else
		If Keydown(KeyControl!) then  // mantiene las otras filas seleccionadas y selecciona
			il_LastRow = row				// o deselecciona a clicada
			this.SelectRow(row,TRUE)
		Else
			il_LastRow = row
			this.SelectRow(0,FALSE)
			this.SelectRow(row,TRUE)
		End If
	END IF
END IF
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr036_ot_usuario_prod
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 816
integer width = 2871
integer height = 768
string dataobject = "d_abc_ot_administracion_usuario_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_almacen, ls_null

this.AcceptText()
SetNull(ls_null)

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT COD_USR AS CODIGO_usuario,"&
				 + "NOMBRE  AS NOMBRE_usuario "&
				 + "FROM USUARIO 	  "&	
				 + "WHERE USUARIO.FLAG_ESTADO = '1'" 

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_usr	[al_row] = ls_codigo
			this.object.nombre	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	
	
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 		      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_null, ls_mensaje, ls_desc

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
	
	CASE 'cod_usr'

		SELECT nombre
			INTO :ls_desc
		FROM usuario
		WHERE cod_usr = :data   
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
			if SQLCA.SQLCode = 100 then
				Messagebox('Aviso','Codigo de usuario no existe ' &
					+ 'no esta activo, por favor verifique')
			else
				MessageBox('Aviso', SQLCA.SQLErrText)
			end if
			this.Object.cod_usr	[row] = ls_null
			this.object.nombre	[row] = ls_null
			this.setcolumn( "cod_usr" )
		 	this.setfocus( )
			RETURN 1
		END IF
		
		this.object.nombre 		[row] = ls_desc
		
END CHOOSE

end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)

This.SelectRow(currentrow, TRUE)
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

