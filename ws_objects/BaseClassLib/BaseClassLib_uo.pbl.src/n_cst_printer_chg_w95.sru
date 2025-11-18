$PBExportHeader$n_cst_printer_chg_w95.sru
$PBExportComments$Funciones para cambiar el Default printer en w95, w98
forward
global type n_cst_printer_chg_w95 from nonvisualobject
end type
end forward

global type n_cst_printer_chg_w95 from nonvisualobject
end type
global n_cst_printer_chg_w95 n_cst_printer_chg_w95

forward prototypes
public function string of_get_printer ()
public function string of_get_driver (string as_printer)
public function string of_get_port (string as_printer)
public function integer of_set_printer (string as_printer)
public function integer of_set_ini (string as_printer, string as_driver, string as_port)
public function integer of_get_drvprt_ini (string as_printer, ref string as_driver, ref string as_port)
end prototypes

public function string of_get_printer ();String ls_key, ls_printer

ls_key = "HKEY_LOCAL_MACHINE\Config\0001\System\CurrentControlSet\Control\Print\Printers"

RegistryGet(ls_key, "default", ls_printer)
				
RETURN ls_printer

end function

public function string of_get_driver (string as_printer);String ls_key, ls_driver

ls_key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print\Printers\" + as_printer

RegistryGet(ls_key, "Printer Driver", ls_driver)
				
RETURN ls_driver

end function

public function string of_get_port (string as_printer);String ls_key, ls_port

ls_key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print\Printers\" + as_printer

RegistryGet(ls_key, "Port", ls_port)
				
RETURN ls_port

end function

public function integer of_set_printer (string as_printer);Integer li_rc

li_rc = RegistrySet("HKEY_LOCAL_MACHINE\Config\0001\System\CurrentControlSet\Control\Print\Printers",&
            "default", as_printer)

RETURN li_rc   //  1 = ok
end function

public function integer of_set_ini (string as_printer, string as_driver, string as_port);String ls_text
Integer	li_rc

ls_text = as_printer + ',' + as_driver + ',' + as_port

li_rc = SetProfileString("c:\windows\win.ini", "Windows", "device", ls_text)

RETURN li_rc   // 1 = ok

end function

public function integer of_get_drvprt_ini (string as_printer, ref string as_driver, ref string as_port);String ls_Temp, ls_PrinterName
Integer	li_pos, li_rc = -1

ls_Temp = ProfileString( "win.ini", "Devices", as_printer,"none" )

IF ls_temp = 'none' THEN GOTO SALIDA

li_pos = Pos(ls_temp, ',')

IF li_pos < 1 THEN GOTO SALIDA

as_driver = Left(ls_temp, li_pos -1)
as_port   = Mid(ls_temp, li_pos +1)
li_rc = 1


SALIDA:

RETURN li_rc		// -1= error, 1 = ok
end function

on n_cst_printer_chg_w95.create
TriggerEvent( this, "constructor" )
end on

on n_cst_printer_chg_w95.destroy
TriggerEvent( this, "destructor" )
end on

