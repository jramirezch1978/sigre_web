$PBExportHeader$n_find_column.sru
forward
global type n_find_column from nonvisualobject
end type
end forward

global type n_find_column from nonvisualobject
end type
global n_find_column n_find_column

forward prototypes
public subroutine find_valor (datawindow adw_1, long al_row, string as_columna, ref decimal adc_monto_x_doc) throws n_found_column
end prototypes

public subroutine find_valor (datawindow adw_1, long al_row, string as_columna, ref decimal adc_monto_x_doc) throws n_found_column;n_found_column  n_found

adc_monto_x_doc = adw_1.Getitemnumber(al_row,as_columna)
MESSAGEBOX("adc_monto_x_doc",adc_monto_x_doc)
if adc_monto_x_doc = -1 THEN
	n_found = CREATE n_found_column
	n_found.setMessage &
	("no encontro columna")
	throw n_found
	
	
end if


end subroutine

on n_find_column.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_find_column.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

