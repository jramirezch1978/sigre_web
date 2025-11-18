$PBExportHeader$w_ap321_datos_importacion.srw
forward
global type w_ap321_datos_importacion from w_abc_master_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap321_datos_importacion
end type
type cb_refresh from commandbutton within w_ap321_datos_importacion
end type
type gb_1 from groupbox within w_ap321_datos_importacion
end type
end forward

global type w_ap321_datos_importacion from w_abc_master_smpl
integer width = 2789
integer height = 2000
string title = "[AP321] Asignar datos de Importacion - Liberacion"
string menuname = "m_mantto_tablas"
uo_fecha uo_fecha
cb_refresh cb_refresh
gb_1 gb_1
end type
global w_ap321_datos_importacion w_ap321_datos_importacion

on w_ap321_datos_importacion.create
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

on w_ap321_datos_importacion.destroy
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

type dw_master from w_abc_master_smpl`dw_master within w_ap321_datos_importacion
integer y = 176
integer width = 2715
integer height = 1628
string dataobject = "d_abc_importacion_descarga_det_tbl"
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

event dw_master::doubleclicked;call super::doubleclicked;String ls_flag_aprob_import
string ls_columna, ls_string, ls_evaluate

this.AcceptText()

if row = 0 then return

CHOOSE CASE lower(dwo.Name)
	CASE "flag_aprob_import"  
		ls_flag_aprob_import = this.object.flag_aprob_import [row]
		
		if ls_flag_aprob_import = '1' then
			MessageBox('Error', 'El registro ya esta aprobado, por favor verifique!', StopSign!)
			return
		end if
		
		this.object.flag_aprob_import 	[row] = '1'
		this.object.user_aprob_import		[row] = gs_user
		this.object.fecha_aprob_import	[row] = gnvo_app.of_fecha_actual()
		
		this.ii_update = 1
		
		return
	
END CHOOSE

ls_string = this.Describe(lower(dwo.name) + '.Protect' )

if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "puerto_origen"

		ls_sql = "select t.puerto as puerto, " &
				 + "t.descr_puerto as descripcion_puerto " &
				 + "from fl_puertos t " &
				 + "where t.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.puerto_origen	[al_row] = ls_codigo
			this.object.descr_puerto	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_pesca"

		ls_sql = "select tipo_pesca as tipo_pesca, " &
				 + "desc_tipo_pesca as descripcion_tipo_pesca " &
				 + "from ap_tipo_pesca " &
				 + "where flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.tipo_pesca			[al_row] = ls_codigo
			this.object.desc_tipo_pesca	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose



end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_desc1, ls_desc2
Long 		ll_count

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'tipo_pesca'
		
		// Verifica que codigo ingresado exista			
		select desc_tipo_pesca
			into :ls_desc1
		from ap_tipo_pesca
		where tipo_pesca = :data
		  and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de Pesca " + data + " o no se encuentra activo, por favor verifique")
			this.object.tipo_pesca			[row] = gnvo_app.is_null
			this.object.desc_tipo_pesca	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_tipo_pesca		[row] = ls_desc1

	CASE 'puerto_origen' 

		// Verifica que codigo ingresado exista			
		select flp.descr_puerto
			into :ls_desc1
		from fl_puertos flp
		where flp.puerto 			= :data
		  and flp.flag_estado 	= '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe puerto " + data + " o no se encuentra activo, por favor verifique")
			this.object.puerto_origen	[row] = gnvo_app.is_null
			this.object.descr_puerto	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.descr_puerto		[row] = ls_desc1


END CHOOSE
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap321_datos_importacion
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

type cb_refresh from commandbutton within w_ap321_datos_importacion
integer x = 1307
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

type gb_1 from groupbox within w_ap321_datos_importacion
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

