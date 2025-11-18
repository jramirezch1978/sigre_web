$PBExportHeader$w_cn700_formato12.srw
forward
global type w_cn700_formato12 from w_rpt_list
end type
type cb_seleccionar from commandbutton within w_cn700_formato12
end type
type st_1 from statictext within w_cn700_formato12
end type
type dw_text from datawindow within w_cn700_formato12
end type
type sle_almacen from singlelineedit within w_cn700_formato12
end type
type sle_descrip from singlelineedit within w_cn700_formato12
end type
type hpb_1 from hprogressbar within w_cn700_formato12
end type
type sle_ano from singlelineedit within w_cn700_formato12
end type
type sle_mes from singlelineedit within w_cn700_formato12
end type
type st_2 from statictext within w_cn700_formato12
end type
type st_3 from statictext within w_cn700_formato12
end type
type gb_1 from groupbox within w_cn700_formato12
end type
type gb_2 from groupbox within w_cn700_formato12
end type
end forward

global type w_cn700_formato12 from w_rpt_list
integer width = 4325
integer height = 2516
string title = "[CN700] Formato 12 - Kardex"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 1073741824
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
sle_almacen sle_almacen
sle_descrip sle_descrip
hpb_1 hpb_1
sle_ano sle_ano
sle_mes sle_mes
st_2 st_2
st_3 st_3
gb_1 gb_1
gb_2 gb_2
end type
global w_cn700_formato12 w_cn700_formato12

type variables
String is_ope_vta, is_almacen, is_col = '', is_type
Integer ii_index

end variables

on w_cn700_formato12.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.hpb_1=create hpb_1
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_seleccionar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.hpb_1
this.Control[iCurrent+7]=this.sle_ano
this.Control[iCurrent+8]=this.sle_mes
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_cn700_formato12.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.hpb_1)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;Long ll_width

ll_width = newwidth - st_box.x - st_box.width

dw_report.width = newwidth - dw_report.x
dw_report.height = p_pie.y - dw_report.y

dw_1.height = p_pie.y - dw_1.y
dw_2.height = p_pie.y - dw_2.y

pb_1.x = ll_width / 2 + st_box.x + st_box.width
pb_2.x = pb_1.x

dw_1.width = pb_1.x - dw_1.x - 10
dw_2.x = pb_1.x + pb_1.width + 10
dw_2.width = newwidth - dw_2.x - 10



end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "XLS Files (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(f_fecha_Actual(0), 'yyyy')
sle_mes.text = string(f_fecha_Actual(0), 'mm')
end event

type p_pie from w_rpt_list`p_pie within w_cn700_formato12
end type

type ole_skin from w_rpt_list`ole_skin within w_cn700_formato12
end type

type uo_h from w_rpt_list`uo_h within w_cn700_formato12
end type

type st_box from w_rpt_list`st_box within w_cn700_formato12
end type

type phl_logonps from w_rpt_list`phl_logonps within w_cn700_formato12
end type

type p_mundi from w_rpt_list`p_mundi within w_cn700_formato12
end type

type p_logo from w_rpt_list`p_logo within w_cn700_formato12
end type

type dw_report from w_rpt_list`dw_report within w_cn700_formato12
boolean visible = false
integer x = 498
integer y = 476
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_formato12_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_cn700_formato12
integer x = 503
integer y = 624
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_sel_mov_alm_periodo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
//messagebox( ls_column, li_pos)
IF li_pos > 0 THEN
	is_col = mid(ls_column,1,li_pos - 1)
	
	st_1.text = "Busca x: " + dw_1.describe( is_col + "_t.text")
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
END  IF

end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

type pb_2 from w_rpt_list`pb_2 within w_cn700_formato12
integer x = 2199
integer y = 1268
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cn700_formato12
integer x = 2386
integer y = 624
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_sel_mov_alm_periodo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type cb_report from w_rpt_list`cb_report within w_cn700_formato12
integer x = 2793
integer y = 344
integer width = 366
integer height = 84
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Long		ll_year, ll_mes, ll_row
string	ls_almacen, ls_mensaje, ls_cod


try 
	SetPointer( Hourglass!)
	
	ll_year 	= Long (sle_ano.text)
	ll_mes	= Long(sle_mes.text) 
	ls_almacen = sle_almacen.text
	
	if ls_almacen = '' then
		Messagebox( "Aviso", "Indique almacen")
		return
	end if
	
	if dw_2.rowcount() = 0 then return	
	
	// Llena datos de dw seleccionados a tabla temporal
	delete from tt_alm_seleccion;
	commit;
	
		
	hpb_1.Maxposition = 1000
	hpb_1.Minposition = 0
		
	FOR ll_row = 1 to dw_2.rowcount()
		hpb_1.Position = Integer((ll_row / dw_2.RowCount( )) * 1000)
		hpb_1.visible = true
		SetMicrohelp( "Articulo: " + string(ll_row) + " de " + string(dw_2.rowcount()) )
		
		ls_cod = dw_2.object.cod_art[ll_row]		
		Insert into tt_alm_seleccion( cod_Art) 
		values ( :ls_cod);		
				
		If sqlca.sqlcode = -1 then
			ls_mensaje = SQLCA.SQLerrtext
			ROLLBACK;
			messagebox("Error al insertar registro en tt_alm_seleccion",ls_mensaje)
			return
		END IF
	
	NEXT	
	
	hpb_1.visible = false
	setMicrohelp( "Ejecutando Procedimiento" )
	
		
	dw_1.visible = false
	dw_2.visible = false		
	ib_preview = false		
	parent.Event ue_preview()		
	dw_report.SetTransObject( sqlca)
	dw_report.retrieve(ls_almacen, ll_year, ll_mes)	
	dw_report.visible = true
	dw_report.object.t_user.text 		= gnvo_app.is_user
	dw_report.object.t_empresa.text 	= gnvo_app.invo_empresa.is_empresa
	dw_report.object.t_periodo.text 	= "Periodo: " + string(ll_year, '0000') + '-' + string(ll_mes, '00')
	dw_report.Object.p_logo.filename = gnvo_app.is_logo
		
	cb_seleccionar.enabled = true
	cb_seleccionar.visible = true

catch ( Exception ex )
	rollback;
	MessageBox('Error', "Error al ejecutar reporte, mensaje de error: " + ex.getMessage())
finally
	SetPointer( Arrow!)
end try

end event

type pb_1 from w_rpt_list`pb_1 within w_cn700_formato12
integer x = 2199
integer y = 1100
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type cb_seleccionar from commandbutton within w_cn700_formato12
boolean visible = false
integer x = 2793
integer y = 248
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;// Crea archivo temporal
string 	ls_almacen
Long		ll_year, ll_mes

ls_almacen 	= sle_almacen.text
ll_year		= Long(sle_ano.text)
ll_mes		= Long(sle_mes.text)

dw_1.SetTransObject(SQLCA)
dw_1.retrieve(ls_almacen, ll_year, ll_mes)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	

cb_seleccionar.visible = false


end event

type st_1 from statictext within w_cn700_formato12
integer x = 503
integer y = 544
integer width = 494
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Buscar por:"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_cn700_formato12
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 1010
integer y = 536
integer width = 1157
integer height = 80
integer taborder = 90
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_text.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_1.Getrow()
return  0
//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event type long dwnenter();//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando  
Long ll_fila, li_x

SetPointer(hourglass!)

String ls_campo

if TRIM( is_col) <> '' THEN

	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)	
	if li_longitud > 0 then		// si ha escrito algo	   
	   IF UPPER( is_type) = 'N' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF

		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())	
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_text.reset()
	this.insertrow(0)
end if	
SetPointer(arrow!)
end event

type sle_almacen from singlelineedit within w_cn700_formato12
event dobleclick pbm_lbuttondblclk
integer x = 1221
integer y = 260
integer width = 224
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O' " &
		 + "  and cod_empresa = '" + gnvo_app.invo_empresa.is_empresa + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()
	cb_seleccionar.visible = true
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()
cb_seleccionar.visible = true

end event

type sle_descrip from singlelineedit within w_cn700_formato12
integer x = 1449
integer y = 260
integer width = 1211
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type hpb_1 from hprogressbar within w_cn700_formato12
boolean visible = false
integer x = 1230
integer y = 368
integer width = 1431
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type sle_ano from singlelineedit within w_cn700_formato12
integer x = 823
integer y = 252
integer width = 251
integer height = 72
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

type sle_mes from singlelineedit within w_cn700_formato12
integer x = 823
integer y = 348
integer width = 251
integer height = 72
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

type st_2 from statictext within w_cn700_formato12
integer x = 553
integer y = 260
integer width = 238
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn700_formato12
integer x = 553
integer y = 352
integer width = 238
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn700_formato12
integer x = 1193
integer y = 168
integer width = 1518
integer height = 300
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Almacen:"
end type

type gb_2 from groupbox within w_cn700_formato12
integer x = 507
integer y = 180
integer width = 654
integer height = 260
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "Periodo"
end type

