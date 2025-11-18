$PBExportHeader$w_ve324_impresion_masiva.srw
forward
global type w_ve324_impresion_masiva from w_rpt
end type
type hpb_progreso from hprogressbar within w_ve324_impresion_masiva
end type
type cb_aceptar from commandbutton within w_ve324_impresion_masiva
end type
type cb_marcar_todo from commandbutton within w_ve324_impresion_masiva
end type
type cb_imprimir from commandbutton within w_ve324_impresion_masiva
end type
type dw_lista from u_dw_abc within w_ve324_impresion_masiva
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve324_impresion_masiva
end type
type cb_invertir from commandbutton within w_ve324_impresion_masiva
end type
type gb_1 from groupbox within w_ve324_impresion_masiva
end type
end forward

global type w_ve324_impresion_masiva from w_rpt
integer width = 3767
integer height = 2224
string title = "[VE324] Impresión Masiva de vouchers"
string menuname = "m_impresion"
event ue_print_voucher ( long al_row )
event ue_imprimir ( )
hpb_progreso hpb_progreso
cb_aceptar cb_aceptar
cb_marcar_todo cb_marcar_todo
cb_imprimir cb_imprimir
dw_lista dw_lista
uo_fechas uo_fechas
cb_invertir cb_invertir
gb_1 gb_1
end type
global w_ve324_impresion_masiva w_ve324_impresion_masiva

type variables
u_ds_base       ids_voucher
end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

event ue_print_voucher(long al_row);String 				ls_origen
Long   				ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros		lstr_param

if al_row = 0 then return

IF dw_lista.getrow() = 0 THEN Return


//Solicita si es impresión directa o previsualización
ls_origen 		= dw_lista.object.origen 	    	[al_row]
ll_ano			= dw_lista.object.ano	  	    	[al_row]
ll_mes			= dw_lista.object.mes	  	    	[al_row]
ll_nro_libro	= dw_lista.object.nro_libro   	[al_row]
ll_nro_asiento	= dw_lista.object.nro_asiento	 	[al_row]

ids_voucher.retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento, gs_empresa)

//Valido que el voucher tenga algun registro
if ids_voucher.rowcount() = 0 then 
	gnvo_app.of_mensaje_error('Voucher no tiene registro Verifique', 'FIN_304_02')
	return
end if

ids_voucher.Object.p_logo.filename = gs_logo

if ids_voucher.of_ExistsText("t_titulo1") then
	ids_voucher.object.t_titulo1.text = "Provisión de Cuentas x Cobrar"
	ids_voucher.object.t_titulo1.visible = '1'
end if	

ids_voucher.Print(True)


end event

event ue_imprimir();Long ll_rows, ll_i, ll_pos

ll_rows = 0
for ll_i = 1 to dw_lista.RowCount()
	if dw_lista.object.seleccion [ll_i] = '1' then
		ll_rows ++
	end if
	
next

if ll_rows = 0 then 
	MessageBox('Error', 'No ha seleccionado ningun registro para imprimir vouchers, por favor verifique!', StopSign!)
	return
end if

ll_pos = 0
for ll_i = 1 to dw_lista.RowCount()
	
	yield()
	if dw_lista.object.seleccion [ll_i] = '1' then
		ll_pos ++
		
		this.post event ue_print_voucher(ll_i)
		
		hpb_progreso.Position = ll_pos
		
	end if
	yield()
	
next

end event

public subroutine of_asigna_dws ();
end subroutine

on w_ve324_impresion_masiva.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.hpb_progreso=create hpb_progreso
this.cb_aceptar=create cb_aceptar
this.cb_marcar_todo=create cb_marcar_todo
this.cb_imprimir=create cb_imprimir
this.dw_lista=create dw_lista
this.uo_fechas=create uo_fechas
this.cb_invertir=create cb_invertir
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.cb_marcar_todo
this.Control[iCurrent+4]=this.cb_imprimir
this.Control[iCurrent+5]=this.dw_lista
this.Control[iCurrent+6]=this.uo_fechas
this.Control[iCurrent+7]=this.cb_invertir
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve324_impresion_masiva.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_progreso)
destroy(this.cb_aceptar)
destroy(this.cb_marcar_todo)
destroy(this.cb_imprimir)
destroy(this.dw_lista)
destroy(this.uo_fechas)
destroy(this.cb_invertir)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()


//** Datastore Voucher **//
ids_voucher = Create u_ds_base
ids_voucher.DataObject = 'd_rpt_voucher_imp_cc_tbl'
ids_voucher.SettransObject(sqlca)

dw_lista.SetTransObject(SQLCA)
end event

event ue_print;call super::ue_print;//idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

dw_lista.retrieve(ld_fecha1, ld_fecha2)

if dw_lista.RowCount() > 0 then
	cb_imprimir.enabled 		= true
	cb_marcar_todo.enabled 	= true
	cb_invertir.enabled		= true
else
	cb_imprimir.enabled 		= false
	cb_marcar_todo.enabled 	= false
	cb_invertir.enabled		= false
end if
end event

event resize;call super::resize;dw_lista.width = newwidth - dw_lista.x
dw_lista.height = newheight - dw_lista.y
end event

event close;call super::close;destroy ids_voucher
end event

event ue_filter_avanzado;//Overrride
dw_lista.EVENT ue_filter_avanzado()
end event

event ue_sort;//Override
dw_lista.EVENT ue_sort()
end event

event ue_filter;call super::ue_filter;//Override
dw_lista.EVENT ue_filter()
end event

type hpb_progreso from hprogressbar within w_ve324_impresion_masiva
integer x = 23
integer y = 124
integer width = 1285
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 1
end type

type cb_aceptar from commandbutton within w_ve324_impresion_masiva
integer x = 1381
integer width = 352
integer height = 196
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve( )
end event

type cb_marcar_todo from commandbutton within w_ve324_impresion_masiva
integer x = 1760
integer width = 485
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Selecionar todo"
end type

event clicked;Long ll_row

for ll_row = 1 to dw_lista.RowCount()
	dw_lista.object.seleccion [ll_row] = '1'
next
end event

type cb_imprimir from commandbutton within w_ve324_impresion_masiva
integer x = 2258
integer y = 8
integer width = 352
integer height = 196
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Imprimir"
end type

event clicked;parent.event ue_imprimir( )
end event

type dw_lista from u_dw_abc within w_ve324_impresion_masiva
integer y = 216
integer width = 3675
integer height = 1776
integer taborder = 90
string dataobject = "d_lista_comprobantes_venta_tbl"
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

event buttonclicked;call super::buttonclicked;if row = 0 then return

parent.event ue_print_voucher(row)
end event

type uo_fechas from u_ingreso_rango_fechas within w_ve324_impresion_masiva
event destroy ( )
integer x = 23
integer y = 44
integer height = 80
integer taborder = 80
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Del:','Al:') 								//	para setear la fecha inicial
of_set_fecha(date(relativedate(today(),-1)), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_invertir from commandbutton within w_ve324_impresion_masiva
integer x = 1760
integer y = 104
integer width = 485
integer height = 104
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Invertir seleccion"
end type

event clicked;Long ll_row

for ll_row = 1 to dw_lista.RowCount()
	if dw_lista.object.seleccion [ll_row] = '1' then
		dw_lista.object.seleccion [ll_row] = '0'
	else
		dw_lista.object.seleccion [ll_row] = '1'
	end if
next
end event

type gb_1 from groupbox within w_ve324_impresion_masiva
integer width = 1358
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas"
end type

