$PBExportHeader$w_rh912_subir_fotos.srw
forward
global type w_rh912_subir_fotos from w_abc
end type
type st_update from statictext within w_rh912_subir_fotos
end type
type hpb_progreso from hprogressbar within w_rh912_subir_fotos
end type
type st_registros from statictext within w_rh912_subir_fotos
end type
type lb_files from listbox within w_rh912_subir_fotos
end type
type cb_browse from commandbutton within w_rh912_subir_fotos
end type
type sle_directorio from singlelineedit within w_rh912_subir_fotos
end type
type st_1 from statictext within w_rh912_subir_fotos
end type
type pb_aceptar from p_aceptar within w_rh912_subir_fotos
end type
type pb_cancelar from p_cancelar within w_rh912_subir_fotos
end type
end forward

global type w_rh912_subir_fotos from w_abc
integer width = 1824
integer height = 2180
string title = "[CN912] Subir Fotos de Trabajadores"
string menuname = "m_only_exit"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
st_update st_update
hpb_progreso hpb_progreso
st_registros st_registros
lb_files lb_files
cb_browse cb_browse
sle_directorio sle_directorio
st_1 st_1
pb_aceptar pb_aceptar
pb_cancelar pb_cancelar
end type
global w_rh912_subir_fotos w_rh912_subir_fotos

on w_rh912_subir_fotos.create
int iCurrent
call super::create
if this.MenuName = "m_only_exit" then this.MenuID = create m_only_exit
this.st_update=create st_update
this.hpb_progreso=create hpb_progreso
this.st_registros=create st_registros
this.lb_files=create lb_files
this.cb_browse=create cb_browse
this.sle_directorio=create sle_directorio
this.st_1=create st_1
this.pb_aceptar=create pb_aceptar
this.pb_cancelar=create pb_cancelar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_update
this.Control[iCurrent+2]=this.hpb_progreso
this.Control[iCurrent+3]=this.st_registros
this.Control[iCurrent+4]=this.lb_files
this.Control[iCurrent+5]=this.cb_browse
this.Control[iCurrent+6]=this.sle_directorio
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.pb_aceptar
this.Control[iCurrent+9]=this.pb_cancelar
end on

on w_rh912_subir_fotos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_update)
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

ls_directorio = GetCurrentDirectory ( )

if mid(ls_directorio, len(ls_directorio), 1) <> '\' then
	ls_directorio += '\'
end if

sle_directorio.text = ls_directorio


lb_files.DirList(ls_directorio + "*.JPG", 1)
st_registros.text = string(lb_files.TotalItems()) + ' registro(s)'
end event

type st_update from statictext within w_rh912_subir_fotos
integer x = 1239
integer y = 1736
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
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type hpb_progreso from hprogressbar within w_rh912_subir_fotos
integer y = 1572
integer width = 1778
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type st_registros from statictext within w_rh912_subir_fotos
integer y = 1656
integer width = 1778
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type lb_files from listbox within w_rh912_subir_fotos
integer y = 212
integer width = 1778
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

type cb_browse from commandbutton within w_rh912_subir_fotos
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

type sle_directorio from singlelineedit within w_rh912_subir_fotos
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

type st_1 from statictext within w_rh912_subir_fotos
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

type pb_aceptar from p_aceptar within w_rh912_subir_fotos
integer x = 485
integer y = 1816
integer width = 411
integer height = 196
integer taborder = 10
string picturename = "C:\SIGRE\resources\BMP\aceptara.bmp"
end type

event clicked;call super::clicked;integer 			li_i, ll_update
string			ls_directorio, ls_fileName, ls_codtra
n_cst_maestro 	lnvo_master

try 
	lnvo_master = create n_cst_maestro
	
	ls_directorio = sle_directorio.text
	
	if mid(ls_directorio, len(ls_directorio), 1) <> '\' then
		ls_directorio += '\'
		sle_directorio.text = ls_directorio
	end if
	
	if not DirectoryExists(ls_directorio) then
		MessageBox('Error', 'Directorio ' + ls_directorio + ' no existe.', StopSign!)
		return
	end if
	
	ll_update = 0
	
	for li_i = 1 to lb_files.TotalItems( )
		ls_codtra = lb_files.text( li_i )
		
		ls_codtra = mid(ls_codtra, 1, pos(ls_codtra,'.') - 1) 
		
		ls_fileName = ls_directorio + ls_codtra + '.jpg'
		
		lb_files.selectItem( li_i )
		
		if lnvo_master.of_grabar_foto( ls_FileName, ls_CodTra) then
			ll_update ++
		end if
		
		hpb_progreso.position = li_i / lb_files.TotalItems() * 100
		
		st_registros.text = 'Procesando ' + string(li_i) + ' de ' &
								+ string(lb_files.TotalItems()) + ' registro(s)'
								
		st_update.text = 'Actualizando: ' + string(ll_update) + ' registro(s)'
		
	next
	
	st_registros.text = string(lb_files.TotalItems()) + ' registro(s)'
	lb_Files.SelectItem( 0 )

catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "Error al subir fotos masivamente")
	
finally
	destroy lnvo_master
	
end try


end event

type pb_cancelar from p_cancelar within w_rh912_subir_fotos
integer x = 905
integer y = 1816
integer width = 411
integer height = 196
integer taborder = 10
boolean originalsize = false
string picturename = "C:\SIGRE\resources\BMP\CANCELAR.BMP"
end type

