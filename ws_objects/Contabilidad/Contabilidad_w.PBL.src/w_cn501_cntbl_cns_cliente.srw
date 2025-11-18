$PBExportHeader$w_cn501_cntbl_cns_cliente.srw
forward
global type w_cn501_cntbl_cns_cliente from w_cns_list
end type
type sle_ano from singlelineedit within w_cn501_cntbl_cns_cliente
end type
type sle_mes_desde from singlelineedit within w_cn501_cntbl_cns_cliente
end type
type st_1 from statictext within w_cn501_cntbl_cns_cliente
end type
type st_2 from statictext within w_cn501_cntbl_cns_cliente
end type
type sle_mes_hasta from singlelineedit within w_cn501_cntbl_cns_cliente
end type
type st_3 from statictext within w_cn501_cntbl_cns_cliente
end type
type st_campo from statictext within w_cn501_cntbl_cns_cliente
end type
type dw_text from datawindow within w_cn501_cntbl_cns_cliente
end type
type pb_3 from picturebutton within w_cn501_cntbl_cns_cliente
end type
type gb_2 from groupbox within w_cn501_cntbl_cns_cliente
end type
type gb_3 from groupbox within w_cn501_cntbl_cns_cliente
end type
end forward

global type w_cn501_cntbl_cns_cliente from w_cns_list
integer width = 3255
integer height = 1824
string title = "Saldos de Cuenta Corriente por Código de relacion (CN501)"
string menuname = "m_abc_report_smpl"
event ue_saveas ( )
sle_ano sle_ano
sle_mes_desde sle_mes_desde
st_1 st_1
st_2 st_2
sle_mes_hasta sle_mes_hasta
st_3 st_3
st_campo st_campo
dw_text dw_text
pb_3 pb_3
gb_2 gb_2
gb_3 gb_3
end type
global w_cn501_cntbl_cns_cliente w_cn501_cntbl_cns_cliente

type variables
String is_col
Integer		ii_grf_val_index = 4
end variables

event ue_saveas();//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_cns, ls_file )
End If

end event

on w_cn501_cntbl_cns_cliente.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes_desde=create sle_mes_desde
this.st_1=create st_1
this.st_2=create st_2
this.sle_mes_hasta=create sle_mes_hasta
this.st_3=create st_3
this.st_campo=create st_campo
this.dw_text=create dw_text
this.pb_3=create pb_3
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes_desde
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_mes_hasta
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_campo
this.Control[iCurrent+8]=this.dw_text
this.Control[iCurrent+9]=this.pb_3
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
end on

on w_cn501_cntbl_cns_cliente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes_desde)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_mes_hasta)
destroy(this.st_3)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.pb_3)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event resize;// Override
end event

event ue_retrieve_list();call super::ue_retrieve_list;string ls_ano, ls_mesd, ls_mesh

ls_ano = string(sle_ano.text)
ls_mesd = string(sle_mes_desde.text)
ls_mesh = string(sle_mes_hasta.text)

DECLARE pb_usp_cntbl_cns_cliente PROCEDURE FOR USP_CNTBL_CNS_CLIENTE
        ( :ls_ano, :ls_mesd, :ls_mesh ) ;
EXECUTE pb_usp_cntbl_cns_cliente ;

dw_cns.of_set_split(dw_cns.of_get_column_end('nombre'))
dw_cns.retrieve()

end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)  

end event

type dw_1 from w_cns_list`dw_1 within w_cn501_cntbl_cns_cliente
integer x = 105
integer y = 344
integer width = 1399
integer height = 792
integer taborder = 0
string dataobject = "d_cntbl_codrel_tbl"
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;idw_1 = dw_cns
idw_1.Visible = False

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Orden: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type pb_1 from w_cns_list`pb_1 within w_cn501_cntbl_cns_cliente
integer x = 1563
integer y = 560
integer width = 96
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
alignment htextalign = center!
end type

type pb_2 from w_cns_list`pb_2 within w_cn501_cntbl_cns_cliente
integer x = 1563
integer y = 744
integer width = 96
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_cns_list`dw_2 within w_cn501_cntbl_cns_cliente
integer x = 1710
integer y = 344
integer width = 1399
integer height = 792
integer taborder = 0
string dataobject = "d_cntbl_codrel_tbl"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_consulta from w_cns_list`cb_consulta within w_cn501_cntbl_cns_cliente
integer x = 2898
integer y = 52
integer width = 270
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
string text = "Consulta"
end type

event cb_consulta::clicked;call super::clicked;string  ls_codigo, ls_descripcion
integer i

gb_3.visible = false
dw_1.visible = false
dw_2.visible = false
pb_1.visible = false
pb_1.visible = false

delete from tt_cntbl_cliente ;
	
for i = 1 to dw_2.rowcount()
  	 ls_codigo      = dw_2.object.proveedor[i]
 	 ls_descripcion = dw_2.object.nom_proveedor[i]
	 
	 insert into tt_cntbl_cliente (codigo, descripcion)
	 values (:ls_codigo, :ls_descripcion) ;
	 
	 if sqlca.sqlcode = -1 then
		 MessageBox("Error al Insertar Registro",sqlca.sqlerrtext)
	end if
next

dw_cns.SetTransObject(sqlca)
dw_cns.visible=true
parent.event ue_retrieve_list()

end event

type dw_cns from w_cns_list`dw_cns within w_cn501_cntbl_cns_cliente
boolean visible = false
integer x = 50
integer y = 356
integer width = 3186
integer height = 1248
integer taborder = 0
string dataobject = "d_cntbl_cns_cliente1_crt"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event dw_cns::constructor;call super::constructor;//Asignacion de variable sin efecto alguno
ii_ck[1] = 1 //Columna de lectura del dw.

end event

event dw_cns::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "codigo"  
		lstr_1.DataObject = 'd_cntbl_cns_cliente2_tbl'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.Title = 'Saldos de Documentos por Cliente y Cuenta'
		lstr_1.tipo_cascada = 'R'
		lstr_1.Arg[1] = GetItemString(row,'codigo')
		lstr_1.Arg[2] = ''
		lstr_1.Arg[3] = ''
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		lstr_1.NextCol = 'nro_doc'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type sle_ano from singlelineedit within w_cn501_cntbl_cns_cliente
integer x = 1669
integer y = 116
integer width = 165
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes_desde from singlelineedit within w_cn501_cntbl_cns_cliente
integer x = 2226
integer y = 116
integer width = 105
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn501_cntbl_cns_cliente
integer x = 1536
integer y = 128
integer width = 123
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn501_cntbl_cns_cliente
integer x = 1911
integer y = 128
integer width = 293
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes Desde"
boolean focusrectangle = false
end type

type sle_mes_hasta from singlelineedit within w_cn501_cntbl_cns_cliente
integer x = 2706
integer y = 116
integer width = 105
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn501_cntbl_cns_cliente
integer x = 2409
integer y = 128
integer width = 283
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type st_campo from statictext within w_cn501_cntbl_cns_cliente
integer x = 41
integer y = 192
integer width = 1426
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
string text = "orden :"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_cn501_cntbl_cns_cliente
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 37
integer y = 80
integer width = 1431
integer height = 84
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_1.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg
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
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type pb_3 from picturebutton within w_cn501_cntbl_cns_cliente
integer x = 2953
integer y = 156
integer width = 165
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\retroceder.bmp"
alignment htextalign = left!
end type

event clicked;dw_cns.visible=false
gb_3.visible = true
dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true


end event

type gb_2 from groupbox within w_cn501_cntbl_cns_cliente
integer x = 1513
integer y = 48
integer width = 1344
integer height = 192
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

type gb_3 from groupbox within w_cn501_cntbl_cns_cliente
integer x = 50
integer y = 264
integer width = 3113
integer height = 912
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

