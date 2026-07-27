/*
  Facility x product-line split step from
  Why-does-the-vintage-Dell-I7-E6420-outperform-brand-new-Dell-I5-ultra-thin-Dell-laptop.sas

  The upstream step seeds a stream, walks 2 facilities x 4 product lines,
  builds the group key with cats(), and routes each record to one of eight
  datasets via a select()/when() block. Upstream those eight datasets live on
  three physical drives (libname chd "c:/sd1"; dhd "d:/sd1"; hhd "e:/sd1";) and
  hold 20,000,000 records each. Here the eight libref.dataset targets are
  redirected to WORK and the record count is small so the run is self-contained;
  the streaminit seed, the do-loop nesting, the cats() key, and the eight-way
  select()/when() routing are exactly as written upstream.
*/

data m160_1  m160_2 m160_3 m160_4 m160_5 m160_6 m160_7 m160_8;
  length revenue expenses 3.;
  call streaminit(4321);
  do rec=1 to 400;
      do facility="A","B";
        do productline="V","W","X","Y";
           grp=cats(facility,productline);
           expenses=int(5*rand('uniform'));
           revenue =int(100*rand('uniform'));
           select (grp);
             when ("AV") output m160_1;
             when ("AW") output m160_2;
             when ("AX") output m160_3;
             when ("AY") output m160_4;
             when ("BV") output m160_5;
             when ("BW") output m160_6;
             when ("BX") output m160_7;
             when ("BY") output m160_8;
           end;
         end;
       end;
    end;
    drop grp rec;
    stop;
run;quit;

/* confirm the eight-way split: one facility x productline pair per dataset */
proc means data=m160_1 sum n nway;
  var revenue expenses;
  class facility productline;
run;
