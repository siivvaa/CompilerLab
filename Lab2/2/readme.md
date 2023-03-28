lex lexer.l
yacc -dvy parser.y -ll
gcc y.tab.c
