$PBExportHeader$w_fi901_proceso_impresion_cri.srw
forward
global type w_fi901_proceso_impresion_cri from window
end type
type rb_cr from radiobutton within w_fi901_proceso_impresion_cri
end type
type rb_crp from radiobutton within w_fi901_proceso_impresion_cri
end type
type cbx_ts from checkbox within w_fi901_proceso_impresion_cri
end type
type em_1 from editmask within w_fi901_proceso_impresion_cri
end type
type dw_rpt from datawindow within w_fi901_proceso_impresion_cri
end type
type em_2 from editmask within w_fi901_proceso_impresion_cri
end type
type st_2 from statictext within w_fi901_proceso_impresion_cri
end type
type st_1 from statictext within w_fi901_proceso_impresion_cri
end type
type cb_1 from commandbutton within w_fi901_proceso_impresion_cri
end type
type gb_1 from groupbox within w_fi901_proceso_impresion_cri
end type
end forward

global type w_fi901_proceso_impresion_cri from window
integer width = 1682
integer height = 832
boolean titlebar = true
string title = "Impresión Masiva de Comprobante de Retención (FI901)"
string menuname = "m_consulta"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
rb_cr rb_cr
rb_crp rb_crp
cbx_ts cbx_ts
em_1 em_1
dw_rpt dw_rpt
em_2 em_2
st_2 st_2
st_1 st_1
cb_1 cb_1
gb_1 gb_1
end type
global w_fi901_proceso_impresion_cri w_fi901_proceso_impresion_cri

on w_fi901_proceso_impresion_cri.create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.rb_cr=create rb_cr
this.rb_crp=create rb_crp
this.cbx_ts=create cbx_ts
this.em_1=create em_1
this.dw_rpt=create dw_rpt
this.em_2=create em_2
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.Control[]={this.rb_cr,&
this.rb_crp,&
this.cbx_ts,&
this.em_1,&
this.dw_rpt,&
this.em_2,&
this.st_2,&
this.st_1,&
this.cb_1,&
this.gb_1}
end on

on w_fi901_proceso_impresion_cri.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_cr)
destroy(this.rb_crp)
destroy(this.cbx_ts)
destroy(this.em_1)
destroy(this.dw_rpt)
destroy(this.em_2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type rb_cr from radiobutton within w_fi901_proceso_impresion_cri
integer x = 46
integer y = 344
integer width = 745
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comp. Retención Lima"
end type

type rb_crp from radiobutton within w_fi901_proceso_impresion_cri
integer x = 46
integer y = 428
integer width = 791
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comp. Retención (T. Carta)"
end type

type cbx_ts from checkbox within w_fi901_proceso_impresion_cri
integer x = 50
integer y = 532
integer width = 558
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terminal Server"
end type

type em_1 from editmask within w_fi901_proceso_impresion_cri
integer x = 512
integer y = 64
integer width = 439
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###-######"
end type

type dw_rpt from datawindow within w_fi901_proceso_impresion_cri
integer x = 41
integer y = 856
integer width = 1097
integer height = 288
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type em_2 from editmask within w_fi901_proceso_impresion_cri
integer x = 512
integer y = 192
integer width = 439
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###-######"
end type

type st_2 from statictext within w_fi901_proceso_impresion_cri
integer x = 73
integer y = 200
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi901_proceso_impresion_cri
integer x = 73
integer y = 72
integer width = 343
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fi901_proceso_impresion_cri
integer x = 1184
integer y = 56
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Imprimir"
end type

event clicked;String ls_cadena
Long   ll_nro_inicial,ll_nro_final,ll_inicio


IF rb_cr.checked THEN
   /*asignacion de dw*/
	if cbx_ts.checked then
		dw_rpt.dataobject =  'd_rpt_formato_retencion_igv_ts_tbl'
		
	else
		/*IMPRESION LOCAL */
		dw_rpt.dataobject =  'd_rpt_formato_retencion_igv_tbl'		
	end if
	
ELSEIF rb_crp.checked THEN
	/*asignacion de dw*/
	if cbx_ts.checked then
	
		dw_rpt.dataobject = 'd_rpt_formato_carta_ret_igv_terminal_tbl'
	else
		dw_rpt.dataobject = 'd_rpt_formato_paramong_retencion_igv_tbl'		
	end if
	
ELSE
	Messagebox('Aviso','Debe Seleccionar Un Tipo de Impresion')
	Return
END IF



ll_nro_inicial = Long(mid(trim(em_1.text),5,6))
ll_nro_final   = Long(mid(trim(em_2.text),5,6))


dw_rpt.Settransobject(sqlca)

For ll_inicio = ll_nro_inicial To ll_nro_final
	 ls_cadena = mid(trim(em_1.text),1,3) +'-' + f_llena_caracteres('0',String(ll_inicio),6)

	 dw_rpt.Retrieve(ls_cadena)
	 dw_rpt.Print(True)	
Next	
end event

type gb_1 from groupbox within w_fi901_proceso_impresion_cri
integer width = 1623
integer height = 632
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

