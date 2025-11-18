$PBExportHeader$w_powerfilter_prompt_to_restore.srw
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type w_powerfilter_prompt_to_restore from window
end type
type st_2 from statictext within w_powerfilter_prompt_to_restore
end type
type st_1 from statictext within w_powerfilter_prompt_to_restore
end type
type cbx_filter from checkbox within w_powerfilter_prompt_to_restore
end type
type cbx_sort from checkbox within w_powerfilter_prompt_to_restore
end type
type cb_cancel from commandbutton within w_powerfilter_prompt_to_restore
end type
type cb_ok from commandbutton within w_powerfilter_prompt_to_restore
end type
end forward

global type w_powerfilter_prompt_to_restore from window
string tag = "//MULTILANG  Restore Original?"
integer width = 2171
integer height = 712
boolean titlebar = true
string title = "Restore Original?"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_2 st_2
st_1 st_1
cbx_filter cbx_filter
cbx_sort cbx_sort
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_powerfilter_prompt_to_restore w_powerfilter_prompt_to_restore

type variables
boolean ib_buttonpressed
string is_cancel
string is_ok
string is_restoreoriginalfilterdefinition
string is_restoreoriginalsortorder
string is_restoreoriginal
string is_restoreoriginaldefinitions
string is_youhavemadechanges

end variables

forward prototypes
public function integer of_setlanguage (integer ai_languagenumber)
end prototypes

public function integer of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
integer li_lang
datastore lds_lang


lds_lang = CREATE datastore
lds_lang.dataobject = "d_powerfilter_languages"
li_lang = ai_languagenumber
THIS.is_cancel = lds_lang.getitemstring(69,li_lang)
THIS.is_ok = lds_lang.getitemstring(79,li_lang)
THIS.is_restoreoriginalfilterdefinition = lds_lang.getitemstring(81,li_lang)
THIS.is_restoreoriginalsortorder = lds_lang.getitemstring(82,li_lang)
THIS.is_restoreoriginal = lds_lang.getitemstring(83,li_lang)
THIS.is_restoreoriginaldefinitions = lds_lang.getitemstring(97,li_lang)
THIS.is_youhavemadechanges = lds_lang.getitemstring(98,li_lang)
DESTROY lds_lang
THIS.title = THIS.is_restoreoriginal
THIS.st_2.text = THIS.is_restoreoriginaldefinitions
THIS.st_1.text = THIS.is_youhavemadechanges
THIS.cbx_filter.text = THIS.is_restoreoriginalfilterdefinition
THIS.cbx_sort.text = THIS.is_restoreoriginalsortorder
THIS.cb_ok.text = THIS.is_ok
THIS.cb_cancel.text = THIS.is_cancel
RETURN 0

end function

on w_powerfilter_prompt_to_restore.create
this.st_2=create st_2
this.st_1=create st_1
this.cbx_filter=create cbx_filter
this.cbx_sort=create cbx_sort
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.st_2,&
this.st_1,&
this.cbx_filter,&
this.cbx_sort,&
this.cb_cancel,&
this.cb_ok}
end on

on w_powerfilter_prompt_to_restore.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cbx_filter)
destroy(this.cbx_sort)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;//open (none) returns long [pbm_open]
integer li_languagenumber
integer li_width
integer li_diff


li_languagenumber = message.doubleparm
of_setlanguage(li_languagenumber)
li_width = len(THIS.st_1.text)
IF len(THIS.st_2.text) > li_width THEN li_width = len(THIS.st_2.text)
li_width = li_width * 27
IF li_width > THIS.width THEN //5
	li_diff = li_width - THIS.width
	THIS.width = li_width
	THIS.st_1.width = li_width
	THIS.st_2.width = li_width
	THIS.cbx_filter.x = THIS.cbx_filter.x + li_diff / 2
	THIS.cbx_sort.x = THIS.cbx_sort.x + li_diff / 2
	THIS.cb_cancel.x = THIS.cb_cancel.x + li_diff
	THIS.cb_ok.x = THIS.cb_ok.x + li_diff
END IF //5
RETURN

end event

event closequery;//closequery (none) returns long [pbm_closequery]


IF  NOT (THIS.ib_buttonpressed) THEN //0
	cb_cancel.postevent(clicked!)
	RETURN 1
ELSE //0
	RETURN 0
END IF //0
RETURN

end event

type st_2 from statictext within w_powerfilter_prompt_to_restore
string tag = "//MULTILANG Would you like to restore the original definitions, or keep the current Sort and Filter definitions?"
integer y = 124
integer width = 2199
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Would you like to restore the original definitions, or keep the current Sort and Filter definitions?"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_powerfilter_prompt_to_restore
string tag = "//MULTILANG You have made changes to the original Sort Order and/or Filtered Rows on Display."
integer y = 52
integer width = 2199
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "You have made changes to the original Sort Order and/or Filtered Rows on Display."
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_filter from checkbox within w_powerfilter_prompt_to_restore
string tag = "//MULTILANG Restore Original Filter Definition"
integer x = 416
integer y = 308
integer width = 1458
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Restore Original Filter Definition"
boolean checked = true
end type

type cbx_sort from checkbox within w_powerfilter_prompt_to_restore
string tag = "//MULTILANG Restore Original Sort Order"
integer x = 416
integer y = 228
integer width = 1454
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Restore Original Sort Order"
boolean checked = true
end type

type cb_cancel from commandbutton within w_powerfilter_prompt_to_restore
string tag = "//MULTILANG Cancel"
integer x = 1737
integer y = 476
integer width = 347
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;//clicked (none) returns long [pbm_bnclicked]
s_powerfilter_restore_parms ls_response


ls_response.buttonpressed = FALSE
ls_response.restoresort = PARENT.cbx_sort.checked
ls_response.restorefilter = PARENT.cbx_filter.checked
PARENT.ib_buttonpressed = TRUE
closewithreturn(PARENT,ls_response)
RETURN

end event

type cb_ok from commandbutton within w_powerfilter_prompt_to_restore
string tag = "//MULTILANG OK"
integer x = 1358
integer y = 476
integer width = 347
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;//clicked (none) returns long [pbm_bnclicked]
s_powerfilter_restore_parms ls_response


ls_response.buttonpressed = TRUE
ls_response.restoresort = PARENT.cbx_sort.checked
ls_response.restorefilter = PARENT.cbx_filter.checked
PARENT.ib_buttonpressed = TRUE
closewithreturn(PARENT,ls_response)
RETURN

end event

