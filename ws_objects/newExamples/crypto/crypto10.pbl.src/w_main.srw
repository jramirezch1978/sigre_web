$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_hashresult from statictext within w_main
end type
type sle_hashresult from singlelineedit within w_main
end type
type cb_hash from commandbutton within w_main
end type
type st_hashvalue from statictext within w_main
end type
type sle_hashvalue from singlelineedit within w_main
end type
type ddlb_provider from dropdownlistbox within w_main
end type
type st_default_label from statictext within w_main
end type
type sle_encrypted from singlelineedit within w_main
end type
type sle_source from singlelineedit within w_main
end type
type st_encrypted_label from statictext within w_main
end type
type cb_decrypt from commandbutton within w_main
end type
type cb_encrypt from commandbutton within w_main
end type
type st_encrypt_label from statictext within w_main
end type
type cb_close from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 2171
integer height = 1044
boolean titlebar = true
string title = "Crypto API Test"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_hashresult st_hashresult
sle_hashresult sle_hashresult
cb_hash cb_hash
st_hashvalue st_hashvalue
sle_hashvalue sle_hashvalue
ddlb_provider ddlb_provider
st_default_label st_default_label
sle_encrypted sle_encrypted
sle_source sle_source
st_encrypted_label st_encrypted_label
cb_decrypt cb_decrypt
cb_encrypt cb_encrypt
st_encrypt_label st_encrypt_label
cb_close cb_close
end type
global w_main w_main

type variables
n_cryptoapi in_crypto

end variables

on w_main.create
this.st_hashresult=create st_hashresult
this.sle_hashresult=create sle_hashresult
this.cb_hash=create cb_hash
this.st_hashvalue=create st_hashvalue
this.sle_hashvalue=create sle_hashvalue
this.ddlb_provider=create ddlb_provider
this.st_default_label=create st_default_label
this.sle_encrypted=create sle_encrypted
this.sle_source=create sle_source
this.st_encrypted_label=create st_encrypted_label
this.cb_decrypt=create cb_decrypt
this.cb_encrypt=create cb_encrypt
this.st_encrypt_label=create st_encrypt_label
this.cb_close=create cb_close
this.Control[]={this.st_hashresult,&
this.sle_hashresult,&
this.cb_hash,&
this.st_hashvalue,&
this.sle_hashvalue,&
this.ddlb_provider,&
this.st_default_label,&
this.sle_encrypted,&
this.sle_source,&
this.st_encrypted_label,&
this.cb_decrypt,&
this.cb_encrypt,&
this.st_encrypt_label,&
this.cb_close}
end on

on w_main.destroy
destroy(this.st_hashresult)
destroy(this.sle_hashresult)
destroy(this.cb_hash)
destroy(this.st_hashvalue)
destroy(this.sle_hashvalue)
destroy(this.ddlb_provider)
destroy(this.st_default_label)
destroy(this.sle_encrypted)
destroy(this.sle_source)
destroy(this.st_encrypted_label)
destroy(this.cb_decrypt)
destroy(this.cb_encrypt)
destroy(this.st_encrypt_label)
destroy(this.cb_close)
end on

event open;String ls_provider, ls_Providers[]
Integer li_idx, li_max

SetPointer(HourGlass!)

// get default provider
ls_provider = in_crypto.of_GetDefaultProvider()

// update settings
in_crypto.iCryptoProvider		= ls_provider
in_crypto.iProviderType			= in_crypto.PROV_RSA_FULL
in_crypto.iEncryptAlgorithm	= in_crypto.CALG_RC4
in_crypto.iHashAlgorithm		= in_crypto.CALG_MD5

// populate provider dropdown
li_max = in_crypto.of_EnumProviders(ls_Providers)
For li_idx = 1 To li_max
	ddlb_provider.AddItem(ls_Providers[li_idx])
Next
ddlb_provider.text = ls_provider

end event

type st_hashresult from statictext within w_main
integer x = 37
integer y = 736
integer width = 443
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hash Result:"
boolean focusrectangle = false
end type

type sle_hashresult from singlelineedit within w_main
integer x = 37
integer y = 800
integer width = 1687
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_hash from commandbutton within w_main
integer x = 1755
integer y = 596
integer width = 334
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Hash"
end type

event clicked;SetPointer(HourGlass!)

If sle_hashvalue.text = "" Then
	MessageBox("Edit Error", "Value to Hash is required!")
	Return
End If

sle_hashresult.text = in_crypto.of_GetHashValue(sle_hashvalue.text)

end event

type st_hashvalue from statictext within w_main
integer x = 37
integer y = 544
integer width = 443
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Value to Hash:"
boolean focusrectangle = false
end type

type sle_hashvalue from singlelineedit within w_main
integer x = 37
integer y = 608
integer width = 1687
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Powerbuilder Rules!"
borderstyle borderstyle = stylelowered!
end type

type ddlb_provider from dropdownlistbox within w_main
integer x = 512
integer y = 32
integer width = 1614
integer height = 384
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;in_crypto.iCryptoProvider = this.Text(index)

end event

type st_default_label from statictext within w_main
integer x = 37
integer y = 40
integer width = 443
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Default Provider:"
boolean focusrectangle = false
end type

type sle_encrypted from singlelineedit within w_main
integer x = 37
integer y = 416
integer width = 1687
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier New"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_source from singlelineedit within w_main
integer x = 37
integer y = 224
integer width = 1687
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Powerbuilder Rules!"
borderstyle borderstyle = stylelowered!
end type

type st_encrypted_label from statictext within w_main
integer x = 37
integer y = 352
integer width = 443
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Encrypted Value:"
boolean focusrectangle = false
end type

type cb_decrypt from commandbutton within w_main
integer x = 1755
integer y = 404
integer width = 334
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Decrypt"
end type

event clicked;String ls_decrypted

SetPointer(HourGlass!)

If sle_encrypted.text = "" Then
	MessageBox("Edit Error", "Encrypted Value is required!")
	Return
End If

ls_decrypted = in_crypto.of_Decrypt(sle_encrypted.text, "SecretKey")

MessageBox("The decrypted value is:", ls_decrypted)

end event

type cb_encrypt from commandbutton within w_main
integer x = 1755
integer y = 212
integer width = 334
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Encrypt"
end type

event clicked;SetPointer(HourGlass!)

If sle_source.text = "" Then
	MessageBox("Edit Error", "Value to Encrypt is required!")
	Return
End If

sle_encrypted.text = in_crypto.of_Encrypt(sle_source.text, "SecretKey")

end event

type st_encrypt_label from statictext within w_main
integer x = 37
integer y = 160
integer width = 443
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Value to Encrypt:"
boolean focusrectangle = false
end type

type cb_close from commandbutton within w_main
integer x = 1755
integer y = 800
integer width = 334
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Close"
boolean cancel = true
end type

event clicked;close(parent)

end event

