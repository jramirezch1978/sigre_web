$PBExportHeader$w_fl008_semanas_pesca.srw
forward
global type w_fl008_semanas_pesca from w_abc
end type
type cb_consultar from commandbutton within w_fl008_semanas_pesca
end type
type st_1 from statictext within w_fl008_semanas_pesca
end type
type em_ano from editmask within w_fl008_semanas_pesca
end type
type dw_master from u_dw_abc within w_fl008_semanas_pesca
end type
end forward

global type w_fl008_semanas_pesca from w_abc
integer width = 2158
integer height = 1340
string title = "Semanas de Pesca (FL008)"
string menuname = "m_mto_smpl"
cb_consultar cb_consultar
st_1 st_1
em_ano em_ano
dw_master dw_master
end type
global w_fl008_semanas_pesca w_fl008_semanas_pesca

on w_fl008_semanas_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.cb_consultar=create cb_consultar
this.st_1=create st_1
this.em_ano=create em_ano
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_consultar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.dw_master
end on

on w_fl008_semanas_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_consultar)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;date ld_fecha

ld_fecha = TODAY()
idw_1     = dw_master
//idw_query = dw_master
dw_master.SetTransObject(SQLCA)
em_ano.Text = string(ld_fecha, 'yyyy')

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_insert;call super::ue_insert;long ll_row

ll_row = dw_master.Event ue_insert()
dw_master.object.ano[ll_row] = year(today())
dw_master.object.mes[ll_row] = month(today())
dw_master.object.fecha_inicio[ll_row] = today()



end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_update_pre;call super::ue_update_pre;Long 		ll_x, ll_row[]
integer 	li_ano, li_mes, li_semana

ib_update_check = true
of_get_row_update(dw_master, ll_row[])

For ll_x = 1 TO UpperBound(ll_row)
//	Validar registro ll_x
	li_ano    = integer(idw_1.object.ano[ll_row[ll_x]])
	li_mes 	 = integer(idw_1.object.mes[ll_row[ll_x]])
	li_semana = integer(idw_1.object.semana[ll_row[ll_x]])
	IF li_ano <= 0  THEN
		MessageBox("Error", "NO SE PUEDEN INGRESAR AÑOS NEGATIVOS", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF li_mes <= 0  THEN
		MessageBox("Error", "NO SE PUEDEN INGRESAR MESES NEGATIVOS", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF li_semana <= 0  THEN
		MessageBox("Error", "NO SE PUEDEN INGRESAR SEMANAS NEGATIVOS", StopSign!  )
		ib_update_check = False
		exit
	END IF

NEXT

if ib_update_check = false then
	idw_1.ScrolltoRow(ll_row[ll_x])
	idw_1.SelectRow(0, false)
	idw_1.SelectRow(ll_row[ll_x], true)
end if

dw_master.of_set_flag_replicacion()


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

type cb_consultar from commandbutton within w_fl008_semanas_pesca
integer x = 1093
integer y = 52
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

event clicked;integer li_ano

li_ano = integer(em_ano.text)
dw_master.retrieve( li_ano )

dw_master.ii_protect = 0
dw_master.of_protect()
end event

type st_1 from statictext within w_fl008_semanas_pesca
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

type em_ano from editmask within w_fl008_semanas_pesca
integer x = 645
integer y = 56
integer width = 297
integer height = 100
integer taborder = 10
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

type dw_master from u_dw_abc within w_fl008_semanas_pesca
integer y = 188
integer width = 2048
integer height = 920
integer taborder = 30
string dataobject = "d_semanas_pesca_grid"
end type

event constructor;call super::constructor;ii_ck[1] = 1		
is_dwform = 'tabular'
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
long 		ll_x
date 		ld_fecha1, ld_fecha2
integer 	li_semana

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "FECHA_INICIO"
		ld_fecha1 = Date(this.object.fecha_inicio[row])
		if row > 1 then
			ld_fecha2 = Date(this.object.fecha_fin[row - 1])
			
			if ld_fecha1 <= ld_fecha2 then
				MessageBox('ERROR', 'NO PUEDE INGRESAR COMO FECHA ' &
						+'INICIAL UNA FECHA MENOR A LA FECHA FINAL DE LA ' &
						+ 'SEMANA ANTERIOR', StopSign!)
				SetNull(ld_fecha1)
				this.object.fecha_inicio[row] = ld_fecha1
				return 2
			end if
		end if
		
		ld_fecha2 = Date( f_fecha_fin( DateTime( ld_fecha1 ) ) )
		
		this.object.fecha_fin[row] = ld_fecha2
		
		if MessageBox('AVISO', "DESEA USTED ACTUALIZAR TODAS LAS SEMANAS SIGUIENTES?", Information!, YesNo!, 2) = 2 then
				return
		end if
		for ll_x = row + 1 to this.RowCount()
			ld_fecha1 = Date(this.object.fecha_fin[ll_x - 1])
			ld_fecha1 = RelativeDate( ld_fecha1, 1 )
			ld_fecha2 = Date( f_fecha_fin( DateTime(ld_fecha1) ))
		
			this.object.fecha_inicio[ll_x] = ld_fecha1
			this.object.fecha_fin	[ll_x] = ld_fecha2
		next

	case "FECHA_FIN"
		
		ld_fecha1 = Date(this.object.fecha_inicio[row])
		ld_fecha2 = Date(this.object.fecha_fin[row])
		
		if ld_fecha2 < ld_fecha1 then
			MessageBox('FLOTA', 'ERROR EN EL INTERVALO DE LAS SEMANAS DE PRODUCCION',StopSign!)
			SetNull(ld_fecha2)
			this.object.fecha_fin[row] = ld_fecha2
			return 1
		end if
		
		if this.RowCount() > 1 then
			ld_fecha1 = Date( this.object.fecha_inicio[ row + 1 ] )
			
			if ld_fecha1 > ld_fecha2 then
				if MessageBox('AVISO', "DESEA USTED ACTUALIZAR TODAS LAS SEMANAS SIGUIENTES?", Information!, YesNo!, 2) = 2 then
					return
				end if
			end if
			
			// En forma automatica cambio las fechas de las semanas
			for ll_x = row + 1 to this.RowCount()
				ld_fecha1 = Date(this.object.fecha_fin[ll_x - 1])
				ld_fecha1 = RelativeDate( ld_fecha1, 1 )
				ld_fecha2 = Date( f_fecha_fin( DateTime(ld_fecha1) ))
			
				this.object.fecha_inicio[ll_x] = ld_fecha1
				this.object.fecha_fin	[ll_x] = ld_fecha2
			next
		
		end if
		
end choose

end event

event itemerror;call super::itemerror;RETURN 1
end event

