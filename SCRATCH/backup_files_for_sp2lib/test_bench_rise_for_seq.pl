#!/usr/bin/perl -w
print WRITE ".title Fanout Versus Delay (TSMC)\n";
print WRITE "\n";
print WRITE ".param vdd=5\n";
print WRITE ".param vddsec=5\n";
print WRITE ".param vss=0.0\n";
print WRITE ".param wp=3.00e-06\n";
print WRITE ".param wn=1.20e-06\n";
print WRITE ".param vlo='0.2*vdd'\n";
print WRITE ".param vmid='0.5*vdd'\n";
print WRITE ".param vhi='0.8*vdd'\n";
print WRITE ".param opcap=0.0001e-12\n";
print WRITE ".param inputslew=0.0300e-9\n";
print WRITE ".param v0=vss\n";
print WRITE ".param v1=vss\n";
print WRITE ".param v2=vlo\n";
print WRITE ".param v3=vhi\n";
print WRITE ".param v4=vdd\n";
print WRITE ".param v5=vdd\n";
print WRITE ".param v6=vhi\n";
print WRITE ".param v7=vlo\n";
print WRITE ".param v8=vss\n";
print WRITE ".param v9=vss\n";
print WRITE "\n";
print WRITE ".param t0='inputslew*10/6*0.0'\n";
print WRITE ".param t1='inputslew*10/6*1.0'\n";
print WRITE ".param t2='inputslew*10/6*1.2'\n";
print WRITE ".param t3='inputslew*10/6*1.8'\n";
print WRITE ".param t4='inputslew*10/6*2.0'\n";
print WRITE ".param t5='inputslew*10/6*3.0'\n";
print WRITE ".param t6='inputslew*10/6*3.2'\n";
print WRITE ".param t7='inputslew*10/6*3.8'\n";
print WRITE ".param t8='inputslew*10/6*4.0'\n";
print WRITE ".param t9='inputslew*10/6*5.0'\n";
print WRITE "\n";
print WRITE ".param t_sec0='inputslew*10/6*0.0 + 5e-9'\n";
print WRITE ".param t_sec1='inputslew*10/6*1.0 + 5e-9'\n";
print WRITE ".param t_sec2='inputslew*10/6*1.2 + 5e-9'\n";
print WRITE ".param t_sec3='inputslew*10/6*1.8 + 5e-9'\n";
print WRITE ".param t_sec4='inputslew*10/6*2.0 + 5e-9'\n";
print WRITE ".param t_sec5='inputslew*10/6*3.0 + 5e-9'\n";
print WRITE ".param t_sec6='inputslew*10/6*3.2 + 5e-9'\n";
print WRITE ".param t_sec7='inputslew*10/6*3.8 + 5e-9'\n";
print WRITE ".param t_sec8='inputslew*10/6*4.0 + 5e-9'\n";
print WRITE ".param t_sec9='inputslew*10/6*5.0 + 5e-9'\n";
print WRITE ".nodeset v(n3)=vss\n";
print WRITE "vdd vdd 0 vdd\n";
print WRITE "vddsec vddsec 0 vddsec\n";
print WRITE "vss vss 0   vss\n";
print WRITE "\n";
print WRITE "vin n2 vss pwl(\n"; 
print WRITE "+               t_sec0   v0\n"; 
print WRITE "+               t_sec1   v1\n";
print WRITE "+               t_sec2   v2\n";
print WRITE "+               t_sec3   v3\n";
print WRITE "+               t_sec4   v4\n";
print WRITE "+               t_sec5   v5\n";
print WRITE "+               t_sec6   v6\n";
print WRITE "+               t_sec7   v7\n";
print WRITE "+               t_sec8   v8\n";
print WRITE "+               t_sec9   v9\n";
print WRITE "+             )\n";
print WRITE "\n";
print WRITE "vin0 n1 vss pwl(\n"; 
print WRITE "+               t0   v0\n"; 
print WRITE "+               t1   v1\n";
print WRITE "+               t2   v2\n";
print WRITE "+               t3   v3\n";
print WRITE "+               t4   v4\n";
print WRITE "+               t5   v5\n";
print WRITE "+             )\n";
print WRITE ".MODEL n NMOS\n";
print WRITE ".MODEL p PMOS\n";
print WRITE "\n";
print WRITE "\n";
print WRITE ".include ./sff1_x4.spi\n";
print WRITE "x1sff1_x4 n2 n1 n3 vdd vss sff1_x4\n";
print WRITE "x1sff1_x4 n2 n3 n4 vdd vss sff1_x4\n";
print WRITE "\n";
print WRITE ".temp 85\n";
print WRITE ".tran 10p 500n\n";
print WRITE "\n";
print WRITE ".meas tran n1_first_rise when v(n1)=vmid rise=1\n";
print WRITE "\n";
print WRITE ".meas tran n2_first_fall when v(n2)=vmid fall=1\n";
print WRITE "\n";
print WRITE ".meas tran n2_first_rise when v(n2)=vmid rise=1\n";
print WRITE "\n";
print WRITE ".meas tran n3_first_rise when v(n3)=vmid rise=1\n";
print WRITE "\n";
print WRITE ".meas tran drise trig v(n2) val=vmid rise=1\n";
print WRITE "+                targ v(n3) val=vmid rise=1\n";
print WRITE "\n";
print WRITE ".meas tran slewr trig v(n3) val=vlo rise=1\n";
print WRITE "+                targ v(n3) val=vhi rise=1\n";
print WRITE "\n";
print WRITE ".end\n";
