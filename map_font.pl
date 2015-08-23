#!/bin/perl -w

use strict;

use open qw/:std :encoding(UTF-8)/;
use Data::Dump qw(dump);

use Switch;

my ( %map_font, $beginning, $ending, $start, $finish, @chars, $key, $font );

print "Enter the name of the font map to be created: ";
chomp( $font = lc(<>) );

( $beginning, $ending ) = unicode_block();

$beginning =~ s/U\+(.*)/$1/;
$ending =~ s/U\+(.*)/$1/;

$font =~ s/ /_/;
$font =~ s/(.*?)\.ttf/$1.hash/;

$start  = hex($beginning);
$finish = hex($ending);

@chars = ( $start .. $finish );

foreach (@chars) {

    my $char = chr($_);
    next unless ( $char =~ /[[:print:]]/ );

    print "\nType the key for the Unicode Character    $char  : ";
    chomp( $key = <> );

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

sub unicode_block {

    my ( $choice, $uni_block, @print );

	$uni_block = "./unicode_block_name";

	open my $print_file, '<', $uni_block;

	while (<$print_file>){

		local $\ = undef;
		print $_;

	}
	
	close $print_file;

    print "Enter the unicode block number to be mapped (to choose manually press enter): ";
    chomp( $choice = <> );

    switch ($choice) {

        my ( $beg, $end );

        case 1   { $beg = "U+0000";   $end = "U+007F";   return ( $beg, $end ) }
        case 2   { $beg = "U+0080";   $end = "U+00FF";   return ( $beg, $end ) }
        case 3   { $beg = "U+0100";   $end = "U+017F";   return ( $beg, $end ) }
        case 4   { $beg = "U+0180";   $end = "U+024F";   return ( $beg, $end ) }
        case 5   { $beg = "U+0250";   $end = "U+02AF";   return ( $beg, $end ) }
        case 6   { $beg = "U+02B0";   $end = "U+02FF";   return ( $beg, $end ) }
        case 7   { $beg = "U+0300";   $end = "U+036F";   return ( $beg, $end ) }
        case 8   { $beg = "U+0370";   $end = "U+03FF";   return ( $beg, $end ) }
        case 9   { $beg = "U+0400";   $end = "U+04FF";   return ( $beg, $end ) }
        case 10  { $beg = "U+0500";   $end = "U+052F";   return ( $beg, $end ) }
        case 11  { $beg = "U+0530";   $end = "U+058F";   return ( $beg, $end ) }
        case 12  { $beg = "U+0590";   $end = "U+05FF";   return ( $beg, $end ) }
        case 13  { $beg = "U+0600";   $end = "U+06FF";   return ( $beg, $end ) }
        case 14  { $beg = "U+0700";   $end = "U+074F";   return ( $beg, $end ) }
        case 15  { $beg = "U+0750";   $end = "U+077F";   return ( $beg, $end ) }
        case 16  { $beg = "U+0780";   $end = "U+07BF";   return ( $beg, $end ) }
        case 17  { $beg = "U+07C0";   $end = "U+07FF";   return ( $beg, $end ) }
        case 18  { $beg = "U+0800";   $end = "U+083F";   return ( $beg, $end ) }
        case 19  { $beg = "U+0840";   $end = "U+085F";   return ( $beg, $end ) }
        case 20  { $beg = "U+08A0";   $end = "U+08FF";   return ( $beg, $end ) }
        case 21  { $beg = "U+0900";   $end = "U+097F";   return ( $beg, $end ) }
        case 22  { $beg = "U+0980";   $end = "U+09FF";   return ( $beg, $end ) }
        case 23  { $beg = "U+0A00";   $end = "U+0A7F";   return ( $beg, $end ) }
        case 24  { $beg = "U+0A80";   $end = "U+0AFF";   return ( $beg, $end ) }
        case 25  { $beg = "U+0B00";   $end = "U+0B7F";   return ( $beg, $end ) }
        case 26  { $beg = "U+0B80";   $end = "U+0BFF";   return ( $beg, $end ) }
        case 27  { $beg = "U+0C00";   $end = "U+0C7F";   return ( $beg, $end ) }
        case 28  { $beg = "U+0C80";   $end = "U+0CFF";   return ( $beg, $end ) }
        case 29  { $beg = "U+0D00";   $end = "U+0D7F";   return ( $beg, $end ) }
        case 30  { $beg = "U+0D80";   $end = "U+0DFF";   return ( $beg, $end ) }
        case 31  { $beg = "U+0E00";   $end = "U+0E7F";   return ( $beg, $end ) }
        case 32  { $beg = "U+0E80";   $end = "U+0EFF";   return ( $beg, $end ) }
        case 33  { $beg = "U+0F00";   $end = "U+0FFF";   return ( $beg, $end ) }
        case 34  { $beg = "U+1000";   $end = "U+109F";   return ( $beg, $end ) }
        case 35  { $beg = "U+10A0";   $end = "U+10FF";   return ( $beg, $end ) }
        case 36  { $beg = "U+1100";   $end = "U+11FF";   return ( $beg, $end ) }
        case 37  { $beg = "U+1200";   $end = "U+137F";   return ( $beg, $end ) }
        case 38  { $beg = "U+1380";   $end = "U+139F";   return ( $beg, $end ) }
        case 39  { $beg = "U+13A0";   $end = "U+13FF";   return ( $beg, $end ) }
        case 40  { $beg = "U+1400";   $end = "U+167F";   return ( $beg, $end ) }
        case 41  { $beg = "U+1680";   $end = "U+169F";   return ( $beg, $end ) }
        case 42  { $beg = "U+16A0";   $end = "U+16FF";   return ( $beg, $end ) }
        case 43  { $beg = "U+1700";   $end = "U+171F";   return ( $beg, $end ) }
        case 44  { $beg = "U+1720";   $end = "U+173F";   return ( $beg, $end ) }
        case 45  { $beg = "U+1740";   $end = "U+175F";   return ( $beg, $end ) }
        case 46  { $beg = "U+1760";   $end = "U+177F";   return ( $beg, $end ) }
        case 47  { $beg = "U+1780";   $end = "U+17FF";   return ( $beg, $end ) }
        case 48  { $beg = "U+1800";   $end = "U+18AF";   return ( $beg, $end ) }
        case 49  { $beg = "U+18B0";   $end = "U+18FF";   return ( $beg, $end ) }
        case 50  { $beg = "U+1900";   $end = "U+194F";   return ( $beg, $end ) }
        case 51  { $beg = "U+1950";   $end = "U+197F";   return ( $beg, $end ) }
        case 52  { $beg = "U+1980";   $end = "U+19DF";   return ( $beg, $end ) }
        case 53  { $beg = "U+19E0";   $end = "U+19FF";   return ( $beg, $end ) }
        case 54  { $beg = "U+1A00";   $end = "U+1A1F";   return ( $beg, $end ) }
        case 55  { $beg = "U+1A20";   $end = "U+1AAF";   return ( $beg, $end ) }
        case 56  { $beg = "U+1AB0";   $end = "U+1AFF";   return ( $beg, $end ) }
        case 57  { $beg = "U+1B00";   $end = "U+1B7F";   return ( $beg, $end ) }
        case 58  { $beg = "U+1B80";   $end = "U+1BBF";   return ( $beg, $end ) }
        case 59  { $beg = "U+1BC0";   $end = "U+1BFF";   return ( $beg, $end ) }
        case 60  { $beg = "U+1C00";   $end = "U+1C4F";   return ( $beg, $end ) }
        case 61  { $beg = "U+1C50";   $end = "U+1C7F";   return ( $beg, $end ) }
        case 62  { $beg = "U+1CC0";   $end = "U+1CCF";   return ( $beg, $end ) }
        case 63  { $beg = "U+1CD0";   $end = "U+1CFF";   return ( $beg, $end ) }
        case 64  { $beg = "U+1D00";   $end = "U+1D7F";   return ( $beg, $end ) }
        case 65  { $beg = "U+1D80";   $end = "U+1DBF";   return ( $beg, $end ) }
        case 66  { $beg = "U+1DC0";   $end = "U+1DFF";   return ( $beg, $end ) }
        case 67  { $beg = "U+1E00";   $end = "U+1EFF";   return ( $beg, $end ) }
        case 68  { $beg = "U+1F00";   $end = "U+1FFF";   return ( $beg, $end ) }
        case 69  { $beg = "U+2000";   $end = "U+206F";   return ( $beg, $end ) }
        case 70  { $beg = "U+2070";   $end = "U+209F";   return ( $beg, $end ) }
        case 71  { $beg = "U+20A0";   $end = "U+20CF";   return ( $beg, $end ) }
        case 72  { $beg = "U+20D0";   $end = "U+20FF";   return ( $beg, $end ) }
        case 73  { $beg = "U+2100";   $end = "U+214F";   return ( $beg, $end ) }
        case 74  { $beg = "U+2150";   $end = "U+218F";   return ( $beg, $end ) }
        case 75  { $beg = "U+2190";   $end = "U+21FF";   return ( $beg, $end ) }
        case 76  { $beg = "U+2200";   $end = "U+22FF";   return ( $beg, $end ) }
        case 77  { $beg = "U+2300";   $end = "U+23FF";   return ( $beg, $end ) }
        case 78  { $beg = "U+2400";   $end = "U+243F";   return ( $beg, $end ) }
        case 79  { $beg = "U+2440";   $end = "U+245F";   return ( $beg, $end ) }
        case 80  { $beg = "U+2460";   $end = "U+24FF";   return ( $beg, $end ) }
        case 81  { $beg = "U+2500";   $end = "U+257F";   return ( $beg, $end ) }
        case 82  { $beg = "U+2580";   $end = "U+259F";   return ( $beg, $end ) }
        case 83  { $beg = "U+25A0";   $end = "U+25FF";   return ( $beg, $end ) }
        case 84  { $beg = "U+2600";   $end = "U+26FF";   return ( $beg, $end ) }
        case 85  { $beg = "U+2700";   $end = "U+27BF";   return ( $beg, $end ) }
        case 86  { $beg = "U+27C0";   $end = "U+27EF";   return ( $beg, $end ) }
        case 87  { $beg = "U+27F0";   $end = "U+27FF";   return ( $beg, $end ) }
        case 88  { $beg = "U+2800";   $end = "U+28FF";   return ( $beg, $end ) }
        case 89  { $beg = "U+2900";   $end = "U+297F";   return ( $beg, $end ) }
        case 90  { $beg = "U+2980";   $end = "U+29FF";   return ( $beg, $end ) }
        case 91  { $beg = "U+2A00";   $end = "U+2AFF";   return ( $beg, $end ) }
        case 92  { $beg = "U+2B00";   $end = "U+2BFF";   return ( $beg, $end ) }
        case 93  { $beg = "U+2C00";   $end = "U+2C5F";   return ( $beg, $end ) }
        case 94  { $beg = "U+2C60";   $end = "U+2C7F";   return ( $beg, $end ) }
        case 95  { $beg = "U+2C80";   $end = "U+2CFF";   return ( $beg, $end ) }
        case 96  { $beg = "U+2D00";   $end = "U+2D2F";   return ( $beg, $end ) }
        case 97  { $beg = "U+2D30";   $end = "U+2D7F";   return ( $beg, $end ) }
        case 98  { $beg = "U+2D80";   $end = "U+2DDF";   return ( $beg, $end ) }
        case 99  { $beg = "U+2DE0";   $end = "U+2DFF";   return ( $beg, $end ) }
        case 100 { $beg = "U+2E00";   $end = "U+2E7F";   return ( $beg, $end ) }
        case 101 { $beg = "U+2E80";   $end = "U+2EFF";   return ( $beg, $end ) }
        case 102 { $beg = "U+2F00";   $end = "U+2FDF";   return ( $beg, $end ) }
        case 103 { $beg = "U+2FF0";   $end = "U+2FFF";   return ( $beg, $end ) }
        case 104 { $beg = "U+3000";   $end = "U+303F";   return ( $beg, $end ) }
        case 105 { $beg = "U+3040";   $end = "U+309F";   return ( $beg, $end ) }
        case 106 { $beg = "U+30A0";   $end = "U+30FF";   return ( $beg, $end ) }
        case 107 { $beg = "U+3100";   $end = "U+312F";   return ( $beg, $end ) }
        case 108 { $beg = "U+3130";   $end = "U+318F";   return ( $beg, $end ) }
        case 109 { $beg = "U+3190";   $end = "U+319F";   return ( $beg, $end ) }
        case 110 { $beg = "U+31A0";   $end = "U+31BF";   return ( $beg, $end ) }
        case 111 { $beg = "U+31C0";   $end = "U+31EF";   return ( $beg, $end ) }
        case 112 { $beg = "U+31F0";   $end = "U+31FF";   return ( $beg, $end ) }
        case 113 { $beg = "U+3200";   $end = "U+32FF";   return ( $beg, $end ) }
        case 114 { $beg = "U+3300";   $end = "U+33FF";   return ( $beg, $end ) }
        case 115 { $beg = "U+3400";   $end = "U+4DBF";   return ( $beg, $end ) }
        case 116 { $beg = "U+4DC0";   $end = "U+4DFF";   return ( $beg, $end ) }
        case 117 { $beg = "U+4E00";   $end = "U+9FFF";   return ( $beg, $end ) }
        case 118 { $beg = "U+A000";   $end = "U+A48F";   return ( $beg, $end ) }
        case 119 { $beg = "U+A490";   $end = "U+A4CF";   return ( $beg, $end ) }
        case 120 { $beg = "U+A4D0";   $end = "U+A4FF";   return ( $beg, $end ) }
        case 121 { $beg = "U+A500";   $end = "U+A63F";   return ( $beg, $end ) }
        case 122 { $beg = "U+A640";   $end = "U+A69F";   return ( $beg, $end ) }
        case 123 { $beg = "U+A6A0";   $end = "U+A6FF";   return ( $beg, $end ) }
        case 124 { $beg = "U+A700";   $end = "U+A71F";   return ( $beg, $end ) }
        case 125 { $beg = "U+A720";   $end = "U+A7FF";   return ( $beg, $end ) }
        case 126 { $beg = "U+A800";   $end = "U+A82F";   return ( $beg, $end ) }
        case 127 { $beg = "U+A830";   $end = "U+A83F";   return ( $beg, $end ) }
        case 128 { $beg = "U+A840";   $end = "U+A87F";   return ( $beg, $end ) }
        case 129 { $beg = "U+A880";   $end = "U+A8DF";   return ( $beg, $end ) }
        case 130 { $beg = "U+A8E0";   $end = "U+A8FF";   return ( $beg, $end ) }
        case 131 { $beg = "U+A900";   $end = "U+A92F";   return ( $beg, $end ) }
        case 132 { $beg = "U+A930";   $end = "U+A95F";   return ( $beg, $end ) }
        case 133 { $beg = "U+A960";   $end = "U+A97F";   return ( $beg, $end ) }
        case 134 { $beg = "U+A980";   $end = "U+A9DF";   return ( $beg, $end ) }
        case 135 { $beg = "U+A9E0";   $end = "U+A9FF";   return ( $beg, $end ) }
        case 136 { $beg = "U+AA00";   $end = "U+AA5F";   return ( $beg, $end ) }
        case 137 { $beg = "U+AA60";   $end = "U+AA7F";   return ( $beg, $end ) }
        case 138 { $beg = "U+AA80";   $end = "U+AADF";   return ( $beg, $end ) }
        case 139 { $beg = "U+AAE0";   $end = "U+AAFF";   return ( $beg, $end ) }
        case 140 { $beg = "U+AB00";   $end = "U+AB2F";   return ( $beg, $end ) }
        case 141 { $beg = "U+AB30";   $end = "U+AB6F";   return ( $beg, $end ) }
        case 142 { $beg = "U+AB70";   $end = "U+ABFF";   return ( $beg, $end ) }
        case 143 { $beg = "U+ABC0";   $end = "U+ABFF";   return ( $beg, $end ) }
        case 144 { $beg = "U+AC00";   $end = "U+D7AF";   return ( $beg, $end ) }
        case 145 { $beg = "U+D7B0";   $end = "U+D7FF";   return ( $beg, $end ) }
        case 146 { $beg = "U+D800";   $end = "U+DB7F";   return ( $beg, $end ) }
        case 147 { $beg = "U+DB80";   $end = "U+DBFF";   return ( $beg, $end ) }
        case 148 { $beg = "U+DC00";   $end = "U+DFFF";   return ( $beg, $end ) }
        case 149 { $beg = "U+E000";   $end = "U+F8FF";   return ( $beg, $end ) }
        case 150 { $beg = "U+F900";   $end = "U+FAFF";   return ( $beg, $end ) }
        case 151 { $beg = "U+FB00";   $end = "U+FB4F";   return ( $beg, $end ) }
        case 152 { $beg = "U+FB50";   $end = "U+FDFF";   return ( $beg, $end ) }
        case 153 { $beg = "U+FE00";   $end = "U+FE0F";   return ( $beg, $end ) }
        case 154 { $beg = "U+FE10";   $end = "U+FE1F";   return ( $beg, $end ) }
        case 155 { $beg = "U+FE20";   $end = "U+FE2F";   return ( $beg, $end ) }
        case 156 { $beg = "U+FE30";   $end = "U+FE4F";   return ( $beg, $end ) }
        case 157 { $beg = "U+FE50";   $end = "U+FE6F";   return ( $beg, $end ) }
        case 158 { $beg = "U+FE70";   $end = "U+FEFF";   return ( $beg, $end ) }
        case 159 { $beg = "U+FF00";   $end = "U+FFEF";   return ( $beg, $end ) }
        case 160 { $beg = "U+FFF0";   $end = "U+FFFF";   return ( $beg, $end ) }
        case 161 { $beg = "U+10000";  $end = "U+1007F";  return ( $beg, $end ) }
        case 162 { $beg = "U+10080";  $end = "U+100FF";  return ( $beg, $end ) }
        case 163 { $beg = "U+10100";  $end = "U+1013F";  return ( $beg, $end ) }
        case 164 { $beg = "U+10140";  $end = "U+1018F";  return ( $beg, $end ) }
        case 165 { $beg = "U+10190";  $end = "U+101CF";  return ( $beg, $end ) }
        case 166 { $beg = "U+101D0";  $end = "U+101FF";  return ( $beg, $end ) }
        case 167 { $beg = "U+10280";  $end = "U+1029F";  return ( $beg, $end ) }
        case 168 { $beg = "U+102A0";  $end = "U+102DF";  return ( $beg, $end ) }
        case 169 { $beg = "U+102E0";  $end = "U+102FF";  return ( $beg, $end ) }
        case 170 { $beg = "U+10300";  $end = "U+1032F";  return ( $beg, $end ) }
        case 171 { $beg = "U+10330";  $end = "U+1034F";  return ( $beg, $end ) }
        case 172 { $beg = "U+10350";  $end = "U+1037F";  return ( $beg, $end ) }
        case 173 { $beg = "U+10380";  $end = "U+1039F";  return ( $beg, $end ) }
        case 174 { $beg = "U+103A0";  $end = "U+103DF";  return ( $beg, $end ) }
        case 175 { $beg = "U+10400";  $end = "U+1044F";  return ( $beg, $end ) }
        case 176 { $beg = "U+10450";  $end = "U+1047F";  return ( $beg, $end ) }
        case 177 { $beg = "U+10480";  $end = "U+104AF";  return ( $beg, $end ) }
        case 178 { $beg = "U+10500";  $end = "U+1052F";  return ( $beg, $end ) }
        case 179 { $beg = "U+10530";  $end = "U+1056F";  return ( $beg, $end ) }
        case 180 { $beg = "U+10600";  $end = "U+1077F";  return ( $beg, $end ) }
        case 181 { $beg = "U+10800";  $end = "U+1083F";  return ( $beg, $end ) }
        case 182 { $beg = "U+10840";  $end = "U+1085F";  return ( $beg, $end ) }
        case 183 { $beg = "U+10860";  $end = "U+1087F";  return ( $beg, $end ) }
        case 184 { $beg = "U+10880";  $end = "U+108AF";  return ( $beg, $end ) }
        case 185 { $beg = "U+108E0";  $end = "U+108FF";  return ( $beg, $end ) }
        case 186 { $beg = "U+10900";  $end = "U+1091F";  return ( $beg, $end ) }
        case 187 { $beg = "U+10920";  $end = "U+1093F";  return ( $beg, $end ) }
        case 188 { $beg = "U+10980";  $end = "U+1099F";  return ( $beg, $end ) }
        case 189 { $beg = "U+109A0";  $end = "U+109FF";  return ( $beg, $end ) }
        case 190 { $beg = "U+10A00";  $end = "U+10A5F";  return ( $beg, $end ) }
        case 191 { $beg = "U+10A60";  $end = "U+10A7F";  return ( $beg, $end ) }
        case 192 { $beg = "U+10A80";  $end = "U+10A9F";  return ( $beg, $end ) }
        case 193 { $beg = "U+10AC0";  $end = "U+10AFF";  return ( $beg, $end ) }
        case 194 { $beg = "U+10B00";  $end = "U+10B3F";  return ( $beg, $end ) }
        case 195 { $beg = "U+10B40";  $end = "U+10B5F";  return ( $beg, $end ) }
        case 196 { $beg = "U+10B60";  $end = "U+10B7F";  return ( $beg, $end ) }
        case 197 { $beg = "U+10B80";  $end = "U+10BAF";  return ( $beg, $end ) }
        case 198 { $beg = "U+10C00";  $end = "U+10C4F";  return ( $beg, $end ) }
        case 199 { $beg = "U+10C80";  $end = "U+10CFF";  return ( $beg, $end ) }
        case 200 { $beg = "U+10E60";  $end = "U+10E7F";  return ( $beg, $end ) }
        case 201 { $beg = "U+11000";  $end = "U+1107F";  return ( $beg, $end ) }
        case 202 { $beg = "U+11080";  $end = "U+110CF";  return ( $beg, $end ) }
        case 203 { $beg = "U+110D0";  $end = "U+110FF";  return ( $beg, $end ) }
        case 204 { $beg = "U+11100";  $end = "U+1114F";  return ( $beg, $end ) }
        case 205 { $beg = "U+11150";  $end = "U+1117F";  return ( $beg, $end ) }
        case 206 { $beg = "U+11180";  $end = "U+111DF";  return ( $beg, $end ) }
        case 207 { $beg = "U+111E0";  $end = "U+111FF";  return ( $beg, $end ) }
        case 208 { $beg = "U+11200";  $end = "U+1124F";  return ( $beg, $end ) }
        case 209 { $beg = "U+11280";  $end = "U+112AF";  return ( $beg, $end ) }
        case 210 { $beg = "U+112B0";  $end = "U+112FF";  return ( $beg, $end ) }
        case 211 { $beg = "U+11300";  $end = "U+1137F";  return ( $beg, $end ) }
        case 212 { $beg = "U+11480";  $end = "U+114DF";  return ( $beg, $end ) }
        case 213 { $beg = "U+11580";  $end = "U+115FF";  return ( $beg, $end ) }
        case 214 { $beg = "U+11600";  $end = "U+1165F";  return ( $beg, $end ) }
        case 215 { $beg = "U+11680";  $end = "U+116CF";  return ( $beg, $end ) }
        case 216 { $beg = "U+11700";  $end = "U+1173F";  return ( $beg, $end ) }
        case 217 { $beg = "U+118A0";  $end = "U+118FF";  return ( $beg, $end ) }
        case 218 { $beg = "U+11AC0";  $end = "U+11AFF";  return ( $beg, $end ) }
        case 219 { $beg = "U+12000";  $end = "U+123FF";  return ( $beg, $end ) }
        case 220 { $beg = "U+12400";  $end = "U+1247F";  return ( $beg, $end ) }
        case 221 { $beg = "U+12480";  $end = "U+1254F";  return ( $beg, $end ) }
        case 222 { $beg = "U+13000";  $end = "U+1342F";  return ( $beg, $end ) }
        case 223 { $beg = "U+14400";  $end = "U+1467F";  return ( $beg, $end ) }
        case 224 { $beg = "U+16800";  $end = "U+16A3F";  return ( $beg, $end ) }
        case 225 { $beg = "U+16A40";  $end = "U+16A6F";  return ( $beg, $end ) }
        case 226 { $beg = "U+16AD0";  $end = "U+16AFF";  return ( $beg, $end ) }
        case 227 { $beg = "U+16B00";  $end = "U+16B8F";  return ( $beg, $end ) }
        case 228 { $beg = "U+16F00";  $end = "U+16F9F";  return ( $beg, $end ) }
        case 229 { $beg = "U+1B000";  $end = "U+1B0FF";  return ( $beg, $end ) }
        case 230 { $beg = "U+1BC00";  $end = "U+1BC9F";  return ( $beg, $end ) }
        case 231 { $beg = "U+1BCA0";  $end = "U+1BCAF";  return ( $beg, $end ) }
        case 232 { $beg = "U+1D000";  $end = "U+1D0FF";  return ( $beg, $end ) }
        case 233 { $beg = "U+1D100";  $end = "U+1D1FF";  return ( $beg, $end ) }
        case 234 { $beg = "U+1D200";  $end = "U+1D24F";  return ( $beg, $end ) }
        case 235 { $beg = "U+1D300";  $end = "U+1D35F";  return ( $beg, $end ) }
        case 236 { $beg = "U+1D360";  $end = "U+1D37F";  return ( $beg, $end ) }
        case 237 { $beg = "U+1D400";  $end = "U+1D7FF";  return ( $beg, $end ) }
        case 238 { $beg = "U+1D800";  $end = "U+1DAAF";  return ( $beg, $end ) }
        case 239 { $beg = "U+1E800";  $end = "U+1E8DF";  return ( $beg, $end ) }
        case 240 { $beg = "U+1EE00";  $end = "U+1EEFF";  return ( $beg, $end ) }
        case 241 { $beg = "U+1F000";  $end = "U+1F02F";  return ( $beg, $end ) }
        case 242 { $beg = "U+1F030";  $end = "U+1F09F";  return ( $beg, $end ) }
        case 243 { $beg = "U+1F0A0";  $end = "U+1F0FF";  return ( $beg, $end ) }
        case 244 { $beg = "U+1F100";  $end = "U+1F1FF";  return ( $beg, $end ) }
        case 245 { $beg = "U+1F200";  $end = "U+1F2FF";  return ( $beg, $end ) }
        case 246 { $beg = "U+1F300";  $end = "U+1F5FF";  return ( $beg, $end ) }
        case 247 { $beg = "U+1F600";  $end = "U+1F64F";  return ( $beg, $end ) }
        case 248 { $beg = "U+1F650";  $end = "U+1F67F";  return ( $beg, $end ) }
        case 249 { $beg = "U+1F680";  $end = "U+1F6FF";  return ( $beg, $end ) }
        case 250 { $beg = "U+1F700";  $end = "U+1F77F";  return ( $beg, $end ) }
        case 251 { $beg = "U+1F780";  $end = "U+1F7FF";  return ( $beg, $end ) }
        case 252 { $beg = "U+1F800";  $end = "U+1F8FF";  return ( $beg, $end ) }
        case 253 { $beg = "U+1F900";  $end = "U+1F9FF";  return ( $beg, $end ) }
        case 254 { $beg = "U+20000";  $end = "U+2A6DF";  return ( $beg, $end ) }
        case 255 { $beg = "U+2A700";  $end = "U+2B73F";  return ( $beg, $end ) }
        case 256 { $beg = "U+2B740";  $end = "U+2B81F";  return ( $beg, $end ) }
        case 257 { $beg = "U+2B820";  $end = "U+2CEAF";  return ( $beg, $end ) }
        case 258 { $beg = "U+2F800";  $end = "U+2FA1F";  return ( $beg, $end ) }
        case 259 { $beg = "U+E0000";  $end = "U+E007F";  return ( $beg, $end ) }
        case 260 { $beg = "U+E0100";  $end = "U+E01EF";  return ( $beg, $end ) }
        case 261 { $beg = "U+F0000";  $end = "U+FFFFF";  return ( $beg, $end ) }
        case 262 { $beg = "U+100000"; $end = "U+10FFFF"; return ( $beg, $end ) }
        else {

            print "Enter the beginning Unicode value of your Language's script: ";
            chomp( $beg = <> );

            print "Enter the last Unicode value of your Language's script: ";
            chomp( $end = <> );

            return ( $beg, $end );
        }
    }
}

