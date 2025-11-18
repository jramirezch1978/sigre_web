$PBExportHeader$u_powerfilter_predeffilters.sru
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type u_powerfilter_predeffilters from userobject
end type
type dw_1 from datawindow within u_powerfilter_predeffilters
end type
end forward

global type u_powerfilter_predeffilters from userobject
integer width = 946
integer height = 3680
long backcolor = 134217744
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type
global u_powerfilter_predeffilters u_powerfilter_predeffilters

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
u_powerfilter_monthopts iu_powerfilter_monthopts
datawindow idw_dw
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
string is_aboveaverage
string is_after_ellipsis
string is_alldatesintheperiod_ellipsis
string is_before_ellipsis
string is_beginswith_ellipsis
string is_belowaverage
string is_between_ellipsis
string is_contains_ellipsis
string is_customfilter_ellipsis
string is_doesnotcontain_ellipsis
string is_doesnotequal_ellipsis
string is_endswith_ellipsis
string is_equals_ellipsis
string is_greaterthanorequalto_ellipsis
string is_greaterthan_ellipsis
string is_lastmonth
string is_lastquarter
string is_lastweek
string is_lastyear
string is_lessthanorequalto_ellipsis
string is_lessthan_ellipsis
string is_nextmonth
string is_nextquarter
string is_nextweek
string is_nextyear
string is_thismonth
string is_thisquarter
string is_thisweek
string is_thisyear
string is_today
string is_tomorrow
string is_yeartodate
string is_yesterday
string is_averageis
string is_equals_cap

end variables

forward prototypes
Public function integer  of_setdropdown (ref userobject a_powerfilter_dropdown)
Public function integer  of_flagrow (integer ai_row)
Public function integer  of_setlist (string as_coltype,string as_colname,string as_title,integer ai_colnum)
Public function integer  of_restorestate ()
Public function integer  of_position ()
Public function decimal  of_getaverage ()
Public function integer  of_setmonthopts (ref userobject a_powerfilter_monthopts)
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


IF THIS.ii_prevrow > 0 THEN //0
	dw_1.setitem(THIS.ii_prevrow,"Selected",0)
END IF //0
IF ai_row > 0 THEN //2
	dw_1.setitem(ai_row,"Selected",1)
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
CHOOSE CASE lower(THIS.is_coltype) //4
	CASE "date","datet","times" //4
		dw_1.setfilter("datatype in (~"Date~",~"All~")")
	CASE "char(","char" //4
		dw_1.setfilter("datatype in (~"Char~",~"All~")")
	CASE "int","long","numbe","real","ulong","decim" //4
		dw_1.setfilter("datatype in (~"Num~",~"All~")")
	CASE "time" //4
		dw_1.setfilter("datatype in (~"Time~",~"All~")")
	CASE ELSE //4
		messagebox("Error",THIS.is_coltype + " column type for is_ColType not recognized")
		RETURN -1
END CHOOSE //4
dw_1.filter()
dw_1.sort()
THIS.dw_1.height = dw_1.rowcount() * 88 + 44
THIS.height = THIS.dw_1.height + 16
of_restorestate()
iu_powerfilter_monthopts.of_setlist(THIS.is_coltype,THIS.is_colname,THIS.is_title,THIS.ii_colnum)
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


THIS.x = THIS.iu_powerfilter_dropdown.x + THIS.iu_powerfilter_dropdown.width
IF (THIS.x + THIS.width) > (PARENT.DYNAMIC workspacewidth()) THEN //1
	THIS.x = THIS.iu_powerfilter_dropdown.x - THIS.width
END IF //1
THIS.y = THIS.iu_powerfilter_dropdown.y + (88 * (iu_powerfilter_dropdown.dw_buttons.rowcount() - 1)) + 4
IF (THIS.y + THIS.height) > (PARENT.DYNAMIC workspaceheight()) AND (PARENT.DYNAMIC workspaceheight() - THIS.height) > 0 THEN //4
	THIS.y = PARENT.DYNAMIC workspaceheight() - THIS.height
END IF //4
RETURN 0

end function

Public function decimal  of_getaverage ();//Public function of_getaverage (none) returns decimal 
decimal ld_average
string ls_return
string ls_originalfilter


ls_return = idw_dw.modify("create compute(band=foreground alignment=~"0~" " + "expression=~"avg(" + THIS.is_colname + "  for all )~" " + "border=~"0~" color=~"255~" x=~"1~" y=~"1~" height=~"1~" width=~"1~" format=~"[GENERAL]~" html.valueishtml=~"0~"  " + "name=powerfilter_computed_average " + "visible=~"0~"  " + "font.face=~"Tahoma~" font.height=~"-10~" font.weight=~"400~"  font.family=~"2~" font.pitch=~"2~" font.charset=~"0~" " + "background.mode=~"2~" background.color=~"0~" )")
IF idw_dw.filteredcount() > 0 THEN //1
	idw_dw.setredraw(FALSE)
	IF THIS.iu_powerfilter_checkbox.maintainoriginalfilter THEN //3
		iu_powerfilter_checkbox.of_getoriginalfilter(ls_originalfilter)
		idw_dw.setfilter(ls_originalfilter)
	ELSE //3
		idw_dw.setfilter("")
	END IF //3
	idw_dw.filter()
END IF //1
ld_average = dec(THIS.idw_dw.object.powerfilter_computed_average[1])
ls_return = idw_dw.modify("destroy powerfilter_computed_average")
RETURN ld_average

end function

Public function integer  of_setmonthopts (ref userobject a_powerfilter_monthopts);//Public function of_setmonthopts (ref userobject a_powerfilter_monthopts) returns integer 
//userobject a_powerfilter_monthopts


THIS.iu_powerfilter_monthopts = a_powerfilter_monthopts
RETURN 0

end function

public function integer of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
integer li_lang
integer li_row
integer li_rows
datastore lds_lang


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
THIS.is_aboveaverage = lds_lang.getitemstring(14,li_lang)
THIS.is_after_ellipsis = lds_lang.getitemstring(15,li_lang)
THIS.is_alldatesintheperiod_ellipsis = lds_lang.getitemstring(16,li_lang)
THIS.is_before_ellipsis = lds_lang.getitemstring(17,li_lang)
THIS.is_beginswith_ellipsis = lds_lang.getitemstring(18,li_lang)
THIS.is_belowaverage = lds_lang.getitemstring(19,li_lang)
THIS.is_between_ellipsis = lds_lang.getitemstring(20,li_lang)
THIS.is_contains_ellipsis = lds_lang.getitemstring(21,li_lang)
THIS.is_customfilter_ellipsis = lds_lang.getitemstring(22,li_lang)
THIS.is_doesnotcontain_ellipsis = lds_lang.getitemstring(23,li_lang)
THIS.is_doesnotequal_ellipsis = lds_lang.getitemstring(24,li_lang)
THIS.is_endswith_ellipsis = lds_lang.getitemstring(25,li_lang)
THIS.is_equals_ellipsis = lds_lang.getitemstring(26,li_lang)
THIS.is_greaterthanorequalto_ellipsis = lds_lang.getitemstring(27,li_lang)
THIS.is_greaterthan_ellipsis = lds_lang.getitemstring(28,li_lang)
THIS.is_lastmonth = lds_lang.getitemstring(29,li_lang)
THIS.is_lastquarter = lds_lang.getitemstring(30,li_lang)
THIS.is_lastweek = lds_lang.getitemstring(31,li_lang)
THIS.is_lastyear = lds_lang.getitemstring(32,li_lang)
THIS.is_lessthanorequalto_ellipsis = lds_lang.getitemstring(33,li_lang)
THIS.is_lessthan_ellipsis = lds_lang.getitemstring(34,li_lang)
THIS.is_nextmonth = lds_lang.getitemstring(35,li_lang)
THIS.is_nextquarter = lds_lang.getitemstring(36,li_lang)
THIS.is_nextweek = lds_lang.getitemstring(37,li_lang)
THIS.is_nextyear = lds_lang.getitemstring(38,li_lang)
THIS.is_thismonth = lds_lang.getitemstring(39,li_lang)
THIS.is_thisquarter = lds_lang.getitemstring(40,li_lang)
THIS.is_thisweek = lds_lang.getitemstring(41,li_lang)
THIS.is_thisyear = lds_lang.getitemstring(42,li_lang)
THIS.is_today = lds_lang.getitemstring(43,li_lang)
THIS.is_tomorrow = lds_lang.getitemstring(44,li_lang)
THIS.is_yeartodate = lds_lang.getitemstring(45,li_lang)
THIS.is_yesterday = lds_lang.getitemstring(46,li_lang)
THIS.is_averageis = lds_lang.getitemstring(68,li_lang)
THIS.is_equals_cap = lds_lang.getitemstring(75,li_lang)
DESTROY lds_lang
li_rows = dw_1.rowcount()
li_row = dw_1.find("filtertype = 'Equals...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_equals_ellipsis)
li_row = dw_1.find("filtertype = 'Does Not Equal...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_doesnotequal_ellipsis)
li_row = dw_1.find("filtertype = 'Begins With...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_beginswith_ellipsis)
li_row = dw_1.find("filtertype = 'Ends With...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_endswith_ellipsis)
li_row = dw_1.find("filtertype = 'Contains...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_contains_ellipsis)
li_row = dw_1.find("filtertype = 'Does Not Contain...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_doesnotcontain_ellipsis)
li_row = dw_1.find("filtertype = 'Greater Than...' and datatype = 'Num'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_greaterthan_ellipsis)
li_row = dw_1.find("filtertype = 'Greater Than Or Equal To...' and datatype = 'Num'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_greaterthanorequalto_ellipsis)
li_row = dw_1.find("filtertype = 'Less Than...' and datatype = 'Num'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lessthan_ellipsis)
li_row = dw_1.find("filtertype = 'Less Than Or Equal To...' and datatype = 'Num'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lessthanorequalto_ellipsis)
li_row = dw_1.find("filtertype = 'Between...' and datatype = 'Num'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_between_ellipsis)
li_row = dw_1.find("filtertype = 'Above Average'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_aboveaverage)
li_row = dw_1.find("filtertype = 'Below Average'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_belowaverage)
li_row = dw_1.find("filtertype = 'Greater Than...' and datatype = 'Time'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_greaterthan_ellipsis)
li_row = dw_1.find("filtertype = 'Greater Than Or Equal To...' and datatype = 'Time'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_greaterthanorequalto_ellipsis)
li_row = dw_1.find("filtertype = 'Less Than...' and datatype = 'Time'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lessthan_ellipsis)
li_row = dw_1.find("filtertype = 'Less Than Or Equal To...' and datatype = 'Time'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lessthanorequalto_ellipsis)
li_row = dw_1.find("filtertype = 'Between...' and datatype = 'Time'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_between_ellipsis)
li_row = dw_1.find("filtertype = 'Before...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_before_ellipsis)
li_row = dw_1.find("filtertype = 'After...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_after_ellipsis)
li_row = dw_1.find("filtertype = 'Between...' and datatype = 'Date'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_between_ellipsis)
li_row = dw_1.find("filtertype = 'Tomorrow'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_tomorrow)
li_row = dw_1.find("filtertype = 'Today'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_today)
li_row = dw_1.find("filtertype = 'Yesterday'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_yesterday)
li_row = dw_1.find("filtertype = 'Next Week'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_nextweek)
li_row = dw_1.find("filtertype = 'This Week'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_thisweek)
li_row = dw_1.find("filtertype = 'Last Week'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lastweek)
li_row = dw_1.find("filtertype = 'Next Month'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_nextmonth)
li_row = dw_1.find("filtertype = 'This Month'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_thismonth)
li_row = dw_1.find("filtertype = 'Last Month'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lastmonth)
li_row = dw_1.find("filtertype = 'Next Quarter'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_nextquarter)
li_row = dw_1.find("filtertype = 'This Quarter'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_thisquarter)
li_row = dw_1.find("filtertype = 'Last Quarter'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lastquarter)
li_row = dw_1.find("filtertype = 'Next Year'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_nextyear)
li_row = dw_1.find("filtertype = 'This Year'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_thisyear)
li_row = dw_1.find("filtertype = 'Last Year'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_lastyear)
li_row = dw_1.find("filtertype = 'Year to Date'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_yeartodate)
li_row = dw_1.find("filtertype = 'All Dates in the Period...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_alldatesintheperiod_ellipsis)
li_row = dw_1.find("filtertype = 'Custom Filter...'",1,li_rows)
IF li_row > 0 THEN dw_1.setitem(li_row,"displaytext",THIS.is_customfilter_ellipsis)
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

on u_powerfilter_predeffilters.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on u_powerfilter_predeffilters.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within u_powerfilter_predeffilters
event ue_mousemove pbm_dwnmousemove
event ue_dwnkey pbm_dwnkey
event ue_setrow ( integer row )
string tag = "//MULTILANG in the shared data in the dataobject"
integer x = 5
integer y = 4
integer width = 933
integer height = 3656
integer taborder = 10
string title = "none"
string dataobject = "d_powerfilter_filteropts"
boolean border = false
boolean livescroll = true
end type

event ue_mousemove;//ue_mousemove (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnmousemove]
//integer xpos
//integer ypos
//long row
//dwobject dwo


IF ((((keydown(keyleftarrow!) OR keydown(keyrightarrow!)) OR keydown(keyuparrow!)) OR keydown(keydownarrow!)) OR keydown(keytab!)) THEN RETURN
IF row = (rowcount() - 1) THEN //1
	CHOOSE CASE lower(PARENT.is_coltype) //2
		CASE "date","datet" //2
			PARENT.iu_powerfilter_monthopts.dw_1.setfocus()
			PARENT.iu_powerfilter_monthopts.visible = TRUE
	END CHOOSE //2
ELSE //1
	PARENT.iu_powerfilter_monthopts.visible = FALSE
	setfocus()
END IF //1
setrow(row)
RETURN

end event

event ue_dwnkey;//ue_dwnkey (keycode key,ulong keyflags) returns long [pbm_dwnkey]
//keycode key
//ulong keyflags
dwobject dwo_column


IF key = keyleftarrow! THEN //0
	PARENT.iu_powerfilter_dropdown.dw_buttons.setfocus()
	PARENT.iu_powerfilter_dropdown.dw_buttons.setrow(PARENT.iu_powerfilter_dropdown.dw_buttons.rowcount())
	PARENT.visible = FALSE
END IF //0
IF getrow() = (rowcount() - 1) THEN //4
	CHOOSE CASE lower(PARENT.is_coltype) //5
		CASE "date","datet" //5
			CHOOSE CASE key //7
				CASE keyrightarrow! //7
					PARENT.iu_powerfilter_monthopts.dw_1.setfocus()
					PARENT.iu_powerfilter_monthopts.visible = TRUE
			END CHOOSE //7
	END CHOOSE //5
END IF //4
IF key = keydownarrow! AND getrow() = rowcount() THEN //11
	POST EVENT ue_setrow(1)
END IF //11
IF key = keyuparrow! AND getrow() = 1 THEN //13
	POST EVENT ue_setrow(rowcount())
END IF //13
IF key = keyenter! THEN //15
	PARENT.visible = FALSE
	dwo_column = THIS.object.filtertype
	POST EVENT clicked(pointerx(),pointery(),getrow(),dwo_column)
	POST EVENT ue_setrow(getrow())
END IF //15
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
string ls_parm2
string ls_filter1
string ls_filter2
string ls_andor
string ls_dayname
date ld_date
date ld_enddate
decimal ld_average
integer li_day
integer li_currentmonth
integer li_startmonth
integer li_endmonth
integer li_month
integer li_currentyear
integer li_year
integer li_return
integer li_row


ls_andor = "And"
li_row = row
IF li_row = 0 THEN li_row = rowcount()
ls_filtertype = getitemstring(li_row,"filtertype")
CHOOSE CASE lower(ls_filtertype) //4
	CASE "equals..." //4
		ls_filter1 = "Equals"
	CASE "does not equal..." //4
		ls_filter1 = "Does Not Equal"
	CASE "begins with..." //4
		ls_filter1 = "Begins With"
	CASE "ends with..." //4
		ls_filter1 = "Ends with"
	CASE "contains..." //4
		ls_filter1 = "Contains"
	CASE "does not contain..." //4
		ls_filter1 = "Does Not Contain"
	CASE "less than...","before..." //4
		ls_filter1 = "Is Less Than"
	CASE "greater than...","after..." //4
		ls_filter1 = "Is Greater Than"
	CASE "less than or equal to..." //4
		ls_filter1 = "Is Less Than Or Equal To"
	CASE "greater than or equal to..." //4
		ls_filter1 = "Is Greater Than Or Equal To"
	CASE "between..." //4
		ls_filter1 = "Is Greater Than Or Equal To"
		ls_filter2 = "Is Less Than Or Equal To"
		ls_andor = "And"
	CASE "above average" //4
		ld_average = PARENT.of_getaverage()
		ls_parm1 = string(ld_average)
		ls_filter1 = "Is Greater Than"
	CASE "below average" //4
		ld_average = PARENT.of_getaverage()
		ls_parm1 = string(ld_average)
		ls_filter1 = "Is Less Than"
	CASE "tomorrow" //4
		ls_filter1 = "Equals"
		ls_parm1 = string(relativedate(today(),1))
	CASE "today" //4
		ls_filter1 = "Equals"
		ls_parm1 = string(today())
	CASE "yesterday" //4
		ls_filter1 = "Equals"
		ls_parm1 = string(relativedate(today(),-1))
	CASE "next week" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = relativedate(today(),7)
		ls_dayname = dayname(ld_date)
		DO UNTIL ls_dayname = "Sunday" //52
			ld_date = relativedate(ld_date,-1)
			ls_dayname = dayname(ld_date)
		LOOP //52
		ls_parm1 = string(ld_date)
		ls_parm2 = string(relativedate(ld_date,7))
	CASE "this week" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = today()
		ls_dayname = dayname(ld_date)
		DO UNTIL ls_dayname = "Sunday" //64
			ld_date = relativedate(ld_date,-1)
			ls_dayname = dayname(ld_date)
		LOOP //64
		ls_parm1 = string(ld_date)
		ls_parm2 = string(relativedate(ld_date,7))
	CASE "last week" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = relativedate(today(),-7)
		ls_dayname = dayname(ld_date)
		DO UNTIL ls_dayname = "Sunday" //76
			ld_date = relativedate(ld_date,-1)
			ls_dayname = dayname(ld_date)
		LOOP //76
		ls_parm1 = string(ld_date)
		ls_parm2 = string(relativedate(ld_date,7))
	CASE "next month" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = relativedate(today(),1)
		li_day = day(ld_date)
		DO UNTIL li_day = 1 //88
			ld_date = relativedate(ld_date,1)
			li_day = day(ld_date)
		LOOP //88
		ld_enddate = relativedate(ld_date,28)
		li_day = day(ld_enddate)
		DO UNTIL li_day = 1 //94
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
		LOOP //94
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "this month" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = today()
		li_day = day(ld_date)
		DO UNTIL li_day = 1 //106
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
		LOOP //106
		ld_enddate = relativedate(ld_date,28)
		li_day = day(ld_enddate)
		DO UNTIL li_day = 1 //112
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
		LOOP //112
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "last month" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_enddate = today()
		li_day = day(ld_enddate)
		DO UNTIL li_day = 1 //124
			ld_enddate = relativedate(ld_enddate,-1)
			li_day = day(ld_enddate)
		LOOP //124
		ld_date = relativedate(ld_enddate,-28)
		li_day = day(ld_date)
		DO UNTIL li_day = 1 //130
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
		LOOP //130
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "next quarter" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		li_currentmonth = month(today())
		CHOOSE CASE li_currentmonth //141
			CASE 1,2,3 //141
				li_startmonth = 4
				li_endmonth = 7
			CASE 4,5,6 //141
				li_startmonth = 7
				li_endmonth = 10
			CASE 7,8,9 //141
				li_startmonth = 10
				li_endmonth = 1
			CASE 10,11,12 //141
				li_startmonth = 1
				li_endmonth = 4
		END CHOOSE //141
		ld_date = today()
		li_day = day(ld_date)
		li_month = month(ld_date)
		DO UNTIL li_month = li_startmonth AND li_day = 1 //157
			ld_date = relativedate(ld_date,1)
			li_day = day(ld_date)
			li_month = month(ld_date)
		LOOP //157
		ld_enddate = relativedate(ld_date,90)
		li_day = day(ld_enddate)
		li_month = month(ld_enddate)
		DO UNTIL li_month = li_endmonth AND li_day = 1 //165
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
			li_month = month(ld_enddate)
		LOOP //165
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "this quarter" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		li_currentmonth = month(today())
		CHOOSE CASE li_currentmonth //177
			CASE 1,2,3 //177
				li_startmonth = 1
				li_endmonth = 4
			CASE 4,5,6 //177
				li_startmonth = 4
				li_endmonth = 7
			CASE 7,8,9 //177
				li_startmonth = 7
				li_endmonth = 10
			CASE 10,11,12 //177
				li_startmonth = 10
				li_endmonth = 1
		END CHOOSE //177
		ld_date = today()
		li_day = day(ld_date)
		li_month = month(ld_date)
		DO UNTIL li_month = li_startmonth AND li_day = 1 //193
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
			li_month = month(ld_date)
		LOOP //193
		ld_enddate = relativedate(ld_date,90)
		li_day = day(ld_enddate)
		li_month = month(ld_enddate)
		DO UNTIL li_month = li_endmonth AND li_day = 1 //201
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
			li_month = month(ld_enddate)
		LOOP //201
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "last quarter" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		li_currentmonth = month(today())
		CHOOSE CASE li_currentmonth //213
			CASE 1,2,3 //213
				li_startmonth = 10
				li_endmonth = 1
			CASE 4,5,6 //213
				li_startmonth = 1
				li_endmonth = 4
			CASE 7,8,9 //213
				li_startmonth = 4
				li_endmonth = 7
			CASE 10,11,12 //213
				li_startmonth = 7
				li_endmonth = 10
		END CHOOSE //213
		ld_date = today()
		li_day = day(ld_date)
		li_month = month(ld_date)
		DO UNTIL li_month = li_startmonth AND li_day = 1 //229
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
			li_month = month(ld_date)
		LOOP //229
		ld_enddate = relativedate(ld_date,90)
		li_day = day(ld_enddate)
		li_month = month(ld_enddate)
		DO UNTIL li_month = li_endmonth AND li_day = 1 //237
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
			li_month = month(ld_enddate)
		LOOP //237
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "next year" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = today()
		li_currentyear = year(ld_date)
		li_year = year(ld_date)
		DO UNTIL li_year <> li_currentyear //251
			ld_date = relativedate(ld_date,1)
			li_year = year(ld_date)
		LOOP //251
		ld_enddate = relativedate(ld_date,365)
		li_day = day(ld_enddate)
		li_month = month(ld_enddate)
		DO UNTIL li_month = 1 AND li_day = 1 //258
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
			li_month = month(ld_enddate)
		LOOP //258
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "this year" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = today()
		li_day = day(ld_date)
		li_month = month(ld_date)
		DO UNTIL li_month = 1 AND li_day = 1 //272
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
			li_month = month(ld_date)
		LOOP //272
		ld_enddate = relativedate(ld_date,365)
		li_day = day(ld_enddate)
		li_month = month(ld_enddate)
		DO UNTIL li_month = 1 AND li_day = 1 //280
			ld_enddate = relativedate(ld_enddate,1)
			li_day = day(ld_enddate)
			li_month = month(ld_enddate)
		LOOP //280
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "last year" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_enddate = today()
		li_currentyear = year(ld_enddate)
		li_year = year(ld_enddate)
		DO UNTIL li_year <> li_currentyear //294
			ld_enddate = relativedate(ld_enddate,-1)
			li_year = year(ld_enddate)
		LOOP //294
		ld_enddate = relativedate(ld_enddate,1)
		ld_date = relativedate(ld_enddate,-365)
		li_day = day(ld_date)
		li_month = month(ld_date)
		DO UNTIL li_month = 1 AND li_day = 1 //302
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
			li_month = month(ld_date)
		LOOP //302
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "year to date" //4
		ls_filter1 = "Is Greater Than or equal to"
		ls_filter2 = "Is Less Than"
		ls_andor = "And"
		ld_date = today()
		ld_enddate = relativedate(ld_date,1)
		li_day = day(ld_date)
		li_month = month(ld_date)
		DO UNTIL li_month = 1 AND li_day = 1 //317
			ld_date = relativedate(ld_date,-1)
			li_day = day(ld_date)
			li_month = month(ld_date)
		LOOP //317
		ls_parm1 = string(ld_date)
		ls_parm2 = string(ld_enddate)
	CASE "all dates in the period..." //4
		RETURN
	CASE "custom filter..." //4
END CHOOSE //4
li_return = PARENT.iu_powerfilter_dropdown.of_customfilter(ls_filter1,ls_parm1,ls_filter2,ls_parm2,ls_andor)
IF li_return = 0 THEN //328
	PARENT.of_flagrow(li_row)
	PARENT.iu_powerfilter_monthopts.of_flagrow(0)
ELSE //328
END IF //328
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
	ELSEIF which_parent = PARENT.iu_powerfilter_monthopts THEN //3
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

