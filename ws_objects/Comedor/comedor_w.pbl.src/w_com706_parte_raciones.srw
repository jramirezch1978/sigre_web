$PBExportHeader$w_com706_parte_raciones.srw
forward
global type w_com706_parte_raciones from w_rpt_general
end type
type sle_parte from singlelineedit within w_com706_parte_raciones
end type
type st_1 from statictext within w_com706_parte_raciones
end type
type em_origen from singlelineedit within w_com706_parte_raciones
end type
type em_descripcion from editmask within w_com706_parte_raciones
end type
type pb_1 from picturebutton within w_com706_parte_raciones
end type
type gb_2 from groupbox within w_com706_parte_raciones
end type
end forward

global type w_com706_parte_raciones from w_rpt_general
integer width = 2011
integer height = 1920
string title = "Parte de Raciones (COM706)"
sle_parte sle_parte
st_1 st_1
em_origen em_origen
em_descripcion em_descripcion
pb_1 pb_1
gb_2 gb_2
end type
global w_com706_parte_raciones w_com706_parte_raciones

on w_com706_parte_raciones.create
int iCurrent
call super::create
this.sle_parte=create sle_parte
this.st_1=create st_1
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.pb_1=create pb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_parte
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_descripcion
this.Control[iCurrent+5]=this.pb_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_com706_parte_raciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_parte)
destroy(this.st_1)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.pb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_nro_parte, ls_origen

//create or replace procedure USP_PR_COSTO_OT_LABOR(
//       asi_nro_orden orden_trabajo.nro_orden%type,
//       aso_mensaje   out varchar2, 
//       aio_ok 			 out number) is

this.SetRedraw(false)

ls_origen	 = em_origen.text
ls_nro_parte = sle_parte.text

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ls_nro_parte = '' or IsNull( ls_nro_parte ) then
	MessageBox('COMEDORES', 'EL NUMERO DE PARTE DE RACIONES NO ESTA DEFINIDO', StopSign!)
	return
end if

idw_1.Retrieve(ls_origen, ls_nro_parte)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.Subtitulo_1.text  = "Nro Parte: " + ls_nro_parte
idw_1.Object.Datawindow.Print.Orientation = '1'

this.SetRedraw(true)
end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_rpt_general`dw_report within w_com706_parte_raciones
integer y = 268
integer width = 1883
integer height = 1444
string dataobject = "d_rpt_parte_raciones_cmp"
end type

type sle_parte from singlelineedit within w_com706_parte_raciones
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
event ue_reset ( )
integer x = 969
integer y = 124
integer width = 416
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event dynamic ue_display()
end event

event ue_display();// Asigna valores a structura 
sg_parametros sl_param

sl_param.dw1    = 'd_lista_parte_raciones_grid'
sl_param.titulo = 'Parte de Raciones'
				
sl_param.tipo    = '1SQL'                                                          
sl_param.string1 = " AND substr(parte_racion,1,2) = '" &
	+ gs_origen + "'"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
				
	This.Text = sl_param.field_ret[1]
	parent.event dynamic ue_retrieve()
			
END IF

end event

event ue_keydwn;if Key = KeyF2! then
	this.event dynamic ue_display()	
end if
end event

type st_1 from statictext within w_com706_parte_raciones
integer x = 978
integer y = 52
integer width = 398
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte Raciones:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_origen from singlelineedit within w_com706_parte_raciones
event dobleclick pbm_lbuttondblclk
integer x = 87
integer y = 124
integer width = 128
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
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

type em_descripcion from editmask within w_com706_parte_raciones
integer x = 229
integer y = 124
integer width = 663
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type pb_1 from picturebutton within w_com706_parte_raciones
integer x = 1554
integer y = 72
integer width = 315
integer height = 180
integer taborder = 40
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

type gb_2 from groupbox within w_com706_parte_raciones
integer x = 46
integer y = 64
integer width = 1408
integer height = 164
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

