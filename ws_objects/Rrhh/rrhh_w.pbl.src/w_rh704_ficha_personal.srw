$PBExportHeader$w_rh704_ficha_personal.srw
forward
global type w_rh704_ficha_personal from w_rpt
end type
type rb_2 from radiobutton within w_rh704_ficha_personal
end type
type rb_1 from radiobutton within w_rh704_ficha_personal
end type
type dw_report from u_dw_rpt within w_rh704_ficha_personal
end type
end forward

global type w_rh704_ficha_personal from w_rpt
integer x = 5
integer y = 4
integer width = 3877
integer height = 1840
string title = "Maestro de Personal (RH704)"
string menuname = "m_reporte"
rb_2 rb_2
rb_1 rb_1
dw_report dw_report
end type
global w_rh704_ficha_personal w_rh704_ficha_personal

type variables
Str_cns_pop istr_1
string is_ruta_foto
string is_vinculo_conyugue, is_vinculo_hijo, is_vinculo_padre, is_vinculo_madre, is_vinculo_hermano, is_vinculo_amigos, is_vinculo_referencias
end variables

forward prototypes
public subroutine of_load_foto (string as_codtra)
end prototypes

public subroutine of_load_foto (string as_codtra);//codigo para abrir documento pdf que se encuentra en un BLOB
blob lbl_pdfdoc, lbl_null
string ls_codinc, ls_prov

// obteniendo valores
ls_prov = TRIM(istr_1.arg[1])

string ls_rutaarchivo, ls_nombrearchivo
integer li_filenum, li_write_error

select substr(a.foto_trabaj,instr(foto_trabaj,'\',-1)+1)
  into :ls_nombrearchivo
  from maestro a where a.cod_trabajador = :ls_prov;

if ls_nombrearchivo = '' or isnull(ls_nombrearchivo) then
	return
end if

//se verifica si existe archivo
if directoryexists("C:\documentos_sigre") = false then
	if createdirectory("C:\documentos_sigre") <> 1 then
		MessageBox('Aviso','No se pudo crear directorio en "C:\documentos_sigre" para guardar el archivo')
		return
	end if
end if

// se puede establecer cualquier ruta donde tenga permisos de escritura el usuario
ls_rutaarchivo = "C:\documentos_sigre\"+ls_nombrearchivo

if fileexists(ls_rutaarchivo) then
	is_ruta_foto = ls_rutaarchivo//MessageBox('Aviso','Ya existe un archivo con el mismo nombre en el directorio "C:\documentos_sigre". No se podra continuar')
	return
end if

SetPointer(HourGlass!)

// obteniendo blob
selectblob foto_blob
		into :lbl_pdfdoc
		from maestro
	  where cod_trabajador = :ls_prov;

if isnull(lbl_pdfdoc) or lbl_pdfdoc = lbl_null then
	messagebox('Aviso','No Existe Documento Adjunto, revise por favor')
	SetPointer(Arrow!)
	return
end if
		
// se tiene que abrir con los siguientes permisos para poder sobre escribir
li_filenum = FileOpen(ls_rutaarchivo, StreamMode!, Write!, LockWrite!, Replace!)

if li_filenum = -1 then
	messagebox('Aviso','No se puede abrir foto por que no tiene acceso al directorio')
	SetPointer(Arrow!)
	return
end if

li_Write_Error = FileWriteEx(li_filenum, lbl_pdfdoc)

if li_Write_Error = -1 then
	messagebox('Aviso','No se puede guardar documento TEMPORAL por que no tiene acceso al directorio')
	SetPointer(Arrow!)
	return
end if

FileClose(li_filenum)
SetPointer(Arrow!)

is_ruta_foto = ls_rutaarchivo

end subroutine

on w_rh704_ficha_personal.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.rb_1
this.Control[iCurrent+3]=this.dw_report
end on

on w_rh704_ficha_personal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()


istr_1 = Message.PowerObjectParm
	of_load_foto(TRIM(istr_1.arg[1]))
	
is_vinculo_conyugue = '2'
is_vinculo_hijo ='1'
is_vinculo_padre = '5'
is_vinculo_madre = '6'
is_vinculo_hermano = '7'
is_vinculo_amigos = '8'
is_vinculo_referencias = '9'
	
THIS.Event ue_retrieve()


end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve;call super::ue_retrieve;
if rb_1.checked then
	idw_1.dataobject = 'd_rpt_ficha_personal_trab_tbl'
	idw_1.SetTransobject(SQLCA)
	idw_1.Retrieve(TRIM(istr_1.arg[1]))
else
	idw_1.dataobject = 'd_rpt_basc_ficha_personal_composite'
	idw_1.SetTransobject(SQLCA)
	idw_1.Retrieve(TRIM(istr_1.arg[1]), is_vinculo_conyugue, is_vinculo_hijo, is_vinculo_padre, is_vinculo_madre, is_vinculo_hermano, is_vinculo_amigos, is_vinculo_referencias)
end if

idw_1.object.p_logo.filename = gs_logo
idw_1.object.maestro_foto_trabaj.filename = is_ruta_foto

if rb_1.checked = false then
	idw_1.object.t_titulobasc1.text = 'ESTUDIO DE SEGURIDAD'
	idw_1.object.t_titulobasc2.text = 'PARA PERSONAL'
	idw_1.object.t_codigobasc.text = 'CANT.FO.05.1'
	idw_1.object.t_versionbasc.text = 'VERSIÓN: 00'
	idw_1.object.t_usuario.text = upper(gs_user)
	DataWindowChild state_child
	idw_1.GetChild('dw_15', state_child)
	state_child.insertrow(0)
end if

end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type rb_2 from radiobutton within w_rh704_ficha_personal
integer x = 402
integer y = 32
integer width = 344
integer height = 99
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "BASC"
end type

event clicked;parent.post event ue_retrieve()
end event

type rb_1 from radiobutton within w_rh704_ficha_personal
integer x = 37
integer y = 32
integer width = 344
integer height = 99
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "General"
boolean checked = true
end type

event clicked;parent.post event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_rh704_ficha_personal
integer x = 29
integer y = 154
integer width = 3771
integer height = 1488
string dataobject = "d_rpt_basc_ficha_personal_composite"
end type

event itemchanged;call super::itemchanged;parent.post event ue_retrieve()
end event

