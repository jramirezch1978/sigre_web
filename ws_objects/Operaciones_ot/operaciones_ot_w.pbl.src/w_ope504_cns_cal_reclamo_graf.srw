$PBExportHeader$w_ope504_cns_cal_reclamo_graf.srw
forward
global type w_ope504_cns_cal_reclamo_graf from w_cns
end type
type sle_valor from singlelineedit within w_ope504_cns_cal_reclamo_graf
end type
type cb_generar from commandbutton within w_ope504_cns_cal_reclamo_graf
end type
type uo_1 from u_ingreso_rango_fechas within w_ope504_cns_cal_reclamo_graf
end type
type rb_cli from radiobutton within w_ope504_cns_cal_reclamo_graf
end type
type rb_rec from radiobutton within w_ope504_cns_cal_reclamo_graf
end type
type rb_clirec from radiobutton within w_ope504_cns_cal_reclamo_graf
end type
type st_1 from statictext within w_ope504_cns_cal_reclamo_graf
end type
type dw_master from u_dw_cns within w_ope504_cns_cal_reclamo_graf
end type
type gb_1 from groupbox within w_ope504_cns_cal_reclamo_graf
end type
end forward

global type w_ope504_cns_cal_reclamo_graf from w_cns
integer width = 2885
integer height = 1848
string title = "Consulta de reclamos de calidad"
string menuname = "m_grafico_reporte"
sle_valor sle_valor
cb_generar cb_generar
uo_1 uo_1
rb_cli rb_cli
rb_rec rb_rec
rb_clirec rb_clirec
st_1 st_1
dw_master dw_master
gb_1 gb_1
end type
global w_ope504_cns_cal_reclamo_graf w_ope504_cns_cal_reclamo_graf

type variables
str_cns_pop istr_1
//str_sig713_grf_pop istr_2
String  		is_column, is_argname[]
Integer		ii_grf_val_index
end variables

on w_ope504_cns_cal_reclamo_graf.create
int iCurrent
call super::create
if this.MenuName = "m_grafico_reporte" then this.MenuID = create m_grafico_reporte
this.sle_valor=create sle_valor
this.cb_generar=create cb_generar
this.uo_1=create uo_1
this.rb_cli=create rb_cli
this.rb_rec=create rb_rec
this.rb_clirec=create rb_clirec
this.st_1=create st_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_valor
this.Control[iCurrent+2]=this.cb_generar
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.rb_cli
this.Control[iCurrent+5]=this.rb_rec
this.Control[iCurrent+6]=this.rb_clirec
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
end on

on w_ope504_cns_cal_reclamo_graf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_valor)
destroy(this.cb_generar)
destroy(this.uo_1)
destroy(this.rb_cli)
destroy(this.rb_rec)
destroy(this.rb_clirec)
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event open;// override

THIS.EVENT ue_open_pre()

end event

event resize;call super::resize;dw_master.width  = newwidth - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

//RETURN ll_rc
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
idw_1 = dw_master
end event

event ue_retrieve_list;call super::ue_retrieve_list;Date ld_fec_ini, ld_fec_fin
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()  

SetPointer(hourglass!)
cb_generar.enabled = false

IF rb_cli.checked = true then
	idw_1.DataObject='d_cal_reclamo_cliente_grf'
ELSEIF rb_rec.checked = true then
	idw_1.DataObject='d_cal_tipo_reclamo_grf'
ELSEIF rb_clirec.checked = true then
	idw_1.DataObject='d_cal_reclamo_cliente_x_tipo_grf'
ELSE
	messagebox('Aviso','Seleccione correctamente opción a consultar')
	return
END IF

idw_1.SetTransObject(sqlca)
idw_1.retrieve(ld_fec_ini, ld_fec_fin)

//idw_1.Object.t_texto.text = 'Del ' + string(ld_fini, 'dd/mm/yyyy') + ' al ' + string(ld_ffin, 'dd/mm/yyyy')
//idw_1.Object.p_logo.filename = gs_logo
SetPointer(Arrow!)
//Parent.SetRedraw(TRUE)

//ib_preview = false
idw_1.visible=true
//idw_1.ii_zoom_actual = 100
//parent.event ue_preview()
cb_generar.enabled = true

end event

type sle_valor from singlelineedit within w_ope504_cns_cal_reclamo_graf
integer x = 978
integer y = 448
integer width = 402
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_generar from commandbutton within w_ope504_cns_cal_reclamo_graf
integer x = 2341
integer y = 232
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;parent.event ue_retrieve_list()


end event

type uo_1 from u_ingreso_rango_fechas within w_ope504_cns_cal_reclamo_graf
integer x = 846
integer y = 240
integer taborder = 20
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type rb_cli from radiobutton within w_ope504_cns_cal_reclamo_graf
integer x = 87
integer y = 180
integer width = 672
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x cliente"
end type

type rb_rec from radiobutton within w_ope504_cns_cal_reclamo_graf
integer x = 87
integer y = 256
integer width = 672
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x tipo de reclamo"
end type

type rb_clirec from radiobutton within w_ope504_cns_cal_reclamo_graf
integer x = 87
integer y = 332
integer width = 672
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x cliente y tipo de reclamo"
end type

type st_1 from statictext within w_ope504_cns_cal_reclamo_graf
integer x = 142
integer y = 48
integer width = 878
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consulta de reclamos de calidad"
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_ope504_cns_cal_reclamo_graf
integer x = 46
integer y = 556
integer width = 2766
integer height = 1160
string dataobject = "d_cal_reclamo_cliente_grf"
end type

event constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event doubleclicked;call super::doubleclicked;/*
grObjectType	lgr_click_obj
string			ls_grgraphname="gr_1", ls_find, ls_category 
String			ls_dato, ls_work, ls_temp
int				li_series, li_category
Long				ll_rc, ll_row, ll_plantas
Decimal			ldc_total

// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, &
						li_category)
// Determinar que categoria se Clicko
IF lgr_click_obj = TypeData!  or lgr_click_obj = TypeCategory!  then
	IF istr_1.nextcol <> '' THEN
		ls_dato = this.CategoryName (ls_grgraphname, li_category)
		ls_category = THIS.Describe(ls_grgraphname + '.Category')
		ls_work = THIS.Describe(ls_grgraphname + '.Values')
		ls_dato = Trim(ls_dato)
		ls_find = ls_category + " = '" + ls_dato + "'"
		ll_row = THIS.Find(ls_find, 1, THIS.RowCount())
		IF ll_row < 1 THEN
			MessageBox('Error ' + ls_dato, 'No se pudo encontrar el dato')
		ELSE
			istr_1.Arg[1] = ls_dato
			of_new_sheet(istr_1)
		END IF
	END IF
End If
*/
end event

type gb_1 from groupbox within w_ope504_cns_cal_reclamo_graf
integer x = 41
integer y = 128
integer width = 745
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

