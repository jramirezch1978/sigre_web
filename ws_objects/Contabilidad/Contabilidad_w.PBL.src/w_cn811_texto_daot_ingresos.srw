$PBExportHeader$w_cn811_texto_daot_ingresos.srw
forward
global type w_cn811_texto_daot_ingresos from w_report_smpl
end type
type cb_1 from commandbutton within w_cn811_texto_daot_ingresos
end type
type em_ano from editmask within w_cn811_texto_daot_ingresos
end type
type em_uit from editmask within w_cn811_texto_daot_ingresos
end type
type st_1 from statictext within w_cn811_texto_daot_ingresos
end type
type st_2 from statictext within w_cn811_texto_daot_ingresos
end type
type em_mes_desde from editmask within w_cn811_texto_daot_ingresos
end type
type em_mes_hasta from editmask within w_cn811_texto_daot_ingresos
end type
type st_3 from statictext within w_cn811_texto_daot_ingresos
end type
type st_4 from statictext within w_cn811_texto_daot_ingresos
end type
type cb_generar from commandbutton within w_cn811_texto_daot_ingresos
end type
type gb_2 from groupbox within w_cn811_texto_daot_ingresos
end type
end forward

global type w_cn811_texto_daot_ingresos from w_report_smpl
integer width = 4027
integer height = 1604
string title = "(CN811) DAOT (Declaración Anual de Operaciones con Terceros) - Ingresos"
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
global w_cn811_texto_daot_ingresos w_cn811_texto_daot_ingresos

on w_cn811_texto_daot_ingresos.create
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

on w_cn811_texto_daot_ingresos.destroy
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

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes_desde, li_mes_hasta
decimal {2} ldc_uit
string ls_msj_err

li_ano       = integer(em_ano.text)
li_mes_desde = integer(em_mes_desde.text)
li_mes_hasta = integer(em_mes_hasta.text)
ldc_uit      = dec(em_uit.text)

if isnull(li_ano) or li_ano = 0 then
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

DECLARE USP_CNTBL_DAOT_INGRESOS PROCEDURE FOR 
	USP_CNTBL_DAOT_INGRESOS( :li_ano, 
									 :li_mes_desde, 
									 :li_mes_hasta, 
									 :ldc_uit ) ;
Execute USP_CNTBL_DAOT_INGRESOS ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	rollback ;
   MessageBox("Error ", "Ha ocurrido un error en el procedimiento USP_CNTBL_DAOT_INGRESOS: " + ls_msj_err, StopSign! )
	return
END IF

Close USP_CNTBL_DAOT_INGRESOS ;

ib_preview = true
event ue_preview()

dw_report.retrieve()

if dw_report.RowCount() > 0 then
	cb_generar.enabled = true
else
	cb_generar.enabled = false
end if
end event

type dw_report from w_report_smpl`dw_report within w_cn811_texto_daot_ingresos
integer x = 0
integer y = 236
integer width = 3291
integer height = 1060
integer taborder = 60
string dataobject = "d_cadena_daot_costos_ingresos_tbl"
end type

type cb_1 from commandbutton within w_cn811_texto_daot_ingresos
integer x = 2592
integer y = 60
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

type em_ano from editmask within w_cn811_texto_daot_ingresos
integer x = 229
integer y = 76
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

type em_uit from editmask within w_cn811_texto_daot_ingresos
integer x = 2107
integer y = 76
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

type st_1 from statictext within w_cn811_texto_daot_ingresos
integer x = 82
integer y = 84
integer width = 128
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn811_texto_daot_ingresos
integer x = 1591
integer y = 92
integer width = 494
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Base Imponible :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_mes_desde from editmask within w_cn811_texto_daot_ingresos
integer x = 841
integer y = 76
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

type em_mes_hasta from editmask within w_cn811_texto_daot_ingresos
integer x = 1367
integer y = 76
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

type st_3 from statictext within w_cn811_texto_daot_ingresos
integer x = 526
integer y = 92
integer width = 274
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Desde"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn811_texto_daot_ingresos
integer x = 1074
integer y = 92
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type cb_generar from commandbutton within w_cn811_texto_daot_ingresos
integer x = 2926
integer y = 52
integer width = 571
integer height = 112
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

event clicked;String  ls_nomb_arch ,ls_path,ls_ruc,ls_ano,ls_mes
Integer li_filenum

ls_ruc = gnvo_app.empresa.is_ruc

ls_ano = trim(em_ano.text)

ls_path='\SIGRE_EXE\DAOT\' //NOMBRE DE DIRECTORIO

ls_nomb_arch = '3350'+ls_ruc+ls_ano+ '_Ingresos.TXT'

If not DirectoryExists ( ls_path ) Then
	//CREACION DE CARPETA
	CreateDirectory ( ls_path )

	li_filenum = ChangeDirectory( ls_path )

	if li_filenum = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio EBOOK')
		RETURN
	end if	

End If

dw_report.SaveAs(ls_path+ls_nomb_arch,TEXT!, FALSE)

Messagebox('Aviso','Se Genero Archivo DAOT '+ls_path+ls_nomb_arch)
end event

type gb_2 from groupbox within w_cn811_texto_daot_ingresos
integer width = 2551
integer height = 220
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

