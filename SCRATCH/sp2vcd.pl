#!/usr/bin/perl
use Benchmark;
my $t0 = new Benchmark;
my $t1 = new Benchmark;

my $spFile_str = "";
my $outfile = "";
my $output = "";
my $drupal_temp_path; 

my $noOfArg = @ARGV;
if($ARGV[0] eq "-h" || $ARGV[0] eq "-help" || $ARGV[0] eq "-HELP"){
  print "Usage : sp2vcd -spice_file <sp file name>\n";
}else{
  for(my $xx=0;$xx<$noOfArg;$xx++){
    if($ARGV[$xx] eq "-spice_file"){$spFile_str = $ARGV[$xx+1];}
    if($ARGV[$xx] eq "-drupal_temp_storage_path"){
          $drupal_temp_path = $ARGV[$xx+1];
    }
  }#for
my $read_legend = 0;
my $end_legend = 0;
#----------------------------------------check plot var-------------------------------------------#
my @plot_var_list = ();
open(READ,"$spFile_str");
while(<READ>){
  chomp();
  if($_ =~ /^\.plot/){
    my $plot_var = (split(/\s+/,$_))[2];
    push(@plot_var_list,$plot_var);
  }
}#while
close(READ);
system ("ngspice -b -o $spFile_str.log $spFile_str");
my @new_list = ();
foreach my $plot_var (@plot_var_list){
  if($plot_var !~ /^v/){
    $plot_var =~ s/i//;
    $plot_var =~ s/\(//;
    $plot_var =~ s/\)//;
    push(@new_list,$plot_var);
  }else {
    push(@new_list,$plot_var);
  }
}
my $cnt = 0;
my @time_vl_list = ();
my %LEGEND_DATA = ();
my $var = "";
open(READ_NG_LOG,"$spFile_str.log");
while(<READ_NG_LOG>){
  chomp();
  if($_ =~ /Legend:/){
    $read_legend = 1;
    $end_legend = 0;
    $var = shift @new_list;
  }if($_ =~ /^\s+Fanout Versus Delay/){
    $read_legend = 0;
    $end_legend = 1;
  }
  if($read_legend == 1 && $end_legend == 0){
    @time_vl_list = ();
    if($_ =~ /^\s+\d/){
      my($time,$value) = (split(/\s+/,$_))[1,2];
      push(@time_vl_list,"[$time,$value]");
    }
    push(@{$LEGEND_DATA{$var}},@time_vl_list);
  }#if
}#while
open(WRITE_LABEL,">label_vs_file_name");
foreach my $var (keys %LEGEND_DATA){
  print WRITE_LABEL "$var var_$cnt\n";
  my $new_var = "\"$var\"";
  open(WRITE ,">var_$cnt");
  $cnt++;
  print WRITE "{\n";
  my $label = '"label"';
  my $data = '"data":[';
  print WRITE "\t$label:$new_var,\n";
  print WRITE "\t$data";
  my $time_vl_new = join (",",@{$LEGEND_DATA{$var}});
  print WRITE "$time_vl_new";
  print WRITE "]\n";
  print WRITE "}\n";
  close(WRITE);
}#foreach
close(WRITE_LABEL);

open(WRITE_COMPLETE,">complete");
close(WRITE_COMPLETE);

if(-e "b3v3_1check.log"){
  system ("rm b3v3_1check.log"); 
}
if( -e "$spFile_str.log"){
  system ("rm $spFile_str.log");
}
   system ("mkdir tmp"); 
   my $process_end = 0;
   do{
     opendir(DIR, ".") or die $!;
     while (my $file = readdir(DIR)) {
       if($file =~ /^var_/){
         system("scp -i /apps/scp_key -o StrictHostKeyChecking=no $file root\@192.168.20.20:/var/www/html/drupal/$drupal_temp_path/");
         system("mv $file ./tmp");
       }elsif($file eq 'label_vs_file_name'){
         system("scp -i /apps/scp_key -o StrictHostKeyChecking=no $file root\@192.168.20.20:/var/www/html/drupal/$drupal_temp_path/");
         system("mv $file ./tmp");
       }elsif($file eq 'complete'){
          $process_end = 1;
          system("scp -i /apps/scp_key -o StrictHostKeyChecking=no var_* root\@192.168.20.20:/var/www/html/drupal/$drupal_temp_path/");
          system("mv var_* ./tmp");
          system("ssh -i /apps/scp_key -o StrictHostKeyChecking=no root\@192.168.20.20 'touch /var/www/html/drupal/$drupal_temp_path/complete'");
          last;
       }
     }
     closedir(DIR);
     sleep(1);
   }while($process_end != 1);
   system("cp ./tmp/* ."); 
   system("rm -rf ./tmp"); 
}#else

my $td = timediff($t1,$t0);
print "script sp2waveform took:",timestr($td),"\n";
