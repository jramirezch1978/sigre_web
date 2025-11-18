$PBExportHeader$w_colnum.srw
$PBExportComments$Muestra el numero de columna de los campos en un dw
forward
global type w_colnum from Window
end type
type st_1 from statictext within w_colnum
end type
type ddlb_object from dropdownlistbox within w_colnum
end type
type sle_libreria from singlelineedit within w_colnum
end type
type cb_libreria from commandbutton within w_colnum
end type
type cb_close from commandbutton within w_colnum
end type
type cb_ok from commandbutton within w_colnum
end type
type dw_result from datawindow within w_colnum
end type
type dw_test from datawindow within w_colnum
end type
end forward

global type w_colnum from Window
int X=823
int Y=360
int Width=2350
int Height=1416
boolean TitleBar=true
string Title="Numeracion de Columnas en un dw"
long BackColor=79741120
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
st_1 st_1
ddlb_object ddlb_object
sle_libreria sle_libreria
cb_libreria cb_libreria
cb_close cb_close
cb_ok cb_ok
dw_result dw_result
dw_test dw_test
end type
global w_colnum w_colnum

type variables
Datastore  ids_objetos
Integer ii_help
end variables

on w_colnum.create
this.st_1=create st_1
this.ddlb_object=create ddlb_object
this.sle_libreria=create sle_libreria
this.cb_libreria=create cb_libreria
this.cb_close=create cb_close
this.cb_ok=create cb_ok
this.dw_result=create dw_result
this.dw_test=create dw_test
this.Control[]={this.st_1,&
this.ddlb_object,&
this.sle_libreria,&
this.cb_libreria,&
this.cb_close,&
this.cb_ok,&
this.dw_result,&
this.dw_test}
end on

on w_colnum.destroy
destroy(this.st_1)
destroy(this.ddlb_object)
destroy(this.sle_libreria)
destroy(this.cb_libreria)
destroy(this.cb_close)
destroy(this.cb_ok)
destroy(this.dw_result)
destroy(this.dw_test)
end on

event open;ids_objetos = create datastore
ids_objetos.dataobject = "d_library_obj"



end event

type st_1 from statictext within w_colnum
int X=37
int Y=172
int Width=247
int Height=92
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="dw:"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type ddlb_object from dropdownlistbox within w_colnum
int X=338
int Y=168
int Width=896
int Height=1108
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean AllowEdit=true
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_libreria from singlelineedit within w_colnum
int X=338
int Y=32
int Width=896
int Height=92
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;int    li_x, li_total
string ls_objects

IF Trim(This.Text) = "" THEN RETURN

ids_objetos.reset()
ddlb_object.reset()
	
ls_objects = LibraryDirectory ( This.Text, dirdatawindow!)

IF IsNull(This.Text) Or Trim(This.Text) = "" THEN RETURN
	
IF ls_objects <> "" THEN
	ids_objetos.importstring(ls_objects)
	ids_objetos.sort()
	FOR  li_x=1 TO ids_objetos.rowcount()
		  ddlb_object.additem(ids_objetos.object.name[li_x])
	NEXT
END IF


end event

type cb_libreria from commandbutton within w_colnum
int X=37
int Y=24
int Width=247
int Height=108
int TabOrder=40
string Text="Libreria"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;string ls_file, ls_path

GetFileOpenName ( "Select Library to Open", ls_path, ls_file, "PBL",&
"Library Files (*.pbl),*.pbl")  

sle_libreria.text = ls_path

sle_libreria.post event modified()

end event

type cb_close from commandbutton within w_colnum
int X=978
int Y=324
int Width=247
int Height=108
int TabOrder=60
string Text="Close"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Close(Parent)
end event

type cb_ok from commandbutton within w_colnum
int X=329
int Y=324
int Width=247
int Height=108
int TabOrder=70
string Text="Ok"
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;String ls_colname, ls_value
Integer li_totcol, li_x, li_pos
Long ll_row

dw_result.Reset()

dw_test.DataObject = ddlb_object.text

li_totcol = Integer(dw_test.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_colname = "#" + String(li_x) + ".dbName"
	ls_colname = dw_test.Describe(ls_colname)
	li_pos = Pos(ls_colname,".")
	ls_colname = Mid(ls_colname,li_pos + 1)
	ll_row = dw_result.InsertRow(0)
	dw_result.SetItem(ll_row,'name',ls_colname)
	dw_result.SetItem(ll_row,'number',li_x)
NEXT



end event

type dw_result from datawindow within w_colnum
int X=1257
int Y=28
int Width=1024
int Height=1256
int TabOrder=50
string DataObject="d_colname"
BorderStyle BorderStyle=StyleLowered!
boolean VScrollBar=true
boolean LiveScroll=true
end type

type dw_test from datawindow within w_colnum
int X=37
int Y=484
int Width=1189
int Height=792
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

