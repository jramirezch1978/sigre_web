$PBExportHeader$w_cn822_txt_liquidaciones_compra.srw
forward
global type w_cn822_txt_liquidaciones_compra from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn822_txt_liquidaciones_compra
end type
type sle_mes from singlelineedit within w_cn822_txt_liquidaciones_compra
end type
type cb_1 from commandbutton within w_cn822_txt_liquidaciones_compra
end type
type st_3 from statictext within w_cn822_txt_liquidaciones_compra
end type
type st_4 from statictext within w_cn822_txt_liquidaciones_compra
end type
type cb_2 from commandbutton within w_cn822_txt_liquidaciones_compra
end type
type gb_1 from groupbox within w_cn822_txt_liquidaciones_compra
end type
end forward

global type w_cn822_txt_liquidaciones_compra from w_report_smpl
integer width = 3369
integer height = 1604
string title = "[CN822] Texto para Importar Liquidaciones de Compra PDT617"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
cb_2 cb_2
gb_1 gb_1
end type
global w_cn822_txt_liquidaciones_compra w_cn822_txt_liquidaciones_compra

on w_cn822_txt_liquidaciones_compra.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.cb_2=create cb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_cn822_txt_liquidaciones_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Integer ln_ano, ln_mes

ln_ano = Integer(sle_ano.text)
ln_mes = Integer(sle_mes.text)

ib_preview = true
event ue_preview()

dw_report.retrieve(ln_ano, ln_mes)
if dw_report.RowCount() > 0 then
	cb_2.enabled = true
else
	cb_2.enabled = false
end if

end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(gnvo_app.of_fecha_Actual(), 'yyyy')
sle_mes.text = string(gnvo_app.of_fecha_Actual(), 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_cn822_txt_liquidaciones_compra
integer x = 0
integer y = 212
integer width = 3291
integer height = 1116
integer taborder = 50
string dataobject = "d_texto_liquidacion_compra_tbl"
end type

type sle_ano from singlelineedit within w_cn822_txt_liquidaciones_compra
integer x = 201
integer y = 76
integer width = 192
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn822_txt_liquidaciones_compra
integer x = 576
integer y = 76
integer width = 105
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn822_txt_liquidaciones_compra
integer x = 814
integer y = 60
integer width = 297
integer height = 92
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

type st_3 from statictext within w_cn822_txt_liquidaciones_compra
integer x = 411
integer y = 84
integer width = 160
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
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn822_txt_liquidaciones_compra
integer x = 37
integer y = 84
integer width = 155
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
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_cn822_txt_liquidaciones_compra
integer x = 1189
integer y = 40
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

event clicked;String  ls_nomb_arch ,ls_path,ls_ruc,ls_ano,ls_mes
Integer li_filenum

//select ruc into :ls_ruc from empresa e where e.cod_empresa = (select cod_empresa from genparam where reckey = '1') ;
ls_ruc = gnvo_app.empresa.is_ruc

ls_ano = trim(sle_ano.text)
ls_mes = trim(sle_mes.text)
ls_path='\sigre_exe\PDT617' //NOMBRE DE DIRECTORIO

ls_nomb_arch = '0617'+ls_ano+ls_mes+ls_ruc+'.lqc'




If not DirectoryExists ( ls_path ) Then
	//CREACION DE CARPETA
	CreateDirectory ( ls_path )

	li_filenum = ChangeDirectory( ls_path )

	if li_filenum = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio para PDT0617')
		RETURN
	end if	

End If



if dw_report.SaveAs(ls_path+ "\"+ls_nomb_arch,TEXT!, FALSE) = -1 then
	Messagebox('Error','A ocurrido un error al momento de generar el archivo de texto. Nombre del Archivo: '+ls_path + "\" + ls_nomb_arch, StopSign!)
else
	Messagebox('Aviso','Se Genero Archivo para PDT617 satifactoriamente. Nombre del Archivo: '+ls_path + "\" + ls_nomb_arch, Information!)
end if



end event

type gb_1 from groupbox within w_cn822_txt_liquidaciones_compra
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

