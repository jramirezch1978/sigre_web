$PBExportHeader$w_powerfilter_custom.srw
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type w_powerfilter_custom from window
end type
type dw_pic2 from datawindow within w_powerfilter_custom
end type
type dw_pic1 from datawindow within w_powerfilter_custom
end type
type dw_filter2 from datawindow within w_powerfilter_custom
end type
type dw_filter1 from datawindow within w_powerfilter_custom
end type
type cbx_matchcase from checkbox within w_powerfilter_custom
end type
type dw_parm2 from datawindow within w_powerfilter_custom
end type
type dw_parm1 from datawindow within w_powerfilter_custom
end type
type st_colheader from statictext within w_powerfilter_custom
end type
type st_useasterisk from statictext within w_powerfilter_custom
end type
type st_usequestionmark from statictext within w_powerfilter_custom
end type
type rb_or from radiobutton within w_powerfilter_custom
end type
type rb_and from radiobutton within w_powerfilter_custom
end type
type st_showrows from statictext within w_powerfilter_custom
end type
type cb_cancel from commandbutton within w_powerfilter_custom
end type
type cb_ok from commandbutton within w_powerfilter_custom
end type
end forward

global type w_powerfilter_custom from window
string tag = "//MULTILANG Custom Filter"
integer width = 2203
integer height = 864
boolean titlebar = true
string title = "Custom Filter"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_pic2 dw_pic2
dw_pic1 dw_pic1
dw_filter2 dw_filter2
dw_filter1 dw_filter1
cbx_matchcase cbx_matchcase
dw_parm2 dw_parm2
dw_parm1 dw_parm1
st_colheader st_colheader
st_useasterisk st_useasterisk
st_usequestionmark st_usequestionmark
rb_or rb_or
rb_and rb_and
st_showrows st_showrows
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_powerfilter_custom w_powerfilter_custom

type variables
s_powerfilter_parms is_returnparms
s_powerfilter_parms is_openparms
string is_colformat
datawindowchild filter_child1
datawindowchild filter_child2

datawindowchild item_child1
datawindowchild item_child2

boolean ib_buttonpressed
string is_equals
string is_doesnotequal
string is_isgreaterthan
string is_isgreaterthanorequalto
string is_islessthan
string is_islessthanorequalto
string is_beginswith
string is_doesnotbeginwith
string is_endswith
string is_doesnotendwith
string is_contains
string is_doesnotcontain
string is_blank
string is_and
string is_cancel
string is_customfilter
string is_matchcase
string is_ok
string is_or
string is_showrowswhere
string is_useasterisk
string is_usequestionmark

end variables

forward prototypes
public function integer of_setlanguage (integer ai_languagenumber)
Public function integer  of_replace (ref string as_string,string as_old,string as_new)
end prototypes

public function integer of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
integer li_lang
datastore lds_lang
integer li_row
integer li_rows


lds_lang = CREATE datastore
lds_lang.dataobject = "d_powerfilter_languages"
li_lang = ai_languagenumber
THIS.is_equals = lds_lang.getitemstring(2,li_lang)
THIS.is_doesnotequal = lds_lang.getitemstring(3,li_lang)
THIS.is_isgreaterthan = lds_lang.getitemstring(4,li_lang)
THIS.is_isgreaterthanorequalto = lds_lang.getitemstring(5,li_lang)
THIS.is_islessthan = lds_lang.getitemstring(6,li_lang)
THIS.is_islessthanorequalto = lds_lang.getitemstring(7,li_lang)
THIS.is_beginswith = lds_lang.getitemstring(8,li_lang)
THIS.is_doesnotbeginwith = lds_lang.getitemstring(9,li_lang)
THIS.is_endswith = lds_lang.getitemstring(10,li_lang)
THIS.is_doesnotendwith = lds_lang.getitemstring(11,li_lang)
THIS.is_contains = lds_lang.getitemstring(12,li_lang)
THIS.is_doesnotcontain = lds_lang.getitemstring(13,li_lang)
THIS.is_blank = lds_lang.getitemstring(63,li_lang)
THIS.is_and = lds_lang.getitemstring(67,li_lang)
THIS.is_cancel = lds_lang.getitemstring(69,li_lang)
THIS.is_customfilter = lds_lang.getitemstring(72,li_lang)
THIS.is_matchcase = lds_lang.getitemstring(77,li_lang)
THIS.is_ok = lds_lang.getitemstring(79,li_lang)
THIS.is_or = lds_lang.getitemstring(80,li_lang)
THIS.is_showrowswhere = lds_lang.getitemstring(84,li_lang)
THIS.is_useasterisk = lds_lang.getitemstring(95,li_lang)
THIS.is_usequestionmark = lds_lang.getitemstring(96,li_lang)
DESTROY lds_lang
THIS.cb_ok.text = THIS.is_ok
THIS.cb_cancel.text = THIS.is_cancel
THIS.cbx_matchcase.text = THIS.is_matchcase
THIS.st_showrows.text = THIS.is_showrowswhere
THIS.st_usequestionmark.text = THIS.is_usequestionmark
THIS.st_useasterisk.text = THIS.is_useasterisk
THIS.rb_and.text = THIS.is_and
THIS.rb_or.text = THIS.is_or
THIS.title = THIS.is_customfilter
li_rows = filter_child1.rowcount()
li_row = filter_child1.find("filtertype = 'equals'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_equals)
li_row = filter_child1.find("filtertype = 'does not equal'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_doesnotequal)
li_row = filter_child1.find("filtertype = 'is greater than'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_isgreaterthan)
li_row = filter_child1.find("filtertype = 'is greater than or equal to'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_isgreaterthanorequalto)
li_row = filter_child1.find("filtertype = 'is less than'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_islessthan)
li_row = filter_child1.find("filtertype = 'is less than or equal to'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_islessthanorequalto)
li_row = filter_child1.find("filtertype = 'begins with'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_beginswith)
li_row = filter_child1.find("filtertype = 'does not begin with'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_doesnotbeginwith)
li_row = filter_child1.find("filtertype = 'ends with'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_endswith)
li_row = filter_child1.find("filtertype = 'does not end with'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_doesnotendwith)
li_row = filter_child1.find("filtertype = 'contains'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_contains)
li_row = filter_child1.find("filtertype = 'does not contain'",1,li_rows)
IF li_row > 0 THEN filter_child1.setitem(li_row,"displaytext",THIS.is_doesnotcontain)
li_rows = filter_child2.rowcount()
li_row = filter_child2.find("filtertype = 'equals'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_equals)
li_row = filter_child2.find("filtertype = 'does not equal'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_doesnotequal)
li_row = filter_child2.find("filtertype = 'is greater than'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_isgreaterthan)
li_row = filter_child2.find("filtertype = 'is greater than or equal to'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_isgreaterthanorequalto)
li_row = filter_child2.find("filtertype = 'is less than'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_islessthan)
li_row = filter_child2.find("filtertype = 'is less than or equal to'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_islessthanorequalto)
li_row = filter_child2.find("filtertype = 'begins with'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_beginswith)
li_row = filter_child2.find("filtertype = 'does not begin with'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_doesnotbeginwith)
li_row = filter_child2.find("filtertype = 'ends with'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_endswith)
li_row = filter_child2.find("filtertype = 'does not end with'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_doesnotendwith)
li_row = filter_child2.find("filtertype = 'contains'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_contains)
li_row = filter_child2.find("filtertype = 'does not contain'",1,li_rows)
IF li_row > 0 THEN filter_child2.setitem(li_row,"displaytext",THIS.is_doesnotcontain)
RETURN 0

end function

Public function integer  of_replace (ref string as_string,string as_old,string as_new);//Public function of_replace (ref string as_string,string as_old,string as_new) returns integer 
//string as_string
//string as_old
//string as_new
long ll_startpos


ll_startpos = pos(as_string,as_old)
DO WHILE ll_startpos > 0 //1
	as_string = replace(as_string,ll_startpos,len(as_old),as_new)
	ll_startpos = pos(as_string,as_old,ll_startpos + len(as_new))
LOOP //1
RETURN 0

end function

on w_powerfilter_custom.create
this.dw_pic2=create dw_pic2
this.dw_pic1=create dw_pic1
this.dw_filter2=create dw_filter2
this.dw_filter1=create dw_filter1
this.cbx_matchcase=create cbx_matchcase
this.dw_parm2=create dw_parm2
this.dw_parm1=create dw_parm1
this.st_colheader=create st_colheader
this.st_useasterisk=create st_useasterisk
this.st_usequestionmark=create st_usequestionmark
this.rb_or=create rb_or
this.rb_and=create rb_and
this.st_showrows=create st_showrows
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.dw_pic2,&
this.dw_pic1,&
this.dw_filter2,&
this.dw_filter1,&
this.cbx_matchcase,&
this.dw_parm2,&
this.dw_parm1,&
this.st_colheader,&
this.st_useasterisk,&
this.st_usequestionmark,&
this.rb_or,&
this.rb_and,&
this.st_showrows,&
this.cb_cancel,&
this.cb_ok}
end on

on w_powerfilter_custom.destroy
destroy(this.dw_pic2)
destroy(this.dw_pic1)
destroy(this.dw_filter2)
destroy(this.dw_filter1)
destroy(this.cbx_matchcase)
destroy(this.dw_parm2)
destroy(this.dw_parm1)
destroy(this.st_colheader)
destroy(this.st_useasterisk)
destroy(this.st_usequestionmark)
destroy(this.rb_or)
destroy(this.rb_and)
destroy(this.st_showrows)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;//open (none) returns long [pbm_open]

datastore ds_1
integer rtncode
integer li_row
string ls_return
string ls_mod
string ls_width
string ls_height
string ls_heightplus


THIS.is_openparms = message.powerobjectparm
THIS.is_returnparms.parm8 = ""
THIS.is_colformat = THIS.is_openparms.parm11
THIS.st_colheader.text = THIS.is_openparms.parm6
THIS.cbx_matchcase.checked = THIS.is_openparms.parm9
rtncode = dw_filter1.getchild("Item",THIS.filter_child1)
IF rtncode = -1 THEN messagebox("Error","Not a DataWindowChild")
rtncode = dw_filter2.getchild("Item",THIS.filter_child2)
IF rtncode = -1 THEN messagebox("Error","Not a DataWindowChild")
of_setlanguage(THIS.is_openparms.parm14)
dw_filter1.insertrow(0)
li_row = filter_child1.find("filtertype = '" + lower(string(THIS.is_openparms.parm1) + "'"),1,filter_child1.rowcount())
filter_child1.setrow(li_row)
filter_child1.scrolltorow(li_row)
dw_filter1.setitem(1,"item",lower(string(THIS.is_openparms.parm1)))
dw_filter2.insertrow(0)
li_row = filter_child2.find("filtertype = '" + lower(string(THIS.is_openparms.parm3) + "'"),1,filter_child2.rowcount())
filter_child2.setrow(li_row)
filter_child2.scrolltorow(li_row)
dw_filter2.setitem(1,"item",lower(string(THIS.is_openparms.parm3)))
IF upper(THIS.is_openparms.parm5) = "AND" THEN //20
	THIS.rb_and.checked = TRUE
	THIS.rb_or.checked = FALSE
ELSE //20
	THIS.rb_and.checked = FALSE
	THIS.rb_or.checked = TRUE
END IF //20
dw_parm1.insertrow(0)
dw_parm1.setitem(1,"Item",THIS.is_openparms.parm2)
dw_parm2.insertrow(0)
dw_parm2.setitem(1,"Item",THIS.is_openparms.parm4)
rtncode = dw_parm1.getchild("Item",item_child1)
IF rtncode = -1 THEN messagebox("Error","Not a DataWindowChild")
rtncode = dw_parm2.getchild("Item",item_child2)
IF rtncode = -1 THEN messagebox("Error","Not a DataWindowChild")
ds_1 = THIS.is_openparms.parm7
ds_1.sharedata(item_child1)
ds_1.sharedata(item_child2)
ls_return = item_child1.modify("timeitem.visible='0' dateitem.visible='0' datetimeitem.visible='0' numericitem.visible='0' item.visible='0' ")
ls_return = item_child2.modify("timeitem.visible='0' dateitem.visible='0' datetimeitem.visible='0' numericitem.visible='0' item.visible='0' ")
ls_mod = item_child1.describe("t_blank.text")
of_replace(ls_mod,"(Blank)",THIS.is_blank)
ls_return = item_child1.modify("t_blank.text=" + ls_mod)
ls_return = item_child2.modify("t_blank.text=" + ls_mod)
ls_mod = item_child1.describe("t_blank.visible")
of_replace(ls_mod,"(Blank)",THIS.is_blank)
ls_return = item_child1.modify("t_blank.visible=" + ls_mod)
ls_return = item_child2.modify("t_blank.visible=" + ls_mod)
CHOOSE CASE lower(THIS.is_openparms.parm10) //47
	CASE "char(","char" //47
		item_child1.modify("item.Format=~"" + THIS.is_colformat + "~"")
		item_child1.modify("item.visible=~"1~" ")
		item_child2.modify("item.Format=~"" + THIS.is_colformat + "~"")
		item_child2.modify("item.visible=~"1~" ")
		IF lower(ds_1.describe("item.BitmapName")) = "yes" THEN //53
			THIS.cbx_matchcase.visible = FALSE
			THIS.st_usequestionmark.visible = FALSE
			THIS.st_useasterisk.visible = FALSE
			ls_width = ds_1.describe("item.width")
			ls_height = ds_1.describe("item.height")
			DO WHILE long(ls_height) > (72 * 2) //59
				ls_height = string(int(long(ls_height) * 0.9))
				ls_width = string(int(long(ls_width) * 0.9))
			LOOP //59
			ls_heightplus = string(long(ls_height) + 8)
			THIS.dw_pic1.visible = TRUE
			THIS.dw_pic2.visible = TRUE
			THIS.dw_pic1.bringtotop = TRUE
			THIS.dw_pic2.bringtotop = TRUE
			ls_return = item_child1.modify("item.BitmapName='Yes'")
			ls_return = item_child1.modify("item.width=" + ls_width)
			ls_return = item_child1.modify("item.height=" + ls_height)
			ls_return = item_child1.modify("DataWindow.Detail.Height=" + ls_heightplus)
			ls_return = item_child2.modify("item.BitmapName='Yes'")
			ls_return = item_child2.modify("item.width=" + ls_width)
			ls_return = item_child2.modify("item.height=" + ls_height)
			ls_return = item_child2.modify("DataWindow.Detail.Height=" + ls_heightplus)
			dw_parm1.sharedata(THIS.dw_pic1)
			ls_return = dw_pic1.modify("item.width=" + ls_width)
			ls_return = dw_pic1.modify("item.height=" + ls_height)
			ls_return = dw_pic1.modify("DataWindow.Detail.Height=" + ls_heightplus)
			THIS.dw_parm1.height = long(ls_heightplus)
			THIS.dw_pic1.height = long(ls_height) + 8
			THIS.dw_pic1.y = THIS.dw_parm1.y
			ls_return = dw_parm1.modify("item.height=" + ls_height)
			ls_return = dw_parm1.modify("DataWindow.Detail.Height=" + ls_heightplus)
			dw_parm2.sharedata(THIS.dw_pic2)
			ls_return = dw_pic2.modify("item.width=" + ls_width)
			ls_return = dw_pic2.modify("item.height=" + ls_height)
			ls_return = dw_pic2.modify("DataWindow.Detail.Height=" + ls_heightplus)
			THIS.dw_parm2.height = long(ls_heightplus)
			THIS.dw_pic2.height = long(ls_height) + 8
			THIS.dw_pic2.y = THIS.dw_parm2.y
			ls_return = dw_parm2.modify("item.height=" + ls_height)
			ls_return = dw_parm2.modify("DataWindow.Detail.Height=" + ls_heightplus)
		END IF //53
	CASE "date" //47
		THIS.cbx_matchcase.visible = FALSE
		item_child1.modify("dateitem.Format=~"" + THIS.is_colformat + "~"")
		item_child1.modify("dateitem.visible=~"1~" ")
		item_child2.modify("dateitem.Format=~"" + THIS.is_colformat + "~"")
		item_child2.modify("dateitem.visible=~"1~" ")
	CASE "datet","times" //47
		THIS.cbx_matchcase.visible = FALSE
		item_child1.modify("datetimeitem.Format=~"" + THIS.is_colformat + "~"")
		item_child1.modify("datetimeitem.visible=~"1~" ")
		item_child2.modify("datetimeitem.Format=~"" + THIS.is_colformat + "~"")
		item_child2.modify("datetimeitem.visible=~"1~" ")
	CASE "time" //47
		THIS.cbx_matchcase.visible = FALSE
		item_child1.modify("timeitem.Format=~"" + THIS.is_colformat + "~"")
		item_child1.modify("timeitem.visible=~"1~" ")
		item_child2.modify("timeitem.Format=~"" + THIS.is_colformat + "~"")
		item_child2.modify("timeitem.visible=~"1~" ")
	CASE "int","long","numbe","real","ulong","decim" //47
		THIS.cbx_matchcase.visible = FALSE
		item_child1.modify("numericitem.Format=~"" + THIS.is_colformat + "~"")
		item_child1.modify("numericitem.visible=~"1~" ")
		item_child2.modify("numericitem.Format=~"" + THIS.is_colformat + "~"")
		item_child2.modify("numericitem.visible=~"1~" ")
	CASE ELSE //47
		messagebox("Error","Column type is not recognized")
		RETURN -1
END CHOOSE //47
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

type dw_pic2 from datawindow within w_powerfilter_custom
boolean visible = false
integer x = 901
integer y = 440
integer width = 1006
integer height = 72
string title = "none"
string dataobject = "d_powerfilter_pictureparm"
end type

type dw_pic1 from datawindow within w_powerfilter_custom
boolean visible = false
integer x = 901
integer y = 256
integer width = 1006
integer height = 72
string title = "none"
string dataobject = "d_powerfilter_pictureparm"
end type

type dw_filter2 from datawindow within w_powerfilter_custom
integer x = 137
integer y = 360
integer width = 722
integer height = 72
integer taborder = 50
string title = "none"
string dataobject = "d_powerfilter_customfilter"
boolean border = false
end type

type dw_filter1 from datawindow within w_powerfilter_custom
integer x = 137
integer y = 172
integer width = 722
integer height = 72
integer taborder = 10
string title = "none"
string dataobject = "d_powerfilter_customfilter"
boolean border = false
end type

type cbx_matchcase from checkbox within w_powerfilter_custom
string tag = "//MULTILANG Match Case"
integer x = 32
integer y = 680
integer width = 859
integer height = 68
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Match Case"
end type

type dw_parm2 from datawindow within w_powerfilter_custom
integer x = 901
integer y = 360
integer width = 1088
integer height = 72
integer taborder = 60
string title = "none"
string dataobject = "d_powerfilter_customparm"
boolean border = false
end type

event itemchanged;//itemchanged (long row,dwobject dwo,string data) returns long [pbm_dwnitemchange]
//long row
//dwobject dwo
//string data


RETURN

end event

type dw_parm1 from datawindow within w_powerfilter_custom
integer x = 901
integer y = 172
integer width = 1088
integer height = 72
integer taborder = 20
string title = "none"
string dataobject = "d_powerfilter_customparm"
boolean border = false
end type

type st_colheader from statictext within w_powerfilter_custom
integer x = 96
integer y = 92
integer width = 2062
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
string text = "ColHeader"
boolean focusrectangle = false
end type

type st_useasterisk from statictext within w_powerfilter_custom
string tag = "//MULTILANG Use * to represent any series of characters"
integer x = 32
integer y = 564
integer width = 1810
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Use * to represent any series of characters"
boolean focusrectangle = false
end type

type st_usequestionmark from statictext within w_powerfilter_custom
string tag = "//MULTILANG Use ? to represent any single character"
integer x = 32
integer y = 500
integer width = 1733
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Use ? to represent any single character"
boolean focusrectangle = false
end type

type rb_or from radiobutton within w_powerfilter_custom
string tag = "//MULTILANG Or"
integer x = 549
integer y = 272
integer width = 293
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Or"
end type

type rb_and from radiobutton within w_powerfilter_custom
string tag = " //MULTILANG And"
integer x = 215
integer y = 272
integer width = 315
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "And"
boolean checked = true
end type

type st_showrows from statictext within w_powerfilter_custom
string tag = "//MULTILANG Show rows where:"
integer x = 32
integer y = 28
integer width = 1115
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
string text = "Show rows where:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_powerfilter_custom
string tag = "//MULTILANG Cancel"
integer x = 1792
integer y = 656
integer width = 370
integer height = 100
integer taborder = 90
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


PARENT.is_returnparms.parm1 = PARENT.is_openparms.parm1
PARENT.is_returnparms.parm2 = PARENT.is_openparms.parm2
PARENT.is_returnparms.parm3 = PARENT.is_openparms.parm3
PARENT.is_returnparms.parm4 = PARENT.is_openparms.parm4
PARENT.is_returnparms.parm5 = PARENT.is_openparms.parm5
PARENT.is_returnparms.parm9 = PARENT.is_openparms.parm9
PARENT.is_returnparms.parm8 = "CANCEL"
PARENT.ib_buttonpressed = TRUE
closewithreturn(PARENT,PARENT.is_returnparms)
RETURN

end event

type cb_ok from commandbutton within w_powerfilter_custom
string tag = "//MULTILANG OK"
integer x = 1390
integer y = 656
integer width = 370
integer height = 100
integer taborder = 80
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


PARENT.dw_parm1.accepttext()
PARENT.dw_parm2.accepttext()
PARENT.is_returnparms.parm1 = PARENT.dw_filter1.getitemstring(1,"Item")
PARENT.is_returnparms.parm2 = PARENT.dw_parm1.getitemstring(1,"Item")
PARENT.is_returnparms.parm12 = PARENT.filter_child1.getitemstring(PARENT.filter_child1.getrow(),"displaytext")
PARENT.is_returnparms.parm3 = PARENT.dw_filter2.getitemstring(1,"Item")
PARENT.is_returnparms.parm4 = PARENT.dw_parm2.getitemstring(1,"Item")
PARENT.is_returnparms.parm13 = PARENT.filter_child2.getitemstring(PARENT.filter_child2.getrow(),"displaytext")
IF PARENT.rb_and.checked THEN //8
	PARENT.is_returnparms.parm5 = "and"
ELSE //8
	PARENT.is_returnparms.parm5 = "or"
END IF //8
PARENT.is_returnparms.parm8 = "OK"
PARENT.is_returnparms.parm9 = PARENT.cbx_matchcase.checked
IF PARENT.is_returnparms.parm1 = "" THEN //14
	messagebox("Error","Error in Filter Options, you must specify a Filter type")
	RETURN
END IF //14
PARENT.ib_buttonpressed = TRUE
closewithreturn(PARENT,PARENT.is_returnparms)
RETURN

end event

