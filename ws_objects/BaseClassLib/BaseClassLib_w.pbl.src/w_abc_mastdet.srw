$PBExportHeader$w_abc_mastdet.srw
$PBExportComments$abc Maestro detalle con pop window para la busqueda del maestro, ff para el Maestro, tbl para el detalle
forward
global type w_abc_mastdet from w_abc
end type
type st_horizontal from statictext within w_abc_mastdet
end type
type st_filter from statictext within w_abc_mastdet
end type
type uo_filter from cls_vuo_filter within w_abc_mastdet
end type
type dw_master from u_dw_abc within w_abc_mastdet
end type
type dw_detail from u_dw_abc within w_abc_mastdet
end type
end forward

global type w_abc_mastdet from w_abc
integer width = 3854
integer height = 2748
string menuname = "m_mtto_smpl"
long il_hiddencolor = 254068744
st_horizontal st_horizontal
st_filter st_filter
uo_filter uo_filter
dw_master dw_master
dw_detail dw_detail
end type
global w_abc_mastdet w_abc_mastdet

type variables
String      		is_tabla_m,is_tabla_d,is_colname_m[],is_coltype_m[],&
						is_colname_d[],is_coltype_d[]
Boolean				ib_log = TRUE
n_cst_log_diario	in_log
string				is_action

Dragobject	idrg_Top		//Reference to the Top control


end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_refreshbars ()
public subroutine of_resizebars ()
public subroutine of_resizepanels ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

//if is_action = 'new' then
//	select count(*)
//		into :ll_count
//	from num_vale_mov
//	where origen = :gs_origen;
//	
//	if ll_count = 0 then
//		ls_lock_table = 'LOCK TABLE NUM_VALE_MOV IN EXCLUSIVE MODE'
//		EXECUTE IMMEDIATE :ls_lock_table ;
//		
//		if SQLCA.SQLCode < 0 then
//			ls_mensaje = SQLCA.SQLErrText
//			ROLLBACK;
//			MessageBox('Aviso', ls_mensaje)
//			return 0
//		end if
//		
//		insert into num_vale_mov(origen, ult_nro)
//		values( :gs_origen, 1);
//		
//		if SQLCA.SQLCode < 0 then
//			ls_mensaje = SQLCA.SQLErrText
//			ROLLBACK;
//			MessageBox('Aviso', ls_mensaje)
//			return 0
//		end if
//	
//	end if
//	
//	SELECT ult_nro
//	  INTO :ll_ult_nro
//	FROM num_vale_mov
//	where origen = :gs_origen for update;
//	
//	update num_vale_mov
//		set ult_nro = ult_nro + 1
//	where origen = :gs_origen;
//	
//	if SQLCA.SQLCode < 0 then
//		ls_mensaje = SQLCA.SQLErrText
//		ROLLBACK;
//		MessageBox('Aviso', ls_mensaje)
//		return 0
//	end if
//	
//	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
//	
//	dw_master.object.nro_vale[dw_master.getrow()] = ls_next_nro
//	dw_master.ii_update = 1
//else
//	ls_next_nro = dw_master.object.nro_vale[dw_master.getrow()] 
//end if

// Asigna numero a detalle
//for ll_j = 1 to dw_detail.RowCount()
//	dw_detail.object.nro_vale[ll_j] = ls_next_nro
//next

return 1
end function

public subroutine of_refreshbars ();// Refresh the size bars

// Force appropriate order
st_horizontal.SetPosition(ToTop!)

// Make sure the Width is not lost
st_horizontal.Height = cii_BarThickness

end subroutine

public subroutine of_resizebars ();//Resize Bars according to Bars themselves, WindowBorder, and BarThickness.

st_horizontal.Move (dw_master.x, st_horizontal.Y)
st_horizontal.Resize (This.WorkSpaceWidth() - st_horizontal.X - cii_WindowBorder, cii_BarThickness)

of_RefreshBars()

end subroutine

public subroutine of_resizepanels ();// Resize the panels according to the Vertical Line, Horizontal Line,
// BarThickness, and WindowBorder.

Long		ll_Width, ll_Height

// Validate the controls.
If Not IsValid(idrg_Top) or Not IsValid(idrg_Bottom) Then
	Return 
End If

ll_Width = This.WorkSpaceWidth()
ll_Height = This.WorkspaceHeight() - p_pie.y

// Enforce a minimum window size
If ll_Height < idrg_Bottom.Y + 150 Then
	ll_Height = idrg_Bottom.Y + 150
End If

// Tengo que validar cual es la altura máxima para redimensionar


// Top processing
idrg_Top.Resize(ll_Width - idrg_Top.X, st_horizontal.Y - idrg_Top.Y)

					
// Bottom Procesing
idrg_Bottom.Move(idrg_bottom.x, st_horizontal.Y + cii_BarThickness)
idrg_Bottom.Resize(ll_Width - (cii_WindowBorder * 2), &
							ll_Height - idrg_Bottom.Y - cii_WindowBorder)

end subroutine

on w_abc_mastdet.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.st_horizontal=create st_horizontal
this.st_filter=create st_filter
this.uo_filter=create uo_filter
this.dw_master=create dw_master
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_horizontal
this.Control[iCurrent+2]=this.st_filter
this.Control[iCurrent+3]=this.uo_filter
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.dw_detail
end on

on w_abc_mastdet.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_horizontal)
destroy(this.st_filter)
destroy(this.uo_filter)
destroy(this.dw_master)
destroy(this.dw_detail)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - cii_WindowBorder
dw_detail.width  = newwidth  - dw_detail.x - cii_WindowBorder
dw_detail.height = p_pie.y - dw_detail.y - cii_WindowBorder

end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = dw_detail AND dw_master.getRow() = 0 THEN
	MessageBox("Error", "No existe registro Maestro")
	RETURN
END IF

ib_insert_check= true
//this.event ue_insert_pre( )

if not ib_insert_check then return

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;if not IsNull(idw_1) and isValid(idw_1) then
	idw_1.of_protect()
end if

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
idw_1.setfocus( )

dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 
dw_detail.of_protect()

if dw_master.isvaliddataobject( ) then
	is_tabla_m = dw_master.Object.Datawindow.Table.UpdateTable
end if
if dw_detail.isvaliddataobject( ) then
	is_tabla_d = dw_detail.Object.Datawindow.Table.UpdateTable
end if

// ii_help = 101           // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//idw_query = dw_master

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	u_ds_base lds_log_m, lds_log_d
	lds_log_m = Create u_ds_base
	lds_log_d = Create u_ds_base
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gnvo_app.is_user, is_tabla_m, gnvo_app.invo_empresa.is_empresa)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gnvo_app.is_user, is_tabla_d, gnvo_app.invo_empresa.is_empresa)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "No se ha podido grabar el Maestro. Datawindow: dw_master"
		gnvo_log.of_errorlog(ls_msg)
		gnvo_app.of_ShowMessageDialog(ls_msg)
	else
		this.event ue_post_update_dw( dw_master )
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "No se ha podido grabar el Detalle. Datawindow: dw_detail"
		gnvo_log.of_errorlog(ls_msg)
		gnvo_app.of_ShowMessageDialog(ls_msg)
	else
		this.event ue_post_update_dw( dw_detail )
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = 'No se pudo grabar el Log Diario, Maestro'
			gnvo_log.of_errorlog(ls_msg)
			gnvo_app.of_ShowMessageDialog(ls_msg)
		END IF
		IF lbo_ok and lds_log_d.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = 'No se pudo grabar el Log Diario, Detalle'
			gnvo_log.of_errorlog(ls_msg)
			gnvo_app.of_ShowMessageDialog(ls_msg)
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update = 0
	dw_master.resetUpdate()
	dw_master.il_totdel = 0
	
	dw_detail.ResetUpdate()
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect( )
	
	this.event ue_update_pos( )
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_open_pos();call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF
end event

event close;call super::close;Destroy in_log
end event

event ue_duplicar;call super::ue_duplicar;idw_1.Event ue_duplicar()
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, dw_detail.is_dwform) <> true then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_set_numera	() = 0 then return

ib_update_check = true

end event

event open;call super::open;// Set the TopLeft, TopRight, and Bottom Controls
idrg_Top = dw_master
idrg_Bottom = dw_detail

//Change the back color so they cannot be seen.
If Not ib_debug Then 
	st_horizontal.BackColor = This.BackColor
	il_HiddenColor = This.BackColor
End If

// Call the resize functions
of_ResizeBars()
of_ResizePanels()
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_1 = dw_master and idw_1.is_dwform = 'form' then 		
	this.event ue_update_request( )
	
	dw_master.reset()
	dw_detail.reset()
	
	is_action = 'new'
else
	IF dw_master.getrow() = 0 then return
end if
end event

type p_pie from w_abc`p_pie within w_abc_mastdet
end type

type ole_skin from w_abc`ole_skin within w_abc_mastdet
end type

type uo_h from w_abc`uo_h within w_abc_mastdet
end type

type st_box from w_abc`st_box within w_abc_mastdet
end type

type phl_logonps from w_abc`phl_logonps within w_abc_mastdet
end type

type p_mundi from w_abc`p_mundi within w_abc_mastdet
end type

type p_logo from w_abc`p_logo within w_abc_mastdet
end type

type st_horizontal from statictext within w_abc_mastdet
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 535
integer y = 1012
integer width = 745
integer height = 32
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "SizeNS!"
long textcolor = 33554432
long backcolor = 16776960
boolean focusrectangle = false
end type

event mousemove;Integer	li_prevposition

If KeyDown(keyLeftButton!) Then

	// Determinar la mínima altura de los paneles dw_master y dw_detail
	if Parent.PointerY() - idrg_top.y < cii_MinimunHeight then return -1

	if idrg_bottom.y + idrg_bottom.height - &
		Parent.PointerY() < cii_MinimunHeight then return -1

	// Store the previous position.
	li_prevposition = This.Y
	
	This.Y = Parent.PointerY()
	
	// Perform redraws when appropriate.
	If Not IsValid(idrg_top) Then Return
	
	If li_prevposition < idrg_top.y + idrg_top.height Then 
		idrg_top.setredraw(true)
	End If
	
	If Not IsValid(idrg_bottom) Then Return
	
	If li_prevposition > idrg_bottom.y Then idrg_bottom.setredraw(true)
End If

end event

event mouseup;// Hide the bar
If Not ib_Debug Then This.BackColor = il_HiddenColor

// Call the resize functions
of_ResizeBars()
of_ResizePanels()

end event

event mousedown;This.SetPosition(ToTop!)
If Not ib_debug Then This.BackColor = 0  // Show Bar in Black while being moved.

end event

type st_filter from statictext within w_abc_mastdet
integer x = 590
integer y = 180
integer width = 302
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Filtrar por :"
boolean focusrectangle = false
end type

type uo_filter from cls_vuo_filter within w_abc_mastdet
integer x = 914
integer y = 156
integer taborder = 50
end type

on uo_filter.destroy
call cls_vuo_filter::destroy
end on

type dw_master from u_dw_abc within w_abc_mastdet
integer x = 503
integer y = 292
integer width = 1362
integer height = 720
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'md'
idw_det  = dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
	
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end if


end event

event retrieveend;call super::retrieveend;if idw_1 = this then
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(rowCount))
end if
end event

type dw_detail from u_dw_abc within w_abc_mastdet
integer x = 503
integer y = 1044
integer width = 1403
integer height = 424
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
 is_dwform = 'tabular' // tabular, grid, form
 
 idw_mst  = dw_master
end event

event ue_insert_pre;call super::ue_insert_pre;Any  la_id
Integer li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_dk)
	la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
	THIS.SetItem(al_row, ii_rk[li_x], la_id)
NEXT


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
	
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end if


end event

event retrieveend;call super::retrieveend;if idw_1 = this then
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(rowCount))
end if
end event

