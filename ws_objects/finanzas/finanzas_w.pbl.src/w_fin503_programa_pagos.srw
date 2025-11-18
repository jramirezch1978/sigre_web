$PBExportHeader$w_fin503_programa_pagos.srw
forward
global type w_fin503_programa_pagos from w_cns
end type
type cb_1 from commandbutton within w_fin503_programa_pagos
end type
type dw_1 from datawindow within w_fin503_programa_pagos
end type
type gb_1 from groupbox within w_fin503_programa_pagos
end type
type dw_cns from u_dw_cns within w_fin503_programa_pagos
end type
end forward

global type w_fin503_programa_pagos from w_cns
integer x = 0
integer y = 0
integer width = 3616
integer height = 1652
string title = "Programa de Pagos  ( FI503)"
string menuname = "m_consulta"
long backcolor = 12632256
integer ii_x = 0
cb_1 cb_1
dw_1 dw_1
gb_1 gb_1
dw_cns dw_cns
end type
global w_fin503_programa_pagos w_fin503_programa_pagos

on w_fin503_programa_pagos.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.cb_1=create cb_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.dw_cns
end on

on w_fin503_programa_pagos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

type cb_1 from commandbutton within w_fin503_programa_pagos
integer x = 3163
integer y = 368
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

event clicked;String ls_fec_inicial,ls_fec_final,ls_origen,ls_moneda

dw_1.Accepttext()

ls_fec_inicial	= String(dw_1.Object.fec_inicial [1],'yyyymmdd')
ls_fec_final	= String(dw_1.Object.fec_final   [1],'yyyymmdd')
ls_origen    	= dw_1.Object.origen  	  [1] 
ls_moneda		= dw_1.Object.cod_moneda  [1]	

IF Isnull(ls_fec_inicial) OR Trim(ls_fec_inicial) = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Fecha Inicial')	
	dw_1.SetFocus()
	dw_1.SetColumn('fec_inicial')
	Return
END IF

IF Isnull(ls_fec_final) OR Trim(ls_fec_final) = '00000000' THEN
	Messagebox('Aviso','Debe Ingresar Fecha Final')	
	dw_1.SetFocus()
	dw_1.SetColumn('fec_final')
	Return
END IF

IF Isnull(ls_origen) OR Trim(ls_origen) = '' THEN
	ls_origen = '%'  /*Todos los origenes */
END IF

IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	ls_moneda = '%'  /*Todos las Monedas */
END IF

//**/

DECLARE PB_USP_FIN_CNS_PROGRAMACION_PAGOS PROCEDURE FOR USP_FIN_CNS_PROGRAMACION_PAGOS
(:ls_fec_inicial,:ls_fec_final,:ls_moneda);
EXECUTE PB_USP_FIN_CNS_PROGRAMACION_PAGOS ;

/**/

idw_1.Retrieve(ls_origen,gs_empresa,gs_user)
/*Elimino Informacion Generada en Arch. Temporal*/
DELETE FROM tt_fin_cns_prog_pagos;
end event

type dw_1 from datawindow within w_fin503_programa_pagos
integer x = 50
integer y = 92
integer width = 969
integer height = 380
integer taborder = 20
string title = "none"
string dataobject = "d_argumentos_prog_pagos_tbl"
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

type gb_1 from groupbox within w_fin503_programa_pagos
integer x = 32
integer y = 8
integer width = 1042
integer height = 472
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
borderstyle borderstyle = stylelowered!
end type

type dw_cns from u_dw_cns within w_fin503_programa_pagos
integer x = 23
integer y = 600
integer width = 3557
integer height = 696
integer taborder = 0
string dataobject = "d_cns_programa_pagos_x_fecha"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
integer ii_sort = 0
string is_dwform = ""
string is_mastdet = ""
end type

event constructor;call super::constructor;ii_ck [1] = 1
end event

