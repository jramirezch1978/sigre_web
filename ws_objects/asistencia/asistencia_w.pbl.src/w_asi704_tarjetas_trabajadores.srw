$PBExportHeader$w_asi704_tarjetas_trabajadores.srw
forward
global type w_asi704_tarjetas_trabajadores from w_report_smpl
end type
type sle_tarjeta from singlelineedit within w_asi704_tarjetas_trabajadores
end type
type cbx_o from checkbox within w_asi704_tarjetas_trabajadores
end type
type pb_1 from picturebutton within w_asi704_tarjetas_trabajadores
end type
type em_origen from singlelineedit within w_asi704_tarjetas_trabajadores
end type
type sle_cod_tra from singlelineedit within w_asi704_tarjetas_trabajadores
end type
type cbx_t from checkbox within w_asi704_tarjetas_trabajadores
end type
type rb_o from radiobutton within w_asi704_tarjetas_trabajadores
end type
type rb_t from radiobutton within w_asi704_tarjetas_trabajadores
end type
type rb_j from radiobutton within w_asi704_tarjetas_trabajadores
end type
type sle_desc_tra from statictext within w_asi704_tarjetas_trabajadores
end type
type em_descripcion from statictext within w_asi704_tarjetas_trabajadores
end type
type gb_3 from groupbox within w_asi704_tarjetas_trabajadores
end type
end forward

global type w_asi704_tarjetas_trabajadores from w_report_smpl
integer width = 2491
integer height = 2500
string title = "Trabajadores / Tarjetas[AS704]"
string menuname = "m_reporte"
long backcolor = 67108864
sle_tarjeta sle_tarjeta
cbx_o cbx_o
pb_1 pb_1
em_origen em_origen
sle_cod_tra sle_cod_tra
cbx_t cbx_t
rb_o rb_o
rb_t rb_t
rb_j rb_j
sle_desc_tra sle_desc_tra
em_descripcion em_descripcion
gb_3 gb_3
end type
global w_asi704_tarjetas_trabajadores w_asi704_tarjetas_trabajadores

on w_asi704_tarjetas_trabajadores.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_tarjeta=create sle_tarjeta
this.cbx_o=create cbx_o
this.pb_1=create pb_1
this.em_origen=create em_origen
this.sle_cod_tra=create sle_cod_tra
this.cbx_t=create cbx_t
this.rb_o=create rb_o
this.rb_t=create rb_t
this.rb_j=create rb_j
this.sle_desc_tra=create sle_desc_tra
this.em_descripcion=create em_descripcion
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_tarjeta
this.Control[iCurrent+2]=this.cbx_o
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.sle_cod_tra
this.Control[iCurrent+6]=this.cbx_t
this.Control[iCurrent+7]=this.rb_o
this.Control[iCurrent+8]=this.rb_t
this.Control[iCurrent+9]=this.rb_j
this.Control[iCurrent+10]=this.sle_desc_tra
this.Control[iCurrent+11]=this.em_descripcion
this.Control[iCurrent+12]=this.gb_3
end on

on w_asi704_tarjetas_trabajadores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_tarjeta)
destroy(this.cbx_o)
destroy(this.pb_1)
destroy(this.em_origen)
destroy(this.sle_cod_tra)
destroy(this.cbx_t)
destroy(this.rb_o)
destroy(this.rb_t)
destroy(this.rb_j)
destroy(this.sle_desc_tra)
destroy(this.em_descripcion)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;String ls_cod_trabajador, ls_cod_origen, ls_tarjeta, ls_title, &
		 ls_nombre_origen, ls_nombre_tra

ls_tarjeta        = sle_tarjeta.text

IF rb_o.Checked = TRUE THEN
	
	IF cbx_o.Checked = TRUE THEN
		
		ls_cod_origen     = '%%'
		ls_cod_trabajador = '%%'
		ls_tarjeta        = '%%'
		ls_title = 'REPORTE DE TARJETAS ASIGNADAS A LOS TRABAJADORES DE TODOS LOS ORIGENES'
	ELSE
		ls_cod_origen     = em_origen.text
		
		Select nombre
		  into :ls_nombre_origen
		  from origen
		 where origen.cod_origen = :ls_cod_origen;
		  
		ls_cod_trabajador = '%%'
		ls_tarjeta        = '%%'
		ls_title = 'REPORTE DE TARJETAS ASIGNADAS A LOS TRABAJADORES DEL ORIGEN DE:' + ls_cod_origen + ' - ' + ls_nombre_origen
	END IF
	
		idw_1.object.t_title.text = ls_title
	
		idw_1.Retrieve(ls_cod_origen, ls_cod_trabajador, ls_tarjeta)

ELSEIF rb_T.Checked = TRUE THEN
		 IF cbx_t.Checked = TRUE THEN
		
			 ls_cod_origen     = '%%'
			 ls_cod_trabajador = '%%'
		    ls_tarjeta        = '%%'
		    ls_title = 'REPORTE DE TARJETAS ASIGNADAS POR TRABAJADOR'
		 ELSE
			 
			 ls_cod_trabajador = sle_cod_tra.TExt
			 ls_cod_origen     = '%%'
			 ls_tarjeta        = '%%'
			
			 ls_nombre_tra = sle_desc_tra.text
			 
			 ls_title = 'REPORTE DE TARJETAS ASIGNADAS AL TRABAJADOR:' + ls_cod_trabajador + ' - ' + ls_nombre_tra
		
		END IF
	
			idw_1.object.t_title.text = ls_title
			idw_1.Retrieve(ls_cod_origen, ls_cod_trabajador, ls_tarjeta)
	
	ELSEIF rb_j.Checked = TRUE THEN
		 
		
			 ls_cod_origen     = '%%'
			 ls_cod_trabajador = '%%'
		    ls_tarjeta        = sle_tarjeta.text
		    
			 ls_title = 'REPORTE DE TARJETAS ASIGNADAS A LA TARJETA: '+ls_tarjeta

	
			idw_1.object.t_title.text = ls_title
	
			idw_1.Retrieve(ls_cod_origen, ls_cod_trabajador, ls_tarjeta)
	
END IF

idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
end event

type dw_report from w_report_smpl`dw_report within w_asi704_tarjetas_trabajadores
integer x = 32
integer y = 400
integer width = 2359
integer height = 1868
string dataobject = "d_rpt_trabajadores_tarjetas_tbl"
end type

type sle_tarjeta from singlelineedit within w_asi704_tarjetas_trabajadores
event dobleclick pbm_lbuttondblclk
integer x = 480
integer y = 252
integer width = 731
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 134217746
long backcolor = 33554431
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT T.COD_TARJETA AS NRO_TARJETA, " & 
		  + "M.APEL_PATERNO||' '||M.APEL_MATERNO||', '||M.NOMBRE1||' '||M.NOMBRE2 AS NOMBRE " &
		  + "FROM RRHH_ASIGNA_TRJT_RELOJ T, MAESTRO M " &
		  + "WHERE T.COD_TRABAJADOR = M.COD_TRABAJADOR"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
end if
end event

type cbx_o from checkbox within w_asi704_tarjetas_trabajadores
integer x = 375
integer y = 92
integer width = 82
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked = true then
	
	em_origen.enabled = false
	em_origen.text = ''
	em_descripcion.text = ''
	
else
	
	em_origen.enabled = true

end if
end event

type pb_1 from picturebutton within w_asi704_tarjetas_trabajadores
integer x = 1947
integer y = 104
integer width = 416
integer height = 164
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type em_origen from singlelineedit within w_asi704_tarjetas_trabajadores
event dobleclick pbm_lbuttondblclk
integer x = 480
integer y = 88
integer width = 370
integer height = 68
integer taborder = 70
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type sle_cod_tra from singlelineedit within w_asi704_tarjetas_trabajadores
event dobleclick pbm_lbuttondblclk
integer x = 480
integer y = 172
integer width = 370
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean enabled = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT m.cod_trabajador as codigo, " & 
		  +"M.APEL_PATERNO||' '||M.APEL_MATERNO||', '||M.NOMBRE1||' '||M.NOMBRE2 AS NOMBRE " &
		  + "FROM maestro m " &
		  + "WHERE m.flag_estado <> '0'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
this.text = ls_codigo
sle_desc_tra.text = ls_data
end event

event modified;String 	ls_nombre, ls_codigo

ls_codigo = this.text

SELECT M.APEL_PATERNO||' '||M.APEL_MATERNO||', '||M.NOMBRE1||' '||M.NOMBRE2 AS TRABAJADOR
	INTO :ls_nombre
FROM maestro m
where m.cod_trabajador =:ls_codigo
  and m.flag_estado <> '0';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Producción', 'Codigo de Trabajador no existe')
	this.text = ''
	sle_desc_tra.text = ''
	return
else
	sle_desc_tra.text = ls_nombre
end if

end event

type cbx_t from checkbox within w_asi704_tarjetas_trabajadores
integer x = 375
integer y = 176
integer width = 82
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean lefttext = true
end type

event clicked;if this.checked = true then
	
	sle_cod_tra.enabled = false
	sle_cod_tra.text = ''
	sle_desc_tra.text = ''
	
else
	
	sle_cod_tra.enabled = true

end if
end event

type rb_o from radiobutton within w_asi704_tarjetas_trabajadores
integer x = 18
integer y = 84
integer width = 315
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
string text = "Origen"
boolean checked = true
end type

event clicked;if this.checked = true then
	cbx_o.enabled = true
	cbx_o.checked = true
	em_origen.enabled = true
	
	cbx_t.enabled = false
	sle_cod_tra.enabled = false

	sle_tarjeta.enabled = false
End if
end event

type rb_t from radiobutton within w_asi704_tarjetas_trabajadores
integer x = 18
integer y = 156
integer width = 315
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
string text = "Trabajador"
end type

event clicked;if this.checked = true then
	
	cbx_t.enabled = true
	cbx_t.checked = true
	sle_cod_tra.enabled = true
	
	cbx_o.enabled = false
	em_origen.enabled = false

	sle_tarjeta.enabled = false
End if
end event

type rb_j from radiobutton within w_asi704_tarjetas_trabajadores
integer x = 18
integer y = 228
integer width = 315
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
string text = "Tarjeta"
end type

event clicked;if this.checked = true then

	sle_tarjeta.enabled = true

	cbx_o.enabled = false
	em_origen.enabled = false
	
	cbx_t.enabled = false
	sle_cod_tra.enabled = false
End if
end event

type sle_desc_tra from statictext within w_asi704_tarjetas_trabajadores
integer x = 864
integer y = 172
integer width = 997
integer height = 68
boolean bringtotop = true
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type em_descripcion from statictext within w_asi704_tarjetas_trabajadores
integer x = 864
integer y = 88
integer width = 997
integer height = 68
boolean bringtotop = true
integer textsize = -6
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type gb_3 from groupbox within w_asi704_tarjetas_trabajadores
integer x = 366
integer y = 32
integer width = 2030
integer height = 328
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Todos - / - Parametros"
end type

