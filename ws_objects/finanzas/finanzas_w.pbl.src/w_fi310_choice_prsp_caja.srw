$PBExportHeader$w_fi310_choice_prsp_caja.srw
forward
global type w_fi310_choice_prsp_caja from w_abc
end type
type dw_tv from u_dw_abc within w_fi310_choice_prsp_caja
end type
type cb_1 from commandbutton within w_fi310_choice_prsp_caja
end type
type st_1 from statictext within w_fi310_choice_prsp_caja
end type
type dw_detail from u_dw_abc within w_fi310_choice_prsp_caja
end type
type dw_listado from u_dw_abc within w_fi310_choice_prsp_caja
end type
end forward

global type w_fi310_choice_prsp_caja from w_abc
integer width = 4457
integer height = 1968
string title = "[FI310] Elegir Presupuesto de caja"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_tv dw_tv
cb_1 cb_1
st_1 st_1
dw_detail dw_detail
dw_listado dw_listado
end type
global w_fi310_choice_prsp_caja w_fi310_choice_prsp_caja

type variables
u_dw_abc		idw_master, idw_detail
String		is_flag_ing_egr
Long			il_semana
end variables

forward prototypes
public subroutine of_refresh_tv (string as_nro_prsp)
end prototypes

public subroutine of_refresh_tv (string as_nro_prsp);
end subroutine

on w_fi310_choice_prsp_caja.create
int iCurrent
call super::create
this.dw_tv=create dw_tv
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_detail=create dw_detail
this.dw_listado=create dw_listado
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_tv
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_listado
end on

on w_fi310_choice_prsp_caja.destroy
call super::destroy
destroy(this.dw_tv)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.dw_listado)
end on

event ue_open_pre;call super::ue_open_pre;Integer				li_year
str_parametros 	lstr_param


lstr_param = Message.powerobjectparm

is_flag_ing_egr = lstr_param.string1
il_semana		 = lstr_param.long1
idw_master		 = lstr_param.dw_m
idw_detail		 = lstr_param.dw_d

if idw_master.GetRow() = 0 then
	MessageBox('Error', 'No ha especificado ninguna cabecera del voucher de pago', StopSign!)
	return
end if

li_year = Year(Date(idw_master.object.fecha_emision [idw_master.GetRow()]))

dw_listado.setTransObject(SQLCA)

dw_listado.Retrieve(il_semana, li_year)
end event

event close;call super::close;str_parametros lstr_param
lstr_param.i_return = 0

CloseWithReturn(this, lstr_param)
end event

event resize;call super::resize;dw_tv.height = newheight - dw_tv.y - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

st_1.width  = newwidth  - st_1.x - 10

//dw_master.width  = newwidth  - dw_master.x - 10
//
end event

type dw_tv from u_dw_abc within w_fi310_choice_prsp_caja
integer y = 636
integer width = 2171
integer height = 1056
string dataobject = "d_list_prsp_caja_tv"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_output;call super::ue_output;String	ls_cod_detalle, ls_cencos, ls_nro_presupuesto

ls_nro_presupuesto = this.Object.nro_presupuesto 	[al_row]
ls_cod_detalle		 = this.object.cod_detalle 		[al_row]
ls_cencos			 = this.object.cencos				[al_row]

dw_detail.Retrieve(ls_nro_presupuesto, ls_cod_detalle, ls_cencos)

if dw_detail.RowCount( ) > 0 then
	dw_detail.SelectRow(0, false)
	dw_detail.SelectRow(1, true)
	dw_detail.setRow(1)	
end if
end event

type cb_1 from commandbutton within w_fi310_choice_prsp_caja
integer x = 3191
integer y = 80
integer width = 535
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Integer 	li_Semana, li_select, li_row, li_count
String	ls_nro_presupuesto
str_parametros lstr_param

if dw_detail.RowCount() = 0 then 
	MessageBox('Error', 'No hay datos para seleccionar en el detalle, por favor verifique!')
	return
end if

li_select = 0
for li_row = 1 to dw_detail.RowCount()
	if dw_detail.isSelected( li_row ) = true then
		li_select = li_row
		exit 
	end if
next

if li_select = 0 then 
	MessageBox('Error', 'No existe fila seleccionada, por favor verifique!')
	return
end if


li_semana 	= Integer(dw_listado.Object.semana 	[dw_listado.getRow()])

idw_detail.object.nro_prsp 		[idw_detail.getRow()] = dw_detail.object.nro_presupuesto [li_select]
idw_detail.object.item_prsp 		[idw_detail.getRow()] = dw_detail.object.nro_item 			[li_select]
idw_detail.object.semana 			[idw_detail.getRow()] = il_semana
idw_detail.object.moneda_psrsp 	[idw_detail.getRow()] = dw_detail.object.cod_moneda 		[li_select]
idw_detail.object.imp_proyectado [idw_detail.getRow()] = dw_detail.object.imp_proyectado 	[li_select]

//Ahora valido cuantos items en el voucher detalle existen para que sugiera rellenarlos
li_count = 0
for li_row = 1 to idw_detail.RowCount()
	ls_nro_presupuesto = idw_detail.object.nro_prsp [li_row] 
	if IsNull(ls_nro_presupuesto) or ls_nro_presupuesto = "" then
		li_count ++
	end if
next

if li_count > 0 then
	if MessageBox('Aviso', 'Existen ' + trim(string(li_count)) &
		+ ' registros en el voucher de Tesorería que no tienen presupuesto de Caja, ¿desea copiar este item del presupuesto de Caja a los demás item que lo tienen en Blanco?', &
		Information!, YesNo!, 2) = 1 then

		for li_row = 1 to idw_detail.RowCount()
			ls_nro_presupuesto = idw_detail.object.nro_prsp [li_row] 
			if IsNull(ls_nro_presupuesto) or ls_nro_presupuesto = "" then
				idw_detail.object.nro_prsp 		[li_row] = dw_detail.object.nro_presupuesto [li_select]
				idw_detail.object.item_prsp 		[li_row] = dw_detail.object.nro_item 			[li_select]
				idw_detail.object.semana 			[li_row] = il_semana
				idw_detail.object.moneda_psrsp 	[li_row] = dw_detail.object.cod_moneda 		[li_select]
				idw_detail.object.imp_proyectado [li_row] = dw_detail.object.imp_proyectado 	[li_select]
			end if
		next
	end if
end if

lstr_param.i_return = 1
CloseWithReturn(parent, lstr_param)

end event

type st_1 from statictext within w_fi310_choice_prsp_caja
integer width = 3717
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Listado de Presupuestos Activos"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_fi310_choice_prsp_caja
integer x = 2185
integer y = 204
integer width = 1541
integer height = 1472
integer taborder = 20
string dataobject = "d_list_prsp_caja_det_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type dw_listado from u_dw_abc within w_fi310_choice_prsp_caja
integer y = 80
integer width = 2171
integer height = 536
string dataobject = "d_list_prsp_caja_activos_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_output;call super::ue_output;String	ls_nro_prsp

ls_nro_prsp 	= this.object.nro_presupuesto[al_row]

dw_tv.Retrieve(ls_nro_prsp, is_flag_ing_egr)
dw_detail.Reset()
end event

