#!/usr/bin/perl 
#===============================================================================
#
#         FILE: DCM_Function_Finder.pl
#
#        USAGE: ./DCM_Function_Finder.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 02/09/2014 10:21:50 PM
#     REVISION: ---
#===============================================================================

use warnings;

our ($FUNCTIONS,$END,$INDIVIDUAL_FUNCTION,$FUNCTION_DESCRIPTION_SEPARATOR);
our (@Functions,%Descriptions,%Parameter_Details);
our ($DCM,@DCM_Data);


my $File=$ARGV[0];
DCM_File						($File);
Functions_Tag					('FUNKTIONEN');
End_Tag							('END');
Individual_Function_Tag			('FKT');
Function_Description_Separator	('""');
Parameter_Tag					('FESTWERT');
Description_Tag					('LANGNAME');
Function_Tag					('FUNKTION')
Unit_Tag						('EINHEIT_W');
Value_Tag						('WERT');
Text_Tag						('TEXT');

#List_Functions();
List_Function_And_Description();

sub Function_Finder
{
	my (@Description_Separation,$Function_Name,$Function_Description,$Line,$Line1,$Function_Start,$Function_End);

	Load_DCM();

	for($Line=0;$Line<=$#DCM_Data;$Line++)
	{
		if($DCM_Data[$Line]=~/^$FUNCTIONS(\s.*)$/)
		{
			$Function_Start=$Line;

			$Function_End=$Function_Start+1;
		
			while($DCM_Data[$Function_End]!~/^$END(\s.*)/) 
			{
				$Function_End+=1;
			}
			goto PARSE_FUNCTION;
		}
	}	


	PARSE_FUNCTION:

	for($Line1=$Function_Start+1;$Line1<$Function_End;$Line1++)
	{
		
		@Description_Separation=split(/$FUNCTION_DESCRIPTION_SEPARATOR/,$DCM_Data[$Line1]);
	
		(($Function_Name=$Description_Separation[0])=~s/$INDIVIDUAL_FUNCTION//);

		$Function_Name=~s/(\s*)//g;

		($Function_Description=$Description_Separation[1])=~s/\"//g;

		push(@Functions,$Function_Name);

		$Descriptions{$Function_Name}=$Function_Description;
	
		print " Function Name : $Function_Name \n";
	}

	return (\@Functions,\%Descriptions);
};


sub List_Functions()
{
	my @Functions_List;
	$Functions_List=((Function_Finder())[0]);
	foreach my $Function_Name (@$Functions_List){print $Function_Name,"\n";}
	print "\nTotal Function Count : ",scalar(@$Functions_List),"\n";
	return (\@$Functions_List,scalar(@$Functions_List),join("|",@$Functions_List));
}
sub List_Function_And_Description()
{
	%$Descriptions=((Function_Finder($File))[2]);
	foreach my $a (keys(%Descriptions))
	{
		print "$a","=>","$Descriptions{$a} \n";
	}
	return \%Descriptions;
}

#Initialisation of Tags
sub DCM_File
{$DCM=shift;}
sub Functions_Tag
{$FUNCTIONS=shift;}
sub End_Tag
{$END=shift;}
sub Individual_Function_Tag
{$INDIVIDUAL_FUNCTION=shift;}
sub Function_Description_Separator
{$FUNCTION_DESCRIPTION_SEPARATOR=shift;}
sub Parameter_Tag
{$PARAMETER=shift;}
sub Description_Tag
{$DESCRIPTION=shift;}
sub Function_Tag
{$FUNCTION=shift;}
sub Unit_Tag
{$UNIT=shift;}
sub Value_Tag
{$VALUE=shift;}
sub Text_Tag
{$TEXT=shift;}

sub Load_DCM
{
	open DCM,$DCM or die "$DCM File Does not Exist.Execution Aborted";

	@DCM_Data=<DCM>;

	close DCM;
}

