digit [0-9]
letter [A-Za-z]

%{
	int count=0;
%}

%%
({digit})* {printf("%s is an integer", yytext);}
{letter}({letter}|{digit})* {count++; printf("\n%s is an identifier", yytext);}
%%

int yywrap(void)
{ 
	return 1;
}
int main()
{
	system("cls"); 
	yylex();
	printf("Number of identifiers = %d\n", count);
	exit(0);
	return 0;
}
