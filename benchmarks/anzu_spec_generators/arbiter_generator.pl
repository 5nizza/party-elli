#! /usr/bin/perl -w 
#$Id: arbiter_generator.pl,v 1.2 2007/04/13 09:22:42 rbloem Exp $

use strict;

#======================================================================
#                             MAIN


if(! defined($ARGV[0])) {
  print "Usage: ./arbiter_generator.pl <num_of_clients>\n";
  exit;
}


my $num_clients = $ARGV[0];

my $env_initial = "";
my $sys_initial = "";
my $env_transitions = "";
my $sys_transitions_part1 = "";
my $sys_transitions_part2 = "";
my $env_fairness = "";
my $sys_fairness = "";
my $input_vars = "";
my $output_vars = "";

for(my $i = 0; $i < $num_clients; $i++) {
  $env_initial .= "r" . $i . "=0;\n";
  $sys_initial .= "g" . $i . "=0;\n";
  if(!($env_transitions eq "")) {
    $env_transitions .= " * ";
  }

  $env_transitions .= "(((r".$i."=1)*(g".$i."=0)->X(r".$i."=1)) * ((r".$i."=0)*(g".$i."=1)->X(r".$i."=0)))";

  $env_fairness .= "G(F((r".$i."=0)+(g".$i."=0)));\n";

  if(!($sys_transitions_part1 eq "")) {
    $sys_transitions_part1 .= " * ";
  }
  $sys_transitions_part1 .= "X(g".$i."=1)";
    
  if(!($sys_transitions_part2 eq "")) {
    $sys_transitions_part2 .= " * ";
  }
  $sys_transitions_part2 .= "((((r".$i."=0)*(g".$i."=0))->X(g".$i."=0)) * (((r".$i."=1)*(g".$i."=1))->X(g".$i."=1)))";

  $sys_fairness .= "G(F(((r".$i."=1)*(g".$i."=1)) + ((r".$i."=0)*(g".$i."=0))));\n";
  $input_vars .= "r".$i.";\n";
  $output_vars .= "g".$i.";\n";
}

print "[ENV_INITIAL]\n";
print $env_initial;
print "\n";
print "[SYS_INITIAL]\n";
print $sys_initial;
print "\n";
print "[ENV_TRANSITIONS]\n";
print "G(" . $env_transitions . ");\n";
print "\n";
print "[ENV_FAIRNESS]\n";
print $env_fairness;
print "\n";
print "[SYS_TRANSITIONS]\n";
print "G((!(" . $sys_transitions_part1 . ")) * " . $sys_transitions_part2 . ");\n";
print "\n";
print "[SYS_FAIRNESS]\n";
print $sys_fairness;
print "\n";
print "[INPUT_VARIABLES]\n";
print $input_vars;
print "\n";
print "[OUTPUT_VARIABLES]\n";
print $output_vars;
print "\n";
