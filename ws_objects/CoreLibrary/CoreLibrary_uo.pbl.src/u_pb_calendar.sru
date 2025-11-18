$PBExportHeader$u_pb_calendar.sru
$PBExportComments$Used by the PB Calendar Object
forward
global type u_pb_calendar from userobject
end type
type lb_1 from listbox within u_pb_calendar
end type
type cb_close from commandbutton within u_pb_calendar
end type
type cb_forwardyear from commandbutton within u_pb_calendar
end type
type cb_backyear from commandbutton within u_pb_calendar
end type
type cb_forwardmonth from commandbutton within u_pb_calendar
end type
type cb_backmonth from commandbutton within u_pb_calendar
end type
type dw_cal from datawindow within u_pb_calendar
end type
type ln_1 from line within u_pb_calendar
end type
type ln_2 from line within u_pb_calendar
end type
end forward

global type u_pb_calendar from userobject
integer width = 2665
integer height = 860
long backcolor = 80263328
long tabtextcolor = 33554432
lb_1 lb_1
cb_close cb_close
cb_forwardyear cb_forwardyear
cb_backyear cb_backyear
cb_forwardmonth cb_forwardmonth
cb_backmonth cb_backmonth
dw_cal dw_cal
ln_1 ln_1
ln_2 ln_2
end type
global u_pb_calendar u_pb_calendar

type variables
Int ii_Day, ii_Month, ii_Year, ii_holiday[]
String is_old_column
String is_DateFormat
Date id_date_selected
string is_return_date
window i_window
object i_obj
str_calendar istr_cal

long il_row
string is_column_name
dwobject i_dwo
datawindow i_dw
singlelineedit i_sle
multilineedit i_mle
statictext i_st
editmask i_em
dropdownlistbox i_ddlb
richtextedit i_rte

string dateparm
boolean ib_requester_is_datawindow
string is_mask = 'dd/mm/yyyy'

end variables

forward prototypes
public function integer days_in_month (integer month, integer year)
public subroutine draw_month (integer year, integer month)
public function int get_month_number (string as_month)
public function string get_month_string (integer as_month)
public subroutine init_cal (date ad_start_date)
public function integer unhighlight_column (string as_column)
public subroutine set_date (date ad_date)
public subroutine set_date_format (string as_date_format)
public function integer highlight_column (string as_column)
public subroutine enter_day_numbers (integer ai_start_day_num, integer ai_days_in_month)
end prototypes

public function integer days_in_month (integer month, integer year);//Most cases are straight forward in that there are a fixed number of 
//days in 11 of the 12 months.  February is, of course, the problem.
//In a leap year February has 29 days, otherwise 28.

Integer		li_DaysInMonth, li_Days[12] = {31,28,31,30,31,30,31,31,30,31,30,31}

// Get the number of days per month for a non leap year.
li_DaysInMonth = li_Days[Month]

// Check for a leap year.
If Month = 2 Then
	// If the year is a leap year, change the number of days.
	// Leap Year Calculation:
	//	Year divisible by 4, but not by 100, unless it is also divisible by 400
	If ( (Mod(Year,4) = 0 And Mod(Year,100) <> 0) Or (Mod(Year,400) = 0) ) Then
		li_DaysInMonth = 29
	End If
End If

//Return the number of days in the relevant month
Return li_DaysInMonth

end function

public subroutine draw_month (integer year, integer month);Int  li_FirstDayNum, li_cell, li_daysinmonth
Date ld_firstday
String ls_month, ls_cell, ls_return

//Set Pointer to an Hourglass and turn off redrawing of Calendar
SetPointer(Hourglass!)
SetRedraw(dw_cal,FALSE)

//Set Instance variables to arguments
ii_month = month
ii_year = year

//check in the instance day is valid for month/year 
//back the day down one if invalid for month ie 31 will become 30
Do While Date(ii_year,ii_month,ii_day) = Date(00,1,1)
	ii_day --
Loop

//Work out how many days in the month
li_daysinmonth = days_in_month(ii_month,ii_year)

//Find the date of the first day in the month
ld_firstday = Date(ii_year,ii_month,1)

//Find what day of the week this is
li_FirstDayNum = DayNumber(ld_firstday)

//Set the first cell
li_cell = li_FirstDayNum + ii_day - 1

//If there was an old column turn off the highlight
unhighlight_column (is_old_column)

//Set the Title
ls_month = get_month_string(ii_month) + " " + string(ii_year)
dw_cal.Object.st_month.text = ls_month

//Enter the day numbers into the datawindow
enter_day_numbers(li_FirstDayNum,li_daysinmonth)

//Define the current cell name
ls_cell = 'cell'+string(li_cell)

//Highlight the current date
highlight_column (ls_cell)

//Set the old column for next time
is_old_column = ls_cell

//Reset the pointer and Redraw
SetPointer(Arrow!)
dw_cal.SetRedraw(TRUE)

end subroutine

public function int get_month_number (string as_month);Int li_month_number

CHOOSE CASE as_month
	CASE "Jan"
		li_month_number = 1
	CASE "Feb"
		li_month_number = 2
	CASE "Mar"
		li_month_number = 3
	CASE "Apr"
		li_month_number = 4
	CASE "May"
		li_month_number = 5
	CASE "Jun"
		li_month_number = 6
	CASE "Jul"
		li_month_number = 7
	CASE "Aug"
		li_month_number = 8
	CASE "Sep"
		li_month_number = 9
	CASE "Oct"
		li_month_number = 10
	CASE "Nov"
		li_month_number = 11
	CASE "Dec"
		li_month_number = 12
END CHOOSE

return li_month_number
end function

public function string get_month_string (integer as_month);String ls_month

CHOOSE CASE as_month
	CASE 1
		ls_month = "Enero"
	CASE 2
		ls_month = "Febrero"
	CASE 3
		ls_month = "Marzo"
	CASE 4
		ls_month = "Abril"
	CASE 5
		ls_month = "Mayo"
	CASE 6
		ls_month = "Junio"
	CASE 7
		ls_month = "Julio"
	CASE 8
		ls_month = "Agosto"
	CASE 9
		ls_month = "Setiembre"
	CASE 10
		ls_month = "Octubre"
	CASE 11
		ls_month = "Noviembre"
	CASE 12
		ls_month = "Diciembre"
END CHOOSE

return ls_month
end function

public subroutine init_cal (date ad_start_date);
/* code added to allow key-scrolling thru month; minimize redraw actions when staying within same month */

Int li_FirstDayNum, li_Cell, li_DaysInMonth
String ls_Year, ls_Month, ls_Return, ls_Cell
Date ld_FirstDay
boolean lb_redraw_month

dw_cal.SetRedraw(FALSE)

// unhighlight the previous cell
if len(is_old_column) > 0 then
   unhighlight_column (is_old_column)
end if

//Set the variables for Day, Month and Year from the date passed to
//the function

// Marc Mataya - Took out to force the redraw on open
//if dw_cal.Rowcount() = 1 and ii_month > 0 and ii_month = Month(ad_start_date) and ii_year > 0 and ii_year = Year(ad_start_date) then // same month; don't redraw
//else
   ii_Month = Month(ad_start_date)
   ii_Year = Year(ad_start_date)
	//Reset the datawindow
   reset(dw_cal)
   //Insert a row into the script datawindow
   dw_cal.InsertRow(0)
   lb_redraw_month = TRUE
//end if
ii_Day = Day(ad_start_date)

//Find how many days in the relevant month
li_daysinmonth = days_in_month(ii_month, ii_year)

//Find the date of the first day of this month
ld_FirstDay = Date(ii_Year, ii_month, 1)

//What day of the week is the first day of the month
li_FirstDayNum = DayNumber(ld_FirstDay)

//Set the starting "cell" in the datawindow. i.e the column in which
//the first day of the month will be displayed
li_Cell = li_FirstDayNum + ii_Day - 1

if lb_redraw_month then
   //Set the Title of the calendar with the Month and Year
   ls_Month = get_month_string(ii_Month) + " " + string(ii_Year)
   dw_cal.Object.st_month.text = ls_month

   //Enter the numbers of the days
   enter_day_numbers(li_FirstDayNum, li_DaysInMonth)
end if

dw_cal.SetItem(1,li_cell,String(Day(ad_start_date)))

//Define the first Cell as a string
ls_cell = 'cell'+string(li_cell)

//Display the first day in bold (or 3D)
highlight_column (ls_cell)

//Set the instance variable i_old_column to hold the current cell, so
//when we change it, we know the old setting
is_old_column = ls_Cell

dw_cal.SetRedraw(TRUE)
dw_cal.setfocus()

end subroutine

public function integer unhighlight_column (string as_column);//If the highlight is on the column set the border of the column back to normal

string ls_return

If as_column <> '' then
	ls_return = dw_cal.Modify(as_column + ".border=0")
	If ls_return <> "" then 
		MessageBox("Modify",ls_return)
		Return -1
	End if
End If

Return 1
end function

public subroutine set_date (date ad_date);// Set the date.  Use the desired format.

If Not isnull(ad_date) then 
	is_return_date = string(ad_date, 'mm/dd/yyyy')
End If
end subroutine

public subroutine set_date_format (string as_date_format);// Set the format.
is_DateFormat = as_date_format

// Set the date with the new format.
If Not isnull(id_date_selected) then 
	set_date (id_date_selected)
End If
end subroutine

public function integer highlight_column (string as_column);//Highlight the current column/date

string ls_return

ls_return = dw_cal.Modify(as_column + ".border=5")
If ls_return <> "" then 
	MessageBox("Modify",ls_return)
	Return -1
End if

Return 1
end function

public subroutine enter_day_numbers (integer ai_start_day_num, integer ai_days_in_month);Int li_count, li_daycount, li_work, li_x

//Blank the columns before the first day of the month
For li_count = 1 to ai_start_day_num
	dw_cal.SetItem(1,li_count,"")
Next

//Set the columns for the days to the String of their Day number
For li_count = 1 to ai_days_in_month
	//Use li_daycount to find which column needs to be set
	li_daycount = ai_start_day_num + li_count - 1
	dw_cal.SetItem(1,li_daycount,String(li_count))
	// Prepare de Date for Holiday Comparison
	li_work = ii_month * 100 + li_count
	// Put Day Text in Black
	IF DayNumber(Date(ii_year,ii_month, li_count)) <> 1 THEN 
		dw_cal.Modify("cell" + String(li_daycount) + ".Color = 0")
	END IF
	// Compare for Holidays
	For li_x = 1 To UpperBound(ii_holiday)
		IF li_work = ii_holiday[li_x] THEN
			// Put Day Text in Red
			dw_cal.Modify("cell" + String(li_daycount) + ".Color = 255")
		END IF
	Next
Next

//Move to next column
li_daycount = li_daycount + 1

//Blank remainder of columns
For li_count = li_daycount to 42
	dw_cal.SetItem(1,li_count,"")
Next

//If there was an old column turn off the highlight
unhighlight_column (is_old_column)

is_old_column = ''


end subroutine

event constructor;/*****************************************************
    \\|//        Code: Marc J. Mataya
   ( @ @ )       Last Updated:  1/26/98
     ( )           
~~oooO~~Oooo~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Purpose: takes in the parameter from the OpenWithParm
code on the requestor side.
This object is called using OpenWithParm(w_pb_calendar,this)
 or OpenWithParm(w_pb_calendar,lstr_cal), a local structure
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Change Log:  when calling this from a datawindow, it
was using primary[1] which was pulling the date from the
first row of the datawindow.  I had to change the calling
script to pass message.stringparm as "calendar 01/18/1998"
*****************************************************/

string ls
integer i_row

// If a Datawindow is calling it then the str_calendar items are
//   required to be set PRIOR to the OpenWithParm
// If "this" is TypeOf Structure!, then the structure must be filled,
//   otherwise, the structure values are ignored

// Loading Holidays
// You can replace this with a function that reads the values from a table
// or you can have this in a global variable and assign it here replacing
// the following code by something like:  ii_holiday = gi_holiday
// value = Month * 100 + Day
//ii_holiday[1] = (1*100) + 1
//ii_holiday[2] = (5*100) + 1
//ii_holiday[3] = (7*100) + 28
//ii_holiday[4] = (7*100) + 29
//ii_holiday[5] = (8*100) + 30
//ii_holiday[6] = (10*100) + 8
//ii_holiday[7] = (11*100) + 1
//ii_holiday[8] = (12*100) + 8
//ii_holiday[9] = (12*100) + 25
ii_holiday = gi_feriado

//if left(message.stringparm,8) = "calendar" then  // = "calendar DD/MM/YYYY"
//	// it's a datawindow requesting it
//	dateparm = mid(message.stringparm,10,10)
//	ib_requester_is_datawindow = true
//else
	// Get the powerobject parameter...
	i_obj = message.powerobjectparm.typeof()

	CHOOSE CASE i_obj
		CASE Structure!
			// set the incoming structure to the uo instance structure
			istr_cal = message.powerobjectparm
			//i_dwo = istr_calendar.active_dwo
			is_column_name = istr_cal.active_column
			i_dw = istr_cal.active_datawindow
			il_row = istr_cal.active_row
			if not isvalid(i_dw) then 
				messagebox('Error','Invalid datawindow set in the structure.',stopsign!)
				closewithreturn(i_window,'01/01/1900')
			end if
			if i_dw.rowcount() >= il_row and il_row > 0 then
				// it has to be either a date or datetime
				ls = is_column_name + '.ColType'
				ls = i_dw.describe(ls)
				//messagebox('type',ls)
				if ls = 'date' then
					dateparm = string(i_dw.getitemdate(il_row,is_column_name),'DD/MM/YYYY')
				else
					dateparm = string(i_dw.getitemdatetime(il_row,is_column_name),'DD/MM/YYYY')
				end if
			else 
				messagebox('Error','Invalid row number set in the structure.',stopsign!)
			end if
		CASE DropDownListBox!  // don't require the structure values
			i_ddlb = message.powerobjectparm
			dateparm = i_ddlb.text
		CASE RichTextEdit!
			i_rte = message.powerobjectparm
			dateparm = i_rte.textline()
		CASE SingleLineEdit!
			i_sle = message.powerobjectparm
			dateparm = i_sle.text
		CASE MultiLineEdit!
			i_mle = message.powerobjectparm
			dateparm = i_mle.text
		CASE StaticText!
			i_st = message.powerobjectparm
			dateparm = i_st.text
		CASE EditMask!
			i_em = message.powerobjectparm
			dateparm = i_em.text
		CASE ELSE
			// The object Is irrelevant!
			CloseWithReturn(i_window,dateparm)
	END CHOOSE
//end if

this.width = dw_cal.width
this.height = dw_cal.height

// find out what the format was when it was sent here
// was it YYYY? was it YY?
if isdate(dateparm) then
	choose case len(dateparm)
		case 10
			is_mask = 'DD/MM/YYYY'
		case 8
			is_mask = 'DD/MM/YY'
		case else
			is_mask = 'DD/MM/YY'
	end choose
end if

// convert the date into a 4 digit year string if it isn't already
dateparm = string(date(dateparm),'DD/MM/YYYY')

// if the date is not valid then force it to be today()
if dateparm = "01/01/1900" or &
	not isdate(dateparm) or &
	mid(trim(dateparm),4,2) = '00' or &
	mid(trim(dateparm),1,2) = '00' then

	dateparm = string(today(),'DD/MM/YYYY')
	id_date_selected = today()
end if

ii_day = day(date(dateparm))
ii_month = month(date(dateparm))
ii_year = year(date(dateparm))

// If there is already a date in the edit box then make this the
// current date in the calendar, otherwise use today
If ii_day = 0 Then ii_day = 1
//ld_date = date(ii_year, ii_month, ii_day)  // This line used for debugging
init_cal(date(ii_year, ii_month, ii_day))


end event

on u_pb_calendar.create
this.lb_1=create lb_1
this.cb_close=create cb_close
this.cb_forwardyear=create cb_forwardyear
this.cb_backyear=create cb_backyear
this.cb_forwardmonth=create cb_forwardmonth
this.cb_backmonth=create cb_backmonth
this.dw_cal=create dw_cal
this.ln_1=create ln_1
this.ln_2=create ln_2
this.Control[]={this.lb_1,&
this.cb_close,&
this.cb_forwardyear,&
this.cb_backyear,&
this.cb_forwardmonth,&
this.cb_backmonth,&
this.dw_cal,&
this.ln_1,&
this.ln_2}
end on

on u_pb_calendar.destroy
destroy(this.lb_1)
destroy(this.cb_close)
destroy(this.cb_forwardyear)
destroy(this.cb_backyear)
destroy(this.cb_forwardmonth)
destroy(this.cb_backmonth)
destroy(this.dw_cal)
destroy(this.ln_1)
destroy(this.ln_2)
end on

type lb_1 from listbox within u_pb_calendar
integer x = 896
integer y = 12
integer width = 1733
integer height = 756
integer taborder = 40
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean border = false
boolean vscrollbar = true
boolean sorted = false
string item[] = {"+ See the w_pb_calendar _calender_object_notes event to copy scripts","+ Uses Courier for the arrows.  Must have font installed.","+ Defaults to today() as if the parameter is an invalid date or null.","+ Also returns a string(date) in the message.stringparm for addl. coding needs","+ Keys:","Page keys = change the months by 1","Ctrl+Page keys = change the years by 1","Arrows = navigate through the days","Enter = select the highlighted date","+ Bug Alert:  you may have to open w_pb_calendar one time","to let PB know about the local external function.  Save after opening.","+ Year 2000 compliant"}
end type

type cb_close from commandbutton within u_pb_calendar
event clicked pbm_bnclicked
integer x = 622
integer y = 568
integer width = 82
integer height = 60
integer taborder = 70
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "X"
end type

event clicked;//closewithreturn(i_window,dateparm)
closewithreturn(i_window,'01/01/1900')

end event

type cb_forwardyear from commandbutton within u_pb_calendar
event _keydown pbm_keydown
integer x = 631
integer width = 78
integer height = 84
integer taborder = 30
integer textsize = -15
integer weight = 700
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier"
string text = ">"
end type

event _keydown;dw_cal.setfocus()
dw_cal.triggerevent(key!)

end event

event clicked;//Increment the month number, but if its 13, set back to 1 (January)
//ii_month = ii_month + 1
//If ii_month = 13 then
//	ii_month = 1
ii_year = ii_year + 1
//End If

//check if selected day is no longer valid for new month
If not(isdate(string(ii_month) + "/" + string(ii_day) + "/"+ string(ii_year))) Then ii_day = 1
	
//Draw the month
draw_month ( ii_year, ii_month )

//Return the chosen date into the SingleLineEdit in the chosen format
id_date_selected = date(ii_year,ii_month,ii_Day)
set_date (id_date_selected)
dw_cal.setfocus()
end event

type cb_backyear from commandbutton within u_pb_calendar
event _keydown pbm_keydown
integer width = 78
integer height = 84
integer taborder = 20
integer textsize = -15
integer weight = 700
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier"
string text = "<"
end type

event _keydown;dw_cal.setfocus()
dw_cal.triggerevent(key!)

end event

event clicked;//Decrement the month, if 0, set to 12 (December)
//ii_month = ii_month - 1
//If ii_month = 0 then
//	ii_month = 12
ii_year = ii_year - 1
//End If

//check if selected day is no longer valid for new month
If not(isdate(string(ii_month) + "/" + string(ii_day) + "/"+ string(ii_year))) Then ii_day = 1

//Draw the month
draw_month ( ii_year, ii_month )

//Return the chosen date into the SingleLineEdit in the chosen format
id_date_selected = date(ii_year,ii_month,ii_Day)
set_date (id_date_selected)

dw_cal.setfocus()
end event

type cb_forwardmonth from commandbutton within u_pb_calendar
event _keydown pbm_keydown
integer x = 581
integer width = 50
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier"
string text = ">"
end type

event _keydown;dw_cal.setfocus()
dw_cal.triggerevent(key!)

end event

event clicked;//Increment the month number, but if its 13, set back to 1 (January)
ii_month = ii_month + 1
If ii_month = 13 then
	ii_month = 1
	ii_year = ii_year + 1
End If

//check if selected day is no longer valid for new month
If not(isdate(string(ii_month) + "/" + string(ii_day) + "/"+ string(ii_year))) Then ii_day = 1
	
//Draw the month
draw_month ( ii_year, ii_month )

//Return the chosen date into the SingleLineEdit in the chosen format
id_date_selected = date(ii_year,ii_month,ii_Day)
set_date (id_date_selected)
dw_cal.setfocus()
end event

type cb_backmonth from commandbutton within u_pb_calendar
event _keydown pbm_keydown
integer x = 78
integer width = 50
integer height = 84
integer taborder = 50
integer textsize = -8
integer weight = 400
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Courier"
string text = "<"
end type

event _keydown;dw_cal.setfocus()
dw_cal.triggerevent(key!)

end event

event clicked;//Decrement the month, if 0, set to 12 (December)
ii_month = ii_month - 1
If ii_month = 0 then
	ii_month = 12
	ii_year = ii_year - 1
End If

//check if selected day is no longer valid for new month
If not(isdate(string(ii_month) + "/" + string(ii_day) + "/"+ string(ii_year))) Then ii_day = 1

//Draw the month
draw_month ( ii_year, ii_month )

//Return the chosen date into the SingleLineEdit in the chosen format
id_date_selected = date(ii_year,ii_month,ii_Day)
set_date (id_date_selected)
dw_cal.setfocus()
end event

type dw_cal from datawindow within u_pb_calendar
event ue_dwnkey pbm_dwnkey
integer width = 736
integer height = 656
integer taborder = 10
string dataobject = "d_calendar"
boolean border = false
end type

event ue_dwnkey;
/*This script will allow the ctrl right arrow and
  ctrl left arrow key combinations to change the months on
  the calendar;
  7/15/97 Mods by REB; arrow keys move within month;
  shift arrow move between months;
  control key arrow move between years;
  cells go from cell1 to cell42;
*/

string ls_columnname
integer li
dwobject dwo


choose case true
	case keydown(keyEnter!) // return the date
		  CHOOSE CASE is_old_column
   			CASE 'cell1'
					dwo = this.Object.cell1
   			CASE 'cell2'
					dwo = this.Object.cell2
   			CASE 'cell3'
	   			dwo = this.Object.cell3
   			CASE 'cell4'
	   			dwo = this.Object.cell4
   			CASE 'cell5'
	   			dwo = this.Object.cell5
   			CASE 'cell6'
	   			dwo = this.Object.cell6
   			CASE 'cell7'
	   			dwo = this.Object.cell7
   			CASE 'cell8'
	   			dwo = this.Object.cell8
   			CASE 'cell9'
	   			dwo = this.Object.cell9
   			CASE 'cell10'
	   			dwo = this.Object.cell10
   			CASE 'cell11'
	   			dwo = this.Object.cell11
   			CASE 'cell12'
	   			dwo = this.Object.cell12
   			CASE 'cell13'
	   			dwo = this.Object.cell13
   			CASE 'cell14'
	   			dwo = this.Object.cell14
   			CASE 'cell15'
	   			dwo = this.Object.cell15
   			CASE 'cell16'
	   			dwo = this.Object.cell16
   			CASE 'cell17'
	   			dwo = this.Object.cell17
   			CASE 'cell18'
	   			dwo = this.Object.cell18
   			CASE 'cell19'
	   			dwo = this.Object.cell19
   			CASE 'cell20'
	   			dwo = this.Object.cell20
   			CASE 'cell21'
	   			dwo = this.Object.cell21
   			CASE 'cell22'
	   			dwo = this.Object.cell22
   			CASE 'cell23'
	   			dwo = this.Object.cell23
   			CASE 'cell24'
	   			dwo = this.Object.cell24
   			CASE 'cell25'
	   			dwo = this.Object.cell25
   			CASE 'cell26'
	   			dwo = this.Object.cell26
   			CASE 'cell27'
	   			dwo = this.Object.cell27
   			CASE 'cell28'
	   			dwo = this.Object.cell28
   			CASE 'cell29'
	   			dwo = this.Object.cell29
   			CASE 'cell30'
	   			dwo = this.Object.cell30
   			CASE 'cell31'
	   			dwo = this.Object.cell31
   			CASE 'cell32'
	   			dwo = this.Object.cell32
   			CASE 'cell33'
	   			dwo = this.Object.cell33
   			CASE 'cell34'
	   			dwo = this.Object.cell34
   			CASE 'cell35'
	   			dwo = this.Object.cell35
   			CASE 'cell36'
	   			dwo = this.Object.cell36
   			CASE 'cell37'
	   			dwo = this.Object.cell37
   			CASE 'cell38'
	   			dwo = this.Object.cell38
   			CASE 'cell39'
	   			dwo = this.Object.cell39
   			CASE 'cell40'
	   			dwo = this.Object.cell40
   			CASE 'cell41'
	   			dwo = this.Object.cell41
   			CASE 'cell42'
	   			dwo = this.Object.cell42
				CASE ELSE
					return
		  END CHOOSE
  		  this.Event post clicked(1, 1, 1, dwo)
	case keydown(keyControl!) and (keydown(keyLeftArrow!) or keydown(keyPageDown!))
		cb_backyear.triggerevent(clicked!)
	case keydown(keyControl!) and (keydown(keyRightArrow!) or keydown(keyPageUp!))
		cb_forwardyear.triggerevent(clicked!)
	case (keydown(keyShift!) and keydown(keyLeftArrow!)) or keydown(keyPageDown!)
		cb_backmonth.triggerevent(clicked!)
	case (keydown(keyShift!) and keydown(keyRightArrow!)) or keydown(keyPageUp!)
		cb_forwardmonth.triggerevent(clicked!)
	case keydown(keyRightArrow!)
		init_cal(RelativeDate(date(ii_year, ii_month, ii_day), 1) )
	case keydown(keyLeftArrow!)
		init_cal(RelativeDate(date(ii_year, ii_month, ii_day), - 1) )
	case keydown(keyUpArrow!)
		init_cal(RelativeDate(date(ii_year, ii_month, ii_day), - 7) )
	case keydown(keyDownArrow!)
		init_cal(RelativeDate(date(ii_year, ii_month, ii_day), 7 ) )
end choose
end event

event clicked;String ls_clickedcolumn, ls_clickedcolumnID
String ls_day, ls_return
string ls_col_name

//Return if click was not on a valid dwobject, depending on what was
//clicked, dwo will be null or dwo.name will be "datawindow"
If IsNull(dwo) Then Return
If Pos(dwo.name, "cell") = 0 Then Return

//Find which column was clicked on and return if it is not valid
ls_clickedcolumn = dwo.name
ls_clickedcolumnID = dwo.id
If ls_clickedcolumn = '' Then Return

//Set Day to the text of the clicked column. Return if it is an empty column
ls_day = dwo.primary[1]
If ls_day = "" then Return

//Convert to a number and place in Instance variable
ii_day = Integer(ls_day)

//If the highlight was on a previous column (is_old_column <> '')
//set the border of the old column back to normal
unhighlight_column (is_old_column)

//Highlight chosen day/column
dwo.border = 5

//Set the old column for next time
is_old_column = ls_clickedcolumn

//Return the chosen date into the object in the original format
id_date_selected = date(ii_year, ii_month, ii_Day)
set_date (id_date_selected)

// set the object to be the date selected
if ib_requester_is_datawindow = false then
	CHOOSE CASE i_obj
		CASE Structure!
			i_dw.setitem(il_row,is_column_name,id_date_selected)
		CASE DropDownListBox!
			i_ddlb.text = string(id_date_selected,is_mask)
		CASE RichTextEdit!
			//i_rte.textline()
		CASE SingleLineEdit!
			i_sle.text = string(id_date_selected,is_mask)
		CASE MultiLineEdit!
			i_mle.text = string(id_date_selected,is_mask)
		CASE StaticText!
			i_st.text = string(id_date_selected,is_mask)
		CASE EditMask!
			i_em.text = string(id_date_selected,is_mask)
		CASE ELSE
			MessageBox("Calendar Object Error","Add code to u_pb_calendar constructor, clicked for dw_cal events, and add a new uo_1 instance variable type.")
	END CHOOSE
end if
closewithreturn(i_window,string(id_date_selected, 'dd/mm/yyyy'))
end event

type ln_1 from line within u_pb_calendar
long linecolor = 16777215
integer linethickness = 4
integer beginy = 676
integer endx = 837
integer endy = 676
end type

type ln_2 from line within u_pb_calendar
long linecolor = 16777215
integer linethickness = 4
integer beginx = 832
integer endx = 832
integer endy = 676
end type

