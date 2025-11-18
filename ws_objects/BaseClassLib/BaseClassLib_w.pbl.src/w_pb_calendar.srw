$PBExportHeader$w_pb_calendar.srw
$PBExportComments$calendario
forward
global type w_pb_calendar from window
end type
type st_2 from statictext within w_pb_calendar
end type
type st_1 from statictext within w_pb_calendar
end type
type uo_1 from u_pb_calendar within w_pb_calendar
end type
type mousepos from structure within w_pb_calendar
end type
end forward

type mousepos from structure
	long		xpos
	long		ypos
end type

global type w_pb_calendar from window
integer x = 832
integer y = 360
integer width = 2715
integer height = 1136
windowtype windowtype = response!
long backcolor = 79741120
event _calendar_object_notes ( )
event _ue_close ( )
st_2 st_2
st_1 st_1
uo_1 uo_1
end type
global w_pb_calendar w_pb_calendar

type prototypes
FUNCTION boolean GetCursorPos(ref structure mousepos) LIBRARY "user32.dll"
end prototypes

type variables
Private:
mousepos i_mousepos



end variables

event _calendar_object_notes;// Copy the following code to any date/text objects event such as rbuttondown, doubleclicked, etc.
// See the special DATAWINDOW code at the bottom

/****** For text type objects like sle, mle, em, st, etc. *************
// assuming this will go in the RBUTTONDOWN event

String ls_previous
this.setfocus()  // not necessary but you may want to use this since rightclicking will not set focus
ls_previous = this.text
OpenWithParm(w_pb_calendar,this)  // this will automatically fill that object with the date (mm/dd/yyyy)
//now compare the new versus the old:
if this.text <> ls_previous then ...m_file.m_save.enabled = true
Return 1  // disables the PB system popup with Cut, Paste, etc.
***********************************************************************/

/****** Special Code For DataWindows***********************************
// assuming this will go in the RBUTTONDOWN event

datawindow ldw
ldw = this
if row < 1 then return 1
if dwo.type <> 'column' then return 1
choose case gf_dw_pop_calendar(ldw,dwo.name,dwo.coltype,row)
	case 1  // turn on save or do an Update() here
		..m_file.m_save.enabled = true
	case -1  // not a date field, pop up your normal menu
		//im_popup.m_pop1.popmenu(w_frame.pointerx(),w_frame.pointery())
		return 1
end choose

--- OR ---
=============================================================
OR, You can use this more detailed code that allows you to 
automatically find the Save menu item for you.
=============================================================
// you can add this in your ancestor u_dw class where the developer
// can enabled the calendar in the constructor event by setting:
//    ib_pop_calendar = true
// this code will pop open the calendar if it is a date field
// also, it will enable the Save menu item if they changed the date

datawindow ldw
graphicobject lgo
window lw
integer i
boolean finished

if ib_pop_calendar = true then
	ldw = this
	if row < 1 then return 1
	if dwo.type <> 'column' then return 1
	choose case gf_dw_pop_calendar(ldw,dwo.name,dwo.coltype,row)
		case 1  // turn on save or do an Update() here
			// find m_save and enable it
			lgo = parent
			do until lgo.typeof() = Window!
				lgo = lgo.getparent()
			loop
			lw = lgo
			// we know save is under File (item 1) so loop 
//   through all of the menu items
			i = 1
			do until finished or i > 30
				// if we reach exit then Save must not exist
				if left(lw.menuid.item[1].item[i].text,5) = '&Exit' then
					finished = true
				else
					if left(lw.menuid.item[1].item[i].text,5) = '&Save' then
						lw.menuid.item[1].item[i].enabled = true
						finished = true
					else
						i++
					end if
				end if
			loop
			accepttext()
			return 1
		case -1  // not a date field, pop up your normal menu or your custom popup menu
			//im_popup.m_pop1.popmenu(w_frame.pointerx(),w_frame.pointery())
			return 1
	end choose
end if

************************************************************************/

/*
Potential Problems:
	If you database uses datetime as it's fields then you'll have to change the requestor
	object scripts, then run the calendar to have PB tell you where the datatypes don't match.
	There are only about 2 changes that you will need to make.  Also, you'll have to make all
	of your single line edit masks of type datetime.  You can't be using datetime in one place
	and date in another and reference the same calendar.
	
	If the user keeps the Win95 Start Bar or Office toolbar on the right side, it will get cut 
	off.  This will align itself up against the right side of the screen.
*/

end event

event _ue_close;close(this)

end event

event open;/****************************************************
                 Code: Marc J. Mataya
    \\|//        marcmataya@writeme.com
   ( @ @ )       
     ( )         Charlotte, NC  
~~oooO~~Oooo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Last Updated:  3/12/98
Rand Borton; Modified key control over calendar scrolling
Marc Mataya; Changed the code below for the requestor and adjusted for the Esc key
Last Update: 17/05/04
Pedro Wong;   Added Holidays, see upb_calendar:constructor
Input Parameter:  message.powerobjectparm and gs_dateparm

The uo_1 constructor event will get hit first.  This is where we will
determine the object type (dw,mle,sle,st,etc.) then extract the current
date from the object (unless it's a datawindow), then pop open this window
with that date using today() as the default date if one doesn't exist.

Also, we want to position this window to appear where the mouse resides, 
similar to the popup menu method.  It will account for the bottom of the screen
and a start menu toolbar + an office toolbar menu being on the bottom.*/

string ls
integer i

this.width = uo_1.width
this.height = uo_1.height

// Allows the user object to reference this window without hard coding
//		a window name (can't use PARENT in the uo_1 code because it has none).
//    The UO will CloseWithReturn(i_window,dateparm).
uo_1.i_window = this

// Get the pointer position using the LOCAL External Function...
GetCursorPos(i_mousepos)
// Now check to see if it will pop it up off of the screen
environment l_env
GetEnvironment(l_env)
// if the window will get cut off on the right make it bump up against the edge
if (i_mousepos.xpos + UnitsToPixels(this.width,XUnitsToPixels!)) > l_env.screenwidth then
	this.x = PixelsToUnits(l_env.screenwidth,XPixelsToUnits!) - this.width
else
	this.x = PixelsToUnits(i_mousepos.xpos,XPixelsToUnits!)
end if
// if the window will get chopped off at the bottom, make the bottom left edge be where the pointer is sitting.
// NOTE:  This object assumes that the user has the start bar and an office toolbar sitting at the bottom
if (i_mousepos.ypos + UnitsToPixels(this.height,yUnitsToPixels!)) + 50 > l_env.screenheight then
	//this.y = PixelsToUnits(l_env.screenheight,yPixelsToUnits!) - this.height 
	this.y = PixelsToUnits(i_mousepos.ypos,yPixelsToUnits!) - this.height
else
	this.y = PixelsToUnits(i_mousepos.ypos,yPixelsToUnits!)
end if

end event

on w_pb_calendar.create
this.st_2=create st_2
this.st_1=create st_1
this.uo_1=create uo_1
this.Control[]={this.st_2,&
this.st_1,&
this.uo_1}
end on

on w_pb_calendar.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.uo_1)
end on

event key;// Allows user to get out without clicking anything
if key = KeyEscape! then
	this.postevent('_ue_close')
end if

end event

type st_2 from statictext within w_pb_calendar
integer x = 14
integer y = 840
integer width = 3122
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = " see the .doc file.  Cut an paste the code for use in your requestor objects..."
boolean focusrectangle = false
end type

type st_1 from statictext within w_pb_calendar
integer x = 14
integer y = 776
integer width = 3026
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 128
long backcolor = 79741120
boolean enabled = false
string text = "See the _calendar_object_notes event of this window to get the usage scripts or"
boolean focusrectangle = false
end type

type uo_1 from u_pb_calendar within w_pb_calendar
integer height = 760
integer taborder = 1
long backcolor = 12632256
end type

on uo_1.destroy
call u_pb_calendar::destroy
end on

