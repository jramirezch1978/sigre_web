$PBExportHeader$n_cst_printer.sru
$PBExportComments$Clase para gestionar la impresora por defecto del usuario
forward
global type n_cst_printer from nonvisualobject
end type
end forward

global type n_cst_printer from nonvisualobject
end type
global n_cst_printer n_cst_printer

type variables
//Nombre del parametro base para la impresora por usuario
Constant String	PARAM_PRINTER_DEFAULT = "PRINTER_DEFAULT_"
end variables

forward prototypes
public function string of_get_printer_default ()
public function string of_get_printer_default (string as_param_name)
public function string of_get_printers ()
public function string of_get_printers (string as_default_printer)
public function boolean of_set_printer_default (string as_printer)
public function boolean of_set_printer_default (string as_param_name, string as_printer)
end prototypes

public function string of_get_printer_default ();/********************************************************************
   FunciÃ³n: of_get_printer_default
   PropÃ³sito: Obtiene la impresora por defecto del usuario actual
   
   Retorno: 
      - String con el nombre de la impresora seleccionada
      - VacÃ­o si el usuario cancela la selecciÃ³n
      
   Notas:
      - Busca el parÃ¡metro PRINTER_DEFAULT_<username> en configuraciÃ³n
      - Si no existe, muestra lista de impresoras disponibles
      - Guarda la impresora seleccionada para futuras consultas
********************************************************************/
String ls_param_name

//Construir el nombre del parametro: PRINTER_DEFAULT_<USERNAME>
ls_param_name = PARAM_PRINTER_DEFAULT + UPPER(trim(gs_user))

Return this.of_get_printer_default(ls_param_name)

end function

public function string of_get_printer_default (string as_param_name);/********************************************************************
   FunciÃ³n: of_get_printer_default (con nombre de parÃ¡metro personalizado)
   PropÃ³sito: Obtiene la impresora por defecto usando un nombre de parÃ¡metro especÃ­fico
   
   ParÃ¡metros:
      - as_param_name: Nombre del parÃ¡metro a usar (ej: "NAME_PRINTER_TICKET_JPEREZ")
   
   Retorno: 
      - String con el nombre de la impresora seleccionada
      - VacÃ­o si el usuario cancela la selecciÃ³n
********************************************************************/
String 	ls_printer, ls_selected_printer
String 	ls_impresoras[]
Integer li_rtn, li_i, li_nbImpresoras, li_selected
Boolean lb_exists

try 
	//Obtener la impresora guardada en configuraciÃ³n
	ls_printer = gnvo_app.of_get_parametro(as_param_name, "")
	
	//Si ya existe una impresora configurada, verificar que aÃºn exista en el sistema
	if len(trim(ls_printer)) > 0 then
		//Verificar que la impresora siga instalada en el sistema
		li_rtn = RegistryKeys("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Print\Printers", ls_impresoras) 
		
		lb_exists = false
		li_nbImpresoras = UpperBound(ls_impresoras)
		
		for li_i = 1 to li_nbImpresoras
			if upper(trim(ls_impresoras[li_i])) = upper(trim(ls_printer)) then
				lb_exists = true
				exit
			end if
		next
		
		//Si la impresora ya no existe, forzar selecciÃ³n
		if not lb_exists then
			MessageBox("Aviso", "La impresora '" + ls_printer + "' ya no estÃ¡ disponible en el sistema.~r~n" &
						+ "Por favor seleccione una nueva impresora.", Information!)
			ls_printer = ""
		end if
	end if
	
	//Si no hay impresora configurada o no existe, mostrar listado para seleccionar
	if len(trim(ls_printer)) = 0 then
		ls_selected_printer = this.of_get_printers()
		
		//Si el usuario seleccionÃ³ una impresora
		if len(trim(ls_selected_printer)) > 0 then
			//Guardar la impresora seleccionada
			if this.of_set_printer_default(as_param_name, ls_selected_printer) then
				MessageBox("ConfiguraciÃ³n Guardada", &
							"Se ha configurado la impresora: " + ls_selected_printer + "~r~n~r~n" &
							+ "Esta impresora se usarÃ¡ por defecto para el usuario actual.~r~n" &
							+ "Puede cambiarla desde la configuraciÃ³n del sistema.", Information!)
				ls_printer = ls_selected_printer
			else
				MessageBox("Error", "No se pudo guardar la configuraciÃ³n de la impresora.~r~n" &
							+ "Por favor intente nuevamente.", StopSign!)
			end if
		end if
	end if
	
	return ls_printer
	
catch (Exception ex)
	MessageBox("Error", "Ha ocurrido una excepciÃ³n en of_get_printer_default: " &
					+ "~r~n" + ex.getMessage(), StopSign!)
	return ""
end try

end function

public function string of_get_printers ();/********************************************************************
   FunciÃ³n: of_get_printers
   PropÃ³sito: Muestra un listado de impresoras disponibles para seleccionar
   
   Retorno: 
      - String con el nombre de la impresora seleccionada
      - VacÃ­o si el usuario cancela
********************************************************************/
Return this.of_get_printers("")

end function

public function string of_get_printers (string as_default_printer);/********************************************************************
   FunciÃ³n: of_get_printers (con impresora por defecto)
   PropÃ³sito: Muestra un listado de impresoras disponibles para seleccionar
   
   ParÃ¡metros:
      - as_default_printer: Impresora a pre-seleccionar (opcional)
   
   Retorno: 
      - String con el nombre de la impresora seleccionada
      - VacÃ­o si el usuario cancela
********************************************************************/
str_parametros lstr_param, lstr_return

try
	//Preparar parÃ¡metros para la ventana de selecciÃ³n
	lstr_param.s_PrintName = as_default_printer
	lstr_param.titulo = "Seleccionar Impresora"
	
	//Abrir ventana de selecciÃ³n de impresoras
	OpenWithParm(w_select_printer, lstr_param)
	lstr_return = Message.PowerObjectParm
	
	//Verificar si el usuario aceptÃ³ la selecciÃ³n
	if lstr_return.b_return then
		return trim(lstr_return.s_PrintName)
	else
		return ""
	end if
	
catch (Exception ex)
	MessageBox("Error", "Ha ocurrido una excepciÃ³n al obtener las impresoras: " &
					+ "~r~n" + ex.getMessage(), StopSign!)
	return ""
end try

end function

public function boolean of_set_printer_default (string as_printer);/********************************************************************
   FunciÃ³n: of_set_printer_default
   PropÃ³sito: Guarda la impresora por defecto para el usuario actual
   
   ParÃ¡metros:
      - as_printer: Nombre de la impresora a guardar
   
   Retorno: 
      - True si se guardÃ³ correctamente
      - False si hubo error
********************************************************************/
String ls_param_name

//Construir el nombre del parametro: PRINTER_DEFAULT_<USERNAME>
ls_param_name = PARAM_PRINTER_DEFAULT + UPPER(trim(gs_user))

Return this.of_set_printer_default(ls_param_name, as_printer)

end function

public function boolean of_set_printer_default (string as_param_name, string as_printer);/********************************************************************
   FunciÃ³n: of_set_printer_default (con nombre de parÃ¡metro personalizado)
   PropÃ³sito: Guarda la impresora por defecto con un nombre de parÃ¡metro especÃ­fico
   
   ParÃ¡metros:
      - as_param_name: Nombre del parÃ¡metro (ej: "PRINTER_DEFAULT_JPEREZ")
      - as_printer: Nombre de la impresora a guardar
   
   Retorno: 
      - True si se guardÃ³ correctamente
      - False si hubo error
********************************************************************/
try
	gnvo_app.of_set_parametro(as_param_name, as_printer)
	COMMIT;
	return true
	
catch (Exception ex)
	ROLLBACK;
	MessageBox("Error", "No se pudo guardar la configuración de impresora: " &
					+ "~r~n" + ex.getMessage(), StopSign!)
	return false
end try

end function

on n_cst_printer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_printer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

