$PBExportHeader$w_al721_rpt_prod_azucar_hora.srw
forward
global type w_al721_rpt_prod_azucar_hora from w_report_smpl
end type
type cb_generar from commandbutton within w_al721_rpt_prod_azucar_hora
end type
type uo_1 from u_ingreso_rango_fechas_horas within w_al721_rpt_prod_azucar_hora
end type
type sle_almacen from singlelineedit within w_al721_rpt_prod_azucar_hora
end type
type pb_1 from picturebutton within w_al721_rpt_prod_azucar_hora
end type
type sle_descrip from singlelineedit within w_al721_rpt_prod_azucar_hora
end type
type st_1 from statictext within w_al721_rpt_prod_azucar_hora
end type
type gb_1 from groupbox within w_al721_rpt_prod_azucar_hora
end type
end forward

global type w_al721_rpt_prod_azucar_hora from w_report_smpl
integer width = 3506
integer height = 1828
string title = "Producción de azúcar  por hora (AL721)"
string menuname = "m_impresion"
long backcolor = 12632256
cb_generar cb_generar
uo_1 uo_1
sle_almacen sle_almacen
pb_1 pb_1
sle_descrip sle_descrip
st_1 st_1
gb_1 gb_1
end type
global w_al721_rpt_prod_azucar_hora w_al721_rpt_prod_azucar_hora

type variables
String is_almacen, is_tipo_mov
end variables

on w_al721_rpt_prod_azucar_hora.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_generar=create cb_generar
this.uo_1=create uo_1
this.sle_almacen=create sle_almacen
this.pb_1=create pb_1
this.sle_descrip=create sle_descrip
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_generar
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.gb_1
end on

on w_al721_rpt_prod_azucar_hora.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_generar)
destroy(this.uo_1)
destroy(this.sle_almacen)
destroy(this.pb_1)
destroy(this.sle_descrip)
destroy(this.st_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;// ii_help = 101           // help topic
String ls_desc_almacen

Select l.almacen_pptt
  into :is_almacen
  from labparam l 
 where reckey = '1';

sle_almacen.text=is_almacen
sle_descrip.text=ls_desc_almacen

select oper_ing_prod into :is_tipo_mov from logparam where reckey='1' ;

end event

event ue_retrieve;call super::ue_retrieve;Date ld_fecini, ld_fecfin
DateTime ldt_fecha1, ldt_fecha2
String ls_texto, ls_almacen, ls_tipo_mov

SetPointer(hourGlass!)

ldt_fecha1=uo_1.of_get_fecha1()
ldt_fecha2=uo_1.of_get_fecha2()
ls_texto = 'Del ' + string(ldt_fecha1, 'dd/mm/yyyy hh:mm:ss') + ' al ' + string(ldt_fecha2, 'dd/mm/yyyy hh:mm:ss')

IF Isnull(ldt_fecha1) OR Isnull(ldt_fecha2) THEN
	Messagebox('Aviso','Fechas nulas a procesar')	
	Return
END IF	

cb_generar.enabled = false

DECLARE PB_USP_ALM_PROD_AZUC_HORA PROCEDURE FOR USP_ALM_PROD_AZUC_HORA('PP01', 'I03', :ldt_fecha1,:ldt_fecha2);
EXECUTE PB_USP_ALM_PROD_AZUC_HORA ;	

/*	
if sqlca.sqlcode = -1 Then
	rollback ;
	MessageBox( 'Error', sqlca.sqlerrtext, StopSign! )
	return
End If
*/

//idw_1.DataObject='d_cns_prod_azucar_hora_cst'
idw_1.DataObject='d_cns_prod_azuc_hora_cst'

idw_1.SetTransObject(sqlca)

idw_1.ii_zoom_actual = 100

idw_1.retrieve(ldt_fecha1,ldt_fecha2)
idw_1.Object.p_logo.filename = gs_logo
//idw_1.Object.t_empresa.text = gs_empresa
//idw_1.Object.t_user.text = gs_user
//idw_1.Object.t_texto.text = ls_texto
//idw_1.retrieve()

ib_preview = FALSE
THIS.Event ue_preview()

idw_1.Visible = true

SetPointer(Arrow!)

cb_generar.enabled = true

end event

type dw_report from w_report_smpl`dw_report within w_al721_rpt_prod_azucar_hora
integer x = 14
integer y = 392
integer width = 3438
integer height = 1220
string dataobject = "d_rpt_frente_cosecha"
end type

type cb_generar from commandbutton within w_al721_rpt_prod_azucar_hora
integer x = 2231
integer y = 128
integer width = 343
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;Parent.TriggerEvent('ue_retrieve')

end event

type uo_1 from u_ingreso_rango_fechas_horas within w_al721_rpt_prod_azucar_hora
integer x = 105
integer y = 228
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(DateTime('01/01/1900'), DateTime('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900')) // rango inicial
of_set_rango_fin(datetime('31/12/9999')) // rango final
end event

on uo_1.destroy
call u_ingreso_rango_fechas_horas::destroy
end on

type sle_almacen from singlelineedit within w_al721_rpt_prod_azucar_hora
integer x = 430
integer y = 104
integer width = 302
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_al721_rpt_prod_azucar_hora
integer x = 759
integer y = 100
integer width = 128
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\Source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String 	ls_data, ls_sql, ls_codigo

ls_sql = "select a.almacen as cod_almacen, a.desc_almacen as descripcion " &
			+ "from almacen a, almacen_tipo_mov atm " &
			+ "where a.almacen=atm.almacen and " &
      	+ "a.flag_tipo_almacen='T' and " &
			+ "atm.tipo_mov = '" + is_tipo_mov + "'"

f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_almacen.text = ls_codigo
	sle_descrip.text = ls_data
	is_almacen = ls_codigo
end if
		
return

end event

type sle_descrip from singlelineedit within w_al721_rpt_prod_azucar_hora
integer x = 933
integer y = 104
integer width = 1143
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_al721_rpt_prod_azucar_hora
integer x = 110
integer y = 116
integer width = 297
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
string text = "Almacen :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_al721_rpt_prod_azucar_hora
integer x = 32
integer y = 24
integer width = 2098
integer height = 336
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

