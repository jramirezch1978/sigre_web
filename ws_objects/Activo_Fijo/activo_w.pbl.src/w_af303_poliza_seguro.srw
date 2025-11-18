$PBExportHeader$w_af303_poliza_seguro.srw
forward
global type w_af303_poliza_seguro from w_abc_mastdet_smpl
end type
type st_campo from statictext within w_af303_poliza_seguro
end type
type dw_1 from datawindow within w_af303_poliza_seguro
end type
end forward

global type w_af303_poliza_seguro from w_abc_mastdet_smpl
integer width = 2642
integer height = 1840
string title = "(AF303) Polizas de Seguros de Activos"
string menuname = "m_master_simple"
long backcolor = 67108864
st_campo st_campo
dw_1 dw_1
end type
global w_af303_poliza_seguro w_af303_poliza_seguro

type variables
Integer ii_dw_upd

string is_codigo

String  is_col = 'cod_activo'
Integer ii_ik[]
sg_parametros ist_datos
end variables

on w_af303_poliza_seguro.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.st_campo=create st_campo
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
end on

on w_af303_poliza_seguro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_1)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

ib_log = TRUE

end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify;call super::ue_modify;integer li_protect 

li_protect = integer(dw_detail.Object.aseguradora.Protect)
if li_protect = 0 then
	dw_detail.Object.aseguradora.Protect = 1
end if 

li_protect = integer(dw_detail.Object.poliza.Protect)
if li_protect = 0 then
	dw_detail.Object.poliza.Protect = 1
end if 

li_protect = integer(dw_detail.Object.seguro_tipo.Protect)
if li_protect = 0 then
	dw_detail.Object.seguro_tipo.Protect = 1
end if 



	

end event

event ue_insert;// Override Ancester
Long   ll_row_master, ll_row, ll_verifica
String ls_clase


dw_detail.accepttext() //accepttext de los dw

CHOOSE CASE idw_1
	CASE dw_detail
	   TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   IF ib_update_check = FALSE THEN RETURN
	  
   CASE ELSE
	  RETURN
	  
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_detail, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_detail.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE
end event

event ue_update;// Override Ancester
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	dw_detail.of_protect( )
	dw_detail.ResetUpdate( )
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_af303_poliza_seguro
integer x = 23
integer y = 236
integer width = 2555
integer height = 560
string dataobject = "dw_lista_maestro_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_dk[1] = 1             // colunmna de pase de parametros



end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::doubleclicked;call super::doubleclicked;if row = 0 then
	
	Integer li_pos, li_col, j
	String  ls_column , ls_report, ls_color
	Long ll_row
	
	li_col = dw_master.GetColumn()
	ls_column = THIS.GetObjectAtPointer()
	
	li_pos = pos(upper(ls_column),'_T')
	
	IF li_pos > 0 THEN
		is_col    = UPPER( mid(ls_column,1,li_pos - 1) )	
		ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
		ls_color  = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
		st_campo.text = "Orden : " + is_col
		dw_1.reset()
		dw_1.InsertRow(0)
		dw_1.SetFocus()
		

		this.setsort(is_col)
		this.sort( )
	ELSE
		ll_row = this.GetRow()
		
		if ll_row > 0 then		
			Any     la_id
			Integer li_x, li_y
			String  ls_tipo
	
			FOR li_x = 1 TO UpperBound(ii_ik)			
				la_id = dw_master.object.data.primary.current[dw_master.getrow(), ii_ik[li_x]]
				// tipo del dato
				ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")
	
				IF LEFT( ls_tipo,1) = 'd' THEN
					ist_datos.field_ret[li_x] = string ( la_id)
				ELSEIF LEFT( ls_tipo,1) = 'c'  THEN
					ist_datos.field_ret[li_x] = la_id
				END IF
				
			NEXT
			
			ist_datos.titulo = "s"		
	
		END IF
	END IF

else
	
	string ls_cod_activo
	ls_cod_activo = this.object.cod_activo[row]
	dw_master.retrieve(ls_cod_activo)
	
end if
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_af303_poliza_seguro
event ue_display ( string as_columna,  long al_row )
integer x = 27
integer y = 848
integer width = 2555
integer height = 732
string dataobject = "dw_poliza_seguro_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE 'aseguradora'
		ls_sql = "select aseguradora as codigo, " &
				  +"descripcion as nombre " &
				  +"from af_aseguradora"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.aseguradora[al_row] = ls_codigo
			This.ii_update = 1
		END IF

	CASE 'seguro_tipo'
		ls_sql = "select seguro_tipo as codigo, " &
				  +"descripcion as nombre " &
				  +"from af_segruo_tipo"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.seguro_tipo[al_row] = ls_codigo
			This.ii_update = 1
		END IF

	CASE 'cod_moneda'
		ls_sql = "select cod_moneda as codigo, " &
				  +"descripcion as nombre " &
				  +"from moneda " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_moneda[al_row] = ls_codigo
			This.ii_update = 1
		END IF

END CHOOSE

end event

event dw_detail::constructor;call super::constructor;//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 6

//Variable de pase de Parametros
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;long ll_reg, ln_item
ln_item = 0 


// Validacion al ingresar un registro
dw_detail.Modify("aseguradora.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("poliza.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("seguro_tipo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("fecha_inicio.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("fecha_termino.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_moneda.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("monto_asegurado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("prima.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("obs.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")

// Numeración automática de items

FOR ll_reg = 1 TO This.RowCount()
	 IF ln_item < This.object.nro_renovacion[ll_reg] THEN
	    ln_item = This.object.nro_renovacion[ll_reg] 
	END IF
NEXT

ln_item = ln_item + 1 
	
This.object.nro_renovacion	[al_row] = ln_item
This.object.flag_estado		[al_row] = '1'
This.object.cod_usr			[al_row] = gs_user



end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 


THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event dw_detail::buttonclicked;call super::buttonclicked;string ls_observacion

ls_observacion = this.object.obs[row]

openwithparm(w_af_observacion,ls_observacion)

if not isnull(Message.StringParm) then
	
	this.object.obs[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if
end event

event dw_detail::itemchanged;call super::itemchanged;String ls_data, ls_null
Date	 ld_fecha1, ld_fecha2, ld_null


SetNull(ls_null)
SetNull(ld_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'aseguradora'
		SELECT descripcion	
		 INTO :ls_data
		FROM af_aseguradora	
		WHERE aseguradora = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.aseguradora		[row] = ls_null
			RETURN 1
		END IF
		
	CASE 'seguro_tipo'
		SELECT descripcion
			INTO :ls_data
		FROM af_segruo_tipo
		WHERE seguro_tipo = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.seguro_tipo	[row] = ls_null
			this.object.descripcion	[row]	= ls_null
			return 1
		END IF
		
		this.object.descripcion[row]	= ls_data
			
		
	CASE 'cod_moneda'
		SELECT descripcion
		  INTO :ls_data
		FROM moneda
		WHERE cod_moneda = :data
		  AND flag_estado = '1';
		 
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'EL CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.cod_moneda	[row] = ls_null
			return 1
		END IF
		
	CASE 'fecha_inicio'
		ld_fecha1 = date(This.object.fecha_inicio[row])
		ld_fecha2 = date(This.object.fecha_termino[row])
		
		IF ld_fecha1 > ld_fecha2 THEN
			messagebox('Error', 'Error en Rango de Fechas')
			This.object.fecha_inicio[row] = ld_null
			RETURN 1
		END IF
		
		
	CASE 'fecha_termino'
		ld_fecha1 = date(This.object.fecha_inicio[row])
		ld_fecha2 = date(This.object.fecha_termino[row])
		
		IF ld_fecha1 > ld_fecha2 THEN
			messagebox('Error', 'Error en Rango de Fechas')
			This.object.fecha_termino[row] = ld_null
			RETURN 1
		END IF

END CHOOSE


end event

event dw_detail::itemerror;call super::itemerror;RETURN 1
end event

type st_campo from statictext within w_af303_poliza_seguro
integer x = 59
integer y = 44
integer width = 1230
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_af303_poliza_seguro
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 59
integer y = 120
integer width = 1230
integer height = 76
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "dw_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_master.triggerevent(doubleclicked!)
Return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()

Return ll_row
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
	
	ls_item = upper( this.GetText() )
//	ls_item = upper( string(data) )

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			this.setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

