$PBExportHeader$w_cn002_plan_cuentas.srw
forward
global type w_cn002_plan_cuentas from w_abc_master_tab
end type
type dw_5 from u_dw_abc within tabpage_3
end type
type st_1 from statictext within w_cn002_plan_cuentas
end type
type uo_search from n_cst_search within w_cn002_plan_cuentas
end type
end forward

global type w_cn002_plan_cuentas from w_abc_master_tab
integer width = 3296
integer height = 2500
string title = "Plan de Cuentas (CN002)"
string menuname = "m_abc_master_smpl"
st_1 st_1
uo_search uo_search
end type
global w_cn002_plan_cuentas w_cn002_plan_cuentas

type variables
String 	is_cuenta, is_cuenta_new
String 	is_col
Integer 	ii_grf_val_index = 4, ii_min_height = 800

		
u_dw_abc 	idw_datos_cnta, idw_flags_cnta, idw_automaticas
end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_datos_cnta = tab_1.tabpage_1.dw_1
idw_flags_cnta = tab_1.tabpage_2.dw_2
idw_automaticas = tab_1.tabpage_3.dw_5
end subroutine

on w_cn002_plan_cuentas.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.st_1=create st_1
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.uo_search
end on

on w_cn002_plan_cuentas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;//of_position_window(0,0)


ib_log = TRUE

of_asigna_dws()

idw_1 = idw_datos_cnta
idw_1.setFocus()

idw_datos_cnta.setTransObject(SQLCA)
idw_flags_cnta.setTransObject(SQLCA)
idw_automaticas.setTransObject(SQLCA)


//Recuperando datos del Maestro
dw_master.Retrieve()

uo_search.of_set_dw( dw_master )

idw_datos_cnta.ii_protect = 0
idw_flags_cnta.ii_protect = 0
idw_automaticas.ii_protect = 0

idw_datos_cnta.of_protect()
idw_flags_cnta.of_protect()
idw_automaticas.of_protect()
end event

event ue_update;// Override
String ls_flag_estado, ls_cuenta
Integer li_ano, li_mes
Boolean lbo_ok = TRUE
//

of_asigna_dws()

idw_datos_cnta.AcceptText( )
idw_automaticas.AcceptText( )

// Para el log diario
IF ib_log THEN
	idw_datos_cnta.of_create_log( )
	idw_automaticas.of_create_log( )
END IF

IF idw_datos_cnta.ii_update = 1 or idw_flags_cnta.ii_update = 1 THEN
	IF idw_datos_cnta.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion en master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_automaticas.ii_update = 1 THEN
	IF idw_automaticas.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Automáticas","Se ha procedido al rollback",exclamation!)
	END IF
END IF

//Para el log diario
IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = idw_datos_cnta.of_save_log()
	END IF
	
	IF lbo_ok THEN
		lbo_ok = idw_automaticas.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_datos_cnta.ii_update 	= 0
	
	idw_flags_cnta.ii_update 	= 0
	idw_automaticas.ii_update 	= 0
	
	idw_datos_cnta.ResetUpdate()
	idw_flags_cnta.ResetUpdate()
	idw_automaticas.ResetUpdate()
	
	dw_master.Retrieve()

	
	f_mensaje('Grabación realizada satisfactoriamente', '')
ELSE
	ROLLBACK USING SQLCA;
END IF
end event

event ue_dw_share;// Override
// Compartir el dw_master con dws secundarios

Integer li_share_status

of_asigna_dws()

li_share_status = idw_datos_cnta.ShareData (idw_flags_cnta)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con idw_flags_cnta",exclamation!)
	RETURN
END IF

end event

event resize;integer li_height

of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

li_height  = newheight / 2 - dw_master.y - 10 + 200
if li_height  < ii_min_height then
	li_height = ii_min_height 
end if

dw_master.height = li_height

st_1.width = dw_master.width
uo_search.width  = dw_master.width
uo_search.event ue_resize( sizetype, dw_master.width, newheight)

tab_1.y = dw_master.y + dw_master.height + 10
tab_1.width = newwidth - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_datos_cnta.width = tab_1.tabpage_1.width - idw_datos_cnta.x - 10
idw_datos_cnta.height = tab_1.tabpage_1.height - idw_datos_cnta.y - 10


idw_flags_cnta.width = tab_1.tabpage_2.width - idw_flags_cnta.x - 10
idw_flags_cnta.height = tab_1.tabpage_2.height - idw_flags_cnta.y - 10

idw_automaticas.width = tab_1.tabpage_3.width - idw_automaticas.x - 10
idw_automaticas.height = tab_1.tabpage_3.height - idw_automaticas.y - 10




end event

event ue_retrieve_dddw();call super::ue_retrieve_dddw;DataWindowChild	dwc_dddw

tab_1.tabpage_1.dw_1.GetChild ("cod_moneda", dwc_dddw)
dwc_dddw.SetTransObject (sqlca)
dwc_dddw.Retrieve ()

tab_1.tabpage_1.dw_1.GetChild ("clase_segui", dwc_dddw)
dwc_dddw.SetTransObject (sqlca)
dwc_dddw.Retrieve ()
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores

if gnvo_app.of_row_Processing( idw_flags_cnta ) <> true then return
if gnvo_app.of_row_Processing( idw_datos_cnta ) <> true then return
if gnvo_app.of_row_Processing( idw_automaticas ) <> true then return

idw_flags_cnta.of_set_flag_replicacion()
idw_automaticas.of_set_flag_replicacion()

ib_update_check = true

end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (idw_datos_cnta.ii_update = 1 or idw_automaticas.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_datos_cnta.ii_update = 0
		idw_automaticas.ii_update = 0
	END IF
END IF

end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	//in_log = Create n_cst_log_diario
	//in_log.of_dw_map(tab_1.tabpage_1.dw_1, is_colname_d, is_coltype_d)
	//in_log.of_dw_map(tab_1.tabpage_2.dw_2, is_colname_r, is_coltype_r)
	//in_log.of_dw_map(tab_1.tabpage_3.dw_5, is_colname_a, is_coltype_a)
END IF
end event

event ue_insert;//Override
Long  ll_row

if idw_1 = dw_master or idw_1 = idw_flags_cnta then
	MessageBox('Error', 'No esta permitido insertar registros en este panel', StopSign!)
	return
	
elseif idw_1 = idw_automaticas then
	
	if idw_automaticas.RowCount() > 0 then
		if MessageBox('Aviso', 'Ya existe un registro en Cuentas Automaticas, desea insertar otro Registro?', &
							Information!, YesNo!, 2) = 2 then
			return
		end if
		
		idw_automaticas.ii_update = 0
		idw_automaticas.Reset()
		idw_automaticas.ResetUpdate()
					
	end if
else
	idw_flags_cnta.ii_update = 0
	idw_flags_cnta.ii_protect = 1
	idw_flags_cnta.of_protect()
	
	idw_datos_cnta.Reset()
	idw_datos_cnta.ii_update = 0
	idw_datos_cnta.ResetUpdate()
	
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	

	
	IF ll_row <> -1 then
		THIS.EVENT ue_insert_pos(ll_row)
	end if

	
end if









end event

event ue_modify;//Overide

idw_datos_cnta.of_protect()
idw_flags_cnta.of_protect()
idw_automaticas.of_protect()
end event

type dw_master from w_abc_master_tab`dw_master within w_cn002_plan_cuentas
integer y = 180
integer width = 1641
integer height = 1220
string dataobject = "d_cntbl_cnta_tbl"
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  tab_1.tabpage_3.dw_3
end event

event dw_master::ue_output;Long ll_row

ll_row = this.GetRow()
if ll_row = 0 then return

// Recuperando los datos de los tabs y las cuentas automaticas
idw_automaticas.Reset()
idw_automaticas.ii_update = 0
idw_automaticas.Resetupdate()


idw_datos_cnta.Reset()
idw_datos_cnta.ii_update = 0
idw_datos_cnta.Resetupdate()


idw_datos_cnta.Retrieve(this.object.cnta_ctbl [al_row])
idw_automaticas.Retrieve(this.object.cnta_ctbl [al_row])
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)


end event

event type integer dw_master::ue_delete_pre();call super::ue_delete_pre;
// Chequeando si tiene referencia en cntbl_ctas_aut
Long ln_count, ln_row
String ls_cuenta, ls_cnta_ctbl

ln_row = dw_master.GetRow()
If ln_row > 0 then
	ls_cuenta=dw_master.GetItemString( ln_row, 'cnta_ctbl' )
	// Chequeando cnta_cntbl

	select count(*) into :ln_count 
	from cntbl_ctas_aut
	where cnta_ctbl=:ls_cuenta ;
	
	if ln_count>0 then
		messagebox('Error', 'Existe en cuentas automaticas')
	end if
	// Chequeando cnta_debe
	ln_count=0
	select count(*), cnta_cntbl into :ln_count, :ls_cnta_ctbl
	from cntbl_ctas_aut
	where cnta_debe=:ls_cuenta 
	group by cnta_cntbl;
	if ln_count>0 then
		messagebox('Error', 'Existe en cuentas automaticas, ver ' + ls_cnta_ctbl )
	end if
	// Chequeando cnta_haber
	ln_count=0
	select count(*), cnta_cntbl into :ln_count, :ls_cnta_ctbl
	from cntbl_ctas_aut
	where cnta_haber=:ls_cuenta 
	group by cnta_cntbl;
	if ln_count>0 then
		messagebox('Error', 'Existe en cuentas automaticas, ver ' + ls_cnta_ctbl )
	end if
end if

return 1
end event

type tab_1 from w_abc_master_tab`tab_1 within w_cn002_plan_cuentas
event create ( )
event destroy ( )
integer x = 0
integer y = 1416
integer width = 3067
integer height = 780
integer textsize = -8
integer weight = 700
end type

on tab_1.create
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
call super::destroy
end on

event tab_1::selectionchanged;call super::selectionchanged;if newindex = 2 then
	idw_flags_cnta.setFocus()
	idw_flags_cnta.setColumn("flag_permite_mov")
end if
end event

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer y = 104
integer width = 3031
integer height = 660
string text = "Datos de la Cuenta"
long tabtextcolor = 16711680
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer width = 2981
integer height = 648
string dataobject = "d_cntbl_cnta_ff"
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_1::constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//idw_mst  = dw_master
//idw_det  =  				// dw_detail
end event

event dw_1::ue_insert_pre;call super::ue_insert_pre;idw_automaticas.ii_update = 0
idw_automaticas.Reset()
idw_automaticas.ResetUpdate()
		
this.object.cod_usr 			[al_row] = gs_user
this.object.fecha_creacion	[al_row] = gnvo_app.of_fecha_Actual()
this.object.flag_estado		[al_row] = '1'
this.object.flag_cod_segui	[al_row] = '1'
this.object.flag_doc_ref2	[al_row] = '1'
this.object.flag_doc_ref	[al_row] = '1'
this.object.flag_codrel		[al_row] = '1'
this.object.flag_ajuste		[al_row] = '1'
this.object.cod_moneda		[al_row] = gnvo_app.is_soles
end event

event dw_1::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_1::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_1::itemchanged;call super::itemchanged;//

String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'desc_cnta'
		
		// Verifica que codigo ingresado exista			
		this.object.abrev_cnta	[row] = mid(ls_data, 1, 25)


END CHOOSE
end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
integer y = 104
integer width = 3031
integer height = 660
string text = "Flag"
long tabtextcolor = 16711680
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer y = 0
integer width = 2798
integer height = 524
string dataobject = "d_cntbl_cnta_1_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_2::constructor;call super::constructor;
is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
idw_mst  = dw_master
//dw_2.object.cnta_ajuste.protect = 0
end event

event dw_2::itemchanged;call super::itemchanged;String ls_flag_ajuste, ls_cuenta
this.ii_update = 1
CHOOSE CASE dwo.name
	CASE 'flag_ajuste'
		ls_flag_ajuste = DATA
		If ls_flag_ajuste = '1' Then
			dw_2.object.cnta_ctbl_ajuste.protect = 0
			ls_cuenta = dw_master.GetItemString(dw_master.GetRow(),"cnta_ctbl")
			dw_2.Setitem(row,'cnta_ctbl_ajuste', ls_cuenta)
      else
			dw_2.object.cnta_ctbl_ajuste.protect = 1
			dw_2.Setitem(row,'cnta_ctbl_ajuste', '')
		End if	
END CHOOSE		
end event

event dw_2::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_2.Setitem( al_row, 'flag_estado', '1' )
dw_2.Setitem( al_row, 'flag_permite_mov', '1' )
dw_2.Setitem( al_row, 'flag_ctabco', '0' )
dw_2.Setitem( al_row, 'flag_cencos', '0' )
dw_2.Setitem( al_row, 'flag_cod_segui', '0' )
dw_2.Setitem( al_row, 'flag_doc_ref', '0' )
dw_2.Setitem( al_row, 'flag_doc_ref2', '0' )
dw_2.Setitem( al_row, 'flag_codrel', '0' )
dw_2.Setitem( al_row, 'flag_labor', '0' )
dw_2.Setitem( al_row, 'flag_ajuste', '0' )

end event

event dw_2::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_2::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
integer y = 104
integer width = 3031
integer height = 660
string text = "Automáticas"
long tabtextcolor = 16711680
dw_5 dw_5
end type

on tabpage_3.create
this.dw_5=create dw_5
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_5
end on

on tabpage_3.destroy
call super::destroy
destroy(this.dw_5)
end on

type dw_3 from w_abc_master_tab`dw_3 within tabpage_3
boolean visible = false
integer width = 87
integer height = 80
boolean livescroll = false
end type

event dw_3::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
boolean visible = false
integer y = 104
integer width = 3031
integer height = 660
boolean enabled = false
string text = ""
end type

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
boolean visible = false
integer width = 64
integer height = 92
end type

event dw_4::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_5 from u_dw_abc within tabpage_3
integer width = 2789
integer height = 420
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cntbl_ctas_aut_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = dw_master

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;//String ls_cnta_cntbl

if dw_master.GetRow() > 0 then
//	ls_cnta_cntbl = dw_master.GetItemString( dw_master.GetRow(), 'cnta_ctbl' )
//	this.SetItem(al_row, 'cnta_cntbl', ls_cnta_cntbl)
	this.SetItem(al_row, 'item', 1)
end if

end event

event itemchanged;call super::itemchanged;String ls_descrip

this.AcceptText()

CHOOSE CASE dwo.name
	CASE 'cnta_debe'
		select desc_cnta 
			into :ls_descrip
		from cntbl_cnta 
		where cnta_ctbl = :data 
		  and flag_estado = '1'
		  and niv_cnta 	= 5;
		
		If SQLCA.SQLCode = 100 then
			ROLLBACK;
			messagebox('Aviso', 'Cuenta contable ' + data + ' no existe o no esta activa o no pertenece al nivel 5, por favor verifique!', StopSign!)
			this.object.cnta_debe 		[row] = gnvo_app.is_null
			this.object.desc_cnta_debe [row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_cnta_debe [row] = ls_descrip
		
		this.ii_update = 1
		
	CASE 'cnta_haber'
		select desc_cnta 
			into :ls_descrip
		from cntbl_cnta 
		where cnta_ctbl = :data 
		  and flag_estado = '1'
		  and niv_cnta 	= 5;
		
		If SQLCA.SQLCode = 100 then
			ROLLBACK;
			messagebox('Aviso', 'Cuenta contable ' + data + ' no existe o no esta activa o no pertenece al nivel 5, por favor verifique!', StopSign!)
			this.object.cnta_haber 			[row] = gnvo_app.is_null
			this.object.desc_cnta_haber 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_cnta_haber [row] = ls_descrip
		
		this.ii_update = 1
END CHOOSE
end event

event ue_display;call super::ue_display;str_cnta_cntbl 	lstr_cnta

choose case lower(as_columna)
	case "cnta_debe"
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			
			this.object.cnta_debe 		[al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta_debe [al_row] = lstr_cnta.desc_cnta
			
			this.ii_update = 1
		end if
		
	case "cnta_haber"
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then

			this.object.cnta_haber 			[al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta_haber 	[al_row] = lstr_cnta.desc_cnta
			
			this.ii_update = 1
		end if


end choose

end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_1 from statictext within w_cn002_plan_cuentas
integer width = 3008
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "D A T O S  G E N E R A L E S"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_search from n_cst_search within w_cn002_plan_cuentas
event destroy ( )
integer y = 92
integer width = 1769
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

