$PBExportHeader$uo_seriales.sru
forward
global type uo_seriales from uo_ddlistbox
end type
end forward

global type uo_seriales from uo_ddlistbox
integer width = 297
end type
global uo_seriales uo_seriales

forward prototypes
public function integer puerto ()
public function string puertos_seriales ()
public function integer num_entries (string as_cadena, string as_separador)
public function string entry (string as_cadena, integer ai_pos, string as_separador)
end prototypes

public function integer puerto ();Int li_puerto

li_puerto = 0

if Left(This.Text,3) = "COM" Then li_puerto = Integer(Mid(This.Text,4))
Return li_puerto

end function

public function string puertos_seriales ();String ls_regreso, ls_puerto, ls_devices[]
Integer li_i, li_j

ls_regreso = ''
if RegistryValues('HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM\',ls_devices) = 1 then
	li_j = UpperBound(ls_devices[])
	for li_i = 1 to li_j
		if RegistryGet('HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM',ls_devices[li_i],RegString!,ls_puerto) = 1 then
			ls_regreso = ls_regreso +  ls_puerto + ','
		else
			Return ''
		end if
	next
end if
li_j = Len(ls_regreso)
if li_j > 0 then ls_regreso = Left(ls_regreso,li_j - 1)
Return ls_regreso
end function

public function integer num_entries (string as_cadena, string as_separador);string ls_separador = '¦'
integer li_i, li_num = 0

if as_Separador <> '' then ls_separador = as_Separador
for li_i = 1 to len(as_cadena)
	if Mid(as_cadena,li_i,1) = ls_separador then li_num++
next
if li_num > 0 then
	li_num++
else
	li_num = 1
end if	
return li_num
end function

public function string entry (string as_cadena, integer ai_pos, string as_separador);/* Funcion que regresa una entry en una cadena el parametro pvs_separador puede ser null, si es asi se pondra por defaul ¦ */
string ls_return, ls_char, ls_separador = "¦"
integer li_pos, li_pos_ini, li_pos_fin, li_num_entries, li_i, li_ctr = 0

if as_separador <> '' then ls_separador = as_separador
li_num_entries = this.num_entries(as_Cadena,ls_separador)
setnull(ls_return)

if ai_pos > 0 and ai_pos <= li_num_entries then
	li_pos = Pos(as_Cadena,ls_separador)
	if li_pos > 0 then
		CHOOSE CASE ai_pos
		CASE 1 
			li_pos_fin = li_pos - 1
			ls_return = Left(as_cadena,li_pos_fin)		
		CASE li_num_entries
				li_pos = LastPos(as_cadena,ls_separador)
				li_pos_fin = li_pos + 1
				ls_return = Mid(as_cadena,li_pos_fin)			
		CASE ELSE
				ls_return = ''
				for li_i = 1 to len(as_cadena)
					ls_char = Mid(as_cadena,li_i,1) 
					if ls_char <> ls_separador then ls_return = ls_return + ls_char
					if ls_char = ls_separador then
						li_ctr++		
						if li_ctr = ai_pos then 
							return ls_return
						else
							ls_return = ''
						end if							
					end if						
				next
		END CHOOSE
	else
		ls_return = as_cadena
	end if
end if	
return trim(ls_return)
end function

on uo_seriales.create
call super::create
end on

on uo_seriales.destroy
call super::destroy
end on

event constructor;call super::constructor;String ls_seriales
Integer li_i, li_j

ls_seriales = this.puertos_seriales()
li_j = this.num_entries(ls_seriales,",")
for li_i = 1 to li_j
	This.AddItem(this.entry(ls_seriales,li_i,","))
next

li_i = This.FindItem("COM1",0)

if li_i > 0 then This.Text = This.Text(li_i)
end event

