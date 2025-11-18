$PBExportHeader$w_select_fecha.srw
forward
global type w_select_fecha from window
end type
type cb_cancelar from commandbutton within w_select_fecha
end type
type cb_aceptar from commandbutton within w_select_fecha
end type
type st_2 from statictext within w_select_fecha
end type
type st_1 from statictext within w_select_fecha
end type
type dw_2 from u_dw_abc within w_select_fecha
end type
type dw_1 from u_dw_abc within w_select_fecha
end type
end forward

global type w_select_fecha from window
integer width = 2231
integer height = 1556
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
st_2 st_2
st_1 st_1
dw_2 dw_2
dw_1 dw_1
end type
global w_select_fecha w_select_fecha

type variables
String			is_ot_adm, is_origen
str_parametros istr_param
end variables

on w_select_fecha.create
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.st_2=create st_2
this.st_1=create st_1
this.dw_2=create dw_2
this.dw_1=create dw_1
this.Control[]={this.cb_cancelar,&
this.cb_aceptar,&
this.st_2,&
this.st_1,&
this.dw_2,&
this.dw_1}
end on

on w_select_fecha.destroy
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event open;istr_param = Message.PowerObjectParm

is_ot_adm 	= istr_param.string1
is_origen		= istr_param.string2

dw_1.Retrieve(gs_user, istr_param.date1, istr_param.date2, is_ot_adm, is_origen)

dw_2.InsertRow( 0 )
end event

type cb_cancelar from commandbutton within w_select_fecha
integer x = 1792
integer y = 1332
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_select_fecha
integer x = 1381
integer y = 1332
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;date				ld_fecha, ld_fecha_dst
Long				ll_row1, ll_found, ll_row2, ll_row_add
String			ls_texto, ls_cod_trabajador
DateTime			ldt_hora_inicio, ldt_hora_fin
str_parametros lstr_param
u_ds_base		lds_base
u_dw_abc			ldw_master

try 
	if dw_1.RowCount( ) = 0 or dw_1.getRow() <= 0 then 
		lstr_param.b_return = false
		return
	end if
	
	if dw_2.RowCount() = 0 then
		gnvo_app.of_Mensaje_error( "Debe ingresar una fecha para hacer la copia")
		lstr_param.b_return = false
		return
	end if
	
	lds_base = create u_ds_base
	
	lds_base.DataObject = 'd_lista_asistencia_tbl'
	lds_base.setTransObject( SQLCA )
	
	ld_fecha 		= Date(dw_1.object.Fecha[dw_1.getRow()])
	ldw_master = istr_param.dw_m
	
	lds_base.Retrieve(gs_user, ld_fecha, is_ot_adm, is_origen)
	
	if lds_base.RowCount( ) = 0 then
		gnvo_app.of_mensaje_error( "No existen registros de asistencia " &
										 + "para la fecha seleccionada " + string(ld_fecha) &
										 + " y para el OT_ADM " + is_ot_adm &
										 + " y el usuario " + gs_user &
										 + ", por favor verifique!")
		return
	end if
	
	for ll_row1 = 1 to dw_2.RowCount() 
		ld_fecha_dst = Date(dw_2.object.fecha [ll_row1])
		
		if not IsNull(ld_fecha_dst) and string(ld_fecha_dst, 'dd/mm/yyyy') <> '00/00/0000' then
			//Si la fecha no es nula y es valida entonces avanzo
			
			for ll_row2 = 1 to lds_base.RowCount()
				yield()
				
				//Siguiente paso es verificar si existe o no el registro				
				ls_cod_trabajador = lds_base.object.cod_trabajador [ll_row2]
				
				ls_texto = "cod_trabajador='" + ls_cod_trabajador +"' and string(fec_movim,'dd/mm/yyyy')='" + string(ld_fecha_dst, 'dd/mm/yyyy') + "'"
				
				ll_found = ldw_master.find(ls_texto, 1, ldw_master.RowCount())
				
				if ll_found = 0 then
					//Si no existe en el datawindows, voy a buscarlo en la tabla
					select count(*)
					  into :ll_found
					from asistencia
					where COD_TRABAJADOR = :ls_cod_trabajador
					  and trunc(FEC_MOVIM) = trunc(:ld_fecha_dst);
					
					if ll_found = 0 then
						//Si no existe entonces recien lo ingreso a la asistencia
						ll_row_add = ldw_master.event ue_insert( )
						if ll_row_add > 0 then
							yield()
							
							//Obtengo las horas de inicio y de fin
							ldt_hora_inicio 	= DateTime(lds_base.object.fec_desde [ll_row2])
							ldt_hora_fin	 	= DateTime(lds_base.object.fec_hasta [ll_row2])
							
							ldw_master.object.cod_trabajador 	[ll_row_add] = lds_base.object.cod_trabajador 	[ll_row2]
							ldw_master.object.nom_trabajador 	[ll_row_add] = lds_base.object.nom_trabajador 	[ll_row2]
							ldw_master.object.fec_movim 			[ll_row_add] = ld_fecha_dst
							ldw_master.object.turno 				[ll_row_add] = lds_base.object.turno 				[ll_row2]
							ldw_master.object.desc_turno 			[ll_row_add] = lds_base.object.desc_turno 			[ll_row2]
							ldw_master.object.ot_adm 				[ll_row_add] = lds_base.object.ot_adm 				[ll_row2]
							ldw_master.object.desc_ot_adm 		[ll_row_add] = lds_base.object.desc_ot_adm 		[ll_row2]
							ldw_master.object.fec_desde 			[ll_row_add] = DateTime(ld_fecha_dst, Time(ldt_hora_inicio))
							ldw_master.object.fec_hasta 			[ll_row_add] = DateTime(ld_fecha_dst, Time(ldt_hora_fin))
							ldw_master.object.cod_tipo_mov 		[ll_row_add] = lds_base.object.cod_tipo_mov 		[ll_row2]
							ldw_master.object.desc_movimiento 	[ll_row_add] = lds_base.object.desc_movimiento 	[ll_row2]
							ldw_master.object.nro_orden 			[ll_row_add] = lds_base.object.nro_orden 			[ll_row2]
							ldw_master.object.oper_sec 			[ll_row_add] = lds_base.object.oper_sec 			[ll_row2]
							ldw_master.object.hor_diu_nor 		[ll_row_add] = lds_base.object.hor_diu_nor 		[ll_row2]
							ldw_master.object.hor_noc_nor 		[ll_row_add] = lds_base.object.hor_noc_nor 		[ll_row2]
							ldw_master.object.hor_ext_diu_1 		[ll_row_add] = lds_base.object.hor_ext_diu_1 		[ll_row2]
							ldw_master.object.hor_ext_diu_2 		[ll_row_add] = lds_base.object.hor_ext_diu_2 		[ll_row2]
							ldw_master.object.hor_ext_noc_1 		[ll_row_add] = lds_base.object.hor_ext_noc_1 	[ll_row2]
							ldw_master.object.hor_ext_noc_2 		[ll_row_add] = lds_base.object.hor_ext_noc_2 	[ll_row2]
							ldw_master.object.hor_ext_100 		[ll_row_add] = lds_base.object.hor_ext_100 		[ll_row2]
							ldw_master.object.horas_trab 			[ll_row_add] = lds_base.object.horas_trab 			[ll_row2]
							ldw_master.object.cod_usr			 	[ll_row_add] = lds_base.object.cod_usr 				[ll_row2]
							ldw_master.object.cod_origen			[ll_row_add] = lds_base.object.cod_origen 			[ll_row2]
							
						end if
					end if
				end if
			next
			
			
		end if
	next
	
	
catch ( Exception ex )
	ROLLBACK;
	gnvo_app.of_catch_exception( ex, "Error de excepciones")
	
finally
	destroy lds_base
	
end try

lstr_param.b_return = true

CloseWithReturn(parent, lstr_param)
end event

type st_2 from statictext within w_select_fecha
integer x = 1097
integer width = 1088
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Fechas para Copiar"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_select_fecha
integer width = 1088
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Asistencia Existentes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_2 from u_dw_abc within w_select_fecha
integer x = 1097
integer y = 96
integer width = 1088
integer height = 1220
string dataobject = "d_lista_fecha_destino_tbl"
end type

event buttonclicked;call super::buttonclicked;if row = 0 then return

if lower(dwo.name) = 'b_add' then
	
	this.insertrow( 0 )
	
elseif lower(dwo.name) = 'b_delete' then
	
	this.deleterow( row )
	
end if
end event

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

type dw_1 from u_dw_abc within w_select_fecha
integer y = 96
integer width = 1088
integer height = 1220
string dataobject = "d_lista_fecha_asistencia_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

