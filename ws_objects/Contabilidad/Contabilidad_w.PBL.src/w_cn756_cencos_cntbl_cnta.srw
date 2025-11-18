$PBExportHeader$w_cn756_cencos_cntbl_cnta.srw
forward
global type w_cn756_cencos_cntbl_cnta from w_abc
end type
type sle_mes2 from singlelineedit within w_cn756_cencos_cntbl_cnta
end type
type st_2 from statictext within w_cn756_cencos_cntbl_cnta
end type
type sle_mes1 from singlelineedit within w_cn756_cencos_cntbl_cnta
end type
type st_1 from statictext within w_cn756_cencos_cntbl_cnta
end type
type st_4 from statictext within w_cn756_cencos_cntbl_cnta
end type
type cb_1 from commandbutton within w_cn756_cencos_cntbl_cnta
end type
type sle_ano from singlelineedit within w_cn756_cencos_cntbl_cnta
end type
type tab_1 from tab within w_cn756_cencos_cntbl_cnta
end type
type tabpage_1 from userobject within tab_1
end type
type dw_rpt1 from u_dw_rpt within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_rpt1 dw_rpt1
end type
type tabpage_2 from userobject within tab_1
end type
type tab_2 from tab within tabpage_2
end type
type tabpage_3 from userobject within tab_2
end type
type dw_flota1 from u_dw_rpt within tabpage_3
end type
type tabpage_3 from userobject within tab_2
dw_flota1 dw_flota1
end type
type tab_2 from tab within tabpage_2
tabpage_3 tabpage_3
end type
type tabpage_2 from userobject within tab_1
tab_2 tab_2
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_6 from userobject within tab_1
end type
type tabpage_7 from userobject within tab_1
end type
type dw_detallado from u_dw_rpt within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_detallado dw_detallado
end type
type tab_1 from tab within w_cn756_cencos_cntbl_cnta
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type
type gb_1 from groupbox within w_cn756_cencos_cntbl_cnta
end type
end forward

global type w_cn756_cencos_cntbl_cnta from w_abc
integer width = 2990
integer height = 2504
string title = "[CN756] Resumen Importe Centros Costo vs Grupo Contable"
string menuname = "m_abc_report_smpl"
event ue_retrieve ( )
sle_mes2 sle_mes2
st_2 st_2
sle_mes1 sle_mes1
st_1 st_1
st_4 st_4
cb_1 cb_1
sle_ano sle_ano
tab_1 tab_1
gb_1 gb_1
end type
global w_cn756_cencos_cntbl_cnta w_cn756_cencos_cntbl_cnta

type variables
u_dw_rpt idw_rpt1, idw_flota1, idw_detallado, idwr_1
end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

event ue_retrieve();//override
Integer 	li_year, li_mes1, li_mes2

of_asigna_dws()

li_year   = integer(sle_ano.text)
li_mes1	= integer(sle_mes1.text)
li_mes2  = integer(sle_mes2.text)

If isnull(li_year) or li_year = 0 then
	MessageBox('Aviso','Debe indicar Año')
	sle_ano.setFocus()
	Return
End if

If isnull(li_mes1) or li_mes1 = 0 then
	MessageBox('Aviso','Debe indicar Mes Desde')
	sle_mes1.setFocus()
	Return
End if

If isnull(li_mes2) or li_mes2 = 0 then
	MessageBox('Aviso','Debe indicar Mes hasta')
	sle_mes2.setFocus()
	Return
End if

idw_rpt1.ib_preview = true  
idw_rpt1.Event ue_preview()
  
idw_rpt1.retrieve(li_year, li_mes1, li_mes2)
idw_flota1.retrieve(li_year, li_mes1, li_mes2)
idw_detallado.retrieve(li_year, li_mes1, li_mes2)

SetPointer(Arrow!)
end event

public subroutine of_asigna_dws ();idw_rpt1 		= tab_1.tabpage_1.dw_rpt1
idw_flota1 		= tab_1.tabpage_2.tab_2.tabpage_3.dw_flota1
idw_detallado 	= tab_1.tabpage_7.dw_detallado
end subroutine

on w_cn756_cencos_cntbl_cnta.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_mes2=create sle_mes2
this.st_2=create st_2
this.sle_mes1=create sle_mes1
this.st_1=create st_1
this.st_4=create st_4
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.tab_1=create tab_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mes2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.sle_mes1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.sle_ano
this.Control[iCurrent+8]=this.tab_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_cn756_cencos_cntbl_cnta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_mes2)
destroy(this.st_2)
destroy(this.sle_mes1)
destroy(this.st_1)
destroy(this.st_4)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.tab_1)
destroy(this.gb_1)
end on

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_2.tab_2.width  = tab_1.tabpage_2.width  - tab_1.tabpage_2.tab_2.x - 10
tab_1.tabpage_2.tab_2.height = tab_1.tabpage_2.height - tab_1.tabpage_2.tab_2.y - 10

idw_rpt1.width  	= tab_1.tabpage_1.width  - idw_rpt1.x - 10
idw_rpt1.height  	= tab_1.tabpage_1.height  - idw_rpt1.y - 10

idw_flota1.width  	= tab_1.tabpage_2.tab_2.tabpage_3.width  - idw_flota1.x - 10
idw_flota1.height  	= tab_1.tabpage_2.tab_2.tabpage_3.height  - idw_flota1.y - 10

idw_detallado.width  	= tab_1.tabpage_7.width  - idw_detallado.x - 10
idw_detallado.height  	= tab_1.tabpage_7.height  - idw_detallado.y - 10
end event

event ue_open_pre;call super::ue_open_pre;string ls_cnta1, ls_cnta2
integer li_year

of_asigna_dws()

li_year = Integer(string(gnvo_app.of_fecha_actual(),'yyyy'))

sle_ano.text = string(li_year)
sle_mes1.text = string(gnvo_app.of_fecha_actual(),'mm')
sle_mes2.text = string(gnvo_app.of_fecha_actual(),'mm')

idw_rpt1.setTransObject( SQLCA )
idw_flota1.setTransObject( SQLCA )
idw_detallado.setTransObject( SQLCA )

idwr_1 = idw_rpt1

idwr_1.setFocus()
end event

event ue_saveas;call super::ue_saveas;idwr_1.EVENT ue_saveas()
end event

event ue_saveas_excel;call super::ue_saveas_excel;string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idwr_1, ls_file )
End If
end event

event ue_saveas_pdf;call super::ue_saveas_pdf;string ls_path, ls_file
int li_rc
n_cst_pdf	lnvo_pdf

ls_file = idw_1.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnvo_pdf = CREATE n_cst_pdf
	try
		if not lnvo_pdf.of_create_pdf( idwr_1, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnvo_pdf
		
	end try
	
End If
end event

event ue_filter_avanzado;//Override
IF idwr_1.is_dwform = 'tabular' THEN	
	idwr_1.Event ue_filter_avanzado()
end if

end event

event ue_filter;//Override
IF idwr_1.is_dwform = 'tabular' THEN	
	idwr_1.Event ue_filter()
end if

end event

type sle_mes2 from singlelineedit within w_cn756_cencos_cntbl_cnta
integer x = 1243
integer y = 76
integer width = 192
integer height = 76
integer taborder = 30
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

type st_2 from statictext within w_cn756_cencos_cntbl_cnta
integer x = 969
integer y = 84
integer width = 270
integer height = 60
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
string text = "Mes Hasta:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes1 from singlelineedit within w_cn756_cencos_cntbl_cnta
integer x = 768
integer y = 76
integer width = 192
integer height = 76
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

type st_1 from statictext within w_cn756_cencos_cntbl_cnta
integer x = 485
integer y = 84
integer width = 270
integer height = 60
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
string text = "Mes Desde:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn756_cencos_cntbl_cnta
integer x = 50
integer y = 84
integer width = 155
integer height = 60
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
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_cn756_cencos_cntbl_cnta
integer x = 1467
integer y = 40
integer width = 288
integer height = 144
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;SetPointer(hourglass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)

end event

type sle_ano from singlelineedit within w_cn756_cencos_cntbl_cnta
integer x = 219
integer y = 76
integer width = 192
integer height = 76
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

type tab_1 from tab within w_cn756_cencos_cntbl_cnta
event create ( )
event destroy ( )
integer y = 236
integer width = 2889
integer height = 1936
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2853
integer height = 1808
long backcolor = 79741120
string text = "Reporte Resumen"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_rpt1 dw_rpt1
end type

on tabpage_1.create
this.dw_rpt1=create dw_rpt1
this.Control[]={this.dw_rpt1}
end on

on tabpage_1.destroy
destroy(this.dw_rpt1)
end on

type dw_rpt1 from u_dw_rpt within tabpage_1
integer width = 2167
integer height = 1604
integer taborder = 20
string dataobject = "d_rpt_cencos_grupo_cntbl_ctb"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idwr_1.BorderStyle = StyleRaised!
idwr_1 = THIS
idwr_1.BorderStyle = StyleLowered!

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2853
integer height = 1808
long backcolor = 79741120
string text = "Costos de Flota"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
tab_2 tab_2
end type

on tabpage_2.create
this.tab_2=create tab_2
this.Control[]={this.tab_2}
end on

on tabpage_2.destroy
destroy(this.tab_2)
end on

type tab_2 from tab within tabpage_2
event create ( )
event destroy ( )
integer width = 2651
integer height = 1632
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_3 tabpage_3
end type

on tab_2.create
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_3}
end on

on tab_2.destroy
destroy(this.tabpage_3)
end on

type tabpage_3 from userobject within tab_2
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2615
integer height = 1504
long backcolor = 79741120
string text = "Resumen por Cuentas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_flota1 dw_flota1
end type

on tabpage_3.create
this.dw_flota1=create dw_flota1
this.Control[]={this.dw_flota1}
end on

on tabpage_3.destroy
destroy(this.dw_flota1)
end on

type dw_flota1 from u_dw_rpt within tabpage_3
integer width = 2167
integer height = 1604
string dataobject = "d_rpt_costo_flota_ctb"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idwr_1.BorderStyle = StyleRaised!
idwr_1 = THIS
idwr_1.BorderStyle = StyleLowered!

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2853
integer height = 1808
long backcolor = 79741120
string text = "Costos de Congelado"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2853
integer height = 1808
long backcolor = 79741120
string text = "Costos de Conservas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2853
integer height = 1808
long backcolor = 79741120
string text = "Costos de Harina"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2853
integer height = 1808
long backcolor = 79741120
string text = "Reporte detallado"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detallado dw_detallado
end type

on tabpage_7.create
this.dw_detallado=create dw_detallado
this.Control[]={this.dw_detallado}
end on

on tabpage_7.destroy
destroy(this.dw_detallado)
end on

type dw_detallado from u_dw_rpt within tabpage_7
integer width = 2167
integer height = 1604
string dataobject = "d_rpt_costos_x_cencos_detallados_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idwr_1.BorderStyle = StyleRaised!
idwr_1 = THIS
idwr_1.BorderStyle = StyleLowered!

end event

type gb_1 from groupbox within w_cn756_cencos_cntbl_cnta
integer width = 1838
integer height = 220
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = " Periodo Contable "
end type

