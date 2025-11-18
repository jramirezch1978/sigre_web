$PBExportHeader$w_rh020_abc_ubicacion_geografica.srw
forward
global type w_rh020_abc_ubicacion_geografica from w_abc_mastdet_smpl
end type
type dw_prov from u_dw_abc within w_rh020_abc_ubicacion_geografica
end type
type dw_ciudad from u_dw_abc within w_rh020_abc_ubicacion_geografica
end type
type dw_dist from u_dw_abc within w_rh020_abc_ubicacion_geografica
end type
end forward

global type w_rh020_abc_ubicacion_geografica from w_abc_mastdet_smpl
integer width = 3529
integer height = 2204
string title = "(RH020)  Ubicación Geográfica"
string menuname = "m_master_simple"
boolean resizable = false
dw_prov dw_prov
dw_ciudad dw_ciudad
dw_dist dw_dist
end type
global w_rh020_abc_ubicacion_geografica w_rh020_abc_ubicacion_geografica

on w_rh020_abc_ubicacion_geografica.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_prov=create dw_prov
this.dw_ciudad=create dw_ciudad
this.dw_dist=create dw_dist
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_prov
this.Control[iCurrent+2]=this.dw_ciudad
this.Control[iCurrent+3]=this.dw_dist
end on

on w_rh020_abc_ubicacion_geografica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_prov)
destroy(this.dw_ciudad)
destroy(this.dw_dist)
end on

event resize;//override
//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_prov.SetTransObject(sqlca)
dw_ciudad.SetTransObject(sqlca)
dw_dist.SetTransObject(sqlca)

idw_1 = dw_master              			// asignar dw corriente

dw_prov.BorderStyle = StyleRaised!
dw_ciudad.BorderStyle = StyleRaised!
dw_dist.BorderStyle = StyleRaised!

dw_prov.of_protect()
dw_ciudad.of_protect()
dw_dist.of_protect()
end event

event ue_update;//override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_prov.of_create_log()
	dw_ciudad.of_create_log()
	dw_dist.of_create_log()
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

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF	dw_prov.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_prov.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF	dw_ciudad.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_ciudad.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF	dw_dist.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_dist.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_prov.of_save_log()
		lbo_ok = dw_ciudad.of_save_log()
		lbo_ok = dw_dist.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_prov.ii_update = 0
	dw_ciudad.ii_update = 0
	dw_dist.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_prov.il_totdel = 0
	dw_ciudad.il_totdel = 0
	dw_dist.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	dw_prov.REsetUpdate()
	dw_ciudad.REsetUpdate()
	dw_dist.REsetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

event ue_dw_share;call super::ue_dw_share;
if dw_master.rowcount( ) > 1 then
	dw_master.scrolltorow( 1 )
	dw_master.setrow( 1 )
	dw_master.selectrow( 1, true )
end if

long ll_fila

ll_fila = dw_master.find("cod_pais = '9589'", 1, idw_1.rowcount())

if ll_fila <> 0 then		// la busqueda resulto exitosa
	dw_master.selectrow(0, false)
	dw_master.selectrow(ll_fila,true)
	dw_master.scrolltorow(ll_fila)
end if
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh020_abc_ubicacion_geografica
integer x = 0
integer y = 8
integer width = 2002
string dataobject = "d_pais_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear
is_dwform = 'tabular'
ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;dw_detail.reset()
dw_prov.reset()
dw_ciudad.reset()
dw_dist.reset()

if currentrow < 1 then return

if dw_detail.retrieve(this.object.cod_pais[currentrow]) > 1 then
	dw_detail.setrow( 1 )
	dw_detail.scrolltorow( 1 )
	dw_detail.selectrow( 1, true )
end if
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh020_abc_ubicacion_geografica
integer y = 536
integer width = 1202
integer height = 728
string dataobject = "d_departamento_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;string ls_pais, ls_dpto

dw_prov.reset()
dw_ciudad.reset()
dw_dist.reset()

if currentrow < 1 then return

ls_pais = this.object.cod_pais[currentrow]
ls_dpto = this.object.cod_dpto[currentrow]

if dw_prov.retrieve(ls_pais, ls_dpto) > 1 then
	dw_prov.setrow( 1 )
	dw_prov.scrolltorow( 1 )
	dw_prov.selectrow( 1, true )
end if
end event

event dw_detail::ue_insert;//ovreride
if dw_master.getrow( ) < 1 then
	messagebox(parent.title, 'No hay ningún país Seleccionado' )
	return -1
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

type dw_prov from u_dw_abc within w_rh020_abc_ubicacion_geografica
integer x = 1216
integer y = 536
integer width = 1202
integer height = 728
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_provincia_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event ue_insert_pre;call super::ue_insert_pre;long ll_detail
ll_detail = dw_detail.getrow( )
if ll_detail < 1 then return
this.object.cod_pais[al_row] = dw_detail.object.cod_pais[ll_detail]
this.object.cod_dpto[al_row] = dw_detail.object.cod_dpto[ll_detail]
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event rowfocuschanged;call super::rowfocuschanged;string ls_cod_pais, ls_cod_dpto, ls_cod_prov

dw_ciudad.reset( )
dw_dist.reset( )

if currentrow < 1 then return

ls_cod_pais = this.object.cod_pais[currentrow]
ls_cod_dpto = this.object.cod_dpto[currentrow]
ls_cod_prov = this.object.cod_prov[currentrow]

if dw_ciudad.retrieve(ls_cod_pais, ls_cod_dpto, ls_cod_prov) > 1 then
	dw_ciudad.setrow( 1 )
	dw_ciudad.scrolltorow( 1 )
	dw_ciudad.selectrow( 1, true )
end if

if dw_dist.retrieve(ls_cod_pais, ls_cod_dpto, ls_cod_prov) > 1 then
	dw_dist.setrow( 1 )
	dw_dist.scrolltorow( 1 )
	dw_dist.selectrow( 1, true )
end if
end event

event ue_insert;// OVERRIDE

if dw_detail.getrow( ) < 1 then
	messagebox(parent.title, 'No hay ningun departamento seleccionado')
	return -1
end if
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

type dw_ciudad from u_dw_abc within w_rh020_abc_ubicacion_geografica
integer y = 1300
integer width = 1202
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_ciudad_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;long ll_prov

ll_prov = dw_prov.getrow( )

if ll_prov < 1 then return

this.object.cod_pais[al_row] = dw_prov.object.cod_pais[ll_prov]
this.object.cod_dpto[al_row] = dw_prov.object.cod_dpto[ll_prov]
this.object.cod_prov[al_row] = dw_prov.object.cod_prov[ll_prov]
end event

event ue_insert;//OVERRIDE

if dw_prov.getrow( ) < 1 then
	messagebox(parent.title, "No hay ninguna provincia seleccionada")
	return -1
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row


end event

type dw_dist from u_dw_abc within w_rh020_abc_ubicacion_geografica
integer x = 1207
integer y = 1300
integer width = 1211
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_distrito_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;long ll_prov

ll_prov = dw_prov.getrow( )

if ll_prov < 1 then return

this.object.cod_pais[al_row] = dw_prov.object.cod_pais[ll_prov]
this.object.cod_dpto[al_row] = dw_prov.object.cod_dpto[ll_prov]
this.object.cod_prov[al_row] = dw_prov.object.cod_prov[ll_prov]
end event

event ue_insert;//OVERRIDE

if dw_prov.getrow( ) < 1 then
	messagebox(parent.title, "No hay ninguna provincia seleccionada")
	return -1
end if

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row


end event

