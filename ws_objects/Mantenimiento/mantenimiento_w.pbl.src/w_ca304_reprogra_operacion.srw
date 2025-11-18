$PBExportHeader$w_ca304_reprogra_operacion.srw
forward
global type w_ca304_reprogra_operacion from w_cns
end type
type ddlb_1 from dropdownlistbox within w_ca304_reprogra_operacion
end type
type st_actualizando from statictext within w_ca304_reprogra_operacion
end type
type cb_aceptar_subsecuentes from commandbutton within w_ca304_reprogra_operacion
end type
type cb_cancelar from commandbutton within w_ca304_reprogra_operacion
end type
type cb_aceptar_registro from commandbutton within w_ca304_reprogra_operacion
end type
type dw_tiempos from datawindow within w_ca304_reprogra_operacion
end type
type st_terminado from statictext within w_ca304_reprogra_operacion
end type
type st_activo from statictext within w_ca304_reprogra_operacion
end type
type st_anulado from statictext within w_ca304_reprogra_operacion
end type
type em_mes_ano from editmask within w_ca304_reprogra_operacion
end type
type cb_ciclo_corte from commandbutton within w_ca304_reprogra_operacion
end type
type st_2 from statictext within w_ca304_reprogra_operacion
end type
type cb_campo from commandbutton within w_ca304_reprogra_operacion
end type
type st_1 from statictext within w_ca304_reprogra_operacion
end type
type st_3 from statictext within w_ca304_reprogra_operacion
end type
type cb_detalles from commandbutton within w_ca304_reprogra_operacion
end type
type dw_grafico from datawindow within w_ca304_reprogra_operacion
end type
end forward

global type w_ca304_reprogra_operacion from w_cns
integer x = 59
integer y = 84
integer width = 3511
integer height = 1740
string title = "Reprogramación de Operaciones (CA304)"
string menuname = "m_cns"
ddlb_1 ddlb_1
st_actualizando st_actualizando
cb_aceptar_subsecuentes cb_aceptar_subsecuentes
cb_cancelar cb_cancelar
cb_aceptar_registro cb_aceptar_registro
dw_tiempos dw_tiempos
st_terminado st_terminado
st_activo st_activo
st_anulado st_anulado
em_mes_ano em_mes_ano
cb_ciclo_corte cb_ciclo_corte
st_2 st_2
cb_campo cb_campo
st_1 st_1
st_3 st_3
cb_detalles cb_detalles
dw_grafico dw_grafico
end type
global w_ca304_reprogra_operacion w_ca304_reprogra_operacion

type variables
String is_corr_corte, is_operaciones


end variables

forward prototypes
public subroutine of_de_detalle_a_grafico ()
public function datetime of_relative_date_times (datetime adt_fecha_hora, integer ai_incremento)
public function integer of_utl_ult_dia_mes (integer ai_ano, integer ai_mes)
public function date of_utl_dia_inicial_del_ano (integer ai_ano, integer ai_mes)
public subroutine of_lineas_s (integer ai_mes, integer ai_ano)
public function date of_utl_dia_inicial_proceso (date ad_ini_ano, ref integer ai_mes, ref integer ai_semana)
public subroutine of_utl_grafica_sem (integer ai_semana_boton, integer ai_semana_calendario, ref integer ai_s_posini, ref integer ai_s_ancho)
public subroutine of_utl_grafica_mes (integer ai_mes_boton, integer ai_mes_calendario, ref integer ai_m_posini, ref integer ai_m_ancho)
public function integer of_utl_dias_a_procesar (integer ai_ano, integer ai_mes, string as_quetipo)
public subroutine of_utl_nuevo_dia (ref boolean ab_nueva_semana, ref boolean ab_nuevo_mes, ref boolean ab_nuevo_ano, ref date ai_fecha, ref integer ai_mes_cal, ref integer ai_sem_cal, ref integer ai_mes_cb, ref integer ai_sem_cb, string as_quetipo)
public subroutine of_utl_grafica_dia (integer ai_dia_boton, integer ai_dia_calendario, ref integer ai_s_posini, ref integer ai_s_ancho, string as_quetipo, long al_color)
public function string of_subsecuentes (string as_corr_corte, integer ai_nro_operacion, datetime ad_fec_inicio, integer ai_subsecuencia, decimal ad_dias_duracion_proy, long al_corr_corte_en_pd)
public subroutine of_lineas_d (integer ai_mes, integer ai_ano)
public subroutine of_botones (string as_lanzador)
public subroutine of_lineas (integer ai_mes, integer ai_ano)
end prototypes

public subroutine of_de_detalle_a_grafico ();Long ll_row_grafico, ll_row_tiempos

ll_row_grafico = dw_grafico.GetRow()
ll_row_tiempos = dw_tiempos.GetRow()

dw_grafico.Object.cod_labor[ll_row_grafico] = dw_tiempos.Object.operaciones_cod_labor[ll_row_tiempos]
dw_grafico.Object.fec_inicio[ll_row_grafico] = dw_tiempos.Object.operaciones_fec_Inicio[ll_row_tiempos]
dw_grafico.Object.dias_duracion_proy[ll_row_grafico] = dw_tiempos.Object.operaciones_dias_duracion_proy[ll_row_tiempos]

end subroutine

public function datetime of_relative_date_times (datetime adt_fecha_hora, integer ai_incremento);date ld_fecha
time lt_hora
ld_fecha = date( adt_fecha_hora )
lt_hora  = time( adt_fecha_hora )
Return DateTime( &
                RelativeDate( ld_fecha, ai_incremento ), &
					               lt_hora )

end function

public function integer of_utl_ult_dia_mes (integer ai_ano, integer ai_mes);Integer li_dias
If ai_mes=2 and mod(ai_ano,4)=0 Then
	li_dias = 29
Else
	Choose Case ai_mes
		CASE 1, 3, 5, 7, 8, 10, 12
			li_dias = 31
      CASE 4, 6, 9, 11 
			li_dias = 30 
      Case else
			li_dias = 28 
	END CHOOSE
end if
Return li_dias

end function

public function date of_utl_dia_inicial_del_ano (integer ai_ano, integer ai_mes);Integer li_dias, li_dia_inicial
String  ls_expression, ls_dayname, ls_fecha
date	  ld_fecha
// of_utl_dia_inicial_del_ano 06-Jul-00
// determina día inicial del año recordando que la semana productiva comienza en domingo
ls_expression = string(ai_ano, "0000") + "-" + string(1, "00"  ) + "-" 
FOR li_dias=1 TO 7
	 ls_fecha = ls_expression + string(li_dias, "00" )
	 ld_fecha = Date( ls_fecha )
	 ls_dayname = dayname( ld_fecha )
	 If pos( 'sundaydomingo', lower(ls_dayname)) > 0 Then
	 	 li_dia_inicial = li_dias
	 End if
NEXT
Return ( Date(ls_expression + string(li_dia_inicial, "00" ) ) )
end function

public subroutine of_lineas_s (integer ai_mes, integer ai_ano);// definiendo variables de las funciones //
Integer li_dias_a_procesar 
date	  ld_fecha_a_procesar
Integer li_mes_cal=0, li_sem_cal=0, li_mes_cb=0, li_sem_cb=0
li_dias_a_procesar  = of_utl_dias_a_procesar ( ai_ano, ai_mes, 'semanal' )
li_mes_cal = ai_mes
ld_fecha_a_procesar = of_utl_dia_inicial_proceso ( &
						of_utl_dia_inicial_del_ano ( ai_ano, ai_mes ), &
						li_mes_cal, li_sem_cal)
// variables del programa //
INTEGER li_dia_proceso // para el for
Integer li_s_ancho=0, li_m_ancho=0
Integer li_s_posini = 800, li_m_posini = 800
Boolean lb_primer_dia=TRUE, lb_nueva_semana, lb_nuevo_mes, lb_nuevo_ano=False
String  ls_mes, ls_dia

ls_dia = "daysafter(" + string(ai_ano, "0000") + "-" + &
                string(ai_mes, "00"  ) + "-01, fec_inicio)" 
ls_dia = "daysafter(" +  string(ld_fecha_a_procesar, "yyyy-mm-dd")+ ", fec_inicio)" 
dw_grafico.object.dias_ini.expression = ls_dia  //"daysafter(  2000-01-01, fec_inicio )"

// solo para ocultar último mes :-)
dw_grafico.Modify("cb_m_13.Visible=FALSE")
dw_grafico.Modify("corr_corte.Visible=FALSE")
dw_grafico.Modify("dias_ini.Visible=FALSE")


FOR li_dia_proceso = 1 TO li_dias_a_procesar+7
	 IF lb_primer_dia=TRUE THEN
	    lb_primer_dia=FALSE
	 ELSE
		 IF lb_nueva_semana=TRUE THEN
			 of_utl_grafica_sem ( li_sem_cb, li_sem_cal, li_s_posini, li_s_ancho )
			 IF lb_nuevo_ano=TRUE AND lb_nueva_semana=TRUE THEN
				 li_sem_cal=0
				 lb_nuevo_ano=FALSE
			 END IF
		 END IF
		 IF lb_nuevo_mes=TRUE THEN
			 of_utl_grafica_mes ( li_mes_cb, li_mes_cal, li_m_posini, li_m_ancho )
		 END IF
	 End IF
  	 of_utl_nuevo_dia( lb_nueva_semana, lb_nuevo_mes, lb_nuevo_ano, &
							 ld_fecha_a_procesar, &
							 li_mes_cal, li_sem_cal, li_mes_cb, li_sem_cb, 'semanal')
	 li_s_ancho = li_s_ancho + 14
	 li_m_ancho = li_m_ancho + 14
NEXT
dw_grafico.visible = False
em_mes_ano.enabled = False

dw_grafico.visible = True
em_mes_ano.enabled = True
end subroutine

public function date of_utl_dia_inicial_proceso (date ad_ini_ano, ref integer ai_mes, ref integer ai_semana);// of_ult_mmdd_inicial 06-Jul-00
// determina el mes y el día que contenga a la primera referencia a la semana del mes...
// por ejemplo si fuera Agosto, debiera comenzar en julio dom(30), lun(31), mar(1)

//toma el domingo que viene y busca el sábado
Integer li_semana, li_mes
li_semana = 0
li_mes = 0
DO WHILE Month( RelativeDate(ad_ini_ano, 7) ) < ai_mes 
	ad_ini_ano = RelativeDate(ad_ini_ano, 7)
	li_semana = li_semana + 1
	IF Month( RelativeDate(ad_ini_ano, 7) ) <> Month( ad_ini_ano ) AND &
		Month( RelativeDate(ad_ini_ano, 7) ) < ai_mes THEN
	   li_mes = li_mes + 1
	End If
LOOP
ai_mes = li_mes
ai_semana = li_semana
Return (ad_ini_ano)


end function

public subroutine of_utl_grafica_sem (integer ai_semana_boton, integer ai_semana_calendario, ref integer ai_s_posini, ref integer ai_s_ancho);// of_utl_grafica_sem  	ai_semana	ai_s_posini(out)	ai_s_ancho(out)
String ls_semana, ls_semana_calendario
String  ls_cb_s_Text, ls_cb_s_x, ls_cb_s_Width, ls_line_s_x1, ls_line_s_x2 // para el modify

ls_semana 				= String( ai_semana_boton, "00")
ls_semana_calendario = String( ai_semana_calendario, "00")
ls_cb_s_Text 	= "cb_s_"	+ls_semana	+".Text = '" + ls_semana_calendario + "'"
ls_cb_s_x	  	= "cb_s_"	+ls_semana	+".x 	  = '" + String(ai_s_posini) + "'"
ls_cb_s_Width = "cb_s_"	+ls_semana	+".Width  = '" + String(ai_s_ancho) + "'"
ls_line_s_x1	= "line_s_"	+ls_semana	+".x1  = '" + String(ai_s_posIni) + "'"
ls_line_s_x2	= "line_s_"	+ls_semana	+".x2  = '" + String(ai_s_posIni) + "'"
dw_grafico.Modify(ls_cb_s_Text)
dw_grafico.Modify(ls_cb_s_x)
dw_grafico.Modify(ls_cb_s_Width)
dw_grafico.Modify(ls_line_s_x1)
dw_grafico.Modify(ls_line_s_x2)
ai_s_posini	= ai_s_posini + ai_s_ancho 
ai_s_ancho 	= 0

end subroutine

public subroutine of_utl_grafica_mes (integer ai_mes_boton, integer ai_mes_calendario, ref integer ai_m_posini, ref integer ai_m_ancho);String  ls_mes, ls_meses, ls_mes_calendario 
String  ls_cb_m_Text, ls_cb_m_x, ls_cb_m_Width, ls_cb_m_visible // para el modify

ls_meses = "EneFebMarAbrMayJunJulAgoSetOctNovDic"
ls_mes 				= String( ai_mes_boton, "00")
ls_mes_calendario = mid(ls_meses, (ai_mes_calendario - 1)*3+1, 3)
ls_cb_m_Text 	= "cb_m_"	+ls_mes	+".Text = '" + ls_mes_calendario + "'"
ls_cb_m_x	  	= "cb_m_"	+ls_mes	+".x 	  = '" + String(ai_m_posini) + "'"
ls_cb_m_Width 	= "cb_m_"	+ls_mes	+".Width  = '" + String(ai_m_ancho) + "'"
ls_cb_m_Visible= "cb_m_"	+ls_mes	+".Visible=TRUE"
dw_grafico.Modify(ls_cb_m_Text)
dw_grafico.Modify(ls_cb_m_x)
dw_grafico.Modify(ls_cb_m_Width)
dw_grafico.Modify(ls_cb_m_Visible)
ai_m_posini	= ai_m_posini + ai_m_ancho 
ai_m_ancho		= 0

end subroutine

public function integer of_utl_dias_a_procesar (integer ai_ano, integer ai_mes, string as_quetipo);// of_dias_a_procesar
// 06-Jul-00 Determinar el número de días que ocupará el año + los días del siguiente año
// suficientes para cerrar la semana
Integer li_dias_a_procesar, li_dias
String  ls_expression, ls_dayname, ls_fecha
Date ld_fecha
// solo para diario 
Integer li_mes = 0

Choose case as_quetipo
	case 'semanal'
		If mod(ai_ano, 4) = 0  Then
		   li_dias_a_procesar = 366
		Else
			li_dias_a_procesar = 365
		End If
		ls_expression = string(ai_ano+1, "0000") + "-" + string(ai_mes, "00"  ) + "-" 
		FOR li_dias=1 TO 7
			 ls_fecha = ls_expression + string(li_dias, "00" )
			 ld_fecha = Date( ls_fecha )
			 ls_dayname = dayname( ld_fecha )
			 If pos( 'sunday,domingo', lower(ls_dayname)) = 0 Then
			 	 li_dias_a_procesar = li_dias_a_procesar +1
			 End if
		NEXT
	case 'diario'
		ls_expression = string(ai_ano, "0000") + "-" + string(ai_mes, "00"  ) + "-01" 
		ld_fecha = Date( ls_expression )
		DO WHILE li_mes < 3
			If Month(ld_fecha) <> Month(RelativeDate( ld_fecha, 1)) THEN
				li_mes = li_mes + 1
			End if
			ld_fecha = RelativeDate( ld_fecha, 1)
			li_dias_a_procesar = li_dias_a_procesar + 1
		LOOP
End choose		
Return( li_dias_a_procesar )
	
end function

public subroutine of_utl_nuevo_dia (ref boolean ab_nueva_semana, ref boolean ab_nuevo_mes, ref boolean ab_nuevo_ano, ref date ai_fecha, ref integer ai_mes_cal, ref integer ai_sem_cal, ref integer ai_mes_cb, ref integer ai_sem_cb, string as_quetipo);Date 	 ld_fecha 
ld_fecha = relativedate( ai_fecha, 1 )
choose case as_quetipo
	case 'semanal'
		if pos('sunday,domingo', lower(dayname(ld_fecha)))>0 THEN
		   ab_nueva_semana=TRUE
			ai_sem_cal = ai_sem_cal + 1
			ai_sem_cb  = ai_sem_cb  + 1
		Else
		   ab_nueva_semana=FALSE
		End If
	case 'diario'
		ai_sem_cal = day( ld_fecha ) 
		ai_sem_cb  = ai_sem_cb  + 1 // día
end choose
if Month(ld_fecha)<>Month(ai_fecha) THEN
   ab_nuevo_mes=TRUE
	ai_mes_cal = ai_mes_cal + 1
	ai_mes_cb  = ai_mes_cb  + 1
	if ai_mes_cal = 13 THEN
	   ai_mes_cal = 1
	end if
Else
   ab_nuevo_mes=FALSE
End If
if Year(ld_fecha)<>Year(ai_fecha) THEN
	ab_nuevo_ano  = TRUE
End If
// actualizando la nueva fecha
ai_fecha = ld_fecha
end subroutine

public subroutine of_utl_grafica_dia (integer ai_dia_boton, integer ai_dia_calendario, ref integer ai_s_posini, ref integer ai_s_ancho, string as_quetipo, long al_color);// of_utl_grafica_sem  	ai_semana	ai_s_posini(out)	ai_s_ancho(out), as_quetipo
// as_quetipo('todo', 'sololinea' )
String ls_semana, ls_semana_calendario
String  ls_cb_s_Text, ls_cb_s_x, ls_cb_s_Width, ls_line_s_x1, ls_line_s_x2 // para el modify
String  ls_cb_s_Visible, ls_line_s_Visible, ls_line_s_color  // para el modify

ls_semana 				= String( ai_dia_boton, "00")
ls_semana_calendario = String( ai_dia_calendario, "00")
ls_cb_s_Text 		= "cb_d_"	+ls_semana	+".Text = '" + ls_semana_calendario + "'"
ls_cb_s_x	  		= "cb_d_"	+ls_semana	+".x 	  = '" + String(ai_s_posini) + "'"
ls_cb_s_Width 		= "cb_d_"	+ls_semana	+".Width  = '" + String(ai_s_ancho) + "'"
ls_cb_s_Visible	= "cb_d_"	+ls_semana	+".Visible=TRUE"
ls_line_s_x1		= "line_s_"	+ls_semana	+".x1  = '" + String(ai_s_posIni) + "'"
ls_line_s_x2		= "line_s_"	+ls_semana	+".x2  = '" + String(ai_s_posIni) + "'"
ls_line_s_Visible	= "line_s_"	+ls_semana	+".Visible=TRUE"
ls_line_s_Color	= "line_s_"	+ls_semana	+".Pen.Color=" + string(al_color)
//dw_grafico.object.line_1_01.Pen.Color = ll_color

if as_quetipo = 'todo' Then
	dw_grafico.Modify(ls_cb_s_Text)
	dw_grafico.Modify(ls_cb_s_x)
	dw_grafico.Modify(ls_cb_s_Width)
	if ai_dia_boton > 88 Then
		dw_grafico.Modify(ls_cb_s_Visible)
	end if
End If
dw_grafico.Modify(ls_line_s_x1)
dw_grafico.Modify(ls_line_s_x2)
dw_grafico.Modify(ls_line_s_Color)
if ai_dia_boton > 88 Then
	dw_grafico.Modify(ls_line_s_Visible)
end if
ai_s_posini	= ai_s_posini + ai_s_ancho 
ai_s_ancho 	= 0
end subroutine

public function string of_subsecuentes (string as_corr_corte, integer ai_nro_operacion, datetime ad_fec_inicio, integer ai_subsecuencia, decimal ad_dias_duracion_proy, long al_corr_corte_en_pd);DataStore lds_1
Long ll_filas, ll_fila, li_nro_operacion, ll_oper_sec_en_pdl
DateTime ldt_Fec_Inicio
String ls_return, ls_mensaje, ls_flag_pre, ls_flag_estado
Integer li_dias_para_inicio, li_dias_duracion_proy
Dec ldc_oper_sec

ls_return = 'ok'
st_actualizando.Text = 'Subsecuencia:'+String(ai_subsecuencia) + " <<< Actualizando: " + String( ai_nro_operacion ) + " >>>"

lds_1 = Create DataStore
lds_1.DataObject = "d_reprogra_ope_subsecuentes_tbl"
lds_1.SetTransObject(SQLCA)
ll_Filas = lds_1.Retrieve(as_corr_corte, ai_nro_operacion )
For ll_Fila = 1 to ll_Filas
	 li_nro_operacion = lds_1.getitemNumber(ll_fila,"Nro_Operacion")
	 if Pos(is_operaciones, " "+string(li_nro_operacion)+" " ) = 0 Then 
   	 li_dias_para_inicio 	= lds_1.getitemNumber(ll_fila,"Dias_Para_Inicio")
   	 ldc_oper_sec          	= lds_1.getitemNumber(ll_fila,"Oper_Sec")
		 ls_flag_pre            = lds_1.getitemString(ll_fila,"flag_pre")
		 
		 //Select count(*) into :ll_oper_sec_en_pdl from pd_labores pdl 
		 // where pdl.oper_sec = :ldc_oper_sec ;
		 select o.flag_estado into :ls_flag_estado 
		   from operaciones o where o.oper_sec = :ldc_oper_sec ;
		 if isnull( ls_flag_estado ) Then
			 ls_flag_estado = '1'
		 end if
		 
     //If ll_oper_sec_en_pdl > 0 then 
		 If ls_flag_estado = '0' or ls_flag_estado = '2' Then //0=Anu, 1=Act, 2=Term, 3=Plan
	       li_dias_duracion_proy 	= lds_1.getitemNumber(ll_fila,"dias_duracion_proy")
      	 ldt_Fec_Inicio        	= lds_1.getitemDateTime(ll_fila,"Fec_inicio")
			 If isNull( li_dias_duracion_proy ) Then 
 				 li_dias_duracion_proy = 0
			 End If 
   	    is_operaciones = is_operaciones + String(li_nro_operacion) + " "
   		 of_subsecuentes ( as_corr_corte, li_nro_operacion, &
      	                   ldt_Fec_Inicio, & 
		   						ai_subsecuencia+1, li_dias_duracion_proy , al_corr_corte_en_pd )

			 continue 
		 end if
		 
		 
		 if isnull(li_dias_para_inicio) Then
			 li_dias_para_inicio=0
		 end if
	    li_dias_duracion_proy 	= lds_1.getitemNumber(ll_fila,"dias_duracion_proy")
		 if ls_flag_pre = 'I' Then // Tomar de la Precedencia la fecha Inicial/Final
      	 ldt_Fec_Inicio = of_Relative_Date_Times( ad_fec_inicio, li_dias_para_inicio)
       else
      	 ldt_Fec_Inicio = of_Relative_Date_Times( ad_fec_inicio, &
                           li_dias_para_inicio + ad_dias_duracion_proy )
       end if
	    // actualiza las operaciones //
		 If al_corr_corte_en_pd > 0 Then 
   		 Update Operaciones
      	    Set Fec_Inicio = :ldt_Fec_Inicio
	        Where Corr_Corte	 = :as_corr_corte And
   	           Nro_Operacion = :li_nro_operacion;
  		 else
   		 Update Operaciones
      	    Set Fec_Inicio = :ldt_Fec_Inicio,
				     Fec_inicio_est = :ldt_Fec_Inicio
	        Where Corr_Corte	 = :as_corr_corte And
   	           Nro_Operacion = :li_nro_operacion;
       end if
       IF SQLCA.SQLNRows > 0 THEN
		    // actualiza movimiento proyectado
   		 update articulo_mov_proy 
             set fec_proyect = :ldt_Fec_Inicio
           where oper_sec = :ldc_oper_sec ;
			  
         ls_mensaje = 'Articulo_mov_proy ==> Fecha:' + string(ldt_Fec_Inicio) + ' ' + &
			             'Operación:' + string( ldc_oper_sec, '##,###,###' ) + ' ' + & 
							 'Registros:' + String( SQLCA.SQLNRows, '##,###,###' ) 
			 w_ca304_reprogra_operacion.SetMicroHelp( ls_mensaje ) 
	      is_operaciones = is_operaciones + String(li_nro_operacion) + " "
   		   of_subsecuentes ( as_corr_corte, li_nro_operacion, &
      	                     ldt_Fec_Inicio, & 
		   							ai_subsecuencia+1, li_dias_duracion_proy , al_corr_corte_en_pd )
       Else
	   	MessageBox( "Error!!!", "No se pudo grabar la operación: " + String (li_nro_operacion) ) 
			ls_return = 'error'
       END IF
	 else
		 MessageBox(" Circular ", " El número de operación " + String(li_nro_operacion) + &
                  " ya ha sido referenciado. Las operaciones sub-secuentes no serán " + &
						" tomadas en cuenta" )
		ls_return = 'circular'
    end If
Next
Destroy lds_1
w_ca304_reprogra_operacion.SetMicroHelp( '' ) 

Return 'Error'
end function

public subroutine of_lineas_d (integer ai_mes, integer ai_ano);// definiendo variables de las funciones //
Integer li_dias_a_procesar
date	  ld_fecha_a_procesar, ld_fecha_inicial
Integer li_mes_cal=0, li_dia_cal=0, li_mes_cb=0, li_dia_cb=0
li_dias_a_procesar  = of_utl_dias_a_procesar ( ai_ano, ai_mes, 'diario' )
ld_fecha_a_procesar = Date (string(ai_ano, "0000") + "-" + string(ai_mes, "00"  ) + "-" + &
			 		 				 string(1, "00" ) )
ld_fecha_inicial    = ld_fecha_a_procesar										
ld_fecha_a_procesar = RelativeDate ( ld_fecha_a_procesar, -1 )
li_mes_cal = ai_mes - 2
						
// variables del programa //
INTEGER li_dia_proceso // para el for
Integer li_s_ancho=0, li_m_ancho=0
Integer li_s_posini = 800, li_m_posini = 800
Boolean lb_primer_dia=TRUE, lb_nueva_semana, lb_nuevo_mes, lb_nuevo_ano=False
String  ls_mes, ls_semana
Long 	  ll_color

ls_semana = "daysafter(" + string(ai_ano, "0000") + "-" + &
                string(ai_mes, "00"  ) + "-01, fec_inicio)" 
dw_grafico.object.dias_ini.expression = ls_semana  //"daysafter(  2000-01-01, fec_inicio )"

// solo para ocultar último mes :-)
//ls_mes = dw_grafico.Describe("r_1.width")
//dw_grafico.Modify("r_1.width='dias_duracion_proy*84'")
//ls_semana = dw_grafico.Describe("r_1.width")
//Messagebox(ls_mes, ls_semana)

dw_grafico.Modify("cb_d_89.Visible=FALSE")
dw_grafico.Modify("cb_d_90.Visible=FALSE")
dw_grafico.Modify("cb_d_91.Visible=FALSE")
dw_grafico.Modify("cb_d_92.Visible=FALSE")
dw_grafico.Modify("cb_d_93.Visible=FALSE")
dw_grafico.Modify("line_s_89.Visible=FALSE")
dw_grafico.Modify("line_s_90.Visible=FALSE")
dw_grafico.Modify("line_s_91.Visible=FALSE")
dw_grafico.Modify("line_s_92.Visible=FALSE")
dw_grafico.Modify("line_s_93.Visible=FALSE")
dw_grafico.Modify("corr_corte.Visible=FALSE")
dw_grafico.Modify("dias_ini.Visible=FALSE")

FOR li_dia_proceso = 1 TO li_dias_a_procesar+1
	 IF lb_primer_dia=TRUE THEN
	    lb_primer_dia=FALSE
	 ELSE
		 of_utl_grafica_dia ( li_dia_cb, li_dia_cal, li_s_posini, li_s_ancho, 'todo', ll_color )
	 End IF
  	 of_utl_nuevo_dia( lb_nueva_semana, lb_nuevo_mes, lb_nuevo_ano, &
							 ld_fecha_a_procesar, &
							 li_mes_cal, li_dia_cal, li_mes_cb, li_dia_cb, 'diario')
	 If ld_fecha_inicial = ld_fecha_a_procesar and lb_nuevo_mes=TRUE THEN
		 lb_nuevo_mes=False
	 End If 
    ll_color = rgb(255,0,0)
	 IF lb_nuevo_mes=TRUE THEN
		 ll_color = RGB(255,0,0)
		 ll_color = RGB(0,255,128)
		 of_utl_grafica_mes ( li_mes_cb, li_mes_cal, li_m_posini, li_m_ancho )
	 END IF
	 li_s_ancho = 84 // li_s_ancho + 14
	 li_m_ancho = li_m_ancho + li_s_ancho
	 if li_dia_proceso = li_dias_a_procesar - 1 THEN
		 li_s_ancho = 84 // li_s_ancho + 14
	 end if
NEXT
of_utl_grafica_dia ( li_dia_cb, li_dia_cal, li_s_posini, li_s_ancho, 'sololinea', ll_color )
dw_grafico.visible = False
em_mes_ano.enabled = False

dw_grafico.visible = True
em_mes_ano.enabled = True
end subroutine

public subroutine of_botones (string as_lanzador);choose case as_lanzador
	case 'dw_tiempos.editchanged'
		cb_campo.Enabled = False
		cb_ciclo_corte.Enabled = False
		dw_grafico.Enabled = False
		em_mes_ano.Enabled = False
		cb_aceptar_registro.Enabled = True
		cb_aceptar_subsecuentes.Enabled = True
		cb_cancelar.Enabled = True
		cb_detalles.Enabled = False
	case 'cb_aceptar_registro', &
		  'cb_cancelar'
		cb_campo.Enabled = True
		cb_ciclo_corte.Enabled = True
		dw_grafico.Enabled = True
		em_mes_ano.Enabled = True
		cb_aceptar_registro.Enabled = False
		cb_aceptar_subsecuentes.Enabled = False
		cb_cancelar.Enabled = False
		cb_detalles.Enabled = True
end choose

end subroutine

public subroutine of_lineas (integer ai_mes, integer ai_ano);Integer li_dias
Integer li_posini, li_contador
String  ls_expression, ls_mes, ls_meses
Long 	  ll_color, ll_colper

ls_meses = "EneFebMarAbrMayJunJulAgoSetOctNovDic"

li_posini 	  = 800 // primera posición de la línea a partir de la fecha indicada
ls_expression = "daysafter(" + String(ai_ano, "0000") + "-" + &
                String(ai_mes, "00"  ) + "-01, fec_inicio)" 
					 

dw_grafico.object.dias_ini.expression = ls_expression  
dw_grafico.object.dias_ini.visible    = FALSE

dw_grafico.Modify("corr_corte.Visible = FALSE")
dw_grafico.Modify("dias_ini.Visible   = FALSE")
dw_grafico.visible = FALSE

ll_colper = rgb(128,128,128)

IF ai_mes=1 THEN
   ll_color = rgb(0,255,128)
ELSE
	ll_color = RGB(255,0,0)
END IF

dw_grafico.object.line_1_01.Pen.Color = ll_color
dw_grafico.object.line_1_01.x1=li_posini
dw_grafico.object.line_1_01.x2=li_posini
dw_grafico.object.cb_1_01.x=li_posini
dw_grafico.object.cb_1_01.background.color=ll_colper

FOR li_contador = 2 TO 37
    IF ai_mes=2 AND mod(ai_ano,4)=0 THEN
   	 li_dias = 29
	 ELSE
       Choose Case ai_mes
	    CASE 1, 3, 5, 7, 8, 10, 12
			   li_dias = 31
       CASE 4, 6, 9, 11 
	       	li_dias = 30 
		 CASE ELSE
		    	li_dias = 28 
       END CHOOSE
   END IF
	
   IF ai_mes+1 = 1 OR ai_mes+1=13 THEN
      ll_color = rgb(0,255,128)
   ELSE
   	ll_color = RGB(255,0,0)
   END IF
	
   IF ai_mes=1 THEN
		IF ll_colper = rgb(128,128,128) THEN
		   ll_colper = rgb(192,192,192)
		ELSE
         ll_colper = rgb(128,128,128)
		END IF
   END IF
	
	li_posini = li_posini + li_dias*7
	ls_mes    = mid(ls_meses, (ai_mes - 1)*3+1, 3)
	
	CHOOSE CASE li_contador
			 CASE 2
					dw_grafico.object.cb_1_01.Text  = ls_mes
					dw_grafico.object.cb_1_01.Background.Color = ll_colper
					dw_grafico.object.cb_1_01.width = li_dias * 7
			      dw_grafico.object.line_1_02.x1  = li_posini
		         dw_grafico.object.line_1_02.x2		  = li_posini
      		   dw_grafico.object.line_1_02.Pen.Color = ll_color
         		dw_grafico.object.cb_1_02.x=li_posini
			 CASE 3
					dw_grafico.object.cb_1_02.Text = ls_mes
					dw_grafico.object.cb_1_02.Background.Color = ll_colper
					dw_grafico.object.cb_1_02.width=li_dias*7
	      		dw_grafico.object.line_1_03.x1=li_posini
         		dw_grafico.object.line_1_03.x2=li_posini
         		dw_grafico.object.line_1_03.Pen.Color = ll_color
         		dw_grafico.object.cb_1_03.x=li_posini
			CASE 4
					dw_grafico.object.cb_1_03.Text = ls_mes
					dw_grafico.object.cb_1_03.Background.Color = ll_colper
					dw_grafico.object.cb_1_03.width=li_dias*7
			      dw_grafico.object.line_1_04.x1=li_posini
			      dw_grafico.object.line_1_04.x2=li_posini
			      dw_grafico.object.line_1_04.Pen.Color = ll_color
		         dw_grafico.object.cb_1_04.x=li_posini
			CASE 5
					dw_grafico.object.cb_1_04.Text = ls_mes
					dw_grafico.object.cb_1_04.Background.Color = ll_colper
					dw_grafico.object.cb_1_04.width=li_dias*7
			      dw_grafico.object.line_1_05.x1=li_posini
		         dw_grafico.object.line_1_05.x2=li_posini
		         dw_grafico.object.line_1_05.Pen.Color = ll_color
					dw_grafico.object.cb_1_05.x=li_posini
			CASE 6
					dw_grafico.object.cb_1_05.Text = ls_mes
					dw_grafico.object.cb_1_05.Background.Color = ll_colper
					dw_grafico.object.cb_1_05.width=li_dias*7
	      		dw_grafico.object.line_1_06.x1=li_posini
         		dw_grafico.object.line_1_06.x2=li_posini
         		dw_grafico.object.line_1_06.Pen.Color = ll_color
         		dw_grafico.object.cb_1_06.x=li_posini
			CASE 7
					dw_grafico.object.cb_1_06.Text = ls_mes
					dw_grafico.object.cb_1_06.Background.Color = ll_colper
					dw_grafico.object.cb_1_06.width=li_dias*7
	      		dw_grafico.object.line_1_07.x1=li_posini
         		dw_grafico.object.line_1_07.x2=li_posini
         		dw_grafico.object.line_1_07.Pen.Color = ll_color
         		dw_grafico.object.cb_1_07.x=li_posini
			CASE 8
					dw_grafico.object.cb_1_07.Text = ls_mes
					dw_grafico.object.cb_1_07.Background.Color = ll_colper
					dw_grafico.object.cb_1_07.width=li_dias*7
	      		dw_grafico.object.line_1_08.x1=li_posini
         		dw_grafico.object.line_1_08.x2=li_posini
         		dw_grafico.object.line_1_08.Pen.Color = ll_color
         		dw_grafico.object.cb_1_08.x=li_posini
			CASE 9
					dw_grafico.object.cb_1_08.Text = ls_mes
					dw_grafico.object.cb_1_08.Background.Color = ll_colper
					dw_grafico.object.cb_1_08.width=li_dias*7
	      		dw_grafico.object.line_1_09.x1=li_posini
         		dw_grafico.object.line_1_09.x2=li_posini
         		dw_grafico.object.line_1_09.Pen.Color = ll_color
         		dw_grafico.object.cb_1_09.x=li_posini
			CASE 10
					dw_grafico.object.cb_1_09.Text = ls_mes
					dw_grafico.object.cb_1_09.Background.Color = ll_colper
					dw_grafico.object.cb_1_09.width=li_dias*7
	      		dw_grafico.object.line_1_10.x1=li_posini
         		dw_grafico.object.line_1_10.x2=li_posini
         		dw_grafico.object.line_1_10.Pen.Color = ll_color
         		dw_grafico.object.cb_1_10.x=li_posini
			CASE 11
					dw_grafico.object.cb_1_10.Text = ls_mes
					dw_grafico.object.cb_1_10.Background.Color = ll_colper
					dw_grafico.object.cb_1_10.width=li_dias*7
	      		dw_grafico.object.line_1_11.x1=li_posini
         		dw_grafico.object.line_1_11.x2=li_posini
         		dw_grafico.object.line_1_11.Pen.Color = ll_color
         		dw_grafico.object.cb_1_11.x=li_posini
			CASE 12
					dw_grafico.object.cb_1_11.Text = ls_mes
					dw_grafico.object.cb_1_11.Background.Color = ll_colper
					dw_grafico.object.cb_1_11.width=li_dias*7
	      		dw_grafico.object.line_1_12.x1=li_posini
         		dw_grafico.object.line_1_12.x2=li_posini
         		dw_grafico.object.line_1_12.Pen.Color = ll_color
         		dw_grafico.object.cb_1_12.x=li_posini
			CASE 13
					dw_grafico.object.cb_1_12.Text = ls_mes
					dw_grafico.object.cb_1_12.Background.Color = ll_colper
					dw_grafico.object.cb_1_12.width=li_dias*7
			      dw_grafico.object.line_2_01.x1=li_posini
		         dw_grafico.object.line_2_01.x2=li_posini
		         dw_grafico.object.line_2_01.Pen.Color = ll_color
		         dw_grafico.object.cb_2_01.x=li_posini
			CASE 14
					dw_grafico.object.cb_2_01.Text = ls_mes
					dw_grafico.object.cb_2_01.Background.Color = ll_colper
					dw_grafico.object.cb_2_01.width=li_dias*7
	      		dw_grafico.object.line_2_02.x1=li_posini
         		dw_grafico.object.line_2_02.x2=li_posini
         		dw_grafico.object.line_2_02.Pen.Color = ll_color
         		dw_grafico.object.cb_2_02.x=li_posini
			CASE 15
					dw_grafico.object.cb_2_02.Text = ls_mes
					dw_grafico.object.cb_2_02.Background.Color = ll_colper
					dw_grafico.object.cb_2_02.width=li_dias*7
	      		dw_grafico.object.line_2_03.x1=li_posini
         		dw_grafico.object.line_2_03.x2=li_posini
         		dw_grafico.object.line_2_03.Pen.Color = ll_color
         		dw_grafico.object.cb_2_03.x=li_posini
			CASE 16
					dw_grafico.object.cb_2_03.Text = ls_mes
					dw_grafico.object.cb_2_03.Background.Color = ll_colper
					dw_grafico.object.cb_2_03.width=li_dias*7
	      		dw_grafico.object.line_2_04.x1=li_posini
         		dw_grafico.object.line_2_04.x2=li_posini
        			dw_grafico.object.line_2_04.Pen.Color = ll_color
         		dw_grafico.object.cb_2_04.x=li_posini
			CASE 17
					dw_grafico.object.cb_2_04.Text = ls_mes
					dw_grafico.object.cb_2_04.Background.Color = ll_colper
					dw_grafico.object.cb_2_04.width=li_dias*7
			      dw_grafico.object.line_2_05.x1=li_posini
		         dw_grafico.object.line_2_05.x2=li_posini
		         dw_grafico.object.line_2_05.Pen.Color = ll_color
	      	   dw_grafico.object.cb_2_05.x=li_posini
			CASE 18
					dw_grafico.object.cb_2_05.Text = ls_mes
					dw_grafico.object.cb_2_05.Background.Color = ll_colper
					dw_grafico.object.cb_2_05.width=li_dias*7
			      dw_grafico.object.line_2_06.x1=li_posini
		         dw_grafico.object.line_2_06.x2=li_posini
		         dw_grafico.object.line_2_06.Pen.Color = ll_color
		         dw_grafico.object.cb_2_06.x=li_posini
			CASE 19
					dw_grafico.object.cb_2_06.Text = ls_mes
					dw_grafico.object.cb_2_06.Background.Color = ll_colper
					dw_grafico.object.cb_2_06.width=li_dias*7
			      dw_grafico.object.line_2_07.x1=li_posini
		         dw_grafico.object.line_2_07.x2=li_posini
		         dw_grafico.object.line_2_07.Pen.Color = ll_color
		         dw_grafico.object.cb_2_07.x=li_posini
			CASE 20
					dw_grafico.object.cb_2_07.Text = ls_mes
					dw_grafico.object.cb_2_07.Background.Color = ll_colper
					dw_grafico.object.cb_2_07.width=li_dias*7
			      dw_grafico.object.line_2_08.x1=li_posini
		         dw_grafico.object.line_2_08.x2=li_posini
		         dw_grafico.object.line_2_08.Pen.Color = ll_color
		         dw_grafico.object.cb_2_08.x=li_posini
			CASE 21
					dw_grafico.object.cb_2_08.Text = ls_mes
					dw_grafico.object.cb_2_08.Background.Color = ll_colper
					dw_grafico.object.cb_2_08.width=li_dias*7
	      		dw_grafico.object.line_2_09.x1=li_posini
		         dw_grafico.object.line_2_09.x2=li_posini
		         dw_grafico.object.line_2_09.Pen.Color = ll_color
		         dw_grafico.object.cb_2_09.x=li_posini
			CASE 22
					dw_grafico.object.cb_2_09.Text = ls_mes
					dw_grafico.object.cb_2_09.Background.Color = ll_colper
					dw_grafico.object.cb_2_09.width=li_dias*7
			      dw_grafico.object.line_2_10.x1=li_posini
		         dw_grafico.object.line_2_10.x2=li_posini
		         dw_grafico.object.line_2_10.Pen.Color = ll_color
		         dw_grafico.object.cb_2_10.x=li_posini
			CASE 23
					dw_grafico.object.cb_2_10.Text = ls_mes
					dw_grafico.object.cb_2_10.Background.Color = ll_colper
					dw_grafico.object.cb_2_10.width=li_dias*7
			      dw_grafico.object.line_2_11.x1=li_posini
		         dw_grafico.object.line_2_11.x2=li_posini
		         dw_grafico.object.line_2_11.Pen.Color = ll_color
		         dw_grafico.object.cb_2_11.x=li_posini
			CASE 24
					dw_grafico.object.cb_2_11.Text = ls_mes
					dw_grafico.object.cb_2_11.Background.Color = ll_colper
					dw_grafico.object.cb_2_11.width=li_dias*7
			      dw_grafico.object.line_2_12.x1=li_posini
		         dw_grafico.object.line_2_12.x2=li_posini
		         dw_grafico.object.line_2_12.Pen.Color = ll_color
		         dw_grafico.object.cb_2_12.x=li_posini
			CASE 25
					dw_grafico.object.cb_2_12.Text = ls_mes
					dw_grafico.object.cb_2_12.Background.Color = ll_colper
					dw_grafico.object.cb_2_12.width=li_dias*7
			      dw_grafico.object.line_3_01.x1=li_posini
		         dw_grafico.object.line_3_01.x2=li_posini
		         dw_grafico.object.line_3_01.Pen.Color = ll_color
		         dw_grafico.object.cb_3_01.x=li_posini
			CASE 26
					dw_grafico.object.cb_3_01.Text = ls_mes
					dw_grafico.object.cb_3_01.Background.Color = ll_colper
					dw_grafico.object.cb_3_01.width=li_dias*7
			      dw_grafico.object.line_3_02.x1=li_posini
		         dw_grafico.object.line_3_02.x2=li_posini
		         dw_grafico.object.line_3_02.Pen.Color = ll_color
		         dw_grafico.object.cb_3_02.x=li_posini
			CASE 27
					dw_grafico.object.cb_3_02.Text = ls_mes
					dw_grafico.object.cb_3_02.Background.Color = ll_colper
					dw_grafico.object.cb_3_02.width=li_dias*7
			      dw_grafico.object.line_3_03.x1=li_posini
		         dw_grafico.object.line_3_03.x2=li_posini
		         dw_grafico.object.line_3_03.Pen.Color = ll_color
		         dw_grafico.object.cb_3_03.x=li_posini
			CASE 28
					dw_grafico.object.cb_3_03.Text = ls_mes
					dw_grafico.object.cb_3_03.Background.Color = ll_colper
					dw_grafico.object.cb_3_03.width=li_dias*7
	      		dw_grafico.object.line_3_04.x1=li_posini
         		dw_grafico.object.line_3_04.x2=li_posini
         		dw_grafico.object.line_3_04.Pen.Color = ll_color
         		dw_grafico.object.cb_3_04.x=li_posini
			CASE 29
					dw_grafico.object.cb_3_04.Text = ls_mes
					dw_grafico.object.cb_3_04.Background.Color = ll_colper
					dw_grafico.object.cb_3_04.width=li_dias*7
	      		dw_grafico.object.line_3_05.x1=li_posini
         		dw_grafico.object.line_3_05.x2=li_posini
         		dw_grafico.object.line_3_05.Pen.Color = ll_color
         		dw_grafico.object.cb_3_05.x=li_posini
			CASE 30
					dw_grafico.object.cb_3_05.Text = ls_mes
					dw_grafico.object.cb_3_05.Background.Color = ll_colper
					dw_grafico.object.cb_3_05.width=li_dias*7
			      dw_grafico.object.line_3_06.x1=li_posini
		         dw_grafico.object.line_3_06.x2=li_posini
		         dw_grafico.object.line_3_06.Pen.Color = ll_color
		         dw_grafico.object.cb_3_06.x=li_posini
			CASE 31
					dw_grafico.object.cb_3_06.Text = ls_mes
					dw_grafico.object.cb_3_06.Background.Color = ll_colper
					dw_grafico.object.cb_3_06.width=li_dias*7
			      dw_grafico.object.line_3_07.x1=li_posini
		         dw_grafico.object.line_3_07.x2=li_posini
		         dw_grafico.object.line_3_07.Pen.Color = ll_color
		         dw_grafico.object.cb_3_07.x=li_posini
			CASE 32
					dw_grafico.object.cb_3_07.Text = ls_mes
					dw_grafico.object.cb_3_07.Background.Color = ll_colper
					dw_grafico.object.cb_3_07.width=li_dias*7
			      dw_grafico.object.line_3_08.x1=li_posini
		         dw_grafico.object.line_3_08.x2=li_posini
		         dw_grafico.object.line_3_08.Pen.Color = ll_color
		         dw_grafico.object.cb_3_08.x=li_posini
			CASE 33
					dw_grafico.object.cb_3_08.Text = ls_mes
					dw_grafico.object.cb_3_08.Background.Color = ll_colper
					dw_grafico.object.cb_3_08.width=li_dias*7
			      dw_grafico.object.line_3_09.x1=li_posini
	      	   dw_grafico.object.line_3_09.x2=li_posini
	         	dw_grafico.object.line_3_09.Pen.Color = ll_color
	         	dw_grafico.object.cb_3_09.x=li_posini
			CASE 34
					dw_grafico.object.cb_3_09.Text = ls_mes
					dw_grafico.object.cb_3_09.Background.Color = ll_colper
					dw_grafico.object.cb_3_09.width=li_dias*7
			      dw_grafico.object.line_3_10.x1=li_posini
		         dw_grafico.object.line_3_10.x2=li_posini
		         dw_grafico.object.line_3_10.Pen.Color = ll_color
		         dw_grafico.object.cb_3_10.x=li_posini
			CASE 35
					dw_grafico.object.cb_3_10.Text = ls_mes
					dw_grafico.object.cb_3_10.Background.Color = ll_colper
					dw_grafico.object.cb_3_10.width=li_dias*7
	      		dw_grafico.object.line_3_11.x1=li_posini
         		dw_grafico.object.line_3_11.x2=li_posini
		         dw_grafico.object.line_3_11.Pen.Color = ll_color
		         dw_grafico.object.cb_3_11.x=li_posini
			CASE 36
					dw_grafico.object.cb_3_11.Text  = ls_mes
					dw_grafico.object.cb_3_11.Background.Color = ll_colper
					dw_grafico.object.cb_3_11.width       = li_dias*7
			      dw_grafico.object.line_3_12.x1        = li_posini
		         dw_grafico.object.line_3_12.x2        = li_posini
		         dw_grafico.object.line_3_12.Pen.Color = ll_color
		         dw_grafico.object.cb_3_12.x           = li_posini
			CASE 37
					dw_grafico.object.cb_3_12.Text        = ls_mes
					dw_grafico.object.cb_3_12.Background.Color = ll_colper
					dw_grafico.object.cb_3_12.width       = li_dias*7
	      		dw_grafico.object.line_3_13.x1        = li_posini
      	   	dw_grafico.object.line_3_13.x2        = li_posini
		         dw_grafico.object.line_3_13.Pen.Color = ll_color
	END CHOOSE
	
	ai_mes = ai_mes + 1
	IF ai_mes > 12 THEN
	   ai_mes = 01
		ai_ano = ai_ano + 1
	END IF
END FOR

dw_grafico.visible = True
em_mes_ano.enabled = True
end subroutine

on w_ca304_reprogra_operacion.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.ddlb_1=create ddlb_1
this.st_actualizando=create st_actualizando
this.cb_aceptar_subsecuentes=create cb_aceptar_subsecuentes
this.cb_cancelar=create cb_cancelar
this.cb_aceptar_registro=create cb_aceptar_registro
this.dw_tiempos=create dw_tiempos
this.st_terminado=create st_terminado
this.st_activo=create st_activo
this.st_anulado=create st_anulado
this.em_mes_ano=create em_mes_ano
this.cb_ciclo_corte=create cb_ciclo_corte
this.st_2=create st_2
this.cb_campo=create cb_campo
this.st_1=create st_1
this.st_3=create st_3
this.cb_detalles=create cb_detalles
this.dw_grafico=create dw_grafico
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.st_actualizando
this.Control[iCurrent+3]=this.cb_aceptar_subsecuentes
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_aceptar_registro
this.Control[iCurrent+6]=this.dw_tiempos
this.Control[iCurrent+7]=this.st_terminado
this.Control[iCurrent+8]=this.st_activo
this.Control[iCurrent+9]=this.st_anulado
this.Control[iCurrent+10]=this.em_mes_ano
this.Control[iCurrent+11]=this.cb_ciclo_corte
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.cb_campo
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.cb_detalles
this.Control[iCurrent+17]=this.dw_grafico
end on

on w_ca304_reprogra_operacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.st_actualizando)
destroy(this.cb_aceptar_subsecuentes)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar_registro)
destroy(this.dw_tiempos)
destroy(this.st_terminado)
destroy(this.st_activo)
destroy(this.st_anulado)
destroy(this.em_mes_ano)
destroy(this.cb_ciclo_corte)
destroy(this.st_2)
destroy(this.cb_campo)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.cb_detalles)
destroy(this.dw_grafico)
end on

event ue_open_pre();call super::ue_open_pre;dw_grafico.SetTransObject(SQLCA)
dw_tiempos.SetTransObject(SQLCA)

st_actualizando.Visible = False
ddlb_1.Text='Mensual'
cb_campo.PostEvent(Clicked!)

//of_position_window(50,10)
THIS.x = 70
THIS.y = 20
ii_help = 304             				// help topic
end event

type ddlb_1 from dropdownlistbox within w_ca304_reprogra_operacion
integer x = 1216
integer y = 1196
integer width = 366
integer height = 344
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean vscrollbar = true
string item[] = {"Mensual","Semanal","Diario"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;Choose case This.Text
	Case 'Mensual'
		dw_grafico.DataObject='d_reprogra_ope_men_tbl'
	Case 'Semanal'
		dw_grafico.DataObject='d_reprogra_ope_sem_tbl'
	Case 'Diario'
		dw_grafico.DataObject='d_reprogra_ope_dia_tbl'
End Choose
dw_grafico.SetTransObject(SQLCA)
dw_grafico.Retrieve(is_corr_corte)
Choose case This.Text
	Case 'Mensual'
		of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
	Case 'Semanal'
		of_lineas_s( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
	Case 'Diario'
		of_lineas_d( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
End Choose



end event

type st_actualizando from statictext within w_ca304_reprogra_operacion
integer x = 9
integer y = 1224
integer width = 613
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Black"
boolean italic = true
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
string text = "actualizando ..."
boolean focusrectangle = false
end type

type cb_aceptar_subsecuentes from commandbutton within w_ca304_reprogra_operacion
integer x = 2514
integer y = 1376
integer width = 937
integer height = 64
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Actualizar también subsecuentes"
end type

event clicked;IF dw_tiempos.Update() = -1 then		// Grabacion del Master
	ROLLBACK using SQLCA;
	messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
ELSE
	// Edg Mar08
	// Si existe correl en el parte diario => no puede modificar fec_ini_estimado
	long ll_corr_corte_en_pd
	ll_corr_corte_en_pd = 0
	select count(*)
	  into :ll_corr_corte_en_pd
     from pd_labores pdl
    where pdl.oper_sec in 
          ( select o.oper_sec
              from operaciones o 
	          where o.corr_corte = :is_corr_corte ) ;
	
	st_actualizando.Visible = True
	st_actualizando.Width = 2277
	Long ll_row_tiempos, ll_row_grafico
	Integer li_nro_operacion

	ll_row_grafico = dw_grafico.GetRow()
	ll_row_tiempos = dw_tiempos.GetRow()
	li_nro_operacion = dw_grafico.GetItemNumber(dw_grafico.GetRow(), "nro_operacion")
	is_operaciones = ''
	of_subsecuentes ( is_corr_corte, &
							li_nro_operacion, &
							dw_tiempos.Object.operaciones_fec_inicio[ll_row_tiempos], 1, &
							dw_tiempos.Object.operaciones_dias_duracion_proy[ll_row_tiempos] , &
							ll_corr_corte_en_pd )	

   COMMIT using SQLCA;
	// simulando el boton de comandos de correlativo de corte //
	dw_grafico.Retrieve(is_corr_corte)
	//em_mes_ano.Text=string(year(today())) + "-01-01"
	Choose case ddlb_1.Text
		Case 'Mensual'
			of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
		Case 'Semanal'
			of_lineas_s( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
		Case 'Diario'
			of_lineas_d( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
	End Choose
	dw_grafico.visible = True
	dw_tiempos.visible = False
	// simulando click en el w_grafico //
	dw_grafico.ScrollToRow(ll_row_grafico)
	dw_grafico.SelectRow(0, False)
	dw_grafico.SelectRow(ll_row_grafico, True)
	li_nro_operacion = dw_grafico.GetItemNumber(ll_row_grafico, "nro_operacion")
	dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
 	dw_tiempos.visible = True
//	cb_detalles.Enabled = True

	st_actualizando.Visible = False
END IF
of_botones('cb_aceptar_registro')

end event

type cb_cancelar from commandbutton within w_ca304_reprogra_operacion
integer x = 2514
integer y = 1484
integer width = 398
integer height = 64
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Cancelar"
end type

event clicked;Integer li_nro_operacion
long ll_grafico_row

ll_grafico_row = dw_grafico.GetRow()
If ll_grafico_Row=0 Then Return

li_nro_operacion = dw_grafico.GetItemNumber(ll_grafico_row, "nro_operacion")
dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
of_botones('cb_cancelar')

end event

type cb_aceptar_registro from commandbutton within w_ca304_reprogra_operacion
integer x = 2519
integer y = 1280
integer width = 937
integer height = 64
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Actualizar sólo este registro"
end type

event clicked;IF dw_tiempos.Update() = -1 then		// Grabacion del Master
	ROLLBACK using SQLCA;
	messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
ELSE
	COMMIT using SQLCA;
	of_de_detalle_a_grafico()
END IF
of_botones('cb_aceptar_registro')

end event

type dw_tiempos from datawindow within w_ca304_reprogra_operacion
integer x = 5
integer y = 1288
integer width = 2491
integer height = 260
integer taborder = 50
string dataobject = "d_reprogra_ope_tiempos_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event editchanged;of_botones('dw_tiempos.editchanged')
// asegurando el cambio en articulos_mov_proy

Dec ldc_oper_sec
DateTime ldt_Fec_inicio
If dwo.name = 'operaciones_fec_inicio' Then
   ldt_Fec_Inicio = DateTime( Date( data ), Time( data ) )
   ldc_oper_sec   = dw_tiempos.getitemNumber(1, "Operaciones_Oper_Sec")
   // actualiza movimiento proyectado
   update articulo_mov_proy 
      set fec_proyect = :ldt_Fec_Inicio
    where oper_sec = :ldc_oper_sec ;
Else
	If dwo.name = 'operaciones_dias_para_inicio' Then
		Dec ldc_nro_oper_preced, ldc_dias_duracion_proy
		Long ll_fila, ll_reg
		Integer li_dias_para_inicio
		String ls_flag_pre, ls_corr_corte
		
		// Datos del registro actual
		ll_fila = This.GetRow()
	   li_dias_para_inicio = integer ( data ) // This.getitemNumber(ll_fila,"operaciones_dias_para_inicio")
      ldc_oper_sec        = This.getitemNumber(ll_fila,"operaciones_oper_sec")
		ls_flag_pre         = This.getitemString(ll_fila,"operaciones_flag_pre")
		ls_corr_corte       = This.getitemString(ll_fila,"operaciones_corr_corte")
		// Datos del registro anterior
      DateTime ldt_Fec_inicio_prec
		ldc_nro_oper_preced =  This.GetItemNumber(ll_fila, "operaciones_nro_oper_preced" )
		If Not ( isnull( ldc_nro_oper_preced ) or ldc_nro_oper_preced = 0 ) Then 
			Select count(*) into :ll_reg from operaciones 
  	       where corr_corte = :ls_corr_corte AND  nro_operacion = :ldc_nro_oper_preced ;
			If ll_reg > 0 Then
				Select fec_inicio, dias_duracion_proy 
				  into :ldt_Fec_inicio_prec, :ldc_dias_duracion_proy 
				  from operaciones 
              where corr_corte = :ls_corr_corte AND  nro_operacion = :ldc_nro_oper_preced ;
            if ls_flag_pre = 'I' Then // Tomar de la Precedencia la fecha Inicial/Final
               ldt_Fec_Inicio = of_Relative_Date_Times( ldt_fec_inicio_prec, li_dias_para_inicio)
            else
					If isnull( ldc_dias_duracion_proy ) Then
						ldc_dias_duracion_proy = 0
					End If
               ldt_Fec_Inicio = of_Relative_Date_Times( ldt_fec_inicio_prec, &
                                li_dias_para_inicio + ldc_dias_duracion_proy )
            end if //ls_flag_pre 
				this.SetItem( ll_fila, 'operaciones_fec_inicio', ldt_fec_inicio ) 
         end if //ll_reg>0 
	   End If //Not(isnull(ldc_nro_oper_preced) or ldc_nro_oper_preced=0)
   End If //dwo.name='operaciones_fec_inicio'
End If //dwo.name='operaciones_fec_inicio'
  
end event

event itemchanged;of_botones('dw_tiempos.editchanged')
// asegurando el cambio en articulos_mov_proy

If dwo.name = 'operaciones_fec_inicio' Then
   Dec ldc_oper_sec
   DateTime ldt_Fec_inicio
   ldt_Fec_Inicio = DateTime( Date( data ), Time( data ) )
   ldc_oper_sec   = dw_tiempos.getitemNumber(1, "Operaciones_Oper_Sec")
   // actualiza movimiento proyectado
   update articulo_mov_proy 
      set fec_proyect = :ldt_Fec_Inicio
    where oper_sec = :ldc_oper_sec ;
End If	 

end event

type st_terminado from statictext within w_ca304_reprogra_operacion
integer x = 594
integer y = 1164
integer width = 283
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Terminado"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_activo from statictext within w_ca304_reprogra_operacion
integer x = 293
integer y = 1164
integer width = 247
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Activo"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_anulado from statictext within w_ca304_reprogra_operacion
integer x = 9
integer y = 1164
integer width = 247
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Anulado"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type em_mes_ano from editmask within w_ca304_reprogra_operacion
event ue_bnclicked ( )
integer x = 3077
integer y = 1188
integer width = 302
integer height = 76
integer taborder = 20
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "01/2000"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/yyyy"
boolean autoskip = true
boolean spin = true
end type

event ue_bnclicked;messagebox(",", "3")
of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
end event

event modified;Choose case ddlb_1.Text
	Case 'Mensual'
		of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
	Case 'Semanal'
		of_lineas_s( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
	Case 'Diario'
		of_lineas_d( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
End Choose

//of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
end event

type cb_ciclo_corte from commandbutton within w_ca304_reprogra_operacion
integer x = 1879
integer y = 12
integer width = 1499
integer height = 72
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "<<< Seleccione el Ciclo/Corte para dicho Campo >>>"
end type

event clicked;String ls_cod_campo, ls_ciclo_corte

ls_cod_campo = Mid(cb_campo.Text,1,7)
OpenWithParm(w_reprogra_ope_ciclo_res, ls_cod_campo)
ls_ciclo_corte = Message.StringParm
IF ls_ciclo_corte = "" THEN
	return
END IF
this.Text = ls_ciclo_corte 
ls_ciclo_corte = Mid(ls_ciclo_corte,8,2) + Mid(ls_ciclo_corte,10,2)
is_corr_corte = ls_cod_campo + ls_ciclo_corte
dw_grafico.Retrieve(is_corr_corte)

em_mes_ano.Text=string(year(today())) + "-01-01"

//this.trigger event ue_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
dw_grafico.visible = True
//of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
st_Anulado.BackColor 	= rgb(192,192,192)
st_Activo.BackColor 		= rgb( 54,159,159)
st_Terminado.BackColor 	= rgb(165,  5,  5)
ddlb_1.Enabled = True
em_mes_ano.Enabled = True

//ddlb_1.post event selectionchanged(1)
ddlb_1.event selectionchanged(1)
end event

type st_2 from statictext within w_ca304_reprogra_operacion
integer x = 1550
integer y = 12
integer width = 325
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Ciclo/Corte:"
boolean focusrectangle = false
end type

type cb_campo from commandbutton within w_ca304_reprogra_operacion
integer x = 219
integer y = 12
integer width = 1285
integer height = 72
integer taborder = 100
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<< Seleccione el Campo >>>"
end type

event clicked;String ls_cod_campo, ls_desc_campo

Open(w_reprogra_ope_campo_res)
ls_cod_campo = Message.StringParm
IF ls_cod_campo = "" THEN
	return
END IF
Select c.desc_campo into :ls_desc_campo from campo c where c.cod_campo=:ls_cod_campo;
this.Text = ls_cod_campo + ' ' + ls_desc_campo
cb_ciclo_corte.Enabled = True
//Post Event cb_ciclo_corte.Clicked
dw_grafico.visible = False
dw_tiempos.visible = False
ddlb_1.Enabled = False
em_mes_ano.Enabled = False
cb_ciclo_corte.PostEvent(Clicked!)


end event

type st_1 from statictext within w_ca304_reprogra_operacion
integer x = 14
integer y = 12
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Campo:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_ca304_reprogra_operacion
integer x = 2386
integer y = 1192
integer width = 695
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Regla a partir de (mm/yyyy):"
boolean focusrectangle = false
end type

type cb_detalles from commandbutton within w_ca304_reprogra_operacion
integer x = 3035
integer y = 1492
integer width = 398
integer height = 64
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Detalles >>>"
end type

event clicked;Long ll_row_grafico
Integer li_nro_operacion
String ls_parametro
ll_row_grafico=dw_grafico.GetRow()
If ll_row_grafico=0 Then Return
li_nro_operacion = dw_grafico.GetItemNumber(ll_row_grafico, "nro_operacion")
ls_parametro = is_corr_corte + String( li_nro_operacion, "####") 

OpenWithParm(w_reprogra_ope_detalle_pop, ls_parametro)
ls_parametro = Message.StringParm
//if ls_parametro = 'cancelar' Then Return // sino retrieve!!!
//dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
Choose case ls_parametro 
	case 'cancelar' 
		Return // sino retrieve!!!
	//case 'solo_registro'
	//	dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
	//	of_de_detalle_a_grafico()
	case 'solo_registro', 'subsecuentes' // copiado literalmente del cb_aceptar_subsecuentes
		st_actualizando.Visible = True
		st_actualizando.Width = 2277
		Long ll_row_tiempos//, ll_row_grafico
		//Integer li_nro_operacion
   	long ll_corr_corte_en_pd
	   ll_corr_corte_en_pd = 0
   	select count(*)
	     into :ll_corr_corte_en_pd
        from pd_labores pdl
       where pdl.oper_sec in 
             ( select o.oper_sec
                 from operaciones o 
	             where o.corr_corte = :is_corr_corte ) ;

		dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
		ll_row_grafico = dw_grafico.GetRow()
		ll_row_tiempos = dw_tiempos.GetRow()
		li_nro_operacion = dw_grafico.GetItemNumber(dw_grafico.GetRow(), "nro_operacion")
		is_operaciones = ''
		If ls_parametro='subsecuentes' Then

       	of_subsecuentes ( is_corr_corte, &
							li_nro_operacion, &
							dw_tiempos.Object.operaciones_fec_inicio[ll_row_tiempos], 1, &
							dw_tiempos.Object.operaciones_dias_duracion_proy[ll_row_tiempos] , &
							ll_corr_corte_en_pd )	


      End If
		COMMIT using SQLCA;
		// simulando el boton de comandos de correlativo de corte //
		dw_grafico.Retrieve(is_corr_corte)
		//em_mes_ano.Text=string(year(today())) + "-01-01"
		Choose case ddlb_1.Text
			Case 'Mensual'
				of_lineas( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
			Case 'Semanal'
				of_lineas_s( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
			Case 'Diario'
				of_lineas_d( integer(mid(em_mes_ano.Text, 1, 2)), integer(mid(em_mes_ano.Text,4,4)) )
		End Choose
		dw_grafico.visible = True
		dw_tiempos.visible = False
		// simulando click en el w_grafico //
		dw_grafico.ScrollToRow(ll_row_grafico)
		dw_grafico.SelectRow(0, False)
		dw_grafico.SelectRow(ll_row_grafico, True)
		li_nro_operacion = dw_grafico.GetItemNumber(ll_row_grafico, "nro_operacion")
		dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
	 	dw_tiempos.visible = True
		//	cb_detalles.Enabled = True
		st_actualizando.Visible = False
		of_botones('cb_aceptar_registro')
end choose


end event

type dw_grafico from datawindow within w_ca304_reprogra_operacion
integer x = 9
integer y = 112
integer width = 3442
integer height = 1048
integer taborder = 90
string dataobject = "d_reprogra_ope_men_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Integer li_nro_operacion

If Row=0 Then Return

This.SelectRow(0, False)
This.SelectRow(row, True)

li_nro_operacion = this.GetItemNumber(row, "nro_operacion")
//messagebox ( is_corr_corte, li_nro_operacion )
dw_tiempos.Retrieve(is_corr_corte, li_nro_operacion)
dw_tiempos.visible = True
cb_detalles.Enabled = True

//dw_grafico.SetSort("fec_inicio")
//dw_grafico.Sort()
end event

