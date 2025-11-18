$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_connect from commandbutton within w_main
end type
type cb_sqlserver from commandbutton within w_main
end type
type cb_datasources from commandbutton within w_main
end type
type ddlb_tables from dropdownlistbox within w_main
end type
type mle_source from multilineedit within w_main
end type
type cb_sprocs from commandbutton within w_main
end type
type lb_stuff from listbox within w_main
end type
type lb_columns from listbox within w_main
end type
type lb_tables from listbox within w_main
end type
type cb_tables from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 4073
integer height = 2484
boolean titlebar = true
string title = "ODBC API"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_connect cb_connect
cb_sqlserver cb_sqlserver
cb_datasources cb_datasources
ddlb_tables ddlb_tables
mle_source mle_source
cb_sprocs cb_sprocs
lb_stuff lb_stuff
lb_columns lb_columns
lb_tables lb_tables
cb_tables cb_tables
cb_cancel cb_cancel
end type
global w_main w_main

type variables
n_odbcapi in_api
s_tables istr_tables[]
s_sprocs istr_sprocs[]
Boolean ib_sprocs

end variables

on w_main.create
this.cb_connect=create cb_connect
this.cb_sqlserver=create cb_sqlserver
this.cb_datasources=create cb_datasources
this.ddlb_tables=create ddlb_tables
this.mle_source=create mle_source
this.cb_sprocs=create cb_sprocs
this.lb_stuff=create lb_stuff
this.lb_columns=create lb_columns
this.lb_tables=create lb_tables
this.cb_tables=create cb_tables
this.cb_cancel=create cb_cancel
this.Control[]={this.cb_connect,&
this.cb_sqlserver,&
this.cb_datasources,&
this.ddlb_tables,&
this.mle_source,&
this.cb_sprocs,&
this.lb_stuff,&
this.lb_columns,&
this.lb_tables,&
this.cb_tables,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.cb_connect)
destroy(this.cb_sqlserver)
destroy(this.cb_datasources)
destroy(this.ddlb_tables)
destroy(this.mle_source)
destroy(this.cb_sprocs)
destroy(this.lb_stuff)
destroy(this.lb_columns)
destroy(this.lb_tables)
destroy(this.cb_tables)
destroy(this.cb_cancel)
end on

event open;ddlb_tables.SelectItem(2)

end event

type cb_connect from commandbutton within w_main
integer x = 2377
integer y = 64
integer width = 517
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Connect"
end type

event constructor;this.Enabled = False

end event

event clicked;String ls_profile
Long ll_len

SetPointer(HourGlass!)

ls_profile = lb_stuff.SelectedItem()
If IsNull(ls_profile) Or ls_profile = "" Then
	Return
End If

ll_len = Pos(ls_profile, " - ")
ls_profile = Left(ls_profile, ll_len - 1)

lb_tables.Reset()
lb_columns.Reset()
lb_stuff.Reset()
mle_source.text = ""

// disconnect from database
disconnect;

// set connection properties
sqlca.DBParm = "ConnectString='DSN=" + ls_profile + "'"

// connect to database
connect;

If sqlca.SQLCode < 0 Then
	MessageBox("Connect Failed", sqlca.SQLErrText)
End If

this.Enabled = False

end event

type cb_sqlserver from commandbutton within w_main
integer x = 2962
integer y = 64
integer width = 517
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "SQL Server"
end type

event clicked;String ls_Servers[]
Integer li_idx, li_max

SetPointer(HourGlass!)

ib_sprocs = False

lb_stuff.Reset()
mle_source.Text = ""

li_max = in_api.of_SQLServers(ls_Servers)

For li_idx = 1 To li_max
	lb_stuff.AddItem(ls_Servers[li_idx])
Next

lb_stuff.SelectItem(1)

cb_connect.Enabled = False

end event

type cb_datasources from commandbutton within w_main
integer x = 1792
integer y = 64
integer width = 517
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "DataSources"
end type

event clicked;String ls_name[], ls_driver[], ls_additem
Integer li_cnt, li_max

SetPointer(HourGlass!)

ib_sprocs = False

lb_stuff.Reset()
mle_source.Text = ""

lb_stuff.SetRedraw(False)

li_max = in_api.of_DataSources("ALL", ls_name, ls_driver)
For li_cnt = 1 To li_max
	ls_additem = ls_name[li_cnt] + " - " + ls_driver[li_cnt]
	lb_stuff.AddItem(ls_additem)
Next

lb_stuff.SetRedraw(True)

cb_connect.Enabled = True

end event

type ddlb_tables from dropdownlistbox within w_main
integer x = 37
integer y = 64
integer width = 517
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"All Tables & Views","User Tables","User Views","System Tables","System Views"}
borderstyle borderstyle = stylelowered!
end type

type mle_source from multilineedit within w_main
integer x = 1792
integer y = 1312
integer width = 2199
integer height = 1028
integer taborder = 110
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_sprocs from commandbutton within w_main
integer x = 1207
integer y = 64
integer width = 517
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Stored Procedures"
end type

event clicked;String ls_additem
Integer li_idx, li_max

SetPointer(HourGlass!)

ib_sprocs = True

lb_stuff.Reset()
mle_source.Text = ""

lb_stuff.SetRedraw(False)

li_max = in_api.of_Sprocs(istr_sprocs)
For li_idx = 1 To li_max
	ls_additem  = istr_sprocs[li_idx].Schema + "."
	ls_additem += istr_sprocs[li_idx].Name
	lb_stuff.AddItem(ls_additem)
Next

lb_stuff.SetRedraw(True)

If li_max > 0 Then
	lb_stuff.SelectItem(1)
	lb_stuff.Event SelectionChanged(1)
	lb_stuff.SetFocus()
End If

cb_connect.Enabled = False

end event

type lb_stuff from listbox within w_main
integer x = 1792
integer y = 224
integer width = 2199
integer height = 1028
integer taborder = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;String ls_schema, ls_sproc, ls_source

If index = 0 Then Return

If ib_sprocs Then
	ls_schema = istr_sprocs[index].Schema
	ls_sproc  = istr_sprocs[index].Name
	mle_source.Text = ""
	mle_source.SetRedraw(False)
	If in_api.of_SprocSource(ls_schema, ls_sproc, ls_source) > 0 Then
		mle_source.Text = ls_source
	End If
	mle_source.SetRedraw(True)
End If

end event

type lb_columns from listbox within w_main
integer x = 37
integer y = 1312
integer width = 1687
integer height = 1028
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type lb_tables from listbox within w_main
integer x = 37
integer y = 224
integer width = 1687
integer height = 1028
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;s_columns lstr_columns[]
s_primarykeys lstr_pkeys[]
s_foreignkeys lstr_fkeys[]
Integer li_idx, li_max
String ls_schema, ls_table, ls_additem, ls_type

If index = 0 Then Return

ls_schema = istr_tables[index].Schema
ls_table  = istr_tables[index].Name

lb_columns.Reset()

lb_columns.SetRedraw(False)

lb_columns.AddItem("Columns:")
li_max = in_api.of_Columns(ls_schema, ls_table, lstr_columns)
For li_idx = 1 To li_max
	ls_additem  = lstr_columns[li_idx].Name + " - "
	ls_additem += lstr_columns[li_idx].DataType
	If lstr_columns[li_idx].Width > 0 Then
		If lstr_columns[li_idx].Decimal = 0 Then
			ls_additem += "("
			ls_additem += String(lstr_columns[li_idx].Width)
			ls_additem += ")"
		Else
			ls_additem += "("
			ls_additem += String(lstr_columns[li_idx].Width)
			ls_additem += ","
			ls_additem += String(lstr_columns[li_idx].Decimal)
			ls_additem += ")"
		End if
	End If
	lb_columns.AddItem(ls_additem)
Next

lb_columns.SetRedraw(True)

ls_type = ddlb_tables.Text
choose case ls_type
	case "User Tables", "System Tables"
		li_max = in_api.of_PrimaryKeys(ls_schema, ls_table, lstr_pkeys)
		If li_max > 0 Then
			lb_columns.AddItem("")
			lb_columns.AddItem("Primary Keys:")
		End If
		For li_idx = 1 To li_max
			ls_additem  = lstr_pkeys[li_idx].pkname + " - "
			ls_additem += lstr_pkeys[li_idx].colname
			lb_columns.AddItem(ls_additem)
		Next
		li_max = in_api.of_ForeignKeys(ls_schema, ls_table, lstr_fkeys)
		If li_max > 0 Then
			lb_columns.AddItem("")
			lb_columns.AddItem("Foreign Keys:")
		End If
		For li_idx = 1 To li_max
			ls_additem  = lstr_fkeys[li_idx].fkname + " - "
			ls_additem += lstr_fkeys[li_idx].fkcolumn
			lb_columns.AddItem(ls_additem)
		Next
end choose

end event

type cb_tables from commandbutton within w_main
integer x = 622
integer y = 64
integer width = 517
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Tables"
end type

event clicked;String ls_additem, ls_type
Integer li_idx, li_max

ls_type = ddlb_tables.Text
choose case ls_type
	case "User Tables"
		ls_type = "TABLE"
	case "User Views"
		ls_type = "VIEW"
	case "System Tables"
		ls_type = "SYSTEM TABLE"
	case "System Views"
		ls_type = "SYSTEM VIEW"
	case else
		ls_type = ""
end choose

lb_tables.Reset()
lb_columns.Reset()

lb_tables.SetRedraw(False)

li_max = in_api.of_Tables(ls_type, istr_tables)
For li_idx = 1 To li_max
	If istr_tables[li_idx].Schema = "" Then
		ls_additem  = istr_tables[li_idx].Name
	Else
		ls_additem  = istr_tables[li_idx].Schema + "."
		ls_additem += istr_tables[li_idx].Name
	End If
	lb_tables.AddItem(ls_additem)
Next

lb_tables.SetRedraw(True)

If li_max > 0 Then
	lb_tables.SelectItem(1)
	lb_tables.Event SelectionChanged(1)
	lb_tables.SetFocus()
End If

end event

type cb_cancel from commandbutton within w_main
integer x = 3547
integer y = 64
integer width = 443
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

