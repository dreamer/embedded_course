// vim: noai:ts=4:sw=4

#ifdef TEST

#include "morse.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

int main() {

	char test[] = "0123456789"
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		"abcdefghijklmnopqrstuvwxyz";

	for (unsigned i = 0; i < strlen(test); i++) {
		char c = test[i];
		const char *code = encode(c);
		char c2 = decode(code);
		int ok = c2 == toupper(c);
		//printf("#define CODE_%c \"\"\n", c);
		//printf("\" %c \" CODE_%c\n", c, c);
		//printf(", CODE_%c\n", c);
		printf("%c: %s [%s]\n", c, ok ? "ok" : "fail", code);
	}

	return 0;
}

#endif // TEST
