$PBExportHeader$w_pr314_firma_partes.srw
forward
global type w_pr314_firma_partes from w_abc_master_smpl
end type
type dw_detail from u_dw_abc within w_pr314_firma_partes
end type
type cb_1 from commandbutton within w_pr314_firma_partes
end type
type dw_partes from u_dw_abc within w_pr314_firma_partes
end type
type st_campo from statictext within w_pr314_firma_partes
end type
type dw_text from datawindow within w_pr314_firma_partes
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr314_firma_partes
end type
type st_1 from statictext within w_pr314_firma_partes
end type
type st_mensaje from statictext within w_pr314_firma_partes
end type
type st_nro from statictext within w_pr314_firma_partes
end type
type sle_nro from singlelineedit within w_pr314_firma_partes
end type
type cb_2 from commandbutton within w_pr314_firma_partes
end type
type st_mensaje2 from statictext within w_pr314_firma_partes
end type
type gb_1 from groupbox within w_pr314_firma_partes
end type
type gb_2 from groupbox within w_pr314_firma_partes
end type
end forward

global type w_pr314_firma_partes from w_abc_master_smpl
integer width = 2985
integer height = 2608
string title = "Firma de Partes de Piso(PR314)"
string menuname = "m_mantto_smpl"
event ue_retrieve_partes ( )
dw_detail dw_detail
cb_1 cb_1
dw_partes dw_partes
st_campo st_campo
dw_text dw_text
uo_fecha uo_fecha
st_1 st_1
st_mensaje st_mensaje
st_nro st_nro
sle_nro sle_nro
cb_2 cb_2
st_mensaje2 st_mensaje2
gb_1 gb_1
gb_2 gb_2
end type
global w_pr314_firma_partes w_pr314_firma_partes

type variables
String is_col
end variables

forward prototypes
public subroutine of_retrieve (string as_nro_parte)
end prototypes

event ue_retrieve_partes();Date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

dw_partes.Retrieve(ld_fecha1, ld_fecha2)
end event

public subroutine of_retrieve (string as_nro_parte);
//dw_detail.reset( )

dw_master.Retrieve(as_nro_parte)
dw_detail.Retrieve(as_nro_parte)

st_mensaje.visible = false

dw_master.ii_protect = 0
dw_detail.ii_protect = 0

dw_master.of_protect( )
dw_detail.of_protect( )

dw_master.ii_update = 0
dw_detail.ii_update = 0

is_Action = 'open'
end subroutine

on w_pr314_firma_partes.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.dw_detail=create dw_detail
this.cb_1=create cb_1
this.dw_partes=create dw_partes
this.st_campo=create st_campo
this.dw_text=create dw_text
this.uo_fecha=create uo_fecha
this.st_1=create st_1
this.st_mensaje=create st_mensaje
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_2=create cb_2
this.st_mensaje2=create st_mensaje2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_partes
this.Control[iCurrent+4]=this.st_campo
this.Control[iCurrent+5]=this.dw_text
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_mensaje
this.Control[iCurrent+9]=this.st_nro
this.Control[iCurrent+10]=this.sle_nro
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.st_mensaje2
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_pr314_firma_partes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.cb_1)
destroy(this.dw_partes)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.uo_fecha)
destroy(this.st_1)
destroy(this.st_mensaje)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_2)
destroy(this.st_mensaje2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;// Relacionar el dw con la base de datos

dw_detail.SetTransObject(sqlca)
dw_partes.SetTransObject(sqlca)
dw_master.reset()
ib_log = TRUE
//is_tabla = 'TG_PARTE_PISO_FIRMA'
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing(dw_master, 'tabular') = false then
	return
	ib_update_check = false
end if

dw_master.of_set_flag_replicacion( )
end event

event ue_list_open;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'ds_partes_formados_tbl'
sl_param.titulo = 'Partes Firmados'
sl_param.field_ret_i[1] = 1	//Nro. Parte firmado

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;// Override
Long  ll_row


//if idw_1 = dw_master THEN
//    dw_master.Reset()
//end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if


end event

event open;//Override
IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	//THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_modify;call super::ue_modify;string 		ls_nro_parte

ls_nro_parte = dw_detail.object.nro_parte [dw_detail.GetRow()]

IF dw_detail.object.flag_estado[dw_detail.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Parte de piso ya ha sido Anulado.~r~No puede hacerle modificaciones')
	dw_master.retrieve( ls_nro_parte)
	dw_master.of_protect( )
	dw_detail.of_protect( )
RETURN

END IF
end event

event ue_delete;//Override

string 		ls_nro_parte

ls_nro_parte = dw_detail.object.nro_parte [dw_detail.GetRow()]

IF dw_detail.object.flag_estado[dw_detail.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Parte de piso ya ha sido Anulado.~r~No puede hacerle modificaciones')
	dw_master.retrieve( ls_nro_parte)
	dw_master.of_protect( )
	dw_detail.of_protect( )
RETURN

END IF

Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_query_retrieve;//Override

event ue_retrieve_partes()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pr314_firma_partes
event dragenter pbm_dwndragenter
event ue_display ( string as_columna,  long al_row )
integer x = 27
integer y = 1484
integer width = 2843
integer height = 900
string dataobject = "d_parte_piso_firmas"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
		case "COD_USR"

		ls_sql = "SELECT a.aprobador as Codigo," &
				  + "u.nombre as Nombre "&
				  + "FROM usuario u, aprob_parte_piso a "&
				  + "WHERE a.FLAG_ESTADO = '1' and u.cod_usr = a.aprobador"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_usr				[al_row] = ls_codigo
			this.object.usuario_nombre		[al_row] = ls_data
			this.object.aprobador			[al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose

end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		   // 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, form (default)

ii_ck[1] = 1			  // columnas de lectrua de este dw
ii_rk[1] = 1 	        // columnas que recibimos del master

idw_mst  = 				dw_master

end event

event dw_master::ue_insert_pre;//Override

long ll_reco, ll_firmas
string ls_nombre, ls_user, ls_formato, ls_nro_parte, ls_mensaje

boolean lb_find

ll_firmas = dw_master.rowcount()
lb_find = false
for ll_reco = 1 to ll_firmas
	ls_user = trim(this.object.cod_usr[ll_reco])
	if ls_user = gs_user then
		lb_find = true
	end if
end for

this.setrow(al_row)
this.scrolltorow(al_row)
if lb_find = true then
	messagebox('Modulo de Produccion','El usuario "'+space(2)+gs_user+'" ya firmó el Parte de Piso, ~r no necesita volver a hacerlo',StopSign!)
	this.event ue_delete()
	return
end if

// Del MAster

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		THIS.SetItem(al_row, ii_rk[li_x], la_id)
	NEXT
END IF


end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_und
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
						
	case "cod_usr"
		
		ls_codigo = this.object.cod_usr[row]

		SetNull(ls_data)
		select u.nombre
		  into :ls_data
		  from usuario u, aprob_parte_piso a
		 where u.cod_usr = a.aprobador
		   and u.cod_usr   = :ls_codigo
		   and u.flag_estado = '1';
		  
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Ususario no existe, no esta activo o no esta definifo como Usuario Firmador", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_usr	  			[row] = ls_codigo
			this.object.usuario_nombre		[row] = ls_codigo
			return 1
		end if
		this.object.aprobador			[row] = ls_codigo
		this.object.usuario_nombre		[row] = ls_data
end choose
		
end event

event dw_master::ue_insert;call super::ue_insert;string 		ls_nombre, ls_nro_parte
datetime   	ld_fecha_firma

ls_nro_parte = dw_detail.object.nro_parte [dw_detail.GetRow()]

IF dw_detail.object.flag_estado[dw_detail.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Parte de piso ya ha sido Anulado.~r~No puede hacerle modificaciones')
	dw_master.retrieve( ls_nro_parte)
	dw_master.of_protect( )
RETURN 1

END IF


ld_fecha_firma = f_fecha_actual()

//  Select nombre
//  into :ls_nombre
//  From Usuario
//  where cod_usr = :gs_user
//  And Usuario.flag_Estado = '1';

ls_nro_parte = dw_detail.object.nro_parte [dw_detail.GetRow()]

this.object.nro_parte		[this.GetRow()] 		= ls_nro_parte
//this.object.cod_usr			[this.GetRow()] 	= gs_user
this.object.fecha_firma		[this.GetRow()]		= ld_fecha_firma
//this.object.aprobador		[this.GetRow()] 		= gs_user
//this.object.usuario_nombre	[this.GetRow()] 	= ls_nombre

//is_action = 'new'
//
//this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

type dw_detail from u_dw_abc within w_pr314_firma_partes
integer x = 27
integer y = 776
integer width = 2834
integer height = 676
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pr_parte_piso_firma"
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1		   // columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
idw_det  =  				dw_detail
end event

event itemerror;call super::itemerror;return 1
end event

event dragdrop;call super::dragdrop;string 	 ls_nro_parte
			
long 		ll_row_cnt, ll_row_find, ll_row, ll_row_mas

if source = dw_partes then
	ll_row_cnt = dw_partes.GetRow()
	if ll_row_cnt = 0 then return
	
	ls_nro_parte = dw_partes.object.nro_parte[ll_row_cnt]
	st_mensaje.visible  = false
	st_mensaje2.visible = false

if ls_nro_parte = '' or IsNull(ls_nro_parte) then
	MessageBox('PRODUCCIÓN', 'NO SE HA DENIFIDO NUMERO DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
	return
else
	
		dw_detail.retrieve(ls_nro_parte)
		dw_master.retrieve( ls_nro_parte)

end if

end if
end event

event dragenter;call super::dragenter;if source = dw_partes then
	source.DragIcon = "H:\Source\ICO\row.ico"
end if
end event

type cb_1 from commandbutton within w_pr314_firma_partes
integer x = 261
integer y = 560
integer width = 274
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "buscar"
end type

event clicked;parent.event dynamic ue_retrieve_partes()
end event

type dw_partes from u_dw_abc within w_pr314_firma_partes
event dragleave pbm_dwndragleave
integer x = 805
integer y = 316
integer width = 2034
integer height = 432
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pr_partes_de_piso_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dragleave;call super::dragleave;if source = dw_partes then
	source.DragIcon = "Error!"
end if
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col 		= dw_partes.GetColumn()
ls_column 	= THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Parte: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

event clicked;call super::clicked;if this.RowCount() > 0 then
	This.Drag(Begin!)
else
	This.Drag(Cancel!)
end if
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

type st_campo from statictext within w_pr314_firma_partes
integer x = 805
integer y = 224
integer width = 1070
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "CAMPO:"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_pr314_firma_partes
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 1879
integer y = 228
integer width = 951
integer height = 72
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_partes.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_partes.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_partes.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg
ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_longitud
string 	ls_item, ls_ordenado_por, ls_comando
Long 		ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_partes.find(ls_comando, 1, dw_partes.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_partes.selectrow(0, false)
			dw_partes.selectrow(ll_fila,true)
			dw_partes.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type uo_fecha from u_ingreso_rango_fechas_v within w_pr314_firma_partes
event destroy ( )
integer x = 78
integer y = 296
integer width = 654
integer height = 212
integer taborder = 60
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type st_1 from statictext within w_pr314_firma_partes
integer x = 151
integer y = 216
integer width = 448
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
boolean focusrectangle = false
end type

type st_mensaje from statictext within w_pr314_firma_partes
integer x = 928
integer y = 1272
integer width = 1829
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Vista Previa del Parte de Piso"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_nro from statictext within w_pr314_firma_partes
integer x = 37
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Partes Firmado:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr314_firma_partes
integer x = 613
integer y = 56
integer width = 389
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_2 from commandbutton within w_pr314_firma_partes
integer x = 1042
integer y = 52
integer width = 402
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;string ls_nro_parte

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_nro_parte = Trim(sle_nro.text)

of_retrieve(ls_nro_parte)

end event

type st_mensaje2 from statictext within w_pr314_firma_partes
integer x = 73
integer y = 820
integer width = 786
integer height = 284
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione el Parte de Piso y arrástrelo Aqui Por favor"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_pr314_firma_partes
integer x = 32
integer y = 172
integer width = 750
integer height = 596
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type gb_2 from groupbox within w_pr314_firma_partes
integer x = 782
integer y = 172
integer width = 2089
integer height = 596
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

