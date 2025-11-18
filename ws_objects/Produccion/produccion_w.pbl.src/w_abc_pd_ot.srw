$PBExportHeader$w_abc_pd_ot.srw
forward
global type w_abc_pd_ot from w_abc
end type
type sle_nro from u_sle_codigo within w_abc_pd_ot
end type
type st_1 from statictext within w_abc_pd_ot
end type
type cbx_1 from checkbox within w_abc_pd_ot
end type
type pb_1 from picturebutton within w_abc_pd_ot
end type
type pb_2 from picturebutton within w_abc_pd_ot
end type
end forward

global type w_abc_pd_ot from w_abc
integer width = 1573
integer height = 680
string title = "Datos de PD OT"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
event ue_salir ( )
sle_nro sle_nro
st_1 st_1
cbx_1 cbx_1
pb_1 pb_1
pb_2 pb_2
end type
global w_abc_pd_ot w_abc_pd_ot

event ue_aceptar();str_parametros sl_param
if cbx_1.checked then
	sl_param.string1 = '1'
else
	sl_param.string1 = '0'
end if

sl_param.string2 = sle_nro.text
sl_param.titulo = 's'

CloseWithReturn(this, sl_param)
end event

event ue_salir();str_parametros sl_param
sl_param.titulo = 'n'

CloseWithReturn(this, sl_param)
end event

event open;call super::open;//Overriding
THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()
end event

on w_abc_pd_ot.create
int iCurrent
call super::create
this.sle_nro=create sle_nro
this.st_1=create st_1
this.cbx_1=create cbx_1
this.pb_1=create pb_1
this.pb_2=create pb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.pb_2
end on

on w_abc_pd_ot.destroy
call super::destroy
destroy(this.sle_nro)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.pb_1)
destroy(this.pb_2)
end on

event ue_open_pre;//Overriding
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton      						// crear menu de boton derecho del mouse
//im_1.m_cortar.visible = false

//dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
//dw_detail.SetTransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

//idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
//dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

//dw_master.of_protect()         		// bloquear modificaciones 
//dw_detail.of_protect()

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
//ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
//ii_access = 1								// 0 = menu (default), 1 = botones, 2 = menu + botones
end event

type sle_nro from u_sle_codigo within w_abc_pd_ot
event ue_dlbclick pbm_lbuttondblclk
integer x = 635
integer y = 200
integer width = 471
integer height = 92
integer taborder = 10
boolean enabled = false
integer limit = 10
end type

event ue_dlbclick;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

ls_sql = "SELECT a.nro_parte AS numero_parte, " &
		  + "to_char(a.fecha), 'dd/mm/yyyy') s fecha_parte, " &
		  + "a.ot_adm as Ot_adm_pd_ot, " &
		  + "a.obs as observaciones " &
		  + "FROM pd_ot a, " &
		  + "ot_adm_usuario b" &
		  + "where a.ot_adm = b.ot_adm " &
		  + "and b.cod_usr = '" + gs_user + "'"
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text = ls_codigo
end if
		

end event

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type st_1 from statictext within w_abc_pd_ot
integer x = 73
integer y = 208
integer width = 544
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Parte (PD OT):"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_abc_pd_ot
integer x = 137
integer y = 88
integer width = 955
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Crear nuevo Parte Diario (PD OT)"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nro.enabled = false
else
	sle_nro.enabled = true
end if
end event

type pb_1 from picturebutton within w_abc_pd_ot
integer x = 462
integer y = 364
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "h:\Source\Bmp\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type pb_2 from picturebutton within w_abc_pd_ot
integer x = 837
integer y = 364
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "h:\Source\Bmp\Salir.bmp"
alignment htextalign = left!
end type

event clicked;parent.event dynamic ue_salir()
end event

