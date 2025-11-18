$PBExportHeader$w_cn002_plan_cuentas.srw
forward
global type w_cn002_plan_cuentas from w_abc_master_tab
end type
type dw_5 from u_dw_abc within tabpage_3
end type
type st_1 from statictext within w_cn002_plan_cuentas
end type
type dw_text from datawindow within w_cn002_plan_cuentas
end type
type st_campo from statictext within w_cn002_plan_cuentas
end type
end forward

global type w_cn002_plan_cuentas from w_abc_master_tab
integer width = 3081
integer height = 2380
string title = "Plan de Cuentas (CN002)"
string menuname = "m_master_simple"
st_1 st_1
dw_text dw_text
st_campo st_campo
end type
global w_cn002_plan_cuentas w_cn002_plan_cuentas

type variables
String is_cuenta, is_cuenta_new
String is_col
Integer ii_grf_val_index = 4, ii_min_height = 800

// Para el registro del Log
string 	is_tabla_d, is_colname_d[], is_coltype_d[], &
			is_tabla_r, is_colname_r[], is_coltype_r[], &
			is_tabla_a, is_colname_a[], is_coltype_a[]
			
u_dw_abc 	idw_datos_cnta, idw_flags_cnta, idw_automaticas
end variables

on w_cn002_plan_cuentas.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_1=create st_1
this.dw_text=create dw_text
this.st_campo=create st_campo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.st_campo
end on

on w_cn002_plan_cuentas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.st_campo)
end on

event ue_open_pre;call super::ue_open_pre;//of_position_window(0,0)


ib_log = TRUE
//is_tabla 	= 'Cntbl_cnta'
is_tabla_d 	= 'Cntbl_cnta'
is_tabla_r 	= 'Cntbl_cnta'
is_tabla_a 	= 'Cntbl_cta_aut'

//Recuperando datos del Maestro
idw_1.Retrieve()
//Activando Shared
tab_1.tabpage_1.dw_1.enabled = TRUE
tab_1.tabpage_2.dw_2.enabled = TRUE
//Activando los no Shared
Tab_1.tabpage_3.dw_5.SettransObject(SQLCA)
end event

event ue_update;// Override
String ls_flag_estado, ls_cuenta
Integer li_ano, li_mes
Boolean lbo_ok = TRUE
//
dw_master.AcceptText( )
tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_2.dw_2.AcceptText()
tab_1.tabpage_3.dw_5.AcceptText()

// Para el log diario
IF ib_log THEN
	dw_master.of_Create_log( )
	tab_1.tabpage_1.dw_1.of_Create_log()
	tab_1.tabpage_2.dw_2.of_Create_log()
	tab_1.tabpage_3.dw_5.of_Create_log()
END IF

IF dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion en master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF tab_1.tabpage_1.dw_1.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_1.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion en tabpage1","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF tab_1.tabpage_2.dw_2.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_2.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion en tabpage1","Se ha procedido al rollback",exclamation!)
	END IF
END IF
IF tab_1.tabpage_3.dw_5.ii_update = 1 THEN
	IF tab_1.tabpage_3.dw_5.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

//Para el log diario
IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log( )
		tab_1.tabpage_1.dw_1.of_save_log()
		tab_1.tabpage_2.dw_2.of_save_log()
		tab_1.tabpage_3.dw_5.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_1.ii_update = 0
	tab_1.tabpage_2.dw_2.ii_update = 0
	tab_1.tabpage_3.dw_5.ii_update = 0
	
	dw_master.ResetUpdate( )
	tab_1.tabpage_1.dw_1.ResetUpdate()
	tab_1.tabpage_2.dw_2.ResetUpdate()
	tab_1.tabpage_3.dw_5.ResetUpdate()
END IF
end event

event ue_dw_share();// Override
// Compartir el dw_master con dws secundarios

Integer li_share_status

li_share_status = dw_master.ShareData (tab_1.tabpage_1.dw_1)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW1",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_2.dw_2)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW2",exclamation!)
	RETURN
END IF
end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect = dw_master.Describe("cnta_ctbl.protect")
If ls_protect = '0' Then
   dw_master.object.cnta_ctbl.protect = 1
End if	



end event

event resize;integer li_height

idw_datos_cnta = tab_1.tabpage_1.dw_1
idw_flags_cnta = tab_1.tabpage_2.dw_2
idw_automaticas = tab_1.tabpage_3.dw_5

dw_master.width  = newwidth  - dw_master.x - 10

li_height  = newheight / 2 - dw_master.y - 10 + 200
if li_height  < ii_min_height then
	li_height = ii_min_height 
end if

dw_master.height = li_height

tab_1.y = dw_master.y + dw_master.height + 10
tab_1.width = newwidth - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_datos_cnta.width = tab_1.width - idw_datos_cnta.x - 50
idw_datos_cnta.height = tab_1.height - idw_datos_cnta.y - 120


idw_flags_cnta.width = tab_1.width - idw_flags_cnta.x - 50
idw_flags_cnta.height = tab_1.height - idw_flags_cnta.y - 120

idw_automaticas.width = tab_1.width - idw_automaticas.x - 50
idw_automaticas.height = tab_1.height - idw_automaticas.y - 120

///!!!@@@ OVERRIDE @@@!!!///
//dw_master.height = newheight - dw_master.y - tab_1.height - ( 10 * 10 )
//tab_1.y = dw_master.y + dw_master.height + 10 

/*
if newheight > tab_1.height + 10 then 
   tab_1.y = newheight - tab_1.height - 10 
   dw_master.height = tab_1.y - dw_master.y - ( 10 * 3 )
   dw_master.width = newwidth - 10 
   tab_1.width = newwidth - 10 
   tab_1.tabpage_1.dw_1.width = newwidth - 10 - 10 - 10
   tab_1.tabpage_2.dw_2.width = newwidth - 10 - 10 - 10
   tab_1.tabpage_3.dw_3.width = newwidth - 10 - 10 - 10
   tab_1.tabpage_3.dw_5.width = newwidth - 10 - 10 - 10
else
	newheight = tab_1.height + 10 
end if 
*/
end event

event ue_retrieve_dddw();call super::ue_retrieve_dddw;DataWindowChild	dwc_dddw

tab_1.tabpage_1.dw_1.GetChild ("cod_moneda", dwc_dddw)
dwc_dddw.SetTransObject (sqlca)
dwc_dddw.Retrieve ()

tab_1.tabpage_1.dw_1.GetChild ("clase_segui", dwc_dddw)
dwc_dddw.SetTransObject (sqlca)
dwc_dddw.Retrieve ()
end event

event ue_update_pre;call super::ue_update_pre;tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_2.dw_2.AcceptText()
tab_1.tabpage_3.dw_5.AcceptText()

dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_1.of_set_flag_replicacion()
tab_1.tabpage_2.dw_2.of_set_flag_replicacion()
tab_1.tabpage_3.dw_5.of_set_flag_replicacion()

end event

event ue_update_request();Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 or tab_1.tabpage_3.dw_5.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_1.ii_update = 0
		tab_1.tabpage_2.dw_2.ii_update = 0
		tab_1.tabpage_3.dw_5.ii_update = 0
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

type dw_master from w_abc_master_tab`dw_master within w_cn002_plan_cuentas
integer y = 252
integer width = 2999
integer height = 1200
string dataobject = "d_cntbl_cnta_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
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

event dw_master::ue_output(long al_row);call super::ue_output;//Messagebox('Aviso', 'Reset de cuentas automaticas')
tab_1.tabpage_3.dw_5.Reset()

THIS.EVENT ue_retrieve_det(al_row)
//ScrolltoRow para leer Shared
tab_1.tabpage_1.dw_1.ScrollToRow(al_row)
tab_1.tabpage_2.dw_2.ScrollToRow(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;//Recuperar los DataWindows no Shared
tab_1.tabpage_3.dw_5.retrieve(aa_id[1])
end event

event dw_master::doubleclicked;call super::doubleclicked;Datawindow ldw
ldw = This

Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF


/*
IF dwo.type <> 'column' THEN RETURN 1
CHOOSE CASE dwo.name
	CASE 'fecha_creacion'
		   f_call_calendar(ldw,'fecha_creacion',dwo.coltype,row)
END CHOOSE		
*/



end event

event dw_master::clicked;call super::clicked;Long ll_row

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
ib_log = TRUE
//is_tabla = 'CNTBL_CTAS'	// nombre de tabla para el Log
tab_1.enabled=true

// Recuperando los datos de los tabs y las cuentas automaticas
ll_row = this.GetRow()
tab_1.tabpage_3.dw_5.Reset()
THIS.EVENT ue_retrieve_det(ll_row)
//ScrolltoRow para leer Shared
tab_1.tabpage_1.dw_1.ScrollToRow(ll_row)
tab_1.tabpage_2.dw_2.ScrollToRow(ll_row)


end event

event dw_master::itemchanged;call super::itemchanged;Long ll_count
Integer li_longitud, li_nivel, li_digito[10], li
String ls_cuenta_ant, ls_flag_estado, ls_status, ls_master, ls_cuenta, ls_cuenta_exi
CHOOSE CASE dwo.name
	CASE 'cnta_ctbl'
		
	   ls_cuenta = DATA
      SELECT count(*)
        INTO :ll_count
        FROM cntbl_cnta
        WHERE cnta_ctbl = :ls_cuenta;
		  
	   li_longitud = LEN(ls_cuenta_exi)
      IF ll_count > 0 Then
			MessageBox("Mensaje al Usuario","Cuenta ya existe")
			dw_master.Setitem(dw_master.il_row,'cnta_ctbl','')
	      w_cn002_plan_cuentas.Menuid.item[1].item[1].item[5].enabled = FALSE
			tab_1.tabpage_1.enabled = FALSE
			tab_1.tabpage_2.enabled = FALSE
			tab_1.tabpage_3.enabled = FALSE
			dw_master.object.desc_cnta.protect=1
			dw_master.object.abrev_cnta.protect=1
			dw_master.object.fecha_creacion.protect=1
			dw_master.object.flag_estado.protect=1
			dw_master.SetColumn(10)
		/*
		Else
		   //Seleccionamos Niveles de la Tabla
         Select cp.nivel1, cp.nivel2, cp.nivel3, cp.nivel4,
                cp.nivel5, cp.nivel6, cp.nivel7, cp.nivel8,
			       cp.nivel9, cp.nivel10
		      Into :li_digito[1], :li_digito[2], :li_digito[3],
		           :li_digito[4], :li_digito[5], :li_digito[6],
		       	  :li_digito[7], :li_digito[8], :li_digito[9],
		           :li_digito[10]
            From cntblparam cp
            Where cp.reckey = '1';
		    //Leemos longitud de la cuenta cargada 
		    li_longitud = LEN(DATA)
		    ls_status = '0'		
		    If li_longitud = 1 Then
			    ls_status = '1'
			    ls_master = '1'
			    w_cn002_plan_cuentas.Menuid.item[1].item[1].item[5].enabled = TRUE
		    End if	
	 	    If li_longitud > 1 Then
		       //Leemos numero de digitos de nivel anterior
		       For li = 1 TO 10
			        If li_digito[li] = li_longitud Then
			           ls_status = '1'
			           li_longitud = li_digito[li - 1]
			           li_nivel = li
				        exit				
			        End if
		      End For	
		    End if	
		    //Si semaforo esta prendido ingresamos
          If ls_status = '1' Then
		       //Asignamos a variable digitos de nivel anterior
		       is_cuenta = MID(DATA,1,li_longitud)
			    //Unicamos cuenta si existe en tabla
             SELECT cnta_ctbl, flag_estado
	            INTO :ls_cuenta_ant, :ls_flag_estado
	            FROM cntbl_cnta
	            WHERE cnta_ctbl = :is_cuenta;
		       li_longitud = LEN(ls_cuenta_ant)
			    //Si longitud es 1
			    If ls_master = '1' Then
			       li_longitud = 1
			    End If
			    //Si cuenta existe
		       IF li_longitud = 0 THEN
			       MessageBox("Mensaje al Usuario","Cuenta no existe")
				    w_cn002_plan_cuentas.Menuid.item[1].item[1].item[5].enabled = FALSE
			       tab_1.tabpage_1.enabled = FALSE
			       tab_1.tabpage_2.enabled = FALSE
			       tab_1.tabpage_3.enabled = FALSE
			       dw_master.object.desc_cnta.protect=1
			       dw_master.object.abrev_cnta.protect=1
			       dw_master.object.fecha_creacion.protect=1
			       dw_master.object.flag_estado.protect=1
			       dw_master.SetColumn(10)
			       RETURN 0
		       ELSE
				    w_cn002_plan_cuentas.Menuid.item[1].item[1].item[5].enabled = TRUE
			       tab_1.tabpage_1.enabled = TRUE
			       tab_1.tabpage_2.enabled = TRUE
			       tab_1.tabpage_3.enabled = TRUE
			       dw_master.object.desc_cnta.protect=0
			       dw_master.object.abrev_cnta.protect=0
			       dw_master.object.fecha_creacion.protect=0
			       dw_master.object.flag_estado.protect=0
			       tab_1.tabpage_1.dw_1.Setitem(tab_1.tabpage_1.dw_1.GetRow(),"niv_cnta",li_nivel)
			       is_cuenta_new = DATA
		       END IF	
		    End If
		*/
		End if		 
END CHOOSE		
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;tab_1.tabpage_1.enabled = FALSE
tab_1.tabpage_2.enabled = FALSE
tab_1.tabpage_3.enabled = FALSE
dw_master.Setitem(al_row,'fecha_creacion',Today())
dw_master.ii_update = 1
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
integer x = 0
integer y = 1472
integer width = 2921
integer height = 696
integer textsize = -8
integer weight = 700
end type

event tab_1::selectionchanged;call super::selectionchanged;tab_1.enabled=true
end event

event tab_1::clicked;call super::clicked;tab_1.enabled=true
tab_1.tabpage_1.enabled = TRUE
tab_1.tabpage_2.enabled = TRUE
tab_1.tabpage_3.enabled = TRUE

end event

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer y = 104
integer width = 2885
integer height = 576
string text = "Datos de la Cuenta"
long tabtextcolor = 16711680
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer y = 0
integer width = 2793
integer height = 416
string dataobject = "d_cntbl_cnta_ff"
boolean livescroll = false
end type

event dw_1::constructor;call super::constructor;tab_1.enabled=true
//tab_1.tabpage_1.enabled = TRUE
//tab_1.tabpage_2.enabled = TRUE
//tab_1.tabpage_3.enabled = TRUE

is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
idw_mst  = dw_master
//idw_det  =  				// dw_detail
end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
integer y = 104
integer width = 2885
integer height = 576
string text = "Flag"
long tabtextcolor = 16711680
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer y = 0
integer width = 2798
integer height = 524
string dataobject = "d_cntbl_cnta_1_tbl"
boolean livescroll = false
end type

event dw_2::constructor;call super::constructor;tab_1.enabled=true
//tab_1.tabpage_1.enabled = TRUE
//tab_1.tabpage_2.enabled = TRUE
//tab_1.tabpage_3.enabled = TRUE

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

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
integer y = 104
integer width = 2885
integer height = 576
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
boolean enabled = false
boolean livescroll = false
end type

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
boolean visible = false
integer y = 104
integer width = 2885
integer height = 576
boolean enabled = false
end type

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
boolean visible = false
integer width = 64
integer height = 92
boolean enabled = false
end type

type dw_5 from u_dw_abc within tabpage_3
integer width = 2789
integer height = 420
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_cntbl_ctas_aut_ff"
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = dw_master

end event

event clicked;call super::clicked;tab_1.enabled=true
//tab_1.tabpage_1.enabled = TRUE
//tab_1.tabpage_2.enabled = TRUE
//tab_1.tabpage_3.enabled = TRUE
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
ib_log = True
//is_tabla = 'Cntbl_ctas_aut'

end event

event doubleclicked;call super::doubleclicked;// Ventanas de ayuda
IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cencos'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cnta_debe'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_debe',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cnta',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'cnta_haber'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
														 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
														 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
														 +'FROM CNTBL_CNTA ' 
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_haber',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cnta_1',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF

END CHOOSE

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;//String ls_cnta_cntbl

if dw_master.GetRow() > 0 then
//	ls_cnta_cntbl = dw_master.GetItemString( dw_master.GetRow(), 'cnta_ctbl' )
//	this.SetItem(al_row, 'cnta_cntbl', ls_cnta_cntbl)
	this.SetItem(al_row, 'item', 1)
end if

end event

event itemchanged;call super::itemchanged;String ls_descrip
Long ll_found
ll_found = 0
CHOOSE CASE dwo.name
		 CASE 'cnta_debe'
				select count(*), desc_cnta into :ll_found, :ls_descrip
				from cntbl_cnta where cnta_ctbl = :data 
				group by desc_cnta ;
				If ll_found = 0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					return 1
				end if
				this.SetItem( row, 'desc_cnta', ls_descrip )
				ii_update = 1
		 CASE 'cnta_haber'
				select count(*), desc_cnta into :ll_found, :ls_descrip
				from cntbl_cnta where cnta_ctbl = :data 
				group by desc_cnta ;
				If ll_found = 0 then
					messagebox('Aviso', 'Cuenta contable no existe')
					return 1
				end if
				this.SetItem( row, 'desc_cnta_1', ls_descrip )
				ii_update = 1
END CHOOSE
end event

type st_1 from statictext within w_cn002_plan_cuentas
integer x = 1266
integer y = 52
integer width = 1394
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "D A T O S  G E N E R A L E S"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_cn002_plan_cuentas
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 59
integer y = 132
integer width = 1143
integer height = 92
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_master.triggerevent(doubleclicked!)
return 1

end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg
ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			this.SetFocus()
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type st_campo from statictext within w_cn002_plan_cuentas
integer x = 69
integer y = 56
integer width = 974
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Orden:"
boolean focusrectangle = false
end type

