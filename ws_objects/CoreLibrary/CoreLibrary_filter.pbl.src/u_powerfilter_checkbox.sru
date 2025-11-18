$PBExportHeader$u_powerfilter_checkbox.sru
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type u_powerfilter_checkbox from checkbox
end type
end forward

global type u_powerfilter_checkbox from checkbox
string tag = "//MULTILANG Filter"
integer width = 206
integer height = 60
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filter"
event type integer ue_positionbuttons ( )
event ue_buttonclicked ( string dwotype,  string dwoname )
event type integer ue_postfilter ( )
end type
global u_powerfilter_checkbox u_powerfilter_checkbox

type prototypes
PUBLIC FUNCTION Long SetParent(Long lChild, Long lParent) LIBRARY "user32.dll"
end prototypes

type variables
integer maxitems=10000
integer buttonheight=76
integer buttonwidth=87
integer buttonxoffset
integer buttonyoffset
integer dropdownxoffset
integer dropdownyoffset
boolean maintainoriginalfilter=TRUE
boolean maintaingroups
boolean promptusertorestore
boolean restoreoriginalsort=TRUE
boolean restoreoriginalfilter=TRUE
boolean allowquicksort=TRUE
string defaulttiptext="(Showing All)"
boolean bubblestyle=FALSE
boolean keepnewrows=FALSE
n_cst_powerfilter iu_powerfilter

end variables

forward prototypes
Public function integer  of_buildfilter (string as_columnfilter,integer ai_columnnumber)
public function integer of_setdw (datawindow a_dw)
Public function integer  of_getparentwindow (ref window aw_parent)
Public function integer  of_setbuttonpics ()
Public function string  of_createbutton (integer ai_colnum,string as_title,string as_colname)
Public function integer  of_settitles (string as_titles[])
Public function integer  of_setcolumns (string as_columns[])
Public function integer  of_getcolumns ()
Public function integer  of_cleantitle (ref string as_title)
Public function integer  of_replace (ref string as_string,string as_old,string as_new)
Public function integer  of_getoriginalfilter (ref string as_originalfilter)
Public function integer  of_setdropdownoffset (integer ai_xoffset,integer ai_yoffset)
Public function integer  of_getdropdownoffset (ref integer ai_xoffset,ref integer ai_yoffset)
Public function integer  of_setoriginalsort ()
Public function integer  of_setoriginalfilter ()
Public function integer  of_getfields ()
Public function integer  of_setlanguage (integer ai_languagenumber)
Public function integer  of_quickfilter (string as_colname,any aa_item)
Public function integer  of_setparentwindow (window aw_parent)
end prototypes

event ue_positionbuttons;//ue_positionbuttons (none) returns integer 


RETURN iu_powerfilter.EVENT ue_positionbuttons()

end event

event ue_buttonclicked;//ue_buttonclicked (string dwotype,string dwoname) returns (none)
//string dwotype
//string dwoname


iu_powerfilter.EVENT ue_buttonclicked(dwotype,dwoname)

end event

event ue_postfilter;//ue_postfilter (none) returns integer 


RETURN iu_powerfilter.EVENT ue_postfilter()

end event

Public function integer  of_buildfilter (string as_columnfilter,integer ai_columnnumber);//Public function of_buildfilter (string as_columnfilter,integer ai_columnnumber) returns integer 
//string as_columnfilter
//integer ai_columnnumber


RETURN iu_powerfilter.of_buildfilter(as_columnfilter,ai_columnnumber)

end function

public function integer of_setdw (datawindow a_dw);//Public function of_setdw (datawindow a_dw) returns integer 
//datawindow a_dw
iu_powerfilter.of_setdw(a_dw)
//SetParent(handle(this),handle(a_dw))
RETURN 0

end function

Public function integer  of_getparentwindow (ref window aw_parent);//Public function of_getparentwindow (ref window aw_parent) returns integer 
//window aw_parent


RETURN iu_powerfilter.of_getparentwindow(aw_parent)

end function

Public function integer  of_setbuttonpics ();//Public function of_setbuttonpics (none) returns integer 


RETURN iu_powerfilter.of_setbuttonpics()

end function

Public function string  of_createbutton (integer ai_colnum,string as_title,string as_colname);//Public function of_createbutton (integer ai_colnum,string as_title,string as_colname) returns string 
//integer ai_colnum
//string as_title
//string as_colname


RETURN iu_powerfilter.of_createbutton(ai_colnum,as_title,as_colname)

end function

Public function integer  of_settitles (string as_titles[]);//Public function of_settitles (string as_titles[]) returns integer 
//string as_titles[]


RETURN iu_powerfilter.of_settitles(as_titles)

end function

Public function integer  of_setcolumns (string as_columns[]);//Public function of_setcolumns (string as_columns[]) returns integer 
//string as_columns[]


RETURN iu_powerfilter.of_setcolumns(as_columns)

end function

Public function integer  of_getcolumns ();//Public function of_getcolumns (none) returns integer 


RETURN iu_powerfilter.of_getcolumns()

end function

Public function integer  of_cleantitle (ref string as_title);//Public function of_cleantitle (ref string as_title) returns integer 
//string as_title


RETURN iu_powerfilter.of_cleantitle(as_title)

end function

Public function integer  of_replace (ref string as_string,string as_old,string as_new);//Public function of_replace (ref string as_string,string as_old,string as_new) returns integer 
//string as_string
//string as_old
//string as_new


RETURN iu_powerfilter.of_replace(as_string,as_old,as_new)

end function

Public function integer  of_getoriginalfilter (ref string as_originalfilter);//Public function of_getoriginalfilter (ref string as_originalfilter) returns integer 
//string as_originalfilter


RETURN iu_powerfilter.of_getoriginalfilter(as_originalfilter)

end function

Public function integer  of_setdropdownoffset (integer ai_xoffset,integer ai_yoffset);//Public function of_setdropdownoffset (integer ai_xoffset,integer ai_yoffset) returns integer 
//integer ai_xoffset
//integer ai_yoffset


RETURN iu_powerfilter.of_setdropdownoffset(ai_xoffset,ai_yoffset)

end function

Public function integer  of_getdropdownoffset (ref integer ai_xoffset,ref integer ai_yoffset);//Public function of_getdropdownoffset (ref integer ai_xoffset,ref integer ai_yoffset) returns integer 
//integer ai_xoffset
//integer ai_yoffset


RETURN iu_powerfilter.of_getdropdownoffset(ai_xoffset,ai_yoffset)

end function

Public function integer  of_setoriginalsort ();//Public function of_setoriginalsort (none) returns integer 


RETURN iu_powerfilter.of_setoriginalsort()

end function

Public function integer  of_setoriginalfilter ();//Public function of_setoriginalfilter (none) returns integer 


RETURN iu_powerfilter.of_setoriginalfilter()

end function

Public function integer  of_getfields ();//Public function of_getfields (none) returns integer 


RETURN iu_powerfilter.of_getfields()

end function

Public function integer  of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
datastore lds_lang


lds_lang = CREATE datastore
lds_lang.dataobject = "d_powerfilter_languages"
THIS.text = lds_lang.getitemstring(76,ai_languagenumber + 2)
DESTROY lds_lang
RETURN iu_powerfilter.of_setlanguage(ai_languagenumber)

end function

Public function integer  of_quickfilter (string as_colname,any aa_item);//Public function of_quickfilter (string as_colname,any aa_item) returns integer 
//string as_colname
//any aa_item


RETURN iu_powerfilter.of_quickfilter(as_colname,aa_item)

end function

Public function integer  of_setparentwindow (window aw_parent);//Public function of_setparentwindow (window aw_parent) returns integer 
//window aw_parent


RETURN iu_powerfilter.of_setparentwindow(aw_parent)

end function

on u_powerfilter_checkbox.create
end on

on u_powerfilter_checkbox.destroy
end on

event clicked;//clicked (none) returns long [pbm_bnclicked]


THIS.iu_powerfilter.checked = THIS.checked
RETURN iu_powerfilter.EVENT ue_clicked()

end event

event constructor;//constructor (none) returns long [pbm_constructor]


THIS.iu_powerfilter = CREATE n_cst_powerfilter
THIS.iu_powerfilter.maxitems = THIS.maxitems
THIS.iu_powerfilter.buttonheight = THIS.buttonheight
THIS.iu_powerfilter.buttonwidth = THIS.buttonwidth
THIS.iu_powerfilter.buttonxoffset = THIS.buttonxoffset
THIS.iu_powerfilter.buttonyoffset = THIS.buttonyoffset
THIS.iu_powerfilter.dropdownxoffset = THIS.dropdownxoffset
THIS.iu_powerfilter.dropdownyoffset = THIS.dropdownyoffset
THIS.iu_powerfilter.maintainoriginalfilter = THIS.maintainoriginalfilter
THIS.iu_powerfilter.promptusertorestore = THIS.promptusertorestore
THIS.iu_powerfilter.restoreoriginalsort = THIS.restoreoriginalsort
THIS.iu_powerfilter.restoreoriginalfilter = THIS.restoreoriginalfilter
THIS.iu_powerfilter.allowquicksort = THIS.allowquicksort
THIS.iu_powerfilter.defaulttiptext = THIS.defaulttiptext
THIS.iu_powerfilter.bubblestyle = THIS.bubblestyle
THIS.iu_powerfilter.keepnewrows = THIS.keepnewrows
RETURN

end event

