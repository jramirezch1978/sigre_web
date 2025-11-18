$PBExportHeader$w_rpt_listas.srw
$PBExportComments$Reporte basado en una seleccion de listas
forward
global type w_rpt_listas from w_rpt
end type
type dw_1 from u_dw_abc within w_rpt_listas
end type
type pb_1 from picturebutton within w_rpt_listas
end type
type pb_2 from picturebutton within w_rpt_listas
end type
type dw_2 from u_dw_abc within w_rpt_listas
end type
type cb_report from commandbutton within w_rpt_listas
end type
end forward

global type w_rpt_listas from w_rpt
integer width = 2363
integer height = 1392
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 67108864
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
cb_report cb_report
end type
global w_rpt_listas w_rpt_listas

type variables
u_dw_abc  idw_otro
str_parametros ist_par
end variables

forward prototypes
public subroutine of_dw_sort ()
end prototypes

public subroutine of_dw_sort ();Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(idw_otro.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(idw_otro.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(idw_otro.ii_ck[li_x]) +" A"
NEXT

idw_otro.SetSort (ls_sort)
idw_otro.Sort()

end subroutine

on w_rpt_listas.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.cb_report=create cb_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.dw_2
this.Control[iCurrent+5]=this.cb_report
end on

on w_rpt_listas.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.cb_report)
end on

event ue_open_pre;// ii_help = 101           // help topic

f_centrar( this)

Long ll_row
// Recoge parametro enviado
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_par = MESSAGE.POWEROBJECTPARM	
	dw_1.DataObject = ist_par.dw1
	dw_2.DataObject = ist_par.dw1
	dw_1.SetTransObject( SQLCA)
	CHOOSE CASE ist_par.tipo 
		case '1S'
			ll_row = dw_1.retrieve(ist_par.string1)
		case '1L'
			ll_row = dw_1.retrieve(ist_par.long1)
		case '1L1A'			
			ll_row = dw_1.retrieve(ist_par.long1, ist_par.field_ret)
		case '1L1S'
			ll_row = dw_1.retrieve(ist_par.long1, ist_par.string1)
		case '1L1S2S'
			ll_row = dw_1.retrieve(ist_par.long1, ist_par.string1, ist_par.string2 )
		case '2S'
			ll_row = dw_1.retrieve(ist_par.string1, ist_par.string2)
		case '3S'
			ll_row = dw_1.retrieve(ist_par.string1, ist_par.string2, ist_par.string3)
		case '1D2D'
			ll_row = dw_1.retrieve(ist_par.fecha1, ist_par.fecha2)
		case else
			ll_row = dw_1.retrieve()
	END CHOOSE		
	
	This.Title = ist_par.titulo	
END IF
delete from tt_pto_seleccion;
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type dw_1 from u_dw_abc within w_rpt_listas
integer y = 16
integer width = 1065
integer height = 1112
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_par = MESSAGE.POWEROBJECTPARM	
end if


is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_2
ii_ck[1] = 1 

end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event ue_selected_row_pro;call super::ue_selected_row_pro;
Long	ll_row, ll_rc, ll_count
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type pb_1 from picturebutton within w_rpt_listas
event ue_clicked_pre ( )
integer x = 1088
integer y = 392
integer width = 142
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event ue_clicked_pre;idw_otro = dw_2
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_1.EVENT ue_selected_row()

// ordenar ventana derecha
of_dw_sort()

end event

type pb_2 from picturebutton within w_rpt_listas
event ue_clicked_pre ( )
integer x = 1088
integer y = 536
integer width = 142
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
alignment htextalign = left!
end type

event ue_clicked_pre;idw_otro = dw_1
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_2.EVENT ue_selected_row()

// ordenar ventana izquierda
of_dw_sort()
end event

type dw_2 from u_dw_abc within w_rpt_listas
integer x = 1248
integer y = 16
integer width = 1065
integer height = 1112
integer taborder = 40
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_1
ii_ck[1] = 1 

end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_otro.ScrollToRow(ll_row)

end event

type cb_report from commandbutton within w_rpt_listas
integer x = 1623
integer y = 1156
integer width = 539
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;
Long 		ll_row
String 	ls_cencos, ls_niv1, ls_niv2, ls_niv3, ls_niv4, &
			ls_codigo, ls_desc, ls_mensaje, ls_cod_art
Integer	li_year

CHOOSE CASE ist_par.opcion 
CASE 1 
	// Llena datos de dw seleccionados a tabla temporal
	delete from tt_pto_seleccion;
	FOR ll_row = 1 to dw_2.rowcount()
		ls_cencos = dw_2.object.cencos[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_seleccion(cencos) values (:ls_cencos);
	NEXT
CASE 2 
	// Llena datos de dw seleccionados a tabla temporal
	delete from tt_pto_seleccion;
	FOR ll_row = 1 to dw_2.rowcount()
		ls_cencos = dw_2.object.cnta_prsp[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_seleccion(cnta_prsp) values (:ls_cencos);
	NEXT
CASE 3   // C.costo nivel 1	
	delete from tt_pto_seleccion;
	FOR ll_row = 1 to dw_2.rowcount()
		ls_niv1 = dw_2.object.cod_n1[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_seleccion(niv1) values (:ls_niv1);
	NEXT
CASE 4   // C.costo nivel 2	
	delete from tt_pto_seleccion;

	FOR ll_row = 1 to dw_2.rowcount()
		ls_niv1 = dw_2.object.cod_n1[ll_row]
		ls_niv2 = dw_2.object.cod_n2[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores

		insert into tt_pto_seleccion(niv1, niv2) values (:ls_niv1, :ls_niv2);
	NEXT
CASE 5   // C.costo nivel 3
	delete from tt_pto_seleccion;

	FOR ll_row = 1 to dw_2.rowcount()
		ls_niv1 = dw_2.object.cod_n1[ll_row]
		ls_niv2 = dw_2.object.cod_n2[ll_row]
		ls_niv3 = dw_2.object.cod_n3[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores

		insert into tt_pto_seleccion(niv1, niv2, niv3) values (:ls_niv1, :ls_niv2, :ls_niv3);
	NEXT
CASE 6   // C.costo nivel 4
	delete from tt_pto_seleccion;
	FOR ll_row = 1 to dw_2.rowcount()
		ls_niv1 = dw_2.object.cod_n1[ll_row]
		ls_niv2 = dw_2.object.cod_n2[ll_row]
		ls_niv3 = dw_2.object.cod_n3[ll_row]
		ls_niv4 = dw_2.object.cencos[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_seleccion(niv1, niv2, niv3, cencos) 
		  values (:ls_niv1, :ls_niv2, :ls_niv3, :ls_niv4);
	NEXT

CASE 7   // Tipos de Servicio
	delete from tt_pto_servicios;
	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_codigo = dw_2.object.servicio	[ll_row]
		
		insert into tt_pto_servicios(servicio) 
		  values (:ls_codigo);
		
		IF SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'No se pudo insertar fila en tt_pto_Servicios: ' + ls_mensaje)
			return
		end if
	NEXT
	commit;

CASE 8   // Centros Costo
	delete from tt_pto_cencos;
	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_codigo = dw_2.object.cencos	[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_cencos(cencos) 
		  values (:ls_codigo);
		  
		IF SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'No se pudo insertar fila en tt_pto_cencos: ' + ls_mensaje)
			return
		end if
	NEXT
	commit;
	
CASE 9   // Cuentas Presupuestales
	delete from tt_pto_cnta_prsp;
	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_codigo = dw_2.object.cnta_prsp	[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_cnta_prsp(cnta_prsp) 
		  values (:ls_codigo);
		  
		IF SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'No se pudo insertar fila en tt_pto_cnta_prsp: ' + ls_mensaje)
			return
		end if
	NEXT
	commit;
	
CASE 10   // Usuarios
	delete from tt_pto_usuario;
	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_codigo = dw_2.object.cod_usr	[ll_row]
		
		// Llena tabla temporal con el centro de costo y todas las cuentas
		// presupuestales que tenga segun indicadores
		insert into tt_pto_usuario(cod_usr) 
		  values (:ls_codigo);
		  
		IF SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'No se pudo insertar fila en tt_pto_usuario: ' + ls_mensaje)
			return
		end if
	NEXT
	commit;

CASE 11   // Reporte de Proyeccion de Produccion	
	// Llena tabla temporal Para el reporte de Proyecciones de Presupuesto
	// Ventana w_pt770
	
	delete from TT_PTO_SEL_PROY_PRSP;
	
	FOR ll_row = 1 to dw_2.rowcount()
		ls_cencos 	= dw_2.object.cencos	[ll_row]
		li_year 		= Integer(dw_2.object.ano [ll_row])
		ls_cod_art	= dw_2.object.cod_art [ll_row]	
		
		
		insert into TT_PTO_SEL_PROY_PRSP(ano, cencos, cod_art) 
		  values (:li_year, :ls_cencos, :ls_cod_art);
		  
		IF SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'No se pudo insertar fila en TT_PTO_SEL_PROY_PRSP: ' + ls_mensaje)
			return
		end if
	NEXT
	commit;
end CHOOSE
//Commit;	

Close (parent)
end event

