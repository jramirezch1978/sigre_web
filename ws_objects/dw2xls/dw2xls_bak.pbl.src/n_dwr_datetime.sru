$PBExportHeader$n_dwr_datetime.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_datetime from nonvisualobject
end type
end forward

global type n_dwr_datetime from nonvisualobject autoinstantiate
end type
global n_dwr_datetime n_dwr_datetime

type variables
protected string is_month[12]
end variables

forward prototypes
public function integer of_dayofweek (date ad_source)
public function long of_days (long al_seconds)
public function date of_firstdayofmonth (date ad_source)
public function date of_gregorian (long al_julian)
public function long of_hours (long al_seconds)
public function boolean of_isleapyear (date ad_source)
public function boolean of_isvalid (date ad_source)
public function boolean of_isvalid (datetime adtm_source)
public function boolean of_isvalid (time atm_source)
public function boolean of_isweekday (date ad_source)
public function boolean of_isweekend (date ad_source)
public function long of_julian (date ad_source)
public function long of_juliandaynumber (date ad_source)
public function date of_lastdayofmonth (date ad_source)
public function long of_millisecsafter (time atm_start,time atm_end)
public function string of_monthname (date ad_source)
public function string of_monthname (integer ai_monthnumber)
public function long of_monthsafter (date ad_start,date ad_end)
public function datetime of_relativedatetime (datetime adtm_start,long al_offset)
public function date of_relativemonth (date ad_source,long al_month)
public function date of_relativeyear (date ad_source,long al_years)
public function long of_secondsafter (datetime adtm_start,datetime adtm_end)
public function integer of_wait (datetime adtm_target)
public function integer of_wait (ulong al_seconds)
public function long of_weeknumber (date ad_source)
public function long of_weeksafter (date ad_start,date ad_end)
public function long of_yearsafter (date ad_start,date ad_end)
end prototypes

public function integer of_dayofweek (date ad_source);long ll_null

if isnull(ad_source) then
	setnull(ll_null)
	return ll_null
end if

if not of_isvalid(ad_source) then
	return -1
end if

return daynumber(ad_source)
end function

public function long of_days (long al_seconds);long ll_result
long ll_null

if isnull(al_seconds) then
	setnull(ll_null)
	return ll_null
end if

if al_seconds < 0 then
	return -1
end if

ll_result = (al_seconds / 3600) / 24
return ll_result
end function

public function date of_firstdayofmonth (date ad_source);date ldt_null

if isnull(ad_source) then
	setnull(ldt_null)
	return ldt_null
end if

if not of_isvalid(ad_source) then
	return ad_source
end if

return date(year(ad_source),month(ad_source),1)
end function

public function date of_gregorian (long al_julian);date ldt_null
long ll_numqc
long ll_numq
long ll_numc
long ll_cent = 36524
long ll_quad = 1461
integer li_year
integer li_month
integer li_day
integer li_daysinmonth[12]={31,28,31,30,31,30,31,31,30,31,30,31}

if isnull(al_julian) then
	setnull(ldt_null)
	return ldt_null
end if

ll_numqc = al_julian / 146097
li_year = ll_numqc * 400
al_julian -= (146097 * ll_numqc)
ll_numc = 0

if al_julian > ll_cent + 1 then
	al_julian -= (ll_cent + 1)
	li_year = li_year + 100
	ll_numc = al_julian / ll_cent
	li_year = li_year + ll_numc * 100
	al_julian -= (ll_numc * ll_cent)
	ll_numc ++
end if

if ll_numc > 0 and al_julian > ll_quad - 1 then
	al_julian -= (ll_quad - 1)
	li_year = li_year + 4
end if

ll_numq = al_julian / ll_quad
li_year = li_year + ll_numq * 4
al_julian -= (ll_numq * ll_quad)

if of_isleapyear(date(li_year,1,1)) then

	if al_julian >= 366 then
		al_julian -= 366
		li_year ++
	else

		if al_julian = 59 then
			li_month = 2
			li_day = 29
			return date(li_year,li_month,li_day)
		else

			if al_julian > 59 then
				al_julian --
			end if

		end if

	end if

end if

do while al_julian >= 365
	al_julian -= 365
	li_year ++
loop

li_month = 0

do while li_daysinmonth[li_month + 1] <= al_julian
	al_julian -= li_daysinmonth[li_month + 1]
	li_month ++
loop

li_month ++
li_day = al_julian + 1
return date(li_year,li_month,li_day)
end function

public function long of_hours (long al_seconds);long ll_result
long ll_null

if isnull(al_seconds) then
	setnull(ll_null)
	return ll_null
end if

if al_seconds < 0 then
	return -1
end if

ll_result = al_seconds / 3600
return ll_result
end function

public function boolean of_isleapyear (date ad_source);integer li_year
boolean lb_null = false

setnull(lb_null)

if isnull(ad_source) then
	return lb_null
end if

if not of_isvalid(ad_source) then
	return lb_null
end if

li_year = integer(string(ad_source,"yyyy"))

if ((mod(li_year,4) = 0 and mod(li_year,100) <> 0) or (mod(li_year,400) = 0)) then
	return true
end if

return false
end function

public function boolean of_isvalid (date ad_source);date ldt_invalid
integer li_year
integer li_month
integer li_day
boolean ret = false

ldt_invalid = date("50/50/1900")
li_year = year(ad_source)
li_month = month(ad_source)
li_day = day(ad_source)

if ((((isnull(ad_source)) or (isnull(li_year))) or (isnull(li_month))) or (isnull(li_day))) then
	return false
end if

if ((((string(ad_source,"dd.mm.yyyy") = string(ldt_invalid,"dd.mm.yyyy")) or (li_year <= 0)) or (li_month <= 0)) or (li_day <= 0)) then
	return false
end if

return true
end function

public function boolean of_isvalid (datetime adtm_source);date ldt_value
date ldt_invalid

if isnull(adtm_source) then
	return false
end if

ldt_value = date(adtm_source)

if not of_isvalid(ldt_value) then
	return false
end if

return true
end function

public function boolean of_isvalid (time atm_source);integer li_hour
integer li_minute
integer li_second

li_hour = hour(atm_source)
li_minute = minute(atm_source)
li_second = second(atm_source)

if ((((isnull(atm_source)) or (isnull(li_hour))) or (isnull(li_minute))) or (isnull(li_second))) then
	return false
end if

if (((li_hour < 0) or (li_minute < 0)) or (li_second < 0)) then
	return false
end if

return true
end function

public function boolean of_isweekday (date ad_source);boolean lb_null = false

if ((isnull(ad_source)) or ( not of_isvalid(ad_source))) then
	setnull(lb_null)
	return lb_null
end if

if daynumber(ad_source) > 1 and daynumber(ad_source) < 7 then
	return true
end if

return false
end function

public function boolean of_isweekend (date ad_source);boolean lb_null = false

if ((isnull(ad_source)) or ( not of_isvalid(ad_source))) then
	setnull(lb_null)
	return lb_null
end if

return  not of_isweekday(ad_source)
end function

public function long of_julian (date ad_source);long ll_null

if isnull(ad_source) then
	setnull(ll_null)
	return ll_null
end if

if not of_isvalid(ad_source) then
	return -1
end if

return daysafter(date(0,1,1),ad_source)
end function

public function long of_juliandaynumber (date ad_source);long ll_null

if isnull(ad_source) then
	setnull(ll_null)
	return ll_null
end if

if not of_isvalid(ad_source) then
	return -1
end if

return daysafter(date(year(ad_source) - 1,12,31),ad_source)
end function

public function date of_lastdayofmonth (date ad_source);integer li_year
integer li_month
integer li_day
boolean ret = false
date ldt_null

if isnull(ad_source) then
	setnull(ldt_null)
	return ldt_null
end if

if not of_isvalid(ad_source) then
	return ad_source
end if

li_year = year(ad_source)
li_month = month(ad_source)
li_day = 31
ret = of_isvalid(date(li_year,li_month,li_day))

do while ( not ret) and li_day > 0
	li_day --
	ret = of_isvalid(date(li_year,li_month,li_day))
loop

return date(li_year,li_month,li_day)
end function

public function long of_millisecsafter (time atm_start,time atm_end);long ll_start
long ll_end
long ll_temp
long ll_null

if ((isnull(atm_start)) or (isnull(atm_end))) then
	setnull(ll_null)
	return ll_null
end if

ll_start = long(string(atm_start,"fff"))
ll_temp = second(atm_start) * 1000
ll_start = ll_start + ll_temp
ll_temp = minute(atm_start) * 60000
ll_start = ll_start + ll_temp
ll_temp = hour(atm_start) * 3600000
ll_start = ll_start + ll_temp
ll_end = long(string(atm_end,"fff"))
ll_temp = second(atm_end) * 1000
ll_end = ll_end + ll_temp
ll_temp = minute(atm_end) * 60000
ll_end = ll_end + ll_temp
ll_temp = hour(atm_end) * 3600000
ll_end = ll_end + ll_temp
return (ll_end - ll_start)
end function

public function string of_monthname (date ad_source);if isnull(ad_source) then
	return "!"
end if

if not of_isvalid(ad_source) then
	return "!"
end if

return of_monthname(month(ad_source))
end function

public function string of_monthname (integer ai_monthnumber);if (((isnull(ai_monthnumber)) or (ai_monthnumber < 0)) or (ai_monthnumber > 12)) then
	return "!"
end if

return is_month[ai_monthnumber]
end function

public function long of_monthsafter (date ad_start,date ad_end);date ld_temp
integer li_year
integer li_month
integer li_mult
double adb_start
double adb_end
long ll_null

if ((((isnull(ad_start)) or (isnull(ad_end))) or ( not of_isvalid(ad_start))) or ( not of_isvalid(ad_end))) then
	setnull(ll_null)
	return ll_null
end if

if ad_start > ad_end then
	ld_temp = ad_start
	ad_start = ad_end
	ad_end = ld_temp
	li_mult = -1
else
	li_mult = 1
end if

li_month = (year(ad_end) - year(ad_start)) * 12
li_month = li_month + month(ad_end) - month(ad_start)

if day(ad_start) > day(ad_end) then
	li_month --
end if

return (li_month * li_mult)
end function

public function datetime of_relativedatetime (datetime adtm_start,long al_offset);datetime ldt_null
date ld_sdate
time lt_stime
long ll_date_adjust
long ll_time_adjust
long ll_time_test

if ((isnull(adtm_start)) or (isnull(al_offset))) then
	setnull(ldt_null)
	return ldt_null
end if

if not of_isvalid(adtm_start) then
	return ldt_null
end if

ld_sdate = date(adtm_start)
lt_stime = time(adtm_start)
ll_date_adjust = al_offset / 86400
ll_time_adjust = mod(al_offset,86400)
ld_sdate = relativedate(ld_sdate,ll_date_adjust)

if ll_time_adjust > 0 then
	ll_time_test = secondsafter(lt_stime,time("23:59:59"))

	if ll_time_test < ll_time_adjust then
		ld_sdate = relativedate(ld_sdate,1)
		ll_time_adjust = ll_time_adjust - ll_time_test - 1
		lt_stime = time("00:00:00")
	end if

	lt_stime = relativetime(lt_stime,ll_time_adjust)
else

	if ll_time_adjust < 0 then
		ll_time_test = secondsafter(lt_stime,time("00:00:00"))

		if ll_time_test > ll_time_adjust then
			ld_sdate = relativedate(ld_sdate,-1)
			ll_time_adjust = ll_time_adjust - ll_time_test + 1
			lt_stime = time("23:59:59")
		end if

		lt_stime = relativetime(lt_stime,ll_time_adjust)
	end if

end if

return datetime(ld_sdate,lt_stime)
end function

public function date of_relativemonth (date ad_source,long al_month);integer li_adjust_months
integer li_adjust_years
integer li_month
integer li_year
integer li_day
integer li_temp_month
date ldt_null

if ((isnull(ad_source)) or (isnull(al_month))) then
	setnull(ldt_null)
	return ldt_null
end if

if not of_isvalid(ad_source) then
	return ad_source
end if

li_adjust_months = mod(al_month,12)
li_adjust_years = al_month / 12
li_temp_month = month(ad_source) + li_adjust_months

if li_temp_month > 12 then
	li_month = li_temp_month - 12
	li_adjust_years ++
else

	if li_temp_month <= 0 then
		li_month = li_temp_month + 12
		li_adjust_years --
	else
		li_month = li_temp_month
	end if

end if

li_year = year(ad_source) + li_adjust_years
li_day = day(ad_source)

do while ( not of_isvalid(date(li_year,li_month,li_day))) and li_day > 0
	li_day --
loop

return date(li_year,li_month,li_day)
end function

public function date of_relativeyear (date ad_source,long al_years);integer li_year
integer li_month
integer li_day
date ldt_null

if ((isnull(ad_source)) or (isnull(al_years))) then
	setnull(ldt_null)
	return ldt_null
end if

if not of_isvalid(ad_source) then
	return ad_source
end if

li_year = year(ad_source) + al_years
li_month = month(ad_source)
li_day = day(ad_source)

do while ( not of_isvalid(date(li_year,li_month,li_day))) and li_day > 0
	li_day --
loop

return date(li_year,li_month,li_day)
end function

public function long of_secondsafter (datetime adtm_start,datetime adtm_end);long ll_total_seconds
long ll_day_adjust
date ld_sdate
date ld_edate
time lt_stime
time lt_etime
long ll_null

if ((((isnull(adtm_start)) or (isnull(adtm_end))) or ( not of_isvalid(adtm_start))) or ( not of_isvalid(adtm_end))) then
	setnull(ll_null)
	return ll_null
end if

ld_sdate = date(adtm_start)
ld_edate = date(adtm_end)
lt_stime = time(adtm_start)
lt_etime = time(adtm_end)

if ld_sdate = ld_edate then
	ll_total_seconds = secondsafter(lt_stime,lt_etime)
else

	if ld_sdate < ld_edate then
		ll_total_seconds = secondsafter(lt_stime,time("23:59:59"))
		ll_day_adjust = daysafter(ld_sdate,ld_edate) - 1

		if ll_day_adjust > 0 then
			ll_total_seconds = ll_total_seconds + 86400 * ll_day_adjust
		end if

		ll_total_seconds = ll_total_seconds + secondsafter(time("00:00:00"),lt_etime) + 1
	else
		ll_total_seconds = secondsafter(lt_stime,time("00:00:00"))
		ll_day_adjust = daysafter(ld_sdate,ld_edate) + 1

		if ll_day_adjust < 0 then
			ll_total_seconds = ll_total_seconds + 86400 * ll_day_adjust
		end if

		ll_total_seconds = ll_total_seconds + secondsafter(time("23:59:59"),lt_etime) - 1
	end if

end if

return ll_total_seconds
end function

public function integer of_wait (datetime adtm_target);date ldt_value
long ll_null

if isnull(adtm_target) then
	setnull(ll_null)
	return ll_null
end if

ldt_value = date(adtm_target)

if not of_isvalid(ldt_value) then
	return -1
end if

do until datetime(today(),now()) >= adtm_target
	yield()
loop

return 1
end function

public function integer of_wait (ulong al_seconds);datetime ldtm_target
integer li_ret

if isnull(al_seconds) then
	return al_seconds
end if

if al_seconds <= 0 then
	return -1
end if

ldtm_target = of_relativedatetime(datetime(today(),now()),al_seconds)
li_ret = of_wait(ldtm_target)
return li_ret
end function

public function long of_weeknumber (date ad_source);date ld_first_ofyear
integer li_weeknumber
integer li_leftover_days
integer li_dayofweek
long ll_null

if isnull(ad_source) then
	setnull(ll_null)
	return ll_null
end if

if not of_isvalid(ad_source) then
	return -1
end if

ld_first_ofyear = date(year(ad_source),1,1)
li_weeknumber = of_weeksafter(ld_first_ofyear,ad_source) + 1
li_leftover_days = mod(daysafter(ld_first_ofyear,ad_source),7)

if of_dayofweek(ld_first_ofyear) + li_leftover_days >= 8 then
	li_weeknumber ++
end if

return li_weeknumber
end function

public function long of_weeksafter (date ad_start,date ad_end);long ll_null

if ((((isnull(ad_start)) or (isnull(ad_end))) or ( not of_isvalid(ad_start))) or ( not of_isvalid(ad_end))) then
	setnull(ll_null)
	return ll_null
end if

return (daysafter(ad_start,ad_end) / 7)
end function

public function long of_yearsafter (date ad_start,date ad_end);date ld_temp
integer li_year
integer li_mult
double adb_start
double adb_end
long ll_null

if ((((isnull(ad_start)) or (isnull(ad_end))) or ( not of_isvalid(ad_start))) or ( not of_isvalid(ad_end))) then
	setnull(ll_null)
	return ll_null
end if

if ad_start > ad_end then
	ld_temp = ad_start
	ad_start = ad_end
	ad_end = ld_temp
	li_mult = -1
else
	li_mult = 1
end if

li_year = year(ad_end) - year(ad_start)
adb_start = month(ad_start)
adb_start = adb_start + day(ad_start) / 100
adb_end = month(ad_end)
adb_end = adb_end + day(ad_end) / 100

if adb_start > adb_end then
	li_year --
end if

return (li_year * li_mult)
end function

on n_dwr_datetime.create
triggerevent("constructor")
end on

on n_dwr_datetime.destroy
triggerevent("destructor")
end on

