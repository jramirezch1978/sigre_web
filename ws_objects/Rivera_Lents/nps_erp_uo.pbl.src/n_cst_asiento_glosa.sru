$PBExportHeader$n_cst_asiento_glosa.sru
forward
global type n_cst_asiento_glosa from nonvisualobject
end type
end forward

global type n_cst_asiento_glosa from nonvisualobject
end type
global n_cst_asiento_glosa n_cst_asiento_glosa

forward prototypes
public function string of_get_value (datawindow adw_data, long al_row, string as_campo)
public function string of_set_glosa (datastore ads_data, long al_row, string as_glosa_texto, string as_glosa_campo)
public function string of_get_value (datastore ads_data, long al_row, string as_campo)
public function string of_set_glosa (datawindow adw_data, long al_row, string as_glosa_texto, string as_glosa_campo)
end prototypes

public function string of_get_value (datawindow adw_data, long al_row, string as_campo);String	ls_type, ls_temp
	
ls_type = adw_data.Describe(as_campo + ".ColType")

IF ls_type = '!' THEN
	SetNull(ls_temp)
	GOTO SALIDA
END IF


CHOOSE CASE ls_type
	CASE 'date'
			ls_temp = ls_temp + String(adw_data.GetItemDate(al_row, as_campo), 'dd/mm/yyyy')
	CASE 'datetime'
			ls_temp = ls_temp + String(adw_data.GetItemDateTime(al_row, as_campo), 'dd/mm/yyyy hh:mm:ss')
	CASE Else
			IF Left(ls_type,4) = 'char' THEN
				ls_temp = ls_temp + adw_data.GetItemString(al_row, as_campo)
			ELSE
				ls_temp = ls_temp + String(adw_data.GetItemNumber(al_row, as_campo))
			END IF
END CHOOSE


SALIDA:
RETURN ls_temp
end function

public function string of_set_glosa (datastore ads_data, long al_row, string as_glosa_texto, string as_glosa_campo);String ls_glosa, ls_texto,ls_campo, ls_temp
Integer li_pos_ini ,li_pos_fin , li_pos ,li_cont ,li_x
String  ls_armado []

IF IsNull(as_glosa_texto) AND IsNull(as_glosa_campo) THEN GOTO SALIDA

IF IsNull(as_glosa_campo) THEN
	ls_glosa = as_glosa_texto
	GOTO SALIDA
END IF

ls_texto = as_glosa_campo


li_pos_ini = 0
li_pos_fin = 0
li_cont	  = 0
li_pos	  = 1

li_pos_ini     = Pos(ls_texto,'[',li_pos) 

DO WHILE li_pos_ini > 0
	li_cont ++
	li_pos_fin = Pos(ls_texto,']',li_pos_ini) 
	ls_armado [li_cont] = Mid(ls_texto,li_pos_ini + 1,li_pos_fin - (li_pos_ini + 1))
	//Inicializa Valor
	li_pos_ini = Pos(ls_texto,'[',li_pos_fin) 
LOOP

FOR li_x = 1 TO UpperBound(ls_armado)
	 ls_campo = ls_armado [li_x]
	 ls_temp  = of_get_value(ads_data, al_row, ls_campo)
	
	IF IsNull(ls_temp) THEN
		ls_temp = 'Error: ' + ls_campo
	END IF

	IF IsNull(ls_glosa) OR Trim(ls_glosa) = '' THEN
		ls_glosa = ls_temp
	ELSE
		ls_glosa = ls_glosa + ' , ' + ls_temp
	END IF
NEXT

SALIDA:

RETURN ls_glosa
end function

public function string of_get_value (datastore ads_data, long al_row, string as_campo);String	ls_type, ls_temp
	
ls_type = ads_data.Describe(as_campo + ".ColType")

IF ls_type = '!' THEN
	SetNull(ls_temp)
	GOTO SALIDA
END IF


CHOOSE CASE ls_type
	CASE 'date'
			ls_temp = ls_temp + String(ads_data.GetItemDate(al_row, as_campo), 'dd/mm/yyyy')
	CASE 'datetime'
			ls_temp = ls_temp + String(ads_data.GetItemDateTime(al_row, as_campo), 'dd/mm/yyyy hh:mm:ss')
	CASE Else
			IF Left(ls_type,4) = 'char' THEN
				ls_temp = ls_temp + ads_data.GetItemString(al_row, as_campo)
			ELSE
				ls_temp = ls_temp + String(ads_data.GetItemNumber(al_row, as_campo))
			END IF
END CHOOSE


SALIDA:
RETURN ls_temp
end function

public function string of_set_glosa (datawindow adw_data, long al_row, string as_glosa_texto, string as_glosa_campo);String ls_glosa, ls_texto,ls_campo, ls_temp
Integer li_pos_ini ,li_pos_fin , li_pos ,li_cont ,li_x
String  ls_armado []

IF IsNull(as_glosa_texto) AND IsNull(as_glosa_campo) THEN GOTO SALIDA

IF IsNull(as_glosa_campo) THEN
	ls_glosa = as_glosa_texto
	GOTO SALIDA
END IF

ls_texto = as_glosa_campo


li_pos_ini = 0
li_pos_fin = 0
li_cont	  = 0
li_pos	  = 1

li_pos_ini     = Pos(ls_texto,'[',li_pos) 

DO WHILE li_pos_ini > 0
	li_cont ++
	li_pos_fin = Pos(ls_texto,']',li_pos_ini) 
	ls_armado [li_cont] = Mid(ls_texto,li_pos_ini + 1,li_pos_fin - (li_pos_ini + 1))
	//Inicializa Valor
	li_pos_ini = Pos(ls_texto,'[',li_pos_fin) 
LOOP

FOR li_x = 1 TO UpperBound(ls_armado)
	 ls_campo = ls_armado [li_x]
	 ls_temp  = of_get_value(adw_data, al_row, ls_campo)
	
	IF IsNull(ls_temp) THEN
		ls_temp = 'Error: ' + ls_campo
	END IF

	IF IsNull(ls_glosa) OR Trim(ls_glosa) = '' THEN
		ls_glosa = ls_temp
	ELSE
		ls_glosa = ls_glosa + ' , ' + ls_temp
	END IF
NEXT

SALIDA:

RETURN ls_glosa
end function

on n_cst_asiento_glosa.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_asiento_glosa.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

