#!/bin/perl

use strict;
use warnings;

use open qw/:std :encoding(UTF-8)/;
use utf8;

use Data::Dump qw(dump);
use Getopt::Long qw(GetOptions);

Getopt::Long::Configure qw(gnu_getopt);

my ( $p2f, $source, $output, %font_map, %filehandles, $string, @transcode, $temp );

GetOptions(
    'print-to-file|p' => \$p2f,
    'use|u=s'         => \$source,
    'help|h'          => \&usage,
) or die "Wrong arguements try $0 -h for help\n";

die "Font map file should be provided for the program to function\n" unless ($source );

$temp = restore_map($source);

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
"\nUsage: $0 [options] {file1.txt file2.txt..} \n\nExample: $0 -f TamilBible.ttf filter.txt\n\nif text is provided insrtead of file name, given text will be transcoded\n\nOptions:\n\n\t-u --use <source_file> generate font map from a source file.\n\t     The source file is the stored hash values of a previous mapping\n\n\t-p --print-to-file using this will output the transcoded text to the file appending the extension '.U' to the input file name. \n\t     If used with a input string, 'output.U' is created and the output is printed in that file\n\n\t-h --help - Prints help\n\nManual mapping of font is essential for using this program\n\n";
    exit 0;
}
