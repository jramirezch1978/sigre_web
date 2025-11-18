$PBExportHeader$w_ma511_costos_mantenimiento_x_maq_anual.srw
forward
global type w_ma511_costos_mantenimiento_x_maq_anual from w_cns
end type
type st_1 from statictext within w_ma511_costos_mantenimiento_x_maq_anual
end type
type ddlb_1 from dropdownlistbox within w_ma511_costos_mantenimiento_x_maq_anual
end type
type dw_ext from datawindow within w_ma511_costos_mantenimiento_x_maq_anual
end type
type cb_3 from commandbutton within w_ma511_costos_mantenimiento_x_maq_anual
end type
type dw_graph from u_dw_grf within w_ma511_costos_mantenimiento_x_maq_anual
end type
type cb_2 from commandbutton within w_ma511_costos_mantenimiento_x_maq_anual
end type
type cb_1 from commandbutton within w_ma511_costos_mantenimiento_x_maq_anual
end type
type dw_cns from u_dw_cns within w_ma511_costos_mantenimiento_x_maq_anual
end type
end forward

global type w_ma511_costos_mantenimiento_x_maq_anual from w_cns
integer width = 3680
integer height = 2244
string title = "Costos de Mantenimiento Anual x Maquina ( MA511)"
string menuname = "m_rpt_smpl"
st_1 st_1
ddlb_1 ddlb_1
dw_ext dw_ext
cb_3 cb_3
dw_graph dw_graph
cb_2 cb_2
cb_1 cb_1
dw_cns dw_cns
end type
global w_ma511_costos_mantenimiento_x_maq_anual w_ma511_costos_mantenimiento_x_maq_anual

type variables
Integer ii_zoom_actual
String  is_ano
end variables

on w_ma511_costos_mantenimiento_x_maq_anual.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.ddlb_1=create ddlb_1
this.dw_ext=create dw_ext
this.cb_3=create cb_3
this.dw_graph=create dw_graph
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.dw_ext
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.dw_graph
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_cns
end on

on w_ma511_costos_mantenimiento_x_maq_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.ddlb_1)
destroy(this.dw_ext)
destroy(this.cb_3)
destroy(this.dw_graph)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_cns)
end on

event ue_open_pre();call super::ue_open_pre;Long    ll_ano_final,ll_ano_inic, ll_inicio
Integer li_contador = 0
String  ls_ano

dw_cns.SetTransObject(sqlca)
dw_graph.SetTransObject(sqlca)
dw_ext.SettransObject(sqlca)

idw_1 = dw_cns                 // asignar dw corriente
of_position_window(0,0)        // Posicionar la ventana en forma fija
ii_zoom_actual = 100
dw_cns.Event ue_preview()
dw_ext.Insertrow(0)

ll_ano_inic  = Long(String(today(),'yyyy')) - 5
ll_ano_final = Long(String(today(),'yyyy')) + 5

FOR ll_inicio = ll_ano_inic TO ll_ano_final
	 li_contador ++	
	 ls_ano = Trim(String(ll_inicio))
	 ddlb_1.InsertItem(ls_ano, li_contador)
NEXT	


end event

event resize;call super::resize;dw_cns.width  = newwidth  - dw_cns.x - 10
dw_cns.height = newheight - dw_cns.y - 10
dw_graph.width  = newwidth  - dw_graph.x - 10
dw_graph.height = newheight - dw_graph.y - 10
end event

type st_1 from statictext within w_ma511_costos_mantenimiento_x_maq_anual
integer x = 23
integer y = 180
integer width = 393
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type ddlb_1 from dropdownlistbox within w_ma511_costos_mantenimiento_x_maq_anual
integer x = 434
integer y = 172
integer width = 425
integer height = 336
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;is_ano = ddlb_1.text(index)
end event

type dw_ext from datawindow within w_ma511_costos_mantenimiento_x_maq_anual
integer x = 14
integer y = 260
integer width = 2107
integer height = 208
integer taborder = 10
string title = "none"
string dataobject = "d_ext_maquina_tab"
boolean border = false
boolean livescroll = true
end type

type cb_3 from commandbutton within w_ma511_costos_mantenimiento_x_maq_anual
boolean visible = false
integer x = 3086
integer y = 244
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Retornar"
end type

event clicked;cb_3.visible 	  = FALSE
dw_graph.Visible = FALSE
dw_cns.Visible   = TRUE
end event

type dw_graph from u_dw_grf within w_ma511_costos_mantenimiento_x_maq_anual
boolean visible = false
integer x = 23
integer y = 512
integer width = 3301
integer height = 1216
integer taborder = 20
string dataobject = "d_rpt_tip_mant_anual_prep_real_grp"
end type

type cb_2 from commandbutton within w_ma511_costos_mantenimiento_x_maq_anual
boolean visible = false
integer x = 3086
integer y = 244
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grafico"
end type

event clicked;cb_2.Visible	  = FALSE
cb_3.Visible	  = TRUE
dw_graph.Visible = TRUE
dw_cns.Visible   = FALSE
end event

type cb_1 from commandbutton within w_ma511_costos_mantenimiento_x_maq_anual
integer x = 3086
integer y = 364
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_ano,ls_tip_costo,ls_cod_maquina,ls_titulo


ls_tip_costo 	= dw_ext.Object.tip_costo   [1]
ls_cod_maquina	= dw_ext.Object.cod_maquina [1]


IF Isnull(is_ano) OR Trim(is_ano) = '' THEN
	Messagebox('Aviso','Debe Seleccionar Año a Procesar')
	Return
END IF

IF Isnull(ls_cod_maquina) OR Trim(ls_cod_maquina) = '' THEN
	Messagebox('Aviso','Debe Seleccionar Maquina')
	Return
END IF

IF Isnull(ls_tip_costo) OR Trim(ls_tip_costo) = '' THEN
	Messagebox('Aviso','Debe Seleccionar Tipo de Costo')
	Return
END IF

/*********************************/
/*Eliminación de Archivo temporal*/
/*********************************/

DELETE FROM tt_maq_x_ot_val ;

DECLARE pb_usp_calc_x_tmant_anual_preal PROCEDURE FOR USP_MTT_CALC_TMAN_ANUAL_PREAL
(:is_ano,:ls_tip_costo,:ls_cod_maquina)  ;
EXECUTE pb_usp_calc_x_tmant_anual_preal;	


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	RETURN
END IF

dw_cns.retrieve(ls_ano,ls_tip_costo,ls_cod_maquina,'M',gs_empresa,gs_user)
dw_cns.Object.p_logo.filename = gs_logo
IF dw_cns.Rowcount() > 0 THEN
	ls_titulo = dw_cns.object.titulo [1] 
END IF
dw_graph.Object.gr_1.Title = ls_titulo
dw_graph.retrieve()
dw_graph.Visible = FALSE
dw_cns.Visible   = TRUE
cb_2.visible     = TRUE


end event

type dw_cns from u_dw_cns within w_ma511_costos_mantenimiento_x_maq_anual
event ue_preview ( )
integer x = 23
integer y = 512
integer width = 3301
integer height = 1216
string dataobject = "d_rpt_tip_mant_anual_prep_real"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_preview();THIS.Modify("DataWindow.Print.Preview=Yes")
THIS.Modify("datawindow.print.preview.zoom = " + String(ii_zoom_actual))
This.title = "Reporte " + " (Zoom: " + String(ii_zoom_actual) + "%)"
SetPointer(hourglass!)

end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1
String ls_data

CHOOSE CASE dwo.Name
		 CASE 'row_column'  
				ls_data = This.Object.row_column[row]
				CHOOSE CASE ls_data
					    CASE 'Mntto. Regular'
								lstr_1.Arg[1]    = 'R'
						 CASE	'Mntto. Preventivo'
								lstr_1.Arg[1]    = 'P' 							
						 CASE	'Mntto Diario'
								lstr_1.Arg[1]    = 'D'
    					 CASE	'Mntto Predictivo'
								lstr_1.Arg[1]    = 'M'							
						 CASE	'Mntto Correctivo'
								lstr_1.Arg[1]    = 'C'							
						 CASE	'Otros'
								lstr_1.Arg[1]    = 'O'														
				END CHOOSE
				

		      lstr_1.DataObject = 'd_rpt_tip_mant_anual_prep_real_x_maq'
		      lstr_1.Width      = 3600			
		      lstr_1.Height     = 1300
		      lstr_1.Title      = 'Mantenimiento de Maquinas'
				lstr_1.Nextcol		= 'cod_maquina'
				of_new_sheet(lstr_1)
END CHOOSE
end event

event constructor;call super::constructor; ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

