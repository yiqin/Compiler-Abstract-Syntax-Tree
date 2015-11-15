%option noyywrap

%{
#include "heading.h"
#include "tok.h"
int yyerror(char *s);
%}

digit		[0-9]
int_const	{digit}+

%%

{int_const}	{ 
	yylval.int_val = atoi(yytext); return INTEGER_LITERAL; 
}

[A-Za-z_][A-Za-z0-9_]* { 
	yylval.op_val = new std::string(yytext); return VARIABLE; 
}

":="	{ yylval.op_val = new std::string(yytext); return ASSIGN; }

"+"		{ yylval.op_val = new std::string(yytext); return PLUS; }
"-"		{ yylval.op_val = new std::string(yytext); return MINUS; }
"*"		{ yylval.op_val = new std::string(yytext); return MULT; }
"/"		{ yylval.op_val = new std::string(yytext); return DIVIDE; }

";"		{ yylval.op_val = new std::string(yytext); return SEMICOLON; }

"("		{ yylval.op_val = new std::string(yytext); return LEFT_PARENTHESIS; }
")"		{ yylval.op_val = new std::string(yytext); return RIGHT_PARENTHESIS; }

[ \t]*		{}
[\n]		{ yylineno++;	}

.		{ std::cerr << "SCANNER "; yyerror(""); exit(1);	}

