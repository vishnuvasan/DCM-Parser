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
our (@Functions,%Descriptions,%Parameter_Details,%Array_Details);
our ($DCM,@DCM_Data);


my $File=$ARGV[0];
DCM_File						($File);
Functions_Tag					('FUNKTIONEN');
End_Tag							('END');
Individual_Function_Tag			('FKT');
Function_Description_Separator	('""');
Parameter_Tag					('FESTWERT');
Description_Tag					('LANGNAME');
Function_Tag					('FUNKTION');
Unit_Tag						('EINHEIT_W');
Value_Tag						('WERT');
Text_Tag						('TEXT');
Array_Tag						('FESTWERTEBLOCK');

#List_Functions();
#List_Function_And_Description();
#Parameter_Finder();
#print "Size $#Parameters";
#foreach(@Parameters){print "Parameters : $_","\n";}
Array_Finder();


foreach my $key (keys(%Array_Details))
{
	print "\n Variable 	: $key \n";
	print " Size		: $Array_Details{$key}{'SIZE'} \n ";
	print " Description	: $Array_Details{$key}{'DESCRIPTION'} \n ";
	print " Function	: $Array_Details{$key}{'FUNCTION'} \n ";
	print " Unit		: $Array_Details{$key}{'UNIT'} \n ";
	print " Array Value : $Array_Details{$key}{'VALUE'}\n\n\n";
}

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


sub Parameter_Finder
{
	Load_DCM();

	my ($Parameter,$Description,$Function_Used,$Unit,$Value);
	
	for($Line=0;$Line<=$#DCM_Data;$Line++)
	{
		if($DCM_Data[$Line]=~/^$PARAMETER(\s).*$/)
		{
			$Parameter_Start=$Line;

			$Parameter_End=$Parameter_Start+1;
		
			while($DCM_Data[$Parameter_End]!~/^$END(\s.*)/) 
			{
				$Parameter_End+=1;
			}
			
			goto PARAMETER_SYNTHESIS;
		}
		
		PARAMETER_SYNTHESIS:

		for($Line1=$Parameter_Start;$Line1<$Parameter_End;$Line1++)
		{
			if($DCM_Data[$Line1]=~/^$PARAMETER(\s).*/)
			{
				$DCM_Data[$Line1]=~s/$PARAMETER//;
				$DCM_Data[$Line1]=~s/\s{2,10}//g;
				$Parameter=$DCM_Data[$Line1];
			}
			if($DCM_Data[$Line1]=~/^(\s*)$DESCRIPTION(\s).*/)
			{
				$DCM_Data[$Line1]=~s/$DESCRIPTION(\s)//;
				$DCM_Data[$Line1]=~s/\"//g;
				$DCM_Data[$Line2]=~s/\n//g;
				$DCM_Data[$Line1]=~s/\s{2,10}//g;
				$Description=$DCM_Data[$Line1];
				$Parameter_Details{$Parameter}{'DESCRIPTION'}=$Description;			
			}
			if($DCM_Data[$Line1]=~/^(\s*)$FUNCTION(\s).*/)
			{
				$DCM_Data[$Line1]=~s/$FUNCTION(\s)//;
				$DCM_Data[$Line1]=~s/\s{2,10}//g;
				$Function_Used=$DCM_Data[$Line1];
				$Parameter_Details{$Parameter}{'FUNCTION'}=$Function_Used;			
			}
			if($DCM_Data[$Line1]=~/^(\s*)$UNIT(\s).*/)
			{
				$DCM_Data[$Line1]=~s/$UNIT(\s)//;
				$DCM_Data[$Line1]=~s/\"//g;
				$DCM_Data[$Line1]=~s/\s{2,10}//g;
				$Unit=$DCM_Data[$Line1];
				if($Unit!~/\w/){$Unit='Nil';}
				$Parameter_Details{$Parameter}{'UNIT'}=$Unit;			
			}
			if($DCM_Data[$Line1]=~/^(\s*)$VALUE(\s).*|^(\s*)$TEXT(\s).*/)
			{
				$DCM_Data[$Line1]=~s/$VALUE(\s)//;
				$DCM_Data[$Line1]=~s/$TEXT(\s)//;
				$DCM_Data[$Line1]=~s/\s{2,10}//g;
				$Value=$DCM_Data[$Line1];
				$Parameter_Details{$Parameter}{'VALUE'}=eval($Value);			
			}
		} 
	}	
}


sub Array_Finder
{
	Load_DCM();

	my ($Array,@Row_Values,@Values,$Size,$Description,@Array_And_Size,$Function_Used,$Unit,$Value);
	
	for($Line=0;$Line<=$#DCM_Data;$Line++)
	{
		if($DCM_Data[$Line]=~/^$ARRAY(\s).*$/)
		{
			$Array_Start=$Line;

			$Array_End=$Array_Start+1;
		
			while($DCM_Data[$Array_End]!~/^$END(\s.*)/) 
			{
				$Array_End+=1;
			}
			
			my @Values;
	
			for($Line1=$Array_Start;$Line1<$Array_End;$Line1++)
			{
				if($DCM_Data[$Line1]=~/^$ARRAY(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$ARRAY//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$DCM_Data[$Line1]=~/(\d+)(\s*)$/;
					@Array=split(/\s/,$DCM_Data[$Line1]);
					$Size=$Array[2];
					$DCM_Data[$Line1]=~s/$Size//;
					$Array=$DCM_Data[$Line1];
					$Array_Details{$Array}{'SIZE'}=$Size;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$DESCRIPTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$DESCRIPTION(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line2]=~s/\n//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Description=$DCM_Data[$Line1];
					$Array_Details{$Array}{'DESCRIPTION'}=$Description;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$FUNCTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$FUNCTION(\s)//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Function_Used=$DCM_Data[$Line1];
					$Array_Details{$Array}{'FUNCTION'}=$Function_Used;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Unit=$DCM_Data[$Line1];
					if($Unit!~/\w/){$Unit='Nil';}
					$Array_Details{$Array}{'UNIT'}=$Unit;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$VALUE(\s).*|^(\s*)$TEXT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$VALUE(\s)//;
					$DCM_Data[$Line1]=~s/$TEXT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}/ /g;
					$Value=$DCM_Data[$Line1];
					@Row_Values=split(/\s{1,20}/,$Value);
					shift(@Row_Values);
					foreach(@Row_Values){push(@Values,$_);}
				}
				if($Line1 == ($Array_End-1))
				{
					push(@Values,']');
					unshift(@Values,'[');
					$string=join(" ",@Values);
					$Array_Details{$Array}{'VALUE'}=$string;
				}
			} 
		}
	}
}


sub No_Of_Parameters
{return $#Parameters;}

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
sub Array_Tag
{$ARRAY=shift;}


sub Load_DCM
{
	open DCM,$DCM or die "$DCM File Does not Exist.Execution Aborted";

	@DCM_Data=<DCM>;

	close DCM;
}

