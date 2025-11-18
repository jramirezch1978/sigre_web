$PBExportHeader$w_ve707_abc_clientes.srw
forward
global type w_ve707_abc_clientes from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ve707_abc_clientes
end type
type sle_2 from singlelineedit within w_ve707_abc_clientes
end type
type cbx_2 from checkbox within w_ve707_abc_clientes
end type
type st_1 from statictext within w_ve707_abc_clientes
end type
type em_porc_abc from editmask within w_ve707_abc_clientes
end type
type st_2 from statictext within w_ve707_abc_clientes
end type
type st_3 from statictext within w_ve707_abc_clientes
end type
type pb_1 from picturebutton within w_ve707_abc_clientes
end type
type gb_fechas from groupbox within w_ve707_abc_clientes
end type
type rb_texto from radiobutton within w_ve707_abc_clientes
end type
type rb_graf from radiobutton within w_ve707_abc_clientes
end type
type dw_grafico from u_dw_rpt within w_ve707_abc_clientes
end type
end forward

global type w_ve707_abc_clientes from w_report_smpl
integer width = 3657
integer height = 2248
string title = "ABC Clientes (VE707)"
string menuname = "m_reporte"
long backcolor = 67108864
uo_fecha uo_fecha
sle_2 sle_2
cbx_2 cbx_2
st_1 st_1
em_porc_abc em_porc_abc
st_2 st_2
st_3 st_3
pb_1 pb_1
gb_fechas gb_fechas
rb_texto rb_texto
rb_graf rb_graf
dw_grafico dw_grafico
end type
global w_ve707_abc_clientes w_ve707_abc_clientes

type variables
string is_doc_ov
end variables

on w_ve707_abc_clientes.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fecha=create uo_fecha
this.sle_2=create sle_2
this.cbx_2=create cbx_2
this.st_1=create st_1
this.em_porc_abc=create em_porc_abc
this.st_2=create st_2
this.st_3=create st_3
this.pb_1=create pb_1
this.gb_fechas=create gb_fechas
this.rb_texto=create rb_texto
this.rb_graf=create rb_graf
this.dw_grafico=create dw_grafico
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.sle_2
this.Control[iCurrent+3]=this.cbx_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.em_porc_abc
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.pb_1
this.Control[iCurrent+9]=this.gb_fechas
this.Control[iCurrent+10]=this.rb_texto
this.Control[iCurrent+11]=this.rb_graf
this.Control[iCurrent+12]=this.dw_grafico
end on

on w_ve707_abc_clientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.sle_2)
destroy(this.cbx_2)
destroy(this.st_1)
destroy(this.em_porc_abc)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_1)
destroy(this.gb_fechas)
destroy(this.rb_texto)
destroy(this.rb_graf)
destroy(this.dw_grafico)
end on

event ue_retrieve;//Ancestor Overriding
date 		ld_fecha1, ld_fecha2
string	ls_cod_art, ls_mensaje
decimal	ldc_porc_abc

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

if cbx_2.checked then
	ls_cod_art = trim(sle_2.text) + '%'
else
	ls_cod_art = '%%'
end if

ldc_porc_abc = dec(em_porc_abc.text)


DECLARE usp_vta_abc_clientes PROCEDURE FOR
	usp_ve_abc_clientes( :ld_fecha1,
								 :ld_fecha2,
								 :ldc_porc_abc,
								 :ls_cod_art );

EXECUTE usp_vta_abc_clientes;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_vta_abc_clientes:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return 
END IF

CLOSE usp_vta_abc_clientes;



idw_1.Retrieve()
dw_grafico.Retrieve()


idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_ventana.text 	= this.ClassName()
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.t_stitulo1.text 	= 'Desde ' + string(ld_Fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')

if ls_cod_art = '%%' then
	idw_1.Object.t_stitulo3.text 	= 'Todos los Articulos'	
else
	idw_1.Object.t_stitulo3.text 	= 'Articulo: ' + left(ls_cod_art, len(ls_cod_art) - 1) + '-' + st_1.text	
end if



if rb_graf.checked then
	dw_grafico.visible = true
	idw_1.visible		 = false
else
	dw_grafico.visible = false
	idw_1.visible		 = true
end if	
end event

event ue_open_pre;call super::ue_open_pre;select doc_ov into :is_doc_ov from logparam where reckey = '1';

idw_1.Visible = true
idw_1.ii_zoom_actual = 100
ib_preview = false
THIS.Event ue_preview()

dw_grafico.settransobject(sqlca)
dw_grafico.visible =  false

idw_1.object.datawindow.print.orientation = 2
end event

event resize;call super::resize;dw_grafico.width  = newwidth  - dw_grafico.x
dw_grafico.height = newheight - dw_grafico.y
end event

event ue_print;call super::ue_print;if rb_texto.checked then
	idw_1.EVENT ue_print()
else
	dw_grafico.EVENT ue_print()
end if	
end event

type dw_report from w_report_smpl`dw_report within w_ve707_abc_clientes
integer x = 0
integer y = 328
integer width = 3191
integer height = 1460
string dataobject = "d_rpt_abc_clientes"
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_ve707_abc_clientes
event destroy ( )
integer x = 50
integer y = 72
integer taborder = 20
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

event ue_output;call super::ue_output;//cb_seleccionar.enabled = true
end event

type sle_2 from singlelineedit within w_ve707_abc_clientes
event ue_dobleclick pbm_lbuttondblclk
integer x = 1042
integer y = 44
integer width = 430
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
date		ld_fecha1, ld_Fecha2

ld_fecha1 = uo_fecha.of_get_fecha1( )
ld_fecha2 = uo_fecha.of_get_fecha2( )

ls_sql = "SELECT DISTINCT A.COD_ART AS CODIGO, " 	&
		 + "A.DESC_ART AS DESCRIPCION " 			&
		 + "FROM ARTICULO A, " 						&
		 + "ARTICULO_MOV_PROY AMP, "				&
		 + "ORDEN_VENTA OV "							&
		 + "WHERE OV.NRO_OV = AMP.NRO_DOC " 	&
		 + "AND AMP.COD_ART = A.COD_ART " 		&
		 + "AND AMP.TIPO_dOC = '" + is_doc_ov + "' " &
		 + "AND AMP.FLAG_ESTADO <> '0' " 		&
		 + "AND OV.NRO_OV <> '0' " 				&
		 + "AND TO_CHAR(OV.FEC_REGISTRO, 'yyyymmdd') BETWEEN '" + string(ld_Fecha1, 'yyyymmdd') + "' and '" + string(ld_fecha2, 'yyyymmdd') + "'" 				
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

IF ls_codigo <> '' THEN
	st_1.text = ls_data
	this.text = ls_codigo
END IF
	

end event

event modified;string ls_desc, ls_cod

ls_cod = this.text

select desc_art
	into :ls_desc
from articulo
where cod_art = :ls_cod
  and flag_estado = '1';
 
if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Codigo de articulo no existe o no esta activo')
	this.text = ''
	return
end if

st_1.text = ls_desc

end event

type cbx_2 from checkbox within w_ve707_abc_clientes
integer x = 699
integer y = 48
integer width = 329
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
string text = "Articulo"
end type

event clicked;if this.checked then
	sle_2.enabled = true
else
	sle_2.enabled = false
end if
end event

type st_1 from statictext within w_ve707_abc_clientes
integer x = 1477
integer y = 44
integer width = 1403
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type em_porc_abc from editmask within w_ve707_abc_clientes
integer x = 1221
integer y = 176
integer width = 238
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "100"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
double increment = 1
string minmax = "0~~100"
end type

type st_2 from statictext within w_ve707_abc_clientes
integer x = 1445
integer y = 184
integer width = 119
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "%"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_ve707_abc_clientes
integer x = 731
integer y = 180
integer width = 471
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porcentaje ABC"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ve707_abc_clientes
integer x = 2926
integer y = 40
integer width = 306
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;decimal  ldc_porc



ldc_porc = dec(em_porc_abc.text)

IF ldc_porc = 0 OR ldc_porc < 1 THEN
	messagebox('Aviso','Por favor seleccione un porcentaje mayor')
	RETURN
END IF

parent.event ue_retrieve( )
end event

type gb_fechas from groupbox within w_ve707_abc_clientes
integer x = 23
integer y = 4
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type rb_texto from radiobutton within w_ve707_abc_clientes
integer x = 1701
integer y = 168
integer width = 402
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Texto"
boolean checked = true
end type

type rb_graf from radiobutton within w_ve707_abc_clientes
integer x = 2171
integer y = 168
integer width = 402
integer height = 68
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Grafico"
end type

type dw_grafico from u_dw_rpt within w_ve707_abc_clientes
integer y = 328
integer width = 3191
integer height = 1460
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_rpt_abc_clientes_p4"
end type

