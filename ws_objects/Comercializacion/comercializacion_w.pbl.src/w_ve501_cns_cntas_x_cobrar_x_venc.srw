$PBExportHeader$w_ve501_cns_cntas_x_cobrar_x_venc.srw
forward
global type w_ve501_cns_cntas_x_cobrar_x_venc from w_cns
end type
type cbx_cli from checkbox within w_ve501_cns_cntas_x_cobrar_x_venc
end type
type cb_2 from commandbutton within w_ve501_cns_cntas_x_cobrar_x_venc
end type
type cb_1 from commandbutton within w_ve501_cns_cntas_x_cobrar_x_venc
end type
type dw_1 from datawindow within w_ve501_cns_cntas_x_cobrar_x_venc
end type
type gb_1 from groupbox within w_ve501_cns_cntas_x_cobrar_x_venc
end type
type dw_cns from u_dw_cns within w_ve501_cns_cntas_x_cobrar_x_venc
end type
end forward

global type w_ve501_cns_cntas_x_cobrar_x_venc from w_cns
integer x = 0
integer y = 0
integer width = 3616
integer height = 1652
string title = "Cuentas x Cobrar Pendientes (FI507)"
string menuname = "m_consulta"
long backcolor = 12632256
integer ii_x = 0
event ue_saveas ( )
cbx_cli cbx_cli
cb_2 cb_2
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
dw_cns dw_cns
end type
global w_ve501_cns_cntas_x_cobrar_x_venc w_ve501_cns_cntas_x_cobrar_x_venc

event ue_saveas();
dw_cns.Event ue_saveas()
end event

on w_ve501_cns_cntas_x_cobrar_x_venc.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cbx_cli=create cbx_cli
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_cli
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.gb_1
this.Control[iCurrent+6]=this.dw_cns
end on

on w_ve501_cns_cntas_x_cobrar_x_venc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_cli)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.dw_cns)
end on

event resize;call super::resize;dw_cns.width  = newwidth  - dw_cns.x - 50
dw_cns.height = newheight - dw_cns.y - 50
end event

event ue_open_pre;call super::ue_open_pre;dw_cns.SetTransObject(sqlca)
idw_1 = dw_cns              // asignar dw corriente
// ii_help = 101           // help topic
of_position_window(0,0)        // Posicionar la ventana en forma fija



/*Preview de Datawindow*/
dw_cns.Modify("DataWindow.Print.Preview=Yes")
dw_cns.Modify("datawindow.print.preview.zoom = 100 " )
SetPointer(hourglass!)


/*Logo de Aipsa*/
idw_1.Object.p_logo.filename = gs_logo

idw_1.is_dwform = 'tabular'

end event

event ue_filter;call super::ue_filter;dw_cns.groupcalc()
end event

type cbx_cli from checkbox within w_ve501_cns_cntas_x_cobrar_x_venc
integer x = 2135
integer y = 272
integer width = 498
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los clientes"
end type

event clicked;delete from tt_proveedor ;

IF cbx_cli.checked = true THEN
	cb_2.enabled = false
ELSE
	cb_2.enabled = true
END IF

end event

type cb_2 from commandbutton within w_ve501_cns_cntas_x_cobrar_x_venc
integer x = 3163
integer y = 164
integer width = 402
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clientes"
end type

event clicked;Long ll_count
str_parametros sl_param 


Rollback ;

sl_param.dw1		= 'd_lista_prov_ctas_x_cobrar_tbl'
sl_param.titulo	= 'Clientes '
sl_param.opcion   = 1
sl_param.db1 		= 1600
sl_param.string1 	= '1RPP'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)


end event

type cb_1 from commandbutton within w_ve501_cns_cntas_x_cobrar_x_venc
integer x = 3163
integer y = 284
integer width = 402
integer height = 108
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_tip_rep, ls_proveedor, ls_texto
Date   ld_fec_inicial, ld_fec_final

Long   ll_count
dw_1.Accepttext()

ld_fec_inicial	= dw_1.Object.fec_inicial [1]
ld_fec_final	= dw_1.Object.fec_final   [1]

ls_tip_rep		= dw_1.Object.tip_rep	  [1]

IF cbx_cli.checked = true THEN
	delete from tt_proveedor ;
	
	insert into tt_fin_proveedor 
	select distinct(p.proveedor) from proveedor p, cntas_cobrar c
	 where p.proveedor=c.cod_relacion and
     	  c.fecha_vencimiento between 
		  trunc(:ld_fec_inicial) and trunc(:ld_fec_final)+0.999 ;
END IF

/*Verifica Proveedores*/
SELECT Count(*)
  INTO :ll_count
  FROM tt_fin_proveedor ;

IF ll_count  = 0 THEN
	Messagebox('Aviso','Debe Seleccionar Proveedor')	
	Return
END IF
/**/

IF Isnull(ld_fec_inicial) OR Isnull(ld_fec_inicial) THEN
	Messagebox('Aviso','Debe Ingresar Fecha Inicial')	
	dw_1.SetFocus()
	dw_1.SetColumn('fec_inicial')
	Return
END IF

IF Isnull(ls_tip_rep) OR Trim(ls_tip_rep) = '' THEN
	Messagebox('Aviso','Debe Seleccionar un tipo de Reporte')
	Return
END IF

IF ls_tip_rep = '1' THEN // Por Fecha de Vencimiento
	dw_cns.dataobject = 'd_rpt_cntas_cobrar_wilf1_tbl'
ELSEIF ls_tip_rep = '2' THEN // Por Codigo de Relacion
	dw_cns.dataobject = 'd_rpt_cntas_cobrar_wilf2_tbl'
ELSEIF ls_tip_rep = '3' THEN // Por Tipo de Documento
	dw_cns.dataobject = 'd_rpt_cntas_cobrar_wilf3_tbl'
END IF

Parent.TriggerEvent('ue_open_pre')

ls_texto = 'Del ' + string(ld_fec_inicial, 'dd/mm/yyyy') + ' al ' + string(ld_fec_final, 'dd/mm/yyyy')

idw_1.object.t_texto.text = ls_texto

idw_1.retrieve(ld_fec_inicial,ld_fec_final)

end event

type dw_1 from datawindow within w_ve501_cns_cntas_x_cobrar_x_venc
integer x = 50
integer y = 92
integer width = 1934
integer height = 296
integer taborder = 20
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

type gb_1 from groupbox within w_ve501_cns_cntas_x_cobrar_x_venc
integer x = 32
integer y = 8
integer width = 1993
integer height = 412
integer taborder = 10
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

type dw_cns from u_dw_cns within w_ve501_cns_cntas_x_cobrar_x_venc
event ue_saveas ( )
integer x = 23
integer y = 492
integer width = 3557
integer height = 804
integer taborder = 0
string dataobject = "d_rpt_cntas_cobrar_wilf1_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
string is_dwform = ""
string is_mastdet = ""
end type

event ue_saveas();this.saveas()

end event

event constructor;call super::constructor;ii_ck [1] = 1
end event

