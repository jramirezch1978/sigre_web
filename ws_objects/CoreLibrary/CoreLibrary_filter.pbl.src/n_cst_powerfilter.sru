$PBExportHeader$n_cst_powerfilter.sru
$PBExportComments$Export By Shu<KenShu@163.net>
forward
global type n_cst_powerfilter from nonvisualobject
end type
end forward

global type n_cst_powerfilter from nonvisualobject
event type integer ue_positionbuttons ( )
event ue_buttonclicked ( string dwotype,  string dwoname )
event type long ue_clicked ( )
event type integer ue_postfilter ( )
end type
global n_cst_powerfilter n_cst_powerfilter

type variables
string is_columnfilter[]
string is_originalfilter
string is_previewbuttons
integer ii_maxcol
integer ii_language=2
boolean ib_customcolumns
boolean ib_customtitles
boolean ib_freeform
integer maxitems=10000
integer buttonheight=64
integer buttonwidth=73
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
string backgroundcolor="Link"
datawindow idw_dw
window iw_parent
string is_colname[]
string is_title[]
string is_coltype[]
string is_lookup[]
u_powerfilter_dropdown iu_powerfilter_dropdown
u_powerfilter_predeffilters iu_powerfilter_predeffilters
u_powerfilter_monthopts iu_powerfilter_monthopts
boolean checked
boolean ib_visible=false
decimal idec_unitxfactor
decimal idec_unityfactor
string is_dwunits
string is_originalsort
long silver=12632256
long buttonface=67108864
long scrollbar=134217728
long desktop=134217729
long activetitlebar=134217730
long inactivetitlebar=134217731
long menubar=134217732
long windowframe=134217734
long activeborder=134217738
long inactiveborder=134217739
long highlight=134217741
long buttonshadow=134217744
long buttonhighlight=134217748
long buttondarkshadow=134217749
long buttonlightshadow=134217750
long tooltip=134217752
long link=134217856
long linkhover=134217857
long linkactive=134217858
long linkvisited=134217859
long applicationworkspace=268435456
long windowbackground=1073741824
boolean ib_testnew=TRUE

end variables

forward prototypes
Public function integer  of_buildfilter (string as_columnfilter,integer ai_columnnumber)
public function integer of_setbuttonpics ()
Public function integer  of_cleantitle (ref string as_title)
Public function integer  of_replace (ref string as_string,string as_old,string as_new)
Public function string  of_createbutton (integer ai_colnum,string as_title,string as_colname)
Public function integer  of_getcolumns ()
Public function integer  of_getdropdownoffset (ref integer ai_xoffset,ref integer ai_yoffset)
Public function integer  of_getfields ()
Public function integer  of_getoriginalfilter (ref string as_originalfilter)
Public function integer  of_getparentwindow (ref window aw_parent)
Public function integer  of_quickfilter (string as_colname,any aa_item)
Public function integer  of_setcolumns (string as_columns[])
Public function integer  of_setdropdownoffset (integer ai_xoffset,integer ai_yoffset)
Public function integer  of_setdw (datawindow a_dw)
Public function integer  of_setoriginalfilter ()
Public function integer  of_setoriginalsort ()
Public function integer  of_setlanguage (integer ai_languagenumber)
Public function integer  of_settitles (string as_titles[])
Protected function boolean  of_usedisplayvalue (string as_colname)
Public function string  of_createcomputedfield (string as_colname,integer ai_colnum)
Public function integer  of_getframe (ref window aw_parent)
Public function integer  of_filter (string as_filter)
Public function integer  of_setparentwindow (window aw_parent)
Public function long  of_setbackgroundcolor (string as_color)
end prototypes

event ue_positionbuttons;//ue_positionbuttons (none) returns integer 
string ls_mod
string ls_colname
string ls_visible
integer li_x
integer li_colwidth
integer li_colnum
integer li_visible
integer li_width
long ll_xpos


IF  NOT (THIS.checked) THEN RETURN 0
IF isvalid(THIS.iu_powerfilter_dropdown) THEN //1
	IF THIS.iu_powerfilter_dropdown.visible THEN //2
		THIS.iu_powerfilter_monthopts.visible = FALSE
		THIS.iu_powerfilter_predeffilters.visible = FALSE
		THIS.iu_powerfilter_dropdown.visible = FALSE
	END IF //2
END IF //1
FOR li_colnum = 1 TO THIS.ii_maxcol //6
	ls_colname = THIS.is_colname[li_colnum]
	li_x = integer(idw_dw.describe(ls_colname + ".x"))
	li_colwidth = integer(idw_dw.describe(ls_colname + ".width"))
	li_x = li_x + THIS.buttonxoffset * THIS.idec_unitxfactor
	IF li_colwidth = 0 THEN //11
		ls_mod = ls_mod + " " + "b_powerfilter" + string(li_colnum) + ".visible='0'"
	ELSE //11
		ls_visible = idw_dw.describe(ls_colname + ".visible")
		IF mid(ls_visible,1,1) = "~"" THEN //15
			ls_visible = mid(ls_visible,2,len(ls_visible) - 2)
			of_replace(ls_visible,"'","~~'")
		END IF //15
		ls_mod = ls_mod + " " + "b_powerfilter" + string(li_colnum) + ".visible='" + ls_visible + "'"
	END IF //11
	IF THIS.ib_freeform THEN //19
		ll_xpos = li_x + li_colwidth
		li_width = THIS.buttonwidth
	ELSE //19
		IF li_colwidth >= (THIS.buttonwidth * THIS.idec_unitxfactor) THEN //23
			ll_xpos = li_x + li_colwidth - THIS.buttonwidth * THIS.idec_unitxfactor
			li_width = THIS.buttonwidth * THIS.idec_unitxfactor
		ELSE //23
			ll_xpos = li_x
			li_width = li_colwidth
		END IF //23
	END IF //19
	IF (long(idw_dw.describe("b_powerfilter" + string(li_colnum) + ".x"))) <> ll_xpos THEN //29
		ls_mod = ls_mod + " " + "b_powerfilter" + string(li_colnum) + ".x='" + string(ll_xpos) + "'"
	END IF //29
	IF (integer(idw_dw.describe("b_powerfilter" + string(li_colnum) + ".width"))) <> li_width THEN //31
		ls_mod = ls_mod + " " + "b_powerfilter" + string(li_colnum) + ".width='" + string(li_width) + "'"
	END IF //31
NEXT //6
IF len(ls_mod) > 0 THEN //34
	idw_dw.modify(ls_mod)
END IF //34
RETURN 0

end event

event ue_buttonclicked;//ue_buttonclicked (string dwotype,string dwoname) returns (none)
//string dwotype
//string dwoname
integer li_colnum


IF dwotype = "button" AND left(string(dwoname),13) = "b_powerfilter" THEN //0
	li_colnum = integer(mid(string(dwoname),14))
ELSE //0
	EVENT ue_positionbuttons()
	RETURN
END IF //0
IF THIS.iu_powerfilter_dropdown.visible THEN //5
	iu_powerfilter_dropdown.of_close()
	EVENT ue_positionbuttons()
ELSE //5
	EVENT ue_positionbuttons()
	iu_powerfilter_dropdown.of_open(li_colnum,THIS.is_colname[li_colnum],THIS.is_title[li_colnum],THIS.is_coltype[li_colnum],THIS.is_columnfilter[li_colnum])
END IF //5

end event

event type long ue_clicked();//ue_clicked (none) returns long 
string 	ls_objects, ls_object, ls_colname, ls_coltype, ls_band, ls_return, ls_title, ls_null, &
			ls_rtn, ls_x, ls_modstring, ls_currentfilter, ls_currentsort, ls_s, ls_t
			
Long		ll_start, ll_end, ll_tab, ll_length, ll_row, ll_column

integer	li_i, li_bandnumber, li_colnum

s_powerfilter_restore_parms lstr_restore
n_cst_powerfilter l_powerfilter


l_powerfilter = THIS
setnull(ls_null)
IF  NOT (isvalid(THIS.iw_parent)) THEN //2
	of_getparentwindow(THIS.iw_parent)
	IF iw_parent.workspaceheight() < 2080 THEN //4
		of_getframe(THIS.iw_parent)
	END IF //4
END IF //2
ls_currentfilter = idw_dw.describe("DataWindow.Table.Filter")
ls_currentsort = idw_dw.describe("DataWindow.Table.Sort")
IF ls_currentsort = "?" THEN ls_currentsort = ""
IF ls_currentfilter = "?" THEN //9
	ls_currentfilter = ""
ELSE //9
	of_replace(ls_currentfilter,"~~","")
END IF //9
ls_x = "Bd eav rcevsdeYRa esit hogEiqRn cltlyAa~nr~rgeaste eRRt l.mRm rs ermTacJt a031B062l"
ls_s = "BnNooiws riesV  tnhoei tTaiumlea vfEo rr0eatllli FgroeOwdo Pm"
IF  NOT (THIS.checked) AND THIS.promptusertorestore THEN //15
	IF THIS.is_originalfilter = ls_currentfilter AND THIS.is_originalsort = ls_currentsort THEN //16
	ELSE //16
		openwithparm(w_powerfilter_prompt_to_restore,THIS.ii_language,THIS.iw_parent)
		lstr_restore = message.powerobjectparm
		idw_dw.setfocus()
		IF lstr_restore.buttonpressed THEN //21
			THIS.restoreoriginalfilter = lstr_restore.restorefilter
			THIS.restoreoriginalsort = lstr_restore.restoresort
		ELSE //21
			THIS.checked = TRUE
			RETURN -1
		END IF //21
	END IF //16
END IF //15
IF  NOT (THIS.ib_customcolumns) THEN //27
	of_getcolumns()
END IF //27
FOR li_colnum = 1 TO THIS.ii_maxcol //29
	IF THIS.checked THEN //30
		ls_modstring = ls_modstring + " " + of_createbutton(li_colnum,THIS.is_title[li_colnum],THIS.is_colname[li_colnum])
		CONTINUE
	END IF //30
	ls_modstring = ls_modstring + " " + "destroy b_powerfilter" + string(li_colnum)
	THIS.is_columnfilter[li_colnum] = ""
NEXT //29
ls_return = idw_dw.modify(ls_modstring)
IF THIS.checked THEN //37
	THIS.iw_parent.DYNAMIC openuserobject(THIS.iu_powerfilter_dropdown,"u_powerfilter_dropdown")
	iu_powerfilter_dropdown.of_initialize(THIS.idw_dw,l_powerfilter,THIS.maxitems,THIS.ii_maxcol,THIS.allowquicksort,THIS.defaulttiptext)
	iu_powerfilter_dropdown.of_setlanguage(THIS.ii_language)
	ls_x = ls_x + " m©s  trheg irrrytplomCr~nr~rn~ni~r mNoecq.nrcetdylaieuiB erhHTeo Thr eowtoePf. w"
	THIS.iw_parent.DYNAMIC openuserobject(THIS.iu_powerfilter_predeffilters,"u_powerfilter_predeffilters")
	iu_powerfilter_predeffilters.of_initialize(THIS.idw_dw,l_powerfilter,THIS.ii_maxcol)
	iu_powerfilter_predeffilters.of_setlanguage(THIS.ii_language)
	ls_x = ls_x + "iwiwK staiesuiovp o, neori tiaemuraoefin io serswnye ceiule  rao Fv~rr~ne~rr ~n.e"
	THIS.iw_parent.DYNAMIC openuserobject(THIS.iu_powerfilter_monthopts,"u_powerfilter_monthopts")
	iu_powerfilter_monthopts.of_initialize(THIS.idw_dw,l_powerfilter,THIS.ii_maxcol)
	iu_powerfilter_monthopts.of_setlanguage(THIS.ii_language)
	ls_x = ls_x + "eqsnuc tnyoaietic uedaotr pr trlom m,rn ori tcutbai rrttslimdse rr e, erlratsl mrro f"
	iu_powerfilter_dropdown.of_setpredef(THIS.iu_powerfilter_predeffilters,THIS.iu_powerfilter_monthopts)
	ls_x = ls_x + "e sduendtnie tineiq ntcotny aseii  trId n~rr.oytlenfo  isieessoaperuuopp on oeirt "
	iu_powerfilter_predeffilters.of_setdropdown(THIS.iu_powerfilter_dropdown)
	iu_powerfilter_predeffilters.of_setmonthopts(THIS.iu_powerfilter_monthopts)
	ls_x = ls_x + "aiueluaaveei  roosfr wsyi  eeurea wat fcovsd yraeetil ioFerqenwcotPy aseiih T"
	iu_powerfilter_monthopts.of_setdropdown(THIS.iu_powerfilter_dropdown)
	iu_powerfilter_monthopts.of_setpredef(THIS.iu_powerfilter_predeffilters)
	FOR li_i = len(ls_x) TO 1 STEP  -2 //57
		ls_rtn = ls_rtn + mid(ls_x,li_i,1)
	NEXT //57
	FOR li_colnum = 1 TO THIS.ii_maxcol //60
		IF of_usedisplayvalue(THIS.is_colname[li_colnum]) THEN //61
			THIS.is_lookup[li_colnum] = of_createcomputedfield(THIS.is_colname[li_colnum],li_colnum)
			CONTINUE
		END IF //61
		THIS.is_lookup[li_colnum] = ls_null
	NEXT //60
	
	FOR li_i = len(ls_s) - 1 TO 1 STEP  -2 //66
		ls_t = ls_t + mid(ls_s,li_i,1)
	NEXT //66
	of_setbuttonpics()
	EVENT ue_positionbuttons()
	IF THIS.ib_visible THEN messagebox(ls_t,ls_rtn)
	THIS.is_previewbuttons = THIS.idw_dw.object.datawindow.print.preview.buttons
	IF upper(THIS.idw_dw.object.datawindow.print.preview) = "YES" THEN //73
		ll_row = idw_dw.getrow()
		ll_column = idw_dw.getcolumn()
		idw_dw.object.datawindow.print.preview.buttons = "Yes"
		idw_dw.setrow(ll_row)
		idw_dw.setcolumn(ll_column)
	END IF //73
ELSE //37
	IF isvalid(THIS.iu_powerfilter_dropdown) THEN iu_powerfilter_dropdown.of_close()
	THIS.iw_parent.DYNAMIC closeuserobject(THIS.iu_powerfilter_dropdown)
	THIS.iw_parent.DYNAMIC closeuserobject(THIS.iu_powerfilter_predeffilters)
	THIS.iw_parent.DYNAMIC closeuserobject(THIS.iu_powerfilter_monthopts)
	ls_modstring = ""
	FOR li_colnum = 1 TO THIS.ii_maxcol //85
		if UpperBound(is_lookup)< li_colnum then exit
		IF  NOT (isnull(THIS.is_lookup[li_colnum])) THEN //86
			ls_modstring = ls_modstring + " " + "destroy " + THIS.is_lookup[li_colnum]
		END IF //86
	NEXT //85
	ls_return = idw_dw.modify(ls_modstring)
	idw_dw.setredraw(FALSE)
	IF THIS.is_originalsort = ls_currentsort AND THIS.is_originalfilter = ls_currentfilter THEN //91
	ELSE //91
		IF THIS.restoreoriginalfilter THEN //93
			IF THIS.is_originalfilter = ls_currentfilter THEN //94
			ELSE //94
				IF THIS.is_originalfilter = "?" THEN THIS.is_originalfilter = ""
				of_filter(THIS.is_originalfilter)
			END IF //94
		END IF //93
		IF THIS.restoreoriginalsort THEN //98
			IF THIS.is_originalsort <> "" THEN //99
				idw_dw.setsort(THIS.is_originalsort)
				idw_dw.sort()
			ELSE //99
				THIS.is_originalsort = ls_currentsort
			END IF //99
		END IF //98
	END IF //91
	IF upper(THIS.idw_dw.object.datawindow.print.preview) = "YES" THEN //104
		ll_row = idw_dw.getrow()
		ll_column = idw_dw.getcolumn()
		idw_dw.object.datawindow.print.preview.buttons = THIS.is_previewbuttons
		idw_dw.setrow(ll_row)
		idw_dw.setcolumn(ll_column)
	END IF //104
	idw_dw.setredraw(TRUE)
END IF //37
RETURN 0

end event

event type integer ue_postfilter();//ue_postfilter (none) returns integer 
idw_dw.Groupcalc( )

RETURN 1

end event

Public function integer  of_buildfilter (string as_columnfilter,integer ai_columnnumber);//Public function of_buildfilter (string as_columnfilter,integer ai_columnnumber) returns integer 
//string as_columnfilter
//integer ai_columnnumber
integer li_colnum
string ls_masterfilter


IF ai_columnnumber > 0 THEN THIS.is_columnfilter[ai_columnnumber] = as_columnfilter
ls_masterfilter = ""
FOR li_colnum = 1 TO THIS.ii_maxcol //2
	IF len(THIS.is_columnfilter[li_colnum]) > 0 THEN //3
		IF len(ls_masterfilter) > 0 THEN //4
			ls_masterfilter = ls_masterfilter + " AND "
		END IF //4
		ls_masterfilter = ls_masterfilter + THIS.is_columnfilter[li_colnum]
	END IF //3
NEXT //2
IF THIS.maintainoriginalfilter AND len(THIS.is_originalfilter) > 0 THEN //8
	IF len(ls_masterfilter) > 0 THEN //9
		ls_masterfilter = "(" + ls_masterfilter + ") AND (" + THIS.is_originalfilter + ")"
	ELSE //9
		ls_masterfilter = THIS.is_originalfilter
	END IF //9
END IF //8
IF len(ls_masterfilter) > 0 AND THIS.keepnewrows THEN //13
	ls_masterfilter = "(" + ls_masterfilter + ") OR ( IsRowNew() AND NOT IsRowModified() )"
END IF //13
idw_dw.setredraw(FALSE)
of_filter(ls_masterfilter)
of_setbuttonpics()
idw_dw.setredraw(TRUE)
POST EVENT ue_postfilter()
RETURN 0

end function

public function integer of_setbuttonpics ();//Public function of_setbuttonpics (none) returns integer 
integer li_colnum
string ls_sort
string ls_pic
string ls_return
string ls_colname
boolean lb_filtered
boolean lb_sortedup
boolean lb_sorteddown


IF THIS.allowquicksort THEN //0
	ls_sort = lower(idw_dw.describe("DataWindow.Table.Sort"))
END IF //0
FOR li_colnum = 1 TO THIS.ii_maxcol //2
	IF len(THIS.is_columnfilter[li_colnum]) > 0 THEN //3
		lb_filtered = TRUE
	ELSE //3
		lb_filtered = FALSE
	END IF //3
	IF isnull(THIS.is_lookup[li_colnum]) THEN //7
		ls_colname = THIS.is_colname[li_colnum]
	ELSE //7
		ls_colname = THIS.is_lookup[li_colnum]
	END IF //7
	lb_sorteddown = match("," + ls_sort,"," + lower(ls_colname + " d"))
	lb_sortedup = match("," + ls_sort,"," + lower(ls_colname + " a"))
	CHOOSE CASE TRUE //13
		CASE lb_filtered AND  NOT (lb_sortedup) AND  NOT (lb_sorteddown) //13
			ls_pic = "C:\SIGRE\CoreLibrary\imagenes\PF_Filtered_PF6.bmp"
		CASE lb_filtered AND  NOT (lb_sorteddown) AND lb_sortedup //13
			ls_pic = "C:\SIGRE\CoreLibrary\imagenes\PF_FilteredUp_PF6.bmp"
		CASE lb_filtered AND lb_sorteddown //13
			ls_pic = "C:\SIGRE\CoreLibrary\imagenes\PF_FilteredDown_PF6.bmp"
		CASE NOT (lb_filtered) AND  NOT (lb_sortedup) AND  NOT (lb_sorteddown) //13
			ls_pic = "C:\SIGRE\CoreLibrary\imagenes\PF_DownArrow_PF6.bmp"
		CASE NOT (lb_filtered) AND  NOT (lb_sorteddown) AND lb_sortedup //13
			ls_pic = "C:\SIGRE\CoreLibrary\imagenes\PF_SortedUp_PF6.bmp"
		CASE NOT (lb_filtered) AND lb_sorteddown //13
			ls_pic = "C:\SIGRE\CoreLibrary\imagenes\PF_SortedDown_PF6.bmp"
	END CHOOSE //13
	ls_return = idw_dw.modify("b_powerfilter" + string(li_colnum) + ".FileName='" + ls_pic + "'")
NEXT //2
RETURN 0

end function

Public function integer  of_cleantitle (ref string as_title);//Public function of_cleantitle (ref string as_title) returns integer 
//string as_title


of_replace(as_title,"~r~n"," ")
of_replace(as_title,"~""," ")
as_title = trim(as_title)
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

Public function string  of_createbutton (integer ai_colnum,string as_title,string as_colname);//Public function of_createbutton (integer ai_colnum,string as_title,string as_colname) returns string 
//integer ai_colnum
//string as_title
//string as_colname
integer li_ypos
integer li_x
integer li_colwidth
integer li_width
integer li_height
long ll_xpos
string ls_modstring
string ls_bubblestyle
string ls_visible


li_height = THIS.buttonheight * THIS.idec_unityfactor
li_ypos = integer(idw_dw.describe("DataWindow.Header.Height")) - li_height
li_x = integer(idw_dw.describe(as_colname + ".x"))
li_colwidth = integer(idw_dw.describe(as_colname + ".width"))
ls_visible = idw_dw.describe(as_colname + ".Visible")
li_x = li_x + THIS.buttonxoffset * THIS.idec_unitxfactor
IF li_colwidth >= (THIS.buttonwidth * THIS.idec_unitxfactor) THEN //6
	ll_xpos = li_x + li_colwidth - THIS.buttonwidth * THIS.idec_unitxfactor
	li_width = THIS.buttonwidth * THIS.idec_unitxfactor
ELSE //6
	ll_xpos = li_x
	li_width = li_colwidth
END IF //6
li_ypos = li_ypos + THIS.buttonyoffset * THIS.idec_unityfactor
IF li_ypos <= 0 THEN //13
	li_ypos = 1
	li_height = integer(idw_dw.describe("DataWindow.Header.Height"))
END IF //13
IF THIS.bubblestyle THEN //16
	ls_bubblestyle = "1"
ELSE //16
	ls_bubblestyle = "0"
END IF //16
IF mid(ls_visible,1,1) = "~"" THEN //20
	ls_visible = mid(ls_visible,2,len(ls_visible) - 2)
	of_replace(ls_visible,"'","~~'")
END IF //20
ls_modstring = "create button(band=Foreground text='' filename='PF_DownArrow_PF.bmp' suppresseventprocessing=yes enabled=yes action='0' border='0' color='33554432' " + "x='" + string(ll_xpos) + "' " + "y='" + string(li_ypos) + "' " + "height='" + string(li_height) + "' width='" + string(li_width) + "' " + "vtextalign='0' htextalign='0' " + "name=" + "b_powerfilter" + string(ai_colnum) + " visible='" + ls_visible + "'" + "font.face='Tahoma' font.height='-10' font.weight='400'  font.family='2' font.pitch='2' font.charset='0' " + "background.mode='2' background.color='67108864' )"
RETURN ls_modstring

end function

Public function integer  of_getcolumns ();//Public function of_getcolumns (none) returns integer 
string ls_objects
string ls_object
string ls_band
string ls_colname
string ls_title
string ls_coltype
long ll_start
long ll_end
long ll_tab
long ll_length
integer li_colnum
integer li_start_pos


ls_objects = idw_dw.describe("DataWindow.Objects")
ll_start = 1
ll_end = len(ls_objects)
DO WHILE ll_start < ll_end //3
	ll_tab = pos(ls_objects,"~t",ll_start)
	IF ll_tab = 0 THEN //5
		ll_tab = ll_end + 1
	END IF //5
	ll_length = ll_tab - ll_start
	ls_object = mid(ls_objects,ll_start,ll_length)
	ls_band = idw_dw.describe(ls_object + ".Band")
	IF upper(ls_band) = "HEADER" AND upper(right(ls_object,2)) = "_T" THEN //10
		li_colnum ++
		ls_colname = left(ls_object,len(ls_object) - 2)
		ls_coltype = lower(left(idw_dw.describe(ls_colname + ".Coltype"),5))
		THIS.is_colname[li_colnum] = ls_colname
		IF  NOT (THIS.ib_customtitles) THEN //15
			ls_title = idw_dw.describe(ls_object + ".text")
			of_cleantitle(ls_title)
			THIS.is_title[li_colnum] = ls_title
		END IF //15
		THIS.is_coltype[li_colnum] = ls_coltype
		THIS.is_columnfilter[li_colnum] = ""
	END IF //10
	ll_start = ll_tab + 1
LOOP //3
THIS.ii_maxcol = li_colnum
RETURN 0

end function

Public function integer  of_getdropdownoffset (ref integer ai_xoffset,ref integer ai_yoffset);//Public function of_getdropdownoffset (ref integer ai_xoffset,ref integer ai_yoffset) returns integer 
//integer ai_xoffset
//integer ai_yoffset


ai_xoffset = THIS.dropdownxoffset
ai_yoffset = THIS.dropdownyoffset
RETURN 0

end function

Public function integer  of_getfields ();//Public function of_getfields (none) returns integer 
string ls_objects
string ls_object
string ls_band
string ls_colname
string ls_title
string ls_coltype
long ll_start
long ll_end
long ll_tab
long ll_length
integer li_colnum
integer li_start_pos


ls_objects = idw_dw.describe("DataWindow.Objects")
ll_start = 1
ll_end = len(ls_objects)
DO WHILE ll_start < ll_end //3
	ll_tab = pos(ls_objects,"~t",ll_start)
	IF ll_tab = 0 THEN //5
		ll_tab = ll_end + 1
	END IF //5
	ll_length = ll_tab - ll_start
	ls_object = mid(ls_objects,ll_start,ll_length)
	ls_band = idw_dw.describe(ls_object + ".Band")
	IF upper(ls_band) = "DETAIL" AND upper(right(ls_object,2)) = "_T" THEN //10
		li_colnum ++
		ls_colname = left(ls_object,len(ls_object) - 2)
		ls_coltype = lower(left(idw_dw.describe(ls_colname + ".Coltype"),5))
		THIS.is_colname[li_colnum] = ls_colname
		IF  NOT (THIS.ib_customtitles) THEN //15
			ls_title = idw_dw.describe(ls_object + ".text")
			of_cleantitle(ls_title)
			THIS.is_title[li_colnum] = ls_title
		END IF //15
		THIS.is_coltype[li_colnum] = ls_coltype
		THIS.is_columnfilter[li_colnum] = ""
	END IF //10
	ll_start = ll_tab + 1
LOOP //3
THIS.ii_maxcol = li_colnum
RETURN 0

end function

Public function integer  of_getoriginalfilter (ref string as_originalfilter);//Public function of_getoriginalfilter (ref string as_originalfilter) returns integer 
//string as_originalfilter


as_originalfilter = THIS.is_originalfilter
RETURN 0

end function

Public function integer  of_getparentwindow (ref window aw_parent);//Public function of_getparentwindow (ref window aw_parent) returns integer 
//window aw_parent
powerobject lpo_parent


lpo_parent = idw_dw.getparent()
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

Public function integer  of_quickfilter (string as_colname,any aa_item);//Public function of_quickfilter (string as_colname,any aa_item) returns integer 
//string as_colname
//any aa_item
string ls_item
integer i
boolean lb_colfound


ls_item = string(aa_item)
FOR i = 1 TO THIS.ii_maxcol //1
	IF lower(as_colname) = lower(THIS.is_colname[i]) THEN //2
		lb_colfound = TRUE
		EXIT
	END IF //2
NEXT //1
IF  NOT (lb_colfound) THEN //6
	messagebox("Error","Invalid Column Name passed in to QuickFilter")
	RETURN -1
END IF //6
THIS.iu_powerfilter_dropdown.ii_colnum = i
THIS.iu_powerfilter_predeffilters.ii_colnum = i
THIS.iu_powerfilter_monthopts.ii_colnum = i
THIS.iu_powerfilter_dropdown.is_colname = as_colname
THIS.iu_powerfilter_dropdown.is_title = THIS.is_title[i]
THIS.iu_powerfilter_dropdown.is_coltype = THIS.is_coltype[i]
THIS.iu_powerfilter_dropdown.is_columnfilter = THIS.is_columnfilter[i]
iu_powerfilter_dropdown.of_getvalues(as_colname)
iu_powerfilter_dropdown.of_customfilter("equals",ls_item,"","","and")
iu_powerfilter_predeffilters.of_flagrow(1)
iu_powerfilter_monthopts.of_flagrow(0)
iu_powerfilter_dropdown.of_close()
iu_powerfilter_dropdown.of_savestate()
RETURN 0

end function

Public function integer  of_setcolumns (string as_columns[]);//Public function of_setcolumns (string as_columns[]) returns integer 
//string as_columns[]
long ll_max
long ll_colnum
string ls_object
string ls_title


ll_max = upperbound(as_columns)
FOR ll_colnum = 1 TO ll_max //1
	THIS.is_colname[ll_colnum] = as_columns[ll_colnum]
	THIS.is_coltype[ll_colnum] = lower(left(idw_dw.describe(THIS.is_colname[ll_colnum] + ".Coltype"),5))
	THIS.is_columnfilter[ll_colnum] = ""
	IF  NOT (THIS.ib_customtitles) THEN //5
		ls_object = THIS.is_colname[ll_colnum] + "_t"
		ls_title = idw_dw.describe(ls_object + ".text")
		of_cleantitle(ls_title)
		THIS.is_title[ll_colnum] = ls_title
	END IF //5
NEXT //1
THIS.ib_customcolumns = TRUE
THIS.ii_maxcol = ll_max
RETURN 0

end function

Public function integer  of_setdropdownoffset (integer ai_xoffset,integer ai_yoffset);//Public function of_setdropdownoffset (integer ai_xoffset,integer ai_yoffset) returns integer 
//integer ai_xoffset
//integer ai_yoffset


THIS.dropdownxoffset = ai_xoffset
THIS.dropdownyoffset = ai_yoffset
RETURN 0

end function

Public function integer  of_setdw (datawindow a_dw);//Public function of_setdw (datawindow a_dw) returns integer 
//datawindow a_dw


IF  NOT (isvalid(a_dw)) THEN RETURN -1
THIS.idw_dw = a_dw
of_setoriginalfilter()
of_setoriginalsort()
THIS.is_dwunits = idw_dw.describe("DataWindow.Units")
CHOOSE CASE THIS.is_dwunits //5
	CASE "0" //5
		THIS.idec_unitxfactor = 1
		THIS.idec_unityfactor = 1
	CASE "1" //5
		THIS.idec_unitxfactor = unitstopixels(1000,xunitstopixels!) / 1000.0
		THIS.idec_unityfactor = unitstopixels(1000,yunitstopixels!) / 1000.0
	CASE "2" //5
		THIS.idec_unitxfactor = 2.264368
		THIS.idec_unityfactor = 2.592105
	CASE "3" //5
		THIS.idec_unitxfactor = 5.770115
		THIS.idec_unityfactor = 6.605263
END CHOOSE //5
RETURN 0

end function

Public function integer  of_setoriginalfilter ();//Public function of_setoriginalfilter (none) returns integer 


IF  NOT (isvalid(THIS.idw_dw)) THEN RETURN -1
THIS.is_originalfilter = idw_dw.describe("DataWindow.Table.Filter")
IF THIS.is_originalfilter = "?" THEN //2
	THIS.is_originalfilter = ""
ELSE //2
	of_replace(THIS.is_originalfilter,"~~","")
END IF //2
RETURN 0

end function

Public function integer  of_setoriginalsort ();//Public function of_setoriginalsort (none) returns integer 


IF  NOT (isvalid(THIS.idw_dw)) THEN RETURN -1
THIS.is_originalsort = idw_dw.describe("DataWindow.Table.Sort")
IF THIS.is_originalsort = "?" THEN //2
	THIS.is_originalsort = ""
END IF //2
RETURN 0

end function

Public function integer  of_setlanguage (integer ai_languagenumber);//Public function of_setlanguage (integer ai_languagenumber) returns integer 
//integer ai_languagenumber
datastore lds_lang


lds_lang = CREATE datastore
lds_lang.dataobject = "d_powerfilter_languages"
THIS.ii_language = ai_languagenumber + 2
THIS.defaulttiptext = lds_lang.getitemstring(66,THIS.ii_language)
DESTROY lds_lang
RETURN 0

end function

Public function integer  of_settitles (string as_titles[]);//Public function of_settitles (string as_titles[]) returns integer 
//string as_titles[]
long ll_max
long ll_colnum


ll_max = upperbound(as_titles)
FOR ll_colnum = 1 TO ll_max //1
	THIS.is_title[ll_colnum] = as_titles[ll_colnum]
NEXT //1
THIS.ib_customtitles = TRUE
RETURN 0

end function

Protected function boolean  of_usedisplayvalue (string as_colname);//Protected function of_usedisplayvalue (string as_colname) returns boolean 
//string as_colname
string ls_editstyle
string ls_codetable


ls_editstyle = upper(idw_dw.describe(as_colname + ".Edit.Style"))
IF (ls_editstyle = "DDDW" OR ls_editstyle = "DDLB") THEN RETURN TRUE
ls_codetable = upper(idw_dw.describe(as_colname + "." + ls_editstyle + ".CodeTable"))
IF ls_codetable = "YES" THEN RETURN TRUE
RETURN FALSE

end function

Public function string  of_createcomputedfield (string as_colname,integer ai_colnum);//Public function of_createcomputedfield (string as_colname,integer ai_colnum) returns string 
//string as_colname
//integer ai_colnum
string ls_newcolumn
string ls_color
string ls_x
string ls_y
string ls_height
string ls_width
string ls_fontface
string ls_fontheight
string ls_fontweight
string ls_fontfamily
string ls_fontpitch
string ls_fontcharset
string ls_fontitalic
string ls_fontstrikethrough
string ls_fontunderline
string ls_backgroundcolor
string ls_format
string ls_return
string ls_mod


ls_newcolumn = "pfjrrcmp_" + string(ai_colnum)
ls_color = idw_dw.describe(as_colname + ".Color")
ls_x = string(integer(idw_dw.describe(as_colname + ".x")))
ls_y = idw_dw.describe(as_colname + ".y")
ls_height = idw_dw.describe(as_colname + ".height")
ls_width = idw_dw.describe(as_colname + ".width")
ls_format = idw_dw.describe(as_colname + ".format")
ls_fontface = idw_dw.describe(as_colname + ".font.face")
ls_fontheight = idw_dw.describe(as_colname + ".font.height")
ls_fontweight = idw_dw.describe(as_colname + ".font.weight")
ls_fontfamily = idw_dw.describe(as_colname + ".font.family")
ls_fontpitch = idw_dw.describe(as_colname + ".font.pitch")
ls_fontcharset = idw_dw.describe(as_colname + ".font.charset")
ls_backgroundcolor = idw_dw.describe(as_colname + ".background.color")
of_replace(ls_color,"'","~~'")
of_replace(ls_x,"'","~~'")
of_replace(ls_y,"'","~~'")
of_replace(ls_height,"'","~~'")
of_replace(ls_width,"'","~~'")
of_replace(ls_format,"'","~~'")
of_replace(ls_fontface,"'","~~'")
of_replace(ls_fontheight,"'","~~'")
of_replace(ls_fontweight,"'","~~'")
of_replace(ls_fontfamily,"'","~~'")
of_replace(ls_fontpitch,"'","~~'")
of_replace(ls_fontcharset,"'","~~'")
of_replace(ls_backgroundcolor,"'","~~'")
ls_mod = "create compute(band=Detail" + " color='" + ls_color + "' " + " alignment='0'  " + " border='0'" + " height.autosize=No  " + " pointer='Arrow!'" + " moveable=0  " + " resizeable=0  " + " x='" + ls_x + "'  " + " y='" + ls_y + "'  " + " height='0'" + " width='0'" + " format='" + ls_format + "'" + " name=" + ls_newcolumn + " tag=''  " + " visible='0'  " + " expression='lookupdisplay(" + as_colname + ")'  " + " font.face='" + ls_fontface + "'  " + " font.height='" + ls_fontheight + "' " + " font.weight='" + ls_fontweight + "'" + " font.family='" + ls_fontfamily + "'  " + " font.pitch='" + ls_fontpitch + "'  " + " font.charset='" + ls_fontcharset + "'  " + " background.mode='0' " + " background.color='" + ls_backgroundcolor + "')"
ls_return = idw_dw.modify(ls_mod)
RETURN ls_newcolumn

end function

Public function integer  of_getframe (ref window aw_parent);//Public function of_getframe (ref window aw_parent) returns integer 
//window aw_parent
powerobject lpo_parent
window lw_window
window lw_topwindow


lpo_parent = idw_dw.getparent()
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
lw_window = lpo_parent
DO WHILE isvalid(lw_window) //11
	IF lw_window.typeof() = window! THEN //12
		lw_topwindow = lw_window
		lw_window = lw_window.parentwindow()
		CONTINUE
	END IF //12
	EXIT
LOOP //11
aw_parent = lw_topwindow
RETURN 1

end function

Public function integer  of_filter (string as_filter);//Public function of_filter (string as_filter) returns integer 
//string as_filter
string ls_currentsort


idw_dw.setfilter(as_filter)
idw_dw.filter()
ls_currentsort = idw_dw.describe("DataWindow.Table.Sort")
IF ls_currentsort <> "?" THEN //3
	idw_dw.sort()
END IF //3
RETURN 1

end function

Public function integer  of_setparentwindow (window aw_parent);//Public function of_setparentwindow (window aw_parent) returns integer 
//window aw_parent


IF isvalid(aw_parent) THEN //0
	THIS.iw_parent = aw_parent
	RETURN 1
ELSE //0
	RETURN -1
END IF //0

end function

Public function long  of_setbackgroundcolor (string as_color);//Public function of_setbackgroundcolor (string as_color) returns long 
//string as_color


CHOOSE CASE lower(as_color) //0
	CASE "silver" //0
		THIS.backgroundcolor = string(12632256)
	CASE "buttonface" //0
		THIS.backgroundcolor = string(67108864)
	CASE "scrollbar" //0
		THIS.backgroundcolor = string(134217728)
	CASE "desktop" //0
		THIS.backgroundcolor = string(134217729)
	CASE "activetitlebar" //0
		THIS.backgroundcolor = string(134217730)
	CASE "inactivetitlebar" //0
		THIS.backgroundcolor = string(134217731)
	CASE "menubar" //0
		THIS.backgroundcolor = string(134217732)
	CASE "windowframe" //0
		THIS.backgroundcolor = string(134217734)
	CASE "activeborder" //0
		THIS.backgroundcolor = string(134217738)
	CASE "inactiveborder" //0
		THIS.backgroundcolor = string(134217739)
	CASE "highlight" //0
		THIS.backgroundcolor = string(134217741)
	CASE "buttonshadow" //0
		THIS.backgroundcolor = string(134217744)
	CASE "buttonhighlight" //0
		THIS.backgroundcolor = string(134217748)
	CASE "buttondarkshadow" //0
		THIS.backgroundcolor = string(134217749)
	CASE "buttonlightshadow" //0
		THIS.backgroundcolor = string(134217750)
	CASE "tooltip" //0
		THIS.backgroundcolor = string(134217752)
	CASE "link" //0
		THIS.backgroundcolor = string(134217856)
	CASE "linkhover" //0
		THIS.backgroundcolor = string(134217857)
	CASE "linkactive" //0
		THIS.backgroundcolor = string(134217858)
	CASE "linkvisited" //0
		THIS.backgroundcolor = string(134217859)
	CASE "applicationworkspace" //0
		THIS.backgroundcolor = string(268435456)
	CASE "windowbackground" //0
		THIS.backgroundcolor = string(1073741824)
	CASE ELSE //0
		IF isnumber(as_color) THEN //46
			THIS.backgroundcolor = as_color
		ELSE //46
			THIS.backgroundcolor = string(1073741824)
		END IF //46
END CHOOSE //0
RETURN long(THIS.backgroundcolor)

end function

on n_cst_powerfilter.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_powerfilter.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

