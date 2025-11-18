$PBExportHeader$w_cm002_proveedor_ficha.srw
forward
global type w_cm002_proveedor_ficha from w_report_smpl
end type
type rb_1 from radiobutton within w_cm002_proveedor_ficha
end type
type rb_2 from radiobutton within w_cm002_proveedor_ficha
end type
type rb_3 from radiobutton within w_cm002_proveedor_ficha
end type
type cbx_1 from checkbox within w_cm002_proveedor_ficha
end type
end forward

global type w_cm002_proveedor_ficha from w_report_smpl
integer width = 4279
integer height = 1476
string title = "Ficha de Proveedor (CM002)"
string menuname = "m_impresion"
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cbx_1 cbx_1
end type
global w_cm002_proveedor_ficha w_cm002_proveedor_ficha

type variables
string is_prov
end variables

on w_cm002_proveedor_ficha.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.cbx_1
end on

on w_cm002_proveedor_ficha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cbx_1)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()

of_position(0,0)
this.height = w_main.height - 400
end event

event ue_retrieve;call super::ue_retrieve;String ls_titulo, ls_codigo, ls_version, ls_fecha

if rb_2.checked then
	ls_titulo ='FICHA CLIENTE'
	ls_codigo = 'CANT.FO.08.1'
	ls_fecha = 'FECHA: 24/03/2014'
else
	ls_titulo ='FICHA PROVEEDOR'	
	ls_codigo = 'CANT.FO.07.1'
	ls_fecha = 'FECHA: 06/03/2014'
end if

ls_version = 'VERSION: 00'

if cbx_1.checked then
	idw_1.dataobject = 'd_rpt_proveedor_basc_ficha_blanco'
	idw_1.insertrow(0)
	
else	
	if rb_1.checked then
		idw_1.dataobject = 'd_rpt_ficha_proveedor'
	else
		idw_1.dataobject = 'd_rpt_proveedor_basc_ficha_composite'
	end if
	idw_1.settransobject(sqlca)
	idw_1.Retrieve(is_prov)
end if


idw_1.Object.p_logo.filename = gs_logo

if rb_1.checked = false then
	idw_1.object.t_titulobasc1.text = ls_titulo
	idw_1.object.t_codigobasc.text = ls_codigo
	idw_1.object.t_versionbasc.text = ls_version
	idw_1.object.t_fecha.text = ls_fecha
	idw_1.object.t_usuario.text = upper(gs_user)
end if

idw_1.Modify("DataWindow.Print.Preview=Yes")
end event

event open;//override
string ls_cliepro

is_prov = Message.Stringparm

if is_prov <> '' then
	
	select flag_clie_prov
	  into :ls_cliepro
	  from proveedor
	 where proveedor = :is_prov;
	 
	 if ls_cliepro = '0' then
		rb_3.enabled = false
	elseif ls_cliepro = '1' then
		rb_2.enabled = false
	end if

else
	
	cbx_1.checked = true
	cbx_1.enabled = false
	rb_1.enabled = false
	rb_1.checked = false
	rb_2.enabled = true
	rb_2.checked = false
	rb_3.enabled = true
	rb_3.checked = false
	
end if

IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

type dw_report from w_report_smpl`dw_report within w_cm002_proveedor_ficha
integer x = 0
integer y = 92
integer width = 4183
integer height = 1104
string dataobject = "d_rpt_proveedor_basc_ficha_composite"
boolean ib_preview = true
end type

type rb_1 from radiobutton within w_cm002_proveedor_ficha
integer y = 8
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "General"
boolean checked = true
end type

event clicked;parent.post event ue_retrieve()
end event

type rb_2 from radiobutton within w_cm002_proveedor_ficha
integer x = 439
integer y = 8
integer width = 640
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ficha BASC Cliente"
end type

event clicked;parent.post event ue_retrieve()
end event

type rb_3 from radiobutton within w_cm002_proveedor_ficha
integer x = 1152
integer y = 8
integer width = 727
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ficha BASC Proveedor"
end type

event clicked;parent.post event ue_retrieve()
end event

type cbx_1 from checkbox within w_cm002_proveedor_ficha
integer x = 1966
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "En Blanco"
end type

event clicked;parent.post event ue_retrieve()
end event

