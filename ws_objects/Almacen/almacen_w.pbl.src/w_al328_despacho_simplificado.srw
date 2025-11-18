$PBExportHeader$w_al328_despacho_simplificado.srw
forward
global type w_al328_despacho_simplificado from w_abc_master_smpl
end type
type cb_buscar from commandbutton within w_al328_despacho_simplificado
end type
type uo_fechas from u_ingreso_rango_fechas within w_al328_despacho_simplificado
end type
type gb_2 from groupbox within w_al328_despacho_simplificado
end type
end forward

global type w_al328_despacho_simplificado from w_abc_master_smpl
integer width = 3493
integer height = 2572
string title = "[AL328] Despacho Simplificado"
string menuname = "m_mantenimiento_sl"
cb_buscar cb_buscar
uo_fechas uo_fechas
gb_2 gb_2
end type
global w_al328_despacho_simplificado w_al328_despacho_simplificado

on w_al328_despacho_simplificado.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.cb_buscar=create cb_buscar
this.uo_fechas=create uo_fechas
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_buscar
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.gb_2
end on

on w_al328_despacho_simplificado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_buscar)
destroy(this.uo_fechas)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;date 		ld_desde, ld_hasta

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ld_desde, ld_hasta)
end event

event ue_insert;//Override
Str_parametros		lstr_param
w_al329_despacho_simplificado_popup lw_1

OpenSheet (lw_1, w_main, 0, layered!)

if IsNull(Message.PowerObjectParm) or not isValid(Message.PowerObjectParm) then return

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return

this.event ue_retrieve( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_al328_despacho_simplificado
integer y = 196
integer width = 3346
integer height = 1932
string dataobject = "d_abc_despacho_simplificado_tbl"
end type

event dw_master::doubleclicked;call super::doubleclicked;str_parametros lstr_rep

if row = 0 then return



if lower(dwo.name) = 'nro_pallets' or lower(dwo.name) = 'total_cajas' then
	lstr_rep.titulo 	= 'Pallets por Movimiento de Almacen'
	lstr_rep.dw1 		= 'd_cns_pallet_vale_articulo_tbl'
	lstr_rep.string1 	= this.object.nro_vale	[row]
	lstr_rep.string2 	= this.object.cod_art	[row]
	lstr_rep.tipo		= '1S2S'
	
	OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end if
end event

event dw_master::constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

type cb_buscar from commandbutton within w_al328_despacho_simplificado
integer x = 1330
integer y = 48
integer width = 571
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_retrieve( )
end event

type uo_fechas from u_ingreso_rango_fechas within w_al328_despacho_simplificado
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 80
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type gb_2 from groupbox within w_al328_despacho_simplificado
integer width = 4320
integer height = 180
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Filtro Parte de Recepcion"
end type

