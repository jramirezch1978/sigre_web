$PBExportHeader$w_abc_seleccion_lista_search.srw
forward
global type w_abc_seleccion_lista_search from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_lista_search
end type
type uo_search from n_cst_search within w_abc_seleccion_lista_search
end type
end forward

global type w_abc_seleccion_lista_search from w_abc_list
integer x = 50
integer width = 3758
integer height = 2144
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion_lista_search w_abc_seleccion_lista_search

type variables
str_parametros istr_param

end variables

forward prototypes
public function boolean of_opcion1 ()
public function boolean of_opcion2 ()
end prototypes

public function boolean of_opcion1 ();Long 		ll_inicio
String	ls_codigo
date ld_fechaingreso

if dw_2.RowCount() = 0 then
	MessageBox('Error', 'Debe Seleccionar un articulo por lo menos. Por favor verifique!', StopSign!)
	return false
end if

delete tt_art;

if gnvo_app.of_existsError(SQLCA) then
	rollback;
	return false;
end if	


FOR ll_inicio = 1 TO dw_2.Rowcount()
	yield()
	ls_codigo = dw_2.Object.cod_art [ll_inicio]	 
	ld_fechaingreso = date(dw_2.Object.vale_mov_fec_registro [ll_inicio])	 
	//Inserción de Proveedores
	Insert Into tt_art (cod_art, fecha_ingreso)  
	VALUES (:ls_codigo, :ld_fechaingreso);
	
	if gnvo_app.of_existsError(SQLCA) then
		rollback;
		return false;
	end if	

	this.setmicrohelp(string(ll_inicio) + ' / ' + string(dw_2.RowCount()))
	
	yield()
NEXT	

return true
end function

public function boolean of_opcion2 ();Long 		ll_inicio
String	ls_codigo, ls_cu
integer ln_cantidad
date ld_fechaingreso

if dw_2.RowCount() = 0 then
	MessageBox('Error', 'Debe Seleccionar un articulo por lo menos. Por favor verifique!', StopSign!)
	return false
end if

delete tt_art;

if gnvo_app.of_existsError(SQLCA) then
	rollback;
	return false;
end if	


FOR ll_inicio = 1 TO dw_2.Rowcount()
	yield()
	
	ls_codigo = dw_2.Object.cod_art 	[ll_inicio]	 
	ls_cu   =  dw_2.Object.cus 			[ll_inicio]	 
	ln_cantidad   =  dw_2.Object.saldo 			[ll_inicio]	 
	//ld_fechaingreso = date(dw_2.Object.vale_mov_fec_registro [ll_inicio])	 
	
	//Inserción de Proveedores
	Insert Into tt_art (cod_art, cu, fecha_ingreso, cantidad)  
	VALUES (:ls_codigo,:ls_cu, :ld_fechaingreso, :ln_cantidad);
	
	if gnvo_app.of_existsError(SQLCA) then
		rollback;
		return false;
	end if	

	this.setmicrohelp(string(ll_inicio) + ' / ' + string(dw_2.RowCount()))
	
	yield()
NEXT	

return true
end function

on w_abc_seleccion_lista_search.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion_lista_search.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
end on

event ue_open_pre;// Overr
String ls_null
Long   ll_row

// Recoge parametro enviado

This.Title = istr_param.titulo
dw_1.DataObject = istr_param.dw1
dw_2.Dataobject = istr_param.dw1

dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)

uo_search.of_set_dw(dw_1)

//Inicializar Variable de Busqueda //

IF Trim(istr_param.tipo) = '' OR Isnull(istr_param.tipo) THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE istr_param.tipo
		CASE '1S'
			ll_row = dw_1.Retrieve( istr_param.string1 )
		CASE '1L'
			ll_row = dw_1.Retrieve( istr_param.long1 )
			
		CASE '1NVP' //Nota de Ventas Por Pagar
			dw_1.Retrieve(istr_param.string2) 
		CASE '1AJCP' //Ajuste x Cantidad y/o precio de nc,nd x cobrar
			dw_1.Retrieve(istr_param.string2) 
		CASE	'1RNDC' //Por Reversion de Doc. de Nota de Credito		
			dw_1.Retrieve(istr_param.string2) 
		CASE	'1INDC' //Por Interes de Fac, Bol , Let x Cobrar
			dw_1.Retrieve(istr_param.string2) 						
		CASE	'1DNCC' //Por Descuento por Pronto Pago
			dw_1.Retrieve(istr_param.string2)
		CASE	'1GR'	  //Guias de Remision sin Orden de Venta
			dw_1.Retrieve(istr_param.string2)
		CASE	'1PED'  //Comprobante de Egreso
			dw_1.Retrieve(istr_param.string3)
		CASE	'1CHC'  //Cheques a Conciliar
			dw_1.Retrieve(istr_param.string2)	
		CASE	'1DCC'  //Documentos a Conciliar		
			dw_1.Retrieve(istr_param.string2)	
		CASE	'1NVP'  //nota debito credito x pagar
			dw_1.Retrieve(istr_param.string4)	
						
	END CHOOSE
END IF



end event

event open;//override
THIS.EVENT ue_open_pre()
end event

event resize;call super::resize;//Posiciones 
dw_1.width = newwidth /2 - pb_1.width /2 - 10
dw_1.height = newheight - dw_1.y - 10

pb_1.x 	  = dw_1.width + 10
pb_2.x 	  = pb_1.x

dw_2.x 	  = pb_1.x + pb_1.width + 10

dw_2.width = dw_1.width
dw_2.height = dw_1.height

cb_transferir.x	= newwidth - cb_transferir.width - 10

uo_Search.width 	= cb_transferir.x - uo_Search.x - 10
uo_Search.event ue_resize(sizetype, cb_transferir.x - 10 - uo_Search.x, newheight)
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_lista_search
integer x = 0
integer y = 116
integer width = 517
end type

event dw_1::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	istr_param = MESSAGE.POWEROBJECTPARM	
end if

ii_ss 	  = 0
is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form
idw_det  = dw_2 				// dw_detail 

ii_ck[1] = 1         // columnas de lectrua de este dw


end event

event dw_1::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long 		ll_row, ll_count, ll_rc
integer 	li_x
Any 		la_id

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

// Asigna datos
idw_det.ScrollToRow(ll_row)

//return ll_row


end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::getfocus;call super::getfocus;dw_1.SetFocus()
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_lista_search
integer x = 690
integer y = 116
integer width = 517
end type

event dw_2::constructor;call super::constructor;ii_ss 	  = 0
ii_ck[1] = 1

end event

event dw_2::ue_selected_row_pos();call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_lista_search
integer x = 530
integer y = 436
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_lista_search
integer x = 530
integer y = 684
end type

type cb_transferir from commandbutton within w_abc_seleccion_lista_search
integer x = 1472
integer width = 297
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;
CHOOSE CASE istr_param.opcion
	CASE 1 //Programa de Pagos
		if not of_opcion1() then return
	CASE 2 //Programa de Pagos
		if not of_opcion2() then return
			
	
		
END CHOOSE

istr_param.b_return = true

Closewithreturn(parent,istr_param)
end event

type uo_search from n_cst_search within w_abc_seleccion_lista_search
event destroy ( )
integer width = 1458
integer taborder = 20
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

