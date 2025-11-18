$PBExportHeader$w_fi504_cns_cntas_x_pagar_x_venc.srw
forward
global type w_fi504_cns_cntas_x_pagar_x_venc from w_cns
end type
type cbx_1 from checkbox within w_fi504_cns_cntas_x_pagar_x_venc
end type
type cb_2 from commandbutton within w_fi504_cns_cntas_x_pagar_x_venc
end type
type cb_1 from commandbutton within w_fi504_cns_cntas_x_pagar_x_venc
end type
type dw_1 from datawindow within w_fi504_cns_cntas_x_pagar_x_venc
end type
type gb_1 from groupbox within w_fi504_cns_cntas_x_pagar_x_venc
end type
type dw_cns from u_dw_cns within w_fi504_cns_cntas_x_pagar_x_venc
end type
end forward

global type w_fi504_cns_cntas_x_pagar_x_venc from w_cns
integer x = 0
integer y = 0
integer width = 3616
integer height = 1652
string title = "Cuentas x Pagar Pendientes (FI504)"
string menuname = "m_impresion"
long backcolor = 67108864
integer ii_x = 0
cbx_1 cbx_1
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
dw_cns dw_cns
end type
global w_fi504_cns_cntas_x_pagar_x_venc w_fi504_cns_cntas_x_pagar_x_venc

on w_fi504_cns_cntas_x_pagar_x_venc.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cbx_1=create cbx_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_cns
end on

on w_fi504_cns_cntas_x_pagar_x_venc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.dw_cns)
end on

event resize;call super::resize;dw_cns.width  = newwidth  - dw_cns.x - 50
dw_cns.height = newheight - dw_cns.y - 50
end event

event ue_open_pre();call super::ue_open_pre;dw_cns.SetTransObject(sqlca)
idw_1 = dw_cns              // asignar dw corriente
// ii_help = 101           // help topic
of_position_window(0,0)        // Posicionar la ventana en forma fija



/*Preview de Datawindow*/
dw_cns.Modify("DataWindow.Print.Preview=Yes")
dw_cns.Modify("datawindow.print.preview.zoom = 100 " )
SetPointer(hourglass!)


/*Logo de Aipsa*/
idw_1.Object.p_logo.filename = gs_logo



end event

event ue_filter;call super::ue_filter;dw_cns.groupcalc()
end event

type cbx_1 from checkbox within w_fi504_cns_cntas_x_pagar_x_venc
integer x = 2062
integer y = 128
integer width = 603
integer height = 72
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los proveedores"
end type

event clicked;//INSERT INTO tt_fin_proveedor select 
end event

type cb_2 from commandbutton within w_fi504_cns_cntas_x_pagar_x_venc
integer x = 2912
integer y = 92
integer width = 402
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Proveedor"
end type

event clicked;Long ll_count
str_parametros sl_param 


Rollback ;

sl_param.dw1		= 'd_lista_prov_ctas_x_pagar_tbl'
sl_param.titulo	= 'Proveedor '
sl_param.opcion   = 1
sl_param.db1 		= 1600
sl_param.string1 	= '1RPP'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)


end event

type cb_1 from commandbutton within w_fi504_cns_cntas_x_pagar_x_venc
integer x = 2912
integer y = 212
integer width = 402
integer height = 108
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_tip_rep, ls_proveedor
Date   ld_fec_inicial, ld_fec_final

Long   ll_count
dw_1.Accepttext()

ld_fec_inicial	= dw_1.Object.fec_inicial [1]
ld_fec_final	= dw_1.Object.fec_final   [1]

ls_tip_rep		= dw_1.Object.tip_rep	  [1]

/*Verifica Proveedores*/
SELECT Count(*)
  INTO :ll_count
  FROM tt_fin_proveedor ;

IF ll_count  = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Proveedor')	
	Return
END IF
/**/

IF Isnull(ld_fec_inicial) OR isnull(ld_fec_final) THEN
	Messagebox('Aviso','Rango de fecha invalido')	
	dw_1.SetFocus()
	dw_1.SetColumn('fec_inicial')
	Return
END IF

IF Isnull(ls_tip_rep) OR Trim(ls_tip_rep) = '' THEN
	Messagebox('Aviso','Debe Seleccionar un tipo de Reporte')
	Return
END IF

IF ls_tip_rep = '1' THEN // Por Fecha de Vencimiento
//	dw_cns.dataobject = 'd_cns_doc_x_pagar_pend_tbl'
	dw_cns.dataobject = 'd_rpt_cntas_pagar_wilfredo_tbl'
ELSEIF ls_tip_rep = '2' THEN // Por Codigo de Relacion
//	dw_cns.dataobject = 'd_cns_doc_x_pagar_pend_x_prov_tbl'
	dw_cns.dataobject = 'd_rpt_cntas_pagar_wilfredo_2_tbl'	
ELSEIF ls_tip_rep = '3' THEN // Por Tipo de Documento
//	dw_cns.dataobject = 'd_cns_doc_x_pagar_pend_x_tdoc_tbl'
	dw_cns.dataobject = 'd_rpt_cntas_pagar_wilfredo_3_tbl'	
END IF

Parent.TriggerEvent('ue_open_pre')


idw_1.Retrieve(ld_fec_inicial,ld_fec_final)

end event

type dw_1 from datawindow within w_fi504_cns_cntas_x_pagar_x_venc
integer x = 37
integer y = 52
integer width = 1934
integer height = 304
integer taborder = 10
string title = "none"
string dataobject = "d_argumentos_cntas_pagar_pend_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
InsertRow(0)
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'fec_inicial'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'fec_final'				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)					
							
END CHOOSE


end event

event itemerror;Return 1
end event

type gb_1 from groupbox within w_fi504_cns_cntas_x_pagar_x_venc
integer width = 1993
integer height = 380
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

type dw_cns from u_dw_cns within w_fi504_cns_cntas_x_pagar_x_venc
integer y = 392
integer width = 3557
integer height = 864
integer taborder = 0
string dataobject = "d_rpt_cntas_pagar_wilfredo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
string is_dwform = ""
string is_mastdet = ""
end type

event constructor;call super::constructor;ii_ck [1] = 1
end event

