$PBExportHeader$w_cd701_doc_transfer.srw
forward
global type w_cd701_doc_transfer from w_rpt_list
end type
type uo_fechas from u_ingreso_rango_fechas within w_cd701_doc_transfer
end type
type cb_1 from commandbutton within w_cd701_doc_transfer
end type
type st_1 from statictext within w_cd701_doc_transfer
end type
type sle_usuario from singlelineedit within w_cd701_doc_transfer
end type
type pb_3 from picturebutton within w_cd701_doc_transfer
end type
type st_nombre from statictext within w_cd701_doc_transfer
end type
end forward

global type w_cd701_doc_transfer from w_rpt_list
integer width = 3913
integer height = 2104
string title = "[CD701] Formato de documentos transferidos"
string menuname = "m_impresion"
uo_fechas uo_fechas
cb_1 cb_1
st_1 st_1
sle_usuario sle_usuario
pb_3 pb_3
st_nombre st_nombre
end type
global w_cd701_doc_transfer w_cd701_doc_transfer

type variables
String is_col
Integer		ii_grf_val_index = 4
end variables

on w_cd701_doc_transfer.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_usuario=create sle_usuario
this.pb_3=create pb_3
this.st_nombre=create st_nombre
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_usuario
this.Control[iCurrent+5]=this.pb_3
this.Control[iCurrent+6]=this.st_nombre
end on

on w_cd701_doc_transfer.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_usuario)
destroy(this.pb_3)
destroy(this.st_nombre)
end on

event open;call super::open;cb_report.visible=false
dw_1.visible=false
dw_2.visible=false
pb_1.visible=false
pb_2.visible=false
dw_report.visible=false


end event

event ue_retrieve;call super::ue_retrieve;Long 	 ll_row, ll_ano, ll_mes
String ls_usuario

Date ld_fec_ini, ld_fec_fin

ld_fec_ini = uo_fechas.of_get_fecha1()  
ld_fec_fin = uo_fechas.of_get_fecha2() 
ls_usuario = sle_usuario.text

dw_report.SetTransObject( sqlca)

	dw_1.visible = false
	dw_2.visible = false
	pb_1.visible = false
	pb_2.visible = false
	this.Event ue_preview()
	dw_report.visible = true	
	dw_report.retrieve(ld_fec_ini, ld_fec_fin,ls_usuario)		
	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.t_usuario.text = gs_user
	dw_report.object.t_titulo1.text = 'DEL ' + STRING( ld_fec_ini, 'dd/mm/yyyy') + &
	  ' AL ' + string( ld_fec_fin, 'dd/mm/yyyy')

end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50)
end event

type dw_report from w_rpt_list`dw_report within w_cd701_doc_transfer
boolean visible = false
integer x = 23
integer y = 192
integer width = 3721
integer height = 1796
string dataobject = "d_rpt_entrega_documentos_user"
end type

type dw_1 from w_rpt_list`dw_1 within w_cd701_doc_transfer
integer x = 110
integer y = 312
integer width = 1257
integer height = 884
string dataobject = "d_lista_doc_x_fecha_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7
ii_ck[8] = 8

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
ii_dk[7] = 7
ii_dk[8] = 8

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
ii_rk[7] = 7
ii_rk[8] = 8

end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
//	st_campo.text = "Orden : " + is_col
//	dw_text.reset()
//	dw_text.InsertRow(0)
//	dw_text.SetFocus()
END IF
end event

type pb_1 from w_rpt_list`pb_1 within w_cd701_doc_transfer
integer x = 1417
integer y = 536
end type

type pb_2 from w_rpt_list`pb_2 within w_cd701_doc_transfer
integer x = 1422
integer y = 704
end type

type dw_2 from w_rpt_list`dw_2 within w_cd701_doc_transfer
integer x = 1691
integer y = 312
integer width = 1239
integer height = 888
string dataobject = "d_lista_doc_x_fecha_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7
ii_ck[8] = 8
ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6
ii_dk[7] = 7
ii_dk[8] = 8
ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6
ii_rk[7] = 7
ii_rk[8] = 8

end event

type cb_report from w_rpt_list`cb_report within w_cd701_doc_transfer
boolean visible = false
integer x = 3296
integer y = 40
integer width = 457
integer textsize = -8
integer weight = 700
end type

event cb_report::clicked;call super::clicked;integer i
string ls_registro



FOR i=1 to dw_2.RowCount()
	ls_registro=dw_2.object.nro_registro[i]

	update tt_cd_registro
	set flag_estado='1' 
	WHERE nro_registro=:ls_registro ;
next

commit;

parent.event ue_retrieve()

cb_report.visible=false
cb_1.visible=true

end event

type uo_fechas from u_ingreso_rango_fechas within w_cd701_doc_transfer
integer x = 37
integer y = 24
integer taborder = 20
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

type cb_1 from commandbutton within w_cd701_doc_transfer
integer x = 2889
integer y = 40
integer width = 361
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar"
end type

event clicked;Long 	 ll_row, ll_ano, ll_mes
String ls_usuario

String ls_fec_ini, ls_fec_fin

ls_fec_ini = String(uo_fechas.of_get_fecha1(),'yyyymmdd')  
ls_fec_fin = String(uo_fechas.of_get_fecha2(),'yyyymmdd')
ls_usuario = sle_usuario.text

dw_1.reset()
dw_2.reset()

delete from tt_cd_registro ;
commit ;

// 
insert into tt_cd_registro(nro_registro,flag_estado) 
select nro_registro, '0' FROM cd_doc_recibido C 
WHERE to_char(c.fecha_recepcion,'yyyymmdd') >= :ls_fec_ini AND 
      to_char(c.fecha_recepcion,'yyyymmdd') <= :ls_fec_fin AND 
      c.cod_user_transfer							= :ls_usuario ;

commit;

dw_1.retrieve()
cb_1.visible=false
cb_report.visible=true
dw_1.visible=true
dw_2.visible=true
pb_1.visible=true
pb_2.visible=true
dw_report.visible=false
end event

type st_1 from statictext within w_cd701_doc_transfer
integer x = 1376
integer y = 32
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
long backcolor = 12632256
string text = "Usuario :"
boolean focusrectangle = false
end type

type sle_usuario from singlelineedit within w_cd701_doc_transfer
integer x = 1609
integer y = 24
integer width = 247
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type pb_3 from picturebutton within w_cd701_doc_transfer
integer x = 1879
integer y = 20
integer width = 128
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "h:\source\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_origen, ls_usuario, ls_area, ls_seccion, ls_nombre

str_seleccionar lstr_seleccionar

			
lstr_seleccionar.s_seleccion = 'S'

lstr_seleccionar.s_sql = 'SELECT CD_USUARIO_SECCION.COD_ORIGEN AS ORIGEN, '&
										 +'CD_USUARIO_SECCION.COD_USR AS USUARIO, '&
										 +'USUARIO.NOMBRE AS NOMBRE, '&
										 +'CD_USUARIO_SECCION.COD_AREA AS AREA, '&
										 +'CD_USUARIO_SECCION.COD_SECCION AS SECCION '&										 
										 +'FROM CD_USUARIO_SECCION, USUARIO ' &
										 +'WHERE CD_USUARIO_SECCION.COD_USR=USUARIO.COD_USR'

						  
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	//ls_origen 	= lstr_seleccionar.param1[1]
	ls_usuario 	= lstr_seleccionar.param2[1]
	ls_nombre 	= lstr_seleccionar.param3[1]
	//ls_area 		= lstr_seleccionar.param4[1]
	//ls_seccion 	= lstr_seleccionar.param5[1]
	
	sle_usuario.text = ls_usuario 
	st_nombre.text	  = ls_nombre
	dw_report.visible=false
	
END IF


end event

type st_nombre from statictext within w_cd701_doc_transfer
integer x = 2117
integer y = 36
integer width = 654
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
boolean focusrectangle = false
end type

