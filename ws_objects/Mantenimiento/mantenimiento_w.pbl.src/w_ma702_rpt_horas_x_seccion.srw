$PBExportHeader$w_ma702_rpt_horas_x_seccion.srw
forward
global type w_ma702_rpt_horas_x_seccion from w_rpt_list
end type
type rb_tall_dma from radiobutton within w_ma702_rpt_horas_x_seccion
end type
type rb_tall_fab from radiobutton within w_ma702_rpt_horas_x_seccion
end type
type uo_1 from u_ingreso_rango_fechas within w_ma702_rpt_horas_x_seccion
end type
type gb_1 from groupbox within w_ma702_rpt_horas_x_seccion
end type
end forward

global type w_ma702_rpt_horas_x_seccion from w_rpt_list
integer width = 3433
integer height = 2008
string title = "Horas trabajadas por seccion (MA702)"
string menuname = "m_rpt_smpl"
rb_tall_dma rb_tall_dma
rb_tall_fab rb_tall_fab
uo_1 uo_1
gb_1 gb_1
end type
global w_ma702_rpt_horas_x_seccion w_ma702_rpt_horas_x_seccion

type variables
String is_opcion
end variables

on w_ma702_rpt_horas_x_seccion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_tall_dma=create rb_tall_dma
this.rb_tall_fab=create rb_tall_fab
this.uo_1=create uo_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_tall_dma
this.Control[iCurrent+2]=this.rb_tall_fab
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_ma702_rpt_horas_x_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_tall_dma)
destroy(this.rb_tall_fab)
destroy(this.uo_1)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
rb_tall_dma.enabled = true
is_opcion = 'D'
end event

event resize;call super::resize;
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type dw_report from w_rpt_list`dw_report within w_ma702_rpt_horas_x_seccion
integer x = 50
integer y = 260
integer width = 3323
integer height = 1552
string dataobject = "d_rpt_horas_x_seccion"
end type

type dw_1 from w_rpt_list`dw_1 within w_ma702_rpt_horas_x_seccion
integer x = 46
integer y = 268
integer width = 1509
integer height = 1156
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_rpt_list`pb_1 within w_ma702_rpt_horas_x_seccion
integer x = 1586
integer y = 624
end type

type pb_2 from w_rpt_list`pb_2 within w_ma702_rpt_horas_x_seccion
integer x = 1582
integer y = 936
end type

type dw_2 from w_rpt_list`dw_2 within w_ma702_rpt_horas_x_seccion
integer x = 1774
integer y = 272
integer width = 1509
integer height = 1156
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_report from w_rpt_list`cb_report within w_ma702_rpt_horas_x_seccion
integer x = 3031
integer y = 72
integer width = 270
integer textsize = -8
string text = "Generar"
end type

event cb_report::clicked;Long i,ll_count
Date ld_fini, ld_ffin
String ls_cencos, ls_desc_cencos

ld_fini = uo_1.of_get_fecha1()
ld_ffin = uo_1.of_get_fecha2()  

dw_1.visible = false
dw_2.visible = false
pb_1.visible = false
pb_2.visible = false

delete from tt_man_cencos;
FOR i = 1 to dw_2.rowcount()
	 // Captura data llenar archivo temporal
	 ls_cencos  		= dw_2.object.cencos[i]
	 // Captura descripcion de centro de costo
	 select desc_cencos 
	 into :ls_desc_cencos 
	 from centros_costo 
	 where cencos=:ls_cencos ;
 	 //ls_desc_cencos 	= dw_2.object.desc_cencos[i]
    // Inserta datos en archivo temporal
	 Insert into tt_man_cencos(cencos, desc_cencos) values ( :ls_cencos, :ls_desc_cencos);		
	 If sqlca.sqlcode = -1 then
		 messagebox("Error al insertar registro",sqlca.sqlerrtext)
 	 END IF

NEXT	
select count(*) into :ll_count from tt_man_cencos ;
messagebox('ll_count',ll_count)

DECLARE pb_usp_man_horas_x_seccion PROCEDURE FOR usp_man_horas_x_seccion(  
   	        :ld_fini,:ld_ffin);

EXECUTE pb_usp_man_horas_x_seccion;	
	
IF SQLCA.sqlcode = -1 THEN
	Rollback;
  	Messagebox("Error","Store Procedure usp_man_horas_x_seccion No Funciona!")
ELSE
	dw_report.DataObject='d_rpt_horas_x_seccion'
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve(ld_fini, ld_ffin)
	
	dw_report.visible = true
	ib_preview = FALSE
	parent.event ue_preview()
END IF
end event

type rb_tall_dma from radiobutton within w_ma702_rpt_horas_x_seccion
integer x = 59
integer y = 64
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Talleres DMA"
end type

event clicked;is_opcion = 'D'
idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true

// dw_1
dw_1.DataObject='d_dddw_cc_dma_tbl'
dw_1.SetTransObject(sqlca)
dw_1.retrieve('TALL_DMA')
dw_1.visible = true
// dw_2
dw_2.DataObject='d_dddw_cc_dma_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type rb_tall_fab from radiobutton within w_ma702_rpt_horas_x_seccion
integer x = 64
integer y = 152
integer width = 457
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Talleres fabrica"
end type

event clicked;is_opcion = 'F'
idw_1 = dw_report
idw_1.Visible = False
pb_1.visible = true
pb_2.visible = true
// dw_1
dw_1.DataObject='d_dddw_cc_dma_tbl'
dw_1.SetTransObject(sqlca)
dw_1.retrieve('TALL_FAB')
dw_1.visible = true
// dw_2
dw_2.DataObject='d_dddw_cc_dma_tbl'
dw_2.SetTransObject(sqlca)
//dw_2.retrieve()
dw_2.visible = true

end event

type uo_1 from u_ingreso_rango_fechas within w_ma702_rpt_horas_x_seccion
integer x = 690
integer y = 52
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // Titulo de botones
of_set_fecha(today(), today()) // Datos por defecto
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type gb_1 from groupbox within w_ma702_rpt_horas_x_seccion
integer x = 55
integer y = 8
integer width = 535
integer height = 228
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
borderstyle borderstyle = styleraised!
end type

