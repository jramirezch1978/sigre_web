$PBExportHeader$w_cn793_resumen_diario.srw
forward
global type w_cn793_resumen_diario from w_report_smpl
end type
type cb_1 from commandbutton within w_cn793_resumen_diario
end type
type cb_2 from commandbutton within w_cn793_resumen_diario
end type
type gb_1 from groupbox within w_cn793_resumen_diario
end type
type uo_fecha from u_ingreso_fecha within w_cn793_resumen_diario
end type
type st_1 from statictext within w_cn793_resumen_diario
end type
type st_2 from statictext within w_cn793_resumen_diario
end type
type sle_nro_resumen from singlelineedit within w_cn793_resumen_diario
end type
end forward

global type w_cn793_resumen_diario from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN793] Resumen Diario de Comprobantes de Retencion"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
cb_2 cb_2
gb_1 gb_1
uo_fecha uo_fecha
st_1 st_1
st_2 st_2
sle_nro_resumen sle_nro_resumen
end type
global w_cn793_resumen_diario w_cn793_resumen_diario

on w_cn793_resumen_diario.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.cb_2=create cb_2
this.gb_1=create gb_1
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.st_2=create st_2
this.sle_nro_resumen=create sle_nro_resumen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_nro_resumen
end on

on w_cn793_resumen_diario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.gb_1)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_nro_resumen)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fecha

ld_fecha = uo_fecha.of_get_fecha()

ib_preview = true
event ue_preview()

dw_report.retrieve(ld_fecha)

if dw_report.RowCount() > 0 then
	cb_2.enabled = true
else
	cb_2.enabled = false
end if

end event

type dw_report from w_report_smpl`dw_report within w_cn793_resumen_diario
integer x = 0
integer y = 276
integer width = 3291
integer height = 1116
integer taborder = 50
string dataobject = "d_resumen_diario_retenciones_tbl"
end type

type cb_1 from commandbutton within w_cn793_resumen_diario
integer x = 2039
integer y = 60
integer width = 297
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type cb_2 from commandbutton within w_cn793_resumen_diario
integer x = 2341
integer y = 60
integer width = 571
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera Archivo TXT"
end type

event clicked;String  	ls_nomb_arch ,ls_path,ls_ruc, ls_nro_resumen
Integer 	li_filenum
date		ld_fecha


ls_ruc = gnvo_app.empresa.is_ruc
ls_nro_resumen = trim(sle_nro_resumen.text)
ld_fecha = uo_fecha.of_get_fecha()

//ls_ano = trim(sle_ano.text)
//ls_mes = trim(sle_mes.text)
ls_path='\sigre_exe\EBOOK' //NOMBRE DE DIRECTORIO

ls_nomb_arch = ls_ruc + '-20-' + string(ld_fecha, 'yyyymmdd') + '-' + ls_nro_resumen + '.txt'

If not DirectoryExists ( ls_path ) Then
	//CREACION DE CARPETA
	CreateDirectory ( ls_path )

	li_filenum = ChangeDirectory( ls_path )

	if li_filenum = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio para Resumen Diario de comprobantes', StopSign!)
		RETURN
	end if	

End If



if dw_report.SaveAs(ls_path+ "\"+ls_nomb_arch,TEXT!, FALSE) = -1 then
	Messagebox('Error','A ocurrido un error al momento de generar el archivo de texto. Nombre del Archivo: '+ls_path + "\" + ls_nomb_arch, StopSign!)
else
	Messagebox('Aviso','Se Genero Archivo para PDT626 satifactoriamente. Nombre del Archivo: '+ls_path + "\" + ls_nomb_arch, Information!)
end if



end event

type gb_1 from groupbox within w_cn793_resumen_diario
integer width = 736
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type uo_fecha from u_ingreso_fecha within w_cn793_resumen_diario
event destroy ( )
integer x = 27
integer y = 68
integer taborder = 50
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;DateTime ldt_hoy

ldt_hoy = gnvo_app.of_fecha_Actual()

of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

this.of_set_fecha(date(ldt_hoy))
end event

type st_1 from statictext within w_cn793_resumen_diario
integer y = 192
integer width = 3291
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "RESUMEN DIARIO DE COMPROBANTES DE RETENCION"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn793_resumen_diario
integer x = 754
integer y = 72
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nro Resumen: "
boolean focusrectangle = false
end type

type sle_nro_resumen from singlelineedit within w_cn793_resumen_diario
integer x = 1157
integer y = 68
integer width = 206
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "1"
borderstyle borderstyle = stylelowered!
end type

