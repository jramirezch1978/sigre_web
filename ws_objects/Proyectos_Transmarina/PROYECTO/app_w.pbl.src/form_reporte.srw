$PBExportHeader$form_reporte.srw
forward
global type form_reporte from window
end type
type pb_3 from picturebutton within form_reporte
end type
type cbx_1 from checkbox within form_reporte
end type
type dw_4 from datawindow within form_reporte
end type
type dw_3 from datawindow within form_reporte
end type
type dw_2 from datawindow within form_reporte
end type
type cb_1 from commandbutton within form_reporte
end type
type st_4 from statictext within form_reporte
end type
type em_2 from editmask within form_reporte
end type
type st_3 from statictext within form_reporte
end type
type em_1 from editmask within form_reporte
end type
type st_2 from statictext within form_reporte
end type
type gb_2 from groupbox within form_reporte
end type
type st_1 from statictext within form_reporte
end type
type sle_buscar_prov from singlelineedit within form_reporte
end type
type rb_2 from radiobutton within form_reporte
end type
type rb_1 from radiobutton within form_reporte
end type
type sle_moneda from singlelineedit within form_reporte
end type
type dw_1 from datawindow within form_reporte
end type
type gb_1 from groupbox within form_reporte
end type
type pb_1 from picturebutton within form_reporte
end type
type pb_2 from picturebutton within form_reporte
end type
type gb_3 from groupbox within form_reporte
end type
end forward

global type form_reporte from window
integer width = 5819
integer height = 3280
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
pb_3 pb_3
cbx_1 cbx_1
dw_4 dw_4
dw_3 dw_3
dw_2 dw_2
cb_1 cb_1
st_4 st_4
em_2 em_2
st_3 st_3
em_1 em_1
st_2 st_2
gb_2 gb_2
st_1 st_1
sle_buscar_prov sle_buscar_prov
rb_2 rb_2
rb_1 rb_1
sle_moneda sle_moneda
dw_1 dw_1
gb_1 gb_1
pb_1 pb_1
pb_2 pb_2
gb_3 gb_3
end type
global form_reporte form_reporte

on form_reporte.create
this.pb_3=create pb_3
this.cbx_1=create cbx_1
this.dw_4=create dw_4
this.dw_3=create dw_3
this.dw_2=create dw_2
this.cb_1=create cb_1
this.st_4=create st_4
this.em_2=create em_2
this.st_3=create st_3
this.em_1=create em_1
this.st_2=create st_2
this.gb_2=create gb_2
this.st_1=create st_1
this.sle_buscar_prov=create sle_buscar_prov
this.rb_2=create rb_2
this.rb_1=create rb_1
this.sle_moneda=create sle_moneda
this.dw_1=create dw_1
this.gb_1=create gb_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.gb_3=create gb_3
this.Control[]={this.pb_3,&
this.cbx_1,&
this.dw_4,&
this.dw_3,&
this.dw_2,&
this.cb_1,&
this.st_4,&
this.em_2,&
this.st_3,&
this.em_1,&
this.st_2,&
this.gb_2,&
this.st_1,&
this.sle_buscar_prov,&
this.rb_2,&
this.rb_1,&
this.sle_moneda,&
this.dw_1,&
this.gb_1,&
this.pb_1,&
this.pb_2,&
this.gb_3}
end on

on form_reporte.destroy
destroy(this.pb_3)
destroy(this.cbx_1)
destroy(this.dw_4)
destroy(this.dw_3)
destroy(this.dw_2)
destroy(this.cb_1)
destroy(this.st_4)
destroy(this.em_2)
destroy(this.st_3)
destroy(this.em_1)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.st_1)
destroy(this.sle_buscar_prov)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.sle_moneda)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.gb_3)
end on

event open;cbx_1.Enabled = false
rb_2.checked = true
em_1.Enabled = false
em_2.Enabled = false
sle_buscar_prov.Enabled = false
em_1.TextColor = RGB(0,128,128)
em_2.TextColor = RGB(0,128,128)
dw_1.Visible = false
dw_2.Visible = false
dw_4.Visible = false
pb_1.Enabled = false
pb_2.Enabled = false
//dw_3.Visible = false





end event

type pb_3 from picturebutton within form_reporte
integer x = 3872
integer y = 228
integer width = 219
integer height = 208
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\Users\richard\Downloads\excel-128.png"
alignment htextalign = left!
string powertiptext = "Exportar a Excel"
end type

event clicked;	string ls_path
	string ls_file
	
if dw_1.Visible = true then	
	setpointer(hourglass!)
	form_reporte.setmicrohelp("Exportando archivo a formato Excel...")
	oleobject luo_excel_1	
	if getfilesavename ( 'Archivos',&
	ls_path,ls_file,&
	'XLS',&
	'XLS Files (*.XLS), *.XLS') = 1 then
		if dw_1.saveas(ls_path,HTMLTable!,true) = 1 then
		luo_excel_1 = create oleobject
			if luo_excel_1.connecttoobject(ls_path) = 0 then
			luo_excel_1.application.displayalerts = false
			luo_excel_1.application.workbooks(1).parent.windows(luo_excel_1.application.workbooks(1).name).visible = true
			luo_excel_1.application.workbooks(1).saveas(ls_path,-4143)
			luo_excel_1.application.workbooks(1).close()
			luo_excel_1.disconnectobject()
			end if
			destroy luo_excel_1
		end if
	end if
	setpointer(arrow!)
	form_reporte.setmicrohelp("Listo...")
elseif dw_2.Visible = true then	
	setpointer(hourglass!)
	form_reporte.setmicrohelp("Exportando archivo a formato Excel...")
	oleobject luo_excel_2	
	if getfilesavename ( 'Archivos',&
	ls_path,ls_file,&
	'XLS',&
	'XLS Files (*.XLS), *.XLS') = 1 then
		if dw_2.saveas(ls_path,HTMLTable!,true) = 1 then
		luo_excel_2 = create oleobject
			if luo_excel_2.connecttoobject(ls_path) = 0 then
			luo_excel_2.application.displayalerts = false
			luo_excel_2.application.workbooks(1).parent.windows(luo_excel_2.application.workbooks(1).name).visible = true
			luo_excel_2.application.workbooks(1).saveas(ls_path,-4143)
			luo_excel_2.application.workbooks(1).close()
			luo_excel_2.disconnectobject()
			end if
			destroy luo_excel_2
		end if
	end if
	setpointer(arrow!)
	form_reporte.setmicrohelp("Listo...")
elseif dw_3.Visible = true then
	setpointer(hourglass!)
	form_reporte.setmicrohelp("Exportando archivo a formato Excel...")
	oleobject luo_excel_3
	if getfilesavename ( 'Archivos',&
	ls_path,ls_file,&
	'XLS',&
	'XLS Files (*.XLS), *.XLS') = 1 then
		if dw_3.saveas(ls_path,HTMLTable!,true) = 1 then
		luo_excel_3 = create oleobject
			if luo_excel_3.connecttoobject(ls_path) = 0 then
			luo_excel_3.application.displayalerts = false
			luo_excel_3.application.workbooks(1).parent.windows(luo_excel_3.application.workbooks(1).name).visible = true
			luo_excel_3.application.workbooks(1).saveas(ls_path,-4143)
			luo_excel_3.application.workbooks(1).close()
			luo_excel_3.disconnectobject()
			end if
			destroy luo_excel_3
		end if
	end if
	setpointer(arrow!)
	form_reporte.setmicrohelp("Listo...")
elseif dw_4.Visible = true then
	setpointer(hourglass!)
	form_reporte.setmicrohelp("Exportando archivo a formato Excel...")
	oleobject luo_excel

	if getfilesavename ( 'Archivos',&
	ls_path,ls_file,&
	'XLS',&
	'XLS Files (*.XLS), *.XLS') = 1 then
		if dw_4.saveas(ls_path,HTMLTable!,true) = 1 then
		luo_excel = create oleobject
			if luo_excel.connecttoobject(ls_path) = 0 then
			luo_excel.application.displayalerts = false
			luo_excel.application.workbooks(1).parent.windows(luo_excel.application.workbooks(1).name).visible = true
			luo_excel.application.workbooks(1).saveas(ls_path,-4143)
			luo_excel.application.workbooks(1).close()
			luo_excel.disconnectobject()
			end if
			destroy luo_excel
		end if
	end if
	setpointer(arrow!)
	form_reporte.setmicrohelp("Listo...")
end if
end event

type cbx_1 from checkbox within form_reporte
integer x = 2555
integer y = 268
integer width = 78
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if cbx_1.checked = true then
	sle_buscar_prov.Enabled = false
	pb_1.Enabled = false
	pb_2.Enabled = true
	em_1.Enabled = true
	em_2.Enabled = true
	em_1.SetFocus()
else
	pb_1.Enabled = true
	sle_buscar_prov.Enabled = true
	sle_buscar_prov.SetFocus()
	pb_2.Enabled = false
	em_1.Enabled = false
	em_2.Enabled = false
	em_1.text = ""
	em_2.text = ""
end if
end event

type dw_4 from datawindow within form_reporte
integer x = 37
integer y = 576
integer width = 5678
integer height = 2344
integer taborder = 60
string title = "none"
string dataobject = "dw_dt_prov_dolares"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_3 from datawindow within form_reporte
integer x = 37
integer y = 576
integer width = 5678
integer height = 2344
integer taborder = 40
string title = "none"
string dataobject = "dw_total_dol"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type dw_2 from datawindow within form_reporte
integer x = 37
integer y = 576
integer width = 5678
integer height = 2344
integer taborder = 20
string title = "none"
string dataobject = "dw_dt_prov_soles"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within form_reporte
integer x = 3250
integer y = 404
integer width = 329
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string text = "Mostrar"
end type

event clicked;cbx_1.Enabled = true
cbx_1.Checked = false
sle_buscar_prov.Text=""
sle_buscar_prov.Enabled = true
sle_buscar_prov.SetFocus()
pb_1.Enabled = true
pb_2.Enabled = false
em_1.Enabled = false
em_1.Text = ""
em_2.Text = ""
em_2.Enabled = false
//Seleccion por soles y deuda total del proveedor
if sle_moneda.text = "S/." and rb_2.checked = true then
	dw_1.settransobject(sqlca)
	dw_1.retrieve()
	dw_1.Visible = true
	dw_2.Visible=false
	dw_3.Visible=false
	dw_4.Visible=false
	if sle_buscar_prov.text = "" then
		dw_1.SetFilter("")
	else
	end if
	dw_1.Filter( )
	dw_1.settransobject(sqlca)
	dw_1.retrieve()
else
end if

//Seleccion por soles y detalle del proveedor
if sle_moneda.text = "S/." and rb_1.checked = true then
	dw_2.settransobject(sqlca)
	dw_2.retrieve()
	dw_2.Visible=true
	dw_1.Visible=false
	dw_3.Visible=false
	dw_4.Visible=false
	if sle_buscar_prov.text = "" then
		dw_2.SetFilter("")
	else
	end if
	dw_2.Filter( )
	dw_2.settransobject(sqlca)
	dw_2.retrieve()
else
end if

//Seleccion por dolares y deuda total del proveedor
if sle_moneda.text = "US$" and rb_2.checked = true then
	dw_3.settransobject(sqlca)
	dw_3.retrieve()
	dw_3.Visible=true
	dw_1.Visible=false
	dw_2.Visible=false
	dw_4.Visible=false
	if sle_buscar_prov.text = "" then
		dw_3.SetFilter("")
	else
	end if
	dw_3.Filter( )
	dw_3.settransobject(sqlca)
	dw_3.retrieve()
else
end if


//Seleccion por dolares y detalle del proveedor
if sle_moneda.text = "US$" and rb_1.checked = true then
	dw_4.settransobject(sqlca)
	dw_4.retrieve()
	dw_4.Visible=true
	dw_1.Visible=false
	dw_2.Visible=false
	dw_3.Visible=false
	if sle_buscar_prov.text = "" then
		dw_4.SetFilter("")
	else
	end if
	dw_4.Filter( )
	dw_4.settransobject(sqlca)
	dw_4.retrieve()
else
end if
end event

type st_4 from statictext within form_reporte
integer x = 2697
integer y = 428
integer width = 233
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda:"
boolean focusrectangle = false
end type

type em_2 from editmask within form_reporte
integer x = 1998
integer y = 400
integer width = 402
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###,###,##0.00"
end type

type st_3 from statictext within form_reporte
integer x = 2002
integer y = 332
integer width = 311
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Final:"
boolean focusrectangle = false
end type

type em_1 from editmask within form_reporte
integer x = 1522
integer y = 400
integer width = 402
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###,###,##0.00"
end type

type st_2 from statictext within form_reporte
integer x = 1527
integer y = 332
integer width = 311
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Saldo Inicial:"
boolean focusrectangle = false
end type

type gb_2 from groupbox within form_reporte
integer x = 1477
integer y = 220
integer width = 1175
integer height = 308
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar por saldo del proveedor:"
end type

type st_1 from statictext within form_reporte
integer x = 137
integer y = 416
integer width = 293
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor:"
boolean focusrectangle = false
end type

type sle_buscar_prov from singlelineedit within form_reporte
event dobleclick pbm_lbuttondblclk
integer x = 430
integer y = 400
integer width = 818
integer height = 88
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event dobleclick;open(busqueda_proveedor)
end event

type rb_2 from radiobutton within form_reporte
integer x = 165
integer y = 296
integer width = 731
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Deuda total por Proveedor"
end type

event clicked;em_1.text=""
em_2.text=""
sle_buscar_prov.text=""
em_1.SetFocus()
end event

type rb_1 from radiobutton within form_reporte
integer x = 165
integer y = 200
integer width = 507
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle Proveedor"
end type

event clicked;em_1.text=""
em_2.text=""
sle_buscar_prov.text=""
em_1.SetFocus()
//dw_1.SetFilter("")
//dw_1.Filter( )
//dw_1.settransobject(sqlca)
//dw_1.retrieve()	
end event

type sle_moneda from singlelineedit within form_reporte
event dobleclick pbm_lbuttondblclk
integer x = 2930
integer y = 404
integer width = 297
integer height = 92
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
string text = "US$"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event dobleclick;open(busqueda_moneda)
end event

type dw_1 from datawindow within form_reporte
integer x = 37
integer y = 576
integer width = 5678
integer height = 2344
integer taborder = 10
string title = "none"
string dataobject = "dw_total_sol"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within form_reporte
integer x = 37
integer y = 100
integer width = 3712
integer height = 456
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar Proveedor"
end type

type pb_1 from picturebutton within form_reporte
integer x = 1257
integer y = 392
integer width = 114
integer height = 104
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string picturename = "C:\Users\richard\Downloads\buscar.png"
alignment htextalign = left!
string powertiptext = "Buscar proveedor"
long backcolor = 67108864
end type

event clicked;//Variable
string ls_buscar
ls_buscar= sle_buscar_prov.text

if ls_buscar = "" then
	messagebox("AVISO","Seleccione un proveedor haciendo doble click...!!",Information!)
else
	//Seleccion por soles y deuda total del proveedor
	if ls_buscar = "" then
		dw_1.SetFilter("")
		elseif sle_moneda.text = "S/." and rb_2.checked = true then	
			ls_buscar="%" + trim(sle_buscar_prov.text)+"%"
			dw_1.SetFilter("upper(nom_proveedor) like '"+ ls_buscar +"' ")
			dw_1.Visible=true
			dw_3.Visible=false
			dw_2.Visible=false
			dw_4.Visible=false
	else
	end if
	dw_1.Filter( )
	dw_1.settransobject(sqlca)
	dw_1.retrieve()	
	
	//Seleccion por soles y detalle del proveedor
	if ls_buscar = "" then
		dw_2.SetFilter("")
		elseif sle_moneda.text = "S/." and rb_1.checked = true then	
			ls_buscar="%" + trim(sle_buscar_prov.text)+"%"
			dw_2.SetFilter("upper(nom_proveedor) like '"+ ls_buscar +"' ")
			dw_2.Visible=true
			dw_1.Visible=false
			dw_3.Visible=false
			dw_4.Visible=false
	else
	end if
	dw_2.Filter( )
	dw_2.settransobject(sqlca)
	dw_2.retrieve()
	
	//Buscar proveedor por dolares y deuda total del proveedor
	if ls_buscar = "" then
		dw_3.SetFilter("")
		elseif sle_moneda.text = "US$" and rb_2.checked = true then	
			ls_buscar="%" + trim(sle_buscar_prov.text)+"%"
			dw_3.SetFilter("upper(nom_proveedor) like '"+ ls_buscar +"' ")
			dw_3.Visible=true
			dw_1.Visible=false
			dw_2.Visible=false
			dw_4.Visible=false
	else
	end if
	dw_3.Filter( )
	dw_3.settransobject(sqlca)
	dw_3.retrieve()
		
	//Seleccion por dolares y detalle del proveedor
	if ls_buscar = "" then
		dw_4.SetFilter("")
		elseif sle_moneda.text = "US$" and rb_1.checked = true then	
			ls_buscar="%" + trim(sle_buscar_prov.text)+"%"
			dw_4.SetFilter("upper(nom_proveedor) like '"+ ls_buscar +"' ")
			dw_4.Visible=true
			dw_1.Visible=false
			dw_2.Visible=false
			dw_3.Visible=false
	else
	end if
	dw_4.Filter( )
	dw_4.settransobject(sqlca)
	dw_4.retrieve()
end if
end event

type pb_2 from picturebutton within form_reporte
integer x = 2409
integer y = 396
integer width = 137
integer height = 96
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Segoe UI"
string picturename = "C:\Users\richard\Downloads\simbolo-de-herramienta-llena-de-filtro.png"
alignment htextalign = left!
long backcolor = 67108864
end type

event clicked;//Filtro para dw_1
string saldo_ini,saldo_fin
//asignar valores a las variables
saldo_ini = string(em_1.Text)  
saldo_fin = string(em_2.Text) 

	//Seleccion por soles y deuda total del proveedor
	if sle_moneda.text = "S/." and rb_2.checked = true then	
		dw_1.setfilter("saldo_sol between double('" + saldo_ini + "' ) and double('"+ saldo_fin +"' ) " ) 
		dw_1.filter()
		dw_1.Visible=true
		dw_3.Visible=false
		dw_2.Visible=false
		dw_4.Visible=false
	else
	end if
		dw_1.settransobject(sqlca)
		dw_1.retrieve()	
	
	//Seleccion por soles y detalle del proveedor
	if sle_moneda.text = "S/." and rb_1.checked = true then	
		dw_2.setfilter("saldo_sol between double('" + saldo_ini + "' ) and double('"+ saldo_fin +"' ) " ) 
		dw_2.filter()
		dw_2.Visible=true
		dw_1.Visible=false
		dw_3.Visible=false
		dw_4.Visible=false
	else
	end if
		dw_2.settransobject(sqlca)
		dw_2.retrieve()	
	
	//Buscar proveedor por dolares y deuda total del proveedor
	if sle_moneda.text = "US$" and rb_2.checked = true then	
		dw_3.setfilter("saldo_dol between double('" + saldo_ini + "' ) and double('"+ saldo_fin +"' ) " ) 
		dw_3.filter()
		dw_3.Visible=true
		dw_1.Visible=false
		dw_2.Visible=false
		dw_4.Visible=false
	else
	end if
		dw_3.settransobject(sqlca)
		dw_3.retrieve()	
		
	//Seleccion por dolares y detalle del proveedor
	if sle_moneda.text = "US$" and rb_1.checked = true then	
		dw_4.setfilter("saldo_dol between double('" + saldo_ini + "' ) and double('"+ saldo_fin +"' ) " ) 
		dw_4.filter()
		dw_4.Visible=true
		dw_1.Visible=false
		dw_2.Visible=false
		dw_3.Visible=false
	else
	end if
		dw_4.settransobject(sqlca)
		dw_4.retrieve()	

end event

type gb_3 from groupbox within form_reporte
integer x = 3799
integer y = 92
integer width = 480
integer height = 456
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

