$PBExportHeader$w_fi318_financiamiento.srw
forward
global type w_fi318_financiamiento from w_abc
end type
type tab_1 from tab within w_fi318_financiamiento
end type
type tabpage_1 from userobject within tab_1
end type
type dw_financiamiento_det from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_financiamiento_det dw_financiamiento_det
end type
type tabpage_2 from userobject within tab_1
end type
type dw_tasa_int from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_tasa_int dw_tasa_int
end type
type tab_1 from tab within w_fi318_financiamiento
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_fi318_financiamiento
end type
end forward

global type w_fi318_financiamiento from w_abc
integer width = 3598
integer height = 1824
string title = "Financiamiento (FI318)"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
tab_1 tab_1
dw_master dw_master
end type
global w_fi318_financiamiento w_fi318_financiamiento

type variables
String is_accion
DatawindowChild idw_impuesto


end variables

forward prototypes
public function boolean wf_num_registro (ref string as_num_registro)
public function string wf_verifica_flag_estado ()
public function decimal wf_imp_interes_x_cuota (long al_nro_cuota, long al_row, decimal adc_tasa_interes, date adt_fecha_vcto)
public subroutine wf_total_capital ()
end prototypes

event ue_anular();String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc
Long    ll_row,ll_row_pasiento,ll_inicio,ll_count
Integer li_opcion

dw_master.Accepttext()

ll_row 			 = dw_master.Getrow()

IF ll_row = 0 OR is_accion = 'new' THEN Return 

ls_flag_estado = wf_verifica_flag_estado () 

IF ls_flag_estado <> '1' THEN RETURN //Documento Ha sido Anulado o facturado total parcialmente

IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_financiamiento_det.ii_update = 1 )THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF

li_opcion = MessageBox('Anula Financiamiento','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN

/**/
dw_master.Object.imp_capital [ll_row] = 0.00
dw_master.Object.imp_interes [ll_row] = 0.00

FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_financiamiento_det.Rowcount()
	 tab_1.tabpage_1.dw_financiamiento_det.object.flag_estado		[ll_inicio] = '0' // Anulado	
	 tab_1.tabpage_1.dw_financiamiento_det.object.imp_cuota_capital[ll_inicio] = 0.00
	 tab_1.tabpage_1.dw_financiamiento_det.object.imp_cuota_interes[ll_inicio] = 0.00
	 tab_1.tabpage_1.dw_financiamiento_det.object.imp_impuesto		[ll_inicio] = 0.00
NEXT



dw_master.ii_update = 1
tab_1.tabpage_1.dw_financiamiento_det.ii_update = 1




end event

public function boolean wf_num_registro (ref string as_num_registro);Boolean lb_retorno = TRUE
String  ls_num_registro


SELECT Max(num_registro)
  INTO :ls_num_registro
  FROM financiamiento ;
  
IF Isnull(ls_num_registro)  OR Trim(ls_num_registro) = '' THEN
	ls_num_registro = '0'
END IF
	as_num_registro = f_llena_caracteres('0',Trim(String(Integer(ls_num_registro) + 1)),8)


Return lb_retorno
end function

public function string wf_verifica_flag_estado ();String ls_flag_estado
Long   ll_inicio


IF is_accion = 'new' THEN
	ls_flag_estado = '1' //Generado
ELSEIF is_accion = 'fileopen' THEN
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_financiamiento_det.Rowcount()
		 ls_flag_estado = tab_1.tabpage_1.dw_financiamiento_det.Object.flag_estado [ll_inicio]
		 
		 IF ls_flag_estado <> '1' THEN
	 		 EXIT //Salida
		 END IF
		 
	Next
ELSEIF is_accion = 'delete'	THEN
	ls_flag_estado = '0' //Anulado	
END IF
	
Return ls_flag_estado	
end function

public function decimal wf_imp_interes_x_cuota (long al_nro_cuota, long al_row, decimal adc_tasa_interes, date adt_fecha_vcto);Long        ll_inicio,ll_found,ll_dias
String      ls_expresion
Decimal {2} ldc_imp_impuesto,ldc_importe_capital,ldc_importe_cuota = 0.00, &
			 	ldc_total_cuota = 0.00,ldc_saldo_capital = 0.00
Date        ldt_fecha_vcto,ldt_fecha_anter

ls_expresion = 'num_cuota < '+Trim(String(al_nro_cuota))


ldc_importe_capital = dw_master.object.imp_capital [dw_master.getrow()]


tab_1.tabpage_1.dw_financiamiento_det.SetFilter(ls_expresion)
tab_1.tabpage_1.dw_financiamiento_det.Filter()

FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_financiamiento_det.Rowcount()
	 ldc_importe_cuota = tab_1.tabpage_1.dw_financiamiento_det.Object.imp_cuota_capital [ll_inicio]
	 IF Isnull(ldc_importe_cuota) THEN ldc_importe_cuota = 0.00
	 
	 ldc_total_cuota   = ldc_total_cuota + ldc_importe_cuota
	 
NEXT


/*Filtrar Registros*/
tab_1.tabpage_1.dw_financiamiento_det.SetFilter('')
tab_1.tabpage_1.dw_financiamiento_det.Filter()

/*Ordenar Registros*/
tab_1.tabpage_1.dw_financiamiento_det.SetSort('num_cuota')
tab_1.tabpage_1.dw_financiamiento_det.Sort()

/*Seleccionar registro*/
tab_1.tabpage_1.dw_financiamiento_det.SelectRow(0, FALSE)
tab_1.tabpage_1.dw_financiamiento_det.SelectRow(al_row, TRUE)

/*Busqueda*/
ls_expresion = 'num_cuota = '+Trim(String(al_nro_cuota - 1))
ll_found = tab_1.tabpage_1.dw_financiamiento_det.find(ls_expresion,1 ,tab_1.tabpage_1.dw_financiamiento_det.Rowcount())
IF ll_found > 0 THEN
	/*datos de detalle */
	ldt_fecha_anter = Date(tab_1.tabpage_1.dw_financiamiento_det.object.fecha_vcto [ll_found])
ELSE
	/*datos de cabcera*/
	ldt_fecha_anter = Date(dw_master.object.fecha_emision [dw_master.getrow()])
END IF

/*saldo de capital*/
ldc_saldo_capital = ldc_importe_capital - ldc_total_cuota
ll_dias				= DaysAfter (ldt_fecha_anter,adt_fecha_vcto)



/*Calculo de Importe*/
ldc_imp_impuesto = (((1  + (adc_tasa_interes / 100)) ^ (ll_dias / 360)) - 1) * ldc_saldo_capital






Return ldc_imp_impuesto
end function

public subroutine wf_total_capital ();Long    ll_inicio
Decimal {2} ldc_cuota_interes = 0.00, ldc_monto_interes = 0.00 

FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_financiamiento_det.Rowcount()
    ldc_cuota_interes = tab_1.tabpage_1.dw_financiamiento_det.Object.imp_cuota_interes [ll_inicio]    	
	 IF Isnull(ldc_cuota_interes) THEN ldc_cuota_interes = 0.00
	 ldc_monto_interes = ldc_monto_interes + ldc_cuota_interes
NEXT



dw_master.Object.imp_interes [dw_master.Getrow()] = ldc_monto_interes
dw_master.ii_update = 1
end subroutine

on w_fi318_financiamiento.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_fi318_financiamiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10


dw_master.width  = newwidth  - dw_master.x - 10
tab_1.tabpage_1.dw_financiamiento_det.width  = newwidth  - tab_1.tabpage_1.dw_financiamiento_det.x - 100
tab_1.tabpage_1.dw_financiamiento_det.height = newheight - tab_1.tabpage_1.dw_financiamiento_det.y - 850
tab_1.tabpage_2.dw_tasa_int.height 				= newheight - tab_1.tabpage_2.dw_tasa_int.y - 950

end event

event ue_open_pre();call super::ue_open_pre;String ls_tip_doc

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_financiamiento_det.SetTransObject(sqlca)
tab_1.tabpage_2.dw_tasa_int.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_financiamiento_det.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija





//** Insertamos GetChild de Tipo de Impuesto de tab_1.tabpage_1.dw_financiamiento_det **//
tab_1.tabpage_1.dw_financiamiento_det.Getchild('tipo_impuesto',idw_impuesto)
idw_impuesto.settransobject(sqlca)
idw_impuesto.Retrieve()
//** **//


/*Documento de Financiamiento (FINPARAM)*/
SELECT doc_financiamiento
  INTO :ls_tip_doc
  FROM finparam
 WHERE (reckey = '1' );
 
 
IF Isnull(ls_tip_doc) OR Trim(ls_tip_doc) = '' THEN
   Messagebox('Aviso','Debe Ingresar Tipo de Documento Financiamiento en Archivo de Parametros ')
END IF

TriggerEvent ('ue_insert')
end event

event ue_insert();Long    ll_row,ll_row_master,ll_currow
String  ls_flag_estado
Boolean lb_result
Decimal {2} ldc_imp_capital


CHOOSE CASE idw_1
		 CASE dw_master
				TriggerEvent('ue_update_request')
				idw_1.reset()
				tab_1.tabpage_1.dw_financiamiento_det.Reset()
				is_accion = 'new'				
		
		 CASE tab_1.tabpage_1.dw_financiamiento_det
				ll_row_master = dw_master.getrow()
				IF ll_row_master = 0 THEN RETURN
				
				ldc_imp_capital = dw_master.object.imp_capital [ll_row_master] 
				
				IF Isnull(ldc_imp_capital) OR ldc_imp_capital = 0.00 THEN
					Messagebox('Aviso','Debe Ingresar Importe de Capital ,Verifique!')
					RETURN
				END IF
				
				IF wf_verifica_flag_estado () <> '1' THEN RETURN
				
		 CASE	tab_1.tabpage_2.dw_tasa_int
				ll_currow 		= tab_1.tabpage_1.dw_financiamiento_det.GetRow()
				lb_result 	   = tab_1.tabpage_1.dw_financiamiento_det.IsSelected(ll_currow)
				
				IF wf_verifica_flag_estado () <> '1' THEN RETURN
				
				IF lb_result = FALSE then
					Messagebox('Aviso','Debe Seleccionar Un documento para generar su Respectivo Interes')
					Return
				END IF
				
		 CASE ELSE
				Return
END CHOOSE

ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_delete();//Override
String ls_flag_estado
Long   ll_row

CHOOSE CASE idw_1
		 CASE tab_1.tabpage_1.dw_financiamiento_det,tab_1.tabpage_2.dw_tasa_int
				IF wf_verifica_flag_estado () <> '1' THEN RETURN
				
		 CASE ELSE
				Return
END CHOOSE

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_financiamiento_det.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_financiamiento_det.ii_update = 0
	
	END IF
END IF

end event

event ue_update();Boolean lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_1.dw_financiamiento_det.AcceptText()
tab_1.tabpage_2.dw_tasa_int.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN
	ROLLBACK USING SQLCA;	
	RETURN
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master Financiamiento
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_financiamiento_det.ii_update = 1 AND lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_financiamiento_det.Update() = -1 then		// Grabacion del detalle Financiamiento
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_2.dw_tasa_int.ii_update = 1 AND lbo_ok = TRUE then
	IF tab_1.tabpage_2.dw_tasa_int.uPDATE() = -1 THEN
		lbo_ok = FALSE
		messagebox("Error en Grabacion Detalle Interes","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_financiamiento_det.ii_update = 0
	tab_1.tabpage_2.dw_tasa_int.ii_update 				= 0
	
	IF is_accion = 'new' THEN is_accion = 'fileopen'
	TriggerEvent('ue_modify')
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_update_pre();String		ls_origen,ls_num_registro,ls_flag_estado
Decimal {2} ldc_imp_cuota_capital
Long        ll_inicio



//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing( tab_1.tabpage_1.dw_financiamiento_det, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


/*Datos de Cabecera*/
ls_num_registro = dw_master.object.num_registro 	[1]
ls_origen		 = dw_master.object.origen				[1]
/**/

ls_flag_estado = wf_verifica_flag_estado ()




IF is_accion = 'new' THEN
	IF wf_num_registro (ls_num_registro) = FALSE THEN
		Messagebox('Aviso','No se pudo Asignar Nro de Registro Verifique')	
		ib_update_check = FALSE
		RETURN
	ELSE
		dw_master.object.num_registro [1] = ls_num_registro
	END IF
	
END IF




IF ls_flag_estado = '1' THEN

	/*Verifica Monto de Cuota*/
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_financiamiento_det.Rowcount()
		 ldc_imp_cuota_capital = tab_1.tabpage_1.dw_financiamiento_det.Object.imp_cuota_capital [ll_inicio]
		 IF Isnull(ldc_imp_cuota_capital) OR ldc_imp_cuota_capital = 0 THEN
			 Messagebox('Aviso','Importe de Cuota debe ser Mayor que  0')
			 tab_1.tabpage_1.dw_financiamiento_det.SetFocus()
			 tab_1.tabpage_1.dw_financiamiento_det.Setrow(ll_inicio)
			 tab_1.tabpage_1.dw_financiamiento_det.SetColumn('imp_cuota_capital')
			 ib_update_check = False	
			 Return
		 END IF		 
	Next
END IF

IF tab_1.tabpage_1.dw_financiamiento_det.Rowcount() = 0 THEN
		Messagebox('Aviso','Debe Ingresar Cuotas de Financiamiento')		
		ib_update_check = FALSE
		RETURN	
END IF

	
	
///Documento de Referencia
FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_financiamiento_det.Rowcount()
	 tab_1.tabpage_1.dw_financiamiento_det.object.origen       [ll_inicio] = ls_origen
	 tab_1.tabpage_1.dw_financiamiento_det.object.num_registro [ll_inicio] = ls_num_registro
NEXT

////Detalle de Interes
FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_tasa_int.Rowcount()
	 tab_1.tabpage_2.dw_tasa_int.object.origen    		  [ll_inicio] = ls_origen
	 tab_1.tabpage_2.dw_tasa_int.object.num_registro	  [ll_inicio] = ls_num_registro
NEXT


end event

event ue_retrieve_list();//override
// Asigna valores a structura 
Long 	 ll_row
String ls_periodo

str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1     = 'd_abc_lista_financiamiento_tbl'
sl_param.titulo  = 'Finanaciamiento'
sl_param.field_ret_i[1] = 1   //origen
sl_param.field_ret_i[2] = 2	//num registro

OpenWithParm( w_search_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	tab_1.tabpage_1.dw_financiamiento_det.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	tab_1.tabpage_2.dw_tasa_int.retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	
	is_accion 			 = 'fileopen'
	TriggerEvent('ue_modify')

END IF

end event

event ue_modify();call super::ue_modify;
Long   ll_row
Int 	 li_protect
String ls_flag_estado

ll_row = dw_master.Getrow()
IF ll_row = 0 THEN RETURN

dw_master.of_protect()
tab_1.tabpage_1.dw_financiamiento_det.of_protect()
tab_1.tabpage_2.dw_tasa_int.of_protect()

ls_flag_estado = wf_verifica_flag_estado ()

IF ls_flag_estado <> '1' THEN //Documento Ha sido Anulado o facturado
	dw_master.ii_protect = 0
	tab_1.tabpage_1.dw_financiamiento_det.ii_protect = 0
	tab_1.tabpage_2.dw_tasa_int.ii_protect	= 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_financiamiento_det.of_protect()
	tab_1.tabpage_2.dw_tasa_int.of_protect()
ELSE
	IF is_accion <> 'new' THEN
		li_protect = integer(dw_master.Object.cod_relacion.Protect)
		IF li_protect = 0	THEN
			dw_master.object.cod_relacion.Protect = 1
		END IF
	END IF	
END IF


end event

type tab_1 from tab within w_fi318_financiamiento
integer x = 32
integer y = 720
integer width = 3506
integer height = 900
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3470
integer height = 780
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_financiamiento_det dw_financiamiento_det
end type

on tabpage_1.create
this.dw_financiamiento_det=create dw_financiamiento_det
this.Control[]={this.dw_financiamiento_det}
end on

on tabpage_1.destroy
destroy(this.dw_financiamiento_det)
end on

type dw_financiamiento_det from u_dw_abc within tabpage_1
integer x = 9
integer y = 12
integer width = 3461
integer height = 728
integer taborder = 20
string dataobject = "d_abc_financiamiento_det_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;IF Getrow() = 0 THEN Return
String 	  		ls_name,ls_prot
str_parametros	sl_param
Datawindow		ldw	
ls_name =  dwo.name
ls_prot    =  this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
    return
end if


CHOOSE CASE dwo.name
		 CASE 'confin'
				sl_param.tipo			= ''
				sl_param.opcion		= 3
				sl_param.titulo 		= 'Selección de Concepto Financiero'
				sl_param.dw_master	= 'd_lista_grupo_financiero_grd'
				sl_param.dw1			= 'd_lista_concepto_financiero_grd'
				sl_param.dw_m			=  This
				OpenWithParm( w_abc_seleccion_md, sl_param)
				IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
				IF sl_param.titulo = 's' THEN
					This.ii_update = 1
					
				END IF
		CASE 'fecha_vcto'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
		CASE 'fecha_pago_int'	
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
END CHOOSE

end event

event itemchanged;Accepttext()
String 		ls_matriz_cntbl,ls_flag_signo,ls_tipo_impuesto
Decimal {2}	ldc_tasa_interes,ldc_imp_capital,ldc_imp_interes,ldc_tasa_impuesto,&
			   ldc_imp_impuesto
Long        ll_row_child,ll_nro_cuota
Date			ldt_fecha_vcto


CHOOSE CASE dwo.name
		 CASE 'confin'
				SELECT matriz_cntbl
				  INTO :ls_matriz_cntbl
				  FROM concepto_financiero
				 WHERE (confin = :data ) ;
				 
				IF Isnull(ls_matriz_cntbl) OR Trim(ls_matriz_cntbl) = '' THEN
					This.object.confin 		 [row] = ''
					This.object.matriz_cntbl [row] = ''
					Messagebox('Aviso','Concepto Financiero No Existe , Verifique!')
					Return 1
				ELSE
					This.object.matriz_cntbl [row] = ls_matriz_cntbl
				END IF
		 				
		 CASE 'imp_cuota_capital','tasa_interes','tipo_impuesto','fecha_vcto'

				ll_nro_cuota	  = This.Object.num_cuota	 	 	 [row]
				ldt_fecha_vcto	  = Date(This.Object.fecha_vcto	 [row])
				ls_tipo_impuesto = This.Object.tipo_impuesto 	 [row]
				ldc_imp_capital  = This.Object.imp_cuota_capital [row]
				ldc_tasa_interes = This.Object.tasa_interes 		 [row]

				
				IF Not(Isnull(ls_tipo_impuesto) OR ls_tipo_impuesto = '' ) THEN
			   	ll_row_child = idw_impuesto.Getrow()
 			   	ldc_tasa_impuesto = idw_impuesto.GetitemNumber(ll_row_child,'tasa_impuesto')
					ls_flag_signo		= idw_impuesto.GetitemString(ll_row_child,'signo')
			   	ldc_imp_impuesto  = Round((ldc_imp_capital * ldc_tasa_impuesto) / 100 ,2)	
					This.Object.signo 		[row] = ls_flag_signo
			   END IF
				
 		 	   This.Object.imp_impuesto 		[row] = ldc_imp_impuesto


				 
				ldc_imp_interes = wf_imp_interes_x_cuota (ll_nro_cuota,row,ldc_tasa_interes,ldt_fecha_vcto)
		 		This.Object.imp_cuota_interes [row] = ldc_imp_interes				 

				wf_total_capital ()
				
				
END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = dw_master		// dw_master
idw_det  = tab_1.tabpage_1.dw_financiamiento_det			// dw_detail
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.num_cuota   [al_row] = al_row
This.Object.flag_estado [al_row] = '1' //Generado
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;SelectRow(0, FALSE)
SelectRow(currentrow, TRUE)
end event

event ue_delete_pos();call super::ue_delete_pos;Long ll_inicio

For ll_inicio = 1 TO This.Rowcount()
	 This.Object.num_cuota [ll_inicio] = ll_inicio
Next
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3470
integer height = 780
long backcolor = 79741120
string text = "Intereses Mora"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_tasa_int dw_tasa_int
end type

on tabpage_2.create
this.dw_tasa_int=create dw_tasa_int
this.Control[]={this.dw_tasa_int}
end on

on tabpage_2.destroy
destroy(this.dw_tasa_int)
end on

type dw_tasa_int from u_dw_abc within tabpage_2
integer x = 14
integer y = 16
integer width = 1463
integer height = 756
integer taborder = 20
string dataobject = "d_abc_financiamiento_interes_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1	// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4

ii_rk[1] = 1  // columnas que recibimos del master
ii_rk[2] = 2  



idw_mst  = dw_master 						// dw_master
idw_det  = tab_1.tabpage_2.dw_tasa_int	// dw_detail
end event

event itemchanged;call super::itemchanged;Accepttext()
String ls_tiint,ls_cuota,ls_expresion
Long   ll_found



CHOOSE CASE dwo.name
		 CASE 'tipo_interes'
				ls_cuota      = Trim(String(This.Object.num_cuota [row]))
				ls_expresion = 'num_cuota = ' + ls_cuota + ' and '+'tipo_interes = '+"'"+data+"'"
				ll_found 	 = This.find(ls_expresion ,1, This.rowcount())				

				IF Not(ll_found = row OR ll_found = 0 ) THEN
					Messagebox('Aviso','Nro de Cuota ya Tiene Considerado Tipo de Interes, Verifique!')
					SetNull(ls_tiint)
					This.Object.tipo_interes [row] = ls_tiint
					Return 1
				END IF		
		
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_currow,ll_num_cuota

ll_currow 	 = tab_1.tabpage_1.dw_financiamiento_det.GetRow()
ll_num_cuota = tab_1.tabpage_1.dw_financiamiento_det.Object.num_cuota [ll_currow]

This.Object.num_cuota [al_row] = ll_num_cuota
This.Object.item		 [al_row] = al_row
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_fi318_financiamiento
integer x = 5
integer width = 3186
integer height = 684
string dataobject = "d_abc_financiamiento_cab_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;String ls_nom_proveedor,lc_cod_moneda
Date   ld_fecha_emision

Accepttext()

CHOOSE CASE dwo.name
		 CASE	'fecha_emision'
				ld_fecha_emision = Date(This.object.fecha_emision [row])
				This.object.tasa_cambio [row] = gnvo_app.of_tasa_cambio (ld_fecha_emision)						
		 CASE	'cod_ctabco'
				SELECT cod_moneda
				  INTO :lc_cod_moneda
				  FROM banco_cnta
				 WHERE (cod_ctabco = :data ) ;
				 
				 
				 This.Object.cod_moneda [row] = lc_cod_moneda
				 
		 CASE 'cod_relacion','cod_aval'
				SELECT nom_proveedor
				  INTO :ls_nom_proveedor
				  FROM proveedor
				 WHERE (proveedor = :data ) ;
				 
				 IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
					 Messagebox('Aviso','Codigo No Existe Verifique')
					 
					 IF dwo.name = 'cod_relacion' THEN
						 This.Object.cod_relacion  [row] = ''
						 This.Object.nom_proveedor [row] = ''
					 ELSEIF dwo.name = 'cod_aval' THEN
						 This.Object.cod_aval 	   [row] = ''
						 This.Object.nom_aval 	   [row] = ''
					 END IF	
					 
					 Return 1
				 ELSE
					IF dwo.name = 'cod_relacion' THEN
						 This.Object.nom_proveedor [row] = ls_nom_proveedor
					 ELSEIF dwo.name = 'cod_aval' THEN
						 This.Object.nom_aval 	   [row] = ls_nom_proveedor
					 END IF	
				 END IF
			
END CHOOSE

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String 	  		 ls_name,ls_prot
Str_seleccionar lstr_seleccionar
ls_name =  dwo.name
ls_prot    =  this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
    return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_relacion','cod_aval'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
								   					 +'PROVEEDOR.EMAIL			  AS EMAIL '&
									   				 +'FROM PROVEEDOR'

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				
				IF lstr_seleccionar.s_action = "aceptar" THEN
					IF dwo.name = 'cod_relacion' THEN
						Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
						Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					ELSEIF dwo.name = 'cod_aval' THEN
						Setitem(row,'cod_aval',lstr_seleccionar.param1[1])
						Setitem(row,'nom_aval',lstr_seleccionar.param2[1])
					END IF
					ii_update = 1
					
				END IF		
END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst  = dw_master					// dw_master
idw_det  = tab_1.tabpage_1.dw_financiamiento_det // dw_detail
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.object.origen 		  [al_row] = gs_origen
This.object.fecha_emision [al_row] = f_fecha_actual ()
This.object.cod_usr		  [al_row] = gs_user 	
end event

