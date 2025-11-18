$PBExportHeader$w_cn976_matriz_nula_almacen.srw
forward
global type w_cn976_matriz_nula_almacen from w_prc
end type
type st_3 from statictext within w_cn976_matriz_nula_almacen
end type
type st_2 from statictext within w_cn976_matriz_nula_almacen
end type
type em_fecha_fin from editmask within w_cn976_matriz_nula_almacen
end type
type em_fecha_ini from editmask within w_cn976_matriz_nula_almacen
end type
type cb_cancelar from commandbutton within w_cn976_matriz_nula_almacen
end type
type cb_generar from commandbutton within w_cn976_matriz_nula_almacen
end type
type st_1 from statictext within w_cn976_matriz_nula_almacen
end type
type gb_1 from groupbox within w_cn976_matriz_nula_almacen
end type
end forward

global type w_cn976_matriz_nula_almacen from w_prc
integer width = 1714
integer height = 1072
string title = "(CN976) Actaulización Contable"
st_3 st_3
st_2 st_2
em_fecha_fin em_fecha_fin
em_fecha_ini em_fecha_ini
cb_cancelar cb_cancelar
cb_generar cb_generar
st_1 st_1
gb_1 gb_1
end type
global w_cn976_matriz_nula_almacen w_cn976_matriz_nula_almacen

on w_cn976_matriz_nula_almacen.create
int iCurrent
call super::create
this.st_3=create st_3
this.st_2=create st_2
this.em_fecha_fin=create em_fecha_fin
this.em_fecha_ini=create em_fecha_ini
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.em_fecha_fin
this.Control[iCurrent+4]=this.em_fecha_ini
this.Control[iCurrent+5]=this.cb_cancelar
this.Control[iCurrent+6]=this.cb_generar
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn976_matriz_nula_almacen.destroy
call super::destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.em_fecha_fin)
destroy(this.em_fecha_ini)
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

type st_3 from statictext within w_cn976_matriz_nula_almacen
integer x = 526
integer y = 520
integer width = 133
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Final"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn976_matriz_nula_almacen
integer x = 526
integer y = 392
integer width = 133
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Inicio"
boolean focusrectangle = false
end type

type em_fecha_fin from editmask within w_cn976_matriz_nula_almacen
integer x = 699
integer y = 516
integer width = 370
integer height = 80
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

type em_fecha_ini from editmask within w_cn976_matriz_nula_almacen
integer x = 699
integer y = 388
integer width = 370
integer height = 80
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

type cb_cancelar from commandbutton within w_cn976_matriz_nula_almacen
integer x = 878
integer y = 760
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

type cb_generar from commandbutton within w_cn976_matriz_nula_almacen
integer x = 398
integer y = 756
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

date   ld_fecha_ini, ld_fecha_fin
string ls_mensaje

ld_fecha_ini = date(em_fecha_ini.text)
ld_fecha_fin = date(em_fecha_fin.text)

DECLARE PB_USP_ALM_ACTUALIZA_MATRIZ_CNT PROCEDURE FOR USP_ALM_ACTUALIZA_MATRIZ_CNT
        ( :ld_fecha_ini, :ld_fecha_fin ) ;
EXECUTE PB_USP_ALM_ACTUALIZA_MATRIZ_CNT ;

IF sqlca.sqlcode = -1 THEN
   ls_mensaje = sqlca.sqlerrtext
	ROLLBACK ;
	MessageBox( 'Error', ls_mensaje, StopSign! )
	MessageBox ('Error',"Store Procedure USP_USP_ALM_ACTUALIZA_MATRIZ_CNT Falló", StopSign!)
ELSE
	COMMIT ;
	MessageBox ('Atención', "Proceso Ha Concluído Satisfactoriamente")
END IF

CLOSE PB_USP_ALM_ACTUALIZA_MATRIZ_CNT ;

cb_generar.enabled  = true
cb_cancelar.enabled = true

end event

type st_1 from statictext within w_cn976_matriz_nula_almacen
integer x = 146
integer y = 112
integer width = 1303
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "MATRICES NULAS DE ALMACEN"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn976_matriz_nula_almacen
integer x = 439
integer y = 304
integer width = 713
integer height = 352
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Fecha "
end type

