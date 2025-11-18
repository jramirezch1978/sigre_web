$PBExportHeader$w_ma708_rpt_lab_pend_x_cc_bk.srw
forward
global type w_ma708_rpt_lab_pend_x_cc_bk from w_rpt_list
end type
type st_1 from statictext within w_ma708_rpt_lab_pend_x_cc_bk
end type
type rb_cc from radiobutton within w_ma708_rpt_lab_pend_x_cc_bk
end type
type uo_1 from u_ingreso_rango_fechas within w_ma708_rpt_lab_pend_x_cc_bk
end type
type gb_1 from groupbox within w_ma708_rpt_lab_pend_x_cc_bk
end type
end forward

global type w_ma708_rpt_lab_pend_x_cc_bk from w_rpt_list
integer height = 1884
string title = "Labores pendientes x centro de costos  / Taller (MA708)"
string menuname = "m_rpt_smpl"
st_1 st_1
rb_cc rb_cc
uo_1 uo_1
gb_1 gb_1
end type
global w_ma708_rpt_lab_pend_x_cc_bk w_ma708_rpt_lab_pend_x_cc_bk

type variables
String is_opcion

end variables

on w_ma708_rpt_lab_pend_x_cc_bk.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.st_1=create st_1
this.rb_cc=create rb_cc
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.rb_cc
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_ma708_rpt_lab_pend_x_cc_bk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.rb_cc)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;
// ii_help = 101           // help topic
idw_1 = dw_report
idw_1.Visible = False
//this.sle_ano.text=string(year(today()))
//this.sle_mes.text=string(month(today()))
is_opcion=''

end event

type dw_report from w_rpt_list`dw_report within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 14
integer y = 388
integer width = 3401
integer height = 1264
end type

type dw_1 from w_rpt_list`dw_1 within w_ma708_rpt_lab_pend_x_cc_bk
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

type pb_1 from w_rpt_list`pb_1 within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 1559
integer y = 916
end type

type pb_2 from w_rpt_list`pb_2 within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 1559
integer y = 1144
end type

type dw_2 from w_rpt_list`dw_2 within w_ma708_rpt_lab_pend_x_cc_bk
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

type cb_report from w_rpt_list`cb_report within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 2651
integer y = 224
end type

event cb_report::clicked;String ls_cnta_prsp, ls_descripcion, ls_cencos, ls_desc_cencos
Integer i
Long ll_count
Date ld_fini, ld_ffin

cb_report.enabled = false
rb_cc.enabled = false
dw_1.visible = false
dw_2.visible = false
pb_1.visible = false
pb_2.visible = false

delete from tt_man_cencos;
	
FOR i = 1 to dw_2.rowcount()
  	 ls_cencos = dw_2.object.cencos[i]
 	 ls_desc_cencos = dw_2.object.desc_cencos[i]
		 
 	 Insert into tt_man_cencos(cencos, desc_cencos) values ( :ls_cencos, :ls_desc_cencos);		
	 If sqlca.sqlcode = -1 then
		 messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 END IF

NEXT

idw_1.DataObject='d_rpt_lab_pend_x_cc_tbl'
idw_1.SetTransObject(sqlca)

// Leyendo fechas de objeto fecha
ld_fini = uo_1.of_get_fecha1()
ld_ffin = uo_1.of_get_fecha2()  
/*Eliminacion de Infomación Temporal*/
delete from tt_man_lab_pend_x_cencos ;
/**/
DECLARE PB_USP_MTT_RPT_VALORIZ_ART PROCEDURE FOR USP_MTT_LABORES_PEND_X_CC ( :ld_fini, :ld_ffin ) ;
execute PB_USP_MTT_RPT_VALORIZ_ART ;
		
IF sqlca.sqlcode = -1 THEN
   MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
   Return
ELSE
   MessageBox( 'Aviso', "Fin de proceso")
END IF

ls_descripcion = 'Del ' + string(ld_fini, 'dd/mm/yyyy') + ' al ' + string(ld_ffin, 'dd/mm/yyyy')
idw_1.retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_subtitulo.text = ls_descripcion

idw_1.visible=true
parent.event ue_preview()
rb_cc.enabled = true
cb_report.enabled = true
end event

type st_1 from statictext within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 905
integer y = 40
integer width = 1390
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Labores pendientes por centro de costo"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_cc from radiobutton within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 64
integer y = 248
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de costo"
end type

event clicked;is_opcion = '1' 
pb_1.visible = true
pb_2.visible = true
idw_1.Visible = False

// dw_1
dw_1.DataObject='d_dddw_cencos'
dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_1.visible = true
// dw_2
dw_2.DataObject='d_dddw_cencos'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true
end event

type uo_1 from u_ingreso_rango_fechas within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 846
integer y = 252
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

type gb_1 from groupbox within w_ma708_rpt_lab_pend_x_cc_bk
integer x = 23
integer y = 164
integer width = 2171
integer height = 200
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Seleccion"
end type

