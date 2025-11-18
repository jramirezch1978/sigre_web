$PBExportHeader$w_memory.srw
$PBExportComments$In-memory compress/uncompress
forward
global type w_memory from window
end type
type cb_close from commandbutton within w_memory
end type
type mle_result from multilineedit within w_memory
end type
type cb_decompress from commandbutton within w_memory
end type
type cb_compress from commandbutton within w_memory
end type
end forward

global type w_memory from window
integer x = 302
integer y = 396
integer width = 2647
integer height = 1556
boolean titlebar = true
string title = "Sample In-memory compress/uncompress"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79416533
boolean center = true
cb_close cb_close
mle_result mle_result
cb_decompress cb_decompress
cb_compress cb_compress
end type
global w_memory w_memory

type variables
blob iblob_zipped
ulong iul_original
String is_source

end variables

on w_memory.create
this.cb_close=create cb_close
this.mle_result=create mle_result
this.cb_decompress=create cb_decompress
this.cb_compress=create cb_compress
this.Control[]={this.cb_close,&
this.mle_result,&
this.cb_decompress,&
this.cb_compress}
end on

on w_memory.destroy
destroy(this.cb_close)
destroy(this.mle_result)
destroy(this.cb_decompress)
destroy(this.cb_compress)
end on

type cb_close from commandbutton within w_memory
integer x = 2231
integer y = 32
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Close"
boolean cancel = true
end type

event clicked;Close(parent)

end event

type mle_result from multilineedit within w_memory
integer x = 37
integer y = 160
integer width = 2528
integer height = 1252
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Fixedsys"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_decompress from commandbutton within w_memory
integer x = 475
integer y = 32
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Decompress"
end type

event clicked;String ls_source
Integer li_rc

SetPointer(HourGlass!)

// uncompress original string
If gn_zlib.of_uncompress(iblob_zipped, iul_original, ls_source) Then
	If ls_source = is_source Then
		mle_result.text = ls_source
	Else
		MessageBox( parent.title, &
						"Uncompressed source does not match original!")
	End If
Else
	MessageBox( parent.title, &
					"Uncompress failed with rc: " + String(li_rc))
End If

end event

type cb_compress from commandbutton within w_memory
integer x = 37
integer y = 32
integer width = 370
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Compress"
end type

event clicked;Integer li_rc
Decimal{2} ldec_pct

SetPointer(HourGlass!)

// get userobject source to use as test string
is_source = LibraryExport("zlibwapi10.pbl", "n_zlib", ExportUserObject!)

// save original size
iul_original = Len(is_source)

// compress original string
If gn_zlib.of_compress(is_source, iblob_zipped) Then
	ldec_pct = 100 - ((Len(iblob_zipped) / iul_original) * 100)
	cb_decompress.enabled = True
	mle_result.text = "Compressed from " + &
		String(iul_original) + " to " + String(Len(iblob_zipped)) + &
		"~r~nA reduction of " + String(ldec_pct) + " percent"
Else
	MessageBox(parent.title, "Compress failed with rc: " + String(li_rc))
End If

end event

