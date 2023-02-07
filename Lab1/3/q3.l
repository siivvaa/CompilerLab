%{
    #include<stdio.h>
    int lineNumber = 1;
    int positionNumber = 1;
%}

%%
([+]|[-]|[*]|[/]|[%]|[+][+]|[-][-])     {fprintf(yyout, "Line: %d || Position: %d - Arithmetic operator: %c\n", lineNumber, positionNumber, yytext[0]); positionNumber++;}
[=]                                     {fprintf(yyout, "Line: %d || Position: %d - Assignment operator: %c\n", lineNumber, positionNumber, yytext[0]); positionNumber++;}
(([>][=])|([<][=])|([=][=])|([!][=]))   {fprintf(yyout, "Line: %d || Position: %d - Relational operator: %c\n", lineNumber, positionNumber, yytext[0]); positionNumber++;}   
([&][&]|[|][|]|[!])                     {fprintf(yyout, "Line: %d || Position: %d - Logical operator: %c\n", lineNumber, positionNumber, yytext[0]); positionNumber++;}    
([|]|[&]|[~]|[\^]|[>][>]|[<][<])         {fprintf(yyout, "Line: %d || Position: %d - Bitwise operator: %c\n", lineNumber, positionNumber, yytext[0]); positionNumber++;}
[\n]                                    {fprintf(yyout,""); lineNumber++; positionNumber = 1;}
.                                       {fprintf(yyout, ""); positionNumber++;}
%%

int yywrap(void)
{ 
	return 1;
}

int main()
{
	extern FILE *yyin, *yyout;
	yyin = fopen("input.txt", "r");
	yyout= fopen("output.txt", "w");
	yylex();
	return 0;
}