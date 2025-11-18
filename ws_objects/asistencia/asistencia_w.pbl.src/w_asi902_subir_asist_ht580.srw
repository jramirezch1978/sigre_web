$PBExportHeader$w_asi902_subir_asist_ht580.srw
forward
global type w_asi902_subir_asist_ht580 from w_abc
end type
type hpb_progreso from hprogressbar within w_asi902_subir_asist_ht580
end type
type st_registros from statictext within w_asi902_subir_asist_ht580
end type
type lb_files from listbox within w_asi902_subir_asist_ht580
end type
type cb_browse from commandbutton within w_asi902_subir_asist_ht580
end type
type sle_directorio from singlelineedit within w_asi902_subir_asist_ht580
end type
type st_1 from statictext within w_asi902_subir_asist_ht580
end type
type pb_aceptar from p_aceptar within w_asi902_subir_asist_ht580
end type
type pb_cancelar from p_cancelar within w_asi902_subir_asist_ht580
end type
end forward

global type w_asi902_subir_asist_ht580 from w_abc
integer width = 1815
integer height = 2080
string title = "[ASI902] Subir Asistencia del HT580"
string menuname = "m_proceso"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
event ue_aceptar ( )
hpb_progreso hpb_progreso
st_registros st_registros
lb_files lb_files
cb_browse cb_browse
sle_directorio sle_directorio
st_1 st_1
pb_aceptar pb_aceptar
pb_cancelar pb_cancelar
end type
global w_asi902_subir_asist_ht580 w_asi902_subir_asist_ht580

event ue_aceptar();integer 			li_i, li_file, li_Registros, li_Pos1, li_Pos2, li_count
string			ls_directorio, ls_fileName, ls_LineFile, ls_mensaje

// DAtos para leer cada registro del archivo de texto
string			ls_codigo, ls_flag_in_out, ls_fecha, ls_hora
DateTime			ldt_FechaHora


ls_directorio = sle_directorio.text

if mid(ls_directorio, len(ls_directorio), 1) <> '\' then
	ls_directorio += '\'
	sle_directorio.text = ls_directorio
end if

if not DirectoryExists(ls_directorio) then
	MessageBox('Error', 'Directorio ' + ls_directorio + ' no existe.')
	return
end if


if lb_files.Selectedindex( ) < 0 then
	MessageBox('Error', 'No ha seleccionado Archivo de Asistencia, por favor verifique')
	return
end if

ls_fileName = lb_files.Text(lb_files.Selectedindex( ))

ls_FileName = ls_directorio + ls_FileName

if not FileExists(ls_FileName) then
	MessageBox('Error', 'No existe Archivo ' + ls_FileName)
	return
end if

li_File = FileOpen(ls_FileName, LineMode!, Read!, Shared!)

if li_File < 0 then
	MessageBox('Error', 'No se ha podido abrir el archivo ' + ls_FileName &
		+ ' para lectura, por favor verifique')
	return
end if

li_Registros = 0
do while FileRead(li_file, ls_LineFile) > 0 
	ls_LineFile = trim(ls_LineFile)
	
	if len(ls_LineFile) = 0 then continue
	li_Registros ++
	
loop

FileClose(li_File)

if MessageBox('Aviso', 'El archivo ' + ls_FileName + ' tiene ' + string(li_Registros) &
		+ ' registros. ' &
		+ "~r~n¿Desea continuar el proceso de lectura de este archivo?", &
		Question!, Yesno!, 1)  = 1 then 
	
	//Inicializo los valores
	li_i = 0
	hpb_progreso.visible = true
	
	//Abro el archivo
	li_File = FileOpen(ls_FileName, LineMode!, Read!, Shared!)

	if li_File < 0 then
		MessageBox('Error', 'No se ha podido abrir el archivo ' + ls_FileName &
			+ ' para lectura, por favor verifique')
		return
	end if

	do while FileRead(li_file, ls_LineFile) > 0 
		ls_LineFile = trim(ls_LineFile)
		
		if len(ls_LineFile) = 0 then continue
		
		//Procesando Linea a Linea, primero saco el codigo
		li_Pos1 = 1
		li_Pos2 = pos(ls_LineFile, ';', li_Pos1)
		ls_codigo = mid(ls_LineFile, li_pos1, li_Pos2 - li_Pos1)
		
		//Ahora saco el Flag de Entrada o salida
		li_Pos1 = li_Pos2 + 1
		li_Pos2 = pos(ls_LineFile, ';', li_Pos1)
		ls_flag_in_out = mid(ls_LineFile, li_pos1, li_Pos2 - li_Pos1)
		
		//Ahora Saco la fecha
		li_Pos1 = li_Pos2 + 1
		li_Pos2 = pos(ls_LineFile, ';', li_Pos1)
		ls_fecha = mid(ls_LineFile, li_pos1, li_Pos2 - li_Pos1)
		
		//Ahora Saco la hora
		li_Pos1 = li_Pos2 + 1
		ls_hora = mid(ls_LineFile, li_pos1)
		
		//Convierto la fecha y hora de string a DateTime
		
		ls_fecha = mid(ls_fecha, 5,4) + '/' + mid(ls_fecha, 3,2) + '/' + mid(ls_fecha, 1, 2)
		ls_hora  = mid(ls_hora, 1, 2) + ':' + mid(ls_hora, 3,2) + ':' + mid(ls_hora, 5,2)
		
		ldt_FechaHora = dateTime(date(ls_fecha), Time(ls_hora))
		
		//Ahora inserto los datos en la tabla
		li_i ++
		st_registros.text = 'Procesando ' + string(li_i) + '/' + string(li_registros)
		hpb_progreso.position = li_i / li_Registros * 100
		
		select count(*)
			into :li_count
		from asistencia_ht580
		where cod_origen = :gs_origen
		  and codigo = :ls_codigo
		  and flag_in_out = :ls_flag_in_out
		  and fec_movimiento = :ldt_FechaHora;
		 
		if li_count = 0 then
			Insert into asistencia_ht580(
				cod_origen, codigo, flag_in_out, fec_registro, fec_movimiento, cod_usr)
			values(
				:gs_origen, :ls_codigo, :ls_flag_in_out, sysdate, :ldt_FechaHora, :gs_user);
			
			if SQLCA.SQLCode = -1 then
				ls_mensaje = SQLCA.SQLErrtext
				ROLLBACK;
				MessageBox('Error en insertar datos en tabla ASISTENCIA_HT580', &
						'Registro Nro: ' + string(li_i) &
						+ "~r~nMensaje de error: " + ls_mensaje)
				return
			end if
		else
			MessageBox('Aviso', 'El registro ' + string(li_i) &
				+ '~r~nTexto: ' + ls_LineFile &
				+ '~r~nya ha sido ingresado ')
				
		end if
		
	loop

	
	FileClose(li_File)
	
	// Grabo los cambios totales en la base de datos
	commit;
	MessageBox('Aviso', 'Proceso realizado satisfactoriamente', Exclamation!)
	
end if
		

hpb_progreso.position = 0
hpb_progreso.visible = false
st_registros.text = string(lb_files.TotalItems()) + ' archivo(s)'

end event

on w_asi902_subir_asist_ht580.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.hpb_progreso=create hpb_progreso
this.st_registros=create st_registros
this.lb_files=create lb_files
this.cb_browse=create cb_browse
this.sle_directorio=create sle_directorio
this.st_1=create st_1
this.pb_aceptar=create pb_aceptar
this.pb_cancelar=create pb_cancelar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.st_registros
this.Control[iCurrent+3]=this.lb_files
this.Control[iCurrent+4]=this.cb_browse
this.Control[iCurrent+5]=this.sle_directorio
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.pb_aceptar
this.Control[iCurrent+8]=this.pb_cancelar
end on

on w_asi902_subir_asist_ht580.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.st_registros)
destroy(this.lb_files)
destroy(this.cb_browse)
destroy(this.sle_directorio)
destroy(this.st_1)
destroy(this.pb_aceptar)
destroy(this.pb_cancelar)
end on

event open;call super::open;string ls_directorio

//ls_directorio = GetCurrentDirectory ( )
ls_directorio = 'i:\pb_exe'

if mid(ls_directorio, len(ls_directorio), 1) <> '\' then
	ls_directorio += '\'
end if

//Por defecto estará en el directorio de asistencia

ls_directorio += 'FilesHT580\'

if not DirectoryExists(ls_directorio) then
	CreateDirectory(ls_directorio)
end if

sle_directorio.text = ls_directorio

lb_files.DirList(ls_directorio + "*.DAT", 1)
st_registros.text = string(lb_files.TotalItems()) + ' archivo(s)'
end event

type hpb_progreso from hprogressbar within w_asi902_subir_asist_ht580
boolean visible = false
integer x = 558
integer y = 1568
integer width = 1207
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type st_registros from statictext within w_asi902_subir_asist_ht580
integer y = 1568
integer width = 535
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type lb_files from listbox within w_asi902_subir_asist_ht580
integer y = 212
integer width = 1760
integer height = 1348
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_browse from commandbutton within w_asi902_subir_asist_ht580
integer x = 1435
integer y = 108
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Examinar"
end type

event clicked;String ls_directorio
integer li_result

ls_directorio = sle_directorio.text

li_result = GetFolder( "Seleccione Directorio", ls_directorio )

// colocar la extensión al nombre el archivo
if li_result = 1 then
	if mid(ls_directorio, len(ls_directorio), 1) <> '\' then
		ls_directorio += '\'
	end if
	sle_directorio.text = ls_directorio
	lb_files.DirList( ls_directorio + "*.JPG", 1)
	st_registros.text = string(lb_files.totalitems( )) + ' registros'
end if

end event

type sle_directorio from singlelineedit within w_asi902_subir_asist_ht580
integer y = 112
integer width = 1422
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_directorio

ls_directorio = sle_directorio.text

if mid(ls_directorio, len(ls_directorio), 1) <> '\' then
	ls_directorio += '\'
end if

if not DirectoryExists(ls_directorio) then
	lb_Files.Reset( )
	MessageBox('Error', 'Directorio: ' + ls_directorio + ' no existe. Por favor verifique')
	return
end if

sle_directorio.text = ls_directorio
lb_files.DirList( ls_directorio + "*.JPG", 1)
st_registros.text = string(lb_files.totalitems( )) + ' registros'
end event

type st_1 from statictext within w_asi902_subir_asist_ht580
integer width = 681
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Directorio de  las fotos:"
boolean focusrectangle = false
end type

type pb_aceptar from p_aceptar within w_asi902_subir_asist_ht580
integer x = 553
integer y = 1696
integer taborder = 10
end type

event clicked;call super::clicked;parent.event ue_aceptar( )
end event

type pb_cancelar from p_cancelar within w_asi902_subir_asist_ht580
integer x = 974
integer y = 1696
integer taborder = 10
boolean originalsize = false
end type

