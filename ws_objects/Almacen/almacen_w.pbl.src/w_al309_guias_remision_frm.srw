$PBExportHeader$w_al309_guias_remision_frm.srw
forward
global type w_al309_guias_remision_frm from w_abc
end type
type hpb_progreso from hprogressbar within w_al309_guias_remision_frm
end type
type pb_reporte from picturebutton within w_al309_guias_remision_frm
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al309_guias_remision_frm
end type
type pb_2 from picturebutton within w_al309_guias_remision_frm
end type
type pb_impresion from picturebutton within w_al309_guias_remision_frm
end type
type dw_master from u_dw_abc within w_al309_guias_remision_frm
end type
type gb_1 from groupbox within w_al309_guias_remision_frm
end type
end forward

global type w_al309_guias_remision_frm from w_abc
integer width = 3730
integer height = 2024
string title = "[AL309] Impresión Masiva de Guias de Remisión"
event ue_print_guias ( )
hpb_progreso hpb_progreso
pb_reporte pb_reporte
uo_fechas uo_fechas
pb_2 pb_2
pb_impresion pb_impresion
dw_master dw_master
gb_1 gb_1
end type
global w_al309_guias_remision_frm w_al309_guias_remision_frm

type variables
Long 		 	il_fila
n_cst_wait	invo_wait
end variables

forward prototypes
public function long of_selected_rows ()
end prototypes

event ue_print_guias();Long 		ll_rows, ll_row, ll_index
String 	ls_org_guia, ls_nro_guia, ls_full_nro_guia

try
	
	invo_wait = create n_cst_wait
	
	if dw_master.RowCount() = 0 then
		MessageBox('Error', 'No hay ningun registro para procesar, por favor verifique!', StopSign!)
		return
	end if
	
	
	hpb_progreso.visible = true
	hpb_progreso.Position = 0
	
	ll_rows = of_selected_rows()
	
	if ll_rows = 0 then
		MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
		return
	end if
	
	if PrintSetupPrinter () <= 0 then return
	
	ll_index = dw_master.GetSelectedRow( 0 )
	ll_row = 0
	
	DO WHILE ll_index > 0
	
		ll_row ++
		
		ls_full_nro_guia	= dw_master.object.full_nro_guia [ll_index]
		ls_org_guia			= dw_master.object.org_guia 		[ll_index]
		ls_nro_guia			= dw_master.object.nro_guia 		[ll_index]
		
		invo_wait.of_mensaje('Imprimiendo la GUIA DE REMISION ' + ls_full_nro_guia + " por favor espere un momento")
		
		gnvo_app.almacen.of_print_guia(ls_org_guia, ls_nro_guia)
		
		hpb_progreso.Position = ll_row / ll_rows * 100
		
		ll_index = dw_master.GetSelectedRow( ll_index )
	
	LOOP

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al imprimir las GUIAS DE REMISION')
	return

finally
	invo_wait.of_close()
	destroy invo_wait
	
	hpb_progreso.visible = false
	
end try

end event

public function long of_selected_rows ();Long ll_row = 0

for ll_row = 1 to dw_master.RowCount()
	if dw_master.IsSelected(ll_row) then
		ll_row ++
	end if
next

return ll_row
end function

on w_al309_guias_remision_frm.create
int iCurrent
call super::create
this.hpb_progreso=create hpb_progreso
this.pb_reporte=create pb_reporte
this.uo_fechas=create uo_fechas
this.pb_2=create pb_2
this.pb_impresion=create pb_impresion
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_progreso
this.Control[iCurrent+2]=this.pb_reporte
this.Control[iCurrent+3]=this.uo_fechas
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.pb_impresion
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.gb_1
end on

on w_al309_guias_remision_frm.destroy
call super::destroy
destroy(this.hpb_progreso)
destroy(this.pb_reporte)
destroy(this.uo_fechas)
destroy(this.pb_2)
destroy(this.pb_impresion)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10


end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones


//of_position_window(0,0)       			// Posicionar la ventana en forma fija


end event

event ue_refresh;call super::ue_refresh;Date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

dw_master.Retrieve(ld_fecha1, ld_fecha2)
end event

type hpb_progreso from hprogressbar within w_al309_guias_remision_frm
integer x = 754
integer y = 204
integer width = 827
integer height = 68
unsignedinteger maxposition = 100
integer setstep = 10
end type

type pb_reporte from picturebutton within w_al309_guias_remision_frm
integer x = 754
integer y = 24
integer width = 274
integer height = 180
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\Reporte.png"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_refresh()
SetPointer(Arrow!)
end event

type uo_fechas from u_ingreso_rango_fechas_v within w_al309_guias_remision_frm
event destroy ( )
integer x = 59
integer y = 52
integer height = 212
integer taborder = 60
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type pb_2 from picturebutton within w_al309_guias_remision_frm
integer x = 1303
integer y = 24
integer width = 274
integer height = 180
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\Exit.png"
alignment htextalign = left!
end type

event clicked;Close (Parent)
end event

type pb_impresion from picturebutton within w_al309_guias_remision_frm
integer x = 1029
integer y = 24
integer width = 274
integer height = 180
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\Imprimir.png"
alignment htextalign = left!
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_print_guias()
SetPointer(Arrow!)
end event

type dw_master from u_dw_abc within w_al309_guias_remision_frm
integer y = 284
integer width = 3579
integer height = 1472
string dataobject = "d_lista_guias_remision"
end type

event clicked;//override

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

idw_mst = dw_master // dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;//****************************************************************************************//
// Objectivo : Codigo para la seleccion en bloque.                                        //
// Argumento : This   -> Datawindows Actual.                                        //
//             as_indicador -> 'S'   Selección Simple                                     //
//                             'M'   Selección Multiple                                   //
// Sintaxis  : uf_seleccion(This,as_indicador)
//****************************************************************************************//

Integer  li_inicio, li_fin
String   ls_campo

This.AcceptText()

IF This.getrow() <= 0 THEN RETURN


IF KeyDown(KeyControl!) THEN
	il_fila = This.getrow()
	
//	Messagebox('il_fila',il_fila)
	
	IF This.IsSelected(il_fila) THEN
		This.SelectRow(il_fila , False)
	ELSE
		This.SelectRow(il_fila , True)
	END IF
	RETURN
END IF

IF KeyDown(KeyShift!) THEN
	li_inicio = This.getrow()
	IF (il_fila - li_inicio) > 0 THEN
		FOR li_fin = il_fila TO li_inicio STEP -1 
			This.SelectRow( li_fin , True)
		NEXT
	ELSE
		FOR li_fin = il_fila TO li_inicio
			 This.SelectRow( li_fin , True)
		NEXT
	END IF
	RETURN
END IF

il_fila = This.getrow()
This.setrow(il_fila)
This.SelectRow(0, False)
This.SelectRow(This.getrow() , True)
end event

type gb_1 from groupbox within w_al309_guias_remision_frm
integer y = 8
integer width = 745
integer height = 268
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

