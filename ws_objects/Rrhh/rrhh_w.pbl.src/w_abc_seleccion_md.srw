$PBExportHeader$w_abc_seleccion_md.srw
$PBExportComments$Seleccion con master detalle
forward
global type w_abc_seleccion_md from w_abc_list
end type
type cb_transferir from commandbutton within w_abc_seleccion_md
end type
type dw_master from u_dw_abc within w_abc_seleccion_md
end type
type uo_search from n_cst_search within w_abc_seleccion_md
end type
end forward

global type w_abc_seleccion_md from w_abc_list
integer x = 539
integer y = 364
integer width = 4197
integer height = 2500
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_transferir cb_transferir
dw_master dw_master
uo_search uo_search
end type
global w_abc_seleccion_md w_abc_seleccion_md

type variables
String is_col = '', is_tipo
integer ii_ik[]
str_parametros ist_datos
Boolean ib_sel = false
Datastore ids_art_a_vender
end variables

forward prototypes
public function integer of_opcion1 ()
end prototypes

public function integer of_opcion1 ();Long 		ll_count, ll_row
u_dw_abc ldw_1

ldw_1 = ist_datos.dw_m

ll_count = dw_2.Rowcount()
IF ll_count > 1 THEN
	Messagebox('Aviso','Solamente Debe Seleccionar Un Concepto Financiero', StopSign!)
	Return 0
end if

ll_row = ldw_1.GetRow()
IF ll_row = 0 THEN RETURN 0
ldw_1.object.confin 		  [ll_row] = dw_2.Object.confin		  [1]

if ldw_1.of_Existecampo( "desc_confin") then
	ldw_1.object.desc_confin [ll_row] = dw_2.Object.descripcion [1]
end if

if ldw_1.of_Existecampo( "matriz_cntbl") then
	ldw_1.object.matriz_cntbl [ll_row] = dw_2.Object.matriz_cntbl [1]
end if

ist_datos.titulo = 's'

return 1
end function

on w_abc_seleccion_md.create
int iCurrent
call super::create
this.cb_transferir=create cb_transferir
this.dw_master=create dw_master
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_transferir
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.uo_search
end on

on w_abc_seleccion_md.destroy
call super::destroy
destroy(this.cb_transferir)
destroy(this.dw_master)
destroy(this.uo_search)
end on

event ue_open_pre;Long ll_row

ii_access = 1   // sin menu

if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if
// Recoge parametro enviado
is_tipo 					= ist_datos.tipo
dw_master.DataObject = ist_datos.dw_master
dw_1.DataObject 		= ist_datos.dw1
dw_2.DataObject 		= ist_datos.dw1

//**DataStore de Artciuclos Por Orden de Venta**//
ids_art_a_vender            = Create DataStore
ids_art_a_vender.DataObject = 'd_tt_fin_art_a_vender_tbl'
ids_art_a_vender.Settransobject(sqlca)
//****//

dw_master.SetTransObject(SQLCA)
dw_1.SetTransObject		(SQLCA)
dw_2.SetTransObject		(SQLCA)	

IF TRIM( is_tipo) = '' THEN 	// Si tipo no es indicado, hace un retrieve
	ll_row = dw_master.retrieve()
ELSE		// caso contrario hace un retrieve con parametros
	CHOOSE CASE is_tipo
		CASE 'ARRAY'
			ll_row = dw_master.Retrieve(ist_datos.str_array)
		CASE '1S'
			ll_row = dw_master.Retrieve(ist_datos.string1)
		CASE '2S'
			ll_row = dw_master.Retrieve(ist_datos.string1, ist_datos.string2)
	END CHOOSE
END IF
	
This.Title = ist_datos.titulo

uo_search.of_set_dw(dw_master)

if dw_master.RowCount() > 0 then
	dw_master.SetRow(1)
	dw_master.selectrow( 0, false)
	dw_master.selectrow( 1, true)
	
	if dw_1.RowCount() > 0 then
		dw_1.SetRow(1)
		dw_1.selectrow( 0, false)
		dw_1.selectrow( 1, true)
	end if
end if

end event

event open;//override
THIS.EVENT ue_open_pre()

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

pb_1.x = newwidth / 2 - pb_1.width/2
pb_2.x = newwidth / 2 - pb_2.width/2

//dw_master.width  = newwidth  - dw_master.x - 10

dw_1.height = newheight - dw_1.y - 10
dw_1.width  = newwidth/2 - pb_1.width/2 - 10

dw_2.height = newheight - dw_2.y - 10
dw_2.x  = newwidth/2 + pb_1.width/2 + 10
dw_2.width  = newwidth  - dw_2.x - 10

cb_transferir.x = newWidth - cb_transferir.width - 10

uo_search.width 	= cb_transferir.x - uo_Search.x - 10
uo_search.event ue_resize(sizetype, newwidth, newheight)


end event

type dw_1 from w_abc_list`dw_1 within w_abc_seleccion_md
integer x = 0
integer y = 928
integer width = 1362
integer height = 808
end type

event dw_1::constructor;call super::constructor;// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if


is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw

ii_ss = 0
end event

event dw_1::getfocus;call super::getfocus;uo_search.SetFocus()
end event

event dw_1::rowfocuschanged;call super::rowfocuschanged;//f_Select_current_row(this)
end event

event dw_1::ue_selected_row_pro;Long	  ll_row, ll_rc, ll_count
Any	  la_id
Integer li_x


ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)


Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type dw_2 from w_abc_list`dw_2 within w_abc_seleccion_md
integer x = 1573
integer y = 928
integer width = 1362
integer height = 808
integer taborder = 60
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
CHOOSE CASE ist_datos.opcion 
		 CASE 1 //Guias de Remision
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_rk[4] = 4
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				ii_dk[4] = 4
				
		CASE 2,3,4,5,8 //Concepto Financiero
				ii_rk[1] = 1				// Deploy key
				ii_rk[2] = 2				
				ii_rk[3] = 3				// Deploy key
				ii_dk[1] = 1				// Receive key
				ii_dk[2] = 2				// Receive key
				ii_dk[3] = 3				
				
		
		CASE	9							  //Articulo Movimiento Proyectado	
				ii_rk[1]  = 1				// Deploy key
				ii_rk[2]  = 2				
				ii_rk[3]  = 3				
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6			
				ii_rk[7]  = 7
				ii_rk[8]  = 8				
				ii_rk[9]  = 9				
				ii_rk[10] = 10
				ii_rk[11] = 11
				ii_rk[12] = 12
				
				ii_dk[1]  = 1				
				ii_dk[2]  = 2				
				ii_dk[3]  = 3				
				ii_dk[4]  = 4								
				ii_dk[5]  = 5				
				ii_dk[6]  = 6			
				ii_dk[7]  = 7
				ii_dk[8]  = 8				
				ii_dk[9]  = 9				
				ii_dk[10] = 10
				ii_dk[11] = 11
				ii_dk[12] = 12
				
		CASE	10							  //Articulo Movimiento Proyectado
											  //x Orden de Compra
				
				ii_rk[1]  = 1				
				ii_rk[2]  = 2				
				ii_rk[3]  = 3
				ii_rk[4]  = 4
				ii_rk[5]  = 5				
				ii_rk[6]  = 6								
				ii_rk[7]  = 7
				ii_rk[8]  = 8
				ii_rk[9]  = 9			
				ii_rk[10]  = 10
				
				
	   		ii_dk[1]  = 1			  //cod art
				ii_dk[2]  = 2			  //nom articulo
				ii_dk[3]  = 3			  //descuento	
				ii_dk[4]  = 4			  //impuesto
				ii_dk[5]  = 5			  //cod moneda
				ii_dk[6]  = 6			  //precio unit
				ii_dk[7]  = 7			  //cant_pendiente
				ii_dk[8]  = 8			  //cencos	
				ii_dk[9]  = 9			  //cnta prsp
				ii_dk[10]  = 10		  //centro beneficio
				
		CASE 	11								//Orden de Servicio Detalle (Cuentas x Pagar)			

				ii_rk[1]   = 1   //COD_ORIGEN
				ii_rk[2]   = 2   //NRO_OS
				ii_rk[3]   = 3   //NRO_ITEM
				ii_rk[4]   = 4   //FLAG_ESTADO
				ii_rk[5]   = 5   //FEC_REGISTRO
				ii_rk[6]   = 6   //FEC_PROYECT
				ii_rk[7]   = 7   //DESCRIPCION
				ii_rk[8]   = 8   //IMPORTE   
				ii_rk[9]   = 9   //IMPUESTO 
				ii_rk[10]  = 10 //descuento
				ii_rk[11]  = 11 //CENCOS
				ii_rk[12]  = 12 //COD_SUB_CAT
				ii_rk[13]  = 13 //CNTA_PRSP
				ii_rk[14]  = 14 //OPER_SEC		
				ii_rk[15]  = 15 //CENTRO BENEF
				
				ii_dk[1]   = 1  //COD_ORIGEN
				ii_dk[2]   = 2  //NRO_OS
				ii_dk[3]   = 3  //NRO_ITEM
				ii_dk[4]   = 4  //FLAG_ESTADO
				ii_dk[5]   = 5  //FEC_REGISTRO
				ii_dk[6]   = 6  //FEC_PROYECT
				ii_dk[7]   = 7  //DESCRIPCION
				ii_dk[8]   = 8  //IMPORTE   
				ii_dk[9]   = 9  //IMPUESTO 
				ii_dk[10]  = 10 //descuento
				ii_dk[11]  = 11 //CENCOS
				ii_dk[12]  = 12 //COD_SUB_CAT
				ii_dk[13]  = 13 //CNTA_PRSP
				ii_dk[14]  = 14 //OPER_SEC				
				ii_dk[15]  = 15 //CENTRO BENEF
				
		 CASE 12    // Embarque
				ii_dk[1] = 1				// 
				ii_dk[2] = 2				// 
				ii_dk[3] = 3				// 
				ii_dk[4] = 4				// 
				ii_dk[5] = 5				// 
				ii_dk[6] = 6				// 
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				
	 	 CASE 13    // Deuda Financiera
            ii_dk[1] = 1 // NRO_CUOTA
				ii_dk[2] = 2 // TIPO_DEUDA_CONCEPTO
				ii_dk[3] = 3 // DESCRIPCION
				ii_dk[4] = 4 // TIPO_DOC_REF
				ii_dk[5] = 5 // NRO_DOC_REF
				ii_dk[6] = 6 // MONTO_PROY
				ii_dk[7] = 7 // FEC_VCTO_PROY
				ii_dk[8] = 8 // FLAG_ESTADO
				ii_dk[9] = 9 // NRO REGISTRO
				ii_dk[10] = 10 // CENCOS
				ii_dk[11] = 11 // CNTA PRSP
				
				ii_rk[1] = 1				
				ii_rk[2] = 2				
				ii_rk[3] = 3				
				ii_rk[4] = 4							
				ii_rk[5] = 5
				ii_rk[6] = 6					
				ii_rk[7] = 7
				ii_rk[8] = 8				
				ii_rk[9] = 9 // NRO REGISTRO
				ii_rk[10] = 10 // CENCOS
				ii_rk[11] = 11 // CNTA PRSP
		
		CASE 14  // Guia de Recepción de Materia Prima
				ii_dk[1] = 1
				ii_dk[2] = 2
				ii_dk[3] = 3
				ii_dk[4] = 4
				ii_dk[5] = 5
				ii_dk[6] = 6
				ii_dk[7] = 7
				ii_dk[8] = 8
				ii_dk[9] = 9
				ii_dk[11] = 11
			  
			   ii_rk[1] = 1
				ii_rk[2] = 2
				ii_rk[3] = 3
				ii_rk[4] = 4
				ii_rk[5] = 5
				ii_rk[6] = 6
				ii_rk[7] = 7
				ii_rk[8] = 8
				ii_rk[9] = 9
				ii_rk[10] = 10
				ii_rk[11] = 11
END CHOOSE
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

type pb_1 from w_abc_list`pb_1 within w_abc_seleccion_md
integer x = 1399
integer y = 1160
integer taborder = 40
string text = ">"
alignment htextalign = center!
end type

type pb_2 from w_abc_list`pb_2 within w_abc_seleccion_md
integer x = 1390
integer y = 1348
integer taborder = 50
alignment htextalign = center!
end type

type cb_transferir from commandbutton within w_abc_seleccion_md
integer x = 2939
integer y = 12
integer width = 338
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Transferir"
end type

event clicked;// Transfiere campos 

CHOOSE CASE ist_datos.opcion
	CASE  1 // Conceptos Financieros
	
		IF of_opcion1() = 1 THEN
			ist_datos.titulo = 's'
		ELSE
			RETURN
		END IF
		
			
END CHOOSE
CloseWithReturn( parent, ist_datos)


end event

type dw_master from u_dw_abc within w_abc_seleccion_md
integer y = 116
integer width = 2894
integer height = 796
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular'  	// tabular(default), form
ii_ss = 1

end event

event ue_output;call super::ue_output;// Muestra detalle
if al_row = 0 then return

CHOOSE CASE ist_datos.opcion 
	CASE 1
		dw_1.Retrieve(this.object.grupo[al_row], ist_datos.str_array)
END CHOOSE
	

end event

type uo_search from n_cst_search within w_abc_seleccion_md
event destroy ( )
integer y = 12
integer taborder = 30
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

