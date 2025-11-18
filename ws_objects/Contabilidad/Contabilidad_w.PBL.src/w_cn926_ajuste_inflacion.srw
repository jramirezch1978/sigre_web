$PBExportHeader$w_cn926_ajuste_inflacion.srw
forward
global type w_cn926_ajuste_inflacion from w_prc
end type
type st_2 from statictext within w_cn926_ajuste_inflacion
end type
type st_1 from statictext within w_cn926_ajuste_inflacion
end type
type sle_ano from singlelineedit within w_cn926_ajuste_inflacion
end type
type sle_mes from singlelineedit within w_cn926_ajuste_inflacion
end type
type cb_reporte from commandbutton within w_cn926_ajuste_inflacion
end type
type cb_cancelar from commandbutton within w_cn926_ajuste_inflacion
end type
type cb_aceptar from commandbutton within w_cn926_ajuste_inflacion
end type
type st_titulo from statictext within w_cn926_ajuste_inflacion
end type
end forward

global type w_cn926_ajuste_inflacion from w_prc
integer width = 1271
integer height = 904
string title = "Ajuste por Inflacion"
string menuname = "m_prc"
boolean resizable = false
string icon = "Database!"
event ue_proceso ( boolean ab_test )
st_2 st_2
st_1 st_1
sle_ano sle_ano
sle_mes sle_mes
cb_reporte cb_reporte
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_titulo st_titulo
end type
global w_cn926_ajuste_inflacion w_cn926_ajuste_inflacion

type variables
Datastore	ids_tasas
end variables

forward prototypes
public function long of_get_nro_asiento (integer ai_libro, integer ai_mes, integer ai_ano, ref double adb_nro_asiento)
public function long of_get_libro (ref integer ai_libro)
public function long of_get_indice (integer ai_mes, integer ai_ano, ref decimal adc_indice)
end prototypes

event ue_proceso(boolean ab_test);/*
Datastore	lds_saldo, lds_as_det, lds_rpt
String		ls_origen, ls_cod_moneda, ls_descripcion, ls_flag_debhab, ls_nota
String		ls_flag_debhab_rei, ls_desc_proceso, ls_win
String		ls_glosa, ls_temp, ls_cnta, ls_cnta_ajuste, ls_cnta_gasing
Date			ld_inicio, ld_final, ld_fecha, ld_temp
DateTime		ldt_hoy
Long			ll_saldo, ll_x, ll_rc, ll_lin, ll_row
Decimal		ldc_sldo_debe, ldc_sldo_haber, ldc_indice, ldc_diferencia, ldc_actualizado
Decimal     ldc_ajuste, ldc_tasa, ldc_acudebe = 0, ldc_acuhaber = 0
Double		ldb_nro_asiento, ldb_nro_asiento_real, ldb_nro_proceso
Integer		li_ano, li_mes, li_mes_sig, li_ano_sig, li_mes_ant, li_ano_ant
Integer		li_item, li_libro

cb_cancelar.enabled = False
ldt_hoy    = DateTime(Today(), Now())

// Determinar inicio y fin del mes
li_ano = Integer(sle_ano.text)
li_mes = Integer(sle_mes.text)
IF li_mes = 12 THEN
	li_mes_sig = 1
	li_ano_sig = li_ano + 1
ELSE
	li_mes_sig = li_mes + 1
	li_ano_sig = li_ano
END IF
ls_temp = '1/' + String(li_mes) + '/' + String(li_ano)
ld_temp = Date(ls_temp)
ld_inicio = ld_temp
ls_temp = '1/' + String(li_mes_sig) + '/' + String(li_ano_sig)
ld_temp = Date(ls_temp)
ld_final = RelativeDate(ld_temp, -1)

// Verificar si no se esta duplicando el proceso de calculo de intereses
SELECT Max("OPER_PROCESOS"."FECHA_OBJ_FINAL"), COUNT(*)
  INTO :ld_fecha, :ll_rc
  FROM "OPER_PROCESOS"  
 WHERE ( "OPER_PROCESOS"."COD_PROCESO" = 'ACAI' ) AND  
       ( "OPER_PROCESOS"."FLAG_REVERSION" = '0');
IF RelativeDate(ld_fecha, 1) <> ld_inicio AND ll_rc > 0 THEN
	MessageBox('Error', 'Este rango de fechas ya fue procesado')
	IF NOT ab_test THEN GOTO SALIDA2
END IF

//Crear Datastores
lds_saldo = CREATE Datastore      // Movimientos Generados
lds_saldo.Dataobject = 'd_cnta_saldos_mes_ajuste'
lds_saldo.SetTransObject(SQLCA)
ll_saldo = lds_saldo.Retrieve(li_ano, li_mes)
IF ll_saldo < 1 THEN GOTO SALIDA1

lds_as_det = CREATE Datastore      // Pre Asiento Det
lds_as_det.Dataobject = 'd_cntbl_asiento_det'
lds_as_det.SetTransObject(SQLCA)

lds_rpt = CREATE Datastore      // Reporte de Ajuste
lds_rpt.Dataobject = 'd_rpt_ajuste_inflacion'

// Get Indice de Ajuste
ll_rc = of_get_indice(li_mes, li_ano, ldc_indice)
IF ll_rc < 0 THEN GOTO SALIDA1

// Get Nro Libo
ll_rc = of_get_libro(li_libro)
IF ll_rc < 0 THEN GOTO SALIDA1

// Get Nro Asiento
ll_rc = of_get_nro_asiento(li_libro, li_mes, li_ano, ldb_nro_asiento)
IF ll_rc < 0 THEN GOTO SALIDA1
ldb_nro_asiento = ldb_nro_asiento + 1

DECLARE pb_ingreso_asiento PROCEDURE FOR USF_INGRESO_ASIENTO(:gs_origen, :li_ano, :li_mes,
        :li_libro, :ls_cod_moneda, :ldc_tasa, :ls_nota, :ldb_nro_proceso, :ls_descripcion,
		  :ld_fecha, :ldt_hoy, :gs_user) ;
		
//	Registrar Proceso de Contabilizacion
IF NOT ab_test THEN
	n_cst_log_proceso		nv_1           // Grabar el log en Oper_Procesos
	nv_1 = Create n_cst_log_proceso
	ls_desc_proceso = 'Asiento Contable de Ajuste x Inflacion'
	ls_win = THIS.ClassName()
	ldb_nro_proceso = nv_1.of_set_log(ld_inicio, ld_final,'ACAI',ls_win,ls_desc_proceso, &
	                                  '1', gs_user)
	DESTROY n_cst_log_proceso
END IF
	
// Proceso Contabilizacion
ls_glosa = 'Asiento Ajuste'

FOR ll_x = 1 TO ll_saldo
//	ls_cnta         = lds_saldo.GetItemString(ll_x, 'cnta_ctbl')
	ls_cnta_ajuste  = lds_saldo.GetItemString(ll_x, 'cnta_ctbl_ajuste')
	ls_cnta_gasing  = lds_saldo.GetItemString(ll_x, 'cnta_ctbl_gasing')
	ldc_sldo_debe   = lds_saldo.GetItemDecimal(ll_x, 'sldo_acusoldeb')
	ldc_sldo_haber  = lds_saldo.GetItemDecimal(ll_x, 'sldo_acusolhab')
	IF IsNull(ldc_sldo_debe) THEN ldc_sldo_debe = 0
	IF IsNull(ldc_sldo_haber) THEN ldc_sldo_haber = 0
	ls_cnta_ajuste  = lds_saldo.GetItemString(ll_x, 'cnta_ctbl')
	ldc_diferencia  = ABS(ldc_sldo_haber - ldc_sldo_debe)
	
	IF ldc_diferencia = 0 THEN CONTINUE
	
	ldc_actualizado = ldc_diferencia * ldc_indice
	ldc_ajuste      = ldc_actualizado - ldc_diferencia
	
	// Insertar el Asiento Detalle de la Cuenta Ajustada
	ll_row = lds_as_det.InsertRow(0)
	IF ll_row < 1 THEN GOTO SALIDA1
	ll_lin = lds_rpt.InsertRow(0)
	IF ll_lin < 1 THEN GOTO SALIDA1
	
	IF ldc_sldo_debe > ldc_sldo_haber THEN
		ls_flag_debhab = 'D'
		ls_flag_debhab_rei = 'H'
		ll_rc = lds_rpt.SetItem( ll_lin, 'sldo_debe', ldc_diferencia)
		ldc_acuhaber = ldc_acuhaber + ldc_diferencia
	ELSE
		ls_flag_debhab = 'H'
		ls_flag_debhab_rei = 'D'
		ll_rc = lds_rpt.SetItem( ll_lin, 'sldo_haber', ldc_diferencia)
		ldc_acudebe = ldc_acudebe + ldc_diferencia
	END IF
	
	ll_rc = lds_as_det.SetItem( ll_row, 'origen', gs_origen)
	ll_rc = lds_as_det.SetItem( ll_row, 'ano', li_ano)
	ll_rc = lds_as_det.SetItem( ll_row, 'mes', li_mes)
	ll_rc = lds_as_det.SetItem( ll_row, 'nro_libro', li_libro)
	ll_rc = lds_as_det.SetItem( ll_row, 'nro_asiento', ldb_nro_asiento)
	ll_rc = lds_as_det.SetItem( ll_row, 'item', ll_row)
	ll_rc = lds_as_det.SetItem( ll_row, 'cnta_ctbl', ls_cnta_ajuste)
	ll_rc = lds_as_det.SetItem( ll_row, 'fecha_cntbl', ld_final)
	ll_rc = lds_as_det.SetItem( ll_row, 'det_glosa', ls_glosa)
	ll_rc = lds_as_det.SetItem( ll_row, 'flag_gen_aut', '2')
	ll_rc = lds_as_det.SetItem( ll_row, 'flag_debhab', ls_flag_debhab)
	ll_rc = lds_as_det.SetItem( ll_row, 'imp_movsol', ldc_diferencia)

	ll_rc = lds_rpt.SetItem( ll_lin, 'cnta_ctbl', ls_cnta_ajuste)
	ll_rc = lds_rpt.SetItem( ll_lin, 'factor', ldc_indice)
	ll_rc = lds_rpt.SetItem( ll_lin, 'sldo_actualizado', ldc_actualizado)
	ll_rc = lds_rpt.SetItem( ll_lin, 'ajuste', ldc_ajuste)

	// Insertar el Asiento Detalle de la Cuenta de Ajuste
	ll_row = lds_as_det.InsertRow(0)
	IF ll_row < 1 THEN GOTO SALIDA1
	ll_lin = lds_rpt.InsertRow(0)
	IF ll_lin < 1 THEN GOTO SALIDA1
	
	ll_rc = lds_as_det.SetItem( ll_row, 'origen', gs_origen)
	ll_rc = lds_as_det.SetItem( ll_row, 'ano', li_ano)
	ll_rc = lds_as_det.SetItem( ll_row, 'mes', li_mes)
	ll_rc = lds_as_det.SetItem( ll_row, 'nro_libro', li_libro)
	ll_rc = lds_as_det.SetItem( ll_row, 'nro_asiento', ldb_nro_asiento +1)
	ll_rc = lds_as_det.SetItem( ll_row, 'item', ll_row)
	ll_rc = lds_as_det.SetItem( ll_row, 'cnta_ctbl', ls_cnta_gasing)
	ll_rc = lds_as_det.SetItem( ll_row, 'fecha_cntbl', ld_final)
	ll_rc = lds_as_det.SetItem( ll_row, 'det_glosa', ls_glosa)
	ll_rc = lds_as_det.SetItem( ll_row, 'flag_gen_aut', '2')
	ll_rc = lds_as_det.SetItem( ll_row, 'flag_debhab', ls_flag_debhab_rei)
	ll_rc = lds_as_det.SetItem( ll_row, 'imp_movsol', ldc_diferencia)

	ll_rc = lds_rpt.SetItem( ll_lin, 'cnta_ctbl', ls_cnta_gasing)
	ll_rc = lds_rpt.SetItem( ll_lin, 'factor', ldc_indice)
	ll_rc = lds_rpt.SetItem( ll_lin, 'sldo_actualizado', ldc_actualizado)
	ll_rc = lds_rpt.SetItem( ll_lin, 'ajuste', ldc_ajuste)

NEXT

IF ab_test THEN
	// Report Ajuste
	f_print_data(lds_rpt, 'Reporte de Ajuste por Inflacion',3100,1500)
ELSE
	// insertar cabecera de asiento
	EXECUTE pb_ingreso_asiento ;             // Grabacion de pre Asiento 
   FETCH pb_ingreso_asiento INTO :ldb_nro_asiento_real ;
	CLOSE pb_ingreso_asiento ;
	IF ldb_nro_asiento_real < 1 THEN
		MessageBox('Error DB', 'En Grabacion Cabecera de Asiento')
		GOTO SALIDA1
	ELSE
		IF ldb_nro_asiento_real <> ldb_nro_asiento THEN
			FOR ll_x = 1 TO RowCount(lds_as_det)
				ll_rc = lds_as_det.SetItem(ll_x, 'nro_asiento', ldb_nro_asiento_real)
			NEXT
		END IF
	END IF
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
DESTROY	lds_saldo
DESTROY	lds_as_det

SALIDA2:
cb_cancelar.enabled = TRUE
*/

end event

public function long of_get_nro_asiento (integer ai_libro, integer ai_mes, integer ai_ano, ref double adb_nro_asiento);Long	ll_rc = 0

SELECT NVL(NRO_ASIENTO,0)
  INTO :adb_nro_asiento
  FROM CNTBL_LIBRO_MES
 WHERE ORIGEN    = :gs_origen AND
       NRO_LIBRO = :ai_libro  AND
		 ANO       = :ai_ano    AND
		 MES       = :ai_mes ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error', 'No se pudo leer CNTBL_Libro_Mes')
	ll_rc = -1
ELSE
	IF IsNull(adb_nro_asiento) OR adb_nro_asiento < 1 THEN
		MessageBox('Error', 'Falta Nro de Asiento en CNTBL_LIBRO_MES')
	   ll_rc = -1
	END IF
END IF		


RETURN ll_rc

end function

public function long of_get_libro (ref integer ai_libro);Long	ll_rc = 0

SELECT NVL(LIBRO_REI,0)
  INTO :ai_libro
  FROM CNTBLPARAM
 WHERE RECKEY = '1'  ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error', 'No se pudo leer CNTBL_Param')
	ll_rc = -1
ELSE
	IF IsNull(ai_libro) THEN
		MessageBox('Error', 'Falta el Libro Rei en Cntbl_Param')
	   ll_rc = -1
	END IF
END IF		


RETURN ll_rc

end function

public function long of_get_indice (integer ai_mes, integer ai_ano, ref decimal adc_indice);Dec	ldc_indice
Integer	li_ano, li_mes
Long	ll_rc = 0


li_mes = ai_mes -1
IF li_mes = 0 THEN
	li_ano = ai_ano -1
	li_mes = 12
ELSE
	li_ano = ai_ano
END IF

SELECT NVL(INDICE,0)
  INTO :adc_indice
  FROM INDICE_AJUSTE
 WHERE ANO = :li_ano AND MES = :li_mes;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error', 'No se pudo leer INDICE_AJUSTE')
	ll_rc = -1
ELSE
	IF IsNull(adc_indice) or adc_indice = 0 THEN
		MessageBox('Error', 'Faltan El indice')
	   ll_rc = -1
	END IF
END IF		


RETURN ll_rc


end function

on w_cn926_ajuste_inflacion.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.st_2=create st_2
this.st_1=create st_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_reporte=create cb_reporte
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_titulo=create st_titulo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_ano
this.Control[iCurrent+4]=this.sle_mes
this.Control[iCurrent+5]=this.cb_reporte
this.Control[iCurrent+6]=this.cb_cancelar
this.Control[iCurrent+7]=this.cb_aceptar
this.Control[iCurrent+8]=this.st_titulo
end on

on w_cn926_ajuste_inflacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_reporte)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_titulo)
end on

event ue_open_pre();
sle_mes.text = String(Month(Today()))
sle_ano.text = String(Year(Today()))



end event

type st_2 from statictext within w_cn926_ajuste_inflacion
integer x = 302
integer y = 260
integer width = 265
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn926_ajuste_inflacion
integer x = 302
integer y = 388
integer width = 265
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn926_ajuste_inflacion
integer x = 686
integer y = 388
integer width = 265
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn926_ajuste_inflacion
integer x = 686
integer y = 260
integer width = 265
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_reporte from commandbutton within w_cn926_ajuste_inflacion
integer x = 37
integer y = 624
integer width = 370
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;PARENT.EVENT ue_proceso(TRUE)
end event

type cb_cancelar from commandbutton within w_cn926_ajuste_inflacion
integer x = 850
integer y = 624
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Close(Parent)
end event

type cb_aceptar from commandbutton within w_cn926_ajuste_inflacion
integer x = 439
integer y = 624
integer width = 370
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;
PARENT.EVENT ue_proceso(FALSE)

end event

type st_titulo from statictext within w_cn926_ajuste_inflacion
integer x = 32
integer y = 16
integer width = 1207
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ajuste por Inflacion"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event constructor;//THIS.text = 'Calculo de Interes Mensual' + char(13) + char(10) + 'Ahorros y Cuentas Corrientes'
end event

