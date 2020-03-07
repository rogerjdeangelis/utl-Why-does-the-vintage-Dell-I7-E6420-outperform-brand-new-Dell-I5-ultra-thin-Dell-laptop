Why does the vintage Dell I7 E6420 outperform brand new Dell I5 ultra thin Dell Laptops;

I don't have a Dell I7 ultrathin, I suspect it would have more of a heat problem?
Probably would approch $2,000 - (equivalent to 12 Dell E6420s)

                             Benchmarks
Elapsed
Seconds    Laptops

  123      Vintage Dell I7 E6420 ($85 bare bones - ~$175 enhanced)
  162      Brand new Dell I5 E7470 Ultra-thin   ( $929 see link below)

One caveat, the Dell I5 has more process running in background that I can not turn off?

Heat throttling the CPUs on the newer ultra-thin Dell Laptop is why

Where you can buy the ultathin Dell I5 E7470
https://www.amazon.com/Dell-Latitude-Business-Ultrabook-i5-6300U/dp/B01F7J3AEQ

Running 8 parallell tasks each running  15 consecutive 'proc means' each on 20,000,000 million obs


Elapsed time for one task with 15 consecutive 'proc means'. (8 of these are running)

Consider the first 15 that are running on CPU 1

Elapsed Seconds (1st to 15th proc means)

Means   Vintage E6420    New E7470 Ultrathin
         seconds          seconds

 01       7.03               4.48
 02       7.08               4.81
 03       8.13               5.73   * notice the effect of heat?
 04       7.60               6.89
 05       7.05               9.01
 06       8.72              10.43
 07       8.21              12.45
 08       8.48              13.71
 09       8.68              13.70
 10       9.39              14.31
 11       8.09              14.09
 12       7.66              14.23
 13       8.53              14.11
 14      11.79              12.21
 15       7.08              12.41
        =======            ======
        123.52             162.57

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

There aare eight facility x product groups. I split and run 8 tasks in parallel

Table                      Obs

c:/sd1/m160_11.sas7bdat    20,000,000
c:/sd1/m160_21.sas7bdat    20,000,000
d:/sd1/m160_31.sas7bdat    20,000,000
d:/sd1/m160_41.sas7bdat    20,000,000
d:/sd1/m160_51.sas7bdat    20,000,000
h:/sd1/m160_61.sas7bdat    20,000,000
h:/sd1/m160_71.sas7bdat    20,000,000
h:/sd1/m160_81.sas7bdat    20,000,000
                          ===========
                          160,000,000

libname chd "c:/sd1";
libname dhd "d:/sd1";
libname hhd "e:/sd1";
libname out "c:/sd1";

data chd.m160_1  chd.m160_2 dhd.m160_3 dhd.m160_4 dhd.m160_5 hhd.m160_6 hhd.m160_7 hhd.m160_8;
  length revenue expenses 3.;
  call streaminit(4321);
  do rec=1 to 20000000;
      do facility="A","B";
        do productline="V","W","X","Y";
           grp=cats(facility,productline);
           expenses=int(5*rand('uniform'));
           revenue =int(100*rand('uniform'));
           select (grp);
             when ("AV") output chd.m160_1;
             when ("AW") output chd.m160_2;
             when ("AX") output dhd.m160_3;
             when ("AY") output dhd.m160_4;
             when ("BV") output dhd.m160_5;
             when ("BW") output hhd.m160_6;
             when ("BX") output hhd.m160_7;
             when ("BY") output hhd.m160_8;
           end;
         end;
       end;
    end;
    drop grp rec;
    stop;
run;quit;

/* chd.chd.m160_11 */


One of the 8
c:/sd1/m160_11.sas7bdat total obs=20,000,000 (mutiply by 8)

  Obs       FACILITY    PRODUCTLINE  REVENUE    EXPENSES

    1          A             V          37          3
    2          A             V          95          1
    3          A             V          29          0
    4          A             V          11          2
    5          A             V          16          3
    6          A             V          11          1
    7          A             V          21          4
    8          A             V          78          0

...

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;


Up to 40 obs WORK.RESULTS total obs=8

Obs    FACILITY    PRODUCTLINE    _TYPE_     _FREQ_     SUMREVENUE    SUMEXPENSES

 1        A             V            3      20000000     990236593      39995625
 2        A             W            3      20000000     989774911      40003257
 3        A             X            3      20000000     990098413      39998330
 4        A             Y            3      20000000     990007722      40002526
 5        B             V            3      20000000     990028079      40001253
 6        B             W            3      20000000     989784861      40001790
 7        B             X            3      20000000     989949866      40002720
 8        B             Y            3      20000000     989863982      40000232
                                           160000000

*                                    ___ _____
 _ __  _ __ ___   ___ ___  ___ ___  |_ _|___  |
| '_ \| '__/ _ \ / __/ _ \/ __/ __|  | |   / /
| |_) | | | (_) | (_|  __/\__ \__ \  | |  / /
| .__/|_|  \___/ \___\___||___/___/ |___|/_/
|_|
;



%let _s=%sysfunc(compbl(C:\Progra~1\SASHome\SASFoundation\9.4\sas.exe -sysin c:\nul -nosplash
  -sasautos c:\oto -work d:\wrk -rsasuser));

* this places the macro in my autocall library, c:/oto, so the batch command can find the macro;

filename ft15f001 "c:\oto\parlel.sas";
parmcards4;
%macro parlel(drv,tbl);

  libname ssd "&drv.";
  %do i=1 %to 15;
    proc means data=ssd.&tbl noprint nway;
      var revenue expenses;
      class facility productline;
      output out=ssd.&tbl.1 sum(revenue)=sumRevenue sum(expenses)=sumExpenses;
    run;
  %end;

%mend parlel;
;;;;
run;quit;

%*parlel(c:/sd1,m160_1))

* set up;

%let tym=%sysfunc(time());

systask kill sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;

systask command "&_s -termstmt %nrstr(%parlel(c:/sd1,m160_1)) -log d:\log\a1.log" taskname=sys1;
systask command "&_s -termstmt %nrstr(%parlel(c:/sd1,m160_2)) -log d:\log\a2.log" taskname=sys2;
systask command "&_s -termstmt %nrstr(%parlel(d:/sd1,m160_3)) -log d:\log\a3.log" taskname=sys3;
systask command "&_s -termstmt %nrstr(%parlel(d:/sd1,m160_4)) -log d:\log\a4.log" taskname=sys4;
systask command "&_s -termstmt %nrstr(%parlel(d:/sd1,m160_5)) -log d:\log\a5.log" taskname=sys5;
systask command "&_s -termstmt %nrstr(%parlel(e:/sd1,m160_6)) -log d:\log\a6.log" taskname=sys6;
systask command "&_s -termstmt %nrstr(%parlel(e:/sd1,m160_7)) -log d:\log\a7.log" taskname=sys7;
systask command "&_s -termstmt %nrstr(%parlel(e:/sd1,m160_8)) -log d:\log\a8.log" taskname=sys8;

waitfor sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;
%put %sysevalf(%sysfunc(time()) - &tym);

/* 12.3340001105971 */

* put them back together (0.01 seconds)
data results;
  set
    'c:/sd1/m160_11.sas7bdat'
    'c:/sd1/m160_21.sas7bdat'
    'd:/sd1/m160_31.sas7bdat'
    'd:/sd1/m160_41.sas7bdat'
    'd:/sd1/m160_51.sas7bdat'
    'h:/sd1/m160_61.sas7bdat'
    'h:/sd1/m160_71.sas7bdat'
    'h:/sd1/m160_81.sas7bdat'
;
run;quit;


Output
Up to 40 obs WORK.RESULTS total obs=8

Obs    FACILITY    PRODUCTLINE    _TYPE_     _FREQ_     SUMREVENUE    SUMEXPENSES

 1        A             V            3      20000000     990236593      39995625
 2        A             W            3      20000000     989774911      40003257
 3        A             X            3      20000000     990098413      39998330
 4        A             Y            3      20000000     990007722      40002526
 5        B             V            3      20000000     990028079      40001253
 6        B             W            3      20000000     989784861      40001790
 7        B             X            3      20000000     989949866      40002720
 8        B             Y            3      20000000     989863982      40000232

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;


196   %let tym=%sysfunc(time());
NOTE: "sys6" is not an active task/transaction.
197   systask kill sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;
198   systask command "&_s -termstmt %nrstr(%parlel(c:/sd1,m160_1)) -log d:\log\a1.log" taskname=sys1;
199   systask command "&_s -termstmt %nrstr(%parlel(c:/sd1,m160_2)) -log d:\log\a2.log" taskname=sys2;
200   systask command "&_s -termstmt %nrstr(%parlel(d:/sd1,m160_3)) -log d:\log\a3.log" taskname=sys3;
201   systask command "&_s -termstmt %nrstr(%parlel(d:/sd1,m160_4)) -log d:\log\a4.log" taskname=sys4;
202   systask command "&_s -termstmt %nrstr(%parlel(d:/sd1,m160_5)) -log d:\log\a5.log" taskname=sys5;
203   systask command "&_s -termstmt %nrstr(%parlel(e:/sd1,m160_6)) -log d:\log\a6.log" taskname=sys6;
204   systask command "&_s -termstmt %nrstr(%parlel(e:/sd1,m160_7)) -log d:\log\a7.log" taskname=sys7;
205   systask command "&_s -termstmt %nrstr(%parlel(e:/sd1,m160_8)) -log d:\log\a8.log" taskname=sys8;
206   waitfor sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;
NOTE: Task "sys7" produced no LOG/Output.
207   %put %sysevalf(%sysfunc(time()) - &tym);

124.390000343031

NOTE: Task "sys5" produced no LOG/Output.
NOTE: Task "sys6" produced no LOG/Output.
NOTE: Task "sys4" produced no LOG/Output.
NOTE: Task "sys8" produced no LOG/Output.
NOTE: Task "sys3" produced no LOG/Output.
NOTE: Task "sys1" produced no LOG/Output.
NOTE: Task "sys2" produced no LOG/Output.


*       ___   _
  __ _ ( _ ) | | ___   __ _
 / _` |/ _ \ | |/ _ \ / _` |
| (_| | (_) || | (_) | (_| |
 \__,_|\___(_)_|\___/ \__, |
                      |___/
;


NOTE: SAS initialization used:
      real time           0.89 seconds
      cpu time            0.23 seconds

NOTE: Libref SSD was successfully assigned as follows:
      Engine:        V9
      Physical Name: c:\sd1

NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           7.03 seconds
      cpu time            6.38 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           7.08 seconds
      cpu time            6.92 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.13 seconds
      cpu time            7.15 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           7.60 seconds
      cpu time            7.19 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           7.05 seconds
      cpu time            6.98 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.72 seconds
      cpu time            6.84 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.


NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.21 seconds
      cpu time            7.84 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.48 seconds
      cpu time            8.33 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.68 seconds
      cpu time            7.86 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           9.39 seconds
      cpu time            8.67 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.09 seconds
      cpu time            8.45 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           7.66 seconds
      cpu time            8.28 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           8.53 seconds
      cpu time            8.81 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           11.19 seconds
      cpu time            8.86 seconds



NOTE: There were 20000000 observations read from the data set SSD.M160_1.
NOTE: The data set SSD.M160_11 has 1 observations and 6 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           7.08 seconds
      cpu time            8.33 seconds



NOTE: SAS Institute Inc., SAS Campus Drive, Cary, NC USA 27513-2414
NOTE: The SAS System used:
      real time           2:04.05
      cpu time            1:57.21


