$PBExportHeader$w_af901_calculo_depreciacion_acumulada.srw
forward
global type w_af901_calculo_depreciacion_acumulada from w_abc
end type
type mle_1 from multilineedit within w_af901_calculo_depreciacion_acumulada
end type
type st_7 from statictext within w_af901_calculo_depreciacion_acumulada
end type
type pb_procesar from picturebutton within w_af901_calculo_depreciacion_acumulada
end type
type em_year from editmask within w_af901_calculo_depreciacion_acumulada
end type
type em_mes from editmask within w_af901_calculo_depreciacion_acumulada
end type
type st_1 from statictext within w_af901_calculo_depreciacion_acumulada
end type
type st_2 from statictext within w_af901_calculo_depreciacion_acumulada
end type
type sle_origen from singlelineedit within w_af901_calculo_depreciacion_acumulada
end type
type st_descripcion from statictext within w_af901_calculo_depreciacion_acumulada
end type
type gb_1 from groupbox within w_af901_calculo_depreciacion_acumulada
end type
type gb_2 from groupbox within w_af901_calculo_depreciacion_acumulada
end type
end forward

global type w_af901_calculo_depreciacion_acumulada from w_abc
integer width = 1522
integer height = 1132
string title = "(AF901) Cálculo de Depreciación de Activos"
string menuname = "m_depre_activo"
boolean maxbox = false
event ue_procesar ( )
mle_1 mle_1
st_7 st_7
pb_procesar pb_procesar
em_year em_year
em_mes em_mes
st_1 st_1
st_2 st_2
sle_origen sle_origen
st_descripcion st_descripcion
gb_1 gb_1
gb_2 gb_2
end type
global w_af901_calculo_depreciacion_acumulada w_af901_calculo_depreciacion_acumulada

type variables

String is_oper_depre, is_salir, is_libro_depre
end variables

forward prototypes
public function integer of_get_param ()
public function integer of_verifica_periodo (long al_year, long al_mes)
public function integer of_eliminar_periodo (string as_origen, long al_year, long al_mes)
public subroutine of_get_row_update (datawindow adw_1, ref long al_row[])
public function integer of_grabar_datos ()
end prototypes

event ue_procesar();// Evento para procesar los datos

Long  	ll_i, ll_nro_item, ll_year, ll_mes, ll_ret
String	ls_origen

ll_year 			= Long(em_year.Text)
ll_mes  			= Long(em_mes.Text)
ls_origen		= sle_origen.text

// Verificar si mes ya fue procesado
IF of_verifica_periodo(ll_year, ll_mes) = 0 THEN
	ll_ret = messagebox('Aviso', 'El mes ya fue procesado, ' + &
						'~n~r'+ 'Si continua se eliminaran los datos ' +&
						'~n~r'+ 'Desea continuar ', Question!, YESNO!) 
	
	IF ll_ret = 1 THEN
		ll_ret = messagebox('Aviso', 'Los datos del perido Año: ' + &
						string(ll_year) + ' mes: ' + String(ll_mes) + &
						'~n~r'+ 'Seran eliminados permanentemente ' +&
						'~n~r'+ 'Estas Seguro ', Question!, YESNO!) 
		
		IF ll_ret = 1 THEN
		  // funcion para eliminar perido
		  IF of_eliminar_periodo(ls_origen, ll_year, ll_mes) = 0 THEN RETURN
		ELSE 
			RETURN
		END IF
	ELSE
		RETURN
	END IF

END IF

IF of_grabar_datos() = 0 THEN
		messagebox('Error', 'Ha ocurrido un error en la funcion grabar datos')
		RETURN
END IF

COMMIT;

messagebox('Grabar Datos', 'El proceso a culminado satisfactoriamente')


end event

public function integer of_get_param ();//Carga los parametros definidos en ap_param

SELECT DEPRECIACION
  INTO :is_oper_depre
FROM   AF_CALCULO_PARAM
WHERE  RECKEY = '1';

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros en AF_CALCULO_PARAM")
	RETURN 0
END IF

IF sqlca.sqlcode < 0 THEN
	Messagebox( "Error en busqueda parametros AF_CALCULO_PARAM ", sqlca.sqlerrtext)
	RETURN 0	
END IF

SELECT NRO_LIBRO_DEPRE
  INTO :is_libro_depre
FROM   AF_PARAM
WHERE  RECKEY = '1';

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros en AF_PARAM")
	RETURN 0
END IF

IF sqlca.sqlcode < 0 THEN
	Messagebox( "Error en busqueda parametros AF_PARAM ", sqlca.sqlerrtext)
	RETURN 0	
END IF

IF ISNULL( is_libro_depre ) or TRIM( is_libro_depre ) = '' THEN
	Messagebox("Error de parametros", "Defina LIBRO DE DEPRECIACION en AF_PARAM")
	RETURN 0
END IF


RETURN 1
end function

public function integer of_verifica_periodo (long al_year, long al_mes);// Función para verificar si el perido ya fue procesado

Long  ll_count

SELECT COUNT(*)
  INTO :ll_count
 FROM  AF_CALCULO_CNTBL
WHERE ANO = :AL_YEAR
 AND  MES = :AL_MES;

IF ll_count <> 0 THEN
   RETURN 0
END IF

RETURN 1
end function

public function integer of_eliminar_periodo (string as_origen, long al_year, long al_mes);// Funcion para eliminar el periodo de la depreciación

String  ls_mensaje

DELETE FROM AF_CALCULO_CNTBL
 WHERE ANO = :al_year
 	AND mes = :al_mes
   AND SUBSTR(COD_ACTIVO, 1,2) = :as_origen;

IF SQLCA.sqlcode = -1 THEN
 ls_mensaje = "Erro al eliminar periodo " + SQLCA.SQLErrText
 Rollback ;
 MessageBox('SQL error', ls_mensaje, StopSign!) 
 RETURN 0 
END IF

RETURN 1
 

end function

public subroutine of_get_row_update (datawindow adw_1, ref long al_row[]);



end subroutine

public function integer of_grabar_datos ();// Función para grabar datos en la tabla AF_calculo_cntbl

String	ls_mensaje, ls_cod_origen
Long		ll_year, ll_mes

ll_year 			= Long(em_year.Text)
ll_mes  			= Long(em_mes.Text)
ls_cod_origen 	= sle_origen.Text


DECLARE USP_AFI_DEPREC_ACUMULADA PROCEDURE FOR
 USP_AFI_DEPREC_ACUMULADA( :gs_user, :ls_cod_origen,
 									:is_oper_depre, :ll_year, :ll_mes);
 
EXECUTE USP_AFI_DEPREC_ACUMULADA;
 
IF SQLCA.sqlcode = -1 THEN
 ls_mensaje = "PROCEDURE USP_AFI_DEPREC_ACUMULADA: " + SQLCA.SQLErrText
 Rollback ;
 MessageBox('SQL error', ls_mensaje, StopSign!) 
 RETURN 0 
END IF
 
CLOSE USP_AFI_DEPREC_ACUMULADA;

RETURN 1
 


   
end function

on w_af901_calculo_depreciacion_acumulada.create
int iCurrent
call super::create
if this.MenuName = "m_depre_activo" then this.MenuID = create m_depre_activo
this.mle_1=create mle_1
this.st_7=create st_7
this.pb_procesar=create pb_procesar
this.em_year=create em_year
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.sle_origen=create sle_origen
this.st_descripcion=create st_descripcion
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
this.Control[iCurrent+2]=this.st_7
this.Control[iCurrent+3]=this.pb_procesar
this.Control[iCurrent+4]=this.em_year
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_origen
this.Control[iCurrent+9]=this.st_descripcion
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_af901_calculo_depreciacion_acumulada.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mle_1)
destroy(this.st_7)
destroy(this.pb_procesar)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_origen)
destroy(this.st_descripcion)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;is_salir = ''

//Verifico que se cargen los parametros en variables de instancia
IF of_get_param() = 0 THEN
   is_salir = 'S'
	post event closequery()   
	RETURN
END IF

// Inicializamos las variables para la depreciación
sle_origen.text = gs_origen
sle_origen.event modified( )

em_year.text = String(Year(Date(f_fecha_actual())))
em_mes.text  = String(Month(Date(f_fecha_actual())))


end event

event closequery;call super::closequery;CHOOSE CASE is_salir
	CASE 'S'
		CLOSE (this)
END CHOOSE
end event

type mle_1 from multilineedit within w_af901_calculo_depreciacion_acumulada
integer x = 50
integer y = 64
integer width = 1353
integer height = 240
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 8388608
long backcolor = 12632256
string text = "Este Proceso Calcular la depreciación Acumulada al 31 de Diciembre y la insertara como un registro manual de Calculo de Depreciación"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within w_af901_calculo_depreciacion_acumulada
integer x = 416
integer y = 824
integer width = 631
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Procesar Depreciación"
boolean focusrectangle = false
end type

type pb_procesar from picturebutton within w_af901_calculo_depreciacion_acumulada
integer x = 288
integer y = 808
integer width = 105
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom064!"
end type

event clicked;// Almacenar los calculos en la Tabla AF_cuenta_Cntbl

Parent.Event dynamic ue_procesar()


end event

type em_year from editmask within w_af901_calculo_depreciacion_acumulada
integer x = 443
integer y = 640
integer width = 210
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
string minmax = "2004~~"
end type

type em_mes from editmask within w_af901_calculo_depreciacion_acumulada
integer x = 805
integer y = 644
integer width = 201
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "1~~12"
end type

event modified;Long  ll_mes

ll_mes = long(em_mes.text)

IF ll_mes < 1 OR ll_mes > 12 OR Isnull(ll_mes) THEN
	MessageBox('Aviso', 'Debe El valor para el mes no es correcto')
	This.text  = String(Month(today()))
	RETURN 1
END IF


end event

type st_1 from statictext within w_af901_calculo_depreciacion_acumulada
integer x = 306
integer y = 656
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Año:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_af901_calculo_depreciacion_acumulada
integer x = 672
integer y = 656
integer width = 133
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Mes:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_af901_calculo_depreciacion_acumulada
event dobleclick pbm_lbuttondblclk
integer x = 325
integer y = 408
integer width = 123
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS DESCRIPCION " &
		  + "FROM ORIGEN " &
		  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
IF ls_codigo <> '' THEN
	This.text 				= ls_codigo
	st_descripcion.text  = ls_data
END IF

end event

event modified;String 	ls_cod_origen, ls_desc, ls_null

SetNull(ls_null)

ls_cod_origen = sle_origen.text
IF ls_cod_origen = '' OR IsNull(ls_cod_origen) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	RETURN
END IF

SELECT NOMBRE
	INTO :ls_desc
FROM ORIGEN
WHERE cod_origen = :ls_cod_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de ORIGEN no existe')
	st_descripcion.text = ls_null
	This.text			  = ls_null
	RETURN
END IF

st_descripcion.text = ls_desc

end event

type st_descripcion from statictext within w_af901_calculo_depreciacion_acumulada
integer x = 480
integer y = 408
integer width = 503
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_af901_calculo_depreciacion_acumulada
integer x = 288
integer y = 572
integer width = 736
integer height = 184
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo"
end type

type gb_2 from groupbox within w_af901_calculo_depreciacion_acumulada
integer x = 288
integer y = 340
integer width = 736
integer height = 184
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen"
end type

