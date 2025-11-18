$PBExportHeader$w_abc_seleccion.srw
forward
global type w_abc_seleccion from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion
end type
type uo_search from n_cst_search within w_abc_seleccion
end type
end forward

global type w_abc_seleccion from w_abc_list
integer width = 3717
integer height = 2144
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
uo_search uo_search
end type
global w_abc_seleccion w_abc_seleccion

type variables
String  	is_col = '', is_tipo, is_type, is_soles, is_tipo_alm, &
			is_oper_cons_int, is_almacen, is_opcion
Date 		id_fecha
Double 	in_tipo_cambio
Long		il_opcion
str_parametros 			ist_datos

end variables

forward prototypes
public function boolean of_opcion1 ()
end prototypes

public function boolean of_opcion1 ();// Solo para consumos internos 
Long   	ll_j
String 	ls_codtra

delete tt_proveedor;

FOR ll_j = 1 TO dw_2.RowCount()								
	
	ls_codtra = dw_2.object.cod_trabajador [ll_j]
	
	insert into tt_proveedor(proveedor)
	values(:ls_codtra);
	
	commit;
	
NEXT				
return true

end function

on w_abc_seleccion.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.uo_search
end on

on w_abc_seleccion.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.uo_search)
end on

event ue_open_pre;call super::ue_open_pre;Long 		ll_row
string 	ls_articulo, ls_datawindow
date		ld_fecha
u_dw_abc	ldw_master

ii_access = 1   // sin menu

// Recoge parametro enviado
if ISNULL( Message.PowerObjectParm ) or NOT IsValid(Message.PowerObjectParm) THEN
	MessageBox('Aviso', 'Parametros enviados estan en blanco', StopSign!)
	return
end if

If Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Aviso', 'Parametros enviados no son del Tipo str_parametros', StopSign!)
	return
end if

is_tipo = ist_datos.tipo
il_opcion = ist_datos.opcion
ls_datawindow = ist_datos.dw1

dw_1.DataObject = ls_datawindow
dw_2.DataObject = ls_datawindow
dw_1.SetTransObject( SQLCA)
dw_2.SetTransObject( SQLCA)	

uo_search.of_set_dw( dw_1 )

IF TRIM(is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
		ll_row = dw_1.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE '1S'
			ll_row = dw_1.Retrieve(ist_datos.string1)
		CASE '2S', '1S2S'				
			ll_row = dw_1.Retrieve(ist_datos.string1, ist_datos.string2)
		CASE '2S_V2'	// Salida x Consumo Interno
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( ist_datos.string1, ist_datos.fecha1, is_almacen, &
					 ist_datos.tipo_doc, ist_datos.nro_doc)
		CASE '2S_V3'	// Ingreso por produccion			
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen, ist_datos.tipo_doc, ist_datos.nro_doc)

		CASE 'CONSIG'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ld_fecha    = ist_datos.fecha1
			ll_row = dw_1.Retrieve( ist_datos.string1, ld_fecha, is_almacen)
			
		CASE 'CONSIG_2'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			ls_articulo = ldw_master.object.cod_art[ll_row]
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen, ls_articulo )
			
		CASE 'CONSIG_3'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )
			
		CASE 'DEVOL'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )
			
		CASE 'PRESTAMOS'
			ldw_master = ist_datos.dw_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( is_almacen )

		CASE 'DEVOL_ALMACEN'				
			ldw_master = ist_datos.dw_or_m
			ll_row = ldw_master.GetRow()
			if ll_row = 0 then return
			
			is_almacen  = ldw_master.object.almacen[ll_row]
			ll_row = dw_1.Retrieve( ist_datos.oper_cons_interno, ist_datos.fecha1, &
						is_almacen, ist_datos.tipo_doc, ist_datos.nro_doc)
			
	END CHOOSE
END IF

This.Title = ist_datos.titulo
is_col = dw_1.Describe("#1" + ".name")



end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()

end event

event resize;call super::resize;dw_1.height 		= newheight - dw_1.y - 10
dw_1.width			= newwidth/2 - dw_1.x - pb_1.width/2 - 20

dw_2.x				= newwidth/2 + pb_1.width/2 + 20
dw_2.height 		= newheight - dw_2.y - 10
dw_2.width   		= newwidth  - dw_2.x - 10

pb_1.x				= newwidth/2 - pb_1.width/2
pb_2.x				= newwidth/2 - pb_2.width/2

cb_Transferir.x	= newwidth - cb_Transferir.width - 10


uo_search.width 	= cb_Transferir.x - uo_search.x - 10
uo_search.event ue_resize( sizetype, uo_search.width, newheight)
end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion
event type integer ue_selected_row_now ( long al_row )
integer x = 0
integer y = 128
integer width = 1362
end type

event dw_1::constructor;call super::constructor;if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0

end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Any			la_id
Integer		li_x
Long			ll_rc, ll_row, ll_count


ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT


idw_det.ScrollToRow(ll_row)

return 
end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion
integer x = 1563
integer y = 132
integer width = 1362
integer taborder = 50
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw

end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Any			la_id
Integer		li_x
Long			ll_rc, ll_row, ll_count


ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT


idw_det.ScrollToRow(ll_row)

return 
end event

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion
integer x = 1390
integer y = 428
integer taborder = 30
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion
integer x = 1394
integer y = 576
integer taborder = 40
end type

type cb_transferir from commandbutton within w_abc_seleccion
integer x = 3287
integer y = 8
integer width = 338
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 
CHOOSE CASE ist_datos.opcion
		
	CASE 1 // Seleccion de trabajadores
		if of_opcion1() then 
			ist_datos.titulo = 's'
		else
			return
		end if

		
END CHOOSE
CloseWithReturn( parent, ist_datos)
end event

type uo_search from n_cst_search within w_abc_seleccion
event destroy ( )
integer y = 8
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

