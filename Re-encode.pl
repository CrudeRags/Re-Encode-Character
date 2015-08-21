#!/bin/perl

use strict;
use warnings;

use open qw/:std :encoding(UTF-8)/;
use utf8;

use Data::Dump qw(dump);
use Getopt::Long qw(GetOptions);

Getopt::Long::Configure qw(gnu_getopt);

my ( $p2f, $font, $source, $output, %font_map, %filehandles, $string, @transcode, $temp );

GetOptions(
    'print-to-file|p' => \$p2f,
    'font|f=s'        => \$font,
    'use|u=s'         => \$source,
    'help|h'          => \&usage,
) or die "Wrong arguements try $0 -h for help\n";

die "Wrong usage: Both font name and font map has been provided. Both can't be used in a single run.\n\n Try $0 -h for help\n" if ( $font && $source );

die "Either font name or font map file should be provided for the program to function\n" unless ( $font || $source );

$temp = map_font($font)      unless ($source);
$temp = restore_map($source) unless ($font);

%font_map = %$temp;

my $replacechar = join( "|", map( quotemeta, sort { length $b <=> length $a } keys %font_map ) );

die "No input to transcode\n" unless (@ARGV);

foreach (@ARGV) {

    if ( !-f $_ ) {

        print "Given arguement is not a file. Transcoding the given text\n";
        $string = $_;
        push @transcode, $string;
        next;
    }

    open my $fh, '<', $_ or die "Can't open $_: $!\n";
    my $output_file = $_ . ".U";

    local $/ = undef;

    while (<$fh>) {

        $output = transcode( $_, \%font_map, $replacechar );

        output( $output, $output_file );
    }
    close $fh;
}

if (@transcode) {

    foreach (@transcode) {

        $output = transcode( $_, \%font_map, $replacechar );

        output($output);

    }
}

exit 0;

sub transcode {

    my ( $transcode_text, $hashstore, $replacechar ) = @_;

    my %replacement = %$hashstore;

    $transcode_text =~ s/h;/u;/g;       # Change as needed {added line due to error in the local files}
	$transcode_text =~ s/i(.)/$1i/g;    # Change as needed
    $transcode_text =~ s/N(.)/$1N/g;    # Change as needed {added to compensate for the composite letters}
    $transcode_text =~ s/n(.)/$1n/g;    # Change as needed {added to compensate for the composite letters}
    $transcode_text =~ s/($replacechar)/$replacement{$1}/g;

    return ($transcode_text);
}

sub output {

    my $filename;

    my ($output) = shift;
    $filename = shift if (@_);

    print "\n$output\n\n" unless ($p2f);

    if ($p2f) {

        $filename = "output.U" unless ($filename);
        open my $final, '>:encoding(UTF-8)', $filename;
        print $final "$output\n";
        close $final;

    }

    return;
}

sub map_font {

    my (%map_font, $beg, $end, $start, $finish, @chars, $key);
    my ($font) = shift;

    $font =~ s/ /_/;
    $font =~ s/(.*?)\.ttf/$1/;

	print "Enter the beginning Unicode value of your Language's script: ";
	chomp($beg = <>);

	print "Enter the last Unicode value of your Language's script: ";
	chomp($end = <>);

	$beg =~ s/U\+(.*)/$1/;
	$end =~ s/U\+(.*)/$1/;

	$start = hex($beg);
	$finish = hex($end);

	@chars = ($start .. $finish);

	foreach (@chars){
		
		my $char = chr($_);
		next unless ($char=~/[[:print:]]/);

		print "Type the key for the Unicode Character $char  : ";
		chomp($key = <>);

		next unless ($key);

		$map_font{$key} = $char;

	}

    print "\nAre there any extra letters in your font's keymap? (y/n): ";
    chomp( my $reply = lc(<>) );

    if ( $reply eq "y" ) {

        my ( $i, $e, $extrachar, $addchar, $exkey, @s );

        print "\nEnter the number of extra characters: ";
        chomp( $i = <> );
        for ( $e = 1 ; $e <= $i ; $e++ ) {

            print "\nEnter the Unicode value of the extra letter(Separate by '.' if composite letter): ";
            chomp( $extrachar = <> );

            if ( $extrachar =~ m/\./ ) {

                @s = split /\./, $extrachar;
                foreach (@s) { s/U\+(.*)/$1/ }
                $addchar = chr( hex( $s[0] ) ) . chr( hex( $s[1] ) );

            }
            else {

                $extrachar =~ s/U\+(.*)/$1/;
                $addchar = chr( hex($extrachar) );

            }

            print "\nEnter the key for $addchar   :";
            chomp( $exkey = <> );

            $map_font{$exkey} = $addchar;

        }
    }

    open my $mapout, '>', $font or die "can't open file";
    print $mapout dump( \%map_font );
    close $mapout;

    print "The Font has been mapped and saved to $mapout\n";

    return ( \%map_font );

}

sub restore_map {

    my ( %restore_map, $hash_source, $hash_string );

    $hash_source = shift;

    local $/ = undef;

    open my $in, '<', $hash_source or die "$hash_source can't be opened: $!";
    $hash_string = <$in>;

    %restore_map = %{ eval $hash_string };

    close $in;

    return ( \%restore_map );
}

sub usage {

    print
"\nUsage: $0 [options] {file1.txt file2.txt..} \n\nExample: $0 -f TamilBible.ttf filter.txt\n\nif text is provided insrtead of file name, given text will be transcoded\n\nOptions:\n\n\t-f --font fontname.ttf - used to pass font name\n\n\t-u --use <source_file> generate font map from a source file.\n\t     The source file is the stored hash values of a previous mapping\n\n\t-p --print-to-file using this will output the transcoded text to the file appending the extension '.U' to the input file name. \n\t     If used with a input string, 'output.U' is created and the output is printed in that file\n\n\t-h --help - Prints help\n\nManual mapping of font is essential for using this program\n\n";
    exit 0;
}
