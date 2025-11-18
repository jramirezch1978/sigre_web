$PBExportHeader$w_ap320_datos_calidad.srw
forward
global type w_ap320_datos_calidad from w_abc_master_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap320_datos_calidad
end type
type cb_refresh from commandbutton within w_ap320_datos_calidad
end type
type gb_1 from groupbox within w_ap320_datos_calidad
end type
end forward

global type w_ap320_datos_calidad from w_abc_master_smpl
integer width = 2789
integer height = 2000
string title = "[AP320] Asignar datos de calidad - Liberacion"
string menuname = "m_mantto_tablas"
uo_fecha uo_fecha
cb_refresh cb_refresh
gb_1 gb_1
end type
global w_ap320_datos_calidad w_ap320_datos_calidad

on w_ap320_datos_calidad.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_tablas" then this.MenuID = create m_mantto_tablas
this.uo_fecha=create uo_fecha
this.cb_refresh=create cb_refresh
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_refresh
this.Control[iCurrent+3]=this.gb_1
end on

on w_ap320_datos_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_refresh)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_refresh;call super::ue_refresh;Date 	ld_fecha1, ld_fecha2
ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

dw_master.retrieve( ld_fecha1, ld_fecha2 )
end event

type dw_master from w_abc_master_smpl`dw_master within w_ap320_datos_calidad
integer y = 176
integer width = 2715
integer height = 1628
string dataobject = "d_abc_calidad_descarga_det_tbl"
end type

event dw_master::constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_moneda"

		ls_sql = "Select cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose



end event

event dw_master::doubleclicked;call super::doubleclicked;String ls_flag_aprob_calidad

this.AcceptText()

CHOOSE CASE lower(dwo.Name)
	CASE "flag_aprob_calidad"  
		ls_flag_aprob_calidad = this.object.flag_aprob_calidad [row]
		
		if ls_flag_aprob_calidad = '1' then
			MessageBox('Error', 'El registro ya esta aprobado, por favor verifique!', StopSign!)
			return
		end if
		
		this.object.flag_aprob_calidad 	[row] = '1'
		this.object.user_aprob_calidad	[row] = gs_user
		this.object.fecha_aprob_calidad	[row] = gnvo_app.of_fecha_actual()
		
		this.ii_update = 1
	
END CHOOSE
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap320_datos_calidad
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 80
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_fecha1, ld_fecha2

ld_fecha2 = DAte(gnvo_app.of_fecha_actual( ))

ld_fecha1 = Date('01/' + string(ld_fecha2, 'mm/yyyy'))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha1, ld_fecha2) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_refresh from commandbutton within w_ap320_datos_calidad
integer x = 1289
integer y = 48
integer width = 439
integer height = 100
integer taborder = 30
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

type gb_1 from groupbox within w_ap320_datos_calidad
integer width = 2725
integer height = 172
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro de Busqueda"
end type

