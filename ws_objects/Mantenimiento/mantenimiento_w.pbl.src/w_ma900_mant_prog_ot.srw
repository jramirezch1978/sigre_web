$PBExportHeader$w_ma900_mant_prog_ot.srw
forward
global type w_ma900_mant_prog_ot from w_prc
end type
type dw_lista_m_prog from u_dw_drag_tbl within w_ma900_mant_prog_ot
end type
type uo_1 from u_cst_basket within w_ma900_mant_prog_ot
end type
type dw_lista_ot from u_dw_drag_tbl within w_ma900_mant_prog_ot
end type
type st_1 from statictext within w_ma900_mant_prog_ot
end type
type dw_text from datawindow within w_ma900_mant_prog_ot
end type
type st_campo from statictext within w_ma900_mant_prog_ot
end type
type cb_1 from commandbutton within w_ma900_mant_prog_ot
end type
type ddlb_1 from dropdownlistbox within w_ma900_mant_prog_ot
end type
type st_2 from statictext within w_ma900_mant_prog_ot
end type
end forward

global type w_ma900_mant_prog_ot from w_prc
integer width = 3639
integer height = 2020
string title = "Generación de Ordenes de Trabajo (MA900)"
string menuname = "m_abc_prc"
dw_lista_m_prog dw_lista_m_prog
uo_1 uo_1
dw_lista_ot dw_lista_ot
st_1 st_1
dw_text dw_text
st_campo st_campo
cb_1 cb_1
ddlb_1 ddlb_1
st_2 st_2
end type
global w_ma900_mant_prog_ot w_ma900_mant_prog_ot

type variables
String is_col = '',is_ano
end variables

forward prototypes
public subroutine wf_genera_ot ()
end prototypes

public subroutine wf_genera_ot ();String ls_nro_mant,ls_ano
Long 	 ll_row,ll_nro_mant


ll_row 			  = dw_lista_m_prog.Getrow()
ll_nro_mant		  = dw_lista_m_prog.object.nro_mantenimiento [ll_row]
ls_nro_mant 	  = Trim(String(ll_nro_mant))
ls_ano			  = String(dw_lista_m_prog.object.fec_estimada [ll_row],'yyyy')





		DECLARE pb_usp_add_orden_trabajo_ope_art PROCEDURE FOR usp_mtt_add_orden_trabajo_ope(  
   	        :ls_ano,:gs_origen,:gs_user,:ls_nro_mant);
	   execute pb_usp_add_orden_trabajo_ope_art;	
	
		IF SQLCA.sqlcode = -1 THEN
	   	Messagebox("Error Store Procedure No Funciona!, ",SQLCA.SQLErrText)			
			Rollback;

		ELSE
			Commit ;
		END IF 
		
dw_lista_ot.retrieve(ll_nro_mant)		
dw_lista_m_prog.object.nro_mant_prog [ll_row] = ll_nro_mant

end subroutine

event resize;call super::resize;
dw_lista_m_prog.width  = newwidth  - dw_lista_m_prog.x - 10

dw_lista_ot.width  	  = newwidth  - dw_lista_ot.x 	 - 450
dw_lista_ot.height = newheight - dw_lista_ot.y - 10


end event

event ue_open_pre();call super::ue_open_pre;Integer li_contador = 0
Long    ll_nro_mant_prog,ll_inicio,ll_ano_final,ll_ano_inic
String  ls_ano

ll_ano_final = Long(String(today(),'yyyy'))

of_position_window(0,0)
//Help
ii_help = 900

dw_lista_m_prog.Settransobject(sqlca)
dw_lista_ot.Settransobject(sqlca)
dw_lista_m_prog.retrieve(String(ll_ano_final))

ll_ano_inic  = ll_ano_final - 5
ll_ano_final = ll_ano_final + 5

FOR ll_inicio = ll_ano_inic TO ll_ano_final
	 li_contador ++	
	 ls_ano = Trim(String(ll_inicio))
	 ddlb_1.InsertItem(ls_ano, li_contador)
NEXT	

IF dw_lista_m_prog.Rowcount() > 0 THEN
	ll_nro_mant_prog	= dw_lista_m_prog.object.nro_mantenimiento [1] 
	dw_lista_ot.Retrieve(ll_nro_mant_prog)
	dw_lista_m_prog.Selectrow(0,FALSE)
	dw_lista_m_prog.Selectrow(1,TRUE)
END IF




of_position_window(0,0)       			// Posicionar la ventana en forma fija
end event

on w_ma900_mant_prog_ot.create
int iCurrent
call super::create
if this.MenuName = "m_abc_prc" then this.MenuID = create m_abc_prc
this.dw_lista_m_prog=create dw_lista_m_prog
this.uo_1=create uo_1
this.dw_lista_ot=create dw_lista_ot
this.st_1=create st_1
this.dw_text=create dw_text
this.st_campo=create st_campo
this.cb_1=create cb_1
this.ddlb_1=create ddlb_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista_m_prog
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.dw_lista_ot
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_text
this.Control[iCurrent+6]=this.st_campo
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.ddlb_1
this.Control[iCurrent+9]=this.st_2
end on

on w_ma900_mant_prog_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista_m_prog)
destroy(this.uo_1)
destroy(this.dw_lista_ot)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.st_campo)
destroy(this.cb_1)
destroy(this.ddlb_1)
destroy(this.st_2)
end on

type dw_lista_m_prog from u_dw_drag_tbl within w_ma900_mant_prog_ot
integer x = 32
integer y = 464
integer width = 2821
integer height = 436
string dragicon = "Rectangle!"
boolean bringtotop = true
string dataobject = "d_manten_prog_tbl"
boolean vscrollbar = true
end type

event clicked;//override
Long ll_nro_mant_prog

IF row = 0 THEN RETURN


il_row = row                    // fila corriente
This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.SetRow(row)

Drag(Begin!)

ll_nro_mant_prog = This.object.nro_mantenimiento [row]
dw_lista_ot.retrieve(ll_nro_mant_prog)		
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_lista_m_prog.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
//	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type uo_1 from u_cst_basket within w_ma900_mant_prog_ot
event destroy ( )
boolean visible = false
integer x = 3250
integer y = 1296
integer width = 306
integer height = 432
integer taborder = 50
boolean bringtotop = true
long backcolor = 15780518
borderstyle borderstyle = styleraised!
end type

on uo_1.destroy
call u_cst_basket::destroy
end on

event ue_output();call super::ue_output;String  ls_cod_origen,ls_nro_orden
Integer li_opcion
Long 	  ll_fila,ll_row

dw_lista_ot.Accepttext()
dw_lista_m_prog.Accepttext()

ll_fila = dw_lista_ot.Getrow()
ll_row  = dw_lista_m_prog.Getrow()

IF ll_fila > 0 THEN 
	li_opcion = MessageBox('Aviso','Desea Eliminar Orden de Trabajo',question!, yesno!, 2)
	IF li_opcion = 1 THEN
		ls_cod_origen 		= dw_lista_ot.Object.cod_origen    [ll_fila]
		ls_nro_orden  		= dw_lista_ot.Object.nro_orden	  [ll_fila]	

		
		Messagebox('aviso ls_cod_origen',ls_cod_origen)
		Messagebox('aviso ls_nro_orden',ls_nro_orden)
		DECLARE pb_usp_del_ord_trab_ope_art PROCEDURE FOR usp_del_ord_trab_ope_art
		(:ls_cod_origen,:ls_nro_orden);
	   EXECUTE pb_usp_del_ord_trab_ope_art;			
		
		
		IF SQLCA.sqlcode = -1 THEN
   		Messagebox("Error","Eliminación no se ha realizado")
			Return
		END IF
		
		Commit ;		
		
		dw_lista_ot.deleterow(ll_fila)
		dw_lista_m_prog.object.nro_mant_prog[ll_row] =0 
	END IF
END IF
end event

type dw_lista_ot from u_dw_drag_tbl within w_ma900_mant_prog_ot
integer x = 32
integer y = 916
integer width = 2825
integer height = 820
integer taborder = 40
string dragicon = "Warning!"
boolean bringtotop = true
string dataobject = "d_orden_trabajo_ff"
boolean vscrollbar = true
end type

event dragdrop;call super::dragdrop;Long ll_fila,ll_nro_mant_prog
Integer li_opcion, li_confirma
DataWindow ldw_Source



IF source.TypeOf() = DataWindow! then
//	beep(2)
	ldw_Source = source
	ldw_Source.Accepttext()
	IF ldw_Source.dataobject = 'd_manten_prog_tbl'  THEN
		ll_fila = ldw_Source.Getrow()
		ll_nro_mant_prog = ldw_Source.Object.nro_mant_prog[ll_fila]
		IF ll_fila = 0 THEN RETURN
		IF Isnull(ll_nro_mant_prog) OR ll_nro_mant_prog = 0  THEN 
			li_opcion = MessageBox('Confirmación','Desea Generar Orden de Trabajo',Question!, YesNo!, 2)
			IF li_opcion = 1 THEN
				wf_genera_ot()
			END IF
		END IF
	END IF
END IF
end event

event clicked;//override
IF row = 0 THEN RETURN

il_row = row                    // fila corriente
uo_1.idragobject = This
Drag(Begin!)


end event

type st_1 from statictext within w_ma900_mant_prog_ot
integer x = 37
integer y = 48
integer width = 814
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Mantenimiento Programados"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_ma900_mant_prog_ot
event dwnenter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 361
integer y = 140
integer width = 1394
integer height = 92
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_lista_m_prog.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_lista_m_prog.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_lista_m_prog.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_lista_m_prog.find(ls_comando, 1, dw_lista_m_prog.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_lista_m_prog.selectrow(0, false)
			dw_lista_m_prog.selectrow(ll_fila,true)
			dw_lista_m_prog.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type st_campo from statictext within w_ma900_mant_prog_ot
integer x = 37
integer y = 160
integer width = 256
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Busqueda :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ma900_mant_prog_ot
integer x = 3259
integer y = 120
integer width = 293
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Long   ll_nro_mant_prog
String ls_comodin = '%'

IF dw_lista_m_prog.Rowcount() > 0 THEN
	IF Long(is_ano) > 0 THEN
		
		DECLARE pb_usp_add_orden_trabajo_ope_art PROCEDURE FOR usp_mtt_add_orden_trabajo_ope(  
   	        :is_ano,:gs_origen,:gs_user,:ls_comodin);
	   execute pb_usp_add_orden_trabajo_ope_art;	
	
		IF SQLCA.sqlcode = -1 THEN
			Rollback;
	   	Messagebox("Error","Store Procedure No Funciona!")
		ELSE
			Commit ;
			dw_lista_m_prog.Retrieve(is_ano)

			IF dw_lista_m_prog.Rowcount() > 0 THEN
				ll_nro_mant_prog	= dw_lista_m_prog.object.nro_mantenimiento [1] 
				dw_lista_ot.Retrieve(ll_nro_mant_prog)
				dw_lista_m_prog.Selectrow(0,FALSE)
				dw_lista_m_prog.Selectrow(1,TRUE)
			ELSE
				dw_lista_ot.Reset()
			END IF
			
		END IF
	ELSE
		Messagebox('Aviso','Seleccione Año a Procesar')
	END IF
END IF
end event

type ddlb_1 from dropdownlistbox within w_ma900_mant_prog_ot
integer x = 2674
integer y = 140
integer width = 402
integer height = 308
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;Long ll_nro_mant_prog
is_ano = ddlb_1.text(index)
dw_lista_m_prog.Retrieve(is_ano)

IF dw_lista_m_prog.Rowcount() > 0 THEN
	ll_nro_mant_prog	= dw_lista_m_prog.object.nro_mantenimiento [1] 
	dw_lista_ot.Retrieve(ll_nro_mant_prog)
	dw_lista_m_prog.Selectrow(0,FALSE)
	dw_lista_m_prog.Selectrow(1,TRUE)
ELSE
	dw_lista_ot.Reset()
END IF


end event

type st_2 from statictext within w_ma900_mant_prog_ot
integer x = 2217
integer y = 156
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Año a Procesar :"
boolean focusrectangle = false
end type

