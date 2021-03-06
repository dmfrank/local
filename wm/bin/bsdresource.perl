#!/usr/bin/perl
# $Id: bsdresource.perl,v 1.1 2011-01-18 19:20:17-08 dmfrank - $

use strict;
use warnings;

use BSD::Resource;
use constant {K_BYTES => 1<<10, MINUTES => 60};

for my $opt (qw (i m n o p r s v)) {
   print "uname -$opt = ", `uname -$opt`;
}

my @limitvec = (
   ["RLIMIT_CPU",      "CPU time (seconds)"],
   ["RLIMIT_FSIZE",    "file size (bytes)"],
   ["RLIMIT_DATA",     "data size (bytes)"],
   ["RLIMIT_STACK",    "stack size (bytes)"],
   ["RLIMIT_CORE",     "coredump size (bytes)"],
   ["RLIMIT_RSS",      "resident set size (bytes)"],
   ["RLIMIT_NPROC",    "number of processes"],
   ["RLIMIT_NOFILE",   "number of open files"],
   ["RLIMIT_MEMLOCK",  "memory locked data size (bytes)"],
   ["RLIMIT_AS",       "(virtual) address space (bytes)"],
   ["RLIMIT_LOCKS",    "number of file locks"],
);

sub print_resources ($) {
   print "@_:\n";
   for my $entry (@limitvec) {
      my ($name, $description) = @$entry;
      my $resource = eval $name;
      my ($soft, $hard) = getrlimit ($resource);
      printf "   %10d %10d %-14s %s\n",
             $soft, $hard, $name, $description;
   }
   for my $opt (qw (c f t)){
      print "   ulimit -$opt = ", `sh -c "ulimit -$opt"`;
   }
}

print_resources "Before";
setrlimit (RLIMIT_CPU,     2 * MINUTES,   2 * MINUTES);
setrlimit (RLIMIT_FSIZE, 256 * K_BYTES, 256 * K_BYTES);
setrlimit (RLIMIT_CORE,    4 * K_BYTES,   4 * K_BYTES);
print_resources "After";

