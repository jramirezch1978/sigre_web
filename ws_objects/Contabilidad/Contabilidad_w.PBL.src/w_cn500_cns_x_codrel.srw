$PBExportHeader$w_cn500_cns_x_codrel.srw
forward
global type w_cn500_cns_x_codrel from w_cns
end type
type pb_2 from picturebutton within w_cn500_cns_x_codrel
end type
type pb_1 from picturebutton within w_cn500_cns_x_codrel
end type
type st_5 from statictext within w_cn500_cns_x_codrel
end type
type st_4 from statictext within w_cn500_cns_x_codrel
end type
type sle_codrel_hasta from singlelineedit within w_cn500_cns_x_codrel
end type
type sle_codrel_desde from singlelineedit within w_cn500_cns_x_codrel
end type
type st_3 from statictext within w_cn500_cns_x_codrel
end type
type st_2 from statictext within w_cn500_cns_x_codrel
end type
type st_1 from statictext within w_cn500_cns_x_codrel
end type
type cb_aceptar from commandbutton within w_cn500_cns_x_codrel
end type
type sle_mes_hasta from singlelineedit within w_cn500_cns_x_codrel
end type
type sle_mes_desde from singlelineedit within w_cn500_cns_x_codrel
end type
type sle_ano from singlelineedit within w_cn500_cns_x_codrel
end type
type dw_master from u_dw_cns within w_cn500_cns_x_codrel
end type
type gb_1 from groupbox within w_cn500_cns_x_codrel
end type
type gb_2 from groupbox within w_cn500_cns_x_codrel
end type
end forward

global type w_cn500_cns_x_codrel from w_cns
integer width = 3136
integer height = 1668
string title = "[CN500] Consulta por Codigo de Relacion y Rango"
string menuname = "m_abc_report_smpl"
pb_2 pb_2
pb_1 pb_1
st_5 st_5
st_4 st_4
sle_codrel_hasta sle_codrel_hasta
sle_codrel_desde sle_codrel_desde
st_3 st_3
st_2 st_2
st_1 st_1
cb_aceptar cb_aceptar
sle_mes_hasta sle_mes_hasta
sle_mes_desde sle_mes_desde
sle_ano sle_ano
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
end type
global w_cn500_cns_x_codrel w_cn500_cns_x_codrel

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)
idw_1 = dw_master              // asignar dw corriente
// ii_help = 101           // help topic
of_position_window(0,0)        // Posicionar la ventana en forma fija
end event

on w_cn500_cns_x_codrel.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_5=create st_5
this.st_4=create st_4
this.sle_codrel_hasta=create sle_codrel_hasta
this.sle_codrel_desde=create sle_codrel_desde
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_aceptar=create cb_aceptar
this.sle_mes_hasta=create sle_mes_hasta
this.sle_mes_desde=create sle_mes_desde
this.sle_ano=create sle_ano
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.sle_codrel_hasta
this.Control[iCurrent+6]=this.sle_codrel_desde
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_aceptar
this.Control[iCurrent+11]=this.sle_mes_hasta
this.Control[iCurrent+12]=this.sle_mes_desde
this.Control[iCurrent+13]=this.sle_ano
this.Control[iCurrent+14]=this.dw_master
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
end on

on w_cn500_cns_x_codrel.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_codrel_hasta)
destroy(this.sle_codrel_desde)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_aceptar)
destroy(this.sle_mes_hasta)
destroy(this.sle_mes_desde)
destroy(this.sle_ano)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve_list;call super::ue_retrieve_list;
string ls_ano, ls_mesd, ls_mesh, ls_mensaje

ls_ano = string(sle_ano.text)
ls_mesd = string(sle_mes_desde.text)
ls_mesh = string(sle_mes_hasta.text)

DECLARE USP_CNTBL_CNS_CLIENTE PROCEDURE FOR USP_CNTBL_CNS_CLIENTE
        ( :ls_ano, :ls_mesd, :ls_mesh ) ;
EXECUTE USP_CNTBL_CNS_CLIENTE ;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQlErrText
	ROLLBACK;
	MessageBox('Error', 'HA ocurrido un error durante la ejecución del procedimiento USP_CNTBL_CNS_CLIENTE: ' + ls_mensaje)
	return
end if

CLOSE USP_CNTBL_CNS_CLIENTE;

dw_master.of_set_split(dw_master.of_get_column_end('nombre'))

dw_master.retrieve()

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type pb_2 from picturebutton within w_cn500_cns_x_codrel
integer x = 1230
integer y = 76
integer width = 128
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
										 +'FROM PROVEEDOR '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codrel_hasta.text = lstr_seleccionar.param1[1]
	END IF

end event

type pb_1 from picturebutton within w_cn500_cns_x_codrel
integer x = 535
integer y = 72
integer width = 123
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "c:\sigre\resources\BMP\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
										 +'FROM PROVEEDOR '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codrel_desde.text = lstr_seleccionar.param1[1]
	END IF

end event

type st_5 from statictext within w_cn500_cns_x_codrel
integer x = 741
integer y = 88
integer width = 174
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hasta:"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn500_cns_x_codrel
integer x = 41
integer y = 88
integer width = 197
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde:"
boolean focusrectangle = false
end type

type sle_codrel_hasta from singlelineedit within w_cn500_cns_x_codrel
integer x = 923
integer y = 80
integer width = 274
integer height = 88
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

type sle_codrel_desde from singlelineedit within w_cn500_cns_x_codrel
integer x = 242
integer y = 80
integer width = 274
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn500_cns_x_codrel
integer x = 2354
integer y = 96
integer width = 288
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes hasta:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn500_cns_x_codrel
integer x = 1865
integer y = 96
integer width = 320
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes desde:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn500_cns_x_codrel
integer x = 1513
integer y = 96
integer width = 142
integer height = 56
integer textsize = -9
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

type cb_aceptar from commandbutton within w_cn500_cns_x_codrel
integer x = 2830
integer y = 84
integer width = 229
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;string  ls_codigo_desde, ls_codigo_hasta

ls_codigo_desde = sle_codrel_desde.text
ls_codigo_hasta = sle_codrel_hasta.text

delete from tt_cntbl_cliente ;
	
insert into tt_cntbl_cliente (codigo, descripcion)
( select proveedor, nom_proveedor from proveedor 
  where proveedor between :ls_codigo_desde and :ls_codigo_hasta ) ;
	 
if sqlca.sqlcode = -1 then
	 MessageBox("Error al Insertar Registro",sqlca.sqlerrtext)
end if

dw_master.SetTransObject(sqlca)
dw_master.visible=true
parent.event ue_retrieve_list()

end event

type sle_mes_hasta from singlelineedit within w_cn500_cns_x_codrel
integer x = 2647
integer y = 88
integer width = 101
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes_desde from singlelineedit within w_cn500_cns_x_codrel
integer x = 2181
integer y = 88
integer width = 105
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano from singlelineedit within w_cn500_cns_x_codrel
integer x = 1650
integer y = 88
integer width = 151
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_cns within w_cn500_cns_x_codrel
integer y = 232
integer width = 3054
integer height = 1120
integer taborder = 90
string dataobject = "d_cntbl_cns_cliente1_crt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;//Asignacion de variable sin efecto alguno
ii_ck[1] = 1 //Columna de lectura del dw.


end event

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "codigo"  
		lstr_1.DataObject = 'd_cntbl_cns_cliente2_tbl'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.Title = 'Saldos de Documentos por Cliente y Cuenta'
		lstr_1.Arg[1] = GetItemString(row,'codigo')
		lstr_1.Arg[2] = ''
		lstr_1.Arg[3] = ''
		lstr_1.Arg[4] = ''
		lstr_1.Arg[5] = ''
		lstr_1.Arg[6] = ''
		lstr_1.NextCol = 'nro_doc'
		of_new_sheet(lstr_1)
END CHOOSE
end event

type gb_1 from groupbox within w_cn500_cns_x_codrel
integer x = 1481
integer y = 8
integer width = 1317
integer height = 208
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Período contable"
end type

type gb_2 from groupbox within w_cn500_cns_x_codrel
integer width = 1394
integer height = 212
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Rango códigos de relación"
end type

