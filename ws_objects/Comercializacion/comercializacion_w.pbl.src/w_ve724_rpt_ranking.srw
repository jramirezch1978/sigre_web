$PBExportHeader$w_ve724_rpt_ranking.srw
forward
global type w_ve724_rpt_ranking from w_rpt
end type
type rb_ambos from radiobutton within w_ve724_rpt_ranking
end type
type rb_dolares from radiobutton within w_ve724_rpt_ranking
end type
type rb_soles from radiobutton within w_ve724_rpt_ranking
end type
type st_nom_art from statictext within w_ve724_rpt_ranking
end type
type sle_1 from singlelineedit within w_ve724_rpt_ranking
end type
type cb_2 from commandbutton within w_ve724_rpt_ranking
end type
type rb_2 from radiobutton within w_ve724_rpt_ranking
end type
type rb_1 from radiobutton within w_ve724_rpt_ranking
end type
type cbx_1 from checkbox within w_ve724_rpt_ranking
end type
type dw_arg from datawindow within w_ve724_rpt_ranking
end type
type dw_report from u_dw_rpt within w_ve724_rpt_ranking
end type
type cb_1 from commandbutton within w_ve724_rpt_ranking
end type
type gb_1 from groupbox within w_ve724_rpt_ranking
end type
type gb_2 from groupbox within w_ve724_rpt_ranking
end type
type gb_3 from groupbox within w_ve724_rpt_ranking
end type
type gb_4 from groupbox within w_ve724_rpt_ranking
end type
type gb_5 from groupbox within w_ve724_rpt_ranking
end type
end forward

global type w_ve724_rpt_ranking from w_rpt
integer width = 3607
integer height = 1452
string title = "[VE724] Reporte de Ranking"
string menuname = "m_reporte"
long backcolor = 12632256
rb_ambos rb_ambos
rb_dolares rb_dolares
rb_soles rb_soles
st_nom_art st_nom_art
sle_1 sle_1
cb_2 cb_2
rb_2 rb_2
rb_1 rb_1
cbx_1 cbx_1
dw_arg dw_arg
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
end type
global w_ve724_rpt_ranking w_ve724_rpt_ranking

type variables
str_seleccionar istr_seleccionar
String is_und_art
end variables

on w_ve724_rpt_ranking.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_ambos=create rb_ambos
this.rb_dolares=create rb_dolares
this.rb_soles=create rb_soles
this.st_nom_art=create st_nom_art
this.sle_1=create sle_1
this.cb_2=create cb_2
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cbx_1=create cbx_1
this.dw_arg=create dw_arg
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ambos
this.Control[iCurrent+2]=this.rb_dolares
this.Control[iCurrent+3]=this.rb_soles
this.Control[iCurrent+4]=this.st_nom_art
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.dw_arg
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_3
this.Control[iCurrent+16]=this.gb_4
this.Control[iCurrent+17]=this.gb_5
end on

on w_ve724_rpt_ranking.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_ambos)
destroy(this.rb_dolares)
destroy(this.rb_soles)
destroy(this.st_nom_art)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cbx_1)
destroy(this.dw_arg)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
end on

event ue_open_pre();call super::ue_open_pre;//idw_1 = dw_report
//idw_1.Visible = TRUE
//idw_1.SetTransObject(sqlca)
//ib_preview = FALSE
//THIS.Event ue_preview()
////
//
// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type rb_ambos from radiobutton within w_ve724_rpt_ranking
integer x = 2405
integer y = 324
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambos"
end type

type rb_dolares from radiobutton within w_ve724_rpt_ranking
integer x = 2405
integer y = 240
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dolares"
end type

type rb_soles from radiobutton within w_ve724_rpt_ranking
integer x = 2405
integer y = 160
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Soles"
end type

type st_nom_art from statictext within w_ve724_rpt_ranking
integer x = 814
integer y = 392
integer width = 1079
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_ve724_rpt_ranking
integer x = 453
integer y = 380
integer width = 343
integer height = 84
integer taborder = 120
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ve724_rpt_ranking
integer x = 82
integer y = 376
integer width = 352
integer height = 92
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Producto"
end type

event clicked;String ls_name,ls_prot,ls_flag_transp, ls_descri1, ls_codigo
Long   ll_row_master
str_seleccionar lstr_seleccionar
Datawindow ldw

	   lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO, '&   
											  +'ARTICULO.NOM_ARTICULO  AS DESCRIPCION '& 
											  +'FROM ARTICULO WHERE '&
											  +'ARTICULO.COD_CLASE=07'											  
				 OpenWithParm(w_seleccionar,lstr_seleccionar)
				 IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				 IF lstr_seleccionar.s_action = "aceptar" THEN
					sle_1.text = lstr_seleccionar.param1[1]
					ls_codigo = lstr_seleccionar.param1[1]
                       Select nom_articulo,und  into :ls_descri1,:is_und_art from articulo where cod_art = :ls_codigo;
					st_nom_art.text = ls_descri1
				END IF
return 1			


end event

type rb_2 from radiobutton within w_ve724_rpt_ranking
integer x = 1957
integer y = 284
integer width = 398
integer height = 72
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Compradores"
end type

type rb_1 from radiobutton within w_ve724_rpt_ranking
integer x = 1957
integer y = 176
integer width = 343
integer height = 72
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clientes"
end type

type cbx_1 from checkbox within w_ve724_rpt_ranking
integer x = 1234
integer y = 96
integer width = 539
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
end type

type dw_arg from datawindow within w_ve724_rpt_ranking
integer x = 69
integer y = 108
integer width = 951
integer height = 272
integer taborder = 10
string title = "none"
string dataobject = "d_ext_fechas_origen_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()
end event

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'ad_fecha_inicio'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'ad_fecha_final'				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)					
							
END CHOOSE


end event

type dw_report from u_dw_rpt within w_ve724_rpt_ranking
integer x = 32
integer y = 520
integer width = 3511
integer height = 844
integer taborder = 120
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_ve724_rpt_ranking
integer x = 2811
integer y = 56
integer width = 613
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_cod_origen, ls_cod_art, ls_moneda

dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]
ls_cod_origen   = dw_arg.object.cod_origen	   [1]
ls_cod_art = sle_1.text


IF rb_1.checked = FALSE and rb_2.checked = FALSE  THEN
	messagebox('Advertencia','Debe Seleccionar un tipo de Ranking')
	Return
END IF

IF cbx_1.CHECKED THEN
	ls_cod_origen = '%'
ELSE
	IF Isnull(ls_cod_origen) OR Trim(ls_cod_origen) = '' THEN
		Messagebox('Aviso','Debe Ingresar Codigo de Origen , Verifique!')
		Return
	ELSE
		ls_cod_origen = ls_cod_origen+'%'
	END IF
END IF

IF rb_soles.checked = FALSE and rb_dolares.checked = FALSE and rb_ambos.checked = FALSE THEN
	messagebox('Advertencia','Debe Seleccionar un tipo de Moneda')
	Return
END IF
IF rb_soles.checked = TRUE THEN
	ls_moneda = 'S'
END IF
IF rb_dolares.checked = TRUE THEN
	ls_moneda = 'D'
END IF
IF rb_ambos.checked = TRUE THEN
	ls_moneda = 'A'
END IF

// Selecciona tipo de ranking
IF rb_1.checked = TRUE  THEN
    DECLARE PB_usp_fin_ranking_clientes PROCEDURE FOR usp_fin_ranking_clientes(:ld_fecha_inicio, :ld_fecha_final , :ls_cod_art, :ls_cod_origen,:ls_moneda ) ;
    EXECUTE PB_usp_fin_ranking_clientes ;
    IF sqlca.sqlcode = -1 THEN
       MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
       MessageBox( 'Error', "Procedimiento <<usp_fin_ranking_clientes>> no concluyo correctamente", StopSign! )
    ELSE
     //	MessageBox( 'Mensaje', "Proceso terminado" )
    END IF
    Close PB_usp_fin_ranking_clientes ;
	dw_report.DataObject = 'd_rpt_ranking_clientes'

ELSEIF rb_2.checked = TRUE  THEN

    DECLARE PB_usp_fin_ranking_compra PROCEDURE FOR usp_fin_ranking_compra(:ld_fecha_inicio, :ld_fecha_final , :ls_cod_art, :ls_cod_origen,:ls_moneda ) ;
    EXECUTE PB_usp_fin_ranking_compra ;
    IF sqlca.sqlcode = -1 THEN
       MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
       MessageBox( 'Error', "Procedimiento <<usp_fin_ranking_compra>> no concluyo correctamente", StopSign! )
    ELSE
     //	MessageBox( 'Mensaje', "Proceso terminado" )
    END IF
    Close PB_usp_fin_ranking_compra ;
	dw_report.DataObject = 'd_rpt_ranking_compradores'
END IF

idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
Parent.Event ue_preview()
dw_report.Retrieve( )
dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_empresa.text = gs_empresa
dw_report.Object.t_user.text = gs_user
dw_report.Object.t_fechas.text = 'Del: ' + string(ld_fecha_inicio,'dd/mm/yyyy') + ' Al ' + String(ld_fecha_final,'dd/mm/yyyy')
dw_report.Object.t_producto.text = Trim(St_nom_art.text) + ' - ' + trim(is_und_art) + ' ( ' + Trim(sle_1.text) + ' ) '
dw_report.Object.t_unidad.text =  trim(is_und_art) 

end event

type gb_1 from groupbox within w_ve724_rpt_ranking
integer x = 41
integer y = 32
integer width = 1893
integer height = 468
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

type gb_2 from groupbox within w_ve724_rpt_ranking
integer x = 1938
integer y = 28
integer width = 430
integer height = 476
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ranking"
end type

type gb_3 from groupbox within w_ve724_rpt_ranking
integer x = 1216
integer y = 200
integer width = 480
integer height = 400
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type gb_4 from groupbox within w_ve724_rpt_ranking
integer x = 1275
integer y = 204
integer width = 480
integer height = 400
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type gb_5 from groupbox within w_ve724_rpt_ranking
integer x = 2373
integer y = 32
integer width = 416
integer height = 472
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
end type

