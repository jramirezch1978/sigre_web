$PBExportHeader$w_cn906_valoriz_fap_ni.srw
forward
global type w_cn906_valoriz_fap_ni from w_prc
end type
type st_5 from statictext within w_cn906_valoriz_fap_ni
end type
type sle_mes from singlelineedit within w_cn906_valoriz_fap_ni
end type
type sle_ano from singlelineedit within w_cn906_valoriz_fap_ni
end type
type cb_cancelar from commandbutton within w_cn906_valoriz_fap_ni
end type
type cb_generar from commandbutton within w_cn906_valoriz_fap_ni
end type
type st_3 from statictext within w_cn906_valoriz_fap_ni
end type
type st_2 from statictext within w_cn906_valoriz_fap_ni
end type
type st_1 from statictext within w_cn906_valoriz_fap_ni
end type
type r_1 from rectangle within w_cn906_valoriz_fap_ni
end type
end forward

global type w_cn906_valoriz_fap_ni from w_prc
integer width = 1728
integer height = 1080
string title = "Valorización de materiales (CN906)"
st_5 st_5
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_3 st_3
st_2 st_2
st_1 st_1
r_1 r_1
end type
global w_cn906_valoriz_fap_ni w_cn906_valoriz_fap_ni

on w_cn906_valoriz_fap_ni.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.sle_ano
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_generar
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.r_1
end on

on w_cn906_valoriz_fap_ni.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.r_1)
end on

event open;call super::open;String ls_ano, ls_mes
Long ll_nro_libro

// Proceso CPEX (Contabilidad productos exonerados)
ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )

select libro_prod_exo into :ll_nro_libro from cntblparam where reckey='1';

sle_ano.text = ls_ano
sle_mes.text = ls_mes


end event

type st_5 from statictext within w_cn906_valoriz_fap_ni
integer x = 96
integer y = 176
integer width = 1445
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "de materiales en función a su facturación"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn906_valoriz_fap_ni
integer x = 923
integer y = 452
integer width = 187
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn906_valoriz_fap_ni
integer x = 923
integer y = 360
integer width = 187
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_cn906_valoriz_fap_ni
integer x = 887
integer y = 784
integer width = 302
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;close(parent)
end event

type cb_generar from commandbutton within w_cn906_valoriz_fap_ni
integer x = 475
integer y = 784
integer width = 302
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;string  ls_ano, ls_mes, ls_msj
Date ld_fecha

cb_generar.enabled = false
cb_cancelar.enabled = false
sle_ano.enabled = false
sle_mes.enabled = false

ld_fecha = today()
ls_ano = sle_ano.text
ls_mes = sle_mes.text


DECLARE PB_USP_CNT_VALOR_NI_FAP_MES PROCEDURE FOR USP_CNT_VALOR_NI_FAP_MES( 
   :ls_ano, :ls_mes ) ;
EXECUTE PB_USP_CNT_VALOR_NI_FAP_MES ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;	
	MessageBox( 'Error', ls_msj, StopSign! )
	MessageBox( 'Error', "Procedimiento <<USP_CNT_VALOR_NI_FAP_MES>> no concluyo correctamente", StopSign! )
ELSE
	COMMIT ;	
	MessageBox( 'Mensaje', "Proceso terminado" )
END IF
		
CLOSE PB_USP_CNT_VALOR_NI_FAP_MES ;

cb_generar.enabled = true
cb_cancelar.enabled = true
sle_ano.enabled = true
sle_mes.enabled = true
end event

type st_3 from statictext within w_cn906_valoriz_fap_ni
integer x = 521
integer y = 448
integer width = 224
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn906_valoriz_fap_ni
integer x = 521
integer y = 360
integer width = 233
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn906_valoriz_fap_ni
integer x = 155
integer y = 68
integer width = 1399
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valorización de ingresos de almacén"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cn906_valoriz_fap_ni
integer linethickness = 1
long fillcolor = 12632256
integer x = 448
integer y = 320
integer width = 768
integer height = 256
end type

