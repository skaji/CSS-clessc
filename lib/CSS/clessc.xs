#ifdef __cplusplus
extern "C" {
#endif

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#ifdef __cplusplus
} /* extern "C" */
#endif

#include "ppport.h"

#undef do_open
#undef do_close

#include <string>
#include <sstream>

#include "CssWriter.h"
#include "LessParser.h"
#include "LessTokenizer.h"
#include "ParameterRulesetLibrary.h"
#include "Stylesheet.h"
#include "value/ValueProcessor.h"

MODULE = CSS::clessc   PACKAGE = CSS::clessc

PROTOTYPES: DISABLE

void
less_compile(SV* input)
PPCODE:
{
    if (SvROK(input) || !SvOK(input)) {
        croak("argument of CSS::clessc::less_compile() must be a string");
    }
    std::istringstream in( std::string(SvPV_nolen(input), SvCUR(input)) );

    ValueProcessor vp;
    ParameterRulesetLibrary pr(&vp);
    LessTokenizer tokenizer(&in);
    LessParser parser(&tokenizer, &pr, &vp);

    Stylesheet* stylesheet = new Stylesheet();

    try {
        parser.parseStylesheet(stylesheet);
    } catch (exception* e) {
        delete stylesheet;
        stylesheet = NULL;
        croak("Line %d, Column %d Parse Error %s",
            tokenizer.getLineNumber(),
            tokenizer.getColumn(),
            e->what()
        );
    }

    std::ostringstream out;
    CssWriter writer(&out);
    writer.writeStylesheet(stylesheet);
    delete stylesheet;
    stylesheet = NULL;

    XPUSHs(sv_2mortal(newSVpvn(out.str().c_str(), out.str().length())));
    XSRETURN(1);
}
