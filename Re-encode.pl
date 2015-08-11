#!/bin/perl
use strict;
use warnings;
use open ':std';
use open ':encoding(UTF-8)';
use Encode qw( encode decode );
use Data::Dump qw(dump);
use Getopt::Long qw(GetOptions);
Getopt::Long::Configure qw(gnu_getopt);

my $font;
my %map;
GetOptions(
	'font|f=s' => \$font,
	'help|h' => \&usage,
	) or die "Try $0 -h for help";
print "Do you want to map $font? (y/n)";
chomp (my $answer = lc <STDIN>);
$font = lc($font);
$font =~ s/ /_/;
$font =~ s/(.*?)\.ttf/$1/;	
if ($answer eq "y") {map_font()} else {restore_map()}

foreach (@ARGV){
	my $modfile = "$_";
	$modfile =~ s/.*\/(.*)/uni$1/;
	process_file($_,$modfile);
	}

sub process_file {
	my @options = @_;
	open my $source, '<', "$options[0]";
	my $result = $options[1];
	my $test = "./text";
	my $missingchar = join("|", map(quotemeta, sort { length $b <=> length $a } keys %map));
	while (<$source>) {
		$/ = undef;
		s/h;/u;/g;  
		s/N(.)/$1N/g;
		s/n(.)/$1n/g;                     #slurp locally
		s/($missingchar)/$map{$1}/g;
		print "$_";	
		open my $final, '>:utf8', "$result";
		print $final "$_";
		close $final;
	}
}



sub map_font {
	my @oddhexes = qw/0B95 0B99 0B9A 0B9E 0B9F 0BA3 0BA4 0BA8 0BAA 0BAE 0BAF 0BB0 0BB2 0BB5 0BB3 0BB4 0BB1 0BA9/;
	my @missingletters = qw/0BC1 0BC2/;
	my @rest = qw/0B85 0B86 0B87 0B88 0B89 0B8A 0B8E 0B8F 0B90 0B92 0B93 0B83  0BBE  0BBF  0BC0  0BC6  0BC7  0BC8  0BCD  0B9C  0BB7  0BB8  0BB9 0BCB 0BCA 0BCC/;
	foreach (@oddhexes) {
		my $oddhex = $_;
		$_ = encode('utf8', chr(hex($_)));
		print "Press the key for $_   :";
		chomp (my $bole = <STDIN>);
		if ($bole eq "") {next};
		$map{$bole} = $_;
		foreach (@missingletters) {
			my $oddchar = encode('utf8', chr(hex($oddhex)).chr(hex($_)));
			print "Press the key for $oddchar   :";
			chomp (my $missingchar = <STDIN>);
			if ($missingchar eq ""){next}
			$map{$missingchar} = $oddchar;
		}
	}
	foreach (@rest) {
		$_ = encode('utf8', chr(hex($_)));
		print "Press the key for $_   :";
		chomp (my $misc = <STDIN>);
		if ($misc eq "") {next};
		$map{$misc} = $_;
	}
	open my $OUTPUT, '>', $font || die "can't open file";
	print $OUTPUT dump (\%map);
	close $OUTPUT;
}



sub restore_map {
	open my $in, '<', "$font" || die "can't open file: $!";
		{
			local $/;
			%map = %{ eval <$in> };
		}
	close $in;
}


sub usage {
print "\nUsage: $0 [options] {file1.txt file2.txt..} \neg: $0 -f TamilBible.ttf chapter.txt\n\nOptions:\n  -f --font - used to pass font name\n  -h --help - Prints help\n\nManual mapping of font is essential for using this program\n";
exit;
}	
