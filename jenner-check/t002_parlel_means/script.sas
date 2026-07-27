/*
  %parlel macro core from
  Why-does-the-vintage-Dell-I7-E6420-outperform-brand-new-Dell-I5-ultra-thin-Dell-laptop.sas

  Upstream, %parlel(drv,tbl) assigns a libname to a physical drive and runs the
  same PROC MEANS fifteen times in a row over a 20,000,000-record table, each
  pass summing revenue and expenses by facility x product line into &tbl.1 --
  the fifteen consecutive passes are the per-CPU workload the benchmark times.

  This caller keeps the macro's PROC MEANS statement verbatim (noprint nway;
  var revenue expenses; class facility productline; output out=&tbl.1
  sum(revenue)=sumRevenue sum(expenses)=sumExpenses;) and its %do 1..15 loop.
  It supplies a small WORK table built the same way the upstream generator does
  (do facility / do productline / cats() key), so no external drive is needed,
  and the 15-pass output dataset can be printed to show the summarization.
*/

/* small stand-in for one of the upstream ssd.m160_n tables */
data m160_1;
  length revenue expenses 3.;
  call streaminit(4321);
  do rec=1 to 200;
      do facility="A","B";
        do productline="V","W","X","Y";
           expenses=int(5*rand('uniform'));
           revenue =int(100*rand('uniform'));
           output;
        end;
      end;
  end;
  drop rec;
  stop;
run;

%macro parlel(tbl);
  %do i=1 %to 15;
    proc means data=&tbl noprint nway;
      var revenue expenses;
      class facility productline;
      output out=&tbl.1 sum(revenue)=sumRevenue sum(expenses)=sumExpenses;
    run;
  %end;
%mend parlel;

%parlel(m160_1)

/* the 15 consecutive passes all land the same summary; show the last one */
proc print data=m160_11 noobs;
run;
