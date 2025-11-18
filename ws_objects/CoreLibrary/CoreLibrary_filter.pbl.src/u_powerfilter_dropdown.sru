$PBExportHeader$u_powerfilter_dropdown.sru
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type u_powerfilter_dropdown from userobject
end type
type p_1 from picture within u_powerfilter_dropdown
end type
type r_2 from rectangle within u_powerfilter_dropdown
end type
type p_resizer from picture within u_powerfilter_dropdown
end type
type cb_cancel from commandbutton within u_powerfilter_dropdown
end type
type cb_ok from commandbutton within u_powerfilter_dropdown
end type
type cbx_1 from checkbox within u_powerfilter_dropdown
end type
type dw_powerfilter from datawindow within u_powerfilter_dropdown
end type
type dw_buttons from datawindow within u_powerfilter_dropdown
end type
type ln_1 from line within u_powerfilter_dropdown
end type
type shl_msg from statichyperlink within u_powerfilter_dropdown
end type
type sle_filter from singlelineedit within u_powerfilter_dropdown
end type
end forward

global type u_powerfilter_dropdown from userobject
boolean visible = false
integer width = 1070
integer height = 1400
string text = "none"
borderstyle borderstyle = styleraised!
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_checkfocus ( )
p_1 p_1
r_2 r_2
p_resizer p_resizer
cb_cancel cb_cancel
cb_ok cb_ok
cbx_1 cbx_1
dw_powerfilter dw_powerfilter
dw_buttons dw_buttons
ln_1 ln_1
shl_msg shl_msg
sle_filter sle_filter
end type
global u_powerfilter_dropdown u_powerfilter_dropdown

type variables
datawindow idw_dw
datastore ids_powerfilter[]
string is_ddfilter
string is_colname
string is_title
string is_columnfilter
string is_coltype
string is_defaulttiptext
string is_colformat
n_cst_powerfilter iu_powerfilter_checkbox
u_powerfilter_predeffilters iu_powerfilter_predeffilters
u_powerfilter_monthopts iu_powerfilter_monthopts
integer ii_colnum
integer ii_maxitems
integer ii_minwidth
integer ii_minheight
integer ii_maxwidth
integer ii_maxheight
integer ii_dwxoffset
integer ii_dwyoffset
integer ii_dwbxoffset
integer ii_dwbyoffset
integer ii_okxoffset
integer ii_okyoffset
integer ii_canxoffset
integer ii_canyoffset
integer ii_resizerxoffset
integer ii_resizeryoffset
integer ii_rectxoffset
integer ii_rectyoffset
integer ii_lineyoffset
integer ii_evalxoffset
integer ii_evalyoffset
window iw_parent
boolean ib_picturevisible[]
boolean ib_selectall[]
boolean ib_allowquicksort
integer ii_buttonsrow3[]
integer ii_buttonsrow4[]
s_powerfilter_parms is_returnparms[]
s_powerfilter_parms is_openparms[]
string is_defaulttype
string is_canceltype
olecustomcontrol iocc_default
olecustomcontrol iocc_cancel
picturebutton ipb_default
picturebutton ipb_cancel
commandbutton icb_default
commandbutton icb_cancel
integer ii_lang
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
string is_blank
string is_matchingcase
string is_selectall
string is_and
string is_cancel
string is_clearfilterfrom
string is_clickanddragtochangesizeofdropdown
string is_datefilters
string is_doesnotequal_cap
string is_equals_cap
string is_matchcase
string is_numberfilters
string is_ok
string is_or
string is_sortatoz
string is_sortearliesttolatest
string is_sortlargesttosmallest
string is_sortlatesttoearliest
string is_sortnewesttooldest
string is_sortoldesttonewest
string is_sortsmallesttolargest
string is_sortztoa
string is_textfilters
string is_timefilters
boolean ib_datalistfilter = false

end variables

forward prototypes
public subroutine of_getvalues (string as_column)
Public function integer  of_getparentwindow (ref window aw_parent)
Private function integer  of_resize (integer ai_x,integer ai_y)
Public function integer  of_savestate ()
Public function integer  of_restorestate ()
Public function integer  of_customfilter (string as_filter1,string as_parm1,string as_filter2,string as_parm2,string as_andor)
Public function integer  of_replace (ref string as_string,string as_old,string as_new)
Public function integer  of_close ()
public function integer of_open (integer ai_colnum, string as_colname, string as_title, string as_coltype, string as_columnfilter)
Public function integer  of_getdefaultcontrol (window aw_parentwindow)
Public function integer  of_restoredefaultcontrol ()
Public function integer  of_monthfilter (string as_filter1,string as_parm1)
Public function integer  of_setpredef (ref userobject a_predeffilters,ref userobject a_monthopts)
Public function integer  of_cleardefaultcontrol ()
public function integer of_setlanguage (integer ai_languagenumber)
Public function integer  of_initialize (ref datawindow adw_dw,ref nonvisualobject a_powerfilter_checkbox,integer a_maxitems,integer ai_maxcol,boolean ab_allowquicksort,string as_defaulttiptext)
Public subroutine of_getvaluesoriginal (string as_column)
end prototypes

event ue_checkfocus;//ue_checkfocus (none) returns (none)
graphicobject which_control
powerobject which_parent


which_control = getfocus()
IF isvalid(which_control) THEN //1
	which_parent = which_control.getparent()
	IF which_parent = THIS THEN //3
		IF which_control <> THIS.dw_buttons THEN dw_buttons.object.rr_1.visible = FALSE
		RETURN
	END IF //3
	IF which_parent = THIS.iu_powerfilter_predeffilters THEN //6
		dw_buttons.object.rr_1.visible = "0~tif(getrow()=currentrow(),1,0)"
		RETURN
	END IF //6
	IF which_control = THIS.idw_dw THEN //9
		IF match(idw_dw.getobjectatpointer(),"b_powerfilter" + string(THIS.ii_colnum)) THEN //10
			RETURN
		END IF //10
	END IF //9
END IF //1
THIS.iu_powerfilter_monthopts.visible = FALSE
THIS.iu_powerfilter_predeffilters.visible = FALSE
of_close()

end event

public subroutine of_getvalues (string as_column);//Public function of_getvalues (string as_column) returns (none)
//string as_column
string ls_value
string ls_valuetest
string ls_sort
string ls_return
string ls_mod
string ls_ascendingtext
string ls_descendingtext
string ls_filtertext
string ls_clearfiltertext
string ls_holdfilter
boolean lb_blankfound
long ll_row
long ll_rowcount
long ll_dropdownrows
long ll_newrow
long ll_rc
long ll_filteredcount
long ll_unfilteredcount
decimal ld_numvalue
date ldt_datevalue
datetime ldtm_datetimevalue
time ltm_timevalue
integer li_return
long ll_width
long ll_height
string ls_width
string ls_height


setpointer(hourglass!)
THIS.is_coltype = lower(left(idw_dw.describe(as_column + ".Coltype"),5))
THIS.is_colformat = idw_dw.describe(THIS.is_colname + ".Format")
IF left(THIS.is_colformat,1) = "~"" AND right(THIS.is_colformat,1) = "~"" THEN //3
	THIS.is_colformat = mid(THIS.is_colformat,2,len(THIS.is_colformat) - 2)
END IF //3
THIS.dw_powerfilter.dataobject = "d_powerfilter"
ls_mod = dw_powerfilter.describe("t_blank.text")
of_replace(ls_mod,"(Blank)",THIS.is_blank)
ls_return = dw_powerfilter.modify("t_blank.text=" + ls_mod)
ls_mod = dw_powerfilter.describe("t_blank.visible")
of_replace(ls_mod,"(Blank)",THIS.is_blank)
ls_return = dw_powerfilter.modify("t_blank.visible=" + ls_mod)
dw_powerfilter.setrowfocusindicator(focusrect!)
of_restorestate()
IF len(THIS.is_columnfilter) = 0 THEN //14
	ids_powerfilter[THIS.ii_colnum].reset()
END IF //14


sle_filter.visible = false
ls_return = dw_powerfilter.modify("timeitem.visible='0' dateitem.visible='0' datetimeitem.visible='0' numericitem.visible='0' item.visible='0' ")
CHOOSE CASE THIS.is_coltype //17
	CASE "char(","char" //17
		ls_sort = "item"
		ls_ascendingtext = THIS.is_sortatoz
		ls_descendingtext = THIS.is_sortztoa
		ls_filtertext = THIS.is_textfilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"item")
		ls_return = dw_powerfilter.modify("item.visible=~"1~" ")
		
		ls_return = dw_powerfilter.modify("item.Format=~"" + THIS.is_colformat + "~"")
		IF (lower(idw_dw.describe(as_column + ".BitmapName"))) = "yes" THEN //27
			dw_powerfilter.object.item.bitmapname = "Yes"
			ll_width = long(idw_dw.describe(as_column + ".width"))
			ll_height = long(idw_dw.describe(as_column + ".height"))
			DO WHILE ll_height > (52 * 4) //31
				ll_width = ll_width * 0.9
				ll_height = ll_height * 0.9
			LOOP //31
			ls_width = string(ll_width)
			ls_height = string(ll_height)
			dw_powerfilter.object.item.width = ls_width
			dw_powerfilter.object.item.height = ls_height
			dw_powerfilter.object.datawindow.detail.height = ls_height
			ids_powerfilter[THIS.ii_colnum].object.item.bitmapname = "Yes"
			ids_powerfilter[THIS.ii_colnum].object.item.width = ls_width
			ids_powerfilter[THIS.ii_colnum].object.item.height = ls_height
			ids_powerfilter[THIS.ii_colnum].object.datawindow.detail.height = ls_height
		ELSE //27
			sle_filter.visible = true
			dw_powerfilter.object.item.bitmapname = "No"
			dw_powerfilter.object.item.width = 782
			dw_powerfilter.object.item.height = 52
			dw_powerfilter.object.datawindow.detail.height = "60"
			ids_powerfilter[THIS.ii_colnum].object.item.bitmapname = "No"
			ids_powerfilter[THIS.ii_colnum].object.item.width = 782
			ids_powerfilter[THIS.ii_colnum].object.item.height = 52
			ids_powerfilter[THIS.ii_colnum].object.datawindow.detail.height = "60"
		END IF //27
	CASE "date" //17
		ls_sort = "dateitem"
		ls_ascendingtext = THIS.is_sortoldesttonewest
		ls_descendingtext = THIS.is_sortnewesttooldest
		ls_filtertext = THIS.is_datefilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"dateitem")
		ls_return = dw_powerfilter.modify("dateitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("dateitem.Format=~"" + THIS.is_colformat + "~"")
	CASE "datet","times" //17
		ls_sort = "datetimeitem"
		ls_ascendingtext = THIS.is_sortoldesttonewest
		ls_descendingtext = THIS.is_sortnewesttooldest
		ls_filtertext = THIS.is_datefilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"datetimeitem")
		ls_return = dw_powerfilter.modify("datetimeitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("datetimeitem.Format=~"" + THIS.is_colformat + "~"")
	CASE "int","long","numbe","real","ulong","decim" //17
		ls_sort = "numericitem"
		ls_ascendingtext = THIS.is_sortsmallesttolargest
		ls_descendingtext = THIS.is_sortlargesttosmallest
		ls_filtertext = THIS.is_numberfilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"numericitem")
		ls_return = dw_powerfilter.modify("numericitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("numericitem.Format=~"" + THIS.is_colformat + "~"")
	CASE "time" //17
		ls_sort = "timeitem"
		ls_ascendingtext = THIS.is_sortearliesttolatest
		ls_descendingtext = THIS.is_sortlatesttoearliest
		ls_filtertext = THIS.is_timefilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"timeitem")
		ls_return = dw_powerfilter.modify("timeitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("timeitem.Format=~"" + THIS.is_colformat + "~"")
	CASE ELSE //17
		messagebox("Error",THIS.is_coltype + " column type for is_ColType not recognized")
		RETURN
END CHOOSE //17
IF THIS.ib_allowquicksort THEN //92
	dw_buttons.setitem(1,"buttonname",ls_ascendingtext)
	dw_buttons.setitem(2,"buttonname",ls_descendingtext)
END IF //92
dw_buttons.setitem(dw_buttons.rowcount() - 1,"buttonname",ls_clearfiltertext)
dw_buttons.setitem(dw_buttons.rowcount(),"buttonname",ls_filtertext)
ll_rowcount = idw_dw.rowcount()
ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].rowcount()
FOR ll_row = 1 TO ll_rowcount //99
	CHOOSE CASE THIS.is_coltype //100
		CASE "char(","char" //100
			ls_value = idw_dw.getitemstring(ll_row,as_column)
			IF trim(ls_value) = "" THEN ls_value = trim(ls_value)
			ls_valuetest = ls_value + " "
			IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //105
				lb_blankfound = TRUE
				CONTINUE
			END IF //105
			ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
		CASE "int","long","numbe","real","ulong" //100
			ld_numvalue = THIS.idw_dw.getitemnumber(ll_row,as_column)
			ls_value = string(ld_numvalue)
			ls_valuetest = ls_value + " "
			IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //114
				lb_blankfound = TRUE
				CONTINUE
			END IF //114
			ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"NumericItem",ld_numvalue)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
		CASE "date" //100
			ldt_datevalue = idw_dw.getitemdate(ll_row,as_column)
			ls_value = string(ldt_datevalue,"yyyy-mm-dd")
			ls_valuetest = ls_value + " "
			IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //124
				lb_blankfound = TRUE
				CONTINUE
			END IF //124
			ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"dateItem",ldt_datevalue)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
		CASE "decim" //100
			ld_numvalue = THIS.idw_dw.getitemdecimal(ll_row,as_column)
			ls_value = string(ld_numvalue)
			ls_valuetest = ls_value + " "
			IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //134
				lb_blankfound = TRUE
				CONTINUE
			END IF //134
			ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"NumericItem",ld_numvalue)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
		CASE "datet","times" //100
			ldtm_datetimevalue = idw_dw.getitemdatetime(ll_row,as_column)
			ls_value = string(ldtm_datetimevalue,"yyyy-mm-dd hh:mm:ss:ffffff")
			ls_valuetest = ls_value + " "
			IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //144
				lb_blankfound = TRUE
				CONTINUE
			END IF //144
			ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"datetimeItem",ldtm_datetimevalue)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
		CASE "time" //100
			ltm_timevalue = idw_dw.getitemtime(ll_row,as_column)
			ls_value = string(ltm_timevalue,"hh:mm:ss:ffffff")
			ls_valuetest = ls_value + " "
			IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //154
				lb_blankfound = TRUE
				CONTINUE
			END IF //154
			ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"TimeItem",ltm_timevalue)
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
		CASE ELSE //100
			messagebox("Error",THIS.is_coltype + " column type for is_ColType not recognized")
			RETURN
	END CHOOSE //100
NEXT //99
ids_powerfilter[THIS.ii_colnum].setsort(ls_sort)
ids_powerfilter[THIS.ii_colnum].sort()
dw_powerfilter.setsort(ls_sort)
ids_powerfilter[THIS.ii_colnum].setfilter("getrow()=1 or Item <> Item[-1]")
ids_powerfilter[THIS.ii_colnum].filter()
IF ids_powerfilter[THIS.ii_colnum].filteredcount() > 0 THEN ids_powerfilter[THIS.ii_colnum].rowsdiscard(1,ids_powerfilter[THIS.ii_colnum].filteredcount(),filter!)
IF lb_blankfound THEN //170
	IF ids_powerfilter[THIS.ii_colnum].rowcount() = 0 THEN //171
		ids_powerfilter[THIS.ii_colnum].insertrow(1)
		ids_powerfilter[THIS.ii_colnum].setitem(1,"Item",THIS.is_blank)
	ELSE //171
		IF (ids_powerfilter[THIS.ii_colnum].find("Item = '" + THIS.is_blank + "'",1,ids_powerfilter[THIS.ii_colnum].rowcount())) = 0 THEN //175
			ids_powerfilter[THIS.ii_colnum].insertrow(1)
			ids_powerfilter[THIS.ii_colnum].setitem(1,"Item",THIS.is_blank)
		END IF //175
	END IF //171
END IF //170
li_return = ids_powerfilter[THIS.ii_colnum].rowscopy(1,ids_powerfilter[THIS.ii_colnum].rowcount(),primary!,THIS.dw_powerfilter,1,primary!)
dw_powerfilter.sort()

end subroutine

Public function integer  of_getparentwindow (ref window aw_parent);//Public function of_getparentwindow (ref window aw_parent) returns integer 
//window aw_parent
powerobject lpo_parent


lpo_parent = getparent()
DO WHILE isvalid(lpo_parent) //1
	IF lpo_parent.typeof() <> window! THEN //2
		lpo_parent = lpo_parent.getparent()
		CONTINUE
	END IF //2
	EXIT
LOOP //1
IF (isnull(lpo_parent) OR  NOT (isvalid(lpo_parent))) THEN //7
	setnull(aw_parent)
	RETURN -1
END IF //7
aw_parent = lpo_parent
RETURN 1

end function

Private function integer  of_resize (integer ai_x,integer ai_y);//Private function of_resize (integer ai_x,integer ai_y) returns integer 
//integer ai_x
//integer ai_y
integer li_pointerx
integer li_pointery
integer li_width
integer li_height
integer li_minx
integer li_miny
integer li_maxx
integer li_maxy
integer li_objectwidth


iw_parent.setredraw(FALSE)
setredraw(FALSE)
THIS.iu_powerfilter_monthopts.visible = FALSE
THIS.iu_powerfilter_predeffilters.visible = FALSE
p_resizer.setposition(totop!)
li_pointerx = ai_x
li_pointery = ai_y
IF isvalid(THIS.iw_parent) THEN //7
	THIS.ii_maxwidth = iw_parent.workspacewidth()
	THIS.ii_maxheight = iw_parent.workspaceheight()
ELSE //7
	THIS.ii_maxwidth = THIS.ii_minwidth
	THIS.ii_maxheight = THIS.ii_minheight
END IF //7
li_minx = THIS.x + THIS.ii_minwidth
li_miny = THIS.y + THIS.ii_minheight
IF li_pointerx >= li_minx AND li_pointerx <= THIS.ii_maxwidth THEN //15
	li_width = li_pointerx - THIS.x
ELSEIF li_pointerx > THIS.ii_maxwidth THEN //15
	li_width = THIS.ii_maxwidth - THIS.x
ELSE //15
	li_width = THIS.ii_minwidth
END IF //15
IF li_pointery >= li_miny AND li_pointery <= THIS.ii_maxheight THEN //21
	li_height = li_pointery - THIS.y
ELSEIF li_pointery > THIS.ii_maxheight THEN //21
	li_height = THIS.ii_maxheight - THIS.y
ELSE //21
	li_height = THIS.ii_minheight
END IF //21
IF (li_height <> THIS.height OR li_width <> THIS.width) THEN //27
	THIS.width = li_width
	THIS.height = li_height
	THIS.p_resizer.x = li_width - THIS.p_resizer.width - THIS.ii_resizerxoffset
	THIS.p_resizer.y = li_height - THIS.p_resizer.height - THIS.ii_resizeryoffset
	THIS.cb_ok.x = li_width - THIS.cb_ok.width - THIS.ii_okxoffset
	THIS.cb_ok.y = li_height - THIS.cb_ok.height - THIS.ii_okyoffset
	THIS.cb_cancel.x = li_width - THIS.cb_cancel.width - THIS.ii_canxoffset
	THIS.cb_cancel.y = li_height - THIS.cb_cancel.height - THIS.ii_canyoffset
	THIS.dw_powerfilter.width = li_width - THIS.dw_powerfilter.x - THIS.ii_dwxoffset
	THIS.dw_powerfilter.height = li_height - THIS.dw_powerfilter.y - THIS.ii_dwyoffset
	THIS.shl_msg.width = li_width - THIS.shl_msg.x - THIS.ii_evalxoffset
	THIS.shl_msg.y = li_height - THIS.shl_msg.height - THIS.ii_evalyoffset
	THIS.dw_buttons.width = li_width - THIS.dw_buttons.x - THIS.ii_dwbxoffset
	dw_buttons.object.rr_1.width = THIS.dw_buttons.width - integer(THIS.dw_buttons.object.rr_1.x)
	dw_buttons.object.l_1.x2 = THIS.dw_buttons.width
	dw_buttons.object.buttonname.width = THIS.dw_buttons.width - integer(THIS.dw_buttons.object.buttonname.x)
	dw_buttons.object.p_arrow.x = THIS.dw_buttons.width - 45
	CHOOSE CASE THIS.dw_powerfilter.dataobject //45
		CASE "d_powerfilter" //45
			IF THIS.dw_powerfilter.object.item.bitmapname = "no" THEN //47
				li_objectwidth = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.item.x) - 4
				dw_powerfilter.object.item.width = li_objectwidth
				dw_powerfilter.object.timeitem.width = li_objectwidth
				dw_powerfilter.object.dateitem.width = li_objectwidth
				dw_powerfilter.object.datetimeitem.width = li_objectwidth
				dw_powerfilter.object.numericitem.width = li_objectwidth
				dw_powerfilter.object.t_blank.width = li_objectwidth
			END IF //47
		CASE "d_powerfilter_datetree" //45
			dw_powerfilter.object.dateitem.width = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.dateitem.x) - 4
			dw_powerfilter.object.compute_month.width = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.compute_month.x) - 4
			dw_powerfilter.object.compute_year.width = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.compute_year.x) - 4
		CASE "d_powerfilter_datetimetree" //45
			dw_powerfilter.object.datetimeitem.width = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.datetimeitem.x) - 4
			dw_powerfilter.object.compute_month.width = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.compute_month.x) - 4
			dw_powerfilter.object.compute_year.width = THIS.dw_powerfilter.width - integer(THIS.dw_powerfilter.object.compute_year.x) - 4
	END CHOOSE //45
	THIS.ln_1.endy = li_height - THIS.ii_lineyoffset
	THIS.r_2.width = li_width - THIS.r_2.x - THIS.ii_rectxoffset
	THIS.r_2.height = li_height - THIS.r_2.y - THIS.ii_rectyoffset
	THIS.iu_powerfilter_predeffilters.x = THIS.x + li_width
	IF (THIS.iu_powerfilter_predeffilters.x + THIS.iu_powerfilter_predeffilters.width) > iw_parent.workspacewidth() THEN //67
		THIS.iu_powerfilter_predeffilters.x = THIS.x - THIS.iu_powerfilter_predeffilters.width
	END IF //67
END IF //27
setredraw(TRUE)
iw_parent.setredraw(TRUE)
RETURN 0

end function

Public function integer  of_savestate ();//Public function of_savestate (none) returns integer 


THIS.ib_picturevisible[THIS.ii_colnum] = THIS.p_1.visible
THIS.ib_selectall[THIS.ii_colnum] = THIS.cbx_1.checked
THIS.ii_buttonsrow3[THIS.ii_colnum] = THIS.dw_buttons.getitemnumber(dw_buttons.rowcount() - 1,"Active")
THIS.ii_buttonsrow4[THIS.ii_colnum] = THIS.dw_buttons.getitemnumber(dw_buttons.rowcount(),"Selected")
RETURN 0

end function

Public function integer  of_restorestate ();//Public function of_restorestate (none) returns integer 


THIS.p_1.visible = THIS.ib_picturevisible[THIS.ii_colnum]
THIS.cbx_1.checked = THIS.ib_selectall[THIS.ii_colnum]
dw_buttons.setitem(dw_buttons.rowcount() - 1,"Active",THIS.ii_buttonsrow3[THIS.ii_colnum])
dw_buttons.setitem(dw_buttons.rowcount(),"Selected",THIS.ii_buttonsrow4[THIS.ii_colnum])
RETURN 0

end function

Public function integer  of_customfilter (string as_filter1,string as_parm1,string as_filter2,string as_parm2,string as_andor);//Public function of_customfilter (string as_filter1,string as_parm1,string as_filter2,string as_parm2,string as_andor) returns integer 
//string as_filter1
//string as_parm1
//string as_filter2
//string as_parm2
//string as_andor
string ls_filter
string ls_parm
string ls_andor
string ls_andordisplay
string ls_powertiptext
string ls_colname
string ls_coltype
string ls_delimfront
string ls_delimback
string ls_dditem
string ls_wildfront
string ls_wildback
string ls_not
string ls_nullcheck
string ls_isnull
string ls_ddnull
string ls_ddnullcheck
string ls_strdelim
string ls_strback
integer li_start_pos
integer li_return
boolean lb_matchcase
boolean lb_checkdecimal
integer li_year
integer li_month
integer li_row
integer li_firstrow
integer li_lastrow
boolean ib_partial
string ls_setvalue
long ll_row
long ll_rows
long ll_filteredrows


IF as_filter1 <> "" THEN //0
	THIS.is_returnparms[THIS.ii_colnum].parm1 = as_filter1
	THIS.is_returnparms[THIS.ii_colnum].parm2 = as_parm1
	THIS.is_returnparms[THIS.ii_colnum].parm3 = as_filter2
	THIS.is_returnparms[THIS.ii_colnum].parm4 = as_parm2
	THIS.is_returnparms[THIS.ii_colnum].parm5 = as_andor
	THIS.is_returnparms[THIS.ii_colnum].parm9 = lb_matchcase
	THIS.is_returnparms[THIS.ii_colnum].parm10 = THIS.is_coltype
	THIS.is_returnparms[THIS.ii_colnum].parm12 = ""
	THIS.is_returnparms[THIS.ii_colnum].parm13 = ""
ELSE //0
	IF upperbound(THIS.is_returnparms) < THIS.ii_colnum THEN //11
		THIS.is_returnparms[THIS.ii_colnum].parm1 = ""
		THIS.is_returnparms[THIS.ii_colnum].parm2 = ""
		THIS.is_returnparms[THIS.ii_colnum].parm3 = ""
		THIS.is_returnparms[THIS.ii_colnum].parm4 = ""
		THIS.is_returnparms[THIS.ii_colnum].parm5 = ""
		THIS.is_returnparms[THIS.ii_colnum].parm9 = FALSE
		THIS.is_returnparms[THIS.ii_colnum].parm10 = THIS.is_coltype
		THIS.is_returnparms[THIS.ii_colnum].parm12 = ""
		THIS.is_returnparms[THIS.ii_colnum].parm13 = ""
	END IF //11
END IF //0
THIS.is_openparms[THIS.ii_colnum].parm1 = THIS.is_returnparms[THIS.ii_colnum].parm1
THIS.is_openparms[THIS.ii_colnum].parm2 = THIS.is_returnparms[THIS.ii_colnum].parm2
THIS.is_openparms[THIS.ii_colnum].parm3 = THIS.is_returnparms[THIS.ii_colnum].parm3
THIS.is_openparms[THIS.ii_colnum].parm4 = THIS.is_returnparms[THIS.ii_colnum].parm4
THIS.is_openparms[THIS.ii_colnum].parm5 = THIS.is_returnparms[THIS.ii_colnum].parm5
THIS.is_openparms[THIS.ii_colnum].parm6 = THIS.is_title
THIS.is_openparms[THIS.ii_colnum].parm7 = THIS.ids_powerfilter[THIS.ii_colnum]
THIS.is_openparms[THIS.ii_colnum].parm8 = THIS.is_returnparms[THIS.ii_colnum].parm8
THIS.is_openparms[THIS.ii_colnum].parm9 = THIS.is_returnparms[THIS.ii_colnum].parm9
THIS.is_openparms[THIS.ii_colnum].parm10 = THIS.is_coltype
THIS.is_openparms[THIS.ii_colnum].parm11 = THIS.is_colformat
THIS.is_openparms[THIS.ii_colnum].parm12 = THIS.is_returnparms[THIS.ii_colnum].parm12
THIS.is_openparms[THIS.ii_colnum].parm13 = THIS.is_returnparms[THIS.ii_colnum].parm13
THIS.is_openparms[THIS.ii_colnum].parm14 = THIS.ii_lang
IF as_parm1 = "" THEN //35
	openwithparm(w_powerfilter_custom,THIS.is_openparms[THIS.ii_colnum])
	THIS.is_returnparms[THIS.ii_colnum] = message.powerobjectparm
	idw_dw.setfocus()
END IF //35
IF upper(string(THIS.is_returnparms[THIS.ii_colnum].parm8)) = "CANCEL" THEN RETURN -1
lb_matchcase = THIS.is_returnparms[THIS.ii_colnum].parm9
IF isnull(THIS.iu_powerfilter_checkbox.is_lookup[THIS.ii_colnum]) THEN //41
	ls_colname = THIS.is_colname
	ls_coltype = THIS.is_coltype
ELSE //41
	ls_colname = THIS.iu_powerfilter_checkbox.is_lookup[THIS.ii_colnum]
	ls_coltype = "char"
END IF //41
CHOOSE CASE ls_coltype //47
	CASE "char(","char" //47
		ls_delimfront = "~""
		ls_delimback = "~""
		ls_dditem = "Item"
	CASE "date" //47
		ls_delimfront = "date(~""
		ls_delimback = "~")"
		ls_dditem = "dateitem"
	CASE "datet" //47
		ls_delimfront = "datetime(~""
		ls_delimback = "~")"
		ls_dditem = "datetimeItem"
	CASE "int","long","ulong" //47
		ls_delimfront = ""
		ls_delimback = ""
		ls_dditem = "numericItem"
	CASE "numbe","real","decim" //47
		lb_checkdecimal = TRUE
		ls_delimfront = ""
		ls_delimback = ""
		ls_dditem = "numericItem"
	CASE "time" //47
		ls_delimfront = "time(~""
		ls_delimback = "~")"
		ls_dditem = "TimeItem"
	CASE "times" //47
		ls_delimfront = "datetime(~""
		ls_delimback = "~")"
		ls_dditem = "DateTimeItem"
	CASE ELSE //47
		messagebox("Error",ls_coltype + " column type for ls_ColType not recognized")
		RETURN -1
END CHOOSE //47
ls_andor = string(THIS.is_returnparms[THIS.ii_colnum].parm5)
IF upper(ls_andor) = "AND" THEN //81
	ls_andordisplay = THIS.is_and
ELSE //81
	ls_andordisplay = THIS.is_or
END IF //81
ls_parm = string(THIS.is_returnparms[THIS.ii_colnum].parm2)
IF ls_parm = THIS.is_blank THEN //86
	ls_parm = ""
	ls_isnull = " isnull(" + ls_colname + ") or "
	ls_ddnull = " isnull(" + ls_dditem + ") or string(" + ls_dditem + ") = ~"" + THIS.is_blank + "~" or "
ELSE //86
	of_replace(ls_parm,"~"","~~~"")
	IF lb_checkdecimal THEN of_replace(ls_parm,",",".")
	ls_isnull = ""
	ls_ddnull = ""
END IF //86
li_start_pos = pos(ls_parm,"*")
IF li_start_pos > 0 THEN //96
	of_replace(ls_parm,"*","%")
	IF lower(string(THIS.is_returnparms[THIS.ii_colnum].parm1)) = "equals" THEN //98
		THIS.is_returnparms[THIS.ii_colnum].parm1 = "like"
	END IF //98
END IF //96
li_start_pos = pos(ls_parm,"?")
IF li_start_pos > 0 THEN //101
	of_replace(ls_parm,"?","_")
	IF lower(string(THIS.is_returnparms[THIS.ii_colnum].parm1)) = "equals" THEN //103
		THIS.is_returnparms[THIS.ii_colnum].parm1 = "like"
	END IF //103
END IF //101
ls_wildfront = ""
ls_wildback = ""
ls_nullcheck = ""
ls_ddnullcheck = ""
ls_not = ""
ls_strdelim = ""
ls_strback = ""
CHOOSE CASE lower(string(THIS.is_returnparms[THIS.ii_colnum].parm1)) //112
	CASE "equals" //112
		ls_filter = "= "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
	CASE "does not equal" //112
		ls_filter = "= "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_not = "Not "
	CASE "is greater than" //112
		ls_filter = "> "
	CASE "is greater than or equal to" //112
		ls_filter = ">= "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
	CASE "is less than" //112
		ls_filter = "< "
	CASE "is less than or equal to" //112
		ls_filter = "<= "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
	CASE "begins with" //112
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_wildback = "%"
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "does not begin with" //112
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_not = "Not "
		ls_wildback = "%"
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "ends with" //112
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_wildfront = "%"
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "does not end with" //112
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_not = "Not "
		ls_wildfront = "%"
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "contains" //112
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_wildfront = "%"
		ls_wildback = "%"
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "like" //112
		THIS.is_returnparms[THIS.ii_colnum].parm1 = "Equals"
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_wildfront = ""
		ls_wildback = ""
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "does not contain" //112
		ls_filter = "Like "
		ls_nullcheck = ls_isnull
		ls_ddnullcheck = ls_ddnull
		ls_not = "Not "
		ls_wildfront = "%"
		ls_wildback = "%"
		ls_strdelim = "String("
		ls_strback = ")"
		ls_delimfront = "~""
		ls_delimback = "~""
	CASE "" //112
		ls_filter = ""
END CHOOSE //112
IF ls_parm = "" THEN //206
	ls_wildfront = ""
	ls_wildback = ""
END IF //206
IF  NOT (lb_matchcase) THEN //209
	IF (ls_strdelim <> "" OR ls_dditem = "Item") THEN //210
		ls_parm = lower(ls_parm)
		ls_strdelim = "LOWER(" + ls_strdelim
		ls_strback = ls_strback + ")"
	END IF //210
END IF //209
THIS.is_columnfilter = "(" + ls_not + "(" + ls_nullcheck + ls_strdelim + ls_colname + ls_strback + " " + ls_filter + ls_delimfront + ls_wildfront + ls_parm + ls_wildback + ls_delimback + "))"
THIS.is_ddfilter = "(" + ls_not + "(" + ls_ddnullcheck + ls_strdelim + ls_dditem + ls_strback + " " + ls_filter + ls_delimfront + ls_wildfront + ls_parm + ls_wildback + ls_delimback + "))"
ls_powertiptext = string(THIS.is_returnparms[THIS.ii_colnum].parm12) + " " + string(THIS.is_returnparms[THIS.ii_colnum].parm2)
ls_parm = string(THIS.is_returnparms[THIS.ii_colnum].parm4)
IF ls_parm = THIS.is_blank THEN //218
	ls_parm = ""
	ls_isnull = " isnull(" + ls_colname + ") or "
	ls_ddnull = " isnull(" + ls_dditem + ") or string(" + ls_dditem + ") = ~"" + THIS.is_blank + "~" or "
ELSE //218
	of_replace(ls_parm,"~"","~~~"")
	IF lb_checkdecimal THEN of_replace(ls_parm,",",".")
	ls_isnull = ""
	ls_ddnull = ""
END IF //218
li_start_pos = pos(ls_parm,"*",1)
IF li_start_pos > 0 THEN //228
	of_replace(ls_parm,"*","%")
	IF lower(string(THIS.is_returnparms[THIS.ii_colnum].parm3)) = "equals" THEN //230
		THIS.is_returnparms[THIS.ii_colnum].parm3 = "like"
	END IF //230
END IF //228
li_start_pos = pos(ls_parm,"?",1)
IF li_start_pos > 0 THEN //233
	of_replace(ls_parm,"?","_")
	IF lower(string(THIS.is_returnparms[THIS.ii_colnum].parm3)) = "equals" THEN //235
		THIS.is_returnparms[THIS.ii_colnum].parm3 = "like"
	END IF //235
END IF //233
IF (string(THIS.is_returnparms[THIS.ii_colnum].parm3) = "" OR isnull(THIS.is_returnparms[THIS.ii_colnum].parm3)) THEN //237
ELSE //237
	ls_wildfront = ""
	ls_wildback = ""
	ls_nullcheck = ""
	ls_ddnullcheck = ""
	ls_not = ""
	ls_strdelim = ""
	ls_strback = ""
	CHOOSE CASE lower(string(THIS.is_returnparms[THIS.ii_colnum].parm3)) //246
		CASE "equals" //246
			ls_filter = "= "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
		CASE "does not equal" //246
			ls_filter = "= "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_not = "Not "
		CASE "is greater than" //246
			ls_filter = "> "
		CASE "is greater than or equal to" //246
			ls_filter = ">= "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
		CASE "is less than" //246
			ls_filter = "< "
		CASE "is less than or equal to" //246
			ls_filter = "<= "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
		CASE "begins with" //246
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_wildback = "%"
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "does not begin with" //246
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_not = "Not "
			ls_wildback = "%"
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "ends with" //246
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_wildfront = "%"
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "does not end with" //246
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_not = "Not "
			ls_wildfront = "%"
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "contains" //246
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_wildfront = "%"
			ls_wildback = "%"
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "like" //246
			THIS.is_returnparms[THIS.ii_colnum].parm3 = "Equals"
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_wildfront = ""
			ls_wildback = ""
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "does not contain" //246
			ls_filter = "Like "
			ls_nullcheck = ls_isnull
			ls_ddnullcheck = ls_ddnull
			ls_not = "Not "
			ls_wildfront = "%"
			ls_wildback = "%"
			ls_strdelim = "String("
			ls_strback = ")"
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "" //246
			ls_filter = ""
	END CHOOSE //246
	IF ls_parm = "" THEN //340
		ls_wildfront = ""
		ls_wildback = ""
	END IF //340
	IF  NOT (lb_matchcase) THEN //343
		IF (ls_strdelim <> "" OR ls_dditem = "Item") THEN //344
			ls_parm = lower(ls_parm)
			ls_strdelim = "LOWER(" + ls_strdelim
			ls_strback = ls_strback + ")"
		END IF //344
	END IF //343
	THIS.is_columnfilter = THIS.is_columnfilter + " " + ls_andor + " " + "(" + ls_not + "(" + ls_nullcheck + ls_strdelim + ls_colname + ls_strback + " " + ls_filter + ls_delimfront + ls_wildfront + ls_parm + ls_wildback + ls_delimback + "))"
	THIS.is_ddfilter = THIS.is_ddfilter + " " + ls_andor + " " + "(" + ls_not + "(" + ls_ddnullcheck + ls_strdelim + ls_dditem + ls_strback + " " + ls_filter + ls_delimfront + ls_wildfront + ls_parm + ls_wildback + ls_delimback + "))"
	ls_powertiptext = ls_powertiptext + " " + ls_andordisplay + " " + string(THIS.is_returnparms[THIS.ii_colnum].parm13) + " " + string(THIS.is_returnparms[THIS.ii_colnum].parm4)
END IF //237
THIS.is_columnfilter = "(" + THIS.is_columnfilter + ")"
IF lb_matchcase THEN //352
	ls_powertiptext = ls_powertiptext + "~r~n" + THIS.is_matchingcase
END IF //352
ll_rows = ids_powerfilter[THIS.ii_colnum].rowcount()
FOR ll_row = 1 TO ll_rows //355
	ids_powerfilter[THIS.ii_colnum].object.check[ll_row] ="0"
NEXT //355
ids_powerfilter[THIS.ii_colnum].setfilter(THIS.is_ddfilter)
ids_powerfilter[THIS.ii_colnum].filter()
ll_filteredrows = ids_powerfilter[THIS.ii_colnum].rowcount()
FOR ll_row = 1 TO ll_filteredrows //361
	ids_powerfilter[THIS.ii_colnum].object.check[ll_row] ="1"
NEXT //361
li_return = ids_powerfilter[THIS.ii_colnum].setfilter("")
li_return = ids_powerfilter[THIS.ii_colnum].filter()
ids_powerfilter[THIS.ii_colnum].sort()
IF ll_filteredrows < ll_rows THEN //367
	THIS.cbx_1.checked = FALSE
ELSE //367
	THIS.cbx_1.checked = TRUE
END IF //367
IF THIS.dw_powerfilter.dataobject = "d_powerfilter_datetree" THEN //371
	ids_powerfilter[THIS.ii_colnum].setsort("dateitem a")
	ids_powerfilter[THIS.ii_colnum].sort()
	FOR li_row = 1 TO ids_powerfilter[THIS.ii_colnum].rowcount() //374
		li_year = year(ids_powerfilter[THIS.ii_colnum].getitemdate(li_row,"dateitem"))
		li_month = month(ids_powerfilter[THIS.ii_colnum].getitemdate(li_row,"dateitem"))
		IF isnull(li_year) THEN //377
			ls_setvalue = ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check")
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkyear",ls_setvalue)
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkmonth",ls_setvalue)
			CONTINUE
		END IF //377
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //386
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //387
				ib_partial = TRUE
				EXIT
			END IF //387
		NEXT //386
		IF ib_partial THEN //391
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear","2")
		ELSE //391
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //391
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year) + " and month(dateitem) = " + string(li_month),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year) + " and month(dateitem) = " + string(li_month),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //399
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //400
				ib_partial = TRUE
				EXIT
			END IF //400
		NEXT //399
		IF ib_partial THEN //404
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth","2")
		ELSE //404
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //404
		li_row = li_lastrow
	NEXT //374
ELSEIF THIS.dw_powerfilter.dataobject = "d_powerfilter_datetimetree" THEN //371
	ids_powerfilter[THIS.ii_colnum].setsort("datetimeitem a")
	ids_powerfilter[THIS.ii_colnum].sort()
	FOR li_row = 1 TO ids_powerfilter[THIS.ii_colnum].rowcount() //413
		li_year = year(date(ids_powerfilter[THIS.ii_colnum].getitemdatetime(li_row,"datetimeitem")))
		li_month = month(date(ids_powerfilter[THIS.ii_colnum].getitemdatetime(li_row,"datetimeitem")))
		IF isnull(li_year) THEN //416
			ls_setvalue = ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check")
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkyear",ls_setvalue)
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkmonth",ls_setvalue)
			CONTINUE
		END IF //416
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //425
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //426
				ib_partial = TRUE
				EXIT
			END IF //426
		NEXT //425
		IF ib_partial THEN //430
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear","2")
		ELSE //430
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //430
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year) + " and month(datetimeitem) = " + string(li_month),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year) + " and month(datetimeitem) = " + string(li_month),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //438
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //439
				ib_partial = TRUE
				EXIT
			END IF //439
		NEXT //438
		IF ib_partial THEN //443
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth","2")
		ELSE //443
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //443
		li_row = li_lastrow
	NEXT //413
END IF //371
IF THIS.is_columnfilter = "" THEN //449
	dw_buttons.setitem(dw_buttons.rowcount() - 1,"Active",0)
	dw_buttons.setitem(dw_buttons.rowcount(),"Selected",0)
ELSE //449
	dw_buttons.setitem(dw_buttons.rowcount() - 1,"Active",1)
	dw_buttons.setitem(dw_buttons.rowcount(),"Selected",1)
END IF //449
THIS.p_1.visible = FALSE
IF len(ls_powertiptext) > 150 THEN ls_powertiptext = left(ls_powertiptext,150) + "..."
of_replace(ls_powertiptext,"~"","~~~"")
of_replace(ls_powertiptext,"'","~~'")
idw_dw.modify("b_powerfilter" + string(THIS.ii_colnum) + ".ToolTip.Tip='" + ls_powertiptext + "'")
iu_powerfilter_checkbox.of_buildfilter(THIS.is_columnfilter,THIS.ii_colnum)
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

Public function integer  of_close ();//Public function of_close (none) returns integer 


THIS.iu_powerfilter_monthopts.visible = FALSE
THIS.iu_powerfilter_predeffilters.visible = FALSE
THIS.visible = FALSE
THIS.cb_cancel.cancel = FALSE
THIS.cb_cancel.default = FALSE
of_restoredefaultcontrol()
of_resize(0,0)
dw_buttons.setrow(1)
RETURN 0

end function

public function integer of_open (integer ai_colnum, string as_colname, string as_title, string as_coltype, string as_columnfilter);//Public function of_open (integer ai_colnum,string as_colname,string as_title,string as_coltype,string as_columnfilter) returns integer 
//integer ai_colnum
//string as_colname
//string as_title
//string as_coltype
//string as_columnfilter
integer 		li_height, li_width, li_pointerx, li_pointery, li_x, li_y, li_scrolloffset
long 			ll_zoomoffset, ll_xpos
integer 		li_dwoffsetx, li_dwoffsety, li_ddxoffset, li_ddyoffset 
String 		ls_colname, ls_coltype
powerobject lpo_parentobject
dragobject 	lpo_parent


THIS.ii_colnum 	= ai_colnum
THIS.is_colname 	= as_colname
THIS.is_title 		= as_title
THIS.is_coltype 	= as_coltype
THIS.is_columnfilter = as_columnfilter

li_pointerx = iw_parent.pointerx()
li_pointery = iw_parent.pointery()
li_height = integer(idw_dw.describe("DataWindow.Header.Height")) / THIS.iu_powerfilter_checkbox.idec_unityfactor
li_scrolloffset = integer(THIS.idw_dw.object.datawindow.horizontalscrollposition) / THIS.iu_powerfilter_checkbox.idec_unitxfactor
li_dwoffsetx = THIS.idw_dw.x
li_dwoffsety = THIS.idw_dw.y
lpo_parentobject = idw_dw.getparent()
DO WHILE isvalid(lpo_parentobject) //12
	IF lpo_parentobject.typeof() <> window! THEN //13
		lpo_parent = lpo_parentobject
		li_dwoffsetx = li_dwoffsetx + lpo_parent.x
		li_dwoffsety = li_dwoffsety + lpo_parent.y
		lpo_parentobject = lpo_parentobject.getparent()
		CONTINUE
	END IF //13
	EXIT
LOOP //12
IF THIS.idw_dw.titlebar THEN li_dwoffsety = li_dwoffsety + 108
IF THIS.idw_dw.resizable THEN li_dwoffsetx = li_dwoffsetx + 32
IF upper(THIS.idw_dw.object.datawindow.print.preview) = "YES" THEN //23
	li_dwoffsety = li_dwoffsety + integer(THIS.idw_dw.object.datawindow.print.margin.top) / THIS.iu_powerfilter_checkbox.idec_unityfactor
	li_dwoffsetx = li_dwoffsetx + integer(THIS.idw_dw.object.datawindow.print.margin.left) / THIS.iu_powerfilter_checkbox.idec_unitxfactor
END IF //23
IF upper(THIS.idw_dw.object.datawindow.print.preview.rulers) = "YES" THEN //26
	li_dwoffsety = li_dwoffsety + 76
	li_dwoffsetx = li_dwoffsetx + 80
END IF //26
ll_xpos = (long(idw_dw.describe("b_powerfilter" + string(THIS.ii_colnum) + ".x"))) / THIS.iu_powerfilter_checkbox.idec_unitxfactor
li_width = (integer(idw_dw.describe("b_powerfilter" + string(THIS.ii_colnum) + ".width"))) / THIS.iu_powerfilter_checkbox.idec_unitxfactor
ll_zoomoffset = long(THIS.idw_dw.object.datawindow.zoom)
ll_xpos = (ll_xpos * ll_zoomoffset) / 100.0
li_width = (li_width * ll_zoomoffset) / 100.0
li_height = (li_height * ll_zoomoffset) / 100.0
li_scrolloffset = (li_scrolloffset * ll_zoomoffset) / 100.0
li_x = ll_xpos + li_width - THIS.width - li_scrolloffset + li_dwoffsetx + 8
IF (abs(li_x - (li_pointerx - THIS.width))) > 100 THEN //37
	li_x = li_pointerx - THIS.width + 45
END IF //37
IF li_x < 1 THEN li_x = 1
li_y = li_dwoffsety + li_height
IF (abs(li_y - (li_pointery + 40))) > 100 THEN //41
	li_y = li_pointery + 40
END IF //41
IF li_y < 1 THEN li_y = 1
IF (li_y + THIS.height) > iw_parent.workspaceheight() AND (li_dwoffsety - THIS.height) > 0 THEN //44
	li_y = li_dwoffsety - THIS.height
END IF //44

iu_powerfilter_checkbox.of_getdropdownoffset(li_ddxoffset,li_ddyoffset)
li_x = li_x + li_ddxoffset
li_y = li_y + li_ddyoffset
move(li_x,li_y)

IF isnull(THIS.iu_powerfilter_checkbox.is_lookup[THIS.ii_colnum]) THEN //50
	ls_colname = as_colname
	ls_coltype = THIS.is_coltype
ELSE //50
	ls_colname = THIS.iu_powerfilter_checkbox.is_lookup[THIS.ii_colnum]
	ls_coltype = "char"
END IF //50

iu_powerfilter_predeffilters.of_setlist(ls_coltype,THIS.is_colname,THIS.is_title,ai_colnum)
of_getvalues(ls_colname)
THIS.bringtotop = TRUE
dw_buttons.setfocus()
THIS.visible = TRUE
THIS.cb_cancel.cancel = TRUE
of_cleardefaultcontrol()
RETURN 0

end function

Public function integer  of_getdefaultcontrol (window aw_parentwindow);//Public function of_getdefaultcontrol (window aw_parentwindow) returns integer 
//window aw_parentwindow
integer li_numcontrols
integer li_i
commandbutton lcb_button
picturebutton lpb_button
olecustomcontrol locc_control


li_numcontrols = upperbound(aw_parentwindow.control)
FOR li_i = 1 TO li_numcontrols //1
	CHOOSE CASE aw_parentwindow.control[li_i].typeof() //2
		CASE commandbutton! //2
			lcb_button = aw_parentwindow.control[li_i]
			IF lcb_button.default = TRUE THEN //5
				THIS.icb_default = lcb_button
				THIS.is_defaulttype = "CommandButton"
				EXIT
			END IF //5
		CASE picturebutton! //2
			lpb_button = aw_parentwindow.control[li_i]
			IF lpb_button.default = TRUE THEN //11
				THIS.ipb_default = lpb_button
				THIS.is_defaulttype = "PictureButton"
				EXIT
			END IF //11
		CASE olecustomcontrol! //2
			locc_control = aw_parentwindow.control[li_i]
			IF locc_control.default = TRUE THEN //17
				THIS.iocc_default = locc_control
				THIS.is_defaulttype = "OLECustomControl"
				EXIT
			END IF //17
	END CHOOSE //2
NEXT //1
FOR li_i = 1 TO li_numcontrols //22
	CHOOSE CASE aw_parentwindow.control[li_i].typeof() //23
		CASE commandbutton! //23
			lcb_button = aw_parentwindow.control[li_i]
			IF lcb_button.cancel = TRUE THEN //26
				THIS.icb_cancel = lcb_button
				THIS.is_canceltype = "CommandButton"
				EXIT
			END IF //26
		CASE picturebutton! //23
			lpb_button = aw_parentwindow.control[li_i]
			IF lpb_button.cancel = TRUE THEN //32
				THIS.ipb_cancel = lpb_button
				THIS.is_canceltype = "PictureButton"
				EXIT
			END IF //32
		CASE olecustomcontrol! //23
			locc_control = aw_parentwindow.control[li_i]
			IF locc_control.cancel = TRUE THEN //38
				THIS.iocc_cancel = locc_control
				THIS.is_canceltype = "OLECustomControl"
				EXIT
			END IF //38
	END CHOOSE //23
NEXT //22
RETURN 0

end function

Public function integer  of_restoredefaultcontrol ();//Public function of_restoredefaultcontrol (none) returns integer 


CHOOSE CASE THIS.is_defaulttype //0
	CASE "CommandButton" //0
		THIS.icb_default.default = TRUE
	CASE "PictureButton" //0
		THIS.ipb_default.default = TRUE
	CASE "OLECustomControl" //0
		THIS.iocc_default.default = TRUE
END CHOOSE //0
CHOOSE CASE THIS.is_canceltype //7
	CASE "CommandButton" //7
		THIS.icb_cancel.cancel = TRUE
	CASE "PictureButton" //7
		THIS.ipb_cancel.cancel = TRUE
	CASE "OLECustomControl" //7
		THIS.iocc_cancel.cancel = TRUE
END CHOOSE //7
RETURN 0

end function

Public function integer  of_monthfilter (string as_filter1,string as_parm1);//Public function of_monthfilter (string as_filter1,string as_parm1) returns integer 
//string as_filter1
//string as_parm1
string ls_filter
string ls_parm
string ls_powertiptext
string ls_dditem
integer li_start_pos
integer li_return
integer li_year
integer li_month
integer li_row
integer li_firstrow
integer li_lastrow
boolean ib_partial
string ls_setvalue
long ll_row
long ll_rows
long ll_filteredrows


ls_parm = as_parm1
CHOOSE CASE THIS.is_coltype //1
	CASE "char(","char" //1
		ls_dditem = "Item"
	CASE "date" //1
		ls_dditem = "dateitem"
	CASE "datet" //1
		ls_dditem = "datetimeItem"
	CASE "int","long","numbe","real","ulong","decim" //1
		ls_dditem = "numericItem"
	CASE "time" //1
		ls_dditem = "TimeItem"
	CASE "times" //1
		ls_dditem = "DateTimeItem"
	CASE ELSE //1
		messagebox("Error",THIS.is_coltype + " column type for is_ColType not recognized")
		RETURN -1
END CHOOSE //1
CHOOSE CASE lower(as_filter1) //17
	CASE "equals" //17
		ls_filter = "= "
	CASE "in" //17
		ls_filter = "in "
END CHOOSE //17
THIS.is_columnfilter = "(month(" + THIS.is_colname + ") " + ls_filter + ls_parm + ")"
THIS.is_ddfilter = "(month(" + ls_dditem + ") " + ls_filter + ls_parm + ")"
ls_powertiptext = as_filter1 + " " + as_parm1
THIS.is_columnfilter = "(" + THIS.is_columnfilter + ")"
ll_rows = ids_powerfilter[THIS.ii_colnum].rowcount()
FOR ll_row = 1 TO ll_rows //27
	ids_powerfilter[THIS.ii_colnum].object.check[ll_row] ="0"
NEXT //27
ids_powerfilter[THIS.ii_colnum].setfilter(THIS.is_ddfilter)
ids_powerfilter[THIS.ii_colnum].filter()
ll_filteredrows = ids_powerfilter[THIS.ii_colnum].rowcount()
FOR ll_row = 1 TO ll_filteredrows //33
	ids_powerfilter[THIS.ii_colnum].object.check[ll_row] ="1"
NEXT //33
li_return = ids_powerfilter[THIS.ii_colnum].setfilter("")
li_return = ids_powerfilter[THIS.ii_colnum].filter()
ids_powerfilter[THIS.ii_colnum].sort()
IF ll_filteredrows < ll_rows THEN //39
	THIS.cbx_1.checked = FALSE
ELSE //39
	THIS.cbx_1.checked = TRUE
END IF //39
IF THIS.dw_powerfilter.dataobject = "d_powerfilter_datetree" THEN //43
	ids_powerfilter[THIS.ii_colnum].setsort("dateitem a")
	ids_powerfilter[THIS.ii_colnum].sort()
	FOR li_row = 1 TO ids_powerfilter[THIS.ii_colnum].rowcount() //46
		li_year = year(ids_powerfilter[THIS.ii_colnum].getitemdate(li_row,"dateitem"))
		li_month = month(ids_powerfilter[THIS.ii_colnum].getitemdate(li_row,"dateitem"))
		IF isnull(li_year) THEN //49
			ls_setvalue = ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check")
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkyear",ls_setvalue)
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkmonth",ls_setvalue)
			CONTINUE
		END IF //49
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //58
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //59
				ib_partial = TRUE
				EXIT
			END IF //59
		NEXT //58
		IF ib_partial THEN //63
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear","2")
		ELSE //63
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //63
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year) + " and month(dateitem) = " + string(li_month),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(dateitem) = " + string(li_year) + " and month(dateitem) = " + string(li_month),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //71
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //72
				ib_partial = TRUE
				EXIT
			END IF //72
		NEXT //71
		IF ib_partial THEN //76
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth","2")
		ELSE //76
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //76
		li_row = li_lastrow
	NEXT //46
ELSEIF THIS.dw_powerfilter.dataobject = "d_powerfilter_datetimetree" THEN //43
	ids_powerfilter[THIS.ii_colnum].setsort("datetimeitem a")
	ids_powerfilter[THIS.ii_colnum].sort()
	FOR li_row = 1 TO ids_powerfilter[THIS.ii_colnum].rowcount() //85
		li_year = year(date(ids_powerfilter[THIS.ii_colnum].getitemdatetime(li_row,"datetimeitem")))
		li_month = month(date(ids_powerfilter[THIS.ii_colnum].getitemdatetime(li_row,"datetimeitem")))
		IF isnull(li_year) THEN //88
			ls_setvalue = ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check")
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkyear",ls_setvalue)
			ids_powerfilter[THIS.ii_colnum].setitem(li_row,"checkmonth",ls_setvalue)
			CONTINUE
		END IF //88
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //97
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //98
				ib_partial = TRUE
				EXIT
			END IF //98
		NEXT //97
		IF ib_partial THEN //102
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear","2")
		ELSE //102
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkyear",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //102
		li_firstrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year) + " and month(datetimeitem) = " + string(li_month),1,ids_powerfilter[THIS.ii_colnum].rowcount())
		li_lastrow = ids_powerfilter[THIS.ii_colnum].find("year(datetimeitem) = " + string(li_year) + " and month(datetimeitem) = " + string(li_month),ids_powerfilter[THIS.ii_colnum].rowcount(),li_firstrow)
		IF li_lastrow = 0 THEN li_lastrow = li_firstrow
		ib_partial = FALSE
		FOR li_row = li_firstrow + 1 TO li_lastrow //110
			IF ids_powerfilter[THIS.ii_colnum].getitemstring(li_row,"check") <> (ids_powerfilter[THIS.ii_colnum].getitemstring(li_row - 1,"check")) THEN //111
				ib_partial = TRUE
				EXIT
			END IF //111
		NEXT //110
		IF ib_partial THEN //115
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth","2")
		ELSE //115
			ids_powerfilter[THIS.ii_colnum].setitem(li_firstrow,"checkmonth",ids_powerfilter[THIS.ii_colnum].getitemstring(li_firstrow,"check"))
		END IF //115
		li_row = li_lastrow
	NEXT //85
END IF //43
IF THIS.is_columnfilter = "" THEN //121
	dw_buttons.setitem(dw_buttons.rowcount() - 1,"Active",0)
	dw_buttons.setitem(dw_buttons.rowcount(),"Selected",0)
ELSE //121
	dw_buttons.setitem(dw_buttons.rowcount() - 1,"Active",1)
	dw_buttons.setitem(dw_buttons.rowcount(),"Selected",1)
END IF //121
THIS.p_1.visible = FALSE
IF len(ls_powertiptext) > 150 THEN ls_powertiptext = left(ls_powertiptext,150) + "..."
idw_dw.modify("b_powerfilter" + string(THIS.ii_colnum) + ".ToolTip.Tip='" + ls_powertiptext + "'")
iu_powerfilter_checkbox.of_buildfilter(THIS.is_columnfilter,THIS.ii_colnum)
RETURN 0

end function

Public function integer  of_setpredef (ref userobject a_predeffilters,ref userobject a_monthopts);//Public function of_setpredef (ref userobject a_predeffilters,ref userobject a_monthopts) returns integer 
//userobject a_predeffilters
//userobject a_monthopts


THIS.iu_powerfilter_predeffilters = a_predeffilters
THIS.iu_powerfilter_monthopts = a_monthopts
RETURN 0

end function

Public function integer  of_cleardefaultcontrol ();//Public function of_cleardefaultcontrol (none) returns integer 


CHOOSE CASE THIS.is_defaulttype //0
	CASE "CommandButton" //0
		THIS.icb_default.default = FALSE
	CASE "PictureButton" //0
		THIS.ipb_default.default = FALSE
	CASE "OLECustomControl" //0
		THIS.iocc_default.default = FALSE
END CHOOSE //0
CHOOSE CASE THIS.is_canceltype //7
	CASE "CommandButton" //7
		THIS.icb_cancel.cancel = FALSE
	CASE "PictureButton" //7
		THIS.ipb_cancel.cancel = FALSE
	CASE "OLECustomControl" //7
		THIS.iocc_cancel.cancel = FALSE
END CHOOSE //7
RETURN 0

end function

public function integer of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
integer li_lang
datastore lds_lang


lds_lang = CREATE datastore
lds_lang.dataobject = "d_powerfilter_languages"
li_lang = ai_languagenumber
THIS.ii_lang = li_lang
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
THIS.is_blank = lds_lang.getitemstring(63,li_lang)
THIS.is_matchingcase = lds_lang.getitemstring(64,li_lang)
THIS.is_selectall = lds_lang.getitemstring(65,li_lang)
THIS.is_and = lds_lang.getitemstring(67,li_lang)
THIS.is_cancel = lds_lang.getitemstring(69,li_lang)
THIS.is_clearfilterfrom = lds_lang.getitemstring(70,li_lang)
THIS.is_clickanddragtochangesizeofdropdown = lds_lang.getitemstring(71,li_lang)
THIS.is_datefilters = lds_lang.getitemstring(73,li_lang)
THIS.is_doesnotequal_cap = lds_lang.getitemstring(74,li_lang)
THIS.is_equals_cap = lds_lang.getitemstring(75,li_lang)
THIS.is_matchcase = lds_lang.getitemstring(77,li_lang)
THIS.is_numberfilters = lds_lang.getitemstring(78,li_lang)
THIS.is_ok = lds_lang.getitemstring(79,li_lang)	
THIS.is_or = lds_lang.getitemstring(80,li_lang)
THIS.is_sortatoz = lds_lang.getitemstring(85,li_lang)
THIS.is_sortearliesttolatest = lds_lang.getitemstring(86,li_lang)
THIS.is_sortlargesttosmallest = lds_lang.getitemstring(87,li_lang)
THIS.is_sortlatesttoearliest = lds_lang.getitemstring(88,li_lang)
THIS.is_sortnewesttooldest = lds_lang.getitemstring(89,li_lang)
THIS.is_sortoldesttonewest = lds_lang.getitemstring(90,li_lang)
THIS.is_sortsmallesttolargest = lds_lang.getitemstring(91,li_lang)
THIS.is_sortztoa = lds_lang.getitemstring(92,li_lang)
THIS.is_textfilters = lds_lang.getitemstring(93,li_lang)
THIS.is_timefilters = lds_lang.getitemstring(94,li_lang)
DESTROY lds_lang
THIS.cb_ok.text = THIS.is_ok
THIS.cb_cancel.text = THIS.is_cancel
THIS.cbx_1.text = THIS.is_selectall
THIS.p_resizer.powertiptext = THIS.is_clickanddragtochangesizeofdropdown
RETURN 0

end function

Public function integer  of_initialize (ref datawindow adw_dw,ref nonvisualobject a_powerfilter_checkbox,integer a_maxitems,integer ai_maxcol,boolean ab_allowquicksort,string as_defaulttiptext);//Public function of_initialize (ref datawindow adw_dw,ref nonvisualobject a_powerfilter_checkbox,integer a_maxitems,integer ai_maxcol,boolean ab_allowquicksort,string as_defaulttiptext) returns integer 
//datawindow adw_dw
//nonvisualobject a_powerfilter_checkbox
//integer a_maxitems
//integer ai_maxcol
//boolean ab_allowquicksort
//string as_defaulttiptext
integer li_colnum


THIS.idw_dw = adw_dw
THIS.iu_powerfilter_checkbox = a_powerfilter_checkbox
THIS.ii_maxitems = a_maxitems - 1
THIS.is_defaulttiptext = as_defaulttiptext
THIS.ib_allowquicksort = ab_allowquicksort
FOR li_colnum = 1 TO ai_maxcol //5
	THIS.ids_powerfilter[li_colnum] = CREATE datastore
	THIS.ids_powerfilter[li_colnum].dataobject = "d_powerfilter"
	THIS.ib_picturevisible[li_colnum] = FALSE
	THIS.ib_selectall[li_colnum] = TRUE
	THIS.ii_buttonsrow3[li_colnum] = 0
	THIS.ii_buttonsrow4[li_colnum] = 0
NEXT //5
IF  NOT (THIS.ib_allowquicksort) THEN //13
	IF dw_buttons.rowcount() = 4 THEN //14
		dw_buttons.deleterow(1)
		dw_buttons.deleterow(1)
		THIS.dw_buttons.height = THIS.dw_buttons.height - 176
		THIS.p_1.y = THIS.p_1.y - 176
		THIS.p_resizer.y = THIS.p_resizer.y - 176
		THIS.cb_cancel.y = THIS.cb_cancel.y - 176
		THIS.cb_ok.y = THIS.cb_ok.y - 176
		THIS.cbx_1.y = THIS.cbx_1.y - 176
		     sle_filter.y = sle_filter.y - 176
		THIS.dw_powerfilter.y = THIS.dw_powerfilter.y - 176
		THIS.shl_msg.y = THIS.shl_msg.y - 176
		THIS.ln_1.beginy = THIS.ln_1.beginy - 176
		THIS.ln_1.endy = THIS.ln_1.endy - 176
		THIS.r_2.height = THIS.r_2.height - 176
		THIS.height = THIS.height - 176
	END IF //14
END IF //13
THIS.ii_dwxoffset = THIS.width - THIS.dw_powerfilter.x - THIS.dw_powerfilter.width
THIS.ii_dwyoffset = THIS.height - THIS.dw_powerfilter.y - THIS.dw_powerfilter.height
THIS.ii_dwbxoffset = THIS.width - THIS.dw_buttons.x - THIS.dw_buttons.width
THIS.ii_dwbyoffset = THIS.height - THIS.dw_buttons.y - THIS.dw_buttons.height
THIS.ii_okxoffset = THIS.width - THIS.cb_ok.x - THIS.cb_ok.width
THIS.ii_okyoffset = THIS.height - THIS.cb_ok.y - THIS.cb_ok.height
THIS.ii_canxoffset = THIS.width - THIS.cb_cancel.x - THIS.cb_cancel.width
THIS.ii_canyoffset = THIS.height - THIS.cb_cancel.y - THIS.cb_cancel.height
THIS.ii_resizerxoffset = THIS.width - THIS.p_resizer.x - THIS.p_resizer.width
THIS.ii_resizeryoffset = THIS.height - THIS.p_resizer.y - THIS.p_resizer.height
THIS.ii_rectxoffset = THIS.width - THIS.r_2.x - THIS.r_2.width
THIS.ii_rectyoffset = THIS.height - THIS.r_2.y - THIS.r_2.height
THIS.ii_lineyoffset = THIS.height - THIS.ln_1.endy
THIS.ii_evalxoffset = THIS.width - THIS.shl_msg.x - THIS.shl_msg.width
THIS.ii_evalyoffset = THIS.height - THIS.shl_msg.y - THIS.shl_msg.height
THIS.ii_minwidth = THIS.width
THIS.ii_minheight = THIS.height
of_getparentwindow(THIS.iw_parent)
of_getdefaultcontrol(THIS.iw_parent)
THIS.shl_msg.visible = THIS.iu_powerfilter_checkbox.ib_visible
THIS.shl_msg.enabled = THIS.iu_powerfilter_checkbox.ib_visible
RETURN 0

end function

Public subroutine of_getvaluesoriginal (string as_column);//Public function of_getvaluesoriginal (string as_column) returns (none)
//string as_column
string ls_value
string ls_valuetest
string ls_sort
string ls_return
string ls_mod
string ls_ascendingtext
string ls_descendingtext
string ls_filtertext
string ls_clearfiltertext
string ls_holdfilter
boolean lb_blankfound
long ll_row
long ll_rowcount
long ll_dropdownrows
long ll_newrow
long ll_rc
long ll_filteredcount
long ll_unfilteredcount
decimal ld_numvalue
date ldt_datevalue
datetime ldtm_datetimevalue
time ltm_timevalue
integer li_return
long ll_width
long ll_height
string ls_width
string ls_height


setpointer(hourglass!)
THIS.is_coltype = lower(left(idw_dw.describe(as_column + ".Coltype"),5))
THIS.is_colformat = idw_dw.describe(THIS.is_colname + ".Format")
IF left(THIS.is_colformat,1) = "~"" AND right(THIS.is_colformat,1) = "~"" THEN //3
	THIS.is_colformat = mid(THIS.is_colformat,2,len(THIS.is_colformat) - 2)
END IF //3
THIS.dw_powerfilter.dataobject = "d_powerfilter"
ls_mod = dw_powerfilter.describe("t_blank.text")
of_replace(ls_mod,"(Blank)",THIS.is_blank)
ls_return = dw_powerfilter.modify("t_blank.text=" + ls_mod)
ls_mod = dw_powerfilter.describe("t_blank.visible")
of_replace(ls_mod,"(Blank)",THIS.is_blank)
ls_return = dw_powerfilter.modify("t_blank.visible=" + ls_mod)
dw_powerfilter.setrowfocusindicator(focusrect!)
of_restorestate()
IF len(THIS.is_columnfilter) = 0 THEN //14
	ids_powerfilter[THIS.ii_colnum].reset()
END IF //14
ls_return = dw_powerfilter.modify("timeitem.visible='0' dateitem.visible='0' datetimeitem.visible='0' numericitem.visible='0' item.visible='0' ")
CHOOSE CASE THIS.is_coltype //17
	CASE "char(","char" //17
		ls_sort = "item"
		ls_ascendingtext = THIS.is_sortatoz
		ls_descendingtext = THIS.is_sortztoa
		ls_filtertext = THIS.is_textfilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"item")
		ls_return = dw_powerfilter.modify("item.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("item.Format=~"" + THIS.is_colformat + "~"")
		IF (lower(idw_dw.describe(as_column + ".BitmapName"))) = "yes" THEN //27
			dw_powerfilter.object.item.bitmapname = "Yes"
			ll_width = long(idw_dw.describe(as_column + ".width"))
			ll_height = long(idw_dw.describe(as_column + ".height"))
			DO WHILE ll_height > (52 * 4) //31
				ll_width = ll_width * 0.9
				ll_height = ll_height * 0.9
			LOOP //31
			ls_width = string(ll_width)
			ls_height = string(ll_height)
			dw_powerfilter.object.item.width = ls_width
			dw_powerfilter.object.item.height = ls_height
			dw_powerfilter.object.datawindow.detail.height = ls_height
			ids_powerfilter[THIS.ii_colnum].object.item.bitmapname = "Yes"
			ids_powerfilter[THIS.ii_colnum].object.item.width = ls_width
			ids_powerfilter[THIS.ii_colnum].object.item.height = ls_height
			ids_powerfilter[THIS.ii_colnum].object.datawindow.detail.height = ls_height
		ELSE //27
			dw_powerfilter.object.item.bitmapname = "No"
			dw_powerfilter.object.item.width = 782
			dw_powerfilter.object.item.height = 52
			dw_powerfilter.object.datawindow.detail.height = "60"
			ids_powerfilter[THIS.ii_colnum].object.item.bitmapname = "No"
			ids_powerfilter[THIS.ii_colnum].object.item.width = 782
			ids_powerfilter[THIS.ii_colnum].object.item.height = 52
			ids_powerfilter[THIS.ii_colnum].object.datawindow.detail.height = "60"
		END IF //27
	CASE "date" //17
		ls_sort = "dateitem"
		ls_ascendingtext = THIS.is_sortoldesttonewest
		ls_descendingtext = THIS.is_sortnewesttooldest
		ls_filtertext = THIS.is_datefilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"dateitem")
		ls_return = dw_powerfilter.modify("dateitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("dateitem.Format=~"" + THIS.is_colformat + "~"")
	CASE "datet","times" //17
		ls_sort = "datetimeitem"
		ls_ascendingtext = THIS.is_sortoldesttonewest
		ls_descendingtext = THIS.is_sortnewesttooldest
		ls_filtertext = THIS.is_datefilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"datetimeitem")
		ls_return = dw_powerfilter.modify("datetimeitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("datetimeitem.Format=~"" + THIS.is_colformat + "~"")
	CASE "int","long","numbe","real","ulong","decim" //17
		ls_sort = "numericitem"
		ls_ascendingtext = THIS.is_sortsmallesttolargest
		ls_descendingtext = THIS.is_sortlargesttosmallest
		ls_filtertext = THIS.is_numberfilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"numericitem")
		ls_return = dw_powerfilter.modify("numericitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("numericitem.Format=~"" + THIS.is_colformat + "~"")
	CASE "time" //17
		ls_sort = "timeitem"
		ls_ascendingtext = THIS.is_sortearliesttolatest
		ls_descendingtext = THIS.is_sortlatesttoearliest
		ls_filtertext = THIS.is_timefilters
		ls_clearfiltertext = THIS.is_clearfilterfrom + " ~"" + THIS.is_title + "~""
		of_replace(THIS.is_colformat,THIS.is_colname,"timeitem")
		ls_return = dw_powerfilter.modify("timeitem.visible=~"1~" ")
		ls_return = dw_powerfilter.modify("timeitem.Format=~"" + THIS.is_colformat + "~"")
	CASE ELSE //17
		messagebox("Error",THIS.is_coltype + " column type for is_ColType not recognized")
		RETURN
END CHOOSE //17
IF THIS.ib_allowquicksort THEN //92
	dw_buttons.setitem(1,"buttonname",ls_ascendingtext)
	dw_buttons.setitem(2,"buttonname",ls_descendingtext)
END IF //92
dw_buttons.setitem(dw_buttons.rowcount() - 1,"buttonname",ls_clearfiltertext)
dw_buttons.setitem(dw_buttons.rowcount(),"buttonname",ls_filtertext)
ll_rowcount = idw_dw.rowcount()
ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].rowcount()
FOR ll_row = 1 TO ll_rowcount //99
	CHOOSE CASE THIS.is_coltype //100
		CASE "char(","char" //100
			ls_value = idw_dw.getitemstring(ll_row,as_column)
			IF trim(ls_value) = "" THEN ls_value = trim(ls_value)
		CASE "date" //100
			ls_value = string(idw_dw.getitemdate(ll_row,as_column),"yyyy-mm-dd")
			ldt_datevalue = idw_dw.getitemdate(ll_row,as_column)
		CASE "datet","times" //100
			ls_value = string(idw_dw.getitemdatetime(ll_row,as_column),"yyyy-mm-dd hh:mm:ss:ffffff")
			ldtm_datetimevalue = idw_dw.getitemdatetime(ll_row,as_column)
		CASE "int","long","numbe","real","ulong" //100
			ls_value = string(THIS.idw_dw.getitemnumber(ll_row,as_column))
			ld_numvalue = THIS.idw_dw.getitemnumber(ll_row,as_column)
		CASE "time" //100
			ls_value = string(idw_dw.getitemtime(ll_row,as_column),"hh:mm:ss:ffffff")
			ltm_timevalue = idw_dw.getitemtime(ll_row,as_column)
		CASE "decim" //100
			ls_value = string(THIS.idw_dw.getitemdecimal(ll_row,as_column))
			ld_numvalue = THIS.idw_dw.getitemdecimal(ll_row,as_column)
		CASE ELSE //100
			messagebox("Error",THIS.is_coltype + " column type for is_ColType not recognized")
			RETURN
	END CHOOSE //100
	ls_valuetest = ls_value + " "
	IF (ls_valuetest = (" ") OR isnull(ls_value)) THEN //123
		lb_blankfound = TRUE
		CONTINUE
	END IF //123
	of_replace(ls_value,"~"","~~~"")
	IF (ids_powerfilter[THIS.ii_colnum].find("Item = ~"" + ls_value + "~"",1,ll_dropdownrows)) > 0 THEN //127
		CONTINUE
	END IF //127
	of_replace(ls_value,"~~~"","~"")
	ll_dropdownrows = ids_powerfilter[THIS.ii_colnum].insertrow(0)
	ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"Item",ls_value)
	CHOOSE CASE THIS.is_coltype //132
		CASE "decim","int","long","numbe","real","ulong" //132
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"NumericItem",ld_numvalue)
		CASE "date" //132
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"dateItem",ldt_datevalue)
		CASE "datet","times" //132
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"datetimeItem",ldtm_datetimevalue)
		CASE "time" //132
			ids_powerfilter[THIS.ii_colnum].setitem(ll_dropdownrows,"TimeItem",ltm_timevalue)
	END CHOOSE //132
	IF ll_dropdownrows > THIS.ii_maxitems THEN EXIT
NEXT //99
ids_powerfilter[THIS.ii_colnum].setsort(ls_sort)
ids_powerfilter[THIS.ii_colnum].sort()
dw_powerfilter.setsort(ls_sort)
IF lb_blankfound THEN //146
	IF ids_powerfilter[THIS.ii_colnum].rowcount() = 0 THEN //147
		ids_powerfilter[THIS.ii_colnum].insertrow(1)
		ids_powerfilter[THIS.ii_colnum].setitem(1,"Item",THIS.is_blank)
	ELSE //147
		IF (ids_powerfilter[THIS.ii_colnum].find("Item = '" + THIS.is_blank + "'",1,ids_powerfilter[THIS.ii_colnum].rowcount())) = 0 THEN //151
			ids_powerfilter[THIS.ii_colnum].insertrow(1)
			ids_powerfilter[THIS.ii_colnum].setitem(1,"Item",THIS.is_blank)
		END IF //151
	END IF //147
END IF //146
li_return = ids_powerfilter[THIS.ii_colnum].rowscopy(1,ids_powerfilter[THIS.ii_colnum].rowcount(),primary!,THIS.dw_powerfilter,1,primary!)
dw_powerfilter.sort()

end subroutine

on u_powerfilter_dropdown.create
this.p_1=create p_1
this.r_2=create r_2
this.p_resizer=create p_resizer
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.cbx_1=create cbx_1
this.dw_powerfilter=create dw_powerfilter
this.dw_buttons=create dw_buttons
this.ln_1=create ln_1
this.shl_msg=create shl_msg
this.sle_filter=create sle_filter
this.Control[]={this.p_1,&
this.r_2,&
this.p_resizer,&
this.cb_cancel,&
this.cb_ok,&
this.cbx_1,&
this.dw_powerfilter,&
this.dw_buttons,&
this.ln_1,&
this.shl_msg,&
this.sle_filter}
end on

on u_powerfilter_dropdown.destroy
destroy(this.p_1)
destroy(this.r_2)
destroy(this.p_resizer)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.cbx_1)
destroy(this.dw_powerfilter)
destroy(this.dw_buttons)
destroy(this.ln_1)
destroy(this.shl_msg)
destroy(this.sle_filter)
end on

type p_1 from picture within u_powerfilter_dropdown
boolean visible = false
integer x = 23
integer y = 424
integer width = 91
integer height = 80
boolean originalsize = true
string picturename = "C:\SIGRE\CoreLibrary\imagenes\pf_checkmark_pf.bmp"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type r_2 from rectangle within u_powerfilter_dropdown
long linecolor = 134217744
integer linethickness = 12
long fillcolor = 1073741824
integer x = -9
integer width = 1079
integer height = 1400
end type

type p_resizer from picture within u_powerfilter_dropdown
event ue_mousemove pbm_mousemove
string tag = "//MULTILANG PowerTipText: Click and drag to change size of dropdown"
integer x = 1024
integer y = 1360
integer width = 32
integer height = 28
string pointer = "SizeNWSE!"
boolean originalsize = true
string picturename = "PF_Resize_PF.bmp"
boolean focusrectangle = false
boolean map3dcolors = true
string powertiptext = "Click and drag to change size of dropdown"
end type

event ue_mousemove;//ue_mousemove (ulong flags,integer xpos,integer ypos) returns long [pbm_mousemove]
//ulong flags
//integer xpos
//integer ypos
integer li_pointerx
integer li_pointery
integer li_width
integer li_height


IF  NOT (keydown(keyleftbutton!)) THEN //0
	RETURN
END IF //0
PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
li_pointerx = PARENT.iw_parent.pointerx()
li_pointery = PARENT.iw_parent.pointery()
PARENT.of_resize(li_pointerx,li_pointery)
RETURN 1

end event

event getfocus;//getfocus (none) returns long [pbm_bnsetfocus]


PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
RETURN

end event

event losefocus;//losefocus (none) returns long [pbm_bnkillfocus]


PARENT.POST EVENT ue_checkfocus()
RETURN

end event

event constructor;//constructor (none) returns long [pbm_constructor]


setposition(totop!)
RETURN

end event

type cb_cancel from commandbutton within u_powerfilter_dropdown
event ue_key pbm_keydown
string tag = "//MULTILANG Cancel"
integer x = 658
integer y = 1256
integer width = 379
integer height = 96
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&Cancel"
end type

event ue_key;//ue_key (keycode key,ulong keyflags) returns long [pbm_keydown]
//keycode key
//ulong keyflags


CHOOSE CASE key //0
	CASE keyuparrow!,keyleftarrow! //0
		PARENT.cb_ok.setfocus()
	CASE keydownarrow!,keyrightarrow! //0
		PARENT.dw_buttons.setrow(1)
		PARENT.dw_buttons.setfocus()
END CHOOSE //0
RETURN

end event

event clicked;//clicked (none) returns long [pbm_bnclicked]


PARENT.of_close()
PARENT.of_restorestate()
PARENT.idw_dw.setfocus()
RETURN

end event

event losefocus;//losefocus (none) returns long [pbm_bnkillfocus]


PARENT.POST EVENT ue_checkfocus()
THIS.default = FALSE
RETURN

end event

event getfocus;//getfocus (none) returns long [pbm_bnsetfocus]


PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
THIS.default = TRUE
RETURN

end event

type cb_ok from commandbutton within u_powerfilter_dropdown
event ue_key pbm_keydown
string tag = "//MULTILANG OK"
integer x = 242
integer y = 1256
integer width = 379
integer height = 96
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "&OK"
end type

event ue_key;//ue_key (keycode key,ulong keyflags) returns long [pbm_keydown]
//keycode key
//ulong keyflags


CHOOSE CASE key //0
	CASE keyuparrow!,keyleftarrow! //0
		PARENT.dw_powerfilter.setfocus()
	CASE keydownarrow!,keyrightarrow! //0
		PARENT.cb_cancel.setfocus()
END CHOOSE //0
RETURN

end event

event clicked;//clicked (none) returns long [pbm_bnclicked]
long ll_checkedcount
long ll_uncheckedcount
long ll_row
long ll_rows
long ll_startloop
string ls_item
string ls_delimfront
string ls_delimback
string ls_equal
string ls_not
string ls_comma
string ls_colname
boolean lb_blankfound
boolean lb_checkdecimal


setpointer(hourglass!)
IF isnull(PARENT.iu_powerfilter_checkbox.is_lookup[PARENT.ii_colnum]) THEN //1
	ls_colname = PARENT.is_colname
ELSE //1
	ls_colname = PARENT.iu_powerfilter_checkbox.is_lookup[PARENT.ii_colnum]
END IF //1
IF PARENT.cbx_1.checked THEN //5
	PARENT.is_columnfilter = ""
ELSE //5
	CHOOSE CASE PARENT.is_coltype //8
		CASE "char(","char" //8
			ls_delimfront = "~""
			ls_delimback = "~""
		CASE "int","long","ulong" //8
			ls_delimfront = ""
			ls_delimback = ""
		CASE "numbe","real","decim" //8
			lb_checkdecimal = TRUE
			ls_delimfront = ""
			ls_delimback = ""
		CASE "time" //8
			ls_delimfront = "time(~""
			ls_delimback = "~")"
		CASE "date" //8
			ls_delimfront = "date(~""
			ls_delimback = "~")"
		CASE "datet","times" //8
			ls_delimfront = "datetime(~""
			ls_delimback = "~")"
		CASE ELSE //8
			messagebox("Error",PARENT.is_coltype + " column type for is_ColType not recognized")
			RETURN -1
	END CHOOSE //8
	PARENT.dw_powerfilter.setredraw(FALSE)
	PARENT.dw_powerfilter.setfilter("check = ~"1~"")
	PARENT.dw_powerfilter.filter()
	ll_checkedcount = PARENT.dw_powerfilter.rowcount()
	ll_uncheckedcount = PARENT.dw_powerfilter.filteredcount()
	ls_not = ""
	ls_equal = PARENT.is_equals_cap + " ~""
	IF ll_uncheckedcount < ll_checkedcount THEN //38
		PARENT.dw_powerfilter.setfilter("check = ~"0~"")
		PARENT.dw_powerfilter.filter()
		ls_not = "Not "
		ls_equal = PARENT.is_doesnotequal_cap + " ~""
	END IF //38
	PARENT.dw_powerfilter.sort()
	ll_rows = PARENT.dw_powerfilter.rowcount()
	IF ll_rows > 0 THEN //45
		ll_row = 1
		ls_item = PARENT.dw_powerfilter.getitemstring(ll_row,"Item")
		CHOOSE CASE ls_item //48
			CASE PARENT.is_blank //48
				PARENT.is_columnfilter = "(isnull(" + ls_colname + ") or trim(string(" + ls_colname + ")) = ~"~" "
				IF ll_rows > 1 THEN //51
					ll_row = 2
					ls_item = PARENT.dw_powerfilter.getitemstring(ll_row,"Item")
					PARENT.of_replace(ls_item,"~"","~~~"")
					PARENT.is_columnfilter = PARENT.is_columnfilter + " or " + ls_colname + " in (" + ls_delimfront + ls_item + ls_delimback
					lb_blankfound = TRUE
				END IF //51
				ll_startloop = 3
			CASE ELSE //48
				PARENT.of_replace(ls_item,"~"","~~~"")
				IF lb_checkdecimal THEN PARENT.of_replace(ls_item,",",".")
				PARENT.is_columnfilter = ls_colname + " in (" + ls_delimfront + ls_item + ls_delimback
				ll_startloop = 2
		END CHOOSE //48
		FOR ll_row = ll_startloop TO ll_rows //63
			ls_item = PARENT.dw_powerfilter.getitemstring(ll_row,"Item")
			PARENT.of_replace(ls_item,"~"","~~~"")
			IF lb_checkdecimal THEN PARENT.of_replace(ls_item,",",".")
			PARENT.is_columnfilter = PARENT.is_columnfilter + "," + ls_delimfront + ls_item + ls_delimback
		NEXT //63
		PARENT.is_columnfilter = "(" + ls_not + "(" + PARENT.is_columnfilter + ")))"
		IF lb_blankfound THEN PARENT.is_columnfilter = PARENT.is_columnfilter + ")"
	ELSE //45
		PARENT.is_columnfilter = ""
	END IF //45
	PARENT.dw_powerfilter.setfilter("")
	PARENT.dw_powerfilter.filter()
	PARENT.dw_powerfilter.sort()
	PARENT.dw_powerfilter.setredraw(TRUE)
END IF //5
PARENT.of_close()
PARENT.iu_powerfilter_predeffilters.of_flagrow(0)
PARENT.iu_powerfilter_monthopts.of_flagrow(0)
IF PARENT.is_columnfilter = "" THEN //80
	PARENT.dw_buttons.setitem(PARENT.dw_buttons.rowcount() - 1,"Active",0)
	PARENT.p_1.visible = FALSE
ELSE //80
	PARENT.dw_buttons.setitem(PARENT.dw_buttons.rowcount() - 1,"Active",1)
	PARENT.p_1.visible = TRUE
END IF //80
PARENT.dw_buttons.setitem(PARENT.dw_buttons.rowcount(),"Selected",0)
PARENT.iu_powerfilter_checkbox.of_buildfilter(PARENT.is_columnfilter,PARENT.ii_colnum)
PARENT.of_savestate()
PARENT.ids_powerfilter[PARENT.ii_colnum].reset()
PARENT.dw_powerfilter.rowscopy(1,PARENT.dw_powerfilter.rowcount(),primary!,PARENT.ids_powerfilter[PARENT.ii_colnum],1,primary!)
PARENT.idw_dw.setfocus()

sle_filter.text = ""

PARENT.idw_dw.event dynamic ue_post_filter()

end event

event losefocus;//losefocus (none) returns long [pbm_bnkillfocus]


THIS.default = FALSE
PARENT.POST EVENT ue_checkfocus()
RETURN

end event

event getfocus;//getfocus (none) returns long [pbm_bnsetfocus]


PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
THIS.default = TRUE
RETURN

end event

type cbx_1 from checkbox within u_powerfilter_dropdown
event ue_key pbm_keydown
string tag = "//MULTILANG (Select All)"
integer x = 151
integer y = 360
integer width = 882
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "(Selecionar Todo)                              "
boolean checked = true
end type

event ue_key;//ue_key (keycode key,ulong keyflags) returns long [pbm_keydown]
//keycode key
//ulong keyflags


CHOOSE CASE key //0
	CASE keydownarrow! //0
		PARENT.dw_powerfilter.setfocus()
	CASE keyuparrow! //0
		PARENT.dw_buttons.setrow(PARENT.dw_buttons.rowcount())
		PARENT.dw_buttons.setfocus()
END CHOOSE //0
RETURN

end event

event clicked;//clicked (none) returns long [pbm_bnclicked]
long ll_row
long ll_rows


ll_rows = PARENT.dw_powerfilter.rowcount()
IF THIS.checked THEN //1
	FOR ll_row = 1 TO ll_rows //2
		dw_powerfilter.object.check[ll_row] ="1"
		dw_powerfilter.object.checkmonth[ll_row] ="1"
		dw_powerfilter.object.checkyear[ll_row] ="1"
	NEXT //2
ELSE //1
	FOR ll_row = 1 TO ll_rows //8
		dw_powerfilter.object.check[ll_row] ="0"
		dw_powerfilter.object.checkmonth[ll_row] ="0"
		dw_powerfilter.object.checkyear[ll_row] ="0"
	NEXT //8
END IF //1
RETURN

end event

event losefocus;//losefocus (none) returns long [pbm_bnkillfocus]


PARENT.POST EVENT ue_checkfocus()
PARENT.cb_ok.default = FALSE
RETURN

end event

event getfocus;//getfocus (none) returns long [pbm_bnsetfocus]


PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
PARENT.cb_ok.default = TRUE
RETURN

end event

type dw_powerfilter from datawindow within u_powerfilter_dropdown
event ue_mousemove pbm_dwnmousemove
event ue_dwnkey pbm_dwnkey
integer x = 151
integer y = 448
integer width = 882
integer height = 796
integer taborder = 30
string title = "none"
string dataobject = "d_powerfilter"
boolean vscrollbar = true
boolean livescroll = true
end type

event ue_mousemove;//ue_mousemove (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnmousemove]
//integer xpos
//integer ypos
//long row
//dwobject dwo


IF (((((keydown(keyleftarrow!) OR keydown(keyrightarrow!)) OR keydown(keyuparrow!)) OR keydown(keydownarrow!)) OR keydown(keyspacebar!)) OR keydown(keytab!)) THEN RETURN
setfocus()
setrow(row)
PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
RETURN

end event

event ue_dwnkey;//ue_dwnkey (keycode key,ulong keyflags) returns long [pbm_dwnkey]
//keycode key
//ulong keyflags


IF key = keyuparrow! AND getrow() = 1 THEN //0
	PARENT.cbx_1.setfocus()
END IF //0
IF key = keydownarrow! AND getrow() = rowcount() THEN //2
	PARENT.cb_ok.setfocus()
END IF //2
RETURN

end event

event clicked;//clicked (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnlbuttonclk]
//integer xpos
//integer ypos
//long row
//dwobject dwo
string ls_band
string ls_level
string ls_checked
string ls_setvalue
integer li_tab
integer li_year
integer li_month
boolean ib_partial
long ll_row
long ll_firstrow
long ll_lastrow


ll_row = row
IF  NOT (ll_row > 0) THEN RETURN
IF getitemstring(row,"check") = "1" THEN //2
	setitem(row,"check","0")
ELSE //2
	setitem(row,"check","1")
END IF //2
setrow(row)
if ib_datalistfilter  then RETURN
IF (find("check = '0' or isnull(check)",1,rowcount() + 1)) = 0 THEN //7
	PARENT.cbx_1.checked = TRUE
ELSE //7
	PARENT.cbx_1.checked = FALSE
END IF //7


end event

event constructor;//constructor (none) returns long [pbm_constructor]


setrowfocusindicator(focusrect!)
RETURN

end event

event losefocus;//losefocus (none) returns long [pbm_dwnkillfocus]


PARENT.cb_ok.default = FALSE
PARENT.POST EVENT ue_checkfocus()
RETURN

end event

event getfocus;//getfocus (none) returns long [pbm_dwnsetfocus]


PARENT.iu_powerfilter_monthopts.visible = FALSE
PARENT.iu_powerfilter_predeffilters.visible = FALSE
PARENT.cb_ok.default = TRUE
RETURN

end event

event scrollhorizontal;//scrollhorizontal (long scrollpos,integer pane) returns long [pbm_dwnhscroll]
//long scrollpos
//integer pane


object.datawindow.horizontalscrollposition = 1
RETURN

end event

type dw_buttons from datawindow within u_powerfilter_dropdown
event ue_mousemove pbm_dwnmousemove
event ue_dwnkey pbm_dwnkey
integer x = 5
integer y = 4
integer width = 1051
integer height = 356
integer taborder = 10
string title = "none"
string dataobject = "d_powerfilter_ddbuttons"
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;//ue_mousemove (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnmousemove]
//integer xpos
//integer ypos
//long row
//dwobject dwo


IF ((((keydown(keyleftarrow!) OR keydown(keyrightarrow!)) OR keydown(keyuparrow!)) OR keydown(keydownarrow!)) OR keydown(keytab!)) THEN RETURN
IF row = rowcount() THEN //1
	PARENT.iu_powerfilter_predeffilters.dw_1.setfocus()
	PARENT.iu_powerfilter_predeffilters.visible = TRUE
ELSE //1
	PARENT.iu_powerfilter_monthopts.visible = FALSE
	PARENT.iu_powerfilter_predeffilters.visible = FALSE
	setfocus()
END IF //1
setrow(row)
RETURN

end event

event ue_dwnkey;//ue_dwnkey (keycode key,ulong keyflags) returns long [pbm_dwnkey]
//keycode key
//ulong keyflags
dwobject dwo_column


IF getrow() = rowcount() THEN //0
	CHOOSE CASE key //1
		CASE keydownarrow! //1
			PARENT.cbx_1.setfocus()
		CASE keyrightarrow! //1
			PARENT.iu_powerfilter_predeffilters.dw_1.setfocus()
			PARENT.iu_powerfilter_predeffilters.visible = TRUE
	END CHOOSE //1
END IF //0
IF getrow() = 1 THEN //7
	CHOOSE CASE key //8
		CASE keyuparrow! //8
			PARENT.cb_cancel.setfocus()
	END CHOOSE //8
END IF //7
IF key = keyenter! THEN //11
	dwo_column = THIS.object.buttonname
	POST EVENT clicked(pointerx(),pointery(),getrow(),dwo_column)
END IF //11
RETURN

end event

event clicked;//clicked (integer xpos,integer ypos,long row,dwobject dwo) returns long [pbm_dwnlbuttonclk]
//integer xpos
//integer ypos
//long row
//dwobject dwo
string ls_return
string ls_colname
string ls_powertiptext


IF row > 0 THEN //0
ELSE //0
	RETURN
END IF //0
IF THIS.getitemnumber(row,"Active") = 1 THEN //3
ELSE //3
	RETURN
END IF //3
IF isnull(PARENT.iu_powerfilter_checkbox.is_lookup[PARENT.ii_colnum]) THEN //6
	ls_colname = PARENT.is_colname
ELSE //6
	ls_colname = PARENT.iu_powerfilter_checkbox.is_lookup[PARENT.ii_colnum]
END IF //6
CHOOSE CASE row //10
	CASE rowcount() //10
	CASE rowcount() - 1 //10
		PARENT.is_columnfilter = ""
		ls_powertiptext = PARENT.is_defaulttiptext
		PARENT.iu_powerfilter_checkbox.of_setbuttonpics()
		PARENT.dw_buttons.setitem(PARENT.dw_buttons.rowcount() - 1,"Active",0)
		PARENT.dw_buttons.setitem(PARENT.dw_buttons.rowcount(),"Selected",0)
		PARENT.p_1.visible = FALSE
		PARENT.iu_powerfilter_predeffilters.of_flagrow(0)
		PARENT.iu_powerfilter_monthopts.of_flagrow(0)
		PARENT.cbx_1.checked = TRUE
		PARENT.iu_powerfilter_checkbox.of_buildfilter(PARENT.is_columnfilter,PARENT.ii_colnum)
		PARENT.of_close()
		PARENT.of_savestate()
	CASE 1 //10
		IF PARENT.iu_powerfilter_checkbox.maintaingroups THEN //26
			PARENT.idw_dw.setredraw(FALSE)
			PARENT.idw_dw.setsort(PARENT.iu_powerfilter_checkbox.is_originalsort + "," + ls_colname)
			PARENT.idw_dw.sort()
			PARENT.idw_dw.groupcalc()
			PARENT.idw_dw.setredraw(TRUE)
		ELSE //26
			PARENT.idw_dw.setsort(ls_colname)
			PARENT.idw_dw.sort()
		END IF //26
		PARENT.iu_powerfilter_checkbox.of_setbuttonpics()
		PARENT.of_close()
	CASE 2 //10
		IF PARENT.iu_powerfilter_checkbox.maintaingroups THEN //38
			PARENT.idw_dw.setredraw(FALSE)
			PARENT.idw_dw.setsort(PARENT.iu_powerfilter_checkbox.is_originalsort + "," + ls_colname + " Desc")
			PARENT.idw_dw.sort()
			PARENT.idw_dw.groupcalc()
			PARENT.idw_dw.setredraw(TRUE)
		ELSE //38
			PARENT.idw_dw.setsort(ls_colname + " Desc")
			PARENT.idw_dw.sort()
		END IF //38
		PARENT.iu_powerfilter_checkbox.of_setbuttonpics()
		PARENT.of_close()
END CHOOSE //10
RETURN

end event

event losefocus;//losefocus (none) returns long [pbm_dwnkillfocus]


object.rr_1.visible = FALSE
PARENT.POST EVENT ue_checkfocus()
RETURN

end event

event scrollhorizontal;//scrollhorizontal (long scrollpos,integer pane) returns long [pbm_dwnhscroll]
//long scrollpos
//integer pane


object.datawindow.horizontalscrollposition = 1
RETURN

end event

event getfocus;//getfocus (none) returns long [pbm_dwnsetfocus]


object.rr_1.visible = "0~tif(getrow() = currentRow(),1,0)"
PARENT.cb_ok.default = FALSE
RETURN

end event

type ln_1 from line within u_powerfilter_dropdown
long linecolor = 134217744
integer linethickness = 4
integer beginx = 123
integer beginy = 340
integer endx = 123
integer endy = 1404
end type

type shl_msg from statichyperlink within u_powerfilter_dropdown
boolean visible = false
integer x = 155
integer y = 1172
integer width = 873
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
alignment alignment = center!
boolean focusrectangle = false
string url = "www.PowerToTheBuilder.com"
end type

type sle_filter from singlelineedit within u_powerfilter_dropdown
event ue_change pbm_enchange
event ue_mousemove pbm_mousemove
integer x = 677
integer y = 364
integer width = 357
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

event ue_change;cbx_1.checked = false
if len(text)  = 0 then
	dw_powerfilter.setfilter( "")
	ib_datalistfilter = false
else
	dw_powerfilter.setfilter( 'item like "%'+text+'%"')
	ib_datalistfilter = true
end if

dw_powerfilter.filter( )

end event

event ue_mousemove;//IF (((((keydown(keyleftarrow!) OR keydown(keyrightarrow!)) OR keydown(keyuparrow!)) OR keydown(keydownarrow!)) OR keydown(keyspacebar!)) OR keydown(keytab!)) THEN RETURN
//PARENT.iu_powerfilter_monthopts.visible = FALSE
//PARENT.iu_powerfilter_predeffilters.visible = FALSE
//
end event

event getfocus;if cbx_1.checked then
	cbx_1.checked = false
	cbx_1.event clicked()
end if
end event

