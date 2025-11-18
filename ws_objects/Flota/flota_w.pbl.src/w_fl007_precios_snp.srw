$PBExportHeader$w_fl007_precios_snp.srw
forward
global type w_fl007_precios_snp from w_abc
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl007_precios_snp
end type
type cb_consultar from commandbutton within w_fl007_precios_snp
end type
type dw_master from u_dw_abc within w_fl007_precios_snp
end type
end forward

global type w_fl007_precios_snp from w_abc
integer width = 2158
integer height = 1340
string title = "[FL007] Precios de Pesca"
string menuname = "m_mto_smpl"
event ue_consultar ( )
uo_fecha uo_fecha
cb_consultar cb_consultar
dw_master dw_master
end type
global w_fl007_precios_snp w_fl007_precios_snp

type variables
string	is_soles
end variables

event ue_consultar();integer li_ano
date ld_fecha_inicio, ld_fecha_fin

ld_fecha_inicio = uo_fecha.of_get_fecha1()
ld_fecha_fin = uo_fecha.of_get_fecha2()

dw_master.retrieve( ld_fecha_inicio, ld_fecha_fin )
dw_master.ii_protect = 0
dw_master.of_protect()
end event

on w_fl007_precios_snp.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.uo_fecha=create uo_fecha
this.cb_consultar=create cb_consultar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_consultar
this.Control[iCurrent+3]=this.dw_master
end on

on w_fl007_precios_snp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
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

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )

dw_master.SetTransObject(SQLCA)
dw_master.of_protect()
idw_1 = dw_master

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

type uo_fecha from u_ingreso_rango_fechas within w_fl007_precios_snp
integer x = 238
integer y = 40
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

RETURN 0
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_consultar from commandbutton within w_fl007_precios_snp
integer x = 1655
integer y = 36
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

type dw_master from u_dw_abc within w_fl007_precios_snp
event ue_display ( string as_columna,  long al_row )
integer y = 188
integer width = 2094
integer height = 920
integer taborder = 30
string dataobject = "d_precio_snp_grid"
end type

event ue_display(string as_columna, long al_row);string ls_sql, ls_codigo, ls_data
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "ESPECIE"
		
		ls_sql = "SELECT ESPECIE AS CODIGO, " &
				 + "DESCR_ESPECIE AS DESCRIPCION " &
             + "FROM TG_ESPECIES " 
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE TRABAJADOR", StopSign!)
			return 
		end if

		this.object.especie			[al_row] 	= ls_codigo		
		this.object.descr_especie	[al_row] 	= ls_data
end choose

end event

event constructor;call super::constructor;ii_ck[1] = 1		
is_dwform = 'tabular'
end event

event itemchanged;call super::itemchanged;string ls_desc_especie, ls_cod_especie
long ll_row

choose case upper(dwo.name)
	case "ESPECIE"
		
		this.AcceptText()
		
		ll_row = this.GetRow()
		ls_cod_especie = this.object.especie[ll_row]

		SetNull(ls_desc_especie)
		
		select descr_especie
			into :ls_desc_especie
		from tg_especies
		where especie = :ls_cod_especie;
		
		if IsNull(ls_desc_especie) or ls_desc_especie = "" then
			return
		end  if
		
		this.object.descr_especie[ll_row] = ls_desc_especie
		
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

event ue_insert_pre;call super::ue_insert_pre;date ld_fecha
decimal ln_precio

ld_fecha = Today()

if al_row > 1 then
	ld_fecha = date(this.object.fecha[al_row - 1])
	ln_precio = this.object.precio_snp[al_row - 1]

	this.object.fecha			[al_row] = RelativeDate(ld_fecha,1)
	this.object.precio_snp	[al_row] = ln_precio
	this.object.cod_moneda	[al_row] = is_soles
else
	this.object.fecha			[al_row] = ld_fecha
	this.object.cod_moneda	[al_row] = is_soles
end if
end event

