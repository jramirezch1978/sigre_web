$PBExportHeader$w_cd302_transf_docum.srw
forward
global type w_cd302_transf_docum from w_rpt_list
end type
type rr_1 from roundrectangle within w_cd302_transf_docum
end type
type st_1 from statictext within w_cd302_transf_docum
end type
type sle_usuario from singlelineedit within w_cd302_transf_docum
end type
type pb_3 from picturebutton within w_cd302_transf_docum
end type
type sle_origen from singlelineedit within w_cd302_transf_docum
end type
type sle_area from singlelineedit within w_cd302_transf_docum
end type
type sle_seccion from singlelineedit within w_cd302_transf_docum
end type
type st_nombre from statictext within w_cd302_transf_docum
end type
end forward

global type w_cd302_transf_docum from w_rpt_list
integer width = 3584
integer height = 2376
boolean titlebar = false
string title = ""
string menuname = "m_mantenimiento_sl"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
boolean border = false
long backcolor = 67108864
rr_1 rr_1
st_1 st_1
sle_usuario sle_usuario
pb_3 pb_3
sle_origen sle_origen
sle_area sle_area
sle_seccion sle_seccion
st_nombre st_nombre
end type
global w_cd302_transf_docum w_cd302_transf_docum

type variables
String 			is_col
Integer			ii_grf_val_index = 4
n_cst_usuario 	invo_usuario
end variables

on w_cd302_transf_docum.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.rr_1=create rr_1
this.st_1=create st_1
this.sle_usuario=create sle_usuario
this.pb_3=create pb_3
this.sle_origen=create sle_origen
this.sle_area=create sle_area
this.sle_seccion=create sle_seccion
this.st_nombre=create st_nombre
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rr_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_usuario
this.Control[iCurrent+4]=this.pb_3
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.sle_area
this.Control[iCurrent+7]=this.sle_seccion
this.Control[iCurrent+8]=this.st_nombre
end on

on w_cd302_transf_docum.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rr_1)
destroy(this.st_1)
destroy(this.sle_usuario)
destroy(this.pb_3)
destroy(this.sle_origen)
destroy(this.sle_area)
destroy(this.sle_seccion)
destroy(this.st_nombre)
end on

event resize;call super::resize;pb_1.x = newwidth / 2 - pb_1.width / 2
pb_2.x = newwidth / 2 - pb_2.width / 2

dw_1.height = newheight - dw_1.y - 10
dw_1.width = pb_1.x - dw_1.x - 10

dw_2.x 		= pb_1.x + pb_1.width + 10
dw_2.width 	= newwidth - dw_2.x - 10
dw_2.height = newheight - dw_2.y - 10

//dw_text.width = dw_1.width + dw_1.x - dw_text.x
end event

event ue_open_pre;call super::ue_open_pre;dw_1.retrieve(gs_user)
end event

type dw_report from w_rpt_list`dw_report within w_cd302_transf_docum
boolean visible = false
integer x = 224
integer y = 180
end type

type dw_1 from w_rpt_list`dw_1 within w_cd302_transf_docum
integer x = 5
integer y = 164
integer width = 1472
integer height = 1096
string dataobject = "d_lista_doc_recibidos_tbl"
end type

event dw_1::constructor;call super::constructor;dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1				// columnas de lectrua de este dw
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

type pb_1 from w_rpt_list`pb_1 within w_cd302_transf_docum
integer x = 1522
integer y = 596
end type

type pb_2 from w_rpt_list`pb_2 within w_cd302_transf_docum
integer x = 1522
integer y = 784
end type

type dw_2 from w_rpt_list`dw_2 within w_cd302_transf_docum
integer x = 1705
integer y = 164
integer width = 1467
integer height = 1104
string dataobject = "d_lista_doc_recibidos_tbl"
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

type cb_report from w_rpt_list`cb_report within w_cd302_transf_docum
integer x = 2738
integer y = 24
integer width = 448
integer height = 104
integer textsize = -8
integer weight = 700
boolean underline = true
string text = "Transfiere"
end type

event cb_report::clicked;call super::clicked;integer 	li_i
string 	ls_nro_registro, ls_mensaje
Long 		ll_count
DateTime ldt_fecha
Date 		ld_fecha
Boolean 	lb_ok

try 
	SetPointer(HourGlass!)
	
	if TRIM(sle_usuario.text) = '' then
		MessageBox('Aviso','Deben especificar un usuario a quien transferir la documentación, por favor verfique!')
		sle_usuario.SetFocus()
		Return 
	end if
	
	IF invo_usuario.is_cod_usr = gs_user THEN
		MessageBox('Aviso','No puede transferir documento a si mismo')
		Return 
	END IF
	
	lb_ok = FALSE
	ldt_fecha = gnvo_app.of_fecha_actual( )
	
	IF (invo_usuario.is_origen='' OR ISNULL(invo_usuario.is_origen)) THEN
		MessageBox('Aviso', 'Defina origen usuario receptor')
		Return
	END IF 
	IF (invo_usuario.is_area='' OR ISNULL(invo_usuario.is_area)) THEN
		MessageBox('Aviso', 'Defina área usuario receptor')
		Return
	END IF 
	IF (invo_usuario.is_seccion='' OR ISNULL(invo_usuario.is_seccion)) THEN
		MessageBox('Aviso', 'Defina sección usuario receptor')
		Return
	END IF 
	
	// Actualizando datos 
	FOR li_i = 1 to dw_2.rowcount()
	
		ls_nro_registro=dw_2.object.nro_registro[li_i]
		
		UPDATE cd_doc_recibido
		SET cod_user_transfer  = :invo_usuario.is_cod_usr,
			 fecha_transfer_ini = :ldt_fecha, 
			 flag_transfer = '2'
		WHERE nro_registro= :ls_nro_registro;
		
		if sqlca.sqlcode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			messagebox("Error al actualizar registro en tabla cd_doc_recibido", "Error en tabla cd_doc_recibido: " + ls_mensaje + ", por favor verifique!", StopSign!)
			return
		end if
		 
	NEXT
	
	commit;
	
	//Envio el email al usuario advirtiendo que tiene documentos que le han transferido
	if gnvo_app.is_FLAG_ENVIO_EMAIL = "1" then
		gnvo_controldoc.of_enviar_email(dw_2, gnvo_app.of_create_usr(gs_user), invo_usuario)
	end if
	
	dw_2.Reset()
	messagebox('Aviso','Se Actualizaron Correctamente los datos', Information!)

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción al tranferir el documento: ' + ex.getMessage() + '. Por favor verifique!', StopSign!)

finally 
	SetPointer(Arrow!)
end try

end event

type rr_1 from roundrectangle within w_cd302_transf_docum
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 67108864
integer x = 5
integer y = 12
integer width = 2702
integer height = 128
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_1 from statictext within w_cd302_transf_docum
integer x = 78
integer y = 40
integer width = 256
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Usuario :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_usuario from singlelineedit within w_cd302_transf_docum
integer x = 357
integer y = 40
integer width = 247
integer height = 84
integer taborder = 20
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

event modified;invo_usuario.is_cod_usr = this.text 

SELECT c.cod_origen, u.nombre, c.cod_area, c.cod_seccion
  INTO :invo_usuario.is_origen, :invo_usuario.is_nombre, :invo_usuario.is_area, :invo_usuario.is_seccion 
  FROM cd_usuario_seccion 	c, 
  		 usuario 				u 
 WHERE c.cod_usr = u.cod_usr 
   AND c.cod_usr = :invo_usuario.is_cod_usr 
	and u.flag_estado = '1';
	
if SQLCA.SQLCode = 100 then
	
	MessageBox('Error', 'No existe usuario ' + invo_usuario.is_cod_usr + " o no se encuentra activo, por favor verifique!", StopSign!)
	
	invo_usuario.Clear()
	return
end if


end event

type pb_3 from picturebutton within w_cd302_transf_docum
integer x = 649
integer y = 40
integer width = 123
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;String ls_sql


ls_sql = "SELECT CUS.COD_ORIGEN AS ORIGEN, "&
		 + "CUS.COD_USR AS USUARIO, "&
		 + "U.NOMBRE AS NOMBRE_usuario, "&
		 + "cus.COD_AREA AS AREA, "&
		 + "cus.COD_SECCION AS SECCION, "&										 
		 + "u.email as email " &
		 + "FROM CD_USUARIO_SECCION CUS, " &
		 + "USUARIO U " &
		 + "WHERE CUS.COD_USR = U.COD_USR " &
		 + "and u.flag_estado = '1'"
	 
if not f_lista_6ret(	ls_sql, &
							invo_usuario.is_origen, &
							invo_usuario.is_cod_usr, &
							invo_usuario.is_nombre, &
							invo_usuario.is_area, &
							invo_usuario.is_seccion, &
							invo_usuario.is_email, &
							'3') then return

IF invo_usuario.is_cod_usr = '' or IsNull(invo_usuario.is_cod_usr)  THEN return
		
IF (invo_usuario.is_origen='' OR ISNULL(invo_usuario.is_origen)) THEN
	MessageBox('Aviso', 'Defina origen usuario receptor', StopSign!)
	Return
END IF 
IF (invo_usuario.is_area='' OR ISNULL(invo_usuario.is_area)) THEN
	MessageBox('Aviso', 'Defina área usuario receptor', stopSign!)
	Return
END IF 
IF (invo_usuario.is_seccion='' OR ISNULL(invo_usuario.is_seccion)) THEN
	MessageBox('Aviso', 'Defina sección usuario receptor', StopSign!)
	Return
END IF 

sle_usuario.text 	= invo_usuario.is_cod_usr
st_nombre.text 	= invo_usuario.is_nombre
	



end event

type sle_origen from singlelineedit within w_cd302_transf_docum
boolean visible = false
integer x = 2299
integer y = 156
integer width = 453
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_area from singlelineedit within w_cd302_transf_docum
boolean visible = false
integer x = 2075
integer y = 48
integer width = 343
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_seccion from singlelineedit within w_cd302_transf_docum
boolean visible = false
integer x = 1742
integer y = 44
integer width = 311
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_nombre from statictext within w_cd302_transf_docum
integer x = 827
integer y = 40
integer width = 1755
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 65535
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

