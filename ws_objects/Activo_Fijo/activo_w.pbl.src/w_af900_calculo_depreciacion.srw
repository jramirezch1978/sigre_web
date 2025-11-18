$PBExportHeader$w_af900_calculo_depreciacion.srw
forward
global type w_af900_calculo_depreciacion from w_abc
end type
type st_11 from statictext within w_af900_calculo_depreciacion
end type
type st_10 from statictext within w_af900_calculo_depreciacion
end type
type st_depre from statictext within w_af900_calculo_depreciacion
end type
type st_oper from statictext within w_af900_calculo_depreciacion
end type
type st_9 from statictext within w_af900_calculo_depreciacion
end type
type em_fecha from editmask within w_af900_calculo_depreciacion
end type
type st_nro_pre_asiento from statictext within w_af900_calculo_depreciacion
end type
type st_8 from statictext within w_af900_calculo_depreciacion
end type
type st_3 from statictext within w_af900_calculo_depreciacion
end type
type pb_asiento from picturebutton within w_af900_calculo_depreciacion
end type
type hpb_barra from hprogressbar within w_af900_calculo_depreciacion
end type
type st_7 from statictext within w_af900_calculo_depreciacion
end type
type pb_procesar from picturebutton within w_af900_calculo_depreciacion
end type
type st_6 from statictext within w_af900_calculo_depreciacion
end type
type pb_reporte from picturebutton within w_af900_calculo_depreciacion
end type
type dw_report from u_dw_rpt within w_af900_calculo_depreciacion
end type
type em_veda from editmask within w_af900_calculo_depreciacion
end type
type em_prod from editmask within w_af900_calculo_depreciacion
end type
type em_year from editmask within w_af900_calculo_depreciacion
end type
type em_mes from editmask within w_af900_calculo_depreciacion
end type
type st_1 from statictext within w_af900_calculo_depreciacion
end type
type st_2 from statictext within w_af900_calculo_depreciacion
end type
type sle_origen from singlelineedit within w_af900_calculo_depreciacion
end type
type st_descripcion from statictext within w_af900_calculo_depreciacion
end type
type st_4 from statictext within w_af900_calculo_depreciacion
end type
type st_5 from statictext within w_af900_calculo_depreciacion
end type
type gb_1 from groupbox within w_af900_calculo_depreciacion
end type
type gb_2 from groupbox within w_af900_calculo_depreciacion
end type
type gb_3 from groupbox within w_af900_calculo_depreciacion
end type
end forward

global type w_af900_calculo_depreciacion from w_abc
integer width = 3959
integer height = 2488
string title = "(AF900) Cálculo de Depreciación de Activos"
string menuname = "m_depre_activo"
windowstate windowstate = maximized!
event ue_procesar ( )
event ue_mostrar_datos ( )
event ue_procesar_pre_asiento ( )
st_11 st_11
st_10 st_10
st_depre st_depre
st_oper st_oper
st_9 st_9
em_fecha em_fecha
st_nro_pre_asiento st_nro_pre_asiento
st_8 st_8
st_3 st_3
pb_asiento pb_asiento
hpb_barra hpb_barra
st_7 st_7
pb_procesar pb_procesar
st_6 st_6
pb_reporte pb_reporte
dw_report dw_report
em_veda em_veda
em_prod em_prod
em_year em_year
em_mes em_mes
st_1 st_1
st_2 st_2
sle_origen sle_origen
st_descripcion st_descripcion
st_4 st_4
st_5 st_5
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_af900_calculo_depreciacion w_af900_calculo_depreciacion

type variables

String is_oper_depre, is_salir, is_libro_depre
end variables

forward prototypes
public function integer of_get_param ()
public function integer of_mostrar_datos (string as_cod_origen, long al_year, long al_mes, long al_porc_prod, long al_porc_veda)
public function integer of_grabar_datos (long ll_nro_item)
public function integer of_verifica_periodo (long al_year, long al_mes)
public function integer of_eliminar_periodo (string as_origen, long al_year, long al_mes)
public function integer of_verifica_matrices ()
public subroutine of_get_row_update (datawindow adw_1, ref long al_row[])
public function integer of_procedure_pre_asiento ()
end prototypes

event ue_procesar();// Evento para procesar los datos

Long  	ll_i, ll_nro_item, ll_year, ll_mes, ll_ret
String	ls_origen

ll_year 			= Long(em_year.Text)
ll_mes  			= Long(em_mes.Text)
ls_origen		= sle_origen.text

pb_asiento.Enabled = False

// Verifica las matrices
IF of_verifica_matrices() = 0 THEN RETURN

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

// Para visualizar la barra de desplazamiento
hpb_barra.MaxPosition = dw_report.RowCount()
hpb_barra.Position = 0

FOR ll_i = 1 TO dw_report.rowcount( )
	ll_nro_item = dw_report.object.nro_item [ll_i]
	
	//funcion para ingresar los datos
	IF of_grabar_datos(ll_nro_item) = 0 THEN
		messagebox('Error', 'Ha ocurrido un error en la funcion grabar datos')
		RETURN
	END IF		

	hpb_barra.position = ll_i // Avance de la barra
NEXT

COMMIT;

pb_asiento.Enabled = True
messagebox('Grabar Datos', 'El proceso a culminado satisfactoriamente')

ll_ret = messagebox('Pre_Asientos', 'Desea Crear los Pre_Asientos del perido Año: ' + &
						string(ll_year) + ' mes: ' + String(ll_mes) &
						, Question!, YESNO!) 
						
IF ll_ret = 1 THEN 
	This.Event Dynamic ue_procesar_pre_asiento()
END IF
end event

event ue_mostrar_datos();// Evento para mostrar los datos en el DW segun la tabla temporal

Long 		ll_year, ll_mes, ll_porc_prod, ll_porc_veda, ll_porc_total
String	ls_cod_origen

ll_year 			= Long(em_year.Text)
ll_mes  			= Long(em_mes.Text)
ll_porc_prod	= Long(em_prod.Text)
ll_porc_veda	= Long(em_veda.Text)
ls_cod_origen 	= sle_origen.Text

// Verifica que la suma de los porcentajes sea 100

ll_porc_total = Long(em_prod.text) + Long(em_veda.Text)
IF ll_porc_total > 100 OR ll_porc_total < 100 THEN
	messagebox('Error', 'La suma de los porcentajes debe ser 100')
	RETURN
END IF

//llamar a la función para llenar tabla temporal
IF of_mostrar_datos(ls_cod_origen, ll_year, ll_mes, &
						  ll_porc_prod, ll_porc_veda) = 0 THEN
	messagebox('Error', 'Se ha producido un error en USP_AFI_TEMPORAL_DEPRECIACION ')
	RETURN
END IF

dw_report.Visible = True
dw_report.retrieve()
end event

event ue_procesar_pre_asiento();// Evento para procesar los datos

//funcion para llamar al Procedimiento para crear Pre_Asientos
IF of_procedure_pre_Asiento() = 0 THEN
	messagebox('Error', 'Ha ocurrido un error en la creación de pre_asientos')
	RETURN
END IF

messagebox('Grabar Datos', 'El proceso a culminado satisfactoriamente')


end event

public function integer of_get_param ();//Carga los parametros definidos en ap_param

SELECT OPER_DEPRE, NRO_LIBRO_DEPRE
  INTO :is_oper_depre, :is_libro_depre
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

IF ISNULL( is_oper_depre ) or TRIM( is_oper_depre ) = '' THEN
	Messagebox("Error de parametros", "Defina OPERACION DE DEPRECIACIÓN en AF_PARAM")
	RETURN 0
END IF


RETURN 1
end function

public function integer of_mostrar_datos (string as_cod_origen, long al_year, long al_mes, long al_porc_prod, long al_porc_veda);// Función para llamar al procedimiento para llenar la tabla temporal

String ls_mensaje

DECLARE USP_AFI_TEMPORAL_DEPRECIACION PROCEDURE FOR
 USP_AFI_TEMPORAL_DEPRECIACION( :al_year, :al_mes, 
 										  :as_cod_origen, :is_oper_depre,
										  :al_porc_prod,  :al_porc_Veda);
 
EXECUTE USP_AFI_TEMPORAL_DEPRECIACION;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "PROCEDURE USP_AFI_TEMPORAL_DEPRECIACION : " + SQLCA.SQLErrText
	 ROLLBACK ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 RETURN 0
END IF
 
CLOSE USP_AFI_TEMPORAL_DEPRECIACION;
 
RETURN 1
end function

public function integer of_grabar_datos (long ll_nro_item);// Función para grabar datos en la tabla AF_calculo_cntbl

String	ls_mensaje

 
DECLARE USP_AFI_CALCULO_DEPRECIACION PROCEDURE FOR
 USP_AFI_CALCULO_DEPRECIACION( :ll_nro_item, :gs_user );
 
EXECUTE USP_AFI_CALCULO_DEPRECIACION;
 
IF SQLCA.sqlcode = -1 THEN
 ls_mensaje = "PROCEDURE USP_AFI_CALCULO_DEPRECIACION: " + SQLCA.SQLErrText
 Rollback ;
 MessageBox('SQL error', ls_mensaje, StopSign!) 
 RETURN 0 
END IF
 
CLOSE USP_AFI_CALCULO_DEPRECIACION;

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

public function integer of_verifica_matrices ();// Funcion para verificar las existencia de las matrices

Long  	ll_porc_prod, ll_porc_veda, ll_found

ll_porc_prod	= Long(em_prod.Text)
ll_porc_veda	= Long(em_veda.Text)

// Verificar matrices contables
IF ll_porc_prod = 100 THEN
	ll_found = dw_report.Find("IsNull(matriz_produc)", 1, &
				 dw_report.rowcount())
ELSEIF ll_porc_veda = 100 THEN 
	ll_found = dw_report.Find("IsNull(matriz_veda)", 1, &
				 dw_report.rowcount())
ELSE 
	ll_found = dw_report.Find("IsNull(matriz_produc) OR IsNull(matriz_veda) ", 1, &
				 dw_report.rowcount())
END IF

IF ll_found > 0 THEN
	messagebox('Aviso', 'Por favor verifique la matriz contable')
	RETURN 0
END IF

RETURN 1


end function

public subroutine of_get_row_update (datawindow adw_1, ref long al_row[]);



end subroutine

public function integer of_procedure_pre_asiento ();// Función para llamar al procedimiento que crea el movimiento

String	ls_origen, ls_mensaje
Long		ll_year, ll_mes, ll_nro_pre_asiento
Datetime ldt_fecha

ls_origen	 	  = sle_origen.Text
ll_year			  = Long(em_year.Text)
ll_mes			  = Long(em_mes.Text)

IF IsNull(ls_origen) OR Len(ls_origen) = 0 THEN
	Messagebox('Error', 'Debe ingresar un origen, por favor Verifique')
	RETURN 0
END IF

em_fecha.getdata(ldt_fecha)


// llamar al procedimiento para crear los preasientos
DECLARE USP_AFI_ASI_DEPRECIACION PROCEDURE FOR
    	  USP_AFI_ASI_DEPRECIACION( :ll_year,
		  									 :ll_mes,
											 :ls_origen,
											 :gs_user,
											 :ldt_fecha,
											 :is_libro_depre);
	 
EXECUTE USP_AFI_ASI_DEPRECIACION;
 
IF SQLCA.sqlcode = -1 THEN
	 ls_mensaje = "USP_AFI_ASI_DEPRECIACION: " + SQLCA.SQLErrText
	 Rollback ;
	 MessageBox('SQL error', ls_mensaje, StopSign!) 
	 RETURN 0
END IF

FETCH USP_AFI_ASI_DEPRECIACION INTO :ll_nro_pre_asiento;
	 
CLOSE USP_AFI_ASI_DEPRECIACION;

st_nro_pre_asiento.Text = String(ll_nro_pre_asiento)

RETURN 1
end function

on w_af900_calculo_depreciacion.create
int iCurrent
call super::create
if this.MenuName = "m_depre_activo" then this.MenuID = create m_depre_activo
this.st_11=create st_11
this.st_10=create st_10
this.st_depre=create st_depre
this.st_oper=create st_oper
this.st_9=create st_9
this.em_fecha=create em_fecha
this.st_nro_pre_asiento=create st_nro_pre_asiento
this.st_8=create st_8
this.st_3=create st_3
this.pb_asiento=create pb_asiento
this.hpb_barra=create hpb_barra
this.st_7=create st_7
this.pb_procesar=create pb_procesar
this.st_6=create st_6
this.pb_reporte=create pb_reporte
this.dw_report=create dw_report
this.em_veda=create em_veda
this.em_prod=create em_prod
this.em_year=create em_year
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.sle_origen=create sle_origen
this.st_descripcion=create st_descripcion
this.st_4=create st_4
this.st_5=create st_5
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_11
this.Control[iCurrent+2]=this.st_10
this.Control[iCurrent+3]=this.st_depre
this.Control[iCurrent+4]=this.st_oper
this.Control[iCurrent+5]=this.st_9
this.Control[iCurrent+6]=this.em_fecha
this.Control[iCurrent+7]=this.st_nro_pre_asiento
this.Control[iCurrent+8]=this.st_8
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.pb_asiento
this.Control[iCurrent+11]=this.hpb_barra
this.Control[iCurrent+12]=this.st_7
this.Control[iCurrent+13]=this.pb_procesar
this.Control[iCurrent+14]=this.st_6
this.Control[iCurrent+15]=this.pb_reporte
this.Control[iCurrent+16]=this.dw_report
this.Control[iCurrent+17]=this.em_veda
this.Control[iCurrent+18]=this.em_prod
this.Control[iCurrent+19]=this.em_year
this.Control[iCurrent+20]=this.em_mes
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.st_2
this.Control[iCurrent+23]=this.sle_origen
this.Control[iCurrent+24]=this.st_descripcion
this.Control[iCurrent+25]=this.st_4
this.Control[iCurrent+26]=this.st_5
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.gb_3
end on

on w_af900_calculo_depreciacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_11)
destroy(this.st_10)
destroy(this.st_depre)
destroy(this.st_oper)
destroy(this.st_9)
destroy(this.em_fecha)
destroy(this.st_nro_pre_asiento)
destroy(this.st_8)
destroy(this.st_3)
destroy(this.pb_asiento)
destroy(this.hpb_barra)
destroy(this.st_7)
destroy(this.pb_procesar)
destroy(this.st_6)
destroy(this.pb_reporte)
destroy(this.dw_report)
destroy(this.em_veda)
destroy(this.em_prod)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_origen)
destroy(this.st_descripcion)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
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

em_year.text = String(Year(today()))
em_mes.text  = String(Month(today()))
em_prod.text = '100'
em_veda.Text = '0'
em_fecha.Text= String(f_fecha_actual(), 'dd/mm/yyyy')

st_oper.backcolor = RGB(216,241,202)
st_depre.backcolor = RGB(254,240,158)

dw_report.SetTransObject(sqlca)  
dw_report.Visible = False

end event

event closequery;call super::closequery;CHOOSE CASE is_salir
	CASE 'S'
		CLOSE (this)
END CHOOSE
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 60
dw_report.height = newheight - dw_report.y - 100
hpb_barra.width  = newwidth  - hpb_barra.x - 60

end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type st_11 from statictext within w_af900_calculo_depreciacion
integer x = 3122
integer y = 56
integer width = 745
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Deprec. de Operaciones"
boolean focusrectangle = false
end type

type st_10 from statictext within w_af900_calculo_depreciacion
integer x = 3122
integer y = 128
integer width = 594
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ultimo mes Depreciado"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_depre from statictext within w_af900_calculo_depreciacion
integer x = 2930
integer y = 124
integer width = 151
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33554431
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_oper from statictext within w_af900_calculo_depreciacion
integer x = 2930
integer y = 52
integer width = 151
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217730
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_9 from statictext within w_af900_calculo_depreciacion
integer x = 2226
integer y = 48
integer width = 265
integer height = 128
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Asiento:"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_fecha from editmask within w_af900_calculo_depreciacion
integer x = 2501
integer y = 68
integer width = 343
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy"
end type

type st_nro_pre_asiento from statictext within w_af900_calculo_depreciacion
integer x = 3022
integer y = 212
integer width = 366
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 8388608
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_8 from statictext within w_af900_calculo_depreciacion
integer x = 2578
integer y = 228
integer width = 439
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Pre_Asiento:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_af900_calculo_depreciacion
integer x = 1879
integer y = 228
integer width = 475
integer height = 52
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Crear Pre Asientos"
boolean focusrectangle = false
end type

type pb_asiento from picturebutton within w_af900_calculo_depreciacion
integer x = 1755
integer y = 208
integer width = 101
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean enabled = false
string picturename = "Custom083!"
string disabledname = "Custom101!"
alignment htextalign = left!
end type

event clicked;// Generamos los Pre asientos Contables

IF dw_report.rowcount( ) = 0 THEN RETURN

Parent.Event dynamic ue_procesar_pre_asiento()
end event

type hpb_barra from hprogressbar within w_af900_calculo_depreciacion
integer y = 300
integer width = 2807
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
boolean smoothscroll = true
end type

type st_7 from statictext within w_af900_calculo_depreciacion
integer x = 864
integer y = 224
integer width = 631
integer height = 56
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

type pb_procesar from picturebutton within w_af900_calculo_depreciacion
integer x = 736
integer y = 208
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

IF dw_report.Rowcount( ) = 0 THEN RETURN

Parent.Event dynamic ue_procesar()


end event

type st_6 from statictext within w_af900_calculo_depreciacion
integer x = 137
integer y = 224
integer width = 402
integer height = 60
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar datos"
boolean focusrectangle = false
end type

type pb_reporte from picturebutton within w_af900_calculo_depreciacion
integer y = 208
integer width = 105
integer height = 88
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Retrieve5!"
alignment htextalign = left!
end type

event clicked;
pb_asiento.Enabled = False
Parent.Event dynamic ue_mostrar_datos()

end event

type dw_report from u_dw_rpt within w_af900_calculo_depreciacion
integer y = 424
integer width = 2807
integer height = 1496
integer taborder = 40
string dataobject = "dw_calculo_depreciacion_tbl"
end type

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type em_veda from editmask within w_af900_calculo_depreciacion
integer x = 1979
integer y = 68
integer width = 183
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0"
string minmax = "0~~100"
end type

event modified;String 	ls_null
Long		ll_valor

SetNull(ls_null)

ll_valor = Long(em_veda.Text)

IF ll_valor < 0 OR ll_valor > 100 THEN
	MessageBox('Aviso', 'Debe Ingresar un dato Válido')
	This.Text = '0'
	RETURN 
END IF

em_prod.Text = String( 100 - ll_valor , '##0')
end event

type em_prod from editmask within w_af900_calculo_depreciacion
integer x = 1586
integer y = 68
integer width = 183
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0"
string minmax = "0~~100"
end type

event modified;String 	ls_null
Long		ll_valor

SetNull(ls_null)

ll_valor = Long(em_prod.Text)
IF ll_valor < 0 OR ll_valor > 100 THEN
	MessageBox('Aviso', 'Debe Ingresar un dato Válido')
	This.Text = '0'
	RETURN 
END IF


em_veda.Text = String( 100 - ll_valor, '##0')
end event

type em_year from editmask within w_af900_calculo_depreciacion
integer x = 805
integer y = 68
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

event modified;String ls_fecha
Long	 ll_mes

ll_mes = long(em_mes.text)

ls_fecha = String('01'+'/'+string(ll_mes + 1, '00') +'/' + This.text)

em_fecha.text = String(Relativedate(date(ls_fecha), -1))

//pb_reporte.event clicked( )
end event

type em_mes from editmask within w_af900_calculo_depreciacion
integer x = 1166
integer y = 72
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

event modified;Long  	ll_mes
String 	ls_fecha
date		ld_fecha

ll_mes = long(em_mes.text)

IF ll_mes < 1 OR ll_mes > 12 OR Isnull(ll_mes) THEN
	MessageBox('Aviso', 'Debe El valor para el mes no es correcto')
	This.text  = String(Month(today()))
	RETURN 1
END IF

ls_fecha = String('01'+'/'+string(ll_mes + 1, '00') +'/' +  em_year.text)

em_fecha.text = String(Relativedate(date(ls_fecha), -1))

//pb_reporte.event clicked( )


end event

type st_1 from statictext within w_af900_calculo_depreciacion
integer x = 667
integer y = 84
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

type st_2 from statictext within w_af900_calculo_depreciacion
integer x = 1033
integer y = 84
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

type sle_origen from singlelineedit within w_af900_calculo_depreciacion
event dobleclick pbm_lbuttondblclk
integer x = 23
integer y = 68
integer width = 119
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

type st_descripcion from statictext within w_af900_calculo_depreciacion
integer x = 165
integer y = 68
integer width = 453
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

type st_4 from statictext within w_af900_calculo_depreciacion
integer x = 1422
integer y = 88
integer width = 183
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Prod:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_af900_calculo_depreciacion
integer x = 1792
integer y = 88
integer width = 183
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Veda:"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_af900_calculo_depreciacion
integer x = 649
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

type gb_2 from groupbox within w_af900_calculo_depreciacion
integer width = 635
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

type gb_3 from groupbox within w_af900_calculo_depreciacion
integer x = 1408
integer y = 4
integer width = 791
integer height = 184
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "% Para Matrices"
end type

