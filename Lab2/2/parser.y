%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    
    void yyerror(const char *s);
    int yylex();
    int yywrap();
    void add(char);
    void insert_type();
    int search(char *);
    void insert_type();
	void update_offset();

    struct dataType {
        char * id_name;
        char * data_type;
        char * type;
		int address;
		int size;
        int line_no;
    } symbol_table[40];

	int offset=0;
    int count=0;
    int q;
    char type[10];
    extern int countn;
%}

%token VOID CHARACTER PRINTFF SCANFF INT CONST FLOAT CHAR FOR IF ELSE TRUE FALSE NUMBER FLOAT_NUM ID LE GE EQ NE GT LT AND OR STR ADD MULTIPLY DIVIDE SUBTRACT UNARY INCLUDE RETURN 

%%

program: headers main '(' ')' '{' body return '}'
;

headers: headers headers
| INCLUDE { add('H'); }
;

main: datatype ID { add('F'); }
;

datatype: INT { insert_type(); }
| FLOAT { insert_type();  }
| CHAR { insert_type(); }
| VOID { insert_type(); }
;

body: FOR { add('K'); } '(' statement ';' condition ';' statement ')' '{' body '}'
| IF { add('K'); } '(' condition ')' '{' body '}' else
| statement ';'
| body body 
| PRINTFF { add('K'); } '(' STR ')' ';'
| SCANFF { add('K'); } '(' STR ',' '&' ID ')' ';'
;

else: ELSE { add('K'); } '{' body '}'
|
;

condition: value relop value 
| TRUE { add('K'); }
| FALSE { add('K'); }
|
;

statement: datatype ID { add('V'); } init
| ID '=' expression
| ID relop expression
| ID UNARY
| UNARY ID
;

init: '=' value
|
;

expression: expression arithmetic expression
| value
;

arithmetic: ADD 
| SUBTRACT 
| MULTIPLY
| DIVIDE
;

relop: LT
| GT
| LE
| GE
| EQ
| NE
;

value: NUMBER { add('C'); }
| FLOAT_NUM { add('C'); }
| CHARACTER { add('C'); }
| ID
;

return: RETURN { add('K'); } value ';'
|
;

%%

int main() {
 extern FILE *yyin;
	yyin = fopen("input.txt", "r");
  yyparse();
  printf("\n\n");
	printf("\t\t\t\t\t\t\t\t SYMBOL TABLE \n\n");
	printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER	SIZE  OFFSET\n");
	printf("_________________________________________________\n\n");
	int i=0;
	for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t%d\t%d\t%d\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no,symbol_table[i].size, symbol_table[i].address);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
		
			
		}
	printf("\n\n");
}

int search(char *type) {
	int i;
	for(i=count-1; i>=0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void add(char c) {
  q=search(yytext);
  if(!q) {
    if(c == 'H') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Header");
			count++;
		}
		else if(c == 'K') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("N/A");
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Keyword\t");
			count++;
		}
		else if(c == 'V') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Variable");
			if(count == 0){
			symbol_table[count].address = 0;
			offset=offset+symbol_table[count].size;
			}
		else{
			symbol_table[count].address =offset;
			offset=offset+symbol_table[count].size;
			}	

			count++;
		}
		else if(c == 'C') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup("CONST");
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Constant");
			symbol_table[count].size=4;
			symbol_table[count].address =offset;

			offset=offset+4;

			count++;
		}
		else if(c == 'F') {
			symbol_table[count].id_name=strdup(yytext);
			symbol_table[count].data_type=strdup(type);
			symbol_table[count].line_no=countn;
			symbol_table[count].type=strdup("Function");
			count++;
		}
	}
	

}

void insert_type() {
	strcpy(type, yytext);
	if(strcmp(type,"int")==0){
		symbol_table[count].size=4;
	}
	
	if(strcmp(type,"float")==0){
		symbol_table[count].size=8;
	}
	

}


void yyerror(const char* msg) {
  fprintf(stderr, "%s\n", msg);
}