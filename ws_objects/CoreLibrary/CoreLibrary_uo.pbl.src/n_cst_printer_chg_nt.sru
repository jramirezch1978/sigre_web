$PBExportHeader$n_cst_printer_chg_nt.sru
$PBExportComments$Funciones para cambiar el Default printer en NT
forward
global type n_cst_printer_chg_nt from nonvisualobject
end type
end forward

global type n_cst_printer_chg_nt from nonvisualobject
end type
global n_cst_printer_chg_nt n_cst_printer_chg_nt

forward prototypes
public function string of_get_printer ()
public function integer of_set_printer (string as_printer)
end prototypes

public function string of_get_printer ();String ls_key, ls_printer

ls_key = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows"

RegistryGet(ls_key, "Device", ls_printer)
				
RETURN ls_printer

end function

public function integer of_set_printer (string as_printer);Integer 	li_rc
String ls_key, ls_printer

ls_key = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows"

li_rc = RegistrySet(ls_key, "Device", ls_printer)
				
RETURN li_rc   //  1 = ok
end function

on n_cst_printer_chg_nt.create
TriggerEvent( this, "constructor" )
end on

on n_cst_printer_chg_nt.destroy
TriggerEvent( this, "destructor" )
end on

