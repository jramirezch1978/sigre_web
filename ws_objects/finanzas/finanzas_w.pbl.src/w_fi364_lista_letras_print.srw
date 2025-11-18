$PBExportHeader$w_fi364_lista_letras_print.srw
forward
global type w_fi364_lista_letras_print from w_abc
end type
type st_6 from statictext within w_fi364_lista_letras_print
end type
type em_copias from editmask within w_fi364_lista_letras_print
end type
type gb_1 from groupbox within w_fi364_lista_letras_print
end type
type dw_boleta from datawindow within w_fi364_lista_letras_print
end type
type dw_master from u_dw_abc within w_fi364_lista_letras_print
end type
type cb_2 from commandbutton within w_fi364_lista_letras_print
end type
type sle_vouche2 from singlelineedit within w_fi364_lista_letras_print
end type
type cb_1 from commandbutton within w_fi364_lista_letras_print
end type
type st_1 from statictext within w_fi364_lista_letras_print
end type
type st_2 from statictext within w_fi364_lista_letras_print
end type
type st_3 from statictext within w_fi364_lista_letras_print
end type
type st_4 from statictext within w_fi364_lista_letras_print
end type
type st_5 from statictext within w_fi364_lista_letras_print
end type
type sle_vouche1 from singlelineedit within w_fi364_lista_letras_print
end type
type sle_libro from singlelineedit within w_fi364_lista_letras_print
end type
type sle_ano from singlelineedit within w_fi364_lista_letras_print
end type
type sle_mes from singlelineedit within w_fi364_lista_letras_print
end type
type sle_origen from singlelineedit within w_fi364_lista_letras_print
end type
end forward

global type w_fi364_lista_letras_print from w_abc
integer width = 3488
integer height = 2024
string title = "Impresión de Letras"
st_6 st_6
em_copias em_copias
gb_1 gb_1
dw_boleta dw_boleta
dw_master dw_master
cb_2 cb_2
sle_vouche2 sle_vouche2
cb_1 cb_1
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
sle_vouche1 sle_vouche1
sle_libro sle_libro
sle_ano sle_ano
sle_mes sle_mes
sle_origen sle_origen
end type
global w_fi364_lista_letras_print w_fi364_lista_letras_print

type variables
Long 		 il_fila
//Datastore ids_bol_print,ids_fac_print
end variables

forward prototypes
public subroutine wf_bol_cobrar (string as_tipo_doc, string as_nro_doc)
public subroutine wf_fact_cobrar (string as_tipo_doc, string as_nro_doc)
end prototypes

public subroutine wf_bol_cobrar (string as_tipo_doc, string as_nro_doc);

DECLARE pb_usp_fin_tt_ctas_x_cobrar PROCEDURE FOR usp_fin_tt_ctas_x_cobrar
(:as_tipo_doc,:as_nro_doc);
EXECUTE pb_usp_fin_tt_ctas_x_cobrar ;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure usp_fin_tt_ctas_x_cobrar , Comunicar en Area de Sistemas' )
	RETURN
END IF




IF f_imp_bol_fact() = FALSE THEN RETURN

dw_boleta.Retrieve()
dw_boleta.Print(True)


end subroutine

public subroutine wf_fact_cobrar (string as_tipo_doc, string as_nro_doc);
//
//DECLARE pb_usp_fin_tt_ctas_x_cobrar PROCEDURE FOR usp_fin_tt_ctas_x_cobrar
//(:as_tipo_doc,:as_nro_doc);
//EXECUTE pb_usp_fin_tt_ctas_x_cobrar ;
//
//
//IF SQLCA.SQLCode = -1 THEN 
//	MessageBox('Fallo Store Procedure','Store Procedure usp_fin_tt_ctas_x_cobrar , Comunicar en Area de Sistemas' )
//	RETURN
//END IF
//
////*Imprime Factura*//
//dw_factura.Retrieve()
//
//OpenWithParm(w_print_opt, dw_factura)
//If Message.DoubleParm = -1 Then Return
//dw_factura.Print(True)
//
////**//
//
end subroutine

on w_fi364_lista_letras_print.create
int iCurrent
call super::create
this.st_6=create st_6
this.em_copias=create em_copias
this.gb_1=create gb_1
this.dw_boleta=create dw_boleta
this.dw_master=create dw_master
this.cb_2=create cb_2
this.sle_vouche2=create sle_vouche2
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.sle_vouche1=create sle_vouche1
this.sle_libro=create sle_libro
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.sle_origen=create sle_origen
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.em_copias
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_boleta
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.sle_vouche2
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.sle_vouche1
this.Control[iCurrent+15]=this.sle_libro
this.Control[iCurrent+16]=this.sle_ano
this.Control[iCurrent+17]=this.sle_mes
this.Control[iCurrent+18]=this.sle_origen
end on

on w_fi364_lista_letras_print.destroy
call super::destroy
destroy(this.st_6)
destroy(this.em_copias)
destroy(this.gb_1)
destroy(this.dw_boleta)
destroy(this.dw_master)
destroy(this.cb_2)
destroy(this.sle_vouche2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.sle_vouche1)
destroy(this.sle_libro)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.sle_origen)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 170
dw_master.height = newheight - dw_master.y - 200
//pb_1.y = newheight -  200
//pb_2.y = newheight -  200
//
end event

event ue_open_pre();dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones

of_position_window(0,0)       			// Posicionar la ventana en forma fija

//idw_1.Retrieve('PR',integer(String(today(),'yyyy')),Integer(String(today(),'mm')),9,1,9999)


end event

event open;call super::open;// llena con valores x defecto

sle_ano.text =  string(today(),'yyyy')
sle_mes.text =  string(today(),'mm')





end event

type st_6 from statictext within w_fi364_lista_letras_print
integer x = 1710
integer y = 68
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nº de Copias:"
boolean focusrectangle = false
end type

type em_copias from editmask within w_fi364_lista_letras_print
integer x = 1787
integer y = 144
integer width = 197
integer height = 100
integer taborder = 110
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
borderstyle borderstyle = stylelowered!
string mask = "#####"
boolean spin = true
string minmax = "1~~"
end type

type gb_1 from groupbox within w_fi364_lista_letras_print
integer x = 64
integer y = 24
integer width = 1536
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

type dw_boleta from datawindow within w_fi364_lista_letras_print
boolean visible = false
integer x = 270
integer y = 1640
integer width = 302
integer height = 252
integer taborder = 120
string title = "none"
string dataobject = "d_rpt_bol_cobrar_ff"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;settransobject(sqlca)
end event

type dw_master from u_dw_abc within w_fi364_lista_letras_print
integer y = 372
integer width = 3424
integer height = 1868
integer taborder = 40
string dataobject = "d_abc_lista_letras_imp_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event clicked;//override

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst = dw_master // dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;//****************************************************************************************//
// Objectivo : Codigo para la seleccion en bloque.                                        //
// Argumento : This   -> Datawindows Actual.                                        //
//             as_indicador -> 'S'   Selección Simple                                     //
//                             'M'   Selección Multiple                                   //
// Sintaxis  : uf_seleccion(This,as_indicador)
//****************************************************************************************//

Integer  li_inicio, li_fin
String   ls_campo

This.AcceptText()

IF This.getrow() <= 0 THEN RETURN


IF KeyDown(KeyControl!) THEN
	il_fila = This.getrow()
	
//	Messagebox('il_fila',il_fila)
	
	IF This.IsSelected(il_fila) THEN
		This.SelectRow(il_fila , False)
	ELSE
		This.SelectRow(il_fila , True)
	END IF
	RETURN
END IF

IF KeyDown(KeyShift!) THEN
	li_inicio = This.getrow()
	IF (il_fila - li_inicio) > 0 THEN
		FOR li_fin = il_fila TO li_inicio STEP -1 
			This.SelectRow( li_fin , True)
		NEXT
	ELSE
		FOR li_fin = il_fila TO li_inicio
			 This.SelectRow( li_fin , True)
		NEXT
	END IF
	RETURN
END IF

il_fila = This.getrow()
This.setrow(il_fila)
This.SelectRow(0, False)
This.SelectRow(This.getrow() , True)
end event

type cb_2 from commandbutton within w_fi364_lista_letras_print
integer x = 1102
integer y = 208
integer width = 402
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir"
end type

event clicked;Integer li_imprime
String ls_nro_letra, ls_tempo, ls_cod_relacion
String ls_prtparam

Datastore lds_1
lds_1 = CREATE DATASTORE
lds_1.DataObject = 'd_rpt_letras_pagar_tbl'
lds_1.settransobject(sqlca)



FOR li_imprime = 1 to dw_master.rowcount()
	   ls_nro_letra    = dw_master.object.nro_doc      [li_imprime]
	   ls_cod_relacion = dw_master.object.cod_relacion [li_imprime]	
      lds_1.Retrieve( ls_nro_letra,ls_cod_relacion )	
		ls_prtparam = " datawindow.print.copies = "+em_copias.text		 

		// modifica datawindow
		lds_1.modify(ls_prtparam)
		
	   lds_1.Print()
NEXT







Destroy lds_1
end event

type sle_vouche2 from singlelineedit within w_fi364_lista_letras_print
integer x = 818
integer y = 228
integer width = 224
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_fi364_lista_letras_print
integer x = 1102
integer y = 88
integer width = 402
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Integer li_ano, li_mes, li_libro, li_vouche1, li_vouche2
String ls_origen

ls_origen = sle_origen.text
li_ano = integer(sle_ano.text)
li_mes = integer( sle_mes.text )
li_libro = integer( sle_libro.text)
li_vouche1 = integer( sle_vouche1.text )
li_vouche2 = integer( sle_vouche2.text )

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
ii_access = 1								

of_position_window(0,0)       			// Posicionar la ventana en forma fija

idw_1.Retrieve(ls_origen, li_ano, li_mes, li_libro,li_vouche1, li_vouche2 )


end event

type st_1 from statictext within w_fi364_lista_letras_print
integer x = 119
integer y = 72
integer width = 192
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi364_lista_letras_print
integer x = 343
integer y = 72
integer width = 133
integer height = 64
boolean bringtotop = true
integer textsize = -8
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

type st_3 from statictext within w_fi364_lista_letras_print
integer x = 526
integer y = 72
integer width = 114
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_fi364_lista_letras_print
integer x = 681
integer y = 72
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Libro:"
boolean focusrectangle = false
end type

type st_5 from statictext within w_fi364_lista_letras_print
integer x = 841
integer y = 76
integer width = 206
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vouche:"
boolean focusrectangle = false
end type

type sle_vouche1 from singlelineedit within w_fi364_lista_letras_print
integer x = 818
integer y = 140
integer width = 224
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_libro from singlelineedit within w_fi364_lista_letras_print
integer x = 672
integer y = 140
integer width = 146
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_fi364_lista_letras_print
integer x = 283
integer y = 140
integer width = 215
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_fi364_lista_letras_print
integer x = 503
integer y = 140
integer width = 165
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_origen from singlelineedit within w_fi364_lista_letras_print
integer x = 110
integer y = 140
integer width = 169
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

