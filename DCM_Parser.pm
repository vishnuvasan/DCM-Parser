###################################################################################################################################################################################
###################################################################################################################################################################################

##	TOOL			:	DCM PARSER

##	VERSION 		: 	1.0

##	COMMENT			: 	A Generic Library to Parse DCM Files

##	USAGE			:	Read the How_To_Use_Me File to Know about the APIs you can play with

##	AUTHOR 			: 	Vishnu Vasan Nehru

##	CONTACT			: 	vishnuvasan@vishnuvasan.com

##	LICENSE			:	Licensed under GPL.For More Details visit https://gnu.org/licenses/gpl.html

##					This Software Should not be used for Any Kind of Commercial Purpose without the Author's Consent.

##	RELEASE REASON		: 	Initial Release			

##	RELEASE DATE 		: 	18.02.2014

##	For Any Queries/Bug Related Information, Please Feel Free to drop me a mail.

####################################################################################################################################################################################
####################################################################################################################################################################################


package DCM_Parser;
use Exporter;
#use warnings;
our $VERSION='1.0';
@ISA = qw(Exporter);

@EXPORT = qw(DCM_File Default_Tags Functions_Tag End_Tag Individual_Function_Tag Function_Description_Separator Parameter_Tag Description_Tag Function_Tag Unit_Tag Value_Tag Text_Tag Array_Tag Group_Curve_Tag X_Axis_Variable_Tag X_Axis_Tag X_Axis_Unit_Tag Distribution_Tag Map_Tag Y_Axis_Variable_Tag Y_Axis_Tag Y_Axis_Unit_Tag Load_DCM Function_Finder Functions Functions_Count Functions_All Functions_Print Functions_And_Description Functions_And_Description_Count Functions_And_Description_All Functions_And_Description_Print Parameters Parameters_Count Parameters_All Parameters_Print Parameters_Details Parameters_Details_Print Arrays Arrays_Count Arrays_All Arrays_Print Arrays_Details Arrays_Details_Print Group_Curves Group_Curves_Count Group_Curves_All Group_Curves_Print Group_Curves_Details Group_Curves_Details_Print Distributions Distributions_Count Distributions_All Distributions_Print Distributions_Details Distributions_Details_Print Maps Maps_Count Maps_All Maps_Print Maps_Details Maps_Details_Print All_Variable_Details);


our ($FUNCTIONS,$END,$INDIVIDUAL_FUNCTION,$FUNCTION_DESCRIPTION_SEPARATOR);
our (%Descriptions,%Parameter_Details,%Array_Details,%Grp_Curve_Details,%Distribution_Details,%Map_Details,%All_Details);
our ($DCM,@DCM_Data);

sub Default_Tags
{
	my $TagValue=shift;

	if(!$TagValue)
	{
		Functions_Tag					('FUNKTIONEN');
		End_Tag						('END');
		Individual_Function_Tag				('FKT');
		Function_Description_Separator			('""');
		Parameter_Tag					('FESTWERT');
		Description_Tag					('LANGNAME');
		Function_Tag					('FUNKTION');
		Unit_Tag					('EINHEIT_W');
		Value_Tag					('WERT');
		Text_Tag					('TEXT');
		Array_Tag					('FESTWERTEBLOCK');
		Group_Curve_Tag					('GRUPPENKENNLINIE');
		X_Axis_Variable_Tag				('SSTX');
		X_Axis_Tag					('ST\/X');
		X_Axis_Unit_Tag					('EINHEIT_X');
		Y_Axis_Variable_Tag				('SSTY');
		Y_Axis_Tag					('ST\/Y');
		Y_Axis_Unit_Tag					('EINHEIT_Y');
		Distribution_Tag				('STUETZSTELLENVERTEILUNG');
		Map_Tag						('GRUPPENKENNFELD');
	}
	else
	{ 
		#User Has to Give His Own Tags from his perl file for Parsing Or Else the Library will Fail
	}
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

		$Descriptions{$Function_Name}=$Function_Description;
	}
	
	return (\%Descriptions);
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
					$DCM_Data[$Line1]=~s/(\s)$Size//;
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


sub Group_Curve_Finder
{
	Load_DCM();

	my ($Grp_Curve,@Row_Values,@Row_Values1,$Values1,@Values,@X_Axis_Values,$Size,$Description,@Grp_Curve_And_Size,$Function_Used,$Unit,$Value);
	
	for($Line=0;$Line<=$#DCM_Data;$Line++)
	{
		if($DCM_Data[$Line]=~/^$GROUP_CURVE(\s).*$/)
		{
			$Grp_Curve_Start=$Line;

			$Grp_Curve_End=$Grp_Curve_Start+1;
		
			while($DCM_Data[$Grp_Curve_End]!~/^$END(\s.*)/) 
			{
				$Grp_Curve_End+=1;
			}
			
			my (@Values,@X_Axis_Values,@Row_Values,@Row_Values1);
	
			for($Line1=$Grp_Curve_Start;$Line1<$Grp_Curve_End;$Line1++)
			{
				if($DCM_Data[$Line1]=~/^$GROUP_CURVE(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$GROUP_CURVE//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$DCM_Data[$Line1]=~/(\d+)(\s*)$/;
					@Grp_Curve_And_Size=split(/\s/,$DCM_Data[$Line1]);
					$Size=$Grp_Curve_And_Size[2];
					$DCM_Data[$Line1]=~s/(\s)$Size//;
					$Grp_Curve=$DCM_Data[$Line1];
					$Grp_Curve_Details{$Grp_Curve}{'SIZE'}=$Size;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$DESCRIPTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$DESCRIPTION(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line2]=~s/\n//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Description=$DCM_Data[$Line1];
					$Grp_Curve_Details{$Grp_Curve}{'DESCRIPTION'}=$Description;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$FUNCTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$FUNCTION(\s)//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Function_Used=$DCM_Data[$Line1];
					$Grp_Curve_Details{$Grp_Curve}{'FUNCTION'}=$Function_Used;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$X_AXIS_UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS_UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$X_Axis_Unit=$DCM_Data[$Line1];
					if($X_Axis_Unit!~/\w/){$X_Axis_Unit='Nil';}
					$Grp_Curve_Details{$Grp_Curve}{'X-AXIS-UNIT'}=$X_Axis_Unit;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Unit=$DCM_Data[$Line1];
					if($Unit!~/\w/){$Unit='Nil';}
					$Grp_Curve_Details{$Grp_Curve}{'UNIT'}=$Unit;			
				}
				if($DCM_Data[$Line1]=~/$X_AXIS_VARIABLE(\s)/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS_VARIABLE(\s)//;
					$DCM_Data[$Line1]=~s/\"|\*//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$X_Axis_Variable=$DCM_Data[$Line1];
					$Grp_Curve_Details{$Grp_Curve}{'X-AXIS-VARIABLE'}=$X_Axis_Variable;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$X_AXIS(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS(\s)//;
					$DCM_Data[$Line1]=~s/$TEXT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}/ /g;
					$Value1=$DCM_Data[$Line1];
					@Row_Values1=split(/\s{1,20}/,$Value1);
					shift(@Row_Values1);
					foreach(@Row_Values1){push(@X_Axis_Values,$_);}#print " X Axis Values : $_ \n";}
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
				if($Line1 == ($Grp_Curve_End-1))
				{
					push(@Values,']');
					unshift(@Values,'[');
					$string=join(" ",@Values);
					foreach(@X_Axis_Values){}#print"B4 Joining : $Grp_Curve ==> $_ \n";}
					push(@X_Axis_Values,']');
					unshift(@X_Axis_Values,'[');
					$string1=join(" ",@X_Axis_Values);
					$Grp_Curve_Details{$Grp_Curve}{'X-AXIS-VALUE'}=$string1;
					$Grp_Curve_Details{$Grp_Curve}{'VALUE'}=$string;
					undef @X_Axis_Values;
				}
			} 
		}
	}
}

sub Distribution_Finder
{
	Load_DCM();

	my ($Distribution,@Row_Values,,@Row_Values1,$Values1,@Values,@X_Axis_Values,$Size,$Description,@Distribution_And_Size,$Function_Used,$Unit,$Value);
	
	for($Line=0;$Line<=$#DCM_Data;$Line++)
	{
		if($DCM_Data[$Line]=~/^$DISTRIBUTION(\s).*$/)
		{
			$Distribution_Start=$Line;

			$Distribution_End=$Distribution_Start+1;
			
			while($DCM_Data[$Distribution_End]!~/^$END(\s.*)/) 
			{
				$Distribution_End+=1;
			}
			
			my (@Values,@X_Axis_Values,@Row_Values,@Row_Values1);
	
			for($Line1=$Distribution_Start;$Line1<$Distribution_End;$Line1++)
			
			{ 
				if($DCM_Data[$Line1]=~/^$DISTRIBUTION(\s).*/) 
				{
					$DCM_Data[$Line1]=~s/$DISTRIBUTION//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$DCM_Data[$Line1]=~/(\d+)(\s*)$/;
					@Distribution_And_Size=split(/\s/,$DCM_Data[$Line1]);
					$Size=$Distribution_And_Size[2];
					$DCM_Data[$Line1]=~s/(\s)$Size//;
					$Distribution=$DCM_Data[$Line1];
					$Distribution_Details{$Distribution}{'SIZE'}=$Size;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$DESCRIPTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$DESCRIPTION(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line2]=~s/\n//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Description=$DCM_Data[$Line1];
					$Distribution_Details{$Distribution}{'DESCRIPTION'}=$Description;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$FUNCTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$FUNCTION(\s)//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Function_Used=$DCM_Data[$Line1];
					$Distribution_Details{$Distribution}{'FUNCTION'}=$Function_Used;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$X_AXIS_UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS_UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$X_Axis_Unit=$DCM_Data[$Line1];
					if($X_Axis_Unit!~/\w/){$X_Axis_Unit='Nil';}
					$Distribution_Details{$Distribution}{'X-AXIS-UNIT'}=$X_Axis_Unit;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Unit=$DCM_Data[$Line1];
					if($Unit!~/\w/){$Unit='Nil';}
					$Distribution_Details{$Distribution}{'UNIT'}=$Unit;			
				}
				if($DCM_Data[$Line1]=~/$X_AXIS_VARIABLE(\s)/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS_VARIABLE(\s)//;
					$DCM_Data[$Line1]=~s/\"|\*//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$X_Axis_Variable=$DCM_Data[$Line1];
					$Grp_Curve_Details{$Grp_Curve}{'X-AXIS-VARIABLE'}=$X_Axis_Variable;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$X_AXIS(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS(\s)//;
					$DCM_Data[$Line1]=~s/$TEXT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}/ /g;
					$Value1=$DCM_Data[$Line1];
					@Row_Values1=split(/\s{1,20}/,$Value1);
					shift(@Row_Values1);
					foreach(@Row_Values1){push(@X_Axis_Values,$_);}#print " X Axis Values : $_ \n";}
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
				if($Line1 == ($Distribution_End-1))
				{
					push(@Values,']');
					unshift(@Values,'[');
					$string=join(" ",@Values);
					foreach(@X_Axis_Values){}#print"B4 Joining : $Grp_Curve ==> $_ \n";}
					push(@X_Axis_Values,']');
					unshift(@X_Axis_Values,'[');
					$string1=join(" ",@X_Axis_Values);
					$Distribution_Details{$Distribution}{'X-AXIS-VALUE'}=$string1;
					$Distribution_Details{$Distribution}{'VALUE'}=$string;
					undef @X_Axis_Values;
				}
			} 
		}
	}
}


sub Map_Finder
{
	Load_DCM();

	my ($Map,@Row_Values,@Row_Values1,@Row_Values2,$Values1,@Values,$Values2,@X_Axis_Values,@Y_Axis_Values,$X_Size,$Y_Size,$Description,@Map_And_Size,$Function_Used,$Unit,$Value);
	
	for($Line=0;$Line<=$#DCM_Data;$Line++)
	{
		if($DCM_Data[$Line]=~/^$MAP(\s).*$/)
		{
			$Map_Start=$Line;

			$Map_End=$Map_Start+1;
			
			while($DCM_Data[$Map_End]!~/^$END(\s.*)/) 
			{
				$Map_End+=1;
			}
			
			my (@Values,@X_Axis_Values,@Y_Axis_Values,@Row_Values,@Row_Values1,@Row_Values2);
	
			for($Line1=$Map_Start;$Line1<$Map_End;$Line1++)
			
			{ 
				if($DCM_Data[$Line1]=~/^$MAP(\s).*/) 
				{
					$DCM_Data[$Line1]=~s/$MAP//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$DCM_Data[$Line1]=~/(\d+)(\s*)$/;
					@Distribution_And_Size=split(/\s/,$DCM_Data[$Line1]);
					$X_Size=$Distribution_And_Size[2];
					$Y_Size=$Distribution_And_Size[3];
					$DCM_Data[$Line1]=~s/$X_Size//;
					$DCM_Data[$Line1]=~s/$Y_Size//;
					$Map=$DCM_Data[$Line1];
					$Map_Details{$Map}{'X-SIZE'}=$X_Size;		
					$Map_Details{$Map}{'Y-SIZE'}=$Y_Size;
				}
				if($DCM_Data[$Line1]=~/^(\s*)$DESCRIPTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$DESCRIPTION(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line2]=~s/\n//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Description=$DCM_Data[$Line1];
					$Map_Details{$Map}{'DESCRIPTION'}=$Description;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$FUNCTION(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$FUNCTION(\s)//;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Function_Used=$DCM_Data[$Line1];
					$Map_Details{$Map}{'FUNCTION'}=$Function_Used;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$X_AXIS_UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS_UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$X_Axis_Unit=$DCM_Data[$Line1];
					if($X_Axis_Unit!~/\w/){$X_Axis_Unit='Nil';}
					$Map_Details{$Map}{'X-AXIS-UNIT'}=$X_Axis_Unit;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$Y_AXIS_UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$Y_AXIS_UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Y_Axis_Unit=$DCM_Data[$Line1];
					if($Y_Axis_Unit!~/\w/){$Y_Axis_Unit='Nil';}
					$Map_Details{$Map}{'Y-AXIS-UNIT'}=$Y_Axis_Unit;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$UNIT(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$UNIT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Unit=$DCM_Data[$Line1];
					if($Unit!~/\w/){$Unit='Nil';}
					$Map_Details{$Map}{'UNIT'}=$Unit;			
				}
				if($DCM_Data[$Line1]=~/$X_AXIS_VARIABLE(\s)/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS_VARIABLE(\s)//;
					$DCM_Data[$Line1]=~s/\"|\*//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$X_Axis_Variable=$DCM_Data[$Line1];
					$Map_Details{$Map}{'X-AXIS-VARIABLE'}=$X_Axis_Variable;			
				}
				if($DCM_Data[$Line1]=~/$Y_AXIS_VARIABLE(\s)/)
				{
					$DCM_Data[$Line1]=~s/$Y_AXIS_VARIABLE(\s)//;
					$DCM_Data[$Line1]=~s/\"|\*//g;
					$DCM_Data[$Line1]=~s/\s{2,10}//g;
					$Y_Axis_Variable=$DCM_Data[$Line1];
					$Map_Details{$Map}{'Y-AXIS-VARIABLE'}=$Y_Axis_Variable;			
				}
				if($DCM_Data[$Line1]=~/^(\s*)$X_AXIS(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$X_AXIS(\s)//;
					$DCM_Data[$Line1]=~s/$TEXT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}/ /g;
					$Value1=$DCM_Data[$Line1];
					@Row_Values1=split(/\s{1,20}/,$Value1);
					shift(@Row_Values1);
					foreach(@Row_Values1){push(@X_Axis_Values,$_);}#print " X Axis Values : $_ \n";}
				}
				if($DCM_Data[$Line1]=~/^(\s*)$Y_AXIS(\s).*/)
				{
					$DCM_Data[$Line1]=~s/$Y_AXIS(\s)//;
					$DCM_Data[$Line1]=~s/$TEXT(\s)//;
					$DCM_Data[$Line1]=~s/\"//g;
					$DCM_Data[$Line1]=~s/\s{2,10}/ /g;
					$Value2=$DCM_Data[$Line1];
					@Row_Values2=split(/\s{1,20}/,$Value2);
					shift(@Row_Values2);
					foreach(@Row_Values2){push(@Y_Axis_Values,$_);}#print " X Axis Values : $_ \n";}
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
				if($Line1 == ($Map_End-1))
				{
					push(@Values,']');
					unshift(@Values,'[');
					$string=join(" ",@Values);
					foreach(@X_Axis_Values){}#print"B4 Joining : $Grp_Curve ==> $_ \n";}
					push(@X_Axis_Values,']');
					unshift(@X_Axis_Values,'[');
					$string1=join(" ",@X_Axis_Values);
					$string2=join(" ",@Y_Axis_Values);
					$Map_Details{$Map}{'X-AXIS-VALUE'}=$string1;
					$Map_Details{$Map}{'Y-AXIS-VALUE'}=$string2;
					$Map_Details{$Map}{'VALUE'}=$string;
					undef @X_Axis_Values;
					undef @Y_Axis_Values;
				}
			} 
		}
	}
}


sub No_Of_Parameters
{return $#Parameters;}

#Initialization of Tags

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

sub Group_Curve_Tag
{$GROUP_CURVE=shift;}

sub X_Axis_Variable_Tag
{$X_AXIS_VARIABLE=shift;}

sub X_Axis_Tag
{$X_AXIS=shift}

sub X_Axis_Unit_Tag
{$X_AXIS_UNIT=shift;}

sub Distribution_Tag
{$DISTRIBUTION=shift;}

sub Map_Tag
{$MAP=shift;}

sub Y_Axis_Variable_Tag
{$Y_AXIS_VARIABLE=shift;}

sub Y_Axis_Tag
{$Y_AXIS=shift}

sub Y_Axis_Unit_Tag
{$Y_AXIS_UNIT=shift;}

sub Load_DCM
{
	open DCM,$DCM or die "$DCM File Does not Exist.Execution Aborted";
	@DCM_Data=<DCM>;
	close DCM;
}


#Wrappers of All The Functionality

sub Functions
{
	my @Functions_List;
	Function_Finder();
	foreach my $Func (keys(%Descriptions))
	{push(@Functions_List,$Func);}
	return \@Functions_List;	
}
sub Functions_All
{
	my $Functions_All;
	$Functions_All=Functions();
	return (join("|",@$Functions_All));
}

sub Functions_Count
{
	my $Functions_All;
	$Functions_All=Functions();
	return scalar(@$Functions_All);
}

sub Functions_Print
{
	my @Functions_List;
	$Functions_List=Functions();
	foreach my $Function_Name (@$Functions_List){print $Function_Name,"\n";}
}

sub Functions_And_Description
{
	%$Descriptions=Function_Finder();
	return \%Descriptions;
}

sub Functions_And_Description_All
{
	my ($Func_And_Desc_All,@Description_All,%Description_All);
	$Func_And_Desc_All=Function_Finder();
	%Description_All=%$Func_And_Desc_All;
	foreach my $Function (keys(%Description_All))
	{
		push(@Description_All,"$Function => $Description_All{$Function}");
	}
	return join('|',@Description_All);
}

sub Functions_And_Description_Count
{
	return Functions_Count;
}

sub Functions_And_Description_Print
{
	my ($Func_Desc,%Description_All);
	$Func_Desc=Function_Finder();
	%Description_All=%$Func_Desc;
	foreach my $Func (keys(%Description_All))
	{
		print "FUNCTION :",$Func,"  =>  "," DESCRIPTION ",$Description_All{$Func},"\n";
	}
}

sub Parameters
{
	my @Params;
	Parameter_Finder();
	foreach my $Parameter (keys(%Parameter_Details))
	{push(@Params,$Parameter);}
	return \@Params;	
}

sub Parameters_Count
{
	my $Params_Count;
	$Params_Count=Parameters();
	return scalar(@$Params_Count);	
}

sub Parameters_All
{
	my $Params_All;
	$Params_All=Parameters();
	return join('|',(@$Params_All));	
}

sub Parameters_Print
{
	my $Params_All;
	$Params_All=Parameters();
	foreach(@$Params_All){print $_,"\n";}
}

sub Parameters_Details
{
	Parameter_Finder();
	return \%Parameter_Details;
}

sub Parameters_Details_Print
{
	Parameter_Finder();
	foreach my $Parameter (keys(%Parameter_Details))
	{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		PARAMETER		: ",$Parameter,"\n";
		print "		DESCRIPTION		: ",$Parameter_Details{$Parameter}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Parameter_Details{$Parameter}{'FUNCTION'},"\n";
		print "		UNIT			: ",$Parameter_Details{$Parameter}{'UNIT'},"\n";
		print "		VALUE			: ",$Parameter_Details{$Parameter}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
	}
}

sub Arrays
{
	my @Arrays;
	Array_Finder();
	foreach my $Array (keys(%Array_Details))
	{push(@Arrays,$Array);}
	return \@Arrays;	
}

sub Arrays_Count
{
	my $Arrays_Count;
	$Arrays_Count=Arrays();
	return scalar(@$Arrays_Count);	
}

sub Arrays_All
{
	my $Arrays_All;
	$Arrays_All=Arrays();
	return join('|',(@$Arrays_All));	
}

sub Arrays_Print
{
	my $Arrays_All;
	$Arrays_All=Arrays();
	foreach(@$Arrays_All){print $_,"\n";}
}

sub Arrays_Details
{
	Array_Finder();
	return \%Array_Details;
}

sub Arrays_Details_Print
{
	Array_Finder();
	foreach my $Array (keys(%Array_Details))
	{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		ARRAY			: ",$Array,"\n";
		print "		SIZE			: ",$Array_Details{$Array}{'SIZE'},"\n";
		print "		DESCRIPTION		: ",$Array_Details{$Array}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Array_Details{$Array}{'FUNCTION'},"\n";
		print "		UNIT			: ",$Array_Details{$Array}{'UNIT'},"\n";
		print "		VALUE			: ",$Array_Details{$Array}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
	}
}

sub Group_Curves
{
	my @Group_Curves;
	Group_Curve_Finder();
	foreach my $Grp_Curve (keys(%Grp_Curve_Details))
	{push(@Group_Curves,$Grp_Curve);}
	return \@Group_Curves;	
}

sub Group_Curves_Count
{
	my $Group_Curves_Count;
	$Group_Curves_Count=Group_Curves();
	return scalar(@$Group_Curves_Count);	
}

sub Group_Curves_All
{
	my $Group_Curves_All;
	$Group_Curves_All=Group_Curves();
	return join('|',(@$Group_Curves_All));	
}

sub Group_Curves_Print
{
	my $Group_Curves_All;
	$Group_Curves_All=Group_Curves();
	foreach(@$Group_Curves_All){print $_,"\n";}
}

sub Group_Curves_Details
{
	Group_Curve_Finder();
	return \%Grp_Curve_Details;
}

sub Group_Curves_Details_Print
{
	Group_Curve_Finder();
	foreach my $Group_Curve (keys(%Grp_Curve_Details))
	{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		GROUP CURVE		: ",$Group_Curve,"\n";
		print "		SIZE			: ",$Grp_Curve_Details{$Group_Curve}{'SIZE'},"\n";
		print "		DESCRIPTION		: ",$Grp_Curve_Details{$Group_Curve}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Grp_Curve_Details{$Group_Curve}{'FUNCTION'},"\n";
		print "		X AXIS UNIT		: ",$Grp_Curve_Details{$Group_Curve}{'X-AXIS-UNIT'},"\n";
		print "		X AXIS VARIABLE	: ",$Grp_Curve_Details{$Group_Curve}{'X-AXIS-VARIABLE'},"\n";
		print "		X AXIS VALUE	: ",$Grp_Curve_Details{$Group_Curve}{'X-AXIS-VALUE'},"\n";
		print "		UNIT			: ",$Grp_Curve_Details{$Group_Curve}{'UNIT'},"\n";
		print "		VALUE			: ",$Grp_Curve_Details{$Group_Curve}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
	}
}

sub Distributions
{
	my @Distributions;
	Distribution_Finder();
	foreach my $Distribution (keys(%Distribution_Details))
	{push(@Distributions,$Distribution);}
	return \@Distributions;	
}

sub Distributions_Count
{
	my $Distributions_Count;
	$Distributions_Count=Distributions();
	return scalar(@$Distributions_Count);	
}

sub Distributions_All
{
	my $Distributions_All;
	$Distributions_All=Distributions();
	return join('|',(@$Distributions_All));	
}

sub Distributions_Print
{
	my $Distributions_All;
	$Distributions_All=Distributions();
	foreach(@$Distributions_All){print $_,"\n";}
}

sub Distributions_Details
{
	Distribution_Finder();
	return \%Distribution_Details;
}

sub Distributions_Details_Print
{
	Distribution_Finder();
	foreach my $Distribution (keys(%Distribution_Details))
	{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		DISTRIBUTION	: ",$Distribution,"\n";
		print "		SIZE			: ",$Distribution_Details{$Distribution}{'SIZE'},"\n";
		print "		DESCRIPTION		: ",$Distribution_Details{$Distribution}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Distribution_Details{$Distribution}{'FUNCTION'},"\n";
		print "		X AXIS UNIT		: ",$Distribution_Details{$Distribution}{'X-AXIS-UNIT'},"\n";
		print "		X AXIS VALUE	: ",$Distribution_Details{$Distribution}{'X-AXIS-VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
	}
}


sub Maps
{
	my @Maps;
	Map_Finder();
	foreach my $Map (keys(%Map_Details))
	{push(@Maps,$Map);}
	return \@Maps;	
}

sub Maps_Count
{
	my $Maps_Count;
	$Maps_Count=Maps();
	return scalar(@$Maps_Count);	
}

sub Maps_All
{
	my $Maps_All;
	$Maps_All=Maps();
	return join('|',(@$Maps_All));	
}

sub Maps_Print
{
	my $Maps_All;
	$Maps_All=Maps();
	foreach(@$Maps_All){print $_,"\n";}
}

sub Maps_Details
{
	Map_Finder();
	return \%Map_Details;
}

sub Maps_Details_Print
{
	Map_Finder();
	foreach my $Map (keys(%Map_Details))
	{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		Map	: ",$Map,"\n";
		print "		X SIZE			: ",$Map_Details{$Map}{'X-SIZE'},"\n";
		print "		Y SIZE			: ",$Map_Details{$Map}{'Y-SIZE'},"\n";
		print "		DESCRIPTION		: ",$Map_Details{$Map}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Map_Details{$Map}{'FUNCTION'},"\n";
		print "		X AXIS VARIABLE	: ",$Map_Details{$Map}{'X-AXIS-VARIABLE'},"\n";
		print "		X AXIS UNIT		: ",$Map_Details{$Map}{'X-AXIS-UNIT'},"\n";
		print "		X AXIS VALUE	: ",$Map_Details{$Map}{'X-AXIS-VALUE'},"\n";
		print "		Y AXIS VARIABLE	: ",$Map_Details{$Map}{'Y-AXIS-VARIABLE'},"\n";
		print "		Y AXIS VALUE	: ",$Map_Details{$Map}{'Y-AXIS-VALUE'},"\n";
		print "		Y AXIS UNIT		: ",$Map_Details{$Map}{'Y-AXIS-UNIT'},"\n";
		print "		UNIT			: ",$Map_Details{$Map}{'UNIT'},"\n";
		print "		VALUE			: ",$Map_Details{$Map}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
	}
}

sub All_Variable_Details
{
	Parameter_Finder();
	foreach my $Parameter (keys(%Parameter_Details))
	{
		$All_Details{$Parameter}{'DESCRIPTION'}=$Parameter_Details{$Parameter}{'DESCRIPTION'};
		$All_Details{$Parameter}{'FUNCTION'}=$Parameter_Details{$Parameter}{'FUNCTION'};
		$All_Details{$Parameter}{'UNIT'}=$Parameter_Details{$Parameter}{'UNIT'};
		$All_Details{$Parameter}{'VALUE'}=$Parameter_Details{$Parameter}{'VALUE'};
	}

	Array_Finder();
	foreach my $Array (keys(%Array_Details))
	{
 		$All_Details{$Array}{'SIZE'}=$Array_Details{$Array}{'SIZE'};
		$All_Details{$Array}{'DESCRIPTION'}=$Array_Details{$Array}{'DESCRIPTION'};
		$All_Details{$Array}{'FUNCTION'}=$Array_Details{$Array}{'FUNCTION'};
		$All_Details{$Array}{'UNIT'}=$Array_Details{$Array}{'UNIT'};
		$All_Details{$Array}{'VALUE'}=$Array_Details{$Array}{'VALUE'};
	}


	Group_Curve_Finder();
	foreach my $Group_Curve (keys(%Grp_Curve_Details))
	{
		$All_Details{$Group_Curve}{'SIZE'}=$Grp_Curve_Details{$Group_Curve}{'SIZE'};
		$All_Details{$Group_Curve}{'DESCRIPTION'}=$Grp_Curve_Details{$Group_Curve}{'DESCRIPTION'};
		$All_Details{$Group_Curve}{'FUNCTION'}=$Grp_Curve_Details{$Group_Curve}{'FUNCTION'};
		$All_Details{$Group_Curve}{'X-AXIS-UNIT'}=$Grp_Curve_Details{$Group_Curve}{'X-AXIS-UNIT'};
		$All_Details{$Group_Curve}{'X-AXIS-VARIABLE'}=$Grp_Curve_Details{$Group_Curve}{'X-AXIS-VARIABLE'};
		$All_Details{$Group_Curve}{'X-AXIS-VALUE'}=$Grp_Curve_Details{$Group_Curve}{'X-AXIS-VALUE'};
		$All_Details{$Group_Curve}{'UNIT'}=$Grp_Curve_Details{$Group_Curve}{'UNIT'};
		$All_Details{$Group_Curve}{'VALUE'}=$Grp_Curve_Details{$Group_Curve}{'VALUE'};
	}


	Distribution_Finder();
	foreach my $Distribution (keys(%Distribution_Details))
	{
		 $All_Details{$Distribution}{'SIZE'}=$Distribution_Details{$Distribution}{'SIZE'};
		 $All_Details{$Distribution}{'DESCRIPTION'}=$Distribution_Details{$Distribution}{'DESCRIPTION'};
		 $All_Details{$Distribution}{'FUNCTION'}=$Distribution_Details{$Distribution}{'FUNCTION'};
		 $All_Details{$Distribution}{'X-AXIS-UNIT'}=$Distribution_Details{$Distribution}{'X-AXIS-UNIT'};
		 $All_Details{$Distribution}{'X-AXIS-VALUE'}=$Distribution_Details{$Distribution}{'X-AXIS-VALUE'};
	}

	Map_Finder();
	foreach my $Map (keys(%Map_Details))
	{
		 $All_Details{$Map}{'X-SIZE'}=$Map_Details{$Map}{'X-SIZE'};
		 $All_Details{$Map}{'Y-SIZE'}=$Map_Details{$Map}{'Y-SIZE'};
		 $All_Details{$Map}{'DESCRIPTION'}=$Map_Details{$Map}{'DESCRIPTION'};
		 $All_Details{$Map}{'FUNCTION'}=$Map_Details{$Map}{'FUNCTION'};
		 $All_Details{$Map}{'X-AXIS-VARIABLE'}=$Map_Details{$Map}{'X-AXIS-VARIABLE'};
		 $All_Details{$Map}{'X-AXIS-UNIT'}=$Map_Details{$Map}{'X-AXIS-UNIT'};
		 $All_Details{$Map}{'X-AXIS-VALUE'}=$Map_Details{$Map}{'X-AXIS-VALUE'};
		 $All_Details{$Map}{'Y-AXIS-VARIABLE'}=$Map_Details{$Map}{'Y-AXIS-VARIABLE'};
		 $All_Details{$Map}{'Y-AXIS-VALUE'}=$Map_Details{$Map}{'Y-AXIS-VALUE'};
		 $All_Details{$Map}{'Y-AXIS-UNIT'}=$Map_Details{$Map}{'Y-AXIS-UNIT'};
		 $All_Details{$Map}{'UNIT'}=$Map_Details{$Map}{'UNIT'};
		 $All_Details{$Map}{'VALUE'}=$Map_Details{$Map}{'VALUE'};
	}

	return\%All_Details;
}

1;
