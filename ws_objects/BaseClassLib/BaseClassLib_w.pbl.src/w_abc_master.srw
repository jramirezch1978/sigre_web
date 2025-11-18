$PBExportHeader$w_abc_master.srw
$PBExportComments$abc para una sola tabla tipo ff, con pop de busqueda
forward
global type w_abc_master from w_abc
end type
type st_filter from statictext within w_abc_master
end type
type uo_filter from cls_vuo_filter within w_abc_master
end type
type dw_master from u_dw_abc within w_abc_master
end type
end forward

global type w_abc_master from w_abc
integer width = 2574
st_filter st_filter
uo_filter uo_filter
dw_master dw_master
end type
global w_abc_master w_abc_master

type variables
String      		is_tabla, is_colname[], is_coltype[]
Boolean				ib_log = FALSE
n_cst_log_diario	in_log
string				is_action
end variables

forward prototypes
public function integer of_set_numera ()
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

on w_abc_master.create
int iCurrent
call super::create
this.st_filter=create st_filter
this.uo_filter=create uo_filter
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_filter
this.Control[iCurrent+2]=this.uo_filter
this.Control[iCurrent+3]=this.dw_master
end on

on w_abc_master.destroy
call super::destroy
destroy(this.st_filter)
destroy(this.uo_filter)
destroy(this.dw_master)
end on

event resize;call super::resize;
dw_master.width  = newwidth  - dw_master.x - cii_WindowBorder
dw_master.height = p_pie.y - dw_master.y - cii_WindowBorder

end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;dw_master.of_protect() 
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

if idw_1.isvaliddataobject( ) then
	is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario
end if

//idw_1.Retrieve()
//ii_help = 101            // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//idw_query = dw_master



end event

event ue_print;call super::ue_print;OpenWithParm(w_print_opt, dw_master)

If Message.DoubleParm = -1 Then Return

dw_master.Print(True)

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;Boolean  lbo_ok = TRUE
String	ls_msg, ls_mensaje

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gnvo_app.is_user, is_tabla, gnvo_app.invo_empresa.is_empresa)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_mensaje = 'No se pudo grabar Maestro, DataWindows: dw_master'
		gnvo_log.of_errorlog(ls_mensaje)
		gnvo_app.of_showMessageDialog(ls_mensaje)
	else
		lbo_ok = this.event ue_post_update_dw( dw_master )
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			ls_mensaje = 'No se pudo grabar el Log Diario del Maestro'
			gnvo_log.of_errorlog(ls_mensaje)
			gnvo_app.of_showMessageDialog(ls_mensaje)
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	this.event ue_update_pos( )
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	END IF
END IF


end event

event ue_open_pos();call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

event ue_close_pre();call super::ue_close_pre;IF ib_log THEN
	DESTROY n_cst_log_diario
END IF

end event

event close;call super::close;Destroy in_log
end event

event ue_duplicar;call super::ue_duplicar;

idw_1.Event ue_duplicar()

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

dw_master.of_set_flag_replicacion()

if of_set_numera	() = 0 then return

ib_update_check = true
end event

event ue_update_pos;call super::ue_update_pos;//Este evento se dispara una vez que la actualización (ue_update) se ha realizado completamente
end event

type p_pie from w_abc`p_pie within w_abc_master
end type

type ole_skin from w_abc`ole_skin within w_abc_master
end type

type uo_h from w_abc`uo_h within w_abc_master
end type

type st_box from w_abc`st_box within w_abc_master
end type

type phl_logonps from w_abc`phl_logonps within w_abc_master
end type

type p_mundi from w_abc`p_mundi within w_abc_master
end type

type p_logo from w_abc`p_logo within w_abc_master
end type

type st_filter from statictext within w_abc_master
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

type uo_filter from cls_vuo_filter within w_abc_master
integer x = 914
integer y = 156
integer taborder = 40
end type

on uo_filter.destroy
call cls_vuo_filter::destroy
end on

type dw_master from u_dw_abc within w_abc_master
integer x = 494
integer y = 272
integer width = 2002
integer height = 1400
boolean bringtotop = true
end type

event clicked;call super::clicked;idw_1 = THIS
end event

event getfocus;call super::getfocus;if this.isvaliddataobject( ) then
	uo_filter.of_set_dw( this )
	uo_filter.of_retrieve_fields( )
	
	uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end if


end event

event retrieveend;call super::retrieveend;uo_h.of_set_title( parent.title + ". Nro de Registros: " + string(this.RowCount()))
end event

