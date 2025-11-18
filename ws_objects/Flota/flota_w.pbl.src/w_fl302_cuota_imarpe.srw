$PBExportHeader$w_fl302_cuota_imarpe.srw
forward
global type w_fl302_cuota_imarpe from w_abc
end type
type pb_retrieve from picturebutton within w_fl302_cuota_imarpe
end type
type pb_procesar from picturebutton within w_fl302_cuota_imarpe
end type
type pb_update from u_pb_update within w_fl302_cuota_imarpe
end type
type pb_modify from u_pb_modify within w_fl302_cuota_imarpe
end type
type pb_new from u_pb_insert within w_fl302_cuota_imarpe
end type
type pb_delete from u_pb_delete within w_fl302_cuota_imarpe
end type
type dw_master from u_dw_abc within w_fl302_cuota_imarpe
end type
end forward

global type w_fl302_cuota_imarpe from w_abc
integer width = 2592
integer height = 1708
string title = "Cuota de Imarpe (FL302)"
string menuname = "m_smpl"
event ue_retrieve ( )
pb_retrieve pb_retrieve
pb_procesar pb_procesar
pb_update pb_update
pb_modify pb_modify
pb_new pb_new
pb_delete pb_delete
dw_master dw_master
end type
global w_fl302_cuota_imarpe w_fl302_cuota_imarpe

event ue_retrieve();pb_new.enabled = true
pb_delete.enabled = true
pb_modify.enabled = true
pb_update.enabled = true
pb_procesar.enabled = true

dw_master.Retrieve()
end event

on w_fl302_cuota_imarpe.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.pb_retrieve=create pb_retrieve
this.pb_procesar=create pb_procesar
this.pb_update=create pb_update
this.pb_modify=create pb_modify
this.pb_new=create pb_new
this.pb_delete=create pb_delete
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_retrieve
this.Control[iCurrent+2]=this.pb_procesar
this.Control[iCurrent+3]=this.pb_update
this.Control[iCurrent+4]=this.pb_modify
this.Control[iCurrent+5]=this.pb_new
this.Control[iCurrent+6]=this.pb_delete
this.Control[iCurrent+7]=this.dw_master
end on

on w_fl302_cuota_imarpe.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_retrieve)
destroy(this.pb_procesar)
destroy(this.pb_update)
destroy(this.pb_modify)
destroy(this.pb_new)
destroy(this.pb_delete)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 200
pb_new.Y 	= newheight - pb_new.height - 20
pb_delete.Y = newheight - pb_delete.height - 20
pb_modify.Y = newheight - pb_modify.height - 20
pb_update.Y = newheight - pb_update.height - 20
pb_procesar.Y = newheight - pb_procesar.height - 20
pb_retrieve.Y = newheight - pb_retrieve.height - 20
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query

dw_master.of_protect()         		// bloquear modificaciones 

of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

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

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

ib_update_check = TRUE
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

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type pb_retrieve from picturebutton within w_fl302_cuota_imarpe
string tag = "Recupera Datos"
integer x = 1490
integer y = 1324
integer width = 155
integer height = 140
integer taborder = 60
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&R"
string picturename = "Retrieve!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Recuperar"
end type

event clicked;PARENT.EVENT Dynamic ue_retrieve()
end event

type pb_procesar from picturebutton within w_fl302_cuota_imarpe
string tag = "Procesa los partes de Pesca"
integer x = 1646
integer y = 1324
integer width = 155
integer height = 140
integer taborder = 70
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&p"
string picturename = "h:\SOURCE\BMP\run.bmp"
string disabledname = "h:\SOURCE\BMP\run_d.bmp"
alignment htextalign = left!
string powertiptext = "Procesar Captura Pesca"
end type

event clicked;long ll_row
string ls_ano, ls_especie

ll_row = dw_master.GetRow()
if ll_row <= 0 then
	MessageBox('Aviso', 'PARA EJECUTAR ESTA OPCION DEBE SELECCIONAR ' &
		+'UN REGISTRO', Information!)
	return
end if

ls_ano 		= dw_master.object.ano[ll_row]
ls_especie 	= dw_master.object.especie[ll_row]

DECLARE PESCA_CAPTURADA PROCEDURE FOR
USP_FL_PESCA_CAPTURADA( :ls_ano, :ls_especie );

EXECUTE PESCA_CAPTURADA;

IF SQLCA.sqlcode = -1 THEN
	MessageBox('SQL error', SQLCA.SQLErrText+', ' &
		+	'Proceso no se ha realizado satisfactoriamente')
	Rollback ;
	Return 
END IF

CLOSE PESCA_CAPTURADA;

dw_master.SetRedraw(false)
pb_retrieve.event clicked()
dw_master.SetRow(ll_row)
dw_master.SelectRow(0, false)
dw_master.SelectRow(ll_row, true)
dw_master.SetRedraw(true)

MessageBox('Aviso','Proceso Satisfactorio..', Information!)

end event

type pb_update from u_pb_update within w_fl302_cuota_imarpe
integer x = 1335
integer y = 1324
integer width = 155
integer height = 140
integer taborder = 50
integer textsize = -2
boolean enabled = false
string text = "&G"
string picturename = "h:\SOURCE\BMP\grabar.bmp"
string disabledname = "h:\SOURCE\BMP\grabar_d.bmp"
string powertiptext = "Grabar"
end type

type pb_modify from u_pb_modify within w_fl302_cuota_imarpe
integer x = 1179
integer y = 1324
integer width = 155
integer height = 140
integer taborder = 40
integer textsize = -2
boolean enabled = false
string text = "&m"
string picturename = "h:\SOURCE\BMP\modificar.bmp"
string disabledname = "h:\SOURCE\BMP\modificar_d.bmp"
string powertiptext = "Modificar"
end type

type pb_new from u_pb_insert within w_fl302_cuota_imarpe
integer x = 864
integer y = 1324
integer width = 155
integer height = 140
integer taborder = 20
integer textsize = -2
boolean enabled = false
string text = "&I"
string picturename = "h:\SOURCE\BMP\nuevo.bmp"
string disabledname = "h:\SOURCE\BMP\nuevo_d.bmp"
string powertiptext = "Insertar"
end type

event clicked;PARENT.EVENT ue_insert()
end event

type pb_delete from u_pb_delete within w_fl302_cuota_imarpe
integer x = 1024
integer y = 1324
integer width = 155
integer height = 140
integer taborder = 30
integer textsize = -2
boolean enabled = false
string text = "&e"
string picturename = "h:\SOURCE\BMP\eliminar.bmp"
string disabledname = "h:\SOURCE\BMP\eliminar_d.bmp"
string powertiptext = "Eliminar"
end type

event clicked;PARENT.EVENT ue_delete()
end event

type dw_master from u_dw_abc within w_fl302_cuota_imarpe
integer x = 14
integer y = 72
integer width = 2491
integer height = 1232
string dataobject = "d_cuota_imarpe_grid"
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;IF currentrow = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = currentrow       // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	THIS.Event ue_output(currentrow)
	RETURN
END IF
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ib_delete_cascada = false // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event ue_insert;call super::ue_insert;integer li_ano
long ll_row

ll_row = this.GetRow()

if ll_row <= 0 then
	return ll_row
end if

if ll_row = 1 then
	this.object.ano[ll_row] = string(year(today()))
else
	li_ano = integer(this.object.ano[ll_row - 1])
	this.object.ano[ll_row] = string(li_ano + 1)
end if

return ll_row
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_tipo, ls_ano
long ll_row, ll_count

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "ESPECIE"
		
		ls_codigo = this.object.especie[ll_row]

		SetNull(ls_data)
		select descr_especie
			into :ls_data
		from tg_especies
		where especie = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
			return 1
		end if
		
		ls_ano = trim(this.object.ano[ll_row])

		select count(*)
			into :ll_count
		from fl_cuota_imarpe
		where ano = :ls_ano 
		  and especie = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "ESPECIE YA ESTA INGRESADA EN ESE AÑO", StopSign!)
			return 1
		end if
		
		this.object.descr_especie[ll_row] = ls_data
end choose
end event

event doubleclicked;call super::doubleclicked;string ls_codigo, ls_data, ls_sql, ls_ano
long ll_row, ll_count
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()
choose case upper(dwo.name)
		
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
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE ESPECIE", StopSign!)
			return 1
		end if
		
		ls_ano = trim(this.object.ano[ll_row])

		select count(*)
			into :ll_count
		from fl_cuota_imarpe
		where ano = :ls_ano 
		  and especie = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "ESPECIE YA FUE INGRESADA EN ESE AÑO", StopSign!)
			return 1
		end if

		this.object.descr_especie[ll_row] 	= ls_data		
		this.object.especie[ll_row] 			= ls_codigo
		this.ii_update = 1
end choose
end event

