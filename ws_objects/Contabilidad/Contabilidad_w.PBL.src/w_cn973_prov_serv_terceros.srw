$PBExportHeader$w_cn973_prov_serv_terceros.srw
forward
global type w_cn973_prov_serv_terceros from w_prc
end type
type st_3 from statictext within w_cn973_prov_serv_terceros
end type
type st_2 from statictext within w_cn973_prov_serv_terceros
end type
type em_fec_final from editmask within w_cn973_prov_serv_terceros
end type
type em_fec_inicio from editmask within w_cn973_prov_serv_terceros
end type
type cb_cancelar from commandbutton within w_cn973_prov_serv_terceros
end type
type cb_generar from commandbutton within w_cn973_prov_serv_terceros
end type
type st_1 from statictext within w_cn973_prov_serv_terceros
end type
type gb_1 from groupbox within w_cn973_prov_serv_terceros
end type
end forward

global type w_cn973_prov_serv_terceros from w_prc
integer width = 1678
integer height = 1100
string title = "(CN973) Asiento Contable"
st_3 st_3
st_2 st_2
em_fec_final em_fec_final
em_fec_inicio em_fec_inicio
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_1 gb_1
end type
global w_cn973_prov_serv_terceros w_cn973_prov_serv_terceros

on w_cn973_prov_serv_terceros.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.em_fec_final=create em_fec_final
this.em_fec_inicio=create em_fec_inicio
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_fec_final
this.Control[iCurrent+4]=this.em_fec_inicio
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn973_prov_serv_terceros.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_fec_final)
destroy(this.em_fec_inicio)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_3 from statictext within w_cn973_prov_serv_terceros
integer x = 443
integer y = 528
integer width = 347
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Fecha Final"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn973_prov_serv_terceros
integer x = 443
integer y = 400
integer width = 347
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Fecha de Inicio"
boolean focusrectangle = false
end type

type em_fec_final from editmask within w_cn973_prov_serv_terceros
integer x = 818
integer y = 512
integer width = 325
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fec_inicio from editmask within w_cn973_prov_serv_terceros
integer x = 818
integer y = 384
integer width = 325
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type cb_cancelar from commandbutton within w_cn973_prov_serv_terceros
integer x = 878
integer y = 792
integer width = 320
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn973_prov_serv_terceros
integer x = 398
integer y = 788
integer width = 320
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;cb_generar.enabled  = false
cb_cancelar.enabled = false

date   ld_fec_inicio, ld_fec_final
string ls_mensaje

ld_fec_inicio = date(em_fec_inicio.text)
ld_fec_final  = date(em_fec_final.text)

if ld_fec_inicio > ld_fec_final then
	MessageBox ('Atención','Fecha de inicio no puede ser mayor a fecha final, Verificar')
	cb_generar.enabled  = true
	cb_cancelar.enabled = true
	return
end if

DECLARE PB_USP_CNTBL_PROV_SERV_TERCEROS PROCEDURE FOR USP_CNTBL_PROV_SERV_TERCEROS
        ( :ld_fec_inicio, :ld_fec_final, :gs_origen, :gs_user ) ;
EXECUTE PB_USP_CNTBL_PROV_SERV_TERCEROS ;

IF sqlca.sqlcode = -1 THEN
   ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', ls_mensaje, StopSign! )
	MessageBox ('Error',"Store Procedure USP_CNTBL_PROV_SERV_TERCEROS Falló", StopSign!)
ELSE
	COMMIT ;
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
END IF

CLOSE PB_USP_CNTBL_PROV_SERV_TERCEROS ;

cb_generar.enabled  = true
cb_cancelar.enabled = true

end event

type st_1 from statictext within w_cn973_prov_serv_terceros
integer x = 101
integer y = 112
integer width = 1394
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "PROVISION SERVICIOS DE TERECEROS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn973_prov_serv_terceros
integer x = 347
integer y = 292
integer width = 896
integer height = 372
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione "
end type

