$PBExportHeader$w_fi005_matriz_contable.srw
forward
global type w_fi005_matriz_contable from w_abc
end type
type uo_buscar from n_cst_search within w_fi005_matriz_contable
end type
type dw_help from datawindow within w_fi005_matriz_contable
end type
type dw_detail from u_dw_abc within w_fi005_matriz_contable
end type
type dw_master from u_dw_abc within w_fi005_matriz_contable
end type
end forward

global type w_fi005_matriz_contable from w_abc
integer width = 4832
integer height = 2612
string title = "Matriz Contable (FI005)"
string menuname = "m_mantenimiento_sl"
uo_buscar uo_buscar
dw_help dw_help
dw_detail dw_detail
dw_master dw_master
end type
global w_fi005_matriz_contable w_fi005_matriz_contable

type variables

end variables

on w_fi005_matriz_contable.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.uo_buscar=create uo_buscar
this.dw_help=create dw_help
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_buscar
this.Control[iCurrent+2]=this.dw_help
this.Control[iCurrent+3]=this.dw_detail
this.Control[iCurrent+4]=this.dw_master
end on

on w_fi005_matriz_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_buscar)
destroy(this.dw_help)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	  // Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)
dw_help.SetTransObject(sqlca)

dw_master.Retrieve()
dw_help.Retrieve()

idw_1 = dw_master              		  // asignar dw corriente
dw_detail.BorderStyle = StyleRaised!  // indicar dw_detail como no activado

dw_master.of_protect()         		  // bloquear modificaciones 
dw_detail.of_protect()

of_position_window(0,0)       		  // Posicionar la ventana en forma fija
//ii_help = 101           				  // help topic

uo_buscar.event ue_resize(0, uo_buscar.width, uo_buscar.height)
uo_buscar.of_set_dw( dw_master )
end event

event ue_insert;call super::ue_insert;Long    ll_row
Integer li_protect

IF idw_1 = dw_detail  THEN
	IF Isnull(dw_master.Object.matriz[dw_master.il_row]) OR Trim(dw_master.Object.matriz[dw_master.il_row]) = '' THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_insert()



IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event resize;call super::resize;
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()
dw_detail.of_protect()

li_protect = integer(dw_master.Object.matriz.Protect)

IF li_protect = 0 THEN
   dw_master.Object.matriz.Protect = 1
END IF 
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

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

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION 
IF f_row_Processing(dw_master, "tabular") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing(dw_detail, "tabular") <> true then	
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF
	
	
dw_master.of_set_flag_replicacion ()
dw_detail.of_set_flag_replicacion ()

end event

event ue_update;Boolean 	lbo_ok = TRUE
String	ls_matriz
Long 		ll_row

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

if ib_log then
	dw_master.of_create_log()
	dw_detail.of_create_log()
end if

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

if lbo_ok then
	if ib_log then
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	end if
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	if dw_master.RowCount() > 0 then
		ls_matriz = dw_master.object.matriz[dw_master.GetRow()]
	else
		ls_matriz = ''
	end if
	
	dw_master.Retrieve()
	//dw_master.Sort()
	//dw_master.groupCalc()
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	if dw_master.RowCount( ) > 0 then
		
		if ls_matriz = '' then
			ll_row = 1
		else
			ll_row = dw_master.Find("trim(matriz)='" + ls_matriz + "'", 1, dw_master.RowCount())
		end if
		
		if ll_row > 0 then
			dw_master.SetRow(ll_row)
			dw_master.SelectRow( 0, false)
			dw_master.SelectRow(ll_row, true)
			dw_master.ScrollToRow(ll_row)
			
			dw_master.event ue_output( ll_row )
		else
			dw_detail.Reset()
		end if
	else
		dw_detail.Reset()
	end if

	f_mensaje('Grabación realizada satisfactoriamente.', '')
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_open_pos();dwobject dwo


IF dw_master.Rowcount() > 0 THEN
	dw_detail.Retrieve()
	dwo = dw_master.object.matriz
	dw_master.Event Clicked(0,0,1,dwo)
END IF

end event

event ue_insert_pos;call super::ue_insert_pos;//idw_1.SelectRow(0, false)
//idw_1.SelectRow(al_row, true)
//idw_1.setRow(al_row)
////idw_1.scrolltorow( al_row )
//
//if idw_1 = dw_master then
//	idw_1.event ue_output( al_row )
//end if
end event

type uo_buscar from n_cst_search within w_fi005_matriz_contable
integer width = 2592
integer taborder = 30
end type

on uo_buscar.destroy
call n_cst_search::destroy
end on

type dw_help from datawindow within w_fi005_matriz_contable
integer x = 2633
integer width = 2469
integer height = 1712
integer taborder = 20
string dragicon = "Form!"
boolean titlebar = true
string title = "Campo de Ayuda"
string dataobject = "d_abc_dw_campos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event itemerror;Return 1
end event

event itemchanged;Accepttext()
end event

event clicked;IF row > 0 THEN
	This.setrow(row)
	This.drag(begin!)
	This.selectrow(0,false)
	This.selectrow(row,true)
END IF
end event

type dw_detail from u_dw_abc within w_fi005_matriz_contable
integer y = 1732
integer width = 3593
integer height = 584
integer taborder = 20
string dataobject = "d_abc_matriz_cntbl_financiera_det_tbl"
borderstyle borderstyle = styleraised!
end type

event itemchanged;call super::itemchanged;Integer li_count = 0
Accepttext()

CHOOSE CASE dwo.name
		 CASE 'cnta_ctbl'
				SELECT Count(*)
				INTO	 :li_count
				FROM   cntbl_cnta
				WHERE  cnta_ctbl = :data ; 
					
				IF li_count = 0 THEN
					Messagebox('Aviso','Cuenta Contable No existe, Verifique! ',StopSign!)
					This.object.cnta_ctbl [row] = ''
					Return 1
				END IF
END CHOOSE


end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				   // indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	         // columnas que recibimos del master


idw_mst  = dw_master // dw_master

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.matriz		[al_row] = dw_master.object.matriz[dw_master.getRow()]
This.Object.item			[al_row] = al_row
This.Object.flag_docref	[al_row] = 'O'
This.SetColumn('cnta_ctbl')
end event

event dragdrop;call super::dragdrop;Dragobject ldo_control
Long       ll_fila
DataWindow ldw_drag
String 	  ls_desc_campo,ls_tipo,ls_formula,ls_glosa
Boolean 	  lb_result		

ldo_control = DraggedObject()

IF ldo_control.typeof() = Datawindow! THEN
	ldw_drag = ldo_control
	IF ldw_drag.dataobject = 'd_abc_dw_campos_tbl' THEN
		ll_fila = ldw_drag.Getrow()
		IF ll_fila > 0 THEN
			ls_desc_campo = ldw_drag.Object.campo 		[ll_fila]
			ls_tipo		  = ldw_drag.Object.flag_tipo [ll_fila]
			IF row = 0 THEN RETURN
			

			lb_result = This.IsSelected(row)
			IF lb_result THEN  //Selecciona Registro
				IF ls_tipo = 'F' THEN
					ls_formula = This.Object.formula [row]
					IF Isnull(ls_formula) THEN 
						ls_formula = ''
					ELSE
						ls_formula = ls_formula+','
					END IF
					
					ls_formula = ls_formula + ls_desc_campo
					
					This.Object.formula 		[row] = ls_formula
					
				ELSE
					ls_glosa = This.Object.glosa_campo [row]
					IF Isnull(ls_glosa) THEN 
						ls_glosa = ''
					ELSE
						ls_glosa = ls_glosa+','
					END IF
					
					ls_glosa = ls_glosa + ls_desc_campo
					
					This.Object.glosa_campo [row] = ls_glosa
					
				END IF
				
				This.ii_update = 1
				
			ELSE
				Messagebox('Aviso','Debe Seleccionar Registro ')
			END IF
			
		END IF
	END IF
END IF





end event

event ue_display;call super::ue_display;boolean 				lb_ret
string 				ls_codigo, ls_data, ls_sql
str_cnta_cntbl 	lstr_cnta

choose case lower(as_columna)
	case "cnta_ctbl"
		
		lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
		if lstr_cnta.b_return = true then
			this.object.cnta_ctbl [al_row] = lstr_cnta.cnta_cntbl
			this.object.desc_cnta [al_row] = lstr_cnta.desc_cnta
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

type dw_master from u_dw_abc within w_fi005_matriz_contable
integer y = 96
integer width = 2606
integer height = 1616
string dataobject = "d_abc_matriz_financiera_tree"
end type

event itemchanged;call super::itemchanged;Long	ll_row
this.Accepttext()

CHOOSE CASE lower(dwo.name)
	CASE 'matriz'

		if mid(data,1,2) = 'CP' then 
			this.object.titulo	[row] = 'CP - CUENTAS X PAGAR'
		elseif mid(data,1,2) = 'CC' then 
			this.object.titulo	[row] = 'CC - CUENTAS X COBRAR'
		elseif mid(data,1,2) = 'FI' then 
			this.object.titulo	[row] = 'FI - TESORERIA/FINANZAS'
		elseif mid(data,1,2) = 'LP' then 
			this.object.titulo	[row] = 'LP - LETRAS X PAGAR'
		elseif mid(data,1,3) = 'LTC' then 
			this.object.titulo	[row] = 'LTC- LETRAS X COBRAR'
		elseif mid(data,1,2) = 'LC' then 
			this.object.titulo	[row] = 'LC - LIQUIDACION DE COMPRA'
		elseif mid(data,1,2) = 'NI' then 
			this.object.titulo	[row] = 'NI - INGRESO A ALMACEN'
		elseif mid(data,1,2) = 'VS' then 
			this.object.titulo	[row] = 'VS - VALE DE SALIDA'
		elseif mid(data,1,3) = 'LBS' then 
			this.object.titulo	[row] = 'LBS - LIQUIDACION DE BENEFICIOS'
		elseif mid(data,1,3) = 'AF' then 
			this.object.titulo	[row] = 'AF - ACTIVO FIJO'
		else
			this.object.titulo	[row] = 'INDETERMINADO'
		end if
		
		this.Sort()
		this.GroupCalc( )
		
		ll_Row = this.Find("trim(matriz)='" + data + "'", 1, this.Rowcount())
		if ll_row > 0 then
		
			this.SetRow(ll_row)
			this.SelectRow(0, false)
			this.SelectRow(ll_row, true)
			this.ScrollToRow(ll_row)

			this.SetColumn("descripcion")
			
			this.event ue_output(ll_row)			
			
			return 1
		end if
		
		
		
END CHOOSE
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = dw_master	// dw_master
idw_det  = dw_detail	// dw_detail
end event

event ue_output;call super::ue_output;String ls_filtro

if trim(this.object.matriz[al_row]) = '' or IsNull(this.object.matriz[al_row]) then
	ls_filtro = "matriz = ''"
else
	ls_filtro = "matriz = '" + trim(this.object.matriz[al_row]) + "'"
end if


if IsNull(ls_Filtro) then ls_filtro = ' ' 

idw_det.SetFilter(ls_filtro)
idw_det.Filter()

end event

event ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("matriz.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.flag_estado [al_row] = '1'
//this.object.titulo 		[al_row] = '99. RECIEN INGRESADOS'
this.event ue_output(al_row)
this.Sort()
this.SetColumn("matriz")

end event

event ue_insert;//Override
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
	
END IF

RETURN ll_row
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!	
end event

