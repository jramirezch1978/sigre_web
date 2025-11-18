$PBExportHeader$u_powerfilter_monthopts.sru
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type u_powerfilter_monthopts from userobject
end type
type dw_1 from datawindow within u_powerfilter_monthopts
end type
end forward

global type u_powerfilter_monthopts from userobject
integer width = 535
integer height = 1420
long backcolor = 134217744
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type
global u_powerfilter_monthopts u_powerfilter_monthopts

type variables
string is_coltype
string is_title
string is_colname
string is_columnfilter
string is_ddfilter
integer ii_colnum
integer ii_prevrow
integer ii_selectedrow[]
u_powerfilter_dropdown iu_powerfilter_dropdown
n_cst_powerfilter iu_powerfilter_checkbox
u_powerfilter_predeffilters iu_powerfilter_predeffilters
datawindow idw_dw
string is_quarter1
string is_quarter2
string is_quarter3
string is_quarter4
string is_january
string is_february
string is_march
string is_april
string is_may
string is_june
string is_july
string is_august
string is_september
string is_october
string is_november
string is_december
string is_equals_cap

end variables

forward prototypes
Public function integer  of_setdropdown (ref userobject a_powerfilter_dropdown)
Public function integer  of_flagrow (integer ai_row)
Public function integer  of_setlist (string as_coltype,string as_colname,string as_title,integer ai_colnum)
Public function integer  of_restorestate ()
Public function integer  of_position ()
Public function integer  of_setpredef (ref userobject a_powerfilter_predeffilters)
public function integer of_setlanguage (integer ai_languagenumber)
Public function integer  of_initialize (datawindow a_dw,ref nonvisualobject a_powerfilter_checkbox,integer ai_maxcol)
end prototypes

Public function integer  of_setdropdown (ref userobject a_powerfilter_dropdown);//Public function of_setdropdown (ref userobject a_powerfilter_dropdown) returns integer 
//userobject a_powerfilter_dropdown


THIS.iu_powerfilter_dropdown = a_powerfilter_dropdown
RETURN 0

end function

Public function integer  of_flagrow (integer ai_row);//Public function of_flagrow (integer ai_row) returns integer 
//integer ai_row
integer li_return


IF THIS.ii_prevrow > 0 THEN //0
	dw_1.setitem(THIS.ii_prevrow,"Selected",0)
END IF //0
IF ai_row > 0 THEN //2
	dw_1.setitem(ai_row,"Selected",1)
	li_return = iu_powerfilter_predeffilters.dw_1.setitem(iu_powerfilter_predeffilters.dw_1.rowcount() - 1,"Selected",1)
	THIS.iu_powerfilter_predeffilters.ii_selectedrow[THIS.ii_colnum] = iu_powerfilter_predeffilters.dw_1.rowcount() - 1
	THIS.ii_prevrow = ai_row
ELSE //2
	THIS.ii_prevrow = 0
END IF //2
THIS.ii_selectedrow[THIS.ii_colnum] = THIS.ii_prevrow
RETURN THIS.ii_prevrow

end function

Public function integer  of_setlist (string as_coltype,string as_colname,string as_title,integer ai_colnum);//Public function of_setlist (string as_coltype,string as_colname,string as_title,integer ai_colnum) returns integer 
//string as_coltype
//string as_colname
//string as_title
//integer ai_colnum


THIS.is_coltype = as_coltype
THIS.is_colname = as_colname
THIS.is_title = as_title
THIS.ii_colnum = ai_colnum
THIS.dw_1.height = dw_1.rowcount() * 88 + 44
THIS.height = THIS.dw_1.height + 16
of_restorestate()
RETURN 0

end function

Public function integer  of_restorestate ();//Public function of_restorestate (none) returns integer 
integer li_selectedrow
integer li_row


FOR li_row = 1 TO dw_1.rowcount() //0
	dw_1.setitem(li_row,"selected",0)
NEXT //0
li_selectedrow = THIS.ii_selectedrow[THIS.ii_colnum]
IF li_selectedrow > 0 THEN //4
	dw_1.setitem(li_selectedrow,"selected",1)
END IF //4
RETURN 0

end function

Public function integer  of_position ();//Public function of_position (none) returns integer 


THIS.x = THIS.iu_powerfilter_predeffilters.x + THIS.iu_powerfilter_predeffilters.width
IF (THIS.x + THIS.width) > (PARENT.DYNAMIC workspacewidth()) THEN //1
	THIS.x = THIS.iu_powerfilter_predeffilters.x - THIS.width
END IF //1
THIS.y = THIS.iu_powerfilter_predeffilters.y + (88 * (iu_powerfilter_predeffilters.dw_1.rowcount() - 1)) + 4
IF (THIS.y + THIS.height) > (PARENT.DYNAMIC workspaceheight()) AND (PARENT.DYNAMIC workspaceheight() - THIS.height) > 0 THEN //4
	THIS.y = PARENT.DYNAMIC workspaceheight() - THIS.height
END IF //4
RETURN 0

end function

Public function integer  of_setpredef (ref userobject a_powerfilter_predeffilters);//Public function of_setpredef (ref userobject a_powerfilter_predeffilters) returns integer 
//userobject a_powerfilter_predeffilters


THIS.iu_powerfilter_predeffilters = a_powerfilter_predeffilters
RETURN 0

end function

public function integer of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
integer li_lang
datastore lds_lang
integer li_row
integer li_rows


lds_lang = CREATE datastore
lds_lang.dataobject = "d_powerfilter_languages"
li_lang = ai_languagenumber
THIS.is_quarter1 = lds_lang.getitemstring(47,li_lang)
THIS.is_quarter2 = lds_lang.getitemstring(48,li_lang)
THIS.is_quarter3 = lds_lang.getitemstring(49,li_lang)
THIS.is_quarter4 = lds_lang.getitemstring(50,li_lang)
THIS.is_january = lds_lang.getitemstring(51,li_lang)
THIS.is_february = lds_lang.getitemstring(52,li_lang)
THIS.is_march = lds_lang.getitemstring(53,li_lang)
THIS.is_april = lds_lang.getitemstring(54,li_lang)
THIS.is_may = lds_lang.getitemstring(55,li_lang)
THIS.is_june = lds_lang.getitemstring(56,li_lang)
THIS.is_july = lds_lang.getitemstring(57,li_lang)
THIS.is_august = lds_lang.getitemstring(58,li_lang)
THIS.is_september = lds_lang.getitemstring(59,li_lang)
THIS.is_october = lds_lang.getitemstring(60,li_lang)
THIS.is_november = lds_lang.getitemstring(61,li_lang)
THIS.is_december = lds_lang.getitemstring(62,li_lang)
THIS.is_equals_cap = lds_lang.getitemstring(75,li_lang)
DESTROY lds_lang
li_rows = dw_1.rowcount()
li_row = dw_1.find("filtertype = 'Quarter 1'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_quarter1)
li_row = dw_1.find("filtertype = 'Quarter 2'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_quarter2)
li_row = dw_1.find("filtertype = 'Quarter 3'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_quarter3)
li_row = dw_1.find("filtertype = 'Quarter 4'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_quarter4)
li_row = dw_1.find("filtertype = 'January'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_january)
li_row = dw_1.find("filtertype = 'February'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_february)
li_row = dw_1.find("filtertype = 'March'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_march)
li_row = dw_1.find("filtertype = 'April'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_april)
li_row = dw_1.find("filtertype = 'May'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_may)
li_row = dw_1.find("filtertype = 'June'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_june)
li_row = dw_1.find("filtertype = 'July'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_july)
li_row = dw_1.find("filtertype = 'August'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_august)
li_row = dw_1.find("filtertype = 'September'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_september)
li_row = dw_1.find("filtertype = 'October'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_october)
li_row = dw_1.find("filtertype = 'November'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_november)
li_row = dw_1.find("filtertype = 'December'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_december)
RETURN 0

end function

Public function integer  of_initialize (datawindow a_dw,ref nonvisualobject a_powerfilter_checkbox,integer ai_maxcol);//Public function of_initialize (datawindow a_dw,ref nonvisualobject a_powerfilter_checkbox,integer ai_maxcol) returns integer 
//datawindow a_dw
//nonvisualobject a_powerfilter_checkbox
//integer ai_maxcol
integer li_col


THIS.visible = FALSE
THIS.idw_dw = a_dw
THIS.iu_powerfilter_checkbox = a_powerfilter_checkbox
FOR li_col = 1 TO ai_maxcol //3
	THIS.ii_selectedrow[li_col] = 0
NEXT //3
RETURN 0

end function

on u_powerfilter_monthopts.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on u_powerfilter_monthopts.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within u_powerfilter_monthopts
event ue_mousemove pbm_dwnmousemove
event ue_dwnkey pbm_dwnkey
event ue_setrow ( integer row )
string tag = "//MULTILANG in the shared data in the dataobject"
integer x = 5
integer y = 4
integer width = 521
integer height = 1416
integer taborder = 10
string title = "none"
string dataobject = "d_powerfilter_monthopts"
boolean border = false
boolean livescroll = true
end type

event ue_mousemove;//ue_mousemove (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnmousemove]
//integer xpos
//integer ypos
//long row
//dwobject dwo


setrow(row)
RETURN

end event

event ue_dwnkey;//ue_dwnkey (keycode key,ulong keyflags) returns long [pbm_dwnkey]
//keycode key
//ulong keyflags
dwobject dwo_column


IF key = keyleftarrow! THEN //0
	PARENT.iu_powerfilter_predeffilters.dw_1.setfocus()
	PARENT.iu_powerfilter_predeffilters.dw_1.setrow(PARENT.iu_powerfilter_predeffilters.dw_1.rowcount() - 1)
	PARENT.visible = FALSE
END IF //0
IF key = keydownarrow! AND getrow() = rowcount() THEN //4
	POST EVENT ue_setrow(1)
END IF //4
IF key = keyuparrow! AND getrow() = 1 THEN //6
	POST EVENT ue_setrow(rowcount())
END IF //6
IF key = keyenter! THEN //8
	PARENT.visible = FALSE
	dwo_column = THIS.object.filtertype
	POST EVENT clicked(pointerx(),pointery(),getrow(),dwo_column)
	POST EVENT ue_setrow(getrow())
END IF //8
RETURN

end event

event ue_setrow;//ue_setrow (integer row) returns (none)
//integer row


setrow(row)

end event

event clicked;//clicked (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnlbuttonclk]
//integer xpos
//integer ypos
//long row
//dwobject dwo
string ls_filtertype
string ls_parm1
string ls_filter1
string ls_powertip
integer li_return
integer li_row


li_row = row
IF li_row = 0 THEN li_row = rowcount()
ls_filtertype = getitemstring(li_row,"filtertype")
CHOOSE CASE lower(ls_filtertype) //3
	CASE "quarter 1" //3
		ls_filter1 = "In"
		ls_parm1 = "(01,02,03)"
	CASE "quarter 2" //3
		ls_filter1 = "In"
		ls_parm1 = "(04,05,06)"
	CASE "quarter 3" //3
		ls_filter1 = "In"
		ls_parm1 = "(07,08,09)"
	CASE "quarter 4" //3
		ls_filter1 = "In"
		ls_parm1 = "(10,11,12)"
	CASE "january" //3
		ls_filter1 = "Equals"
		ls_parm1 = "01"
	CASE "february" //3
		ls_filter1 = "Equals"
		ls_parm1 = "02"
	CASE "march" //3
		ls_filter1 = "Equals"
		ls_parm1 = "03"
	CASE "april" //3
		ls_filter1 = "Equals"
		ls_parm1 = "04"
	CASE "may" //3
		ls_filter1 = "Equals"
		ls_parm1 = "05"
	CASE "june" //3
		ls_filter1 = "Equals"
		ls_parm1 = "06"
	CASE "july" //3
		ls_filter1 = "Equals"
		ls_parm1 = "07"
	CASE "august" //3
		ls_filter1 = "Equals"
		ls_parm1 = "08"
	CASE "september" //3
		ls_filter1 = "Equals"
		ls_parm1 = "09"
	CASE "october" //3
		ls_filter1 = "Equals"
		ls_parm1 = "10"
	CASE "november" //3
		ls_filter1 = "Equals"
		ls_parm1 = "11"
	CASE "december" //3
		ls_filter1 = "Equals"
		ls_parm1 = "12"
END CHOOSE //3
li_return = PARENT.iu_powerfilter_dropdown.of_monthfilter(ls_filter1,ls_parm1)
IF li_return = 0 THEN //53
	IF ls_powertip <> "" THEN //54
		PARENT.idw_dw.modify("b_powerfilter" + string(PARENT.ii_colnum) + ".tooltip.tip='" + PARENT.is_equals_cap + " " + ls_powertip + "'")
	END IF //54
	PARENT.of_flagrow(li_row)
ELSE //53
END IF //53
PARENT.iu_powerfilter_dropdown.of_close()
PARENT.iu_powerfilter_dropdown.of_savestate()
PARENT.idw_dw.setfocus()

PARENT.idw_dw.event dynamic ue_post_filter()

RETURN

end event

event losefocus;//losefocus (none) returns long [pbm_dwnkillfocus]
graphicobject which_control
powerobject which_parent


which_control = getfocus()
IF isvalid(which_control) THEN //1
	which_parent = which_control.getparent()
	IF which_parent = PARENT.iu_powerfilter_dropdown THEN //3
		PARENT.iu_powerfilter_dropdown.POST EVENT ue_checkfocus()
		RETURN
	END IF //3
END IF //1
PARENT.visible = FALSE
PARENT.iu_powerfilter_dropdown.POST EVENT ue_checkfocus()
RETURN

end event

event getfocus;//getfocus (none) returns long [pbm_dwnsetfocus]


PARENT.of_position()
RETURN

end event

