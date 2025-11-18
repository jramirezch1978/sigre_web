$PBExportHeader$w_cm504_precio_promedio.srw
forward
global type w_cm504_precio_promedio from w_cns_list
end type
type gb_11 from groupbox within w_cm504_precio_promedio
end type
type rb_soles from radiobutton within w_cm504_precio_promedio
end type
type rb_dolares from radiobutton within w_cm504_precio_promedio
end type
type st_1 from statictext within w_cm504_precio_promedio
end type
type em_ano from editmask within w_cm504_precio_promedio
end type
end forward

global type w_cm504_precio_promedio from w_cns_list
integer x = 110
integer y = 436
integer height = 1952
string title = "[CM504] Precios de compra Promediados por Mes"
string menuname = "m_consulta_impresion"
event ue_saveas ( )
gb_11 gb_11
rb_soles rb_soles
rb_dolares rb_dolares
st_1 st_1
em_ano em_ano
end type
global w_cm504_precio_promedio w_cm504_precio_promedio

type variables
String is_col
end variables

forward prototypes
public function integer of_set_datos ()
end prototypes

event ue_saveas();dw_cns.saveas()
end event

public function integer of_set_datos ();Date ld_desde, ld_hasta
ld_desde = Date( '01/01/' + em_ano.text)
ld_hasta = Date( '31/12/' + em_ano.text)

SetPointer( hourglass!)

//	cb_consulta.enabled = false
	dw_1.visible = true
	dw_2.visible = true
	dw_cns.visible = false
	// genera archivo de articulos, solo los que se han movido segun compras
	DECLARE PB_USP_CMP_SEL_ARTICULOS PROCEDURE FOR USP_CMP_SEL_ARTICULOS(:ld_desde, :ld_hasta, 'A');
	EXECUTE PB_USP_CMP_SEL_ARTICULOS;
	If sqlca.sqlcode = -1 then
		messagebox("Error", sqlca.sqlerrtext)
		return 0
	end if	
	dw_1.reset()
	dw_2.reset()
	dw_1.retrieve(ld_desde, ld_hasta)
Return 1
end function

on w_cm504_precio_promedio.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_impresion" then this.MenuID = create m_consulta_impresion
this.gb_11=create gb_11
this.rb_soles=create rb_soles
this.rb_dolares=create rb_dolares
this.st_1=create st_1
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_11
this.Control[iCurrent+2]=this.rb_soles
this.Control[iCurrent+3]=this.rb_dolares
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_ano
end on

on w_cm504_precio_promedio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_11)
destroy(this.rb_soles)
destroy(this.rb_dolares)
destroy(this.st_1)
destroy(this.em_ano)
end on

event ue_open_pre();call super::ue_open_pre;dw_cns.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
dw_1.SetTransObject(sqlca)
idw_1 = dw_cns         // asignar dw corriente

// ii_help = 101           // help topic
idw_1.Visible = False


end event

event resize;call super::resize;dw_1.height = newheight  - dw_1.y - 10
dw_2.height = newheight  - dw_2.y - 10
dw_cns.height = newheight - dw_cns.y - 10
dw_cns.width = newwidth - dw_cns.x - 10
end event

type dw_1 from w_cns_list`dw_1 within w_cm504_precio_promedio
integer x = 14
integer y = 412
integer width = 1627
string dataobject = "d_sel_articulos_compras"
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type pb_1 from w_cns_list`pb_1 within w_cm504_precio_promedio
integer x = 1678
integer y = 752
end type

type pb_2 from w_cns_list`pb_2 within w_cm504_precio_promedio
integer x = 1678
integer y = 964
integer taborder = 60
end type

type dw_2 from w_cns_list`dw_2 within w_cm504_precio_promedio
integer x = 1847
integer y = 412
integer width = 1627
integer taborder = 50
string dataobject = "d_sel_articulos_compras"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type cb_consulta from w_cns_list`cb_consulta within w_cm504_precio_promedio
integer x = 2139
integer y = 72
integer width = 549
integer height = 96
integer taborder = 70
string text = "Consulta - Reporte"
end type

event cb_consulta::clicked;call super::clicked;dw_cns.retrieve()

	    
end event

type dw_cns from w_cns_list`dw_cns within w_cm504_precio_promedio
boolean visible = false
integer x = 18
integer y = 256
integer width = 3438
integer height = 1252
integer taborder = 40
string dataobject = "d_cns_precio_promedio_305"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_cns::constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form
end event

event dw_cns::doubleclicked;call super::doubleclicked;RETURN
String ls_cod_moneda, ls_cod_art

IF rb_soles.checked = true then
	Select cod_soles into :ls_cod_moneda from logparam; 
ELseIf rb_dolares.checked = true then
	Select cod_dolares into :ls_cod_moneda from logparam; 
End If

IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

lstr_1.DataObject = 'd_cns_precio_promedio_det_305'
lstr_1.Width = 3000
lstr_1.Height= 1250
lstr_1.Title = 'Precios promedios'
lstr_1.Arg[1] = GetItemString(row, 'cod_art')
ls_cod_art = lstr_1.Arg[1]

//DECLARE PB_USP_CNS_PRECIO_PROMEDIO_DET PROCEDURE FOR USP_CNS_PRECIO_PROMEDIO_DET
//         (:ls_cod_art, :ls_cod_moneda ) ;
//EXECUTE PB_USP_CNS_PRECIO_PROMEDIO_DET;
If sqlca.sqlcode = -1 then
	messagebox("Error al ejecutar Store Procedure", sqlca.sqlerrtext)
Else		
	of_new_sheet(lstr_1)
End IF
end event

type gb_11 from groupbox within w_cm504_precio_promedio
integer x = 32
integer y = 28
integer width = 1074
integer height = 200
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Moneda"
end type

type rb_soles from radiobutton within w_cm504_precio_promedio
integer x = 133
integer y = 112
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Soles"
boolean checked = true
boolean lefttext = true
end type

event clicked;//dw_master.dataobject = 'd_cns_precio_promedio_soles'
end event

type rb_dolares from radiobutton within w_cm504_precio_promedio
integer x = 686
integer y = 112
integer width = 315
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dólares"
boolean lefttext = true
end type

event clicked;
//dw_master.dataObject = 'd_cns_precio_promedio_dolar'
end event

type st_1 from statictext within w_cm504_precio_promedio
integer x = 1294
integer y = 100
integer width = 151
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type em_ano from editmask within w_cm504_precio_promedio
integer x = 1458
integer y = 92
integer width = 306
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

