$PBExportHeader$w_cn502_cntbl_cns_cnta_crrte.srw
forward
global type w_cn502_cntbl_cns_cnta_crrte from w_cns_list
end type
type sle_cuenta from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
end type
type sle_descripcion from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
end type
type cb_1 from commandbutton within w_cn502_cntbl_cns_cnta_crrte
end type
type sle_year from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
end type
type sle_mes1 from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
end type
type sle_mes2 from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
end type
type st_1 from statictext within w_cn502_cntbl_cns_cnta_crrte
end type
type st_2 from statictext within w_cn502_cntbl_cns_cnta_crrte
end type
type st_3 from statictext within w_cn502_cntbl_cns_cnta_crrte
end type
type pb_3 from picturebutton within w_cn502_cntbl_cns_cnta_crrte
end type
type gb_1 from groupbox within w_cn502_cntbl_cns_cnta_crrte
end type
type gb_3 from groupbox within w_cn502_cntbl_cns_cnta_crrte
end type
type cbx_1 from checkbox within w_cn502_cntbl_cns_cnta_crrte
end type
end forward

global type w_cn502_cntbl_cns_cnta_crrte from w_cns_list
integer width = 3515
integer height = 2316
string title = "Saldos de Cuenta Corriente por Cuenta Contable (CN502)"
string menuname = "m_abc_report_smpl"
sle_cuenta sle_cuenta
sle_descripcion sle_descripcion
cb_1 cb_1
sle_year sle_year
sle_mes1 sle_mes1
sle_mes2 sle_mes2
st_1 st_1
st_2 st_2
st_3 st_3
pb_3 pb_3
gb_1 gb_1
gb_3 gb_3
cbx_1 cbx_1
end type
global w_cn502_cntbl_cns_cnta_crrte w_cn502_cntbl_cns_cnta_crrte

on w_cn502_cntbl_cns_cnta_crrte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_cuenta=create sle_cuenta
this.sle_descripcion=create sle_descripcion
this.cb_1=create cb_1
this.sle_year=create sle_year
this.sle_mes1=create sle_mes1
this.sle_mes2=create sle_mes2
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.pb_3=create pb_3
this.gb_1=create gb_1
this.gb_3=create gb_3
this.cbx_1=create cbx_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_cuenta
this.Control[iCurrent+2]=this.sle_descripcion
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_year
this.Control[iCurrent+5]=this.sle_mes1
this.Control[iCurrent+6]=this.sle_mes2
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.pb_3
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.cbx_1
end on

on w_cn502_cntbl_cns_cnta_crrte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_cuenta)
destroy(this.sle_descripcion)
destroy(this.cb_1)
destroy(this.sle_year)
destroy(this.sle_mes1)
destroy(this.sle_mes2)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.pb_3)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.cbx_1)
end on

event resize;// Override

//dw_master.width  = newwidth  - dw_master.x - 10
dw_cns.width  = newwidth  - dw_cns.x - 10
dw_cns.height = newheight - dw_cns.y - 10


end event

event ue_open_pre;call super::ue_open_pre;date ld_today

ld_today = Date(gnvo_app.of_fecha_Actual())

sle_year.text = string(ld_today, 'yyyy')
sle_mes1.text = '00'
sle_mes2.text = string(ld_today, 'mm')


end event

type dw_1 from w_cns_list`dw_1 within w_cn502_cntbl_cns_cnta_crrte
integer x = 101
integer y = 340
integer width = 1399
integer height = 1044
integer taborder = 0
boolean enabled = false
string dataobject = "d_cntbl_codrel_tbl"
end type

event dw_1::constructor;call super::constructor;idw_1 = dw_cns
idw_1.Visible = False

dw_1.SetTransObject(sqlca)
dw_1.retrieve()
dw_2.SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type pb_1 from w_cns_list`pb_1 within w_cn502_cntbl_cns_cnta_crrte
integer x = 1550
integer y = 676
integer width = 96
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "»"
alignment htextalign = center!
end type

type pb_2 from w_cns_list`pb_2 within w_cn502_cntbl_cns_cnta_crrte
integer x = 1550
integer y = 916
integer width = 96
integer height = 84
integer taborder = 0
integer textsize = -10
string text = "«"
alignment htextalign = center!
end type

type dw_2 from w_cns_list`dw_2 within w_cn502_cntbl_cns_cnta_crrte
integer x = 1705
integer y = 340
integer width = 1399
integer height = 1044
integer taborder = 0
boolean enabled = false
string dataobject = "d_cntbl_codrel_tbl"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2

end event

type cb_consulta from w_cns_list`cb_consulta within w_cn502_cntbl_cns_cnta_crrte
integer x = 2811
integer y = 12
integer width = 265
integer height = 156
integer textsize = -8
integer weight = 700
string text = "Reporte"
end type

event cb_consulta::clicked;call super::clicked;string  ls_codigo, ls_descripcion, ls_cuenta
integer li_i, li_year, li_mes1, li_mes2

li_year 	= Integer(sle_year.text)
li_mes1	= Integer(sle_mes1.text)
li_mes2 	= Integer(sle_mes2.text)
ls_cuenta = trim(sle_cuenta.text) + '%'

delete from tt_cntbl_codrel ;

if cbx_1.checked then
	insert into tt_cntbl_codrel(codigo, descripcion)
	select distinct cad.cod_relacion, substr(p.nom_proveedor,1,50)
	   from	cntbl_asiento 		ca,
				cntbl_Asiento_Det cad,
				proveedor			p
		where ca.origen 			= cad.origen
		  and ca.ano				= cad.ano
		  and ca.mes				= cad.mes
		  and ca.nro_libro		= cad.nro_libro
		  and ca.nro_asiento		= cad.nro_Asiento
		  and cad.cod_relacion	= p.proveedor
		  and ca.ano				= :li_year
		  and ca.mes				between :li_mes1 and :li_mes2
		  and cad.cnta_ctbl		like :ls_cuenta;
	
	if gnvo_app.of_ExistsError(SQLCA, "Insert tt_cntbl_codrel") then return
		  
else
	for li_i = 1 to dw_2.rowcount()
		 ls_codigo      = dw_2.object.proveedor[li_i]
		 ls_descripcion = dw_2.object.nom_proveedor[li_i]
		 
		 insert into tt_cntbl_codrel (codigo, descripcion)
		 values (:ls_codigo, :ls_descripcion) ;
		 
		 if sqlca.sqlcode = -1 then
			 MessageBox("Error al Insertar Registro",sqlca.sqlerrtext)
		end if
	next
end if


commit;

// Oculta objetos
gb_3.visible=false
dw_1.visible=false
dw_2.visible=false
pb_1.visible=false
pb_1.visible=false
cbx_1.visible = false


dw_cns.SetTransObject(sqlca)
dw_cns.visible=true
dw_cns.Retrieve(ls_cuenta, li_year, li_mes1, li_mes2)
//parent.event ue_retrieve_list()

pb_3.visible = true

end event

type dw_cns from w_cns_list`dw_cns within w_cn502_cntbl_cns_cnta_crrte
boolean visible = false
integer x = 0
integer y = 208
integer width = 3419
integer height = 1804
integer taborder = 0
string dataobject = "d_cntbl_cns_cnta_crrte1_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_cns::constructor;call super::constructor;//Asignacion de variable sin efecto alguno
ii_ck[1] = 1 //Columna de lectura del dw.

end event

event dw_cns::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "codigo"  
		lstr_1.DataObject = 'd_cntbl_cns_cnta_crrte2_tbl'
		lstr_1.Width = 3050
		lstr_1.Height= 1510
		lstr_1.Title = 'Saldos de Documentos por Cliente'
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

type sle_cuenta from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
integer x = 69
integer y = 72
integer width = 320
integer height = 84
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_descripcion from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
integer x = 535
integer y = 72
integer width = 1399
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn502_cntbl_cns_cnta_crrte
integer x = 407
integer y = 72
integer width = 96
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_cnta_cntbl 	lstr_cnta	
lstr_cnta = gnvo_cntbl.of_get_cnta_cntbl()
		
if lstr_cnta.b_return = true then
	sle_cuenta.text = lstr_cnta.cnta_cntbl
	sle_descripcion.text = lstr_cnta.desc_cnta
end if
end event

type sle_year from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
integer x = 2011
integer y = 112
integer width = 165
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes1 from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
integer x = 2194
integer y = 112
integer width = 165
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes2 from singlelineedit within w_cn502_cntbl_cns_cnta_crrte
integer x = 2377
integer y = 112
integer width = 165
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn502_cntbl_cns_cnta_crrte
integer x = 2021
integer y = 32
integer width = 165
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn502_cntbl_cns_cnta_crrte
integer x = 2194
integer y = 36
integer width = 165
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 12632256
string text = "M.I."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn502_cntbl_cns_cnta_crrte
integer x = 2377
integer y = 36
integer width = 165
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 12632256
string text = "M.F."
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_cn502_cntbl_cns_cnta_crrte
integer x = 2565
integer y = 4
integer width = 233
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\BMP\retroceder.bmp"
end type

event clicked;
gb_3.visible=true
dw_1.visible=true
dw_2.visible=true
pb_1.visible=true
pb_1.visible=true
dw_cns.visible=false
cbx_1.visible = true

this.visible = false

end event

type gb_1 from groupbox within w_cn502_cntbl_cns_cnta_crrte
integer width = 1993
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Cuenta Contable "
end type

type gb_3 from groupbox within w_cn502_cntbl_cns_cnta_crrte
integer x = 46
integer y = 260
integer width = 3113
integer height = 1156
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type cbx_1 from checkbox within w_cn502_cntbl_cns_cnta_crrte
integer y = 204
integer width = 1458
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los proveedores"
boolean checked = true
end type

event clicked;if this.checked then
	dw_1.enabled = false
	dw_2.enabled = false
	
else
	
	dw_1.enabled = true
	dw_2.enabled = true
end if
end event

