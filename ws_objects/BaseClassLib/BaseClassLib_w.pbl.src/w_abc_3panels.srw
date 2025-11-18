$PBExportHeader$w_abc_3panels.srw
forward
global type w_abc_3panels from w_abc
end type
type dw_master from u_dw_abc within w_abc_3panels
end type
type dw_detail from u_dw_abc within w_abc_3panels
end type
type st_1 from statictext within w_abc_3panels
end type
type uo_filter from cls_vuo_filter within w_abc_3panels
end type
type dw_detdet from u_dw_abc within w_abc_3panels
end type
type st_horizontal from statictext within w_abc_3panels
end type
type st_both from statictext within w_abc_3panels
end type
type st_vertical from statictext within w_abc_3panels
end type
type st_master from statictext within w_abc_3panels
end type
type st_detail from statictext within w_abc_3panels
end type
type st_detdet from statictext within w_abc_3panels
end type
end forward

global type w_abc_3panels from w_abc
integer width = 3415
integer height = 1968
dw_master dw_master
dw_detail dw_detail
st_1 st_1
uo_filter uo_filter
dw_detdet dw_detdet
st_horizontal st_horizontal
st_both st_both
st_vertical st_vertical
st_master st_master
st_detail st_detail
st_detdet st_detdet
end type
global w_abc_3panels w_abc_3panels

type variables
String      		is_tabla_m, is_tabla_d, is_tabla_dd, &
						is_colname_m[], is_coltype_m[], &
						is_colname_d[], is_coltype_d[], &
						is_colname_dd[], is_coltype_dd[]
String				is_action						
Boolean				ib_log = TRUE
n_cst_log_diario	in_log
StaticText			ist_1
Long					il_st_color
Integer				ii_ModePanels

protected:
constant integer ii_ModeTopRightLeftBottom = 1
constant integer ii_ModeTopBottomRightLeft = 2


end variables

forward prototypes
public subroutine of_refreshbars ()
public subroutine of_resizebars ()
public subroutine of_resizepanels ()
public function integer of_set_numera ()
end prototypes

public subroutine of_refreshbars ();// Refresh the size bars

// Force appropriate order
st_vertical.SetPosition(ToTop!)
st_horizontal.SetPosition(ToTop!)
st_both.SetPosition(ToTop!)

// Make sure the Width is not lost
st_vertical.Width = cii_BarThickness
st_horizontal.Height = cii_BarThickness
st_both.Resize (cii_BarThickness, cii_BarThickness)

end subroutine

public subroutine of_resizebars ();//Resize Bars according to Bars themselves, WindowBorder, and BarThickness.
If IsNull(idrg_TopLeft) or IsNull(idrg_topright) or isNull(idrg_bottom) then return

If Not IsValid(idrg_TopRight) or Not IsValid(idrg_TopRight) or &
	Not IsValid(idrg_Bottom) Then
	Return 
End If

if ii_modepanels = ii_modetoprightleftbottom then
	st_vertical.Move (st_vertical.X, idrg_TopLeft.Y)
	st_vertical.Resize (cii_Barthickness, &
			st_horizontal.Y - st_vertical.Y )
	
	st_horizontal.Move (idrg_Bottom.X, st_horizontal.Y)
	st_horizontal.Resize (This.WorkSpaceWidth() - st_horizontal.X &
			- cii_WindowBorder, cii_BarThickness)
	
elseif ii_modepanels = ii_modetopbottomrightleft then
	st_vertical.Y = st_horizontal.Y + cii_barthickness
	st_vertical.height = This.WorkSpaceHeight() - st_vertical.Y &
			- cii_WindowBorder
	
	st_horizontal.Move (idrg_TopRight.X, st_horizontal.Y)
	st_horizontal.Resize (This.WorkSpaceWidth() - st_horizontal.X &
			- cii_WindowBorder, cii_BarThickness)
end if

st_both.Move(st_vertical.X, st_horizontal.Y)
st_both.Resize(cii_BarThickness, cii_BarThickness)


of_RefreshBars()

end subroutine

public subroutine of_resizepanels ();// Resize the panels according to the Vertical Line, Horizontal Line,
// BarThickness, and WindowBorder.

Long		ll_Width, ll_Height

// Validate the controls.
If Not IsValid(idrg_TopRight) or Not IsValid(idrg_TopRight) or &
	Not IsValid(idrg_Bottom) Then
	Return 
End If

ll_Width = This.WorkSpaceWidth()
ll_Height = This.WorkspaceHeight()

// Enforce a minimum window size
If ll_Width < idrg_TopRight.X + 150 Then
	ll_Width = idrg_TopRight.X + 150
End If

If ll_Height < idrg_Bottom.Y + 150 Then
	ll_Height = idrg_Bottom.Y + 150
End If

if ii_ModePanels = ii_Modetoprightleftbottom then
	// TopLeft processing
	idrg_TopLeft.Resize(st_vertical.X - idrg_TopLeft.X, st_horizontal.Y - idrg_TopLeft.Y)
	st_master.width = idrg_TopLeft.width
	
	// TopRight Processing
	idrg_TopRight.Move(st_vertical.X + cii_BarThickness, idrg_topright.Y)
	idrg_TopRight.Resize(ll_Width - (st_vertical.X + cii_BarThickness) - cii_WindowBorder, &
									st_horizontal.Y - idrg_TopRight.Y)
	st_detail.X = idrg_TopRight.X
	st_detail.width = idrg_TopRight.width
								
	// Bottom Procesing
	idrg_Bottom.Move(idrg_Bottom.X, st_horizontal.Y + cii_BarThickness &
				+ st_detdet.height)
	idrg_Bottom.Resize(ll_Width - idrg_Bottom.X - cii_WindowBorder, &
								ll_Height - idrg_Bottom.Y - cii_WindowBorder)
	st_detdet.Y = st_horizontal.Y + cii_BarThickness
	st_detdet.width = idrg_Bottom.width

elseif ii_ModePanels = ii_Modetopbottomrightleft then
	// TopLeft processing
	idrg_TopLeft.Resize(This.workspacewidth( ) - idrg_TopLeft.X - cii_windowborder , &
			st_horizontal.Y - idrg_TopLeft.Y)
	st_master.width = idrg_TopLeft.width
	
	//TopRight Processing
	st_detail.Y = st_horizontal.Y + cii_barthickness
	st_detail.width = st_Vertical.X - idrg_TopRight.X
	
	idrg_topright.Y = st_detail.Y + st_detail.height
	idrg_TopRight.resize( st_detail.width , &
			this.workspaceheight( ) - idrg_TopRight.Y - cii_windowborder )
	
	//Bottom procesing
	st_detdet.move(st_vertical.X + cii_barthickness, &
			st_horizontal.Y + cii_barthickness)
	st_detdet.width = this.workspacewidth( ) - st_detdet.X - cii_windowborder
	
	idrg_bottom.Move(st_detdet.X, st_detdet.Y + st_detdet.height)
	idrg_bottom.resize(st_detdet.width, &
			this.WorkSpaceheight( ) - idrg_bottom.Y - cii_windowborder)
	

end if

end subroutine

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

on w_abc_3panels.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.st_1=create st_1
this.uo_filter=create uo_filter
this.dw_detdet=create dw_detdet
this.st_horizontal=create st_horizontal
this.st_both=create st_both
this.st_vertical=create st_vertical
this.st_master=create st_master
this.st_detail=create st_detail
this.st_detdet=create st_detdet
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.uo_filter
this.Control[iCurrent+5]=this.dw_detdet
this.Control[iCurrent+6]=this.st_horizontal
this.Control[iCurrent+7]=this.st_both
this.Control[iCurrent+8]=this.st_vertical
this.Control[iCurrent+9]=this.st_master
this.Control[iCurrent+10]=this.st_detail
this.Control[iCurrent+11]=this.st_detdet
end on

on w_abc_3panels.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.st_1)
destroy(this.uo_filter)
destroy(this.dw_detdet)
destroy(this.st_horizontal)
destroy(this.st_both)
destroy(this.st_vertical)
destroy(this.st_master)
destroy(this.st_detail)
destroy(this.st_detdet)
end on

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	u_ds_base lds_log_m, lds_log_d, lds_log_dd
	lds_log_m = Create u_ds_base
	lds_log_d = Create u_ds_base
	lds_log_dd = Create u_ds_base
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_dd.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	lds_log_dd.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gnvo_app.is_user, is_tabla_m, gnvo_app.invo_empresa.is_empresa)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gnvo_app.is_user, is_tabla_d, gnvo_app.invo_empresa.is_empresa)
	in_log.of_create_log(dw_detdet, lds_log_dd, is_colname_dd, is_coltype_dd, gnvo_app.is_user, is_tabla_dd, gnvo_app.invo_empresa.is_empresa)
	
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
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
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "No se ha podido grabar el Detalle. Datawindow: dw_detail"
		gnvo_log.of_errorlog(ls_msg)
		gnvo_app.of_ShowMessageDialog(ls_msg)
	else
		this.event ue_post_update_dw( dw_detail )
	END IF
END IF

IF	dw_detdet.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detdet.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "No se ha podido grabar el Maestro. Datawindow: dw_master"
		gnvo_log.of_errorlog(ls_msg)
		gnvo_app.of_ShowMessageDialog(ls_msg)
	else
		this.event ue_post_update_dw( dw_detdet )
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = 'No se pudo grabar el Log Diario, Maestro'
			gnvo_log.of_errorlog(ls_msg)
			gnvo_app.of_ShowMessageDialog(ls_msg)
		END IF
		
		IF lbo_ok and lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = 'No se pudo grabar el Log Diario, Detalle'
			gnvo_log.of_errorlog(ls_msg)
			gnvo_app.of_ShowMessageDialog(ls_msg)
		END IF

		IF lbo_ok and lds_log_dd.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_msg = 'No se pudo grabar el Log Diario, Detalle'
			gnvo_log.of_errorlog(ls_msg)
			gnvo_app.of_ShowMessageDialog(ls_msg)
		END IF

	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
	destroy lds_log_dd
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_detdet.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_detdet.il_totdel = 0
	
	this.event ue_update_pos( )
END IF

end event

event close;call super::close;Destroy in_log
end event

event open;call super::open;// Set the TopLeft, TopRight, and Bottom Controls
idrg_TopLeft = dw_master
idrg_TopRight = dw_detail
idrg_Bottom = dw_detdet

ii_modepanels = ii_modeTopRightLeftBottom

//Change the back color so they cannot be seen.
If Not ib_debug Then 
	st_horizontal.BackColor = This.BackColor
	st_both.backcolor = This.BackColor
	st_vertical.BackColor = This.BackColor
	il_HiddenColor = This.BackColor
End If

// Call the resize functions
//of_ResizeBars()
//of_ResizePanels()

st_horizontal.event doubleclicked( )
st_vertical.event doubleclicked( )
end event

event resize;call super::resize;//Long ll_width, ll_height

st_horizontal.width = newwidth - st_horizontal.x - cii_windowborder

dw_detail.width = newwidth - dw_detail.x - cii_windowborder
dw_detdet.width = newwidth - dw_detdet.x - cii_windowborder
dw_detdet.height = newheight - dw_detdet.y - cii_windowborder

//st_Vertical.event doubleclicked( )
//st_Horizontal.event doubleclicked( )
end event

event ue_duplicar;call super::ue_duplicar;idw_1.Event ue_duplicar()
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = dw_detail AND dw_master.getRow() = 0 THEN
	MessageBox("Error", "No existe registro Maestro")
	RETURN
END IF

IF idw_1 = dw_detdet AND dw_detail.getRow() = 0 THEN
	MessageBox("Error", "No existe registro Maestro")
	RETURN
END IF


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_modify;call super::ue_modify;if not IsNull(idw_1) and isValid(idw_1) then
	idw_1.of_protect()
end if
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
	in_log.of_dw_map(dw_detdet, is_colname_dd, is_coltype_dd)
END IF
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
dw_detdet.SetTransObject(SQLCA)

idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado
dw_detdet.BorderStyle = StyleRaised! 	// indicar dw_detail como no activado

dw_master.of_protect()         			// bloquear modificaciones 
dw_detail.of_protect()
dw_detdet.of_protect()

if dw_master.isvaliddataobject( ) then
	is_tabla_m = dw_master.Object.Datawindow.Table.UpdateTable
end if
if dw_detail.isvaliddataobject( ) then
	is_tabla_d = dw_detail.Object.Datawindow.Table.UpdateTable
end if
if dw_detdet.isvaliddataobject( ) then
	is_tabla_dd = dw_detdet.Object.Datawindow.Table.UpdateTable
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

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
if f_row_Processing( dw_master, dw_master.is_dwform ) <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, dw_detail.is_dwform ) <> true then return
if f_row_Processing( dw_detdet, dw_detdet.is_dwform) <> true then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_detdet.of_set_flag_replicacion()

if of_set_numera	() = 0 then return

ib_update_check = true
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR &
	 dw_detdet.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
			"Existen cambios que no se han grabado. Desea grabarlos?", &
			Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_detdet.ii_update = 0
	END IF
END IF
end event

type p_pie from w_abc`p_pie within w_abc_3panels
end type

type ole_skin from w_abc`ole_skin within w_abc_3panels
end type

type uo_h from w_abc`uo_h within w_abc_3panels
end type

type st_box from w_abc`st_box within w_abc_3panels
end type

type phl_logonps from w_abc`phl_logonps within w_abc_3panels
end type

type p_mundi from w_abc`p_mundi within w_abc_3panels
end type

type p_logo from w_abc`p_logo within w_abc_3panels
end type

type dw_master from u_dw_abc within w_abc_3panels
integer x = 498
integer y = 364
integer width = 1125
integer height = 660
integer taborder = 20
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

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_master
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
	
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))

end if
end event

event retrieveend;call super::retrieveend;if idw_1 = this then
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(RowCount))
end if
end event

type dw_detail from u_dw_abc within w_abc_3panels
integer x = 1655
integer y = 364
integer width = 1079
integer height = 660
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor; is_mastdet = 'md'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
 is_dwform = 'tabular' // tabular, grid, form
 
 idw_mst  = dw_master
 idw_det = dw_detdet
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

event ue_insert_pre;call super::ue_insert_pre;Any  la_id
Integer li_x

FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
	la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
	THIS.SetItem(al_row, ii_rk[li_x], la_id)
NEXT
end event

event retrieveend;call super::retrieveend;if idw_1 = this then
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(RowCount))
end if
end event

type st_1 from statictext within w_abc_3panels
integer x = 590
integer y = 180
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar por :"
boolean focusrectangle = false
end type

type uo_filter from cls_vuo_filter within w_abc_3panels
integer x = 914
integer y = 156
integer taborder = 60
boolean bringtotop = true
end type

on uo_filter.destroy
call cls_vuo_filter::destroy
end on

type dw_detdet from u_dw_abc within w_abc_3panels
integer x = 498
integer y = 1152
integer width = 2245
integer height = 692
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                      // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, grid, form
 
idw_mst  = dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;Any  la_id
Integer li_x

FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
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
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(RowCount))
end if
end event

type st_horizontal from statictext within w_abc_3panels
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 498
integer y = 1028
integer width = 745
integer height = 32
boolean bringtotop = true
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
	if ii_modePanels = ii_modetoprightleftbottom then
		if Parent.PointerY() - idrg_topRight.y < cii_MinimunHeight then return -1
	
		if idrg_bottom.y + idrg_bottom.height - &
			Parent.PointerY() < cii_MinimunHeight then return -1

	elseif ii_modePanels = ii_modetopbottomrightleft then

		if Parent.PointerY() - idrg_topLeft.y < cii_MinimunHeight then return -1
	
		if idrg_bottom.y + idrg_bottom.height - &
			Parent.PointerY() < cii_MinimunHeight then return -1

	end if
	
	// Store the previous position.
	li_prevposition = This.Y

	// Refresh the Bar attributes.	
	This.Y = Parent.PointerY()
	
	// Perform redraws when appropriate.
	If Not IsValid(idrg_topleft) or Not IsValid(idrg_topright) Then Return
	If li_prevposition < idrg_topleft.y + idrg_topleft.height Then 
		idrg_topleft.setredraw(true)
		idrg_topright.setredraw(true)
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

event doubleclicked;Long ll_height

ll_height = (parent.workspaceheight( ) - dw_master.Y - st_detdet.height) / 2

if ii_ModePanels = ii_ModeTopRightLeftBottom then
	dw_detail.Y = dw_master.Y
	dw_detdet.X = dw_master.X
	st_vertical.Y = dw_master.Y
	st_horizontal.X = dw_master.X
	
	st_horizontal.Y = dw_master.Y + ll_height - cii_barthickness / 2

elseif ii_ModePanels = ii_ModeTopBottomRightLeft then

	st_horizontal.Y = dw_master.Y + ll_height - cii_barthickness / 2
	
	st_detail.X = dw_master.X
	st_detail.Y = st_horizontal.Y + cii_Barthickness
	
	dw_detail.X = dw_master.X
	dw_detail.y = st_detail.Y + st_detail.height

end if

of_ResizeBars()
of_resizepanels( )
end event

type st_both from statictext within w_abc_3panels
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 1618
integer y = 1020
integer width = 41
integer height = 44
string dragicon = "Exclamation!"
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "SizeNESW!"
long textcolor = 16711680
long backcolor = 16711680
long bordercolor = 16711680
boolean focusrectangle = false
end type

event mousemove;//Check for move in progess
If KeyDown(keyLeftButton!) Then
	st_horizontal.Trigger Event mousemove(flags, xpos, ypos)
	st_vertical.Trigger Event mousemove(flags, xpos, ypos)
	
	// Stretch the Vertical line
	st_vertical.Resize(cii_BarThickness, &
			5 + st_horizontal.Y - st_vertical.Y)
End If







end event

event mouseup;st_vertical.Trigger Event mouseup(flags, xpos, ypos)
st_horizontal.Trigger Event mouseup(flags, xpos, ypos)


end event

event mousedown;This.SetPosition(ToTop!)
If Not ib_debug Then
	// Show Bar2 in Black while being moved.
	st_vertical.BackColor = 0
	st_horizontal.BackColor = 0
End If

end event

event doubleclicked;st_horizontal.event doubleclicked( )
st_vertical.event doubleclicked( )
end event

type st_vertical from statictext within w_abc_3panels
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
event mousedown pbm_lbuttondown
integer x = 1623
integer y = 284
integer width = 27
integer height = 540
string dragicon = "Exclamation!"
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "SizeWE!"
long textcolor = 255
long backcolor = 255
long bordercolor = 276856960
boolean focusrectangle = false
end type

event mousemove;Integer	li_prevposition

If KeyDown(keyLeftButton!) Then
	if ii_modePanels = ii_modetoprightleftbottom then
		// Determinar la mínima altura de los paneles dw_master y dw_detail
		if  idrg_topRight.X + idrg_topRight.width - Parent.PointerX() < cii_MinimunWidth then return -1
	
		if Parent.PointerX() - idrg_topLeft.X < cii_MinimunWidth then return -1

	elseif ii_modePanels = ii_modetopbottomrightleft then
		// Determinar la mínima altura de los paneles dw_master y dw_detail
		if  Parent.PointerX() - idrg_topRight.X  < cii_MinimunWidth then return -1
	
		if idrg_bottom.X + idrg_bottom.width - Parent.PointerX() < cii_MinimunWidth then return -1
	end if
		
	// Store the previous position.
	li_prevposition = This.X

	// Refresh the Bar attributes.
	This.X = Parent.PointerX()
	
	// Perform redraws when appropriate.
	If Not IsValid(idrg_topright) or Not IsValid(idrg_topleft) Then Return
	If li_prevposition > idrg_topright.x Then idrg_topright.setredraw(true)
	If li_prevposition < idrg_topleft.x + idrg_topleft.width Then idrg_topleft.setredraw(true)
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

event doubleclicked;Long ll_width

ll_width = (parent.WorkSpaceWidth( ) - dw_master.X) / 2

if ii_ModePanels = ii_ModeTopRightLeftBottom then
	dw_detail.Y = dw_master.Y
	dw_detdet.X = dw_master.X
	st_vertical.Y = dw_master.Y
	st_horizontal.X = dw_master.X
	
	st_Vertical.X = dw_master.X + ll_width - cii_barthickness / 2
	
elseif ii_ModePanels = ii_modeTopBottomRightLeft then
	
	//st_horizontal.Y = dw_master.Y + ll_height - cii_barthickness / 2
	st_detail.X = dw_master.X
	st_detail.Y = st_horizontal.Y + cii_Barthickness
	
	dw_detail.X = dw_master.X
	dw_detail.y = st_detail.Y + st_detail.height
	
	st_Vertical.X = dw_master.X + ll_width - cii_barthickness / 2
	st_vertical.Y = st_horizontal.Y + cii_barthickness
	
end if

of_ResizeBars()
of_resizepanels( )
end event

type st_master from statictext within w_abc_3panels
integer x = 498
integer y = 276
integer width = 1125
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_abc_3panels
integer x = 1655
integer y = 276
integer width = 1079
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detdet from statictext within w_abc_3panels
integer x = 498
integer y = 1068
integer width = 2245
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

