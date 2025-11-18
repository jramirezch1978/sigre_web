$PBExportHeader$w_ma704_rpt_costo_materiales.srw
forward
global type w_ma704_rpt_costo_materiales from w_rpt_list
end type
type uo_1 from u_ingreso_rango_fechas within w_ma704_rpt_costo_materiales
end type
type cb_3 from commandbutton within w_ma704_rpt_costo_materiales
end type
type cb_4 from commandbutton within w_ma704_rpt_costo_materiales
end type
type gb_1 from groupbox within w_ma704_rpt_costo_materiales
end type
end forward

global type w_ma704_rpt_costo_materiales from w_rpt_list
integer height = 1884
string title = "Costo de materiales / Taller (MA704)"
string menuname = "m_rpt_smpl"
uo_1 uo_1
cb_3 cb_3
cb_4 cb_4
gb_1 gb_1
end type
global w_ma704_rpt_costo_materiales w_ma704_rpt_costo_materiales

type variables

end variables

on w_ma704_rpt_costo_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.cb_3=create cb_3
this.cb_4=create cb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.gb_1
end on

on w_ma704_rpt_costo_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;dw_report.SettransObject(sqlca)

// ii_help = 101           // help topic
idw_1 = dw_report
idw_1.Visible = TRUE
ib_preview = FALSE
Trigger event ue_preview()





end event

type dw_report from w_rpt_list`dw_report within w_ma704_rpt_costo_materiales
integer x = 14
integer y = 436
integer width = 3401
integer height = 1216
string dataobject = "d_rpt_costo_material_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_ma704_rpt_costo_materiales
boolean visible = false
integer x = 91
integer y = 588
integer width = 1353
integer height = 960
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2


end event

type pb_1 from w_rpt_list`pb_1 within w_ma704_rpt_costo_materiales
boolean visible = false
integer x = 1559
integer y = 916
end type

type pb_2 from w_rpt_list`pb_2 within w_ma704_rpt_costo_materiales
boolean visible = false
integer x = 1559
integer y = 1144
end type

type dw_2 from w_rpt_list`dw_2 within w_ma704_rpt_costo_materiales
boolean visible = false
integer x = 1851
integer y = 584
integer width = 1353
integer height = 960
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_ma704_rpt_costo_materiales
integer x = 2985
integer y = 264
integer width = 434
integer textsize = -8
end type

event cb_report::clicked;call super::clicked;String ls_cnta_prsp, ls_descripcion
Integer i
Long ll_count
Date ld_fini, ld_ffin


idw_1.DataObject='d_rpt_costo_material_tbl'
idw_1.SetTransObject(sqlca)

// Leyendo fechas de objeto fecha
ld_fini = uo_1.of_get_fecha1()
ld_ffin = uo_1.of_get_fecha2()  

/*Eliminacion de Infomación Temporal*/
delete from tt_man_valoriz_art ;

select count(*) into :ll_count from tt_man_cencos ;
//MessageBox('Cencos', string(ll_count))

select count(*) into :ll_count from tt_man_cnta_prsp ;
//MessageBox('Cnta Prsp', string(ll_count))

/**/
DECLARE PB_USP_MTT_RPT_VALORIZ_ART PROCEDURE FOR USP_MTT_RPT_VALORIZ_ART ( :ld_fini, :ld_ffin ) ;
execute PB_USP_MTT_RPT_VALORIZ_ART ;
		
IF sqlca.sqlcode = -1 THEN
   MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	rollback ;
   Return
ELSE
   MessageBox( 'Aviso', "Fin de proceso")
END IF

ls_descripcion = 'Del ' + string(ld_fini, 'dd/mm/yyyy') + ' al ' + string(ld_ffin, 'dd/mm/yyyy')
idw_1.retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_subtitulo.text = ls_descripcion

ib_preview = FALSE
parent.event ue_preview()

end event

type uo_1 from u_ingreso_rango_fechas within w_ma704_rpt_costo_materiales
integer x = 73
integer y = 88
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') 
of_set_fecha(today(), today() )
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_3 from commandbutton within w_ma704_rpt_costo_materiales
integer x = 2985
integer y = 144
integer width = 434
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cnta. Prsp"
end type

event clicked;//d_dddw_cntas_presupuestal

Long ll_count
sg_parametros sl_param 


delete from tt_man_cnta_prsp ;

sl_param.dw1		= 'd_dddw_cntas_presupuestal'
sl_param.titulo	= 'Cuenta Presupuestal'
sl_param.opcion   = 26
sl_param.db1 		= 1730
sl_param.string1 	= '1CTA'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cb_4 from commandbutton within w_ma704_rpt_costo_materiales
integer x = 2985
integer y = 20
integer width = 434
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Centro de Costo "
end type

event clicked;Long ll_count
sg_parametros sl_param 


delete from tt_man_cencos ;

	


sl_param.dw1		= 'd_dddw_cencos'
sl_param.titulo	= 'Centros de Costo'
sl_param.opcion   = 25
sl_param.db1 		= 1730
sl_param.string1 	= '1CCOS'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type gb_1 from groupbox within w_ma704_rpt_costo_materiales
integer x = 32
integer y = 12
integer width = 1454
integer height = 212
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Fechas"
end type

