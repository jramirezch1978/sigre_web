$PBExportHeader$w_cn932_valoriz_almac.srw
forward
global type w_cn932_valoriz_almac from w_prc
end type
type st_5 from statictext within w_cn932_valoriz_almac
end type
type sle_2 from singlelineedit within w_cn932_valoriz_almac
end type
type sle_1 from singlelineedit within w_cn932_valoriz_almac
end type
type cb_cancelar from commandbutton within w_cn932_valoriz_almac
end type
type cb_procesar from commandbutton within w_cn932_valoriz_almac
end type
type st_3 from statictext within w_cn932_valoriz_almac
end type
type st_2 from statictext within w_cn932_valoriz_almac
end type
type st_1 from statictext within w_cn932_valoriz_almac
end type
type r_1 from rectangle within w_cn932_valoriz_almac
end type
end forward

global type w_cn932_valoriz_almac from w_prc
integer width = 1582
integer height = 1104
string title = "Re valorizacion de almacenes (CN932)"
event ue_proceso ( boolean ab_test )
st_5 st_5
sle_2 sle_2
sle_1 sle_1
cb_cancelar cb_cancelar
cb_procesar cb_procesar
st_3 st_3
st_2 st_2
st_1 st_1
r_1 r_1
end type
global w_cn932_valoriz_almac w_cn932_valoriz_almac

event ue_proceso(boolean ab_test);/*
Datastore	lds_mov, lds_matriz, lds_as, lds_as_det
String		ls_oper[], ls_mat_cntbl, ls_filter
String		ls_operacion, ls_cuenta, ls_cuenta_ref, ls_cod_moneda, ls_descripcion, ls_glosa
String		ls_cod_ctabco, ls_desc_proceso, ls_win, ls_glosa_texto, ls_glosa_campo, ls_cnta
String		ls_cnta_ctbl, ls_cnta_ctbl_sfl, ls_flag_dehab, ls_campo, ls_formula
String		ls_flag_lucro, ls_nota, ls_sol
Date			ld_fecha, ld_inicio, ld_final, ld_valuta
DateTime		ldt_hoy
Long			ll_count, ll_mov, ll_x, ll_y, ll_z, ll_row, ll_rc, ll_dias, ll_procesos
Long			ll_cod_banco, ll_matriz
Decimal		ldc_importe, ldc_tasa, ldc_saldo, ldc_movsol, ldc_movdol, ldc_movaju
Decimal		ldc_totsoldeb, ldc_totsolhab, ldc_totdoldeb, ldc_totdolhab, ldc_tasa_cambio
Double		ldb_nro_cheque, ldb_nro_oper, ldb_nro_proceso
Integer		li_nlib, li_test
n_cst_asiento_glosa	nv_2

nv_2 = CREATE n_cst_asiento_glosa

cb_cancelar.enabled = False
ld_inicio = uo_fechas.of_get_fecha1()
ld_final  = uo_fechas.of_get_fecha2()
ldt_hoy    = DateTime(Today(), Now())

// Verificar si no se esta duplicando el proceso de notas de ingreso - almacen
SELECT Max("OPER_PROCESOS"."FECHA_OBJ_FINAL"), COUNT(*)
  INTO :ld_fecha, :ll_count
  FROM "OPER_PROCESOS"  
 WHERE ( "OPER_PROCESOS"."COD_PROCESO" = 'STKI' ) AND  
       ( "OPER_PROCESOS"."FLAG_REVERSION" = '0');

IF RelativeDate(ld_fecha, 1) <> ld_inicio AND ll_count > 0 THEN
	MessageBox('Error', 'Este rango de fechas ya fue procesado')
	IF NOT ab_test THEN GOTO SALIDA2
END IF





/*
//Carga de Codigos de Operacion a Contabilizar
ll_rc = of_get_lista_oper(ls_oper)
IF ll_rc < 0 THEN GOTO SALIDA1

//Carga de Codigos Moneda Sol
ll_rc = of_get_parametros(ls_sol)
IF ll_rc < 0 THEN GOTO SALIDA1

//Crear Datastores
lds_mov = CREATE Datastore      // Movimientos Generados
lds_mov.Dataobject = 'd_oper_diario_cajero'
lds_mov.SetTransObject(SQLCA)

lds_matriz = CREATE Datastore      // Matriz de de la Operacion
lds_matriz.Dataobject = 'd_matriz_cntbl_oper_det'
lds_matriz.SetTransObject(SQLCA)
ll_rc = lds_matriz.Retrieve()

lds_as = CREATE Datastore          // Pre Asiento
lds_as.Dataobject = 'd_cntbl_pre_asiento'
lds_as.SetTransObject(SQLCA)

lds_as_det = CREATE Datastore      // Pre Asiento Det
lds_as_det.Dataobject = 'd_cntbl_pre_asiento_det'
lds_as_det.SetTransObject(SQLCA)

//	Registrar Proceso de Contabilizacion
IF NOT ab_test THEN
	n_cst_log_proceso		nv_1           // Grabar el log en Oper_Procesos
	nv_1 = Create n_cst_log_proceso
	ls_desc_proceso = 'Contabilizacion Operaciones de Cajero'
	ls_win = THIS.ClassName()
	ldb_nro_proceso = nv_1.of_set_log(ld_inicio, ld_final,'COCJ',ls_win,ls_desc_proceso, &
	                                  '1',gs_user)
	DESTROY n_cst_log_proceso
END IF
	
// Funcion PLSQL para Insetar Cabecera de Asiento Provisional
DECLARE pb_ingreso_pre_asiento PROCEDURE FOR USF_INGRESO_PRE_ASIENTO(:gs_origen, :li_nlib,
        :ls_cod_moneda, :ldc_tasa, :ls_nota, :ldb_nro_proceso, :ls_descripcion, :ld_fecha, 
		  :ldt_hoy, :gs_user) ;

// Proceso Contabilizacion
ll_procesos = DaysAfter(ld_inicio, ld_final) + 1  
ld_fecha = ld_inicio

FOR ll_y = 1 TO ll_procesos								// uno x dia de rango digitado
	ll_mov = lds_mov.Retrieve(ld_fecha,ls_oper)
	IF ll_mov < 1 THEN CONTINUE
	ldc_tasa_cambio = of_get_cambio_sbs(ld_fecha)
	IF ldc_tasa_cambio = 0 THEN ldc_tasa_cambio = 1

	FOR ll_x = 1 TO ll_mov									// uno x moviento
		ls_operacion   = lds_mov.GetItemString(ll_x, 'operacion')
		ld_valuta      = Date(lds_mov.GetItemDateTime(ll_x, 'fecha_valuta'))
		ls_cuenta      = lds_mov.GetItemString(ll_x, 'cuenta')
		ls_cuenta_ref  = lds_mov.GetItemString(ll_x, 'cuenta_ref')
		ll_cod_banco   = lds_mov.GetItemNumber(ll_x, 'cod_banco')
		ls_cod_moneda  = lds_mov.GetItemString(ll_x, 'cod_moneda')
		ls_descripcion = lds_mov.GetItemString(ll_x, 'descripcion')
		ldc_saldo      = lds_mov.GetItemDecimal(ll_x, 'saldo')		
		ldc_tasa       = lds_mov.GetItemDecimal(ll_x, 'tasa')
		ls_cod_ctabco  = lds_mov.GetItemString(ll_x, 'cod_ctabco')
		ldb_nro_cheque = lds_mov.GetItemNumber(ll_x, 'nro_cheque')
		ls_flag_lucro  = lds_mov.GetItemString(ll_x, 'flag_sin_fines_lucro')
		li_nlib        = lds_mov.GetItemNumber(ll_x, 'nro_libro')
		ls_mat_cntbl   = lds_mov.GetItemString(ll_x, 'matriz_ctbl')
		ls_filter = "matriz_ctbl = '" + ls_mat_cntbl + " '"
		ll_rc = lds_matriz.SetFilter(ls_filter)
		ll_rc = lds_matriz.Filter()
		ll_matriz = lds_matriz.RowCount()
		IF ll_matriz < 1 THEN CONTINUE
		
		IF ab_test THEN
			ldb_nro_oper = ll_x
		ELSE
			EXECUTE pb_ingreso_pre_asiento ;             // Grabacion de pre Asiento 
      	FETCH pb_ingreso_pre_asiento INTO :ldb_nro_oper ;
			CLOSE pb_ingreso_pre_asiento ;
			IF ldb_nro_oper < 1 THEN
				MessageBox('Error DB', 'En Grabacion Cabecera de Asiento Pre')
				GOTO SALIDA1
			END IF
		END IF
		
		FOR ll_z = 1 TO ll_matriz							// uno x Detalle de Matriz
			ll_row = lds_as_det.InsertRow(0)
			IF ll_row < 1 THEN GOTO SALIDA1
			ls_cnta_ctbl     = lds_matriz.GetItemString(ll_z, 'cnta_ctbl')
			ls_cnta_ctbl_sfl = lds_matriz.GetItemString(ll_z, 'cnta_ctbl_sfl')
			ls_flag_dehab    = lds_matriz.GetItemString(ll_z, 'flag_debe_haber')
			ls_campo         = lds_matriz.GetItemString(ll_z, 'campo')
			ls_formula       = lds_matriz.GetItemString(ll_z, 'formula')
			ls_glosa_texto   = lds_matriz.GetItemString(ll_z, 'glosa_texto')
			ls_glosa_campo   = lds_matriz.GetItemString(ll_z, 'glosa_campo')
			IF ls_flag_lucro = '1' THEN  
				ls_cnta = ls_cnta_ctbl_sfl             // Cuenta Sin Fines de Lucro
			ELSE
				ls_cnta = ls_cnta_ctbl
			END IF
			IF Len(ls_campo) > 1 THEN              // verificacion existencia de campo
				li_test = Integer(lds_mov.Describe(ls_campo + '.ID'))
				IF li_test < 1 THEN
					MessageBox('Error', 'El Campo :' + ls_campo + ' No existe')
					GOTO SALIDA1
				END IF
				ldc_importe    = lds_mov.GetItemDecimal(ll_x, ls_campo)
			ELSE
				IF Len(ls_formula) > 1 THEN           
					ldc_importe = of_set_importe(ls_formula, lds_mov, ll_x)  // uso formula
				ELSE
					ldc_importe = 0
				END IF
			END IF

			IF ls_cod_moneda = ls_sol THEN
				ldc_movsol = ldc_importe
				ldc_movdol = ldc_importe / ldc_tasa_cambio
			ELSE
				ldc_movdol = ldc_importe
				ldc_movsol = ldc_importe * ldc_tasa_cambio
			END IF

			IF Upper(ls_flag_dehab) = 'D' THEN               // debe o haber
				ldc_totsoldeb = ldc_totsoldeb + ldc_movsol
				ldc_totdoldeb = ldc_totdoldeb + ldc_movdol
			ELSE
				ldc_totsolhab = ldc_totsolhab + ldc_movsol
				ldc_totdolhab = ldc_totdolhab + ldc_movdol
			END IF
			ls_glosa = nv_2.of_set_glosa(lds_mov, ll_x, ls_glosa_texto, ls_glosa_campo)
//			ls_glosa = of_set_glosa(ls_glosa_texto, ls_glosa_campo, lds_mov, ll_x)
			ll_rc = lds_as_det.SetItem( ll_row, 'cod_origen', gs_origen)
			ll_rc = lds_as_det.SetItem( ll_row, 'nro_libro', li_nlib)
			ll_rc = lds_as_det.SetItem( ll_row, 'nro_provisional', ldb_nro_oper)
			ll_rc = lds_as_det.SetItem( ll_row, 'item', ll_z)
			ll_rc = lds_as_det.SetItem( ll_row, 'cnta_ctbl', ls_cnta)
			ll_rc = lds_as_det.SetItem( ll_row, 'fec_cntbl', ld_fecha)
			ll_rc = lds_as_det.SetItem( ll_row, 'det_glosa', ls_glosa)
			ll_rc = lds_as_det.SetItem( ll_row, 'flag_gen_aut', '1')
			ll_rc = lds_as_det.SetItem( ll_row, 'flag_debhab', ls_flag_dehab)
			ll_rc = lds_as_det.SetItem( ll_row, 'cod_ctabco', ls_cod_ctabco)
			ll_rc = lds_as_det.SetItem( ll_row, 'imp_movsol', ldc_movsol)
			ll_rc = lds_as_det.SetItem( ll_row, 'imp_movdol', ldc_movdol)
		NEXT
	NEXT
	ld_fecha = RelativeDate(ld_fecha, 1)
NEXT

IF ab_test THEN
	f_view_data(lds_mov, 'Movimientos',3100,1500)
	f_view_data(lds_as_det, 'Asientos',3100,1500)
ELSE
	ll_rc = lds_as_det.Update()                // Grabacion de Detalle de Asiento
	IF ll_rc = -1 THEN
		ROLLBACK ;
  		MessageBox('Error', 'Grabacion de Asiento Det')
	ELSE
		COMMIT ;
		MessageBox('Fin de Proceso', 'Proceso Concluido Satisfactoriamente')
		CB_CANCELAR.EVENT POST clicked()
	END IF
END IF

SALIDA1:
DESTROY	lds_mov
DESTROY	lds_matriz
DESTROY	lds_as
DESTROY	lds_as_det
*/
SALIDA2:
cb_cancelar.enabled = TRUE
DESTROY n_cst_asiento_glosa
*/
end event

on w_cn932_valoriz_almac.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_2=create sle_2
this.sle_1=create sle_1
this.cb_cancelar=create cb_cancelar
this.cb_procesar=create cb_procesar
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_2
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_procesar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.r_1
end on

on w_cn932_valoriz_almac.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.cb_cancelar)
destroy(this.cb_procesar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.r_1)
end on

event open;call super::open;String ls_ano, ls_mes, ls_nro_libro

ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )
					
sle_1.text = ls_ano
sle_2.text = ls_mes

end event

event ue_open_pre();call super::ue_open_pre;of_position_window(50,50)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

end event

type st_5 from statictext within w_cn932_valoriz_almac
integer x = 174
integer y = 180
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingresos y salidas"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_cn932_valoriz_almac
integer x = 891
integer y = 496
integer width = 187
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_cn932_valoriz_almac
integer x = 891
integer y = 404
integer width = 187
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn932_valoriz_almac
integer x = 919
integer y = 732
integer width = 302
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;Close(Parent)
end event

type cb_procesar from commandbutton within w_cn932_valoriz_almac
integer x = 293
integer y = 732
integer width = 302
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;string  ls_ano, ls_mes, ls_fecha, ls_msj
Long ll_ano, ll_mes

cb_procesar.enabled = false
sle_1.enabled = false
sle_2.enabled = false

ls_ano = sle_1.text
ls_mes = sle_2.text
ll_ano = LONG(ls_ano)
ll_mes = LONG(ls_mes)

DECLARE PB_USP_CNT_ACT_VALOR_ARTICULO PROCEDURE FOR USP_CNT_ACT_VALOR_ARTICULO ( 
   :ll_ano, :ll_mes ) ;
execute PB_USP_CNT_ACT_VALOR_ARTICULO  ;

IF sqlca.sqlcode = -1 Then
	ls_msj = sqlca.sqlerrtext
	rollback ;
	MessageBox( 'Error', ls_msj, StopSign! )
	MessageBox( 'Error', "Procedimiento <<USP_CNT_VALOR_ALM>> no concluyo correctamente", StopSign! )
ELSE
	commit ;
	MessageBox( 'Mensaje', "Proceso terminado" )
End If

cb_procesar.enabled = true
sle_1.enabled = true
sle_2.enabled = true

end event

type st_3 from statictext within w_cn932_valoriz_almac
integer x = 448
integer y = 492
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn932_valoriz_almac
integer x = 448
integer y = 400
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn932_valoriz_almac
integer x = 105
integer y = 72
integer width = 1362
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valorizacion de movimiento de almacenes"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cn932_valoriz_almac
integer linethickness = 1
long fillcolor = 12632256
integer x = 366
integer y = 332
integer width = 805
integer height = 308
end type

