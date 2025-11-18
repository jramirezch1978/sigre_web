$PBExportHeader$w_pt706_ejecucion_anual.srw
$PBExportComments$Detalle de ejecucion mensual
forward
global type w_pt706_ejecucion_anual from w_report_smpl
end type
type em_ano from editmask within w_pt706_ejecucion_anual
end type
type st_3 from statictext within w_pt706_ejecucion_anual
end type
type cb_1 from commandbutton within w_pt706_ejecucion_anual
end type
type rb_1 from radiobutton within w_pt706_ejecucion_anual
end type
type rb_2 from radiobutton within w_pt706_ejecucion_anual
end type
type rb_cencos_all from radiobutton within w_pt706_ejecucion_anual
end type
type rb_5 from radiobutton within w_pt706_ejecucion_anual
end type
type st_2 from statictext within w_pt706_ejecucion_anual
end type
type sle_moneda from singlelineedit within w_pt706_ejecucion_anual
end type
type gb_1 from groupbox within w_pt706_ejecucion_anual
end type
type gb_5 from groupbox within w_pt706_ejecucion_anual
end type
type gb_2 from groupbox within w_pt706_ejecucion_anual
end type
end forward

global type w_pt706_ejecucion_anual from w_report_smpl
integer width = 3566
integer height = 1652
string title = "Ejecucion presupuestal - Anual (PT706)"
string menuname = "m_impresion"
em_ano em_ano
st_3 st_3
cb_1 cb_1
rb_1 rb_1
rb_2 rb_2
rb_cencos_all rb_cencos_all
rb_5 rb_5
st_2 st_2
sle_moneda sle_moneda
gb_1 gb_1
gb_5 gb_5
gb_2 gb_2
end type
global w_pt706_ejecucion_anual w_pt706_ejecucion_anual

type variables
Integer   ii_zoom_actual = 80, ii_zi = 10, ii_sort = 0
String  	is_nivelcc, is_nivelcp

end variables

on w_pt706_ejecucion_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.st_3=create st_3
this.cb_1=create cb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_cencos_all=create rb_cencos_all
this.rb_5=create rb_5
this.st_2=create st_2
this.sle_moneda=create sle_moneda
this.gb_1=create gb_1
this.gb_5=create gb_5
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_cencos_all
this.Control[iCurrent+7]=this.rb_5
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.sle_moneda
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_5
this.Control[iCurrent+12]=this.gb_2
end on

on w_pt706_ejecucion_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.cb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_cencos_all)
destroy(this.rb_5)
destroy(this.st_2)
destroy(this.sle_moneda)
destroy(this.gb_1)
destroy(this.gb_5)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;em_ano.text = string(gnvo_app.of_fecha_Actual(), 'yyyy')

sle_moneda.text = gnvo_app.is_soles
end event

type dw_report from w_report_smpl`dw_report within w_pt706_ejecucion_anual
integer x = 0
integer y = 200
integer width = 2030
integer height = 1196
string dataobject = "d_rpt_ejecucion_anual"
end type

type em_ano from editmask within w_pt706_ejecucion_anual
integer x = 265
integer y = 72
integer width = 247
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_3 from statictext within w_pt706_ejecucion_anual
integer x = 55
integer y = 88
integer width = 160
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pt706_ejecucion_anual
integer x = 2821
integer y = 72
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Reporte"
end type

event clicked;Long		ll_year
string 	ls_mensaje, ls_moneda

ll_year = Long(em_ano.text)
ls_moneda = sle_moneda.text

if rb_2.checked then
	// Inserta todos los registros en tabla temporal

	Delete from TT_PTO_TIPO_PRTDA;
	
	insert into TT_PTO_TIPO_PRTDA ( TIPO_PRTDA_PRSP ) 
	  SELECT distinct
         tpd.tipo_prtda_prsp
    FROM presupuesto_ejec pe,
         presupuesto_partida pp,
         tipo_prtda_prsp_det tpd
   WHERE pe.ano              = pp.ano
     and pe.cencos           = pp.cencos
     and pe.cnta_prsp        = pp.cnta_prsp
     and pp.tipo_prtda_prsp  = tpd.tipo_prtda_prsp
     and pp.ano              = :ll_year;            
	
	if sqlca.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha sucedido un error al insertar un registro en TT_PTO_TIPO_PRTDA. Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	Commit;
	
end if


if rb_cencos_all.checked then
	// Inserta todos los registros en tabla temporal

	Delete from TT_PTO_SELECCION;
	
	insert into TT_PTO_SELECCION(cencos)
	  SELECT DISTINCT 
         pe.CENCOS 
    FROM presupuesto_ejec     pe,
         presupuesto_partida  pp,
         CENTROS_COSTO        cc,
         tt_pto_tipo_prtda    tt
   WHERE pe.ano       = pp.ano
     and pe.cencos    = pp.cencos
     and pe.cnta_prsp = pp.cnta_prsp
     and pe.CENCOS    = cc.CENCOS 
     and pe.ANO       = :ll_year 
     and pp.tipo_prtda_prsp = tt.tipo_prtda_prsp;
	
	if sqlca.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha sucedido un error al insertar un registro en TT_PTO_SELECCION. Mensaje: ' + ls_mensaje, StopSign!)
		return 
	end if
	
	Commit;
	
end if



Setpointer(hourglass!)   

dw_report.SetTransObject(sqlca)
dw_report.retrieve(ll_year, ls_moneda)

dw_report.object.datawindow.print.orientation = 1
dw_report.visible = true

dw_report.object.t_titulo1.text = 'Año: ' + em_ano.text
dw_report.object.t_titulo2.text = 'Moneda: ' + sle_moneda.text

dw_report.object.t_usuario.text = gs_user
dw_report.Object.p_logo.filename = gs_logo
end event

type rb_1 from radiobutton within w_pt706_ejecucion_anual
integer x = 873
integer y = 84
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Long ll_count
str_parametros lstr_param

// Asigna valores a structura 
lstr_param.dw_master = 'd_lista_tipo_prtda_prsp_year_tbl'
lstr_param.dw1 	= "d_lista_tipo_prtda_prsp_det_year_tbl"
lstr_param.titulo = "Tipos de Partidas Presupuestales"
lstr_param.opcion = 1
lstr_param.tipo 	= '1L'
lstr_param.long1	= Long(em_ano.text)

OpenWithParm( w_abc_seleccion_md, lstr_param)

select count(*)
  into :ll_count
  from tt_pto_tipo_prtda;

if ll_count = 0 then
	this.checked = false
	return
end if
end event

type rb_2 from radiobutton within w_pt706_ejecucion_anual
integer x = 603
integer y = 84
integer width = 270
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

type rb_cencos_all from radiobutton within w_pt706_ejecucion_anual
integer x = 1312
integer y = 84
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

type rb_5 from radiobutton within w_pt706_ejecucion_anual
integer x = 1582
integer y = 84
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona"
end type

event clicked;Long ll_year
str_parametros lstr_param

ll_year = Long(em_ano.text)

if rb_2.checked then
	// Inserta todos los registros en tabla temporal

	Delete from TT_PTO_TIPO_PRTDA;
	
	insert into TT_PTO_TIPO_PRTDA ( TIPO_PRTDA_PRSP ) 
	  SELECT distinct
         tpd.tipo_prtda_prsp
    FROM presupuesto_ejec pe,
         presupuesto_partida pp,
         tipo_prtda_prsp_det tpd
   WHERE pe.ano              = pp.ano
     and pe.cencos           = pp.cencos
     and pe.cnta_prsp        = pp.cnta_prsp
     and pp.tipo_prtda_prsp  = tpd.tipo_prtda_prsp
     and pp.ano              = :ll_year;            
	
	Commit;
	
end if

lstr_param.titulo 	= "Centros de costo"
lstr_param.dw1 		= "d_lista_presup_partida_cencos_ano_all"		
lstr_param.opcion 	= 2
lstr_param.tipo 		= '1L1S'
lstr_param.long1		= ll_year
lstr_param.string1 	= '%%'

OpenWithParm( w_abc_seleccion_lista_search, lstr_param)
end event

type st_2 from statictext within w_pt706_ejecucion_anual
integer x = 2016
integer y = 84
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type sle_moneda from singlelineedit within w_pt706_ejecucion_anual
event dobleclick pbm_lbuttondblclk
integer x = 2299
integer y = 76
integer width = 288
integer height = 80
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_moneda as codigo_moneda, "&
			+"m.descripcion as descripcion_moneda "&
  			+"from moneda m Where m.flag_estado = 1"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type gb_1 from groupbox within w_pt706_ejecucion_anual
integer width = 544
integer height = 192
integer taborder = 90
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

type gb_5 from groupbox within w_pt706_ejecucion_anual
integer x = 1280
integer width = 713
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costos"
end type

type gb_2 from groupbox within w_pt706_ejecucion_anual
integer x = 553
integer width = 713
integer height = 192
integer taborder = 100
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Prtda Prsp"
end type

