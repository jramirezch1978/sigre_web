$PBExportHeader$w_fl041_derecho_pesca.srw
forward
global type w_fl041_derecho_pesca from w_abc
end type
type em_ano from editmask within w_fl041_derecho_pesca
end type
type st_1 from statictext within w_fl041_derecho_pesca
end type
type cb_consultar from commandbutton within w_fl041_derecho_pesca
end type
type dw_master from u_dw_abc within w_fl041_derecho_pesca
end type
end forward

global type w_fl041_derecho_pesca from w_abc
integer width = 2267
integer height = 1356
string title = "Tasas de Derecho de Pesca (FL041)"
string menuname = "m_mto_smpl"
event ue_consultar ( )
em_ano em_ano
st_1 st_1
cb_consultar cb_consultar
dw_master dw_master
end type
global w_fl041_derecho_pesca w_fl041_derecho_pesca

type variables
string	is_soles
end variables

event ue_consultar();integer li_ano

li_ano = integer( em_ano.text )

dw_master.retrieve( li_ano )
dw_master.ii_protect = 0
dw_master.of_protect()
end event

on w_fl041_derecho_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.em_ano=create em_ano
this.st_1=create st_1
this.cb_consultar=create cb_consultar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_consultar
this.Control[iCurrent+4]=this.dw_master
end on

on w_fl041_derecho_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.cb_consultar)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_update;call super::ue_update;Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
END IF

end event

event ue_insert;call super::ue_insert;long ll_row

ll_row = dw_master.Event ue_insert()




end event

event ue_open_pre;call super::ue_open_pre;em_ano.text = string(f_fecha_actual(), 'yyyy')
idw_1 = dw_master
dw_master.SetTransObject(SQLCA)
dw_master.of_protect()

select cod_soles
	into :is_soles
from logparam
where reckey = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam (parametros de logistica)', Exclamation!)
	return
end if

if SQLCA.SQLCode < 0 then
	MessageBox('Aviso', SQLCA.SQLErrText, Exclamation!)
	return
end if

if is_soles = '' or IsNull(is_soles) then
	MessageBox('Aviso', 'No ha definido la moneda soles en parámetros de logistica', StopSign!)
	return
end if

this.event dynamic ue_consultar()

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type em_ano from editmask within w_fl041_derecho_pesca
integer x = 645
integer y = 56
integer width = 297
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

type st_1 from statictext within w_fl041_derecho_pesca
integer x = 485
integer y = 68
integer width = 160
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type cb_consultar from commandbutton within w_fl041_derecho_pesca
integer x = 969
integer y = 56
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Consultar"
end type

event clicked;parent.event dynamic ue_consultar()
end event

type dw_master from u_dw_abc within w_fl041_derecho_pesca
event ue_display ( string as_columna,  long al_row )
integer y = 188
integer width = 2094
integer height = 920
integer taborder = 30
string dataobject = "d_abc_tasa_derecho_pesca_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_moneda"
		ls_sql = "SELECT cod_moneda AS CODIGO_moneda, " &
				 + "descripcion AS DESCRIPCION_moneda " &
             + "FROM moneda " &
				 + "where flag_estado = '1'"					 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_moneda			[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
		return
end choose
end event

event constructor;call super::constructor;ii_ck[1] = 1		
is_dwform = 'tabular'
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_moneda"
		
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Moneda no existe o no está activo", StopSign!)
			this.object.cod_moneda	[row] = ls_null
			return 1
		end if

end choose
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
	 	this.event ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.ano			[al_row] = Integer(em_ano.text)
this.object.tasa_pago	[al_row] = 0
end event

event itemerror;call super::itemerror;return 1
end event

