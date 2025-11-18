$PBExportHeader$w_cn928_nivelacion_tipo_cambio.srw
forward
global type w_cn928_nivelacion_tipo_cambio from w_prc
end type
type st_2 from statictext within w_cn928_nivelacion_tipo_cambio
end type
type st_1 from statictext within w_cn928_nivelacion_tipo_cambio
end type
type sle_ano from singlelineedit within w_cn928_nivelacion_tipo_cambio
end type
type sle_mes from singlelineedit within w_cn928_nivelacion_tipo_cambio
end type
type cb_reporte from commandbutton within w_cn928_nivelacion_tipo_cambio
end type
type cb_cancelar from commandbutton within w_cn928_nivelacion_tipo_cambio
end type
type cb_aceptar from commandbutton within w_cn928_nivelacion_tipo_cambio
end type
type st_titulo from statictext within w_cn928_nivelacion_tipo_cambio
end type
end forward

global type w_cn928_nivelacion_tipo_cambio from w_prc
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
global w_cn928_nivelacion_tipo_cambio w_cn928_nivelacion_tipo_cambio

type variables
Datastore	ids_tasas
end variables

forward prototypes
public function long of_get_libro (ref string as_cnta_ganancia, ref string as_cnta_perdida, ref integer ai_libro)
public function long of_get_moneda (ref string as_moneda)
public function long of_set_rpt (ref datastore ads_rpt, string as_cuenta, decimal adc_sldo_sol, decimal adc_sldo_dol, string as_dh, decimal adc_cambio_sbs, decimal adc_sldo_tcfm, decimal adc_diferencia)
public function long of_get_tipo_cambio (date ad_inicio, date ad_final, ref decimal adc_tipo_cambio)
public function long of_get_nro_asiento (integer ai_libro, integer ai_mes, integer ai_ano, ref double adb_nro_asiento)
public function long of_set_asiento_det (ref datastore ads_as_det, integer ai_ano, integer ai_mes, integer ai_libro, double adb_nro_asiento, string as_cuenta, date ad_fecha, string as_glosa, string as_flag_gen_aut, string as_dh, decimal adc_importe)
end prototypes

event ue_proceso(boolean ab_test);/*
Datastore	lds_saldo, lds_as_det, lds_rpt
String		ls_origen, ls_cod_moneda, ls_descripcion, ls_nota, ls_moneda
String		ls_desc_proceso, ls_win, ls_glosa, ls_temp, ls_cnta_rei
String		ls_cnta_gdc, ls_cnta_pdc, ls_cuenta, ls_dh
Date			ld_inicio, ld_final, ld_fecha, ld_temp
DateTime		ldt_hoy
Long			ll_saldo, ll_x, ll_rc, ll_lin, ll_row
Decimal		ldc_sldo_soldeb, ldc_sldo_solhab, ldc_sldo_doldeb, ldc_sldo_dolhab
Decimal		ldc_sldo_sol, ldc_sldo_dol, ldc_cambio_sbs, ldc_diferencia, ldc_sldo_tcfm
Decimal     ldc_tasa, ldc_ganancia = 0, ldc_perdida = 0
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
 WHERE ( "OPER_PROCESOS"."COD_PROCESO" = 'ANTC' ) AND  
       ( "OPER_PROCESOS"."FLAG_REVERSION" = '0');
IF RelativeDate(ld_fecha, 1) <> ld_inicio AND ll_rc > 0 THEN
	MessageBox('Error', 'Este rango de fechas ya fue procesado')
	IF NOT ab_test THEN GOTO SALIDA2
END IF

//Crear Datastores
lds_saldo = CREATE Datastore      // Saldos
lds_saldo.Dataobject = 'd_cnta_saldos_mes_moneda'
lds_saldo.SetTransObject(SQLCA)

lds_as_det = CREATE Datastore     // Pre Asiento Det
lds_as_det.Dataobject = 'd_cntbl_asiento_det'
lds_as_det.SetTransObject(SQLCA)

lds_rpt = CREATE Datastore        // Reporte de Ajuste
lds_rpt.Dataobject = 'd_rpt_nivelacion_tipo_cambio'

// Get Tipo Cambio
ll_rc = of_get_tipo_cambio(ld_inicio, ld_final, ldc_cambio_sbs)
IF ll_rc < 0 THEN GOTO SALIDA1

// Get Nro Libo y Cuentas
ll_rc = of_get_libro(ls_cnta_gdc, ls_cnta_pdc, li_libro)
IF ll_rc < 0 THEN GOTO SALIDA1

// Get Moneda Dolar
ll_rc = of_get_moneda(ls_moneda)
IF ll_rc < 0 THEN GOTO SALIDA1

// Get Nro Asiento
ll_rc = of_get_nro_asiento(li_libro, li_mes, li_ano, ldb_nro_asiento)
IF ll_rc < 0 THEN GOTO SALIDA1
ldb_nro_asiento = ldb_nro_asiento + 1

DECLARE pb_ingreso_asiento PROCEDURE FOR USF_INGRESO_ASIENTO(:gs_origen, :li_ano, :li_mes,
        :li_libro, :ls_cod_moneda, :ldc_tasa, :ls_nota, :ldb_nro_proceso, :ls_descripcion,
		  :ld_fecha, :ldt_hoy, :gs_user) ;

// Leer Saldos de Cuentas en Dolares
ll_saldo = lds_saldo.Retrieve(li_ano, li_mes, ls_moneda)
IF ll_saldo < 1 THEN GOTO SALIDA1
	
//	Registrar Proceso de Contabilizacion
IF NOT ab_test THEN
	n_cst_log_proceso		nv_1           // Grabar el log en Oper_Procesos
	nv_1 = Create n_cst_log_proceso
	ls_desc_proceso = 'Asiento x Nivelacion de Tipo de Cambio'
	ls_win = THIS.ClassName()
	ldb_nro_proceso = nv_1.of_set_log(ld_inicio, ld_final,'ANTC',ls_win,ls_desc_proceso, &
	                                  '1', gs_user)
	DESTROY n_cst_log_proceso
END IF
	
// Proceso Contabilizacion
ls_glosa = 'Asiento Nivelacion x Tipo de Cambio'

FOR ll_x = 1 TO ll_saldo
	ls_cuenta         = lds_saldo.GetItemString(ll_x, 'cnta_ctbl')
	ldc_sldo_soldeb   = lds_saldo.GetItemDecimal(ll_x, 'sldo_soldeb')
	ldc_sldo_solhab   = lds_saldo.GetItemDecimal(ll_x, 'sldo_solhab')
	ldc_sldo_doldeb   = lds_saldo.GetItemDecimal(ll_x, 'sldo_doldeb')
	ldc_sldo_dolhab   = lds_saldo.GetItemDecimal(ll_x, 'sldo_dolhab')
	IF IsNull(ldc_sldo_soldeb) THEN ldc_sldo_soldeb = 0
	IF IsNull(ldc_sldo_solhab) THEN ldc_sldo_solhab = 0
	IF IsNull(ldc_sldo_doldeb) THEN ldc_sldo_doldeb = 0
	IF IsNull(ldc_sldo_dolhab) THEN ldc_sldo_dolhab = 0

	ldc_sldo_sol = ldc_sldo_soldeb - ldc_sldo_solhab
	IF ldc_sldo_sol = 0 THEN CONTINUE
	ldc_sldo_dol = ldc_sldo_doldeb - ldc_sldo_dolhab
	ldc_sldo_tcfm = Round(ldc_sldo_dol * ldc_cambio_sbs, 2) 
	ldc_diferencia = ldc_sldo_tcfm - ldc_sldo_sol
	IF ldc_sldo_sol > 0 THEN
		ls_dh = 'D'
		IF ldc_diferencia > 0 THEN
			ldc_ganancia = ldc_ganancia + ldc_diferencia  // sumar ganancia
		ELSE
			ldc_ganancia = ldc_ganancia + ldc_diferencia  // restar perdida
		END IF
	ELSE
		ls_dh = 'H'
		IF ldc_diferencia > 0 THEN
			ldc_perdida = ldc_perdida + ldc_diferencia    // sumar perdida
		ELSE
			ldc_perdida = ldc_perdida + ldc_diferencia    // restar ganancia
		END IF
	END IF
	
	// adicionar asiento det 
	IF NOT ab_test THEN ll_rc = of_set_asiento_det(lds_as_det, li_ano, li_mes, &
	                                  li_libro, ldb_nro_asiento, ls_cuenta, &
												 ld_final, ls_glosa, '2', ls_dh, ABS(ldc_diferencia))
	// adicionar linea a reporte
	ll_rc = of_set_rpt(lds_rpt, ls_cuenta, ldc_sldo_sol, ldc_sldo_dol, ls_dh, &
	                   ldc_cambio_sbs, ldc_sldo_tcfm, ABS(ldc_diferencia))
NEXT

// asiento Cuentas de Ganancias y Perdidas x Diferencia en Cambio
IF ldc_ganancia> 0 THEN
	// adicionar asiento det 
	IF NOT ab_test THEN ll_rc = of_set_asiento_det(lds_as_det, li_ano, li_mes, & 
	                                  li_libro, ldb_nro_asiento, ls_cnta_gdc, &
												 ld_final, ls_glosa, '2', 'D', ldc_ganancia)
	// adicionar linea a reporte
	ll_rc = of_set_rpt(lds_rpt, ls_cnta_gdc, 0, 0, 'D', 0, 0, ldc_ganancia)
END IF

IF ldc_perdida > 0 THEN
	// adicionar asiento det 
	IF NOT ab_test THEN ll_rc = of_set_asiento_det(lds_as_det, li_ano, li_mes, &
	                                  li_libro, ldb_nro_asiento, ls_cnta_pdc, &
												 ld_final, ls_glosa, '2', 'D', ldc_perdida)
	// adicionar linea a reporte
	ll_rc = of_set_rpt(lds_rpt, ls_cnta_pdc, 0, 0, 'D', 0, 0, ldc_perdida)
END IF
	
IF ab_test THEN
	// Report Ajuste
	f_print_data(lds_rpt, 'Nivelacion x Diferencia de Cambio',3100,1500)
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

public function long of_get_libro (ref string as_cnta_ganancia, ref string as_cnta_perdida, ref integer ai_libro);Long	ll_rc = 0

SELECT CNTA_NTC_GDC, CNTA_NTC_PDC, NVL(LIBRO_NTC,0)
  INTO :as_cnta_ganancia, :as_cnta_perdida, :ai_libro
  FROM CNTBLPARAM
 WHERE RECKEY = '1'  ;
	
IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error', 'No se pudo leer CNTBL_Param')
	ll_rc = -1
ELSE
	IF IsNull(as_cnta_ganancia) OR IsNull(as_cnta_perdida) OR IsNull(ai_libro) THEN
		MessageBox('Error', 'Faltan laS Cntas o el Libro en Cntbl_Param')
	   ll_rc = -1
	END IF
END IF		


RETURN ll_rc

end function

public function long of_get_moneda (ref string as_moneda);Long	ll_rc = 0

SELECT MONEDA_DOL
  INTO :as_moneda
  FROM OPERPARAM
 WHERE RECKEY = '1'  ;
	

IF SQLCA.SQLCODE <> 0 THEN
	MessageBox('Error', 'No se pudo leer OperParam')
	ll_rc = -1
ELSE
	IF IsNull(as_moneda) THEN
		MessageBox('Error', 'Faltan la moneda de Dolares en OperParam')
	   ll_rc = -1
	END IF
END IF	
	
RETURN ll_rc
	
end function

public function long of_set_rpt (ref datastore ads_rpt, string as_cuenta, decimal adc_sldo_sol, decimal adc_sldo_dol, string as_dh, decimal adc_cambio_sbs, decimal adc_sldo_tcfm, decimal adc_diferencia);Long		ll_rc, ll_row


// adicionar linea a reporte
ll_row = ads_rpt.InsertRow(0)
IF ll_row < 1 THEN GOTO SALIDA

ll_rc = ads_rpt.SetItem( ll_row, 'cuenta', as_cuenta)
ll_rc = ads_rpt.SetItem( ll_row, 'saldo_sol', adc_sldo_sol)
ll_rc = ads_rpt.SetItem( ll_row, 'saldo_dol', adc_sldo_dol)
ll_rc = ads_rpt.SetItem( ll_row, 'dh', as_dh)
ll_rc = ads_rpt.SetItem( ll_row, 'tipo_cambio', adc_cambio_sbs)
ll_rc = ads_rpt.SetItem( ll_row, 'saldo_tcfm', adc_sldo_tcfm)
ll_rc = ads_rpt.SetItem( ll_row, 'diferencia', adc_diferencia)

SALIDA:
RETURN ll_rc
end function

public function long of_get_tipo_cambio (date ad_inicio, date ad_final, ref decimal adc_tipo_cambio);Datastore	lds_tc
Long			ll_rc, ll_x
Decimal		ldc_test

//Crear Datastores
lds_tc = CREATE Datastore      // Saldos
lds_tc.Dataobject = 'd_calendario'
lds_tc.SetTransObject(SQLCA)
ll_rc = lds_tc.Retrieve(ad_inicio, ad_final)

IF ll_rc < 1 THEN GOTO SALIDA

FOR ll_x = ll_rc TO 1 Step -1
	ldc_test = lds_tc.GetItemDecimal(ll_x, 'cambio_sbs')
	IF ldc_test > 0 THEN
		adc_tipo_cambio = ldc_test
		ll_rc = ll_x
		EXIT
	END IF
	ll_rc = -7
NEXT

SALIDA:
IF ll_rc < 1 THEN	MessageBox('Error', 'No se tiene Tipo de Cambio')
RETURN ll_rc
end function

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

public function long of_set_asiento_det (ref datastore ads_as_det, integer ai_ano, integer ai_mes, integer ai_libro, double adb_nro_asiento, string as_cuenta, date ad_fecha, string as_glosa, string as_flag_gen_aut, string as_dh, decimal adc_importe);Long		ll_rc, ll_row

// adicionar asiento det 
ll_rc = ads_as_det.InsertRow(0)
IF ll_rc < 1 THEN	GOTO SALIDA

ll_row = ll_rc

ll_rc = ads_as_det.SetItem( ll_row, 'origen', gs_origen)
ll_rc = ads_as_det.SetItem( ll_row, 'ano', ai_ano)
ll_rc = ads_as_det.SetItem( ll_row, 'mes', ai_mes)
ll_rc = ads_as_det.SetItem( ll_row, 'nro_libro', ai_libro)
ll_rc = ads_as_det.SetItem( ll_row, 'nro_asiento', adb_nro_asiento)
ll_rc = ads_as_det.SetItem( ll_row, 'item', ll_row)
ll_rc = ads_as_det.SetItem( ll_row, 'cnta_ctbl', as_cuenta)
ll_rc = ads_as_det.SetItem( ll_row, 'fecha_cntbl', ad_fecha)
ll_rc = ads_as_det.SetItem( ll_row, 'det_glosa', as_glosa)
ll_rc = ads_as_det.SetItem( ll_row, 'flag_gen_aut', as_flag_gen_aut)
ll_rc = ads_as_det.SetItem( ll_row, 'flag_debhab', as_dh)
ll_rc = ads_as_det.SetItem( ll_row, 'imp_movsol', adc_importe)

SALIDA:
RETURN	ll_rc
end function

on w_cn928_nivelacion_tipo_cambio.create
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

on w_cn928_nivelacion_tipo_cambio.destroy
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

type st_2 from statictext within w_cn928_nivelacion_tipo_cambio
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
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn928_nivelacion_tipo_cambio
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
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn928_nivelacion_tipo_cambio
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

type sle_mes from singlelineedit within w_cn928_nivelacion_tipo_cambio
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

type cb_reporte from commandbutton within w_cn928_nivelacion_tipo_cambio
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

type cb_cancelar from commandbutton within w_cn928_nivelacion_tipo_cambio
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

type cb_aceptar from commandbutton within w_cn928_nivelacion_tipo_cambio
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

type st_titulo from statictext within w_cn928_nivelacion_tipo_cambio
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
string text = "Nivelacion x Tipo de Cambio"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event constructor;//THIS.text = 'Calculo de Interes Mensual' + char(13) + char(10) + 'Ahorros y Cuentas Corrientes'
end event

