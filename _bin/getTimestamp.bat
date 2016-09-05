@if (@X)==(@Y) @end  /* harmless hybrid line that begins a JScript comment
@goto :batch
::
::getTimestamp.bat version 2.6 by Dave Benham
::
::  Release History:
::    2.6 2016-07-10 - Added -OLM and -OLD to allow addition of months/years
::                     without changing the local hour. In other words, the
::                     computation compensates for changes in dayling savings
::                     conditions.
::    2.5 2016-07-09 - Fixed bug with offset computations when the before and
::                     after have different time zones due to daylight savings.
::    2.4 2015-11-27 - Added formats to support comma as decimal mark in
::                     ISO 8601 time and timestamp formats.
::                     Added formats to support ISO 8601 week dates
::                     and ordinal dates.
::                     Rearranged documentation, and added examples for
::                     base date specified as a list of numeric values.
::    2.3 2015-07-11 - Added {ISO-xx}, {ISOxx}, {DY} and {DDY} formats
::                     Added -?? (paged help) option
::                     Allow user defined default option values by defining
::                     variables of the form "GetTimestamp-OPTION=VALUE"
::    2.2 2014-12-03 - Doc fix: -R ReturnVariable is unchanged if err occurs
::    2.1 2014-12-03 - Added GOTO at top to increase performance (32% faster)
::    2.0 2014-12-02 - Major rewrite: most code now in JScript (25% faster)
::                     Better error handling
::                     May now use /Option or -Option
::                     Added -V option
::                     Added {{} format value to enable unambiguous { literal
::    1.1 ????-??-?? - Added -Z option and obscure bug fixes
::    1.0 2013-07-17 - Initial release
::
::============ Documentation ===========
:::
:::getTimestamp  [-option [value]]...
:::
:::  Displays a formatted timestamp. Defaults to the current local date
:::  and time using an ISO 8601 format with milliseconds, time zone
:::  and punctuation, using period as a decimal mark.
:::
:::  Returned ERRORLEVEL is 0 upon success, 1 if failure.
:::
:::  Options may be prefaced with - or /
:::
:::  All options have default values. The default value can be overridden by
:::  defining an evironment variable of the form "GetTimestamp-OPTION=VALUE".
:::  For example, upper case English weekday abbreviations can be specified as
:::  the default by defining "GetTimestamp-WKD=SUN MON TUE WED THU FRI SAT".
:::
:::  Command line option values take precedence, followed by environment variable
:::  defaults, followed by built in defaults.
:::
:::  The following options are all case insensitive:
:::
:::    -?  : Prints this documentation for getTimestamp
:::
:::    -?? : Prints this documentation with pagination via MORE
:::
:::    -V  : Prints the version of getTimeStamp
:::
:::    -D DateSpec
:::
:::       Specify the base date and time.
:::       Default value is current local date and time.
:::       The DateSpec supports many formats:
:::
:::         ""    (no value)
:::
:::           Current date and time - the default
:::
:::         milliseconds
:::
:::           A JScript numeric expression that represents the number of
:::           milliseconds since 1970-01-01 00:00:00 UTC.
:::           Decimal values are truncated.
:::           Negative values represent dates prior to 1970-01-01.
:::
:::         "'Date [Time] [TimeZone]'"
:::
:::           A string representation of the date and time. The date information
:::           is required, the time and time zone are optional. Missing time info
:::           is assumed to be 0 (midnight). Missing time zone info is assumed to
:::           be local time zone.
:::
:::           The Date, Time, and TimeZone information can be represented as any
:::           string that is accepted by the JScript Date.Parse() method.
:::           There are many formatting options. Documentation is available at:
:::           http://msdn.microsoft.com/en-us/library/k4w173wk(v=vs.84).aspx
:::
:::           Examples of equivalent representations of Midnight on January 4,
:::           2013 assuming local time zone is U.S Eastern Standard Time (EST):
:::
:::             '1-4-2013'                    Defaults to local time zone
:::             "'January 4, 2013 EST'"       Explicit Eastern Std Time (US)
:::             "'2013/1/4 -05'"              Explicit Eastern Std Time (US)
:::             "'Jan 3 2013 23: CST'"        Central Standard Time (US)
:::             "'2013 3 Jan 9:00 pm -0800'"  Pacific Standard Time (US)
:::             "'01/04/2013 05:00:00 UTC'"   Universal Coordinated Time
:::             "'1/4/2013 05:30 +0530'"      India Standard Time
:::
:::         "year, month[, day[, hour[, minute[, second[, millisecond]]]]]"
:::
:::           A comma delimited list of numeric JScript expressions representing
:::           various components of date and time. Year and month are required,
:::           the rest are optional. Missing values are treated as 0.
:::           Decimal values are truncated. A 0 month represents January.
:::           A 1 day represents the first day of the month. A 0 day represents
:::           the last day of the prior month. The date/time value is always
:::           in local time. There is no mechanism to specify a time zone.
:::
:::           Examples: (all in local time)
:::             "2012,0,1,12,45,3,121"  12:45:03.121 on Jan 1, 2012
:::             "2012,0,1,12"           Noon on Jan 1, 2012
:::             "2012,1,1"              Midnight on Feb 1, 2012
:::             "2012,2,0"              Midnight on Feb 29, 2012 (last day of Feb)
:::             "2012,2"                Midnight on Feb 29, 2012 (last day of Feb)
:::
:::           The ability to use JScript expressions makes it convenient to do
:::           date and time offset computations in a very compact form.
:::
:::           For example, starting with:
:::             "2015,8,7,14,5"        Sep 7, 2015 at 14:05:00
:::
:::           It is simple to subtract 30 days and 30 minutes from the above:
:::             "2015,8,7-30,14,5-30"  Aug 8, 2015 at 13:35:00
:::
:::    -U  : Returns a UTC timestamp instead of local timestamp.
:::          Default is a local timestamp.
:::
:::    -Z TimeZoneMinuteOffset
:::
:::       Returns the timestamp using the specified time zone offset.
:::       TimeZoneMinuteOffset is a JScript numeric expression that
:::       represents the number of minutes offset from UTC.
:::       Decimal values are truncated.
:::       Default is empty, meaning local timezone.
:::
:::    -OY YearOffset
:::
:::       Specify the number of years to offset the base date/time.
:::       The JScript numeric expression is truncated to an integral number.
:::       Default is 0
:::
:::    -OM MonthOffset
:::
:::       Specify the number of months to offset the base date/time, ignoring
:::       local daylight savings conditions. The change is guaranteed to be a
:::       multiple of 24 hours. The JScript numeric expression is truncated to
:::       an integral number. Default is 0
:::
:::    -OLM LocalMonthOffset
:::
:::       Specify the number of months to offset the base date/time, taking into
:::       account local daylight savings conditions. The change may not be a
:::       multiple of 24 hours if the offset results in a change from standard
:::       to daylight savings, or vice versa. The JScript numeric expression is
:::       truncated to an integral number. Default is 0
:::
:::    -OD DayOffset
:::
:::       Specify the number of days to offset the base date/time, ignoring
:::       local daylight savings conditions. The change is guaranteed to be a
:::       multiple of 24 hours. The JScript numeric expression is truncated to
:::       an integral number. Default is 0
:::
:::    -OLD LocalDayOffset
:::
:::       Specify the number of days to offset the base date/time, taking into
:::       account local daylight savings conditions. The change may not be a
:::       multiple of 24 hours if the offset results in a change from standard
:::       to daylight savings, or vice versa. The JScript numeric expression is
:::       truncated to an integral number. Default is 0
:::
:::    -OH HourOffset
:::
:::       Specify the number of hours to offset the base date/time.
:::       The JScript numeric expression is truncated to an integral number.
:::       Default is 0
:::
:::    -ON MinuteOffset
:::
:::       Specify the number of minutes to offset the base date/time.
:::       The JScript numeric expression is truncated to an integral number.
:::       Default is 0
:::
:::    -OS SecondOffset
:::
:::       Specify the number of seconds to offset the base date/time.
:::       The JScript numeric expression is truncated to an integral number.
:::       Default is 0
:::
:::    -OF MillisecondOffset
:::
:::       Specify the number of milliseconds to offset the base date/time.
:::       The JScript numeric expression is truncated to an integral number.
:::       Default is 0
:::
:::    -F FormatString
:::
:::       Specify the timestamp format.
:::       Default is "{ISO-TS.}"
:::       Strings within braces are dynamic components.
:::       All other strings are literals.
:::       Available components (case insensitive) are:
:::
:::         {YYYY}  4 digit year, zero padded
:::
:::         {YY}    2 digit year, zero padded
:::
:::         {Y}     year without zero padding
:::
:::         {MONTH} month name, as preferentially specified by:
:::                    1) -MONTH option
:::                    2) GetTimestamp-MONTH environment variable
:::                    3) Mixed case, English month names
:::
:::         {MTH}   month abbreviation, as preferentially specified by:
:::                    1) -MTH option
:::                    2) GetTimestamp-MTH environment variable
:::                    3) Mixed case, English month abbreviations
:::
:::         {MM}    2 digit month number, zero padded
:::
:::         {M}     month number without zero padding
:::
:::         {WEEKDAY} day of week name, as preferentially specified by:
:::                    1) -WEEKDAY option
:::                    2) GetTimestamp-WEEKDAY environment variable
:::                    3) Mixed case, English day names
:::
:::         {WKD}   day of week abbreviation, as preferentially specified by:
:::                    1) -WKD option
:::                    2) GetTimestamp-WKD environment variable
:::                    3) Mixed case, English day abbreviations
:::
:::         {W}     day of week number: 0=Sunday, 6=Saturday
:::
:::         {DD}    2 digit day of month number, zero padded
:::
:::         {D}     day of month number, without zero padding
:::
:::         {DDY}   3 digit day of year number, zero padded
:::
:::         {DY}    day of year number, without zero padding
:::
:::         {HH}    2 digit hours, 24 hour format, zero padded
:::
:::         {H}     hours, 24 hour format without zero padding
:::
:::         {HH12}  2 digit hours, 12 hour format, zero padded
:::
:::         {H12}   hours, 12 hour format without zero padding
:::
:::         {NN}    2 digit minutes, zero padded
:::
:::         {N}     minutes without padding
:::
:::         {SS}    2 digit seconds, zero padded
:::
:::         {S}     seconds without padding
:::
:::         {FFF}   3 digit milliseconds, zero padded
:::
:::         {F}     milliseconds without padding
:::
:::         {AM}    AM or PM in upper case
:::
:::         {PM}    am or pm in lower case
:::
:::         {ZZZZ}  timezone expressed as minutes offset from UTC,
:::                 zero padded to 3 digits with sign
:::
:::         {Z}     timzone expressed as minutes offset from UTC without padding
:::
:::         {ZS}    ISO 8601 timezone sign
:::
:::         {ZH}    ISO 8601 timezone hours (no sign)
:::
:::         {ZM}    ISO 8601 timezone minutes (no sign)
:::
:::         {TZ}    ISO 8601 timezone in +/-hh:mm format
:::
:::         {ISOTS}  same as {ISOTS.}
:::
:::         {ISOTS.} YYYYMMDDThhmmss.fff+hhss
:::                  Compressed ISO 8601 date/time (timestamp) with milliseconds
:::                  and time zone, using . as decimal mark
:::
:::         {ISOTS,} YYYYMMDDThhmmss,fff+hhss
:::                  Compressed ISO 8601 date/time (timestamp) with milliseconds
:::                  and time zone, using , as decimal mark
:::
:::         {ISODT}  YYYYMMDD
:::                  Compressed ISO 8601 date format
:::
:::         {ISOTM}  same as {ISOTM.}
:::
:::         {ISOTM.} hhmmss.fff
:::                  Compressed ISO 8601 time format with milliseconds,
:::                  using . as decimal mark
:::
:::         {ISOTM,} hhmmss,fff
:::                  Compressed ISO 8601 time format with milliseconds,
:::                  using , as decimal mark
:::
:::         {ISOTZ}  +hhmm
:::                  Compressed ISO 8601 timezone format
:::
:::         {ISOWY}  yyyy
:::                  ISO 8601 week numbering year
:::                  Dec 29, 30, or 31 may belong to the next Jan year
:::                  Jan 01, 02, or 03 may belong to the prior Dec year
:::
:::         {ISOWK}  ww
:::                  ISO 8601 week number
:::                  Week 01 is the week with the year's first Thursday
:::
:::         {ISOWD}  d
:::                  ISO 8601 day of week: 1=Monday, 7=Sunday
:::
:::         {ISODTW} yyyyWwwd
:::                  Compressed ISO 8601 week date format
:::
:::         {ISODTO} YYYYDDD
:::                  Compressed ISO 8601 ordinal date format
:::
:::         {ISO-TS} same as {ISO-TS.}
:::
:::         {ISO-TS.} YYYY-MM-DDThh:mm:ss.fff+hh:ss
:::                  ISO 8601 date/time (timestamp) with milliseconds and time zone
:::                  using . as decimal mark
:::
:::         {ISO-TS,} YYYY-MM-DDThh:mm:ss,fff+hh:ss
:::                  ISO 8601 date/time (timestamp) with milliseconds and time zone
:::                  using , as decimal mark
:::
:::         {ISO-DT} YYYY-MM-DD
:::                  ISO 8601 date format
:::
:::         {ISO-TM} same as {ISO-TM.}
:::
:::         {ISO-TM.} hh:mm:ss.fff
:::                  ISO 8601 time format with milliseconds,
:::                  using . as decimal mark
:::
:::         {ISO-TM,} hh:mm:ss,fff
:::                  ISO 8601 time format with milliseconds,
:::                  using , as decimal mark
:::
:::         {ISO-TZ} +hh:mm
:::                  ISO 8601 timezone  (same as {TZ})
:::
:::         {ISO-DTW} yyyy-Www-d
:::                  ISO 8601 week date format
:::
:::         {ISO-DTO} YYYY-DDD
:::                  ISO 8601 ordinal date format
:::
:::         {UMS}   Milliseconds since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {U}     Same as {US}
:::
:::         {US}    Seconds since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {UM}    Minutes since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {UH}    Hours since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {UD}    Days since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {USD}   Decimal seconds since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {UMD}   Decimal minutes since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {UHD}   Decimal hours since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {UDD}   Decimal days since 1970-01-01 00:00:00.000 UTC.
:::                 Negative numbers represent days prior to 1970-01-01.
:::                 This value is unaffected by the -U option.
:::                 This value should not be used with the -Z option
:::
:::         {{}     A { character
:::
:::    -R ReturnVariable
:::
:::       Save the timestamp in ReturnVariable instead of displaying it.
:::       ReturnVariable is unchanged if an error occurs.
:::       Default is empty, meaning print to screen.
:::
:::    -WKD "Abbreviated day of week list"
:::
:::       Override the default day abbreviations with a space delimited,
:::       quoted list, starting with Sun.
:::       Default is mixed case, 3 character English day abbreviations.
:::
:::    -WEEKDAY "Day of week list"
:::
:::       Override the default day names with a space delimited, quoted list,
:::       starting with Sunday.
:::       Default is mixed case English day names.
:::
:::    -MTH "Abbreviated month list"
:::
:::       Override the default month abbreviations with a space delimited,
:::       quoted list, starting with Jan.
:::       Default is mixed case, 3 character English month abbreviations.
:::
:::    -MONTH "Month list"
:::
:::       Override the default month names with a space delimited, quoted list,
:::       starting with January.
:::       Default is mixed case English month names.
:::
:::
:::  GetTimestamp.bat was written by Dave Benham and originally posted at
:::  http://www.dostips.com/forum/viewtopic.php?f=3&t=4847
:::

============= :Batch portion ===========
@echo off
setlocal enableDelayedExpansion

:: Define options
set ^"options=^
 -?:^
 -??:^
 -v:^
 -u:^
 -z:""^
 -f:"{ISO-TS}"^
 -d:""^
 -oy:""^
 -om:""^
 -od:""^
 -oh:""^
 -on:""^
 -os:""^
 -of:""^
 -olm:""^
 -old:""^
 -r:""^
 -wkd:"Sun Mon Tue Wed Thu Fri Sat"^
 -weekday:"Sunday Monday Tuesday Wednesday Thursday Friday Saturday"^
 -mth:"Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"^
 -month:"January February March April May June July August September October November December"^"

:: Set default option values
for %%O in (%options%) do for /f "tokens=1,* delims=:" %%A in ("%%O") do (
  if defined GetTimestamp%%A (set "%%A=!GetTimestamp%%A!") else set "%%A=%%~B"
)
set "-?="
set "-??="

:: Get options
:loop
if not "%~1"=="" (
  set "arg=%~1"
  if "!arg:~0,1!" equ "/" set "arg=-!arg:~1!"
  for /f delims^=^ eol^= %%A in ("!arg!") do set "test=!options:*%%A:=! "
  if "!test!"=="!options! " (
      >&2 echo Error: Invalid option %~1. Use %~nx0 -? to get help.
      exit /b 1
  ) else if "!test:~0,1!"==" " (
      set "!arg!=1"
      if /i "!arg!" equ "-U" set "-z="
  ) else (
      set "!arg!=%~2"
      shift /1
  )
  shift /1
  goto :loop
)
if defined -z set "-u=1"
if defined -r set "%-r%="

:: Display paged help
if defined -?? (
  (for /f "delims=: tokens=*" %%A in ('findstr "^:::" "%~f0"') do @echo(%%A)|more /e
  exit /b 0
) 2>nul

:: Display help
if defined -? (
  for /f "delims=: tokens=*" %%A in ('findstr "^:::" "%~f0"') do echo(%%A
  exit /b 0
)

:: Display version
if defined -v (
  for /f "tokens=* delims=:" %%A in ('findstr "^::getTimestamp\.bat" "%~f0"') do @echo(%%A
  exit /b 0
)

:: Execute the JScript script and return the result
for /f "delims=" %%A in ('cscript //E:JScript //nologo "%~f0"') do (
  endlocal
  if "%-R%" neq "" (set "%-R%=%%A") else (echo(%%A)
  exit /b 0
)
exit /b 1;


************ JScript portion ***********/
var env  = WScript.CreateObject("WScript.Shell").Environment("Process"),
    utc  = env('-U'),
    wkd     = env('-WKD').split(' '),
    weekday = env('-WEEKDAY').split(' '),
    mth     = env('-MTH').split(' '),
    month   = env('-MONTH').split(' '),
    stderr  = WScript.StdErr,
    y,m,d,w,h,h12,n,s,f,u,z,zs,za,
    pc=':', pcm=',', pd='-', pp='.', p2='00', p3='000', p4='0000';

if (wkd.length!=7)     badOp('-WKD');
if (weekday.length!=7) badOp('-WEEKDAY');
if (mth.length!=12)    badOp('-MTH');
if (month.length!=12)  badOp('-MONTH');

try {
  var dt = eval('new Date('+env('-D')+')');
} catch(e) {
} finally {
  if (isNaN(dt)) badOp('-D');
}

if (env('-OY')) dt.setUTCFullYear(     dt.getUTCFullYear()    +getNum('-OY') );
if (env('-OM')) dt.setUTCMonth(        dt.getUTCMonth()       +getNum('-OM') );
if (env('-OD')) dt.setUTCDate(         dt.getUTCDate()        +getNum('-OD') );
if (env('-OH')) dt.setUTCHours(        dt.getUTCHours()       +getNum('-OH') );
if (env('-ON')) dt.setUTCMinutes(      dt.getUTCMinutes()     +getNum('-ON') );
if (env('-OS')) dt.setUTCSeconds(      dt.getUTCSeconds()     +getNum('-OS') );
if (env('-OF')) dt.setUTCMilliseconds( dt.getUTCMilliseconds()+getNum('-OF') );
if (env('-Z'))  dt.setUTCMinutes(      dt.getUTCMinutes()  +(z=getNum('-Z')) );

if (env('-OLM')) dt.setMonth(        dt.getMonth()       +getNum('-OLM') );
if (env('-OLD')) dt.setDate(         dt.getDate()        +getNum('-OLD') );

y = utc ? dt.getUTCFullYear(): dt.getFullYear();
m = utc ? dt.getUTCMonth()   : dt.getMonth();
d = utc ? dt.getUTCDate()    : dt.getDate();
w = utc ? dt.getUTCDay()     : dt.getDay();
h = utc ? dt.getUTCHours()   : dt.getHours();
n = utc ? dt.getUTCMinutes() : dt.getMinutes();
s = utc ? dt.getUTCSeconds() : dt.getSeconds();
f = utc ? dt.getUTCMilliseconds() : dt.getMilliseconds();
u = dt.getTime();

h12 = h%12;
if (!h12) h12=12;

if (z==undefined) if (utc) z=0; else z=-dt.getTimezoneOffset();
zs = z<0 ? '-' : '+';
za = Math.abs(z);

WScript.echo( env('-F').replace( /\{(.*?)\}/gi, repl ) );
WScript.Quit(0);

function lpad( val, pad ) {
  var rtn=val.toString();
  return (rtn.length<pad.length) ? (pad+rtn).slice(-pad.length) : val;
}

function getNum( v ) {
  var rtn;
  try {
    rtn = Number(eval(env(v)));
  } catch(e) {
  } finally {
    if (isNaN(rtn-rtn)) badOp(v);
    return rtn;
  }
}

function badOp(option) {
  stderr.WriteLine('Error: Invalid '+option+' value');
  WScript.Quit(1);
}

function trunc( n ) { return Math[n>0?"floor":"ceil"](n); }

function weekNum(dt) {
   var dt2 = new Date(dt.valueOf());
   var day = (dt.getDay()+6)%7;
   dt2.setDate(dt2.getDate()-day+3);
   var now = dt2.valueOf();
   dt2.setMonth(0, 1);
   if (dt2.getDay() != 4) {
      dt2.setMonth( 0, (11-dt2.getDay())%7 + 1 );
   }
   return 1 + Math.ceil((now-dt2.valueOf())/604800000);
}

function weekYr(dt) {
   var dt2 = new Date(dt.valueOf());
   dt2.setDate(dt2.getDate()+3-(dt.getDay()+6)%7);
   return dt2.getFullYear();
}

function repl($0,$1) {
  switch ($1.toUpperCase()) {
    case 'YYYY' : return lpad(y,p4);
    case 'YY'   : return (p2+y.toString()).slice(-2);
    case 'Y'    : return y.toString();
    case 'MM'   : return lpad(m+1,p2);
    case 'M'    : return (m+1).toString();
    case 'DD'   : return lpad(d,p2);
    case 'D'    : return d.toString();
    case 'W'    : return w.toString();
    case 'DY'   : return trunc(((new Date(y,m,d)).getTime()-(new Date(y,0,0)).getTime())/86400000).toString();
    case 'DDY'  : return lpad( trunc(((new Date(y,m,d)).getTime()-(new Date(y,0,0)).getTime())/86400000), p3);
    case 'HH'   : return lpad(h,p2);
    case 'H'    : return h.toString();
    case 'HH12' : return lpad(h12,p2);
    case 'H12'  : return h12.toString();
    case 'NN'   : return lpad(n,p2);
    case 'N'    : return n.toString();
    case 'SS'   : return lpad(s,p2);
    case 'S'    : return s.toString();
    case 'FFF'  : return lpad(f,p3);
    case 'F'    : return f.toString();
    case 'AM'   : return h>=12 ? 'PM' : 'AM';
    case 'PM'   : return h>=12 ? 'pm' : 'am';
    case 'UMS'  : return u.toString();
    case 'USD'  : return (u/1000).toString();
    case 'UMD'  : return (u/1000/60).toString();
    case 'UHD'  : return (u/1000/60/60).toString();
    case 'UDD'  : return (u/1000/60/60/24).toString();
    case 'U'    :
    case 'US'   : return trunc(u/1000).toString();
    case 'UM'   : return trunc(u/1000/60).toString();
    case 'UH'   : return trunc(u/1000/60/60).toString();
    case 'UD'   : return trunc(u/1000/60/60/24).toString();
    case 'ZZZZ' : return zs+lpad(za,p3);
    case 'Z'    : return z.toString();
    case 'ZS'   : return zs;
    case 'ZH'   : return lpad(trunc(za/60),p2);
    case 'ZM'   : return lpad(za%60,p2);
    case 'TZ'   :
    case 'ISO-TZ' : return ''+zs+lpad(trunc(za/60),p2)+pc+lpad(za%60,p2);
    case 'ISOTS'  :
    case 'ISOTS.' : return ''+lpad(y,p4)+lpad(m+1,p2)+lpad(d,p2)+'T'+lpad(h,p2)+lpad(n,p2)+lpad(s,p2)+pp+lpad(f,p3)+zs+lpad(trunc(za/60),p2)+lpad(za%60,p2);
    case 'ISOTS,' : return ''+lpad(y,p4)+lpad(m+1,p2)+lpad(d,p2)+'T'+lpad(h,p2)+lpad(n,p2)+lpad(s,p2)+pcm+lpad(f,p3)+zs+lpad(trunc(za/60),p2)+lpad(za%60,p2);
    case 'ISODT'  : return ''+lpad(y,p4)+lpad(m+1,p2)+lpad(d,p2);
    case 'ISOTM'  :
    case 'ISOTM.' : return ''+lpad(h,p2)+lpad(n,p2)+lpad(s,p2)+pp+lpad(f,p3);
    case 'ISOTM,' : return ''+lpad(h,p2)+lpad(n,p2)+lpad(s,p2)+pcm+lpad(f,p3);
    case 'ISOTZ'  : return ''+zs+lpad(trunc(za/60),p2)+lpad(za%60,p2);
    case 'ISO-TS' :
    case 'ISO-TS.': return ''+lpad(y,p4)+pd+lpad(m+1,p2)+pd+lpad(d,p2)+'T'+lpad(h,p2)+pc+lpad(n,p2)+pc+lpad(s,p2)+pp+lpad(f,p3)+zs+lpad(trunc(za/60),p2)+pc+lpad(za%60,p2);
    case 'ISO-TS,': return ''+lpad(y,p4)+pd+lpad(m+1,p2)+pd+lpad(d,p2)+'T'+lpad(h,p2)+pc+lpad(n,p2)+pc+lpad(s,p2)+pcm+lpad(f,p3)+zs+lpad(trunc(za/60),p2)+pc+lpad(za%60,p2);
    case 'ISO-DT' : return ''+lpad(y,p4)+pd+lpad(m+1,p2)+pd+lpad(d,p2);
    case 'ISO-TM' :
    case 'ISO-TM.': return ''+lpad(h,p2)+pc+lpad(n,p2)+pc+lpad(s,p2)+pp+lpad(f,p3);
    case 'ISO-TM,': return ''+lpad(h,p2)+pc+lpad(n,p2)+pc+lpad(s,p2)+pcm+lpad(f,p3);
    case 'ISOWY'  : return ''+lpad(weekYr(dt),p4);
    case 'ISOWK'  : return ''+lpad(weekNum(dt),p2);
    case 'ISOWD'  : return ''+((w+6)%7+1);
    case 'ISODTW' : return ''+lpad(weekYr(dt),p4)+'W'+lpad(weekNum(dt),p2)+((w+6)%7+1);
    case 'ISODTO' : return ''+lpad(y,p4)+lpad( trunc(((new Date(y,m,d)).getTime()-(new Date(y,0,0)).getTime())/86400000), p3);
    case 'ISO-DTW': return ''+lpad(weekYr(dt),p4)+pd+'W'+lpad(weekNum(dt),p2)+pd+((w+6)%7+1);
    case 'ISO-DTO': return ''+lpad(y,p4)+pd+lpad( trunc(((new Date(y,m,d)).getTime()-(new Date(y,0,0)).getTime())/86400000), p3);
    case 'WEEKDAY': return weekday[w];
    case 'WKD'    : return wkd[w];
    case 'MONTH'  : return month[m];
    case 'MTH'    : return mth[m];
    case '{'      : return $1;
    default       : return $0;
  }
}