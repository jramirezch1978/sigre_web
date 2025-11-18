$PBExportHeader$n_cst_time.sru
forward
global type n_cst_time from nonvisualobject
end type
end forward

global type n_cst_time from nonvisualobject autoinstantiate
end type

type variables
DateTime		idt_start_total_time, idt_end_total_time
DateTime		idt_start_event_time, idt_end_event_time
Long			il_total_records, il_index
decimal		idc_array_event_times[], ai_null[]
end variables

forward prototypes
public function dateTime onstarttotaltime ()
public function datetime onendtotaltime ()
public function datetime onstarteventtime ()
public function datetime onendeventtime ()
public function decimal gettotaltime ()
public function decimal gettotaleventtime ()
public subroutine settotalrecords (long al_total_records)
public function decimal getaveragetime ()
public function decimal getremainingtime ()
public subroutine reset ()
end prototypes

public function dateTime onstarttotaltime ();idt_start_total_time = gnvo_app.of_fecha_Actual()

return idt_start_total_time
end function

public function datetime onendtotaltime ();idt_end_total_time = gnvo_app.of_fecha_Actual()

return idt_end_total_time
end function

public function datetime onstarteventtime ();idt_start_event_time = gnvo_app.of_fecha_Actual()

return idt_start_event_time
end function

public function datetime onendeventtime ();decimal ldc_event_time

idt_end_event_time = gnvo_app.of_fecha_Actual()

//Obtengo el tiempo transcurrido en segundos
select (:idt_end_event_time - :idt_start_event_time) * 24 * 3600
	into :ldc_event_time
from dual;

if SQLCA.SQLCode < 0 then
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al hacer el calculo del tiempo getTotalEventTime(). ' &
							 + 'Mensaje: ' + SQLCA.SQLErrText, StopSign!)
	return idt_end_event_time
end if

//lo almaceno en el arreglo
il_index ++

idc_array_event_times[il_index] = ldc_event_time


return idt_end_event_time
end function

public function decimal gettotaltime ();DEcimal 	ldc_total_time

select (:idt_end_total_time - :idt_start_total_time) * 24 * 3600
	into :ldc_total_time
from dual;

if SQLCA.SQLCode < 0 then
	ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al hacer el calculo del tiempo getTotalTime(). ' &
							 + 'Mensaje: ' + SQLCA.SQLErrText, StopSign!)
							 

	return -1.00
end if

return ldc_total_time
end function

public function decimal gettotaleventtime ();DEcimal 	ldc_total_event_time

select (:idt_end_event_time - :idt_start_event_time) * 24 * 3600
	into :ldc_total_event_time
from dual;

if SQLCA.SQLCode < 0 then
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al hacer el calculo del tiempo getTotalEventTime(). ' &
							 + 'Mensaje: ' + SQLCA.SQLErrText, StopSign!)
	return -1.00
end if

return ldc_total_event_time
end function

public subroutine settotalrecords (long al_total_records);il_total_records = al_total_records
end subroutine

public function decimal getaveragetime ();decimal 	ldc_Average_Time
Long 		ll_row

ldc_Average_Time = 0

for ll_row = 1 to il_index
	ldc_Average_Time += idc_array_event_times [ll_row]
next


return ldc_Average_Time / Dec(il_total_records)
end function

public function decimal getremainingtime ();decimal 	ldc_Average_Time, ldc_remaing_time

ldc_Average_Time = this.getAverageTime()

ldc_remaing_time = (il_total_records - il_index) * ldc_Average_time


return ldc_remaing_time
end function

public subroutine reset ();idc_array_event_times = ai_null
il_index = 0
end subroutine

on n_cst_time.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_time.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;il_index = 0
end event

