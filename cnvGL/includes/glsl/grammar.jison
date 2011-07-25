
/* description: Parses end executes mathematical expressions. */
/*note that many of the preprocessor rules below should begin with a '^'. Jison does not seem to support that at this time*/


/* lexical grammar */
%lex

DEC_INT		[1-9][0-9]*
HEX_INT		0[xX][0-9a-fA-F]+
OCT_INT		0[0-7]*
INT		({DEC_INT}|{HEX_INT}|{OCT_INT})
SPC		[ \t]*
SPCP		[ \t]+
HASH		^{SPC}#{SPC}

%s PRAGMA PP

%%

[ \r\t]+
    /* Preprocessor tokens. */ 
[ \t]*\#[ \t]*$	{}		
[ \t]*\#[ \t]*"version"		{ this.begin('PP'); return 'VERSION'; }
[ \t]*\#[ \t]*"extension"		{ this.begin('PP'); return 'EXTENSION'; }

{HASH}"line"{SPCP}{INT}{SPCP}{INT}{SPC}$ {
				   /* Eat characters until the first digit is
				    * encountered
				    */
					var ptr = 0;
					while (yytext.slice(0, 1) < '0' || yytext.slice(0, 1) > '9')
						ptr++;

				   /* Subtract one from the line number because
				    * yylineno is zero-based instead of
				    * one-based.
				    */
				   yylineno = parseInt(yytext.slice(0, 1)) - 1;
				   yylloc.source = parseInt(yytext.slice(0));
				}
{HASH}"line"{SPCP}{INT}{SPC}$	{
				   /* Eat characters until the first digit is
				    * encountered
				    */
					var ptr = 0;
					while (yytext.slice(0, 1) < '0' || yytext.slice(0, 1) > '9')
						ptr++;

				   /* Subtract one from the line number because
				    * yylineno is zero-based instead of
				    * one-based.
				    */
				   yylineno = parseInt(yytext.slice(0, 1)) - 1;
				}
{SPC}\#{SPC}"pragma"{SPCP}"debug"{SPC}\({SPC}"on"{SPC}\) {
				  this.begin('PP');
				  return 'PRAGMA_DEBUG_ON';
				}
{SPC}\#{SPC}"pragma"{SPCP}"debug"{SPC}\({SPC}"off"{SPC}\) {
				  this.begin('PP');
				  return 'PRAGMA_DEBUG_OFF';
				}
{SPC}\#{SPC}"pragma"{SPCP}"optimize"{SPC}\({SPC}"on"{SPC}\) {
				  this.begin('PP');
				  return 'PRAGMA_OPTIMIZE_ON';
				}
{SPC}\#{SPC}"pragma"{SPCP}"optimize"{SPC}\({SPC}"off"{SPC}\) {
				  this.begin('PP');
				  return 'PRAGMA_OPTIMIZE_OFF';
				}
{SPC}\#{SPC}"pragma"{SPCP}"STDGL"{SPCP}"invariant"{SPC}\({SPC}"all"{SPC}\) {
				  this.begin('PP');
				  return 'PRAGMA_INVARIANT_ALL';
				}
{SPC}\#{SPC}"pragma"{SPCP}	{ this.begin('PRAGMA'); }

<PRAGMA>[\n]			{ this.begin('INITIAL'); yylineno++; yycolumn = 0; }
<PRAGMA>.			{ }

<PP>\/\/[^\n]*			{ }
<PP>[ \t\r]*			{ }
<PP>":"				return 'COLON';
<PP>[_a-zA-Z][_a-zA-Z0-9]*	{
				   yylval.identifier = strdup(yytext);
				   return 'IDENTIFIER';
				}
<PP>[1-9][0-9]*			{
				    yylval.n = strtol(yytext, NULL, 10);
				    return 'INTCONSTANT';
				}
<PP>[\n]				{ this.begin('INITIAL'); yylineno++; yycolumn = 0; return 'EOL'; }

[\n]		{ yylineno++; yycolumn = 0; }

"attribute"	return 'ATTRIBUTE';
"const"		return 'CONST_TOK';
"bool"		return 'BOOL_TOK';
"float"		return yy.token.FLOAT_TOK;
"int"		return 'INT_TOK';
"uint"		return yy.KEYWORD(130, 130, UINT_TOK);

"break"		return 'BREAK';
"continue"	return 'CONTINUE';
"do"		return 'DO';
"while"		return 'WHILE';
"else"		return 'ELSE';
"for"		return 'FOR';
"if"		return 'IF';
"discard"		return 'DISCARD';
"return"		return 'RETURN';

"bvec2"		return 'BVEC2';
"bvec3"		return 'BVEC3';
"bvec4"		return 'BVEC4';
"ivec2"		return 'IVEC2';
"ivec3"		return 'IVEC3';
"ivec4"		return 'IVEC4';
"uvec2"		return yy.KEYWORD(130, 130, UVEC2);
"uvec3"		return yy.KEYWORD(130, 130, UVEC3);
"uvec4"		return yy.KEYWORD(130, 130, UVEC4);
"vec2"		return 'VEC2';
"vec3"		return 'VEC3';
"vec4"		return yy.token.VEC4;
"mat2"		return 'MAT2X2';
"mat3"		return 'MAT3X3';
"mat4"		return 'MAT4X4';
"mat2x2"		return yy.KEYWORD(120, 120, MAT2X2);
"mat2x3"		return yy.KEYWORD(120, 120, MAT2X3);
"mat2x4"		return yy.KEYWORD(120, 120, MAT2X4);
"mat3x2"		return yy.KEYWORD(120, 120, MAT3X2);
"mat3x3"		return yy.KEYWORD(120, 120, MAT3X3);
"mat3x4"		return yy.KEYWORD(120, 120, MAT3X4);
"mat4x2"		return yy.KEYWORD(120, 120, MAT4X2);
"mat4x3"		return yy.KEYWORD(120, 120, MAT4X3);
"mat4x4"		return yy.KEYWORD(120, 120, MAT4X4);

"in"		return 'IN_TOK';
"out"		return 'OUT_TOK';
"inout"		return 'INOUT_TOK';
"uniform"		return 'UNIFORM';
"varying"		return yy.token.VARYING;
"centroid"	return yy.KEYWORD(120, 120, CENTROID);
"invariant"	return yy.KEYWORD([120, 1], [120, 1], INVARIANT, true, true);
"flat"		return yy.KEYWORD([130, 1], 130, FLAT);
"smooth"		return yy.KEYWORD(130, 130, SMOOTH);
"noperspective"	return yy.KEYWORD(130, 130, NOPERSPECTIVE);

"sampler1D"	return 'SAMPLER1D';
"sampler2D"	return 'SAMPLER2D';
"sampler3D"	return 'SAMPLER3D';
"samplerCube"	return 'SAMPLERCUBE';
"sampler1DArray"	return yy.KEYWORD(130, 130, SAMPLER1DARRAY);
"sampler2DArray"	return yy.KEYWORD(130, 130, SAMPLER2DARRAY);
"sampler1DShadow"	return 'SAMPLER1DSHADOW';
"sampler2DShadow"	return 'SAMPLER2DSHADOW';
"samplerCubeShadow"	return yy.KEYWORD(130, 130, SAMPLERCUBESHADOW);
"sampler1DArrayShadow"	return yy.KEYWORD(130, 130, SAMPLER1DARRAYSHADOW);
"sampler2DArrayShadow"	return yy.KEYWORD(130, 130, SAMPLER2DARRAYSHADOW);
"isampler1D"		return yy.KEYWORD(130, 130, ISAMPLER1D);
"isampler2D"		return yy.KEYWORD(130, 130, ISAMPLER2D);
"isampler3D"		return yy.KEYWORD(130, 130, ISAMPLER3D);
"isamplerCube"		return yy.KEYWORD(130, 130, ISAMPLERCUBE);
"isampler1DArray"		return yy.KEYWORD(130, 130, ISAMPLER1DARRAY);
"isampler2DArray"		return yy.KEYWORD(130, 130, ISAMPLER2DARRAY);
"usampler1D"		return yy.KEYWORD(130, 130, USAMPLER1D);
"usampler2D"		return yy.KEYWORD(130, 130, USAMPLER2D);
"usampler3D"		return yy.KEYWORD(130, 130, USAMPLER3D);
"usamplerCube"		return yy.KEYWORD(130, 130, USAMPLERCUBE);
"usampler1DArray"		return yy.KEYWORD(130, 130, USAMPLER1DARRAY);
"usampler2DArray"		return yy.KEYWORD(130, 130, USAMPLER2DARRAY);


"struct"		return 'STRUCT';
"void"		return 'VOID_TOK';

"layout"		{/*copy manually*/}

"++"		return 'INC_OP';
"--"		return 'DEC_OP';
"<="		return 'LE_OP';
">="		return 'GE_OP';
"=="		return 'EQ_OP';
"!="		return 'NE_OP';
"&&"		return 'AND_OP';
"||"		return 'OR_OP';
"^^"		return 'XOR_OP';
"<<"		return 'LEFT_OP';
">>"		return 'RIGHT_OP';

"*="		return 'MUL_ASSIGN';
"/="		return 'DIV_ASSIGN';
"+="		return 'ADD_ASSIGN';
"%="		return 'MOD_ASSIGN';
"<<="		return 'LEFT_ASSIGN';
">>="		return 'RIGHT_ASSIGN';
"&="		return 'AND_ASSIGN';
"^="		return 'XOR_ASSIGN';
"|="		return 'OR_ASSIGN';
"-="		return 'SUB_ASSIGN';

[1-9][0-9]*[uU]?	{
			    yylval.n = strtol(yytext, NULL, 10);
			    return IS_UINT ? UINTCONSTANT : INTCONSTANT;
			}
"0"[xX][0-9a-fA-F]+[uU]?	{
			    yylval.n = strtol(yytext + 2, NULL, 16);
			    return IS_UINT ? UINTCONSTANT : INTCONSTANT;
			}
"0"[0-7]*[uU]?		{
			    yylval.n = strtol(yytext, NULL, 8);
			    return IS_UINT ? UINTCONSTANT : INTCONSTANT;
			}

[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?[fF]?	{
			    yylval.real = glsl_strtod(yytext, NULL);
			    return 'FLOATCONSTANT';
			}
\.[0-9]+([eE][+-]?[0-9]+)?[fF]?		{
			    yylval.real = glsl_strtod(yytext, NULL);
			    return 'FLOATCONSTANT';
			}
[0-9]+\.([eE][+-]?[0-9]+)?[fF]?		{
			    yylval.real = glsl_strtod(yytext, NULL);
			    return 'FLOATCONSTANT';
			}
[0-9]+[eE][+-]?[0-9]+[fF]?		{
			    yylval.real = glsl_strtod(yytext, NULL);
			    return 'FLOATCONSTANT';
			}
[0-9]+[fF]		{
			    yylval.real = glsl_strtod(yytext, NULL);
			    return 'FLOATCONSTANT';
			}

"true"			{
			    yylval.n = 1;
			    return 'BOOLCONSTANT';
			}
"false"			{
			    yylval.n = 0;
			    return 'BOOLCONSTANT';
			}


"asm"		return yy.KEYWORD([110, 1], 999, ASM);
"class"		return yy.KEYWORD([110, 1], 999, CLASS);
"union"		return yy.KEYWORD([110, 1], 999, UNION);
"enum"		return yy.KEYWORD([110, 1], 999, ENUM);
"typedef"		return yy.KEYWORD([110, 1], 999, TYPEDEF);
"template"	return yy.KEYWORD([110, 1], 999, TEMPLATE);
"this"		return yy.KEYWORD([110, 1], 999, THIS);
"packed"		return yy.KEYWORD([110, 1], 999, PACKED_TOK);
"goto"		return yy.KEYWORD([110, 1], 999, GOTO);
"switch"		return yy.KEYWORD([110, 1], 130, SWITCH);
"default"		return yy.KEYWORD([110, 1], 130, DEFAULT);
"inline"		return yy.KEYWORD([110, 1], 999, INLINE_TOK);
"noinline"	return yy.KEYWORD([110, 1], 999, NOINLINE);
"volatile"	return yy.KEYWORD([110, 1], 999, VOLATILE);
"public"		return yy.KEYWORD([110, 1], 999, PUBLIC_TOK);
"static"		return yy.KEYWORD([110, 1], 999, STATIC);
"extern"		return yy.KEYWORD([110, 1], 999, EXTERN);
"external"	return yy.KEYWORD([110, 1], 999, EXTERNAL);
"interface"	return yy.KEYWORD([110, 1], 999, INTERFACE);
"long"		return yy.KEYWORD([110, 1], 999, LONG_TOK);
"short"		return yy.KEYWORD([110, 1], 999, SHORT_TOK);
"double"		return yy.KEYWORD([110, 1], 400, DOUBLE_TOK);
"half"		return yy.KEYWORD([110, 1], 999, HALF);
"fixed"		return yy.KEYWORD([110, 1], 999, FIXED_TOK);
"unsigned"	return yy.KEYWORD([110, 1], 999, UNSIGNED);
"input"		return yy.KEYWORD([110, 1], 999, INPUT_TOK);
"output"		return yy.KEYWORD([110, 1], 999, OUTPUT);
"hvec2"		return yy.KEYWORD([110, 1], 999, HVEC2);
"hvec3"		return yy.KEYWORD([110, 1], 999, HVEC3);
"hvec4"		return yy.KEYWORD([110, 1], 999, HVEC4);
"dvec2"		return yy.KEYWORD([110, 1], 400, DVEC2);
"dvec3"		return yy.KEYWORD([110, 1], 400, DVEC3);
"dvec4"		return yy.KEYWORD([110, 1], 400, DVEC4);
"fvec2"		return yy.KEYWORD([110, 1], 999, FVEC2);
"fvec3"		return yy.KEYWORD([110, 1], 999, FVEC3);
"fvec4"		return yy.KEYWORD([110, 1], 999, FVEC4);
"sampler2DRect"		return 'SAMPLER2DRECT';
"sampler3DRect"		return yy.KEYWORD([110, 1], 999, SAMPLER3DRECT);
"sampler2DRectShadow"	return 'SAMPLER2DRECTSHADOW';
"sizeof"		return yy.KEYWORD([110, 1], 999, SIZEOF);
"cast"		return yy.KEYWORD([110, 1], 999, CAST);
"namespace"	return yy.KEYWORD([110, 1], 999, NAMESPACE);
"using"		return yy.KEYWORD([110, 1], 999, USING);

"lowp"		return yy.KEYWORD(120, [130, 1], LOWP);
"mediump"		return yy.KEYWORD(120, [130, 1], MEDIUMP);
"highp"		return yy.KEYWORD(120, [130, 1], yy.token.HIGHP);
"precision"	return yy.KEYWORD(120, [130, 1], yy.token.PRECISION);

"case"		return yy.KEYWORD(130, 130, CASE);
"common"		return yy.KEYWORD(130, 999, COMMON);
"partition"	return yy.KEYWORD(130, 999, PARTITION);
"active"		return yy.KEYWORD(130, 999, ACTIVE);
"superp"		return yy.KEYWORD([130, 1], 999, SUPERP);
"samplerBuffer"	return yy.KEYWORD(130, 140, SAMPLERBUFFER);
"filter"		return yy.KEYWORD(130, 999, FILTER);
"image1D"		return yy.KEYWORD(130, 999, IMAGE1D);
"image2D"		return yy.KEYWORD(130, 999, IMAGE2D);
"image3D"		return yy.KEYWORD(130, 999, IMAGE3D);
"imageCube"	return yy.KEYWORD(130, 999, IMAGECUBE);
"iimage1D"	return yy.KEYWORD(130, 999, IIMAGE1D);
"iimage2D"	return yy.KEYWORD(130, 999, IIMAGE2D);
"iimage3D"	return yy.KEYWORD(130, 999, IIMAGE3D);
"iimageCube"	return yy.KEYWORD(130, 999, IIMAGECUBE);
"uimage1D"	return yy.KEYWORD(130, 999, UIMAGE1D);
"uimage2D"	return yy.KEYWORD(130, 999, UIMAGE2D);
"uimage3D"	return yy.KEYWORD(130, 999, UIMAGE3D);
"uimageCube"	return yy.KEYWORD(130, 999, UIMAGECUBE);
"image1DArray"	return yy.KEYWORD(130, 999, IMAGE1DARRAY);
"image2DArray"	return yy.KEYWORD(130, 999, IMAGE2DARRAY);
"iimage1DArray"	return yy.KEYWORD(130, 999, IIMAGE1DARRAY);
"iimage2DArray"	return yy.KEYWORD(130, 999, IIMAGE2DARRAY);
"uimage1DArray"	return yy.KEYWORD(130, 999, UIMAGE1DARRAY);
"uimage2DArray"	return yy.KEYWORD(130, 999, UIMAGE2DARRAY);
"image1DShadow"	return yy.KEYWORD(130, 999, IMAGE1DSHADOW);
"image2DShadow"	return yy.KEYWORD(130, 999, IMAGE2DSHADOW);
"image1DArrayShadow" return yy.KEYWORD(130, 999, IMAGE1DARRAYSHADOW);
"image2DArrayShadow" return yy.KEYWORD(130, 999, IMAGE2DARRAYSHADOW);
"imageBuffer"	return yy.KEYWORD(130, 999, IMAGEBUFFER);
"iimageBuffer"	return yy.KEYWORD(130, 999, IIMAGEBUFFER);
"uimageBuffer"	return yy.KEYWORD(130, 999, UIMAGEBUFFER);
"row_major"	return yy.KEYWORD(130, 999, ROW_MAJOR);

[_a-zA-Z][_a-zA-Z0-9]*	{
				var state = yy.yyextra;
				var ctx = state;
				yy.yylval.identifier = ralloc_strdup(ctx, yytext);
			    return yy.classify_identifier(state, yytext);
			}

.			{ return yytext[0].charCodeAt(0); }



/lex

/* operator associations and precedence */

%left '+'
%left '*'

%start glsl-start

%% /* language grammar */

glsl-start :
			translation_unit EOF		{ return $1; }
		;

variable_identifier:
			'IDENTIFIER'
		;

primary_expression:
			variable_identifier
		|	'INTCONSTANT'
		|	'UINTCONSTANT'
		|	'FLOATCONSTANT'
		|	'BOOLCONSTANT'
		|	'LEFT_PAREN' expression 'RIGHT_PAREN'
		;

postfix_expression:
			primary_expression
		|	postfix_expression 'LEFT_BRACKET' integer_expression 'RIGHT_BRACKET'
		|	function_call
		|	postfix_expression 'DOT' 'FIELD_SELECTION'
		|	postfix_expression 'INC_OP'
		|	postfix_expression 'DEC_OP'
		;

integer_expression:
			expression
		;

function_call:
			function_call_or_method
		;

function_call_or_method:
			function_call_generic
		|	postfix_expression 'DOT' function_call_generic
		;

function_call_generic:
			function_call_header_with_parameters 'RIGHT_PAREN'
		|	function_call_header_no_parameters 'RIGHT_PAREN'
		;

function_call_header_no_parameters:
			function_call_header 'VOID'
		|	function_call_header
		;

function_call_header_with_parameters:
			function_call_header assignment_expression
		|	function_call_header_with_parameters 'COMMA' assignment_expression
		;

function_call_header:
			function_identifier 'LEFT_PAREN'
		;

/* Grammar Note: Constructors look like functions, but lexical analysis recognized most of them as
   keywords. They are now recognized through “type_specifier”.
*/

function_identifier:
			type_specifier
		|	'IDENTIFIER'
		|	'FIELD_SELECTION'
		;

unary_expression:
			postfix_expression
		|	'INC_OP' unary_expression
		|	'DEC_OP' unary_expression
		|	unary_operator unary_expression
		;

/* Grammar Note: No traditional style type casts. */

unary_operator:
			'PLUS'
		|	'DASH'
		|	'BANG'
		|	'TILDE'
		;

/* Grammar Note: No '*' or '&' unary ops. Pointers are not supported. */

multiplicative_expression:
			unary_expression
		|	multiplicative_expression 'STAR' unary_expression
		|	multiplicative_expression 'SLASH' unary_expression
		|	multiplicative_expression 'PERCENT' unary_expression
		;

additive_expression:
			multiplicative_expression
		|	additive_expression 'PLUS' multiplicative_expression
		|	additive_expression 'DASH' multiplicative_expression
		;

shift_expression:
			additive_expression
		|	shift_expression 'LEFT_OP' additive_expression
		|	shift_expression 'RIGHT_OP' additive_expression
		;

relational_expression:
			shift_expression
		|	relational_expression 'LEFT_ANGLE' shift_expression
		|	relational_expression 'RIGHT_ANGLE' shift_expression
		|	relational_expression 'LE_OP' shift_expression
		|	relational_expression 'GE_OP' shift_expression
		;

equality_expression:
			relational_expression
		|	equality_expression 'EQ_OP' relational_expression
		|	equality_expression 'NE_OP' relational_expression
		;

and_expression:
			equality_expression
		|	and_expression 'AMPERSAND' equality_expression
		;

exclusive_or_expression:
			and_expression
		|	exclusive_or_expression 'CARET' and_expression
		;

inclusive_or_expression:
			exclusive_or_expression
		|	inclusive_or_expression 'VERTICAL_BAR' exclusive_or_expression
		;

logical_and_expression:
			inclusive_or_expression
		|	logical_and_expression 'AND_OP' inclusive_or_expression
		;

logical_xor_expression:
			logical_and_expression
		|	logical_xor_expression 'XOR_OP' logical_and_expression
		;

logical_or_expression:
			logical_xor_expression
		|	logical_or_expression 'OR_OP' logical_xor_expression
		;

conditional_expression:
			logical_or_expression
		|	logical_or_expression 'QUESTION' expression 'COLON' assignment_expression
		;

assignment_expression:
			conditional_expression
		|	unary_expression assignment_operator assignment_expression
		;

assignment_operator:
			'EQUAL'
		|	'MUL_ASSIGN'
		|	'DIV_ASSIGN'
		|	'MOD_ASSIGN'
		|	'ADD_ASSIGN'
		|	'SUB_ASSIGN'
		|	'LEFT_ASSIGN'
		|	'RIGHT_ASSIGN'
		|	'AND_ASSIGN'
		|	'XOR_ASSIGN'
		|	'OR_ASSIGN'
		;

expression:
			assignment_expression
		|	expression 'COMMA' assignment_expression
		;

constant_expression:
			conditional_expression
		;

declaration:
			function_prototype 'SEMICOLON'	{ console.log('declaration 1', $1); }
		|	init_declarator_list 'SEMICOLON'	{ console.log('declaration 2', $1); }
		|	'PRECISION' precision_qualifier type_specifier_no_prec 'SEMICOLON'			{ yy.ast.adoptMulti($1, $2, $3); }
		|	type_qualifier 'IDENTIFIER' 'LEFT_BRACE' struct_declaration_list 'RIGHT_BRACE' 'SEMICOLON' 	{ console.log('declaration 4', $1, $2, $3, $4, $5); }
		|	type_qualifier 'IDENTIFIER' 'LEFT_BRACE' struct_declaration_list 'RIGHT_BRACE' 'IDENTIFIER' 'SEMICOLON' 	{ console.log('declaration 5', $1, $2, $3, $4, $5, $6); }
		|	type_qualifier 'IDENTIFIER' 'LEFT_BRACE' struct_declaration_list 'RIGHT_BRACE' 'IDENTIFIER' 'LEFT_BRACKET' 'RIGHT_BRACKET' 'SEMICOLON'	{ console.log('declaration 6', $1, $2, $3, $4, $5, $6, $7, $8); }
		|	type_qualifier 'IDENTIFIER' 'LEFT_BRACE' struct_declaration_list 'RIGHT_BRACE' 'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET' 'SEMICOLON'	{ console.log('declaration 7', $1, $2, $3, $4, $5, $6, $7, $8, $9); }
		|	type_qualifier 'SEMICOLON'	{ console.log('declaration 8', $1); }
		;

function_prototype:
			function_declarator 'RIGHT_PAREN'	{ $$ = $1; }
		;

function_declarator:
			function_header
		|	function_header_with_parameters
		;

function_header_with_parameters:
			function_header parameter_declaration	{ $$ = yy.ast.adoptLeft($1, $2); }
		|	function_header_with_parameters 'COMMA' parameter_declaration { $$ = yy.ast.adoptSibling($1, $3); }
		;

function_header:
			fully_specified_type 'IDENTIFIER' 'LEFT_PAREN'	{	
																$1 = yy.ast.attribute($2, 'function');
																$$ = yy.ast.adoptLeft($2, $1);
															}
		;

parameter_declarator:
			type_specifier 'IDENTIFIER'		{ $$ = yy.ast.adoptLeft($1, $2); }
		|	type_specifier 'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET'	{
																								$$ = yy.ast.adoptLeft($1, $2);
																								$2 = yy.ast.adoptMulti($2, $3, $4);
																							}
		;

parameter_declaration:
			parameter_type_qualifier parameter_qualifier parameter_declarator
		|	parameter_qualifier parameter_declarator
		|	parameter_type_qualifier parameter_qualifier parameter_type_specifier
		|	parameter_qualifier parameter_type_specifier
		;

parameter_qualifier:
			/* empty */
		|	'IN'
		|	'OUT'
		|	'INOUT'
		;

parameter_type_specifier:
			type_specifier
		;

init_declarator_list:
			single_declaration	{ console.log('init_declarator_list 1', $1); }
		|	init_declarator_list 'COMMA' 'IDENTIFIER'	{ console.log('init_declarator_list 2', $1, $2, $3); }
		|	init_declarator_list 'COMMA' 'IDENTIFIER' 'LEFT_BRACKET' 'RIGHT_BRACKET'	{ console.log('init_declarator_list 3', $1, $2, $3, $4, $5); }
		|	init_declarator_list 'COMMA' 'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET'	{ console.log('init_declarator_list 4', $1, $2, $3, $4, $5, $6); }
		|	init_declarator_list 'COMMA' 'IDENTIFIER' 'LEFT_BRACKET' 'RIGHT_BRACKET' 'EQUAL' initializer	{ console.log('init_declarator_list 5', $1, $2, $3, $4, $5, $6, $7); }
		|	init_declarator_list 'COMMA' 'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET' 'EQUAL' initializer	{ console.log('init_declarator_list 6', $1, $2, $3, $4, $5, $6, $7, $8); }
		|	init_declarator_list 'COMMA' 'IDENTIFIER' 'EQUAL' initializer	{ console.log('init_declarator_list 7', $1, $2, $3, $4, $5); }
		;

single_declaration:
			fully_specified_type
		|	fully_specified_type 'IDENTIFIER'	{ $$ = yy.ast.adoptLeft($1, $2); }
		|	fully_specified_type 'IDENTIFIER' 'LEFT_BRACKET' 'RIGHT_BRACKET'
		|	fully_specified_type 'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET'
		|	fully_specified_type 'IDENTIFIER' 'LEFT_BRACKET' 'RIGHT_BRACKET' 'EQUAL' initializer
		|	fully_specified_type 'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET' 'EQUAL' initializer
		|	fully_specified_type 'IDENTIFIER' 'EQUAL' initializer 'INVARIANT' 'IDENTIFIER'
		;

/* Grammar Note: No 'enum', or 'typedef'. */

fully_specified_type:
			type_specifier
		|	type_qualifier type_specifier	{ $$ = yy.ast.adoptLeft($1, $2); }
		;

invariant_qualifier:
			'INVARIANT'
		;

interpolation_qualifier:
			'SMOOTH'
		|	'FLAT'
		|	'NOPERSPECTIVE'
		;

layout_qualifier:
			'LAYOUT' 'LEFT_PAREN' layout_qualifier_id_list 'RIGHT_PAREN'
		;

layout_qualifier_id_list:
			layout_qualifier_id
		|	layout_qualifier_id_list 'COMMA' layout_qualifier_id
		;

layout_qualifier_id:
			'IDENTIFIER'
		|	'IDENTIFIER' 'EQUAL' 'INTCONSTANT'
		;

parameter_type_qualifier:
			'CONST'
		;

type_qualifier:
			storage_qualifier
		|	layout_qualifier
		|	layout_qualifier storage_qualifier
		|	interpolation_qualifier storage_qualifier
		|	interpolation_qualifier
		|	invariant_qualifier storage_qualifier
		|	invariant_qualifier interpolation_qualifier storage_qualifier
		|	invariant_qualifier
		;

storage_qualifier:
			'CONST'
		|	'ATTRIBUTE' /* Vertex only. */
		|	'VARYING'
		|	'CENTROID' 'VARYING'
		|	'IN'
		|	'OUT'
		|	'CENTROID' 'IN'
		|	'CENTROID' 'OUT'
		|	'PATCH' 'IN'
		|	'PATCH' 'OUT'
		|	'SAMPLE' 'IN'
		|	'SAMPLE' 'OUT'
		|	'UNIFORM'
		;

type_specifier:
			type_specifier_no_prec
		|	precision_qualifier type_specifier_no_prec	{ $$ = yy.ast.adoptLeft($1, $2); }
		;

type_specifier_no_prec:
			type_specifier_nonarray
		|	type_specifier_nonarray 'LEFT_BRACKET' 'RIGHT_BRACKET'			{ $$ = yy.ast.adoptLeft($1, $2); }
		|	type_specifier_nonarray 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET'	{ $$ = yy.ast.adoptMulti($1, $2, $3); }
		;

type_specifier_nonarray:
			'VOID'
		|	'FLOAT'
		|	'DOUBLE'
		|	'INT'
		|	'UINT'
		|	'BOOL'
		|	'VEC2'
		|	'VEC3'
		|	'VEC4'
		|	'DVEC2'
		|	'DVEC3'
		|	'DVEC4'
		|	'BVEC2'
		|	'BVEC3'
		|	'BVEC4'
		|	'IVEC2'
		|	'IVEC3'
		|	'IVEC4'
		|	'UVEC2'
		|	'UVEC3'
		|	'UVEC4'
		|	'MAT2'
		|	'MAT3'
		|	'MAT4'
		|	'MAT2X2'
		|	'MAT2X3'
		|	'MAT2X4'
		|	'MAT3X2'
		|	'MAT3X3'
		|	'MAT3X4'
		|	'MAT4X2'
		|	'MAT4X3'
		|	'MAT4X4'
		|	'DMAT2'
		|	'DMAT3'
		|	'DMAT4'
		|	'DMAT2X2'
		|	'DMAT2X3'
		|	'DMAT2X4'
		|	'DMAT3X2'
		|	'DMAT3X3'
		|	'DMAT3X4'
		|	'DMAT4X2'
		|	'DMAT4X3'
		|	'DMAT4X4'
		|	'SAMPLER1D'
		|	'SAMPLER2D'
		|	'SAMPLER3D'
		|	'SAMPLERCUBE'
		|	'SAMPLER1DSHADOW'
		|	'SAMPLER2DSHADOW'
		|	'SAMPLERCUBESHADOW'
		|	'SAMPLER1DARRAY'
		|	'SAMPLER2DARRAY'
		|	'SAMPLER1DARRAYSHADOW'
		|	'SAMPLER2DARRAYSHADOW'
		|	'SAMPLERCUBEARRAY'
		|	'SAMPLERCUBEARRAYSHADOW'
		|	'ISAMPLER1D'
		|	'ISAMPLER2D'
		|	'ISAMPLER3D'
		|	'ISAMPLERCUBE'
		|	'ISAMPLER1DARRAY'
		|	'ISAMPLER2DARRAY'
		|	'ISAMPLERCUBEARRAY'
		|	'USAMPLER1D'
		|	'USAMPLER2D'
		|	'USAMPLER3D'
		|	'USAMPLERCUBE'
		|	'USAMPLER1DARRAY'
		|	'USAMPLER2DARRAY'
		|	'USAMPLERCUBEARRAY'
		|	'SAMPLER2DRECT'
		|	'SAMPLER2DRECTSHADOW'
		|	'ISAMPLER2DRECT'
		|	'USAMPLER2DRECT'
		|	'SAMPLERBUFFER'
		|	'ISAMPLERBUFFER'
		|	'USAMPLERBUFFER'
		|	'SAMPLER2DMS'
		|	'ISAMPLER2DMS'
		|	'USAMPLER2DMS'
		|	'SAMPLER2DMSARRAY'
		|	'ISAMPLER2DMSARRAY'
		|	'USAMPLER2DMSARRAY'
		|	struct_specifier
		|	'TYPE_NAME'
		;

precision_qualifier:
			'HIGH_PRECISION'
		|	'MEDIUM_PRECISION'
		|	'LOW_PRECISION'
		;

struct_specifier:
			'STRUCT' 'IDENTIFIER' 'LEFT_BRACE' struct_declaration_list 'RIGHT_BRACE'
		|	'STRUCT' 'LEFT_BRACE' struct_declaration_list 'RIGHT_BRACE'
		;

struct_declaration_list:
			struct_declaration
		|	struct_declaration_list struct_declaration
		;

struct_declaration:
			type_specifier struct_declarator_list 'SEMICOLON'
		|	type_qualifier type_specifier struct_declarator_list 'SEMICOLON'
		;

struct_declarator_list:
			struct_declarator
		|	struct_declarator_list 'COMMA' struct_declarator
		;

struct_declarator:
			'IDENTIFIER'
		|	'IDENTIFIER' 'LEFT_BRACKET' 'RIGHT_BRACKET'
		|	'IDENTIFIER' 'LEFT_BRACKET' constant_expression 'RIGHT_BRACKET'
		;

initializer:
			assignment_expression
		;

declaration_statement:
			declaration
		;

statement:
			compound_statement
		|	simple_statement
		;

/* Grammar Note: labeled statements for SWITCH only; 'goto' is not supported. */

simple_statement:
			declaration_statement
		|	expression_statement
		|	selection_statement
		|	switch_statement
		|	case_label
		|	iteration_statement
		|	jump_statement
		;

compound_statement:
			'LEFT_BRACE' 'RIGHT_BRACE'
		|	'LEFT_BRACE' statement_list 'RIGHT_BRACE'
		;

statement_no_new_scope:
			compound_statement_no_new_scope
		|	simple_statement
		;

compound_statement_no_new_scope:
			'LEFT_BRACE' 'RIGHT_BRACE'
		|	'LEFT_BRACE' statement_list 'RIGHT_BRACE'
		;

statement_list:
			statement
		|	statement_list statement
		;

expression_statement:
			'SEMICOLON'
		|	expression 'SEMICOLON'
		;

selection_statement:
			'IF' 'LEFT_PAREN' expression 'RIGHT_PAREN' selection_rest_statement
		;

selection_rest_statement:
			statement 'ELSE' statement
		|	statement
		;

condition:
			expression
		|	fully_specified_type 'IDENTIFIER' 'EQUAL' initializer
		;

switch_statement:
			'SWITCH' 'LEFT_PAREN' expression 'RIGHT_PAREN' 'LEFT_BRACE' switch_statement_list 'RIGHT_BRACE'
		;

switch_statement_list:
			/* nothing */
		|	statement_list
		;

case_label:
			'CASE' expression 'COLON'
		|	'DEFAULT' 'COLON'
		;

iteration_statement:
			'WHILE' 'LEFT_PAREN' condition 'RIGHT_PAREN' statement_no_new_scope
		|	'DO' statement 'WHILE' 'LEFT_PAREN' expression 'RIGHT_PAREN' 'SEMICOLON'
		|	'FOR' 'LEFT_PAREN' for_init_statement for_rest_statement 'RIGHT_PAREN'
		|	statement_no_new_scope
		;

for_init_statement:
			expression_statement
		|	declaration_statement
		;

conditionopt:
			condition
		|	/* empty */
		;

for_rest_statement:
			conditionopt 'SEMICOLON'
		|	conditionopt 'SEMICOLON' expression
		;

jump_statement:
			'CONTINUE' 'SEMICOLON'
		|	'BREAK' 'SEMICOLON'
		|	'RETURN' 'SEMICOLON'
		|	'RETURN' expression
		|	'DISCARD' 'SEMICOLON' /* Fragment shader only.*/
		;

/* Grammar Note: No 'goto'. Gotos are not supported.*/

translation_unit:
			external_declaration
		|	translation_unit external_declaration		{ $$ = yy.ast.adoptSibl($1, $2); }
		;

external_declaration:
			function_definition
		|	declaration
		;

function_definition:
		function_prototype compound_statement_no_new_scope	{ $$ = yy.ast.adoptLeft($1, $2); }
		;