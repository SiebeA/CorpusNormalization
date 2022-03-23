

# open the input file
my $f = shift;
my $TEXT = "";
open(INPUT, "< $f") or die("Unable to open file $f.\n");
while(<INPUT>) {
	#$TEXT .= $_;
  # covered cases: number with(out) comma, with(out) dot, with(out) million or billion or trillion.

if ($_ =~ m/[\$€¥£]\d+/) {
  my $new=$_;
  # Converting dollars
  $new =~ s/\$(\d+\,\d+\.\d+ trillion)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+ trillion)/$1 dollars/ig;
  $new =~ s/\$(\d+\.\d+ trillion)/$1 dollars/ig;
  $new =~ s/\$(\d+ trillion)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+\.\d+ billion)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+ billion)/$1 dollars/ig;
  $new =~ s/\$(\d+\.\d+ billion)/$1 dollars/ig;
  $new =~ s/\$(\d+ billion)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+\.\d+ million)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+ million)/$1 dollars/ig;
  $new =~ s/\$(\d+\.\d+ million)/$1 dollars/ig;
  $new =~ s/\$(\d+ million)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+\.\d+)/$1 dollars/ig;
  $new =~ s/\$(\d+\,\d+)/$1 dollars/ig;
  $new =~ s/\$(\d+\.\d+)/$1 dollars/ig;
  if ( /\$1 / ) { $new =~ s/(\$1 )/1 dollar /ig; }
  $new =~ s/\$(\d+)/$1 dollars/ig;

  # Converting euro
  $new =~ s/€(\d+\,\d+\.\d+ trillion)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+ trillion)/$1 euro/ig;
  $new =~ s/€(\d+\.\d+ trillion)/$1 euro/ig;
  $new =~ s/€(\d+ trillion)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+\.\d+ billion)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+ billion)/$1 euro/ig;
  $new =~ s/€(\d+\.\d+ billion)/$1 euro/ig;
  $new =~ s/€(\d+ billion)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+\.\d+ million)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+ million)/$1 euro/ig;
  $new =~ s/€(\d+\.\d+ million)/$1 euro/ig;
  $new =~ s/€(\d+ million)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+\.\d+)/$1 euro/ig;
  $new =~ s/€(\d+\,\d+)/$1 euro/ig;
  $new =~ s/€(\d+\.\d+)/$1 euro/ig;
  # if ( /€1 / ) { $new =~ s/(€1 )/1 euro /ig; }
  $new =~ s/€(\d+)/$1 euro/ig;

  # Converting yen
  $new =~ s/¥(\d+\,\d+\.\d+ trillion)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+ trillion)/$1 yen/ig;
  $new =~ s/¥(\d+\.\d+ trillion)/$1 yen/ig;
  $new =~ s/¥(\d+ trillion)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+\.\d+ billion)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+ billion)/$1 yen/ig;
  $new =~ s/¥(\d+\.\d+ billion)/$1 yen/ig;
  $new =~ s/¥(\d+ billion)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+\.\d+ million)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+ million)/$1 yen/ig;
  $new =~ s/¥(\d+\.\d+ million)/$1 yen/ig;
  $new =~ s/¥(\d+ million)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+\.\d+)/$1 yen/ig;
  $new =~ s/¥(\d+\,\d+)/$1 yen/ig;
  $new =~ s/¥(\d+\.\d+)/$1 yen/ig;
  # if ( /¥1 / ) { $new =~ s/(¥1 )/1 yen /ig; }
  $new =~ s/¥(\d+)/$1 yen/ig;

  # Converting pounds
  $new =~ s/£(\d+\,\d+\.\d+ trillion)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+ trillion)/$1 pounds/ig;
  $new =~ s/£(\d+\.\d+ trillion)/$1 pounds/ig;
  $new =~ s/£(\d+ trillion)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+\.\d+ billion)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+ billion)/$1 pounds/ig;
  $new =~ s/£(\d+\.\d+ billion)/$1 pounds/ig;
  $new =~ s/£(\d+ billion)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+\.\d+ million)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+ million)/$1 pounds/ig;
  $new =~ s/£(\d+\.\d+ million)/$1 pounds/ig;
  $new =~ s/£(\d+ million)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+\.\d+)/$1 pounds/ig;
  $new =~ s/£(\d+\,\d+)/$1 pounds/ig;
  $new =~ s/£(\d+\.\d+)/$1 pounds/ig;
  if ( /£1 / ) { $new =~ s/(£1 )/1 pound /ig; }
  $new =~ s/£(\d+)/$1 pounds/ig;
  print $new
  }
else {
  print $_
  }
}
close(INPUT);
