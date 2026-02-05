// My custom snippets for Obsidian

// Use backslashes to escape special characters (used often for latex commands (Ex: \frac -> \\frac))
// Options: t (text mode only), m (math mode only), A (auto complete), r (regex)
// 	 When using the regex mode, use [[0]], [[1]], etc. for capture groups
//	 Also use $0, $1, for cursor jump positions
[
  // Math mode (active outside of math mode)
  {trigger: "mk", replacement: "$$0$", options: "tA", description: "Enter inline math mode"},
  {trigger: "dm", replacement: "$$\n$0\n$$", options: "tAw", description: "Enter multiline math mode"},
  
  
  // Inline codeblock shortcuts (active outside of math mode)
  {trigger: "cbp", replacement: "`{cpp} $0`", options: "tA", description: "Insert inline C++ codeblock"},
  {trigger: "cby", replacement: "`{py} $0`", options: "tA", description: "Insert inline Python codeblock"},
  {trigger: "cbs", replacement: "`{sql} $0`", options: "tA", description: "Insert inline SQL codeblock"},
  
  
  // Auto convert numbers and single letters to inline math mode (active outside of math mode)
  {trigger: "\\b(-?\\d*\\.?\\d+)\\b(\\s|,|\\.\\s)", replacement: "$\\hspace{0pt}[[0]]$[[1]]", options: "rtA", description: "Automatically convert numbers to math"},
  {trigger: "([^'áéíóúÁÉÍÓÚ])\\b((?![aAI])[a-zA-Z])\\b([\\n\\s\\.,])", replacement: "[[0]]$[[1]]$[[2]]", options: "rtA", description: "Automatically treat lone characters as math (except a, A, I)"},
  // Create a math mode A in text mode (active outside of math mode)
  {trigger: "vA ", replacement: "$A$ ", options: "tA", description: "Insert a math mode A"},
  {trigger: "vA,", replacement: "$A$,", options: "tA", description: "Insert a math mode A"},
  {trigger: "vA.", replacement: "$A$,", options: "tA", description: "Insert a math mode A"},
  {trigger: "vaa ", replacement: "$a$ ", options: "tA", description: "Insert a math mode A"},
  {trigger: "vaa,", replacement: "$a$,", options: "tA", description: "Insert a math mode A"},
  {trigger: "vaa.", replacement: "$a$,", options: "tA", description: "Insert a math mode A"},
  
  
  // Dashes (active outside of math mode)
  {trigger: "--", replacement: "–", options: "tA"},
  {trigger: "–-", replacement: "—", options: "tA"},
  {trigger: "—-", replacement: "---", options: "tA"},
  
  
  // Visual operations (highlight text and type trigger)
  {trigger: "U", replacement: "\\underbrace{ ${VISUAL} }_{ $0 }", options: "mA"},
  {trigger: "B", replacement: "\\underset{ $0 }{ ${VISUAL} }", options: "mA"},
  {trigger: "C", replacement: "\\cancel{ ${VISUAL} }", options: "mA"},
  {trigger: "K", replacement: "\\cancelto{ $0 }{ ${VISUAL} }", options: "mA"},
  {trigger: "S", replacement: "\\sqrt{ ${VISUAL} }", options: "mA"},
  
  
  // Logical spacing
  {trigger: "there", replacement: "\\therefore ", options: "mA", description: "Therefore symbol (three dots in a triangle)"},
  {trigger: "quad", replacement: " \\quad ", options: "mA", description: "Quad (tab like space)"},
  {trigger: "qquad", replacement: " \\qquad ", options: "mA", description: "Double quad (quad times two)"},
  {trigger: "qtq", replacement: " \\quad\\therefore\\quad ", options: "mA", description: "Quad therefore quad"},
  
  
  // Text in math mode
  {trigger: "te", replacement: "\\text{$0}", options: "mA", description: "Text in math mode"},
  {trigger: "bf", replacement: "\\mathbf{$0}", options: "mA", description: "Bold text in math mode"},
  {trigger: "rm", replacement: "\\mathrm{$0}$1", options: "mA", description: "Roman font"},
  {trigger: "op", replacement: "\\operatorname{$0}$1", options: "mA", description: "Math operator (for custom functions)"},
  {trigger: "cal", replacement: "\\mathcal{$0}$1", options: "mA", description: "Calligraphic font (for capital letters)"},
  {trigger: "mcal", replacement: "\\mathcal{$0}$1", options: "mA"},
  {trigger: "mbb", replacement: "\\mathbb{$0}$1", options: "mA"},
  
  
  // Common math fonts and letters
  {trigger: "ell", replacement: "\\ell", options: "mA"},
  {trigger: "lll", replacement: "\\ell", options: "mA"},
  {trigger: "LL", replacement: "\\mathcal{L}", options: "mA"},
  {trigger: "HH", replacement: "\\mathcal{H}", options: "mA"},
  {trigger: "CC", replacement: "\\mathbb{C}", options: "mA"},
  {trigger: "RR", replacement: "\\mathbb{R}", options: "mA"},
  {trigger: "\\mathbb{R}([0-9m-n])", replacement: "\mathbb{R}^{[[0]]}", options: "rmA", description: "All real numbers to the power of a number or n or m"},
  {trigger: "ZZ", replacement: "\\mathbb{Z}", options: "mA"},
  {trigger: "QQ", replacement: "\\mathbb{Q}", options: "mA"},
  {trigger: "NN", replacement: "\\mathbb{N}", options: "mA"},
  {trigger: "II", replacement: "\\mathbb{1}", options: "mA"},
  {trigger: "\\mathbb{1}I", replacement: "\\hat{\\mathbb{1}}", options: "mA"},
  {trigger: "AA", replacement: "\\mathcal{A}", options: "mA"},
  {trigger: "BB", replacement: "\\mathbf{B}", options: "mA"},
  {trigger: "EE", replacement: "\\mathbf{E}", options: "mA"},
  {trigger: "\\mathbf{E}E", replacement: "\\mathcal{E}", options: "mA"},
  
  
  // Math symbol decorators
  {trigger: "bar", replacement: "\\bar{$0}$1", options: "mA", description: "Bar over (complement)"},
  {trigger: "hat", replacement: "\\hat{$0}$1", options: "mA", description: "Hat over (unit vectors)"},
  {trigger: "dot", replacement: "\\dot{$0}$1", options: "mA", description: "Dot over"},
  {trigger: "ddot", replacement: "\\ddot{$0}$1", options: "mA", priority: 2, description: "Double dot over"},
  {trigger: "cdot", replacement: "\\cdot ", options: "mA", priority: 2, description: "Center dot (multiplication)"},
  {trigger: ",,", replacement: "\\, ", options: "mA", description: "Spacer"},
  {trigger: "...", replacement: "\\dots", options: "mA", description: "Three bottom dots"},
  {trigger: "cdos", replacement: "\\cdots", options: "mA", description: "Three center dots"},
  {trigger: "vdos", replacement: "\\vdots", options: "mA", description: "Three vertical dots"},
  {trigger: "ddos", replacement: "\\ddots", options: "mA", description: "Three diagonal dots"},
  {trigger: "vec", replacement: "\\vec{$0}$1", options: "mA", description: "Vector arrow over"},
  {trigger: "tilde", replacement: "\\tilde{$0}$1", options: "mA", description: "Tilde over"},
  {trigger: "und", replacement: "\\underline{$0}$1", options: "mA", description: "Underline"},
  {trigger: "over", replacement: "\\overline{$0}$1", options: "mA", description: "Overline"},
  // Lots of auto-formatting by typing a letter/s and then a number/trigger
  {trigger: "([a-zA-Z]),\\.", replacement: "\\mathbf{[[0]]}", options: "rmA"},
  {trigger: "([a-zA-Z])\\.,", replacement: "\\mathbf{[[0]]}", options: "rmA"},
  {trigger: "([A-Za-z])(\\d)", replacement: "[[0]]_{[[1]]}", options: "rmA", description: "Auto letter subscript", priority: -1},
  {trigger: "([A-Za-z])_{(\\d+)}(\\d)", "replacement": "[[0]]_{[[1]][[2]]}", options: "rmA", description: "Auto letter subscript for more digits"},
  // {trigger: "([A-Za-z])_(\\d\\d)", replacement: "[[0]]_{[[1]]}", options: "rmA"},
  {trigger: "\\hat{([A-Za-z])}(\\d)", replacement: "hat{[[0]]}_{[[1]]}", options: "rmA"},
  {trigger: "\\\\mathbf{([A-Za-z])}(\\d)", replacement: "\\mathbf{[[0]]}_{[[1]]}", options: "rmA"},
  {trigger: "\\\\vec{([A-Za-z])}(\\d)", replacement: "\\vec{[[0]]}_{[[1]]}", options: "rmA"},
  {trigger: "([a-zA-Z])bar", replacement: "\\bar{[[0]]}", options: "rmA"},
  {trigger: "([a-zA-Z])hat", replacement: "\\hat{[[0]]}", options: "rmA"},
  {trigger: "([a-zA-Z])ddot", replacement: "\\ddot{[[0]]}", options: "rmA", priority: 3},
  {trigger: "([a-zA-Z])dot", replacement: "\\dot{[[0]]}", options: "rmA", priority: 1},
  {trigger: "([a-zA-Z])vec", replacement: "\\vec{[[0]]}", options: "rmA"},
  {trigger: "([a-zA-Z])tilde", replacement: "\\tilde{[[0]]}", options: "rmA"},
  {trigger: "([a-zA-Z])und", replacement: "\\underline{[[0]]}", options: "rmA"},
  {trigger: "([a-zA-Z])over", replacement: "\\overline{[[0]]}", options: "rmA"},
  
  
  // Arrows
  {trigger: "->", replacement: "\\to ", options: "mA", description: "Right arrow"},
  {trigger: "to", replacement: "\\to ", options: "mA", description: "Right arrow"},
  {trigger: "\\to o", replacement: "\\longrightarrow ", options: "mA", description: "Long right arrow"}, // FIXME
  {trigger: "xto", replacement: "\\xrightarrow{$0}$1", options: "mA", description: "Right arrow with text above (useful for transformations with a description)"},
  {trigger: "-<", replacement: "\\gets ", options: "mA", description: "Left arrow"},
  {trigger: "gets", replacement: "\\gets ", options: "mA", description: "Left arrow"},
  {trigger: "from", replacement: "\\gets ", options: "mA", description: "Left arrow"},
  {trigger: "<->", replacement: "\\leftrightarrow ", options: "mA", description: "Left-right arrow"},
  {trigger: "!>", replacement: "\\mapsto", options: "mA", description: "Maps to"},
  {trigger: "maps", replacement: "\\mapsto", options: "mA", description: "Maps to"},
  {trigger: "xmaps", replacement: "\\xmapsto{$0}", options: "mA", description: "Maps to with text above"},
  
  
  // Common variables
  {trigger: "xnn", replacement: "x_{n}", options: "mA"},
  {trigger: "\\xi i", replacement: "x_{i}", options: "mA"},
  {trigger: "xjj", replacement: "x_{j}", options: "mA"},
  {trigger: "xnp1", replacement: "x_{n+1}", options: "mA"},
  {trigger: "ynn", replacement: "y_{n}", options: "mA"},
  {trigger: "yii", replacement: "y_{i}", options: "mA"},
  {trigger: "yjj", replacement: "y_{j}", options: "mA"},
  
  
  // Common functions
  {trigger: "fn", replacement: "f(n)", options: "mA"},
  {trigger: "fx", replacement: "f(x)", options: "mA"},
  {trigger: "gx", replacement: "g(x)", options: "mA"},
  {trigger: "hx", replacement: "h(x)", options: "mA"},
  
  
  // Operations
  {trigger: "sr", replacement: "^{2}", options: "mA", description: "Squared"},
  {trigger: "cb", replacement: "^{3}", options: "mA", description: "Cubed"},
  {trigger: "rd", replacement: "^{$0}$1", options: "mA", description: "Raised (to the power of)"},
  {trigger: "_", replacement: "_{$0}$1", options: "mA", description: "Subscript"},
  {trigger: "st", replacement: "_\\text{$0}", options: "rmA", description: "Text subscript"},
  {trigger: "sq", replacement: "\\sqrt{ $0 }$1", options: "mA", description: "Square root"},
  {trigger: "//", replacement: "\\frac{$0}{$1}$2", options: "mA", description: "Fraction"},
  {trigger: "frac", replacement: "\\frac{$0}{$1}$2", options: "mA", description: "Fraction"},
  {trigger: "ee", replacement: "e^{ $0 }$1", options: "mA", description: "e to the power of..."},
  {trigger: "conj", replacement: "^{*}", options: "mA", description: "Conjugate"},
  // Divisions
  {trigger: "mod", replacement: "\\mod ", options: "mA"},
  {trigger: "gcd", replacement: "\\gcd ", options: "mA"},
  // Logarithms
  {trigger: "log", replacement: "\\log", options: "mA"},
  {trigger: "ln", replacement: "\\ln", options: "mA"},
  
  
  // Logical operators (logical and, or, not, xor, etc.)
  {trigger: "lor", replacement: "\\lor", options: "mA"},
  {trigger: "land", replacement: "\\land", options: "mA"},
  {trigger: "lxor", replacement: "\\oplus", options: "mA"},
  {trigger: "neg", replacement: "\\neg", options: "mA"},
  {trigger: "no===", replacement: "\\not\\equiv", options: "mA"},
  // Equality symbols
  {trigger: "\\\\(neq|geq|leq|gg|ll|sim)([0-9]+)", replacement: "\\[[0]] [[1]]", options: "rmA"}, // Insert space after inequality symbols
  
  
  // Symbols
  {trigger: "ooo", replacement: "\\infty", options: "mA", description: "Infinity"},
  {trigger: "sum", replacement: "\\sum ", options: "mA", description: "Summation"},
  {trigger: "ssum", replacement: "\\sum_{$0}^{$1}$2", options: "mA", description: "Summation auto tab"},
  {trigger: "prod", replacement: "\\prod", options: "mA", description: "Product"},
  {trigger: "pprod", replacement: "\\prod_{$0}^{$1}$2", options: "mA", description: "Product auto tab"},
  {trigger: "lim", replacement: "\\lim_{ ${0:n} \\to ${1:\\infty} } $2", options: "mA", description: "Limit"},
  
  {trigger: "xx", replacement: "\\times ", options: "mA", description: "Multiplication X"},
  {trigger: "**", replacement: "\\cdot ", options: "mA", description: "Multiplication dot"},
  {trigger: "div", replacement: "\\div ", options: "mA", description: "Division symbol"},
  {trigger: "([^\\\\])pm", replacement: "[[0]]\\pm", options: "rm", description: "Plus-minus"},
  {trigger: "([^\\\\])mp", replacement: "[[0]]\\mp", options: "rm", description: "Minus-plus"},
  {trigger: "+-", replacement: "\\pm ", options: "mA", description: "Plus-minus"},
  {trigger: "-+", replacement: "\\mp ", options: "mA", description: "Minus-plus"},
  {trigger: "inv", replacement: "^{-1}", options: "mA", description: "Inverse"},
  {trigger: "\\\\\\", replacement: "\\setminus", options: "mA", description: "Division using a backslash"},
  {trigger: "mid", replacement: "\\mid ", options: "mA"},
  {trigger: "given", replacement: "\\mid ", options: "mA", description: "Given symbol in probability"},
  {trigger: "!|", replacement: "\\nmid ", options: "mA"},
  {trigger: "%", replacement: "\\%$0", options: "rmA", description: "Percent"},
  
  // Set theory
  {trigger: "and", replacement: "\\cap ", options: "mA"},
  {trigger: "orr", replacement: "\\cup ", options: "mA"},
  {trigger: "inn", replacement: "\\in ", options: "mA"},
  {trigger: "notin", replacement: "\\not\\in ", options: "mA"},
  {trigger: "\\subset eq", replacement: "\\subseteq ", options: "mA"},
  {trigger: "eset", replacement: "\\emptyset", options: "mA"},
  // {trigger: "set", replacement: "\\{ $0 \\}$1", options: "mA"},
  {trigger: "set", replacement: "\\left\\{ $0 \\right\\}", options: "mA"},
  {trigger: "=>", replacement: "\\implies ", options: "mA"},
  {trigger: "=<", replacement: "\\impliedby ", options: "mA"},
  {trigger: "iff", replacement: "\\iff ", options: "mA"},
  // Quantifications
  {trigger: "forall", replacement: "\\forall ", options: "mA"},
  {trigger: "e\\xi", replacement: "\\exists", options: "mA", priority: 1},
  
  // Comparison operators
  {trigger: "===", replacement: "\\equiv ", options: "mA"},
  {trigger: "~=", replacement: "\\approx ", options: "mA"},
  {trigger: "!=", replacement: "\\neq ", options: "mA"},
  {trigger: "neq", replacement: "\\neq ", options: "mA"},
  {trigger: ">=", replacement: "\\geq ", options: "mA"},
  {trigger: "geq", replacement: "\\geq ", options: "mA"},
  {trigger: "<=", replacement: "\\leq ", options: "mA"},
  {trigger: "leq", replacement: "\\leq ", options: "mA"},
  {trigger: ">>", replacement: "\\gg ", options: "mA"},
  {trigger: "<<", replacement: "\\ll ", options: "mA"},
  {trigger: "~~", replacement: "\\sim ", options: "mA"},
  {trigger: "sim", replacement: "\\sim ", options: "mA"},
  
  {trigger: "para", replacement: "\\parallel ", options: "mA"},
  {trigger: "prop", replacement: "\\propto ", options: "mA"},
  {trigger: "nab", replacement: "\\nabla", options: "mA"},
  {trigger: "grad", replacement: "\\nabla", options: "mA", description: "Gradient symbol"},
  {trigger: "delta", replacement: "\\delta", options: "mA"},
  {trigger: "upkap", replacement: "\\upkappa", options: "mA"},
  
  {trigger: "deg", replacement: "\\degree", options: "mA"},
  {trigger: "o+", replacement: "\\oplus ", options: "mA", description: "Circle with a plus"},
  {trigger: "ox", replacement: "\\otimes ", options: "mA", description: "Circle with a times"},
  {trigger: "otimes", replacement: "\\otimes ", options: "mA", description: "Circle with a times"},
  {trigger: "Sq", replacement: "\\square ", options: "mA", description: "Square"},
  {trigger: "dag", replacement: "^{\\dagger}", options: "mA", description: "Dagger"},
  
  
  // Brackets
  {trigger: "avg", replacement: "\\langle $0 \\rangle$1", options: "mA", description: "Left and right angle brackets"},
  {trigger: "norm", replacement: "\\lvert $0 \\rvert$1", options: "mA", priority: 1, description: "Left and right vertical pipes"},
  {trigger: "ceil", replacement: "\\lceil $0 \\rceil$1", options: "mA", description: "Ceiling"},
  {trigger: "floor", replacement: "\\lfloor $0 \\rfloor$1", options: "mA", description: "Floor"},
  {trigger: "mood", replacement: "|$0|$1", options: "mA", description: "Pipes"},
  {trigger: "(", replacement: "(${VISUAL})", options: "mA"},
  {trigger: "[", replacement: "[${VISUAL}]", options: "mA"},
  {trigger: "{", replacement: "{${VISUAL}}", options: "mA"},
  {trigger: "(", replacement: "($0)$1", options: "mA"},
  {trigger: "{", replacement: "{$0}$1", options: "mA"},
  {trigger: "[", replacement: "[$0]$1", options: "mA"},
  {trigger: "{{", replacement: "\\{ ", options: "mA"},
  {trigger: "}}", replacement: "\\} ", options: "mA"},
  // Auto-scaling brackets
  {trigger: "lr(", replacement: "\\left( $0 \\right)$1", options: "mA"},
  {trigger: "||", replacement: "\\left| $0 \\right|$1", options: "mA"},
  {trigger: "abs", replacement: "\\left| $0 \\right|$1", options: "mA"},
  {trigger: "lr|", replacement: "\\left| $0 \\right|$1", options: "mA"},
  {trigger: "lr{", replacement: "\\left\\{ $0 \\right\\}$1", options: "mA"},
  {trigger: "lr[", replacement: "\\left[ $0 \\right]$1", options: "mA"},
  {trigger: "lr<", replacement: "\\left< $0 \\right>$1", options: "mA"},
  {trigger: "<>", replacement: "\\left< $0 \\right>$1", options: "mA"},
  // Bra-ket notation (quantum mechanics)
  {trigger: "bra", replacement: "\\bra{$0} $1", options: "mA", description: "Left angle bracket and right pipe"},
  {trigger: "ket", replacement: "\\ket{$0} $1", options: "mA", description: "Left pipe and right angle bracket"},
  {trigger: "brk", replacement: "\\braket{ $0 | $1 } $2", options: "mA", description: "Left angle bracket, middle pipe, right angle bracket"},
  {trigger: "\\\\bra{([^|]+)\\|", replacement: "\\braket{ [[0]] | $0 ", options: "rmA", description: "Convert bra into braket"},
  {trigger: "\\\\bra{(.+)}([^ ]+)>", replacement: "\\braket{ [[0]] | $0 ", options: "rmA", description: "Convert bra into braket (alternate)"},
  
  
  // Probability
  // {trigger: "choose", replacement: "\\binom{$0}{$1}", options: "mA", description: "Probability combination"},
  {trigger: "([A-Za-z0-9]+) choose", replacement: "\{[[0]] \\choose $0\}$1", options: "rmA", description: "Probability combination"},
  {trigger: "\{([A-Za-z0-9]+) choose", replacement: "\{[[0]] \\choose $0", options: "rmA", priority: 1, description: "Probability combination"},
  
  
  // Scientific stuff
  {trigger: "t_{1}0", replacement: "\\times 10^{$0}$1", options: "mA", priority: 1, description: "10^n"},
  // Units
  //	{trigger: "uu", replacement: "~\\mathrm{$0}$1", options: "mA", description: "Add space before units and enter rm format (custom option using mathrm)"},
  {trigger: "pu", replacement: "~\\pu{$0}", options: "mA", description: "Physical units with a space before (built-in LaTeX option)"},	
  
  
  // Big-O notation
  {trigger: "OO1", replacement: "O(1)", options: "mA", description: "Big-O of 1"},
  {trigger: "OO\\logn", replacement: "O(\\log n)", options: "mA", description: "Big-O of log n"},
  {trigger: "OOn", replacement: "O(n)", options: "mA", description: "Big-O of n"},
  {trigger: "O(n)\\logn", replacement: "O(n \\log n)", options: "mA", description: "Big-O of n log n"},
  {trigger: "O(n)2", replacement: "O(n^2)", options: "rmA", description: "Big-O of n squared"},
  {trigger: "O(n)3", replacement: "O(n^3)", options: "rmA", description: "Big-O of n cubed"},
  {trigger: "OO_{2}n", replacement: "O(2^n)", options: "mA", description: "Big-O of 2^n"},
  {trigger: "O(n)!", replacement: "O(n!)", options: "mA", description: "Big-O of n factorial"},
  
  
  // Trig functions
  {trigger: "([^\\\\])(arcsin|arccos|arctan|arccot|arccsc|arcsec|sin|cos|tan|cot|csc|sec)", replacement: "[[0]]\\[[1]]", options: "rmA"},
  {trigger: "\\\\(arcsin|arccos|arctan|arccot|arccsc|arcsec|sin|cos|tan|cot|csc|sec)([A-Za-gi-z])", replacement: "\\[[0]] [[1]]", options: "rmA"}, // Insert space after trig funcs. Skips letter "h" to allow sinh, cosh, etc.
  {trigger: "\\\\(arcsinh|arccosh|arctanh|arccoth|arcsch|arcsech|sinh|cosh|tanh|coth|csch|sech)([A-Za-z])", replacement: "\\[[0]] [[1]]", options: "rmA"}, // Insert space after trig funcs
  
  
  // Unit vectors
  {trigger: ":i", replacement: "\\mathbf{i}", options: "mA"},
  {trigger: ":j", replacement: "\\mathbf{j}", options: "mA"},
  {trigger: ":k", replacement: "\\mathbf{k}", options: "mA"},
  {trigger: ":x", replacement: "\\hat{\\mathbf{x}}", options: "mA"},
  {trigger: ":y", replacement: "\\hat{\\mathbf{y}}", options: "mA"},
  {trigger: ":z", replacement: "\\hat{\\mathbf{z}}", options: "mA"},
  
  
  // Derivatives and partial derivatives
  {trigger: "ddt", replacement: "\\frac{d}{dt} ", options: "mA", description: "d/dt"},
  {trigger: "par", replacement: "\\frac{ \\partial ${0:y} }{ \\partial ${1:x} } $2", options: "mA", description: "Partial derivative"},
  {trigger: "pa2", replacement: "\\frac{ \\partial^{2} ${0:y} }{ \\partial ${1:x}^{2} } $2", options: "mA", description: "Second partial derivative"},
  {trigger: "pa3", replacement: "\\frac{ \\partial^{3} ${0:y} }{ \\partial ${1:x}^{3} } $2", options: "mA", description: "Third partial derivative"},
  {trigger: "pa([A-Za-z])([A-Za-z])", replacement: "\\frac{ \\partial [[0]] }{ \\partial [[1]] } ", options: "rm"},
  {trigger: "pa([A-Za-z])([A-Za-z])([A-Za-z])", replacement: "\\frac{ \\partial^{2} [[0]] }{ \\partial [[1]] \\partial [[2]] } ", options: "rm"},
  {trigger: "pa([A-Za-z])([A-Za-z])2", replacement: "\\frac{ \\partial^{2} [[0]] }{ \\partial [[1]]^{2} } ", options: "rmA"},
  {trigger: "de([A-Za-z])([A-Za-z])", replacement: "\\frac{ d[[0]] }{ d[[1]] } ", options: "rm"},
  {trigger: "de([A-Za-z])([A-Za-z])2", replacement: "\\frac{ d^{2}[[0]] }{ d[[1]]^{2} } ", options: "rmA"},
  
  
  // Integrals
  {trigger: "int", replacement: "\\int ", options: "mA", description: "Integral"},
  // The main integral option you want to use
  // Tab through each field (lower bound, upper bound, integrand, and variable of integration) (defaults to 0 to infinity and dx)
  {trigger: "dint", replacement: "\\int_{${0:0}}^{${1:\\infty}} $2 \\, d${3:x}$4", options: "mA", description: "Definite integral"},
  {trigger: "eint", replacement: "\\int_{$0}^{$1} $2 \\, d${3:x}$4", options: "mA", description: "Empty definite integral"},
  {trigger: "oinf", replacement: "\\int_{0}^{\\infty} $0 \\, d${1:x}$2", options: "mA", description: "Integral from 0 to infinity"},
  {trigger: "infint", replacement: "\\int_{-\\infty}^{\\infty} $0 \\, d${1:x}$2", options: "mA", description: "Integral from -infinity to infinity"},
  {trigger: "oint", replacement: "\\oint", options: "mA", description: "Closed loop integral"},
  {trigger: "iint", replacement: "\\iint", options: "mA", description: "Double integral"},
  {trigger: "iiint", replacement: "\\iiint", options: "mA", description: "Triple integral"},
  
  
  // Matrices and Vectors
  {trigger: "mag", replacement: "\\left|\\left| $0 \\right|\\right|$1", options: "mA", description: "Vector magnitude (auto-scaling bars)"},
  // {trigger: "mag", replacement: "\\big\\| $0 \\big\\| $1", options: "mA"},
  {trigger: "m([A-Z])", replacement: "\\mathbf{[[0]]}", options: "rmA", description: "Bold matrix identifier"},
  {trigger: "\\to p", replacement: "\\top", options: "mA", description: "Looks like an T or upside down perp (Useful for transpose)"},
  {trigger: "\\\\mathbf{([A-Za-z])}T", replacement: "\\mathbf{[[0]]}^{\\top}", options: "rmA", description: "Matrix transpose"},
  {trigger: "det", replacement: "\\det($0)", options: "mA", description: "Matrix determinant"},
  {trigger: "ker", replacement: "\\ker($0)", options: "mA", description: "Matrix kernel"},
  {trigger: "dim", replacement: "\\dim($0)", options: "mA", description: "Matrix dimension"},
  {trigger: "Im", replacement: "\\operatorname{Im}($0)", options: "mA", description: "Matrix image"},
  {trigger: "basis", replacement: "\\operatorname{basis}($0)", options: "mA", description: "Matrix basis"},
  {trigger: "\\nu ll", replacement: "\\operatorname{null}($0)", options: "mA", description: "Matrix null space"},
  {trigger: "span", replacement: "\\operatorname{span}($0)", options: "mA", description: "Matrix span (parentheses)"},
  {trigger: "sspan", replacement: "\\operatorname{span}\\left\\{ $0 \\right\\}$1", options: "mA", description: "Matrix span (braces)"},
  {trigger: "rank", replacement: "\\operatorname{rank}($0)", options: "mA", description: "Matrix rank"},
  {trigger: "row", replacement: "\\operatorname{row}($0)", options: "mA", description: "Matrix row"},
  {trigger: "col", replacement: "\\operatorname{col}($0)", options: "mA", description: "Matrix column"},
  {trigger: "proj", replacement: "\\operatorname{proj}", options: "mA", description: "Matrix projection"},
  {trigger: "\\mathbb{R}EF", replacement: "\\operatorname{RREF}($0)", options: "mA", description: "Matrix RREF"},
  
  
  // Machine Learning
  {trigger: "exp", replacement: "\\operatorname{exp}($0)", options: "mA", description: "e to the power of..."},
  {trigger: "min", replacement: "\\operatorname{min}($0)", options: "mA", description: "Minimum"},
  {trigger: "max", replacement: "\\operatorname{max}($0)", options: "mA", description: "Maximum"},
  
  
  // Environments and matrices/arrays
  {trigger: "beg", replacement: "\\begin{$0}\n$1\n\\end{$0}", options: "mA", description: "Create a new environment"},
  {trigger: "matrix", replacement: "\\begin{matrix}\n$0\n\\end{matrix}", options: "mA", description: "Matrix (no brackets)"},
  {trigger: "pmat", replacement: "\\begin{pmatrix}\n$0\n\\end{pmatrix}", options: "mA", description: "Parentheses matrix"},
  {trigger: "bmat", replacement: "\\begin{bmatrix}\n$0\n\\end{bmatrix}", options: "mA", description: "Brackets matrix"},
  {trigger: "ibmat", replacement: "\\begin{bmatrix} $0 \\end{bmatrix}", options: "mA", description: "Inline brackets matrix"},
  {trigger: "Bmat", replacement: "\\begin{Bmatrix}\n$0\n\\end{Bmatrix}", options: "mA", description: "Curly braces matrix"},
  {trigger: "vmat", replacement: "\\begin{vmatrix}\n$0\n\\end{vmatrix}", options: "mA", description: "Vertical bars matrix"},
  {trigger: "Vmat", replacement: "\\begin{Vmatrix}\n$0\n\\end{Vmatrix}", options: "mA", description: "Double vertical bars matrix"},
  {trigger: "case", replacement: "\\begin{cases}\n$0\n\\end{cases}", options: "mA", description: "Cases list (left brace)"},
  {trigger: "icase", replacement: "\\begin{cases} $0 \\end{cases}", options: "mA", description: "Inline cases list (left brace)"},
  {trigger: "array", replacement: "\\begin{array}{}\n$0\n\\end{array}", options: "mA", description: "Array (no brackets)"},
  {trigger: "brr", replacement: "\\left[\\begin{array}{}\n$0\n\\end{array}\\right]", options: "mA", description: "Brackets array"},
  // Array with custom column bars; specify column bars with c's and pipes: e.g. {cc|cc|c}
  {trigger: "carray", replacement: "\\left[\\begin{array}{$0}\n$1\n\\end{array}\\right]", options: "mA", description: "Array with custom column bars"},
  {trigger: "icarray", replacement: "\\left[\\begin{array}{$0} $1 \\end{array}\\right]", options: "mA", description: "Inline array with custom column bars"},
  {trigger: "align", replacement: "\\begin{align}\n$0\n\\end{align}", options: "mA", description: "Align environment"},
  {trigger: "hline", replacement: "\\hline", options: "mA", description: "Horizontal line for matrices/arrays"},
  
  
  // Greek letters
  {trigger: "@a", replacement: "\\alpha", options: "mA"},
  {trigger: "@A", replacement: "\\alpha", options: "mA"},
  {trigger: "@b", replacement: "\\beta", options: "mA"},
  {trigger: "@B", replacement: "\\beta", options: "mA"},
  {trigger: "@c", replacement: "\\chi", options: "mA"},
  {trigger: "@C", replacement: "\\chi", options: "mA"},
  {trigger: "@g", replacement: "\\gamma", options: "mA"},
  {trigger: "@G", replacement: "\\Gamma", options: "mA"},
  {trigger: "@d", replacement: "\\delta", options: "mA"},
  {trigger: "@D", replacement: "\\Delta", options: "mA"},
  {trigger: "@e", replacement: "\\epsilon", options: "mA"},
  {trigger: "eps", replacement: "\\epsilon", options: "mA"},
  {trigger: "@E", replacement: "\\epsilon", options: "mA"},
  {trigger: ":e", replacement: "\\varepsilon", options: "mA"},
  {trigger: ":E", replacement: "\\varepsilon", options: "mA"},
  {trigger: "@z", replacement: "\\zeta", options: "mA"},
  {trigger: "@Z", replacement: "\\zeta", options: "mA"},
  {trigger: "@t", replacement: "\\theta", options: "mA"},
  {trigger: "@T", replacement: "\\Theta", options: "mA"},
  {trigger: "@k", replacement: "\\kappa", options: "mA"},
  {trigger: "@K", replacement: "\\kappa", options: "mA"},
  {trigger: "lambda", replacement: "\\lambda", options: "mA"},
  {trigger: "@l", replacement: "\\lambda", options: "mA"},
  {trigger: "@L", replacement: "\\Lambda", options: "mA"},
  {trigger: "@m", replacement: "\\mu", options: "mA"},
  {trigger: "@M", replacement: "\\mu", options: "mA"},
  {trigger: "@r", replacement: "\\rho", options: "mA"},
  {trigger: "@R", replacement: "\\rho", options: "mA"},
  {trigger: "@s", replacement: "\\sigma", options: "mA"},
  {trigger: "@S", replacement: "\\Sigma", options: "mA"},
  {trigger: "ome", replacement: "\\omega", options: "mA"},
  {trigger: "@o", replacement: "\\omega", options: "mA"},
  {trigger: "Ome", replacement: "\\Omega", options: "mA"},
  {trigger: "@O", replacement: "\\Omega", options: "mA"},
  {trigger: "@u", replacement: "\\upsilon", options: "mA"},
  {trigger: "@U", replacement: "\\Upsilon", options: "mA"},
  {trigger: "([^\\\\])(${GREEK}|${SYMBOL})", replacement: "[[0]]\\[[1]]", options: "rmA", description: "Add backslash before greek letters and symbols"},
  
  // Insert space after greek letters and symbols, etc
  {trigger: "\\\\(${GREEK}|${SYMBOL}|${SHORT_SYMBOL})([A-Za-z])", replacement: "\\[[0]] [[1]]", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) sr", replacement: "\\[[0]]^{2}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) cb", replacement: "\\[[0]]^{3}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) rd", replacement: "\\[[0]]^{$0}$1", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) hat", replacement: "\\hat{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) dot", replacement: "\\dot{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) bar", replacement: "\\bar{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) vec", replacement: "\\vec{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) tilde", replacement: "\\tilde{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK}|${SYMBOL}) und", replacement: "\\underline{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK}),\\.", replacement: "\\boldsymbol{\\[[0]]}", options: "rmA"},
  {trigger: "\\\\(${GREEK})\\.,", replacement: "\\boldsymbol{\\[[0]]}", options: "rmA"},
  
  // Physics 2 CONSTANTS
  {trigger: "K:", replacement: "8.99\\times 10^{9}", options: "mA", description: "Coulomb's constant"},
  {trigger: "\\epsilon_{0}:", replacement: "8.85\\times 10^{-12}", options: "mA", description: "Permittivity of free space"},
  {trigger: "\\mu_{0}:", replacement: "1.257\\times 10^{-6}", options: "mA", description: "Permeability of free space"},
  {trigger: "c::", replacement: "3.00\\times 10^{8}", options: "mA", description: "Speed of light in vacuum"},
]
