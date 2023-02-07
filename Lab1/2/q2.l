%{
    #include<stdio.h>
%}

%%
main|auto|break|case|char|const|continue|default|double|else|enum|extern|float|for|goto|do|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while		   	  		 	 {fprintf(yyout, "Lexeme:%s||Token:Keyword\n",yytext);}
[a-zA-Z_][a-zA-Z0-9_]{0,31}			 {fprintf(yyout, "Lexeme:%s||Token:Identifier\n", yytext);}
[0-9]+					   				 {fprintf(yyout, "Lexeme:%s||Token:Constant\n", yytext);}
([0-9]([a-zA-Z]+[0-9]+)+)				 {fprintf(yyout, "Lexeme:%s||Token:Invalid Identifier!\n", yytext);}
[a-zA-Z_][a-zA-Z0-9_]{32,}   			 {fprintf(yyout, "Lexeme:%s||Token:Invalid Identifier\n", yytext);}     
[+]|[-]|[*]|[/]|[%]|[+][+]|[-][-]|[=]|([>][=])|([<][=])|([=][=])|([!][=])|[&][&]|[|][|]|[!]|[|]|[&]|[~]|[\^]|[>][>]|[<][<]			   						 {fprintf(yyout, "Lexeme:%s||Token:Operator\n", yytext);}	
\[|\]|\(|\)|\{|\}|\,|;|\*|\=|\#										 {fprintf(yyout, "Lexeme:%s||Token:Special Chararacters.\n", yytext);}
.            			   				 {}                                                                           
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