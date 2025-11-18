$PBExportHeader$w_cn810_texto_daot_costos.srw
forward
global type w_cn810_texto_daot_costos from w_report_smpl
end type
type cb_1 from commandbutton within w_cn810_texto_daot_costos
end type
type em_ano from editmask within w_cn810_texto_daot_costos
end type
type em_uit from editmask within w_cn810_texto_daot_costos
end type
type st_1 from statictext within w_cn810_texto_daot_costos
end type
type st_2 from statictext within w_cn810_texto_daot_costos
end type
type em_mes_desde from editmask within w_cn810_texto_daot_costos
end type
type em_mes_hasta from editmask within w_cn810_texto_daot_costos
end type
type st_3 from statictext within w_cn810_texto_daot_costos
end type
type st_4 from statictext within w_cn810_texto_daot_costos
end type
type cb_generar from commandbutton within w_cn810_texto_daot_costos
end type
type gb_2 from groupbox within w_cn810_texto_daot_costos
end type
end forward

global type w_cn810_texto_daot_costos from w_report_smpl
integer width = 3854
integer height = 1604
string title = "(CN810) DAOT (Declaración Anual de Operaciones con Terceros) - Costos"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
em_ano em_ano
em_uit em_uit
st_1 st_1
st_2 st_2
em_mes_desde em_mes_desde
em_mes_hasta em_mes_hasta
st_3 st_3
st_4 st_4
cb_generar cb_generar
gb_2 gb_2
end type
global w_cn810_texto_daot_costos w_cn810_texto_daot_costos

type variables
n_cst_utilitario invo_util
end variables

on w_cn810_texto_daot_costos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_uit=create em_uit
this.st_1=create st_1
this.st_2=create st_2
this.em_mes_desde=create em_mes_desde
this.em_mes_hasta=create em_mes_hasta
this.st_3=create st_3
this.st_4=create st_4
this.cb_generar=create cb_generar
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_uit
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_mes_desde
this.Control[iCurrent+7]=this.em_mes_hasta
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.cb_generar
this.Control[iCurrent+11]=this.gb_2
end on

on w_cn810_texto_daot_costos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_uit)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_mes_desde)
destroy(this.em_mes_hasta)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_generar)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_year, li_mes_desde, li_mes_hasta
string 	ls_msj_err
decimal 	ldc_uit

li_year       = integer(em_ano.text)
li_mes_desde = integer(em_mes_desde.text)
li_mes_hasta = integer(em_mes_hasta.text)
ldc_uit      = dec(em_uit.text)

if isnull(li_year) or li_year = 0 then
	MessageBox('Aviso','Debe registrar el año de proceso')
	return
end if

if isnull(li_mes_desde) or li_mes_desde = 0 or li_mes_desde > 12 then
	MessageBox('Aviso','Mes DESDE es incorrecto. Verifique')
	return
end if

if isnull(li_mes_hasta) or li_mes_hasta = 0 or li_mes_hasta > 12 then
	MessageBox('Aviso','Mes HASTA es incorrecto. Verifique')
	return
end if

if li_mes_desde > li_mes_hasta then
	MessageBox('Aviso','Rango de meses es incorrecto. Verificar')
	return
end if

if isnull(ldc_uit) or ldc_uit = 0.00 then
	MessageBox('Aviso','El valor de U.I.T. debe ser mayor a cero')
	return
end if

/*
	create or replace procedure usp_cntbl_daot_costos (
	  ani_year        in number,
	  ani_mes_desde   in number,
	  ani_mes_hasta   in number,
	  ani_UIT         in number
	) is
*/

DECLARE USP_CNTBL_DAOT_COSTOS PROCEDURE FOR 
	USP_CNTBL_DAOT_COSTOS( 	:li_year, 
									:li_mes_desde, 
									:li_mes_hasta, 
									:ldc_uit ) ;
Execute USP_CNTBL_DAOT_COSTOS ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	rollback ;
   MessageBox("Error", "Error en procedimiento USP_CNTBL_DAOT_COSTOS. Mensaje: " + ls_msj_err, StopSign! )
	return
END IF

Close USP_CNTBL_DAOT_COSTOS ;

ib_preview = true
event ue_preview()

dw_report.retrieve()

if dw_report.RowCount() > 0 then
	cb_generar.enabled = true
else
	cb_generar.enabled = false
end if
end event

type dw_report from w_report_smpl`dw_report within w_cn810_texto_daot_costos
integer x = 0
integer y = 204
integer width = 3291
integer height = 1052
integer taborder = 60
string dataobject = "d_cadena_daot_costos_ingresos_tbl"
end type

type cb_1 from commandbutton within w_cn810_texto_daot_costos
integer x = 2578
integer y = 72
integer width = 297
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type em_ano from editmask within w_cn810_texto_daot_costos
integer x = 229
integer y = 72
integer width = 251
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_uit from editmask within w_cn810_texto_daot_costos
integer x = 2107
integer y = 72
integer width = 370
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##,###,###,###.00"
end type

type st_1 from statictext within w_cn810_texto_daot_costos
integer x = 82
integer y = 84
integer width = 137
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn810_texto_daot_costos
integer x = 1591
integer y = 88
integer width = 498
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor UIT en curso :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_mes_desde from editmask within w_cn810_texto_daot_costos
integer x = 841
integer y = 72
integer width = 178
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_mes_hasta from editmask within w_cn810_texto_daot_costos
integer x = 1367
integer y = 72
integer width = 178
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_3 from statictext within w_cn810_texto_daot_costos
integer x = 512
integer y = 88
integer width = 320
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes desde :"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn810_texto_daot_costos
integer x = 1051
integer y = 88
integer width = 315
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_generar from commandbutton within w_cn810_texto_daot_costos
integer x = 2926
integer y = 72
integer width = 571
integer height = 92
integer taborder = 10
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

event clicked;String  ls_nomb_arch ,ls_path,ls_ruc,ls_year,ls_mes, ls_file_name
Integer li_filenum

try 
	ls_ruc = gnvo_app.empresa.is_ruc

	ls_year = trim(em_ano.text)

	//NOMBRE DE DIRECTORIO
	ls_path = gnvo_app.of_get_parametro("PATH_SIGRE_DAOT", 'i:\SIGRE_EXE\DAOT\')
	
	if right(ls_path, 1) = '\' then
		ls_path = mid(ls_path, 1, len(ls_path) - 1)
	end if
	
	//Directorio donde se guardan los archivos de Texto
	ls_path = ls_path + '\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + ls_year + '_' + ls_mes + '\' //NOMBRE DE DIRECTORIO
	
	If not DirectoryExists ( ls_path ) Then
		if not invo_util.of_CreateDirectory( ls_path ) then return
	End If

	ls_nomb_arch = '3350' + ls_ruc + ls_year + '_costos.TXT'
	
	
	ls_file_name= ls_path+ls_nomb_arch
	
	//Pregunto si desea sobrescribir el archivo
	if FileExists(ls_file_name) then
		if MessageBox('Aviso', 'El archivo ' + ls_file_name + ' ya existe, ¿Desea Sobreescribirlo?', &
										Information!, YesNo!, 1) = 2 then return
	end if
	
	if dw_report.SaveAs(ls_file_name,TEXT!, FALSE) = 1 then
		Messagebox('Aviso','Se Genero Satisfactoriamente Archivo DAOT '+ls_file_name, Information!)
	else
		Messagebox('Error','Se ha producido un error al grabar el DAOT '+ls_file_name + ', por favor verifique!', StopSign!)
	end if
	
catch ( Exception ex)
	gnvo_app.of_catch_Exception(ex, 'Error al generar archivo ebook')
end try




end event

type gb_2 from groupbox within w_cn810_texto_daot_costos
integer width = 2551
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccionar "
end type

