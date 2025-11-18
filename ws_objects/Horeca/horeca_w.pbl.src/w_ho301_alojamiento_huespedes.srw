$PBExportHeader$w_ho301_alojamiento_huespedes.srw
forward
global type w_ho301_alojamiento_huespedes from w_abc_master_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_ho301_alojamiento_huespedes
end type
type cb_1 from commandbutton within w_ho301_alojamiento_huespedes
end type
type gb_1 from groupbox within w_ho301_alojamiento_huespedes
end type
end forward

global type w_ho301_alojamiento_huespedes from w_abc_master_smpl
integer width = 3255
integer height = 2384
string title = "[HO301] Alojamiento de Huespedes y Servicios"
string menuname = "m_mto_smpl"
uo_1 uo_1
cb_1 cb_1
gb_1 gb_1
end type
global w_ho301_alojamiento_huespedes w_ho301_alojamiento_huespedes

on w_ho301_alojamiento_huespedes.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.uo_1=create uo_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.gb_1
end on

on w_ho301_alojamiento_huespedes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;dw_master.Retrieve()

end event

type dw_master from w_abc_master_smpl`dw_master within w_ho301_alojamiento_huespedes
integer y = 356
integer width = 2706
integer height = 1460
string dataobject = "d_lista_registros_alojamiento_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen 		[al_row] = gs_origen
this.object.flag_estado 	[al_row] = '1'
this.object.imp_hospedaje 	[al_row] = 0.00
end event

event dw_master::constructor;call super::constructor;//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type uo_1 from u_ingreso_rango_fechas within w_ho301_alojamiento_huespedes
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 70
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_hoy

ld_hoy = DAte(gnvo_app.of_fecha_actual( ))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_hoy, ld_hoy) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_1 from commandbutton within w_ho301_alojamiento_huespedes
integer x = 14
integer y = 168
integer width = 1285
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_refresh( )
end event

type gb_1 from groupbox within w_ho301_alojamiento_huespedes
integer width = 2725
integer height = 340
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

