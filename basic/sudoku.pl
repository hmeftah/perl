#!/usr/bin/perl -w
#
# program to play "sudoku" game, using a char based TTY (unix/linux) 
# or a DOS window on Windows 95 and up.
#
my $winconsole;
if ($^O eq "MSWin32") {
   eval {
      require Win32::Console;
      import  Win32::Console;
      require Win32::Console::ANSI;
      import  Win32::Console::ANSI;
      $winconsole = Win32::Console->new;
      $winconsole = Win32::Console->new($winconsole->STD_INPUT_HANDLE);
   }; die "Look into the README.txt file : $@" if $@;
}
use Term::ANSIScreen qw/:color :cursor :screen/;

use integer;
use Cwd;
use Getopt::Std;     # option processing
our ($opt_d);
getopts('d') || exit;

my $max_solutions;   # maximum number of solutions the program will search for
if ($opt_d) {
   $max_solutions = 10;  # if -d option ( solving log) then max is 10
} else {
   $max_solutions = 1;   # else the first solution found will do
}

my $logging;               # logging indicator for solver

my @smatrix=(
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
);
my $pto_smatrix = \@smatrix;
my $pto_smatrix_solution = \@smatrix;
my @smatrix_initial=(
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
);   
my $solution_found = 0;

my @possible_matrix=(
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
);   
my @hash_Xas=(
   (),(),(),(),(),(),(),(),(),
);
    
my @hash_Yas=(
   (),(),(),(),(),(),(),(),(),
);

my @hash_subsquares=(
   ((),(),()),
   ((),(),()),
   ((),(),()),
);
my @check_ind_Xas=(0,0,0,0,0,0,0,0,0);
my @check_ind_Yas=(0,0,0,0,0,0,0,0,0);
my @check_ind_subsquares=(
   [(0,0,0)],
   [(0,0,0)],
   [(0,0,0)],
);
my $sudoku = 0;  # toggle between possible numbers and sudoku display

$intro_txt = "Enter Sudoku (given numbers); when done, enter Ctrl-q; or Ctrl-g to generate";
$play_txt = "Ctrl-h>Help|Ctrl-s>Save|Ctrl-l>Load|Ctrl-p>Play|Ctrl-q>Quit|Ctrl-x>Execute|";
$error_txt = "From starting point chosen, solving Sudoku not possible (inconsistencies)";
$solved_txt = "program executed solution";
$txt_line = "";

my @gen_matrix=(
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
);
my $pto_gen_matrix = \@gen_matrix;    

my @work_matrix=(
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
  [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
);
my $pto_work_matrix = \@work_matrix;   

sub print_grid {
   (my $col, my $row) = @_;
   locate ($row, $col);
   print "   |   |   "; 
   $row += 1;
   locate ($row, $col);
   print "---|---|---";
   $row += 1;
   locate ($row, $col);
   print "   |   |   ";
   $row += 1;
   locate ($row, $col);
   print "---|---|---";
   $row += 1;
   locate ($row, $col);
   print "   |   |   ";
}

sub check_number {
   (my $y, my $x, my $key, my $color) = @_;
   if ($key ne " ") {
      for (my $i = $y + 1; $i < 9; $i++) {   # same number to the right ?
         $color = 'bold red' unless ($smatrix[$i][$x] ne $key);
      }
      for (my $i = $y - 1; $i >= 0; $i--) {  # same number to the left ?
         $color = 'bold red' unless ($smatrix[$i][$x] ne $key);
      }
      for (my $i = $x + 1; $i < 9; $i++) {   # same number down ?
         $color = 'bold red' unless ($smatrix[$y][$i] ne $key);
      }
      for (my $i = $x - 1; $i >= 0; $i--) {  # same number above ?
         $color = 'bold red' unless ($smatrix[$y][$i] ne $key);
      }
   
      # calculate origin of sub-square
      my $oy = $y - ($y % 3);
      my $ox = $x - ($x % 3);
 
      # check if same number in same sub-square
      for (my $i = $ox; $i < ($ox + 3); $i++) {
         for (my $j = $oy; $j < ($oy + 3); $j++) {
            $color = 'bold red' unless ($smatrix[$j][$i] ne $key);
         }
      }
   }
   return ($color);
}

sub check_unique_number {
   my ($x, $y, $i, $j, %numbers_count, %place_last_found, $number);
   for ($y = 0; $y < 9; $y++) {
      (%numbers_count, %place_last_found) = ();
      for ($x = 0; $x < 9; $x++) {
         if ($possible_matrix[$x][$y]) {
            foreach $number (split ('', $possible_matrix[$x][$y])) { 
               $numbers_count{$number}++;
               $place_last_found{$number} = $x; 
            }
         }
      }
      foreach $number (keys %numbers_count) {
         if ($numbers_count{$number} == 1) {     # unique number found in row
            $x = $place_last_found{$number};
            $possible_matrix[$x][$y] = $number;
         } 
      }
   }
   for ($x = 0; $x < 9; $x++) {
      (%numbers_count, %place_last_found) = ();
      for ($y = 0; $y < 9; $y++) {
         if ($possible_matrix[$x][$y]) {
            foreach $number (split ('', $possible_matrix[$x][$y])) { 
               $numbers_count{$number}++;
               $place_last_found{$number} = $y; 
            }
         }
      }
      foreach $number (keys %numbers_count) {
         if ($numbers_count{$number} == 1) {   # unique number found in column
            $y = $place_last_found{$number};
            $possible_matrix[$x][$y] = $number;
         } 
      }
   }
   for ($i = 0; $i < 3; $i++) {
      for ($j = 0; $j < 3; $j++) {
         (%numbers_count, %place_last_found_x, %place_last_found_y) = ();
         for ($y = ($i * 3); $y < (($i * 3) + 3); $y++) {
            for ($x = ($j * 3); $x < (($j * 3) + 3); $x++) {
               if ($possible_matrix[$x][$y]) {
                  foreach $number (split ('', $possible_matrix[$x][$y])) { 
                     $numbers_count{$number}++;
                     $place_last_found_x{$number} = $x; 
                     $place_last_found_y{$number} = $y; 
                  }
               }  
            }
         }
         foreach $number (keys %numbers_count) {
            if ($numbers_count{$number} == 1) { # unique number found in subsqr
               $x = $place_last_found_x{$number};
               $y = $place_last_found_y{$number};
               $possible_matrix[$x][$y] = $number;
            } 
         }
      }
   }
}

sub possible_numbers {
   (my $pto_smatrix) = @_;
   my $retcode;
   my ($i,$j,$x,$y);
  (@hash_Xas, @hash_Yas, @hash_subsquares) = ();

   # scan numbers entered per row (X axis)
   for ($y = 0; $y < 9; $y++) {      # for each row
      for ($x = 0; $x < 9; $x++) {   # for each row-field
         $hash_Xas[$y]{$$pto_smatrix[$y][$x]}++; #sort-out and count(in a hash) 
      }
      delete $hash_Xas[$y]{" "}; # delete reference to blank keys
   }
  
   # scan numbers entered per row (Y axis)
   for ($x = 0; $x < 9; $x++) {      # for each column
      for ($y = 0; $y < 9; $y++) {   # for each column-field
         $hash_Yas[$x]{$$pto_smatrix[$y][$x]}++; #sort-out and count(in a hash) 
      }
      delete $hash_Yas[$x]{" "}; # delete reference to blank keys
   }

   # scan numbers entered in each sub-square
   for ($i = 0; $i < 3; $i++) {
      for ($j = 0; $j < 3; $j++) {
         for ($y = ($i * 3); $y < (($i * 3) + 3); $y++) {
            for ($x = ($j * 3); $x < (($j * 3) + 3); $x++) {
               $hash_subsquares[$i][$j]{$$pto_smatrix[$y][$x]}++; # idem
            }
         }
         delete $hash_subsquares[$i][$j]{" "}; # delete ref to blank keys
      }
   }
   # calculate (with data in the hashes) what numbers are possible in each 
   # sudoku square not yet filled in.
   @possible_matrix = ();
   for ($x = 0; $x < 9; $x++) {
      for ($y = 0; $y < 9; $y++) {
         if ($$pto_smatrix[$x][$y] eq " ") {
            my %work = (1,1,2,1,3,1,4,1,5,1,6,1,7,1,8,1,9,1);
            foreach $nbr (keys %{$hash_Yas[$y]}) {
               delete $work{$nbr};
            }
            foreach $nbr (keys %{$hash_Xas[$x]}) {
               delete $work{$nbr};
            }
            foreach $nbr (keys %{$hash_subsquares[$x/3][$y/3]}) {
               delete $work{$nbr};
            }
            $possible_matrix[$y][$x] = join ('', sort keys %work);
         }
      }
   }
   &check_unique_number;
   $retcode = &check_possible_numbers;
   return $retcode;
}

sub check_possible_numbers {
# check if the number of still empty places per row/column/sub-square 
# exactly matches the remaining differential keys for that row/column/sub-square
# if that is not the case, the previously chosen number 
# (by the user or the solver) is an incorrect choice!
# which leads to an impossible solution.

   @check_ind_Xas=(0,0,0,0,0,0,0,0,0);
   @check_ind_Yas=(0,0,0,0,0,0,0,0,0);
   @check_ind_subsquares=([(0,0,0)],[(0,0,0)],[(0,0,0)]);
   my ($x, $y, $i, $j, $keycnt, %work, @possible_number_strings, $n, $cnt);
   my $retcode = 0;
   
   for ($y = 0; $y < 9; $y++) {
      %work = (); $cnt = 0; @possible_number_strings = (); $n = 0;
      for ($x = 0; $x < 9; $x++) {		
         if ($possible_matrix[$x][$y]) {
            $possible_number_strings[$n] = $possible_matrix[$x][$y];
            $n++;
         }
      }
      foreach $str (sort {return(1) if ($a gt $b);
                          return(0) if ($a eq $b);   
                          return(-1) if ($a lt $b);} @possible_number_strings) {
         $cnt++;
         @nbrs = split (//,$str);
         foreach $nbr (@nbrs) {
            $work{$nbr}++;       
         }
         $keycnt = (keys %work);
         if ($cnt > $keycnt) {
            $check_ind_Yas[$y] = 1;
            $retcode = 1;
         }
      }
      if (!$check_ind_Yas[$y]) {
         $keycnt = (keys %work);
         if ($cnt != $keycnt) {
            $check_ind_Yas[$y] = 1;
            $retcode = 1;
         }
      }
      $cnt = 0;
      foreach $str (sort { $a <=> $b} @possible_number_strings) {
         $cnt++;
         @nbrs = split (//,$str);
         foreach $nbr (@nbrs) {
            $work{$nbr}++;       
         }
         $keycnt = (keys %work);
         if ($cnt > $keycnt) {
            $check_ind_Yas[$y] = 1;
            $retcode = 1;
         }
      }
      if (!$check_ind_Yas[$y]) {
         $keycnt = (keys %work);
         if ($cnt != $keycnt) {
            $check_ind_Yas[$y] = 1;
            $retcode = 1;
         }
      }
   }
   for ($x = 0; $x < 9; $x++) {
      %work = (); $cnt = 0; @possible_number_strings = (); $n = 0;
      for ($y = 0; $y < 9; $y++) {
         if ($possible_matrix[$x][$y]) {
            $possible_number_strings[$n] = $possible_matrix[$x][$y];
            $n++;
         }
      }
      foreach $str (sort {return(1) if ($a gt $b);
                          return(0) if ($a eq $b);   
                          return(-1) if ($a lt $b);} @possible_number_strings) {
         $cnt++;
         @nbrs = split (//,$str);
         foreach $nbr (@nbrs) {
            $work{$nbr}++;       
         }
         $keycnt = (keys %work);
         if ($cnt > $keycnt) {
            $check_ind_Xas[$x] = 1;
            $retcode = 1;
         }
      }
      if (!$check_ind_Xas[$x]) {
         $keycnt = (keys %work);
         if ($cnt != $keycnt) {
            $check_ind_Xas[$x] = 1;
            $retcode = 1;
         }
      }
      $cnt = 0;
      # the same process , now using numerically sorted keys
      foreach $str (sort { $a <=> $b} @possible_number_strings) {
         $cnt++;
         @nbrs = split (//,$str);
         foreach $nbr (@nbrs) {
            $work{$nbr}++;       
         }
         $keycnt = (keys %work);
         if ($cnt > $keycnt) {
            $check_ind_Xas[$x] = 1;
            $retcode = 1;
         }
      }
      if (!$check_ind_Xas[$x]) {
         $keycnt = (keys %work);
         if ($cnt != $keycnt) {
            $check_ind_Xas[$x] = 1;
            $retcode = 1;
         }
      }
   }
   for ($i = 0; $i < 3; $i++) {
      for ($j = 0; $j < 3; $j++) {
         %work = (); $cnt = 0; $n = 0; @possible_number_strings = ();
         for ($y = ($i * 3); $y < (($i * 3) + 3); $y++) {
            for ($x = ($j * 3); $x < (($j * 3) + 3); $x++) {
               if ($possible_matrix[$x][$y]) { 
                  $possible_number_strings[$n] = $possible_matrix[$x][$y];
                  $n++;
               }
            }
         }
         foreach $str (sort {return(1) if ($a gt $b);
                          return(0) if ($a eq $b);   
                          return(-1) if ($a lt $b);} @possible_number_strings) {
            if ($str) {
               $cnt++;
               @nbrs = split (//,$str);
               foreach $nbr (@nbrs) {
                  $work{$nbr}++;       
               }
               $keycnt = (keys %work);
               if ($cnt > $keycnt) { 
                  $check_ind_subsquares[$i][$j]= 1;
                  $retcode = 1;
               }
            }
         }
         if (!$check_ind_subsquares[$i][$j]) {
            $keycnt = (keys %work);
            if ($cnt != $keycnt) {
               $check_ind_subsquares[$i][$j]= 1;
               $retcode = 1;
            }
         }
         $cnt = 0;
         foreach $str (sort { $a <=> $b } @possible_number_strings) {
            if ($str) {
               $cnt++;
               @nbrs = split (//,$str);
               foreach $nbr (@nbrs) {
                  $work{$nbr}++;       
               }
               $keycnt = (keys %work);
               if ($cnt > $keycnt) { 
                  $check_ind_subsquares[$i][$j]= 1;
                  $retcode = 1;
               }
            }
         }
         if (!$check_ind_subsquares[$i][$j]) {
            $keycnt = (keys %work);
            if ($cnt != $keycnt) {
               $check_ind_subsquares[$i][$j]= 1;
               $retcode = 1;
            }
         }
      }
   }
   return $retcode;
}

sub sub_square_possible_matrix {
   my($col, $row, $x, $y, $i, $j, $c, $r, $color);
   ($col, $row, $x, $y) = @_;
   $color = "reset";
   $c = $col; $r = $row;
   locate ($r, $c);
   for ($i = $y; $i < ($y + 3); $i++) {
      for ($j = $x; $j < ($x + 3); $j++) {
         $nbr = $possible_matrix[$j][$i];
         $nbr = " " unless ($nbr);
         if ($check_ind_subsquares[$y][$x]) {
            $color = "magenta";
         }
         if ($check_ind_Yas[$i])  {
            $color = "magenta";
         }
         if ($check_ind_Xas[$j])  {
            $color = "magenta";
         }
         if ((length $nbr) > 6) {
            print color ("$color");
            print substr($nbr,0,6);
            locate ($r+1, $c);
            print substr($nbr,6);
            locate ($r, $c);
            $color = "reset";
         } else {
            print color ("$color");
            print $nbr;
            $color = "reset";
         }
         $c += 7;
         locate ($r, $c); 
      }
      $c = $col; $r += 2;
      locate ($r, $c); 
   }
}

sub sub_square_smatrix {
   my($col, $row, $x, $y, $i, $j, $c, $r);
   ($col, $row, $x, $y, my $pto_smatrix, my $color) = @_;
   $c = $col; $r = $row;
   locate ($r, $c);
   for ($i = $y; $i < ($y + 3); $i++) {
      for ($j = $x; $j < ($x + 3); $j++) {
         $nbr = $$pto_smatrix[$i][$j];
         $nbr = " " unless ($nbr);
         print color ($color) unless (!$color);
         if ($smatrix_initial[$i][$j] ne " ") {
            print color ('bold green');
         }
         print $nbr;
         print color ('reset');
         $c += 4;
         locate ($r, $c);
      }
      $c = $col; $r += 2;
      locate ($r, $c);
   }
}

sub disp_smatrix {
   my ($pto_smatrix, $txt_line, $color) = @_;
   cls;      # clearscreen 
   locate (1, 1);
   print color ('bold yellow');
   print "-------------------------------------\n";
   print "|           |           |           |\n";
   print "|           |           |           |\n"; 
   print "|           |           |           |\n";
   print "|           |           |           |\n";
   print "|           |           |           |\n";
   print "|-----------|-----------|-----------|\n";
   print "|           |           |           |\n";
   print "|           |           |           |\n"; 
   print "|           |           |           |\n";
   print "|           |           |           |\n";
   print "|           |           |           |\n";
   print "|-----------|-----------|-----------|\n";
   print "|           |           |           |\n";
   print "|           |           |           |\n"; 
   print "|           |           |           |\n";
   print "|           |           |           |\n";
   print "|           |           |           |\n";
   print "-------------------------------------\n";
   print color ("reset");

   &print_grid(2,2);
   &print_grid(14,2);
   &print_grid(26,2);
   &print_grid(2,8);
   &print_grid(14,8);
   &print_grid(26,8);
   &print_grid(2,14);
   &print_grid(14,14);
   &print_grid(26,14);
     
   &sub_square_smatrix(3,2,0,0,$pto_smatrix, $color);
   &sub_square_smatrix(15,2,3,0,$pto_smatrix, $color);
   &sub_square_smatrix(27,2,6,0,$pto_smatrix, $color);
   &sub_square_smatrix(3,8,0,3,$pto_smatrix, $color);
   &sub_square_smatrix(15,8,3,3,$pto_smatrix, $color);
   &sub_square_smatrix(27,8,6,3,$pto_smatrix, $color);
   &sub_square_smatrix(3,14,0,6,$pto_smatrix, $color);
   &sub_square_smatrix(15,14,3,6,$pto_smatrix, $color);
   &sub_square_smatrix(27,14,6,6,$pto_smatrix, $color);
   locate (24, 1);
   print color ('bold white');
   if ($txt_line) {
      print "$txt_line";
   }
   locate (25, 1);
   print "$play_txt";
   print color ("reset");

   $sudoku = 1;
}

sub disp_possible_matrix {
  cls;      # clearscreen
  locate (1, 1);
  print color ('bold yellow');
  print "-------------------------------------------------------------------\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|---------------------|---------------------|---------------------|\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|---------------------|---------------------|---------------------|\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "|                     |                     |                     |\n";
  print "-------------------------------------------------------------------\n";
  print color ("reset");
  &sub_square_possible_matrix(3,2,0,0);
  &sub_square_possible_matrix(25,2,3,0);
  &sub_square_possible_matrix(47,2,6,0);
  &sub_square_possible_matrix(3,9,0,3);
  &sub_square_possible_matrix(25,9,3,3);
  &sub_square_possible_matrix(47,9,6,3);
  &sub_square_possible_matrix(3,16,0,6);
  &sub_square_possible_matrix(25,16,3,6);
  &sub_square_possible_matrix(47,16,6,6);
  print color ('bold white');
  locate (25, 1);
  print "$play_txt";
  $sudoku = 0;
}

sub compute_solution {
  (my $pto_smatrix_old) = @_;
   print TEST "compute_solution entered\n" if ($logging);
   my $retcode = 0;
   my $number_count;    # number of empty spaces left
   my ($nbr, $row, $col);
   my $nbr_string;
   my ($i, $j);
   my @smatrix=(
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
     [(' ',' ',' ',' ',' ',' ',' ',' ',' ')],
   );
   my $pto_smatrix_new = \@smatrix;
   my $color = "reset";
   my $switch_1;
   
   # copy previous to current smatrix
   for ($i = 0; $i < 9; $i++) {
      for ($j = 0; $j < 9; $j++) {
         $smatrix[$i][$j] = $$pto_smatrix_old[$i][$j];
      }
   }

   $retcode = &possible_numbers($pto_smatrix_new);
   if ($retcode == 0) {

      $number_count = 0;
      $switch_1 = 0;
      for ($i = 0; $i < 9; $i++) {
         for ($j = 0; $j < 9; $j++) {
            if ($possible_matrix[$j][$i]) {
               $number_count++;
               if (length($possible_matrix[$j][$i]) == 1) {

                  # "possible matrix" apparently is inverted compared to 
                  # smatrix, therefore swap places subscripts $i and $j !

                  $smatrix[$i][$j] = $possible_matrix[$j][$i];
                  if ($logging) {
                     $row = $i + 1; $col = $j + 1; 
                     print TEST 
                  "len 1, nbr $possible_matrix[$j][$i] in row $row col $col\n";
                  }
                  $switch_1 = 1;
               }
            }
         }
      }
      if ($switch_1 == 1) {
         $retcode = &compute_solution($pto_smatrix_new);
         return 0 if ($solution_found >= $max_solutions);
      }
   }

   # look for the shortest possible number string left 
   
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 2) {

                     # save the string found, in (local) variable

                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 2, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 3) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 3, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 4) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 4, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 5) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 5, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 6) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 6, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 7) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 7, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 8) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 8, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if ($retcode == 0) {  
      if ($number_count > 0) {
         for ($i = 0; $i < 9; $i++) {
            for ($j = 0; $j < 9; $j++) {
               if ($possible_matrix[$j][$i]) {
                  if (length($possible_matrix[$j][$i]) == 9) {
                     $nbr_string = $possible_matrix[$j][$i];
                     foreach $nbr (split (//,$nbr_string)) {
                        $gen_matrix[$i][$j] = $nbr;
                        $smatrix[$i][$j] = $nbr; 
                        if ($logging) {            # solving log
                           $row = $i + 1; $col = $j + 1; 
                           print TEST "len 9, nbr $nbr in row $row col $col\n";
                        }
                        $retcode = &compute_solution($pto_smatrix_new);
                        return 0 if ($solution_found >= $max_solutions);
                     }
                     return $retcode;
                  }
               }
            }
         }
      }
   }
   if (($retcode == 0) && ($number_count <= 0)) {
      # save solution in global smatrix
      $solution_found++;
      print TEST "Solution found nr: $solution_found\n" if ($logging);
      for ($i = 0; $i < 9; $i++) {
         for ($j = 0; $j < 9; $j++) {
            $$pto_smatrix_solution[$i][$j] = $$pto_smatrix_new[$i][$j];
            print TEST $$pto_smatrix_new[$i][$j],"," if ($logging);
         }
         print TEST "\n" if ($logging); 
      }
   }
   print TEST "Returned $retcode\n" if ($logging); 
   return $retcode;
}

sub random {       # generate a random digit 0 - 8
   my $r;
   $r = rand(10000000);
   $r = int($r);
   $r = $r % 9;
   return $r;      
}

sub generate_sudoku {      # generate a sudoku with one solution
   my ($color, $new_color, $i, $j, $x, $y, $k, $key);
   my $save_max_solutions;
   my $save_entry;
   my @cnt=(
      [(0,0,0)],
      [(0,0,0)],
      [(0,0,0)],
   );
   my $nextdot;

   $save_max_solutions = $max_solutions;
   $max_solutions = 1;
   
   $solution_found = 0;

   locate(23,1); 
   print "                             \n";
   locate(23,1);
   print "Please wait.\n";
   $nextdot = 13;
   while (!$solution_found) {    # repeat process until random sudoku solution
      locate(23,$nextdot++);
      print ".\n";               # show sign of life to the user
      # init the global sudoku matrix
      for ($i = 0; $i < 9; $i++) { 
         for ($j = 0; $j < 9; $j++) { 
            $smatrix[$i][$j] = ' ';
         }
      }
      $color = "bold green";

      # seeding 21 random numbers in a matrix in random places
      for ($i = 0; $i < 21; $i++) {
         $x = &random;     # random 0 - 8
         $y = &random;
         if ($smatrix[$y][$x] eq " ") {     
            $k = &random + 1;    # value for matrix random 1 - 9
            $key = sprintf("%d", $k);        #    convert num to char
            $new_color = &check_number($y,$x,$key,$color); # check value
            if ($color eq $new_color) {  # check ok, new color not "red"
               $smatrix[$y][$x] = $key;
            } else {
               $new_color = $color;
               $i--;
            }
         } else {
            $i--;
         }
      }
      $logging = 0;          # set logging indicator off
      &compute_solution($pto_smatrix);
   }
   for ($i = 0; $i < 9; $i++) { 
      for ($j = 0; $j < 9; $j++) { 
         $work_matrix[$i][$j] = $smatrix[$i][$j];  # copy "solution"
         $gen_matrix[$i][$j] = " ";    # init gen_matrix
      }
   }

   # take a random symmetric pattern from the generated sudoku solution
   for ($i = 0; $i < 13; $i++) {
      $x = &random;     # random 0 - 8
      $y = &random;
      if ($gen_matrix[$y][$x] eq " ") {
         if ($cnt[$y / 3][$x / 3] < 3) {    
            $gen_matrix[$y][$x] = $work_matrix[$y][$x];  
            $gen_matrix[8-$y][8-$x] = $work_matrix[8-$y][8-$x];  
            $cnt[$y / 3][$x / 3]++;    
            $cnt[2 - ($y / 3)][2 - ($x / 3)]++;    
         } else {
            $i--;
         }
      } else {
         $i--;
      }
   }
   # the gen matrix contains the basic generated sudoku which in general has
   # many different solutions. It must now be enhanced to only provide the 
   # solution contained in the work matrix, using the solving routine 
   # "compute_solution", this will distort the pattern, but nevermind.

   $solution_found = 0;   # reset global indicator
   
   &compute_solution($pto_gen_matrix);

   # remove not needed entries, to reduce the "given" numbers. If taking away 
   # a given number results into a possible number equal to itself, it can be
   # left open.
 
   my $count1 = 0; 
   my $numbers;
   my $count2 = 0;
   for ($i = 0; $i < 9; $i++) { 
      locate(23,$nextdot++);
      print ".\n";                   # show sign of life to the user
      for ($j = 0; $j < 9; $j++) { 
         if ($gen_matrix[$i][$j] ne " ") {         # for each given number
            $count1++;
            $save_entry = $gen_matrix[$i][$j];     # save value
            $gen_matrix[$i][$j] = " ";             # blank it, and
            &possible_numbers($pto_gen_matrix);    # calculate possible numbers

            # if the only possibility for this place in the matrix is the 
            # saved entry, leave it blank, otherwise put it back 
            if ($save_entry ne $possible_matrix[$j][$i]) { 
               $gen_matrix[$i][$j] = $save_entry;  # put back saved entry 
            } else {
               $count2++;
            } 
         }
      }
   }
   
   # fill the playing matrix $smatrix
   for ($i = 0; $i < 9; $i++) { 
      for ($j = 0; $j < 9; $j++) { 
         $smatrix[$i][$j] = $gen_matrix[$i][$j];
      }
   }

   $txt_line ="One possible solution; enter ctrl-q or ctrl-g again";

   &disp_smatrix($pto_smatrix, $txt_line, $color);
   $txt_line = "";
   $numbers = $count1 - $count2;
   locate(23,1);
   print "Sudoku has $numbers numbers\n";

   $solution_found = 0;                       # reset values
   $max_solutions = $save_max_solutions;
   return;
}

sub save_sudoku {
   (my $pto_smatrix) = @_;
   my $msg = ""; my $rc;my $fname; my $tbrow;
   my $cdir = cwd;
   print color ('bold yellow');
   locate (10, 6); 
   print "                                                               ";
   locate (11, 6); 
   print " ----------Enter (path) filename to save sudoku--------------- ";
   locate (12, 6);
   print " | current directory:                                        | ";
   locate (13, 6);
   print " |                                                           | ";
   locate (14, 6);
   print " |==>                                                        | ";
   locate (15, 6);
   print " |                                                           | ";
   locate (16, 6);
   print " ------------------------------------------------------------- ";
   print locate(12, 28), $cdir;
   locate (14, 12); 
   print color ('reset');
   $fname = <STDIN> ;
   chomp $fname;
   if ($fname) {
      locate (15, 12); 
      open (SAVE, ">$fname") || ($rc = 1);
      if ($rc) {
         $msg = "open failed for $fname: $!";
      }else{
         print SAVE "current\n";
         foreach $tbrow (@{$pto_smatrix}) {
            print SAVE join(',',@{$tbrow}),"\n";
         }
         print SAVE "initial\n";
         foreach $tbrow (@smatrix_initial) {
            print SAVE join(',',@{$tbrow}),"\n";
         }
         close (SAVE);
         $msg = "Sudoku saved in $fname";
      }
   }
   &disp_smatrix($pto_smatrix, $msg);
}

sub load_sudoku {
   (my $pto_smatrix) = @_;
   my $msg = ""; my $line; my $i; my $rc; my $fname;
   my $record_sep_save;
   my $cdir = cwd;
   print color ('bold yellow');
   locate (10, 6);
   print "                                                               ";
   locate (11, 6);
   print " ----------Enter (path) filename to load sudoku--------------- ";
   locate (12, 6);
   print " | current directory:                                        | ";
   locate (13, 6);
   print " |                                                           | ";
   locate (14, 6);
   print " |==>                                                        | ";
   locate (15, 6);
   print " |                                                           | ";
   locate (16, 6);
   print " ------------------------------------------------------------- ";
   print locate(12, 28), $cdir;
   locate (14, 12);
   print color ('reset');
   $fname = <STDIN> ;
   chomp $fname;
   if ($fname) {
      locate (15, 12);
      open (SAVE, "$fname") || ($rc = 1);
      if ($rc) {
         $msg = "open failed for $fname: $!";
      }else{
         $i = 0; $line = "";
         $line = <SAVE>;
         $record_sep_save = $/;   # save record separator value
         if ($line =~ m/\r\n$/) {
            $/ = "\r\n";
         }
         chomp $line;
         if ($line eq "current") {
            $line = <SAVE> || ($rc = 1);
            chomp $line;
            while ((!$rc) && ($line ne "initial")) {
               @{$$pto_smatrix[$i++]} = (split(',',$line));
               $line = <SAVE> || ($rc = 1);
               chomp $line;
            }
            if (!$rc) {
               $i = 0;
               $line = <SAVE> || ($rc = 1);
               while (!$rc) {
                  chomp $line;
                  @{$smatrix_initial[$i++]} = (split(',',$line));
                  $line = <SAVE> || ($rc = 1);
               }
               $msg = "Sudoku loaded from $fname";
               $solution_found = 0;  # reset global var
            }else{
               $msg = "loading failed, wrong file format";
            }
         }else{
            $msg = "loading failed, wrong file format";
         }
         $/ = $record_sep_save;    #save record separator value
         close (SAVE);
      }   
   }
   &disp_smatrix($pto_smatrix, $msg);
}

sub help_info {
   print color ("reset");
   if ($^O eq "MSWin32") {
      cls;
      print color ("reset");
      system ("type sudoku.txt | more");# display the "man" page
   } 
   else {
      system ("man ./sudoku.6");    # display the "man" page
   }
}

sub ReadKeyb {
   my $key = "\xff";    # "dummy" value init
   my @event = ();
   my ($mode, $newmode);
   if ($^O eq "MSWin32") { # windows
      # used methods Mode, Input and Flush are from Win32::Console
 
      $mode = $winconsole->Mode() || die $^E;  # get current mode
      $newmode = $mode;
      $newmode &= ~(&ENABLE_LINE_INPUT | &ENABLE_ECHO_INPUT); # echo off
      $winconsole->Mode($newmode) || die $^E;  # set new mode    
      $winconsole->Flush || die $^E;           # flush input buffer


      # get input-event until keyboard pressed on char key or arrow key

      # event[0] is 1 when keyboard event
      # event[1] is 1 when key is pressed
      # event[2] is number repeats ( not used here )
      # event[3] is virtual key code 
      # event[4] is virtual scan code ( not used here)
      # event[5] is character in ascii if char key, otherwise 0
      # event[6] is control key (shift, ctrl, num etc) state. ( not used here)  

      @event = $winconsole->Input();           # get input event
      while  (!(($event[0] == 1 && $event[1] == 1) &&
             (($event[5] > 0) ||
             ($event[3] >= 37) && $event[3] <= 40))) {

         @event = $winconsole->Input();           # get input event
      }

      $winconsole->Flush || die $^E;           # flush the rest
      $winconsole->Mode($mode) || die $^E;     # reset current mode 

      if ($event[5] > 0) { # if character key pressed
         $key = sprintf("%c", $event[5]);   # convert ascii to char
      }
      else {
         $key = 'U' if ($event[3] == 38);   # arrow up
         $key = 'D' if ($event[3] == 40);   # arrow down
         $key = 'R' if ($event[3] == 39);   # arrow right
         $key = 'L' if ($event[3] == 37);   # arrow left
      }
   }
   else {      # Linux
      system ("stty",'raw','-echo','eol',"\001");
      $key = getc(STDIN);
      if ($key eq "\x1b") {      # 01b 05b ... are the arrow keys
         if (getc(STDIN) eq "\x5b") {   
            $arrow = getc(STDIN);       
            if      ($arrow eq "\x41") {
               $key = 'U';   # arrow up
            } elsif ($arrow eq "\x42") { 
               $key = 'D';   # arrow down
            } elsif ($arrow eq "\x43") { 
               $key = 'R';   # arrow to the right
            } elsif ($arrow eq "\x44") { 
               $key = 'L';   # arrow to the left
            }
         }
      }
      system ("stty",'-raw','echo','eol',"");
   }
   return $key;
}

sub play_numbers {
   (my $color, my $pto_smatrix) = @_;
   my $retcode;
   my $col = 3; my $y = 0;
   my $row = 2;  my $x = 0;
   my $arrow;
   my $key = "";
   my $disp_txt;
   locate ($row, $col);
# Keyboard entries can be queried with the "showkey -m" command 
# (gives hex values) in Linux.
   $key = &ReadKeyb();  # read before           
   while ($key ne "\x11") {         # while not Ctrl-q 
      if ($key eq 'L') {
         $col = $col - 4 unless (($col - 4) < 3);
         $x -= 1 unless (($x - 1) < 0);
      }
      if ($key eq 'R') {
         $col = $col + 4 unless (($col + 4) > 35);
         $x += 1 unless (($x + 1) > 8);
      }
      if ($key eq 'D') {
         $row = $row + 2 unless (($row + 2) > 18);
         $y += 1 unless (($y + 1) > 8);
      }
      if ($key eq 'U') {
         $row = $row - 2 unless (($row - 2) < 2);
         $y -= 1 unless (($y - 1) < 0);
      }
      if ($key eq "\x7f") {     # backspace char(delete) equals space 
         $key = " ";            # (so deleting can also be using spacebar)
      }

      locate ($row, $col);
      savepos;          # save sursor position ANSIScreen function

      if ($key =~ m/[1-9 ]/) { # check if entered value is number or space
         if ($smatrix_initial[$y][$x] eq " ") {  # if not a part of sudoku  
            $$pto_smatrix[$y][$x] = " "; # delete prev value before display new
            $new_color = check_number($y,$x,$key,$color); # check value
            $$pto_smatrix[$y][$x] = $key;
            print color ("$new_color");
            print $key;
            print color ("$color");
            loadpos;     # restore cursor position after print (ANSIScreen
                         # function)   
         }
      }

      # "bold green" is used as an indicator of the initial program phase
      if (($key eq "\x10") && ($color ne 'bold green')) {  # Ctrl-p,
                                        # toggle display "possible" numbers 
                                        # matrix and Sudoku matrix
         if ( $sudoku == 1 ) {   # show possible matrix     
            # find out for each empty place, what numbers are still possible
            $retcode = &possible_numbers($pto_smatrix);
            &disp_possible_matrix;
         } 
         else {                 # show sudoku matrix
            &disp_smatrix($pto_smatrix); 
            loadpos; 
         }
      }
      if (($key eq "\x18") && ($color ne 'bold green')) {  # Ctrl-x,
                                                           # execute solution
         if ($opt_d) {          # if debug option
            open (TEST,">sudoku_test.txt") || die "open error : $!";
            $logging = 1;
         } else {
            $logging = 0;
         }
         $retcode = &compute_solution($pto_smatrix);
         if ($solution_found) {
            if ($max_solutions > 1) {
               if ($solution_found < $max_solutions) {
                  $disp_txt = "$solved_txt, found $solution_found solution(s)"; 
               } else {
                  $disp_txt = "$solved_txt, $solution_found solutions or more"; 
               }
            } else {
               $disp_txt = $solved_txt;
            }
            &disp_smatrix($pto_smatrix_solution, $disp_txt);
         }else {
            &disp_smatrix($pto_smatrix_solution, $error_txt);
         }
         loadpos;
         close (TEST) if ($opt_d);
      } 
      if (($key eq "\x07") && ($color eq 'bold green')) {  # Ctrl-g,
                                        # generate a sudoku                
         &generate_sudoku;
         loadpos;
      }
      if (($key eq "\x13") && ($color ne 'bold green')) {  # Ctrl-s,
                                                      # save sudoku to file 
         &save_sudoku($pto_smatrix);
         loadpos;
      } 
      if (($key eq "\x0c") && ($color ne 'bold green')) {  # Ctrl-l,
                                                      # load sudoku from file 
         &load_sudoku($pto_smatrix);
         loadpos;
      } 
      if ($key eq "\x08") {                          # Ctrl-h,
                                                      # display help info 
         &help_info;
         if ($color ne 'bold green') {
            if ($sudoku == 1) {
               &disp_smatrix($pto_smatrix);
               loadpos;
            } else {
               &disp_possible_matrix;
            }
         } else {
            &disp_smatrix($pto_smatrix, $intro_txt, $color);
            loadpos;
         }
      } 
      $key = &ReadKeyb();  # read after           
   }   
}

# main

# display initial empty sudoku matrix
&disp_smatrix($pto_smatrix, $intro_txt);

# enter sudoku initial values ("green" color)
&play_numbers('bold green', $pto_smatrix); 

# save given sudoku (green nbrs) 

for ($y = 0; $y < 9; $y++) {
   for ($x = 0; $x < 9; $x++) {
      $smatrix_initial[$y][$x] = $smatrix[$y][$x];
   }
}

&disp_smatrix($pto_smatrix, $txt_line);  #redisplay sudoku matrix 

# solve the sudoku-puzzle (reset color)
&play_numbers('reset', $pto_smatrix); 

print locate(1, 1), color ('reset');     # reset color/cursor before quit
cls;      # Clear screen                   
