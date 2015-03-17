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

#include "CssPrettyWriter.h"
#include "CssWriter.h"
#include "LessParser.h"
#include "LessStylesheet.h"
#include "LessTokenizer.h"
#include "Stylesheet.h"

MODULE = CSS::clessc   PACKAGE = CSS::clessc

PROTOTYPES: DISABLE

void
less_compile(...)
PPCODE:
{
  if (items != 1 || SvROK(ST(0)) || !SvOK(ST(0))) {
    croak("argument of CSS::clessc::less_compile() must be a string");
  }

  SV* input = ST(0);
  std::istringstream in( std::string(SvPV_nolen(input), SvCUR(input)) );

  std::string source("-");
  LessStylesheet stylesheet;
  std::list<std::string> sources;
  LessTokenizer tokenizer(in, source);
  LessParser parser(tokenizer, sources);
  sources.push_back(source);
  try {
    parser.parseStylesheet(stylesheet);
  } catch (ParseException* e) {
    croak("%s at line %d, column %d", e->what(), e->getLineNumber(), e->getColumn());
  } catch (exception* e) {
    croak("%s at line %d, column %d", e->what(), tokenizer.getLineNumber(), tokenizer.getColumn());
  };

  Stylesheet css;
  ProcessingContext context;
  std::ostringstream out;
  // CssPrettyWriter writer(out);
  CssWriter writer(out);
  try {
    stylesheet.process(css, context);
  } catch (ParseException* e) {
    croak("%s at line %d, column %d", e->what(), e->getLineNumber(), e->getColumn());
  } catch (exception* e) {
    croak("%s", e->what());
  }
  css.write(writer);

  XPUSHs(sv_2mortal(newSVpvn(out.str().c_str(), out.str().length())));
  XSRETURN(1);
}
