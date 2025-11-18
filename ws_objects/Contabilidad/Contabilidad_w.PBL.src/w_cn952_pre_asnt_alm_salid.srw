$PBExportHeader$w_cn952_pre_asnt_alm_salid.srw
forward
global type w_cn952_pre_asnt_alm_salid from w_prc
end type
type st_5 from statictext within w_cn952_pre_asnt_alm_salid
end type
type sle_libro from singlelineedit within w_cn952_pre_asnt_alm_salid
end type
type sle_mes from singlelineedit within w_cn952_pre_asnt_alm_salid
end type
type sle_ano from singlelineedit within w_cn952_pre_asnt_alm_salid
end type
type cb_cancelar from commandbutton within w_cn952_pre_asnt_alm_salid
end type
type cb_generar from commandbutton within w_cn952_pre_asnt_alm_salid
end type
type st_4 from statictext within w_cn952_pre_asnt_alm_salid
end type
type st_3 from statictext within w_cn952_pre_asnt_alm_salid
end type
type st_2 from statictext within w_cn952_pre_asnt_alm_salid
end type
type st_1 from statictext within w_cn952_pre_asnt_alm_salid
end type
type r_1 from rectangle within w_cn952_pre_asnt_alm_salid
end type
end forward

global type w_cn952_pre_asnt_alm_salid from w_prc
integer width = 1883
integer height = 1116
string title = "Pre asientos de almacen sub prod.term. (CN952)"
st_5 st_5
sle_libro sle_libro
sle_mes sle_mes
sle_ano sle_ano
cb_cancelar cb_cancelar
cb_generar cb_generar
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
r_1 r_1
end type
global w_cn952_pre_asnt_alm_salid w_cn952_pre_asnt_alm_salid

on w_cn952_pre_asnt_alm_salid.create
int iCurrent
call super::create
this.st_5=create st_5
this.sle_libro=create sle_libro
this.sle_mes=create sle_mes
this.sle_ano=create sle_ano
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_5
this.Control[iCurrent+2]=this.sle_libro
this.Control[iCurrent+3]=this.sle_mes
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.r_1
end on

on w_cn952_pre_asnt_alm_salid.destroy
call super::destroy
destroy(this.st_5)
destroy(this.sle_libro)
destroy(this.sle_mes)
destroy(this.sle_ano)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.r_1)
end on

event open;call super::open;String ls_ano, ls_mes, ls_nro_libro
Long ll_nro_libro
// Proceso CAVS

ls_ano = string( year( today() ) )
ls_mes = string( month( today() ) )
select libro_alm_sal into :ll_nro_libro from cntblparam where reckey='1';
					
sle_ano.text = ls_ano
sle_mes.text = ls_mes
sle_libro.text = string(ll_nro_libro)
end event

type st_5 from statictext within w_cn952_pre_asnt_alm_salid
integer x = 302
integer y = 196
integer width = 1243
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "almacen de sub productos terminados"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_libro from singlelineedit within w_cn952_pre_asnt_alm_salid
integer x = 1015
integer y = 596
integer width = 187
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_cn952_pre_asnt_alm_salid
integer x = 1015
integer y = 508
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

type sle_ano from singlelineedit within w_cn952_pre_asnt_alm_salid
integer x = 1015
integer y = 416
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

type cb_cancelar from commandbutton within w_cn952_pre_asnt_alm_salid
integer x = 965
integer y = 856
integer width = 302
integer height = 80
integer taborder = 70
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

type cb_generar from commandbutton within w_cn952_pre_asnt_alm_salid
integer x = 581
integer y = 856
integer width = 302
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;string  ls_ano, ls_mes, ls_fecha, ls_nro_libro, ls_msj
Date ld_fecha

cb_generar.enabled = false
sle_ano.enabled = false
sle_mes.enabled = false

ls_ano = sle_ano.text
ls_mes = sle_mes.text
ls_nro_libro = sle_libro.text
ld_fecha = today()

// Generacion de asientos contables de almacen de sub productos terminados

DECLARE PB_USP_CNT_952_ALM_ING PROCEDURE FOR USP_CNT_952_ALM_ING ( 
   :ls_ano, :ls_mes, :gs_origen, :gs_user, :ld_fecha ) ;
EXECUTE PB_USP_CNT_952_ALM_ING  ;

IF sqlca.sqlcode = -1 THEN
	ls_msj = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', ls_msj, StopSign! )
	MessageBox( 'Error', "Procedimiento <<USP_CNT_952_ALM_ING>> no concluyo correctamente", StopSign! )
ELSE
	
	COMMIT ;
	
	DECLARE PB_USP_CNT_952_ALM_SAL PROCEDURE FOR USP_CNT_952_ALM_SAL ( 
   :ls_ano, :ls_mes, :gs_origen, :gs_user, :ld_fecha ) ;
	EXECUTE PB_USP_CNT_952_ALM_SAL  ;

	IF sqlca.sqlcode = -1 THEN
		ls_msj = sqlca.sqlerrtext
		ROLLBACK ;
		MessageBox( 'Error', ls_msj, StopSign! )
		MessageBox( 'Error', "Procedimiento <<USP_CNT_952_ALM_SAL>> no concluyo correctamente", StopSign! )
	END IF 
	
	COMMIT ;
	
	MessageBox( 'Mensaje', "Proceso terminado" )
	Close pb_usp_cnt_952_alm_sal ;
END IF
		
Close pb_usp_cnt_952_alm_ing ;

cb_generar.enabled = true
sle_ano.enabled = true
sle_mes.enabled = true
end event

type st_4 from statictext within w_cn952_pre_asnt_alm_salid
integer x = 571
integer y = 592
integer width = 357
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro contable :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn952_pre_asnt_alm_salid
integer x = 571
integer y = 504
integer width = 357
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

type st_2 from statictext within w_cn952_pre_asnt_alm_salid
integer x = 571
integer y = 416
integer width = 357
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

type st_1 from statictext within w_cn952_pre_asnt_alm_salid
integer x = 361
integer y = 80
integer width = 1134
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generacion de pre asientos"
alignment alignment = center!
boolean focusrectangle = false
end type

type r_1 from rectangle within w_cn952_pre_asnt_alm_salid
integer linethickness = 1
long fillcolor = 12632256
integer x = 480
integer y = 360
integer width = 827
integer height = 356
end type

