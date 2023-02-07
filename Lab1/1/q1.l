%{
	#include<stdio.h>
%}

%%
[ ][ ]+     												{ fprintf(yyout, ""); } 
[\n]													 	{ fprintf(yyout, ""); }
[\t]													 	{ fprintf(yyout, ""); }
[/][/]([\t]|[ ]|[a-zA-Z0-9!@#$%^&*()_+=.,/?-])*[\n]		 	{ fprintf(yyout, ""); }	
[/][*]([\n]|[\t]|[ ]|[a-zA-Z0-9!@#$%^&*()_+=.,/?-])*[*][/]  { fprintf(yyout, ""); }
.															{ fprintf(yyout, "%s", yytext); }
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


