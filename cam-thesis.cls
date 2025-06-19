%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Class ``cam-thesis''
%%
%% Version: v0.2
%% Authors: Jean Martina, Rok Strnisa, Matej Urbas
%% Date: 30/07/2008
%%
%% Copyright (c) 2008-2012, Rok Strniša, Jean Martina, Matej Urbas
%% License: Simplified BSD License
%% License file: ./License
%% Original License URL: http://www.freebsd.org/copyright/freebsd-license.html
%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% General guidelines on which this class is based:
%%
%%     http://www.cl.cam.ac.uk/local/phd/typography/
%%     http://www.admin.cam.ac.uk/offices/gradstud/exams/submission/phd/format.html
%%
%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Class identification.
%%
%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cam-thesis}[2012/04/12 University of Cambridge thesis class]

\typeout{}
\typeout{***********************************************}
\typeout{***********************************************}
\typeout{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% General Cambridge guidelines.
%%
%% LIMIT: 60k words (including tables and footnotes, excluding appendices, bib,
%% photos, diagrams); title and section headings should be capitalized as normal
%% sentences; citations should include authors' initials, and page numbers (if
%% possible); double-sided printing is permissible for the soft bound version;
%% however, single-sided is required for the text of the final, hard bound
%% library copy (diagrams on facing pages are acceptable); always make it
%% possible to create the ps file as well (required for technical reports).
%%
%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Package options (see README.md for a list of options with descriptions).
%%
%% These options can be provided within square brackets of the `documentclass'
%% command.
%%
%%%%%

% techreport - formats the thesis as a technical report.
\newif\ifcam@techreport\cam@techreportfalse
\DeclareOption{techreport}{\cam@techreporttrue}

% times - tells the class to use the times font.
\newif\ifcam@times\cam@timesfalse
\DeclareOption{times}{\cam@timestrue}

% glossary - puts the glossary (after the TOC).
%
\newif\ifcam@glossary\cam@glossaryfalse
\DeclareOption{glossary}{\cam@glossarytrue}

% index - puts the index at the end of the thesis.
%
\newif\ifcam@index\cam@indexfalse
\DeclareOption{withindex}{\cam@indextrue}

% 1st year report - omits abstract/declaration
%
\newif\ifcam@firstyr\cam@firstyrfalse
\DeclareOption{firstyr}{\cam@firstyrtrue}

% 2nd year report - omits declaration
%
\newif\ifcam@secondyr\cam@secondyrfalse
\DeclareOption{secondyr}{\cam@secondyrtrue}

% backrefs - add back references
%
\newif\ifcam@backrefs\cam@backrefsfalse
\DeclareOption{backrefs}{\cam@backrefstrue}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Using report class as base.
%%
%%%%%
\PassOptionsToClass{a4paper,12pt,twoside,openright}{report}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax
\LoadClass{report}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% For consistent vertical spacing
%%
%%%%%
\raggedbottom


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Additional packages, and their options.
%%
%%%%%
\RequirePackage{graphicx}           % Required for the UC Logo (on the title page)
\RequirePackage{calc}               % Used for calculating margins and laying out the title page
\RequirePackage{setspace}      	    % Used for selecting single or onehalf line spacing.
\RequirePackage{microtype}          % Improvement of general text appearance 

% Hyperref should be included in any case, but we make it non-obtrusive (i.e.: no hyperlink borders).
% Why do we need a separate treatment of hyperref for the techreport? Because the guidelines say so. :)
\ifcam@techreport
    % TODO: If the thesis is compiled to PS, include the 'dvips' option to hyperref.
    \RequirePackage[
        pdfpagelabels=false,
        pdfborder={0 0 0},
        pdfusetitle=true
    ]{hyperref}
\else
    \RequirePackage[
        pdffitwindow=true,
        pdfpagelabels=true,
        colorlinks=false,
        pdfborder={0 0 0},
        pdfusetitle=true
    ]{hyperref}
\fi
\RequirePackage[all]{hypcap}        % Fixes links to floats (must be included after hyperref).

% Create the index
\ifcam@index
    \RequirePackage{makeidx}
    \makeindex
    \newcommand{\printthesisindex}{%
        \cleardoublepage%
        \phantomsection%
        \addcontentsline{toc}{chapter}{Index}%
        \printindex}
\fi

% Create the glossary
\ifcam@glossary
    \RequirePackage{glossaries}
    \makeglossaries%
    \newcommand{\printthesisglossary}{\printglossary[nonumberlist]}
    \newcommand{\cam@printthesisglossary}{%
        \cleardoublepage%
        \pagestyle{empty}%
        \renewcommand{\glossarypreamble}{\thispagestyle{empty}}%
        \printthesisglossary%
    }
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Page margins (suitable for J.S. Wilson & Son).
%%
%%%%%

\newlength{\cam@topmargin}
\newlength{\cam@bottommargin}
\newlength{\cam@oddmargin}
\newlength{\cam@evenmargin}


%% Calculate and set the margins properly (with parameters that actually have
%% some meaning for everyday thesis-writers).
%%
%% @param	1	odd side margin (inner margin).
%% @param	2	even side margin (outer margin).
%% @param	3	top margin.
%% @param	4	bottom margin.
\DeclareRobustCommand{\cam@calcpaperdims}[4]{%
% MARGINS
% 'Top margin' is the distance between the top of the text and the top of the page.
% 'Bottom margin' is the distance between the bottom of the footer (the page number) and the bottom of the page.
\setlength{\cam@oddmargin}{#1}        % inner margin
\setlength{\cam@evenmargin}{#2}       % outer margin
\setlength{\cam@topmargin}{#3}        % top margin        (the distance from the top of the page to the top of the body text -- the header is located between)
\setlength{\cam@bottommargin}{#4}     % bottom margin     (the distance from the bottom of the page to the bottom of the body text -- the footer is located between)
% Horizontal spacing
\setlength{\textwidth}{\paperwidth-\cam@oddmargin-\cam@evenmargin}     % text takes the remaining width (210 - inner - outer)
\setlength{\oddsidemargin}{\cam@oddmargin-1in}   % Counter the LaTeX 1in margin
\setlength{\evensidemargin}{\cam@evenmargin-1in} % Counter the LaTeX 1in margin
\setlength{\marginparwidth}{\cam@evenmargin-8mm} % the margin only has 'outer' space available, so we have to make it a bit thinner.
\setlength{\marginparsep}{3mm}

% Vertical spacing
\setlength{\headheight}{5mm}      % The height of the box where the heading text lives
\setlength{\headsep}{5mm}         % The distance between the heading and the top of the text
\setlength{\topmargin}{\cam@topmargin-\headheight-\headsep-1in} % Counter the LaTeX 1in margin

\setlength{\textheight}{\paperheight-\cam@topmargin-1.7\cam@bottommargin}   % text takes the remaining height (297 - top margin - bottom margin)
\setlength{\footskip}{.7\cam@bottommargin} % The distance from the bottom of the text to the bottom of the footer
}
\ifcam@techreport
\cam@calcpaperdims{25mm}{25mm}{20mm}{20mm}
\else
\cam@calcpaperdims{30mm}{20mm}{20mm}{20mm}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Fonts
%%
%%%%%

% Font recommended by the Computer Laboratory (Adobe Sabon).
% Note: You might need to install it first.
% \renewcommand\rmdefault{psb}

% Use the times font if the user selected this option.
\ifcam@times
    \RequirePackage{times}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Line spacing
%%
%%%%%

% One-and-a-half spacing (required by board of graduate studies).
% (Should remove this for Computer Laboratory technical report.)
\ifcam@techreport\else%
    \onehalfspacing%
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Variable definitions and default values: these variables should be defined by
%% the user (somewhere in the preamble). For example, to put the abstract into
%% the thesis, the thesis writer should type the following somewhere in the
%% preamble (before the `\begin{document}` or `\frontmatter` commands are
%% called):
%%
%%      \abstract{This is my abstract.}
%%
%% See below (in the comments starting with 'DOCVAR: ') for a list of all
% variables
%% the thesis writer is expected to use.
%%
%%%%%

% DOCVAR: abstract (The text that will be instered into the abstract of the
% thesis.)
\newcommand{\@abstract}{}
\renewcommand{\abstract}[1]{\renewcommand{\@abstract}{#1}}

% DOCVAR: acknowledgements (The text that will be instered into the
% acknowledgments of the thesis.)
\newcommand{\@acknowledgements}{}
\newcommand{\acknowledgements}[1]{\renewcommand{\@acknowledgements}{#1}}

% DOCVAR: college (The name of the thesis writer's college, which will appear
% just below their name.)
\newcommand{\@college}{}
\newcommand{\college}[1]{\renewcommand{\@college}{#1}}

% DOCVAR: keywords (These keywords will appear in the PDF meta-information
% called `pdfkeywords`.)
\newcommand{\@keywords}{}
\newcommand{\keywords}[1]{\renewcommand{\@keywords}{#1}}

% DOCVAR: subjectline (This subject will appear in the PDF meta-information
% called `pdfsubject`.)
\newcommand{\@subjectline}{}
\newcommand{\subjectline}[1]{\renewcommand{\@subjectline}{#1}}

% DOCVAR: submissiondate (The date of the submission of this thesis. If the
% submission date is provided, it will be printed on the title page--within the
% `submissionnotice` by default. Note that the thesis writer can provide their
% own `submissionnotice`, in which case it is up to them whether they will use
% this date in their notice.)
\newif\ifcam@submissiondate\cam@submissiondatefalse
\newcommand{\@submissiondate}{}
\newcommand{\submissiondate}[1]{\renewcommand{\@submissiondate}{#1}\cam@submissiondatetrue}

% DOCVAR: submissionnotice (The submission notice is shown on the bottom of the
% title page.)
\newcommand{\@submissionnotice}{%
\ifcam@firstyr
First year report submitted
\else 
\ifcam@secondyr
Second year report submitted
\else
This dissertation is submitted
\fi
\fi
\ifcam@submissiondate
    on \@submissiondate{}
\fi
\ifcam@firstyr
in partial fulfilment of the requirements
\fi
\ifcam@secondyr
in partial fulfilment of the requirements
\fi
for the degree of Doctor of Philosophy%
}
\newcommand{\submissionnotice}[1]{\renewcommand{\@submissionnotice}{#1}}

% DOCVAR: collegeshield (The name of the file that contains the image of the
% college's shield. If `collegeshield' is provided, it will be included in the
% title page (just below the author's name and above the name of the college).
\newif\ifcam@collegeshield\cam@collegeshieldfalse
\newcommand{\@collegeshield}{}
\newcommand{\collegeshield}[1]{\renewcommand{\@collegeshield}{#1}\cam@collegeshieldtrue}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Chapter and section numbering
%%
% TODO: Check whether numbering up to the fourth level is okay. It is not
% specified in the guidelines.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Front matter
%%
%% - outside and inside front cover
%% - title leaf
%% Do not include the date of make!
%% Institution + department.
%% Names of referees. (optional)
%% Degree.
%% Date of submission and defense. (optional)
%% Place and date of publication and publishers (and other info by them).
%%%%%
\newcommand{\frontmatter}{

\pagestyle{empty}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Title page components
%%
%%%%%
\ifcam@techreport
% Technical report mustn't have the custom title page (a standard one will be
% prepended by the editor, see http://www.cl.cam.ac.uk/techreports/submission.html).
\else
% The boxes below are all that will be displayed on the title page. They are
% used to calculate exactly how much space should be left between them
% (vertically).

%% LOGO box
\newlength{\cam@logorightnudge}
\setlength{\cam@logorightnudge}{-0.5\paperwidth+12mm}
\newsavebox{\cam@logo}
\begin{lrbox}{\cam@logo}
\hspace*{\cam@logorightnudge}\includegraphics[width=73mm]{CollegeShields/CUni}
\end{lrbox}

%% THESIS TITLE box
\newsavebox{\cam@title}
\begin{lrbox}{\cam@title}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
			\Huge%
				\ifcam@times\else%
				\bfseries%
				\fi%
			{\@title{}}%
			\ifcam@firstyr\\%
				{\vspace{5mm}\emph{\LARGE PhD Proposal}}%
			\fi%
			\ifcam@secondyr\\%
				{\vspace{5mm}\emph{\LARGE Dissertation Schedule}}%
			\fi
		\end{center}
    \end{minipage}
\end{lrbox}

%% COLLEGESHIELD box (optional):
\ifcam@collegeshield%
    \newsavebox{\cam@collegeshieldbox}
    \begin{lrbox}{\cam@collegeshieldbox}
    \includegraphics[height=20mm]{\@collegeshield}
    \end{lrbox}
\fi

%% AUTHOR&COLLEGE box
\newsavebox{\cam@authorcollege}
\begin{lrbox}{\cam@authorcollege}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
        {\large \@author{}~\\[1ex]}
        \ifcam@collegeshield%
            \vspace{2mm}{\usebox{\cam@collegeshieldbox}}\\
        \fi
        \@college{}
        \end{center}
    \end{minipage}
\end{lrbox}

%% SUBMISSION NOTICE box
\newsavebox{\cam@submitnotice}
\begin{lrbox}{\cam@submitnotice}
    \begin{minipage}[c][\height][c]{.98\textwidth}
        \begin{center}
            \@submissionnotice{}
        \end{center}
    \end{minipage}
\end{lrbox}

% Now calculate the exact free vertical space
\newlength{\cam@titlepagevspace}
\setlength{\cam@titlepagevspace}{\textheight%
	-\totalheightof{\usebox{\cam@logo}}%
	-\totalheightof{\usebox{\cam@submitnotice}}%
	-\totalheightof{\usebox{\cam@authorcollege}}%
	-\totalheightof{\usebox{\cam@title}}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Title Page: Put the components (logo, title, author, college and submit
%% notice) onto the title page.
%%
%%%%%
\begin{center}
~\vspace{.02\cam@titlepagevspace}\\
{\usebox{\cam@logo}}\\
\vspace{.28\cam@titlepagevspace}
{\usebox{\cam@title}}\\
\vspace{.23\cam@titlepagevspace}
{\usebox{\cam@authorcollege}}\\
\null\vfill
{\usebox{\cam@submitnotice}}
\end{center}
\hypersetup{pdfsubject={\@subjectline},pdfkeywords={\@keywords}}
\fi

% Epigraph on odd page. (optional)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Declaration
%%
%%%%%
\ifcam@techreport
% Technical report doesn't need the declaration
% (see http://www.cl.cam.ac.uk/techreports/submission.html).
\else
{\ifcam@firstyr
% First and second yr report don't need the declaration
\else 
\ifcam@secondyr
%
\else
\chapter*{Declaration}
\thispagestyle{empty}
This dissertation is the result of my own work and includes nothing which is the outcome
of work done in collaboration except as declared in the Preface and specified in the text.
It is not substantially the same as any that I have submitted, or am concurrently
submitting, for a degree or diploma or other qualification at the University of Cambridge
or any other University or similar institution except as declared in the Preface and
specified in the text. I further state that no substantial part of my dissertation has
already been submitted, or is being concurrently submitted, for any such degree, diploma
or other qualification at the University of Cambridge or any other University or similar
institution except as declared in the Preface and specified in the text.
This dissertation does not exceed the prescribed limit of 60\,000 words.

% Leaving some space for the signature:
\vspace{15mm}

\begin{flushright}
\@author{}\\
\@date{}\\
\end{flushright}
\vfill
\fi
\fi}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Abstract
%%
%%%%%
\ifcam@techreport%
    \setcounter{page}{3}
\fi

\ifcam@firstyr
% First yr report doesn't need a standalone abstract
\else

\chapter*{Abstract}
\thispagestyle{empty}

% Cambridge thesis submission guidelines require the title and author be in the abstract.
% For more info see https://www.cambridgestudents.cam.ac.uk/your-course/examinations/graduate-exam-information/after-examination/degree-approval-and-1
\textbf{\large \@title}
\par\vspace{0.3cm}
\noindent\textit{\@author}
\par\vspace{0.6cm}

\@abstract{}
\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Acknowledgements
%%
%%%%%

\ifcam@firstyr
% First and second yr report don't need the acknowledgements
\else 
{\ifcam@secondyr
%
\else
\chapter*{Acknowledgements}
\thispagestyle{empty}
\@acknowledgements{}
\fi}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Table of contents, figures, symbols and glossary.
%%
%%%%%

% The following command prevents the page number to be displayed on the first
% page of the TOC.
\addtocontents{toc}{\protect\thispagestyle{empty}}
\pagestyle{empty}
\tableofcontents{}

\ifcam@glossary%
    \cam@printthesisglossary
\fi

\cleardoublepage
\pagestyle{plain}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Backrefs
%%
%%%%%

\ifcam@backrefs
\RequirePackage[hyperpageref]{backref}
\renewcommand*{\backref}[1]{}
\renewcommand*{\backrefalt}[4]{%
	\ifcase #1 %
	\or
	{\footnotesize Cited on page #2.}%
	\else
	{\footnotesize Cited on pages #2.}%
	\fi
}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Additional Packages 
%%
%%%%% 

% number formatting 
\usepackage{siunitx}
\sisetup{mode = math}
\usepackage{xspace} 

% math symbols 
\usepackage{latexsym}
\usepackage{amsmath}
\usepackage{amsthm}
\usepackage{amssymb}
\usepackage{mathtools} 


% checkmarks and crossmarks
\usepackage{pifont}
\newcommand{\cmark}{\textcolor{green!60!black}{\ding{51}}} % green checkmark
\newcommand{\xmark}{\textcolor{red}{\ding{55}}}     
\usepackage{enumitem}

% Table packages: 
% - allow table cells to span multiple rows
% - enables top lines 
\usepackage{multirow}
\usepackage{booktabs}
\usepackage{tabularray}
\usepackage{makecell}

% citation for citep
\usepackage[numbers]{natbib} 

% better placement of figures - can use H 
\usepackage{float}
\usepackage{wrapfig}
\usepackage{subcaption}

% emojies
\usepackage{twemojis}

% color customization for background and text 
\usepackage[HTML,table]{xcolor}

% highlighting of text 
\usepackage{soul}

% text underline
\usepackage[normalem]{ulem}

% quotation Marks 
\usepackage{csquotes} 

% color notes/ boxes for highlighting 
\usepackage[most]{tcolorbox}

% special Fonts 
\usepackage{fontspec}
\defaultfontfeatures{Path=fonts/}
\newfontface\rammetto{RammettoOne-Regular.ttf}

% clever referencing \cref 
\usepackage{cleveref}
\crefname{section}{\S}{\S\S}
\Crefname{section}{\S}{\S\S}
\crefformat{section}{\S#2#1#3}
\crefname{figure}{Fig.}{Fig.}
\crefname{alg}{Alg.}{Alg.}
\crefname{line}{line}{lines}
\crefname{appendix}{App.}{App.}
\crefname{equation}{eq.}{eqs.}
\crefname{table}{Table}{Tables}
\crefname{proposition}{Proposition}{Propositions}
\crefname{assumption}{Assump.}{Assumps.}
\crefname{lemma}{Lemma}{Lemmas}
\crefname{definition}{Defn.}{Defns.}
\crefname{hypothesis}{Hypothesis}{Hypotheses}
\crefname{estimator}{Estimator}{Estimators}
\crefname{theorem}{Theorem}{Theorems}
\crefname{thm}{Theorem}{Theorems}
\crefname{result}{Result}{Results}

% Thesis Main Colors 
\definecolor{thesisorange}{HTML}{ff7f11}
\definecolor{thesisblue}{HTML}{37718e}
\definecolor{thesisbeige}{HTML}{faedca}
\definecolor{thesispurple}{HTML}{c1cefe}
\definecolor{thesisgreen}{HTML}{a0ddff}

%%
%% MACROS 
%%

% Create Special \myemph emphasis that escapes '_' correctly 
\makeatletter
\DeclareRobustCommand*{\escapeus}[1]{%
  \begingroup\@activeus\scantokens{#1\endinput}\endgroup}
\begingroup\lccode`\~=`\_\relax
   \lowercase{\endgroup\def\@activeus{\catcode`\_=\active \let~\_}}
\makeatother

\newcommand{\myemph}[1]{\textsf{{\escapeus{#1}}}}

% Setup integer and float and other number standardizations 
\newcommand{\integer}[1]{%
    \num[
        mode = math,
        round-mode=places,
        round-precision=0,
        group-separator={,},
        group-minimum-digits=4,
        ]{#1}%
    \xspace
}
\newcommand{\float}[2][1]{%
    \num[
        group-digits=false, 
        round-precision=#1, 
        round-mode=places,
    ]{#2}%
    \xspace
}

\newcommand{\snum}[1]{\num{#1}\xspace}

\newcommand{\q}[2]{\qty[mode=math]{#1}{#2}\xspace}
\DeclareSIUnit[quantity-product = {}]\percent{\%}
\DeclareSIUnit[quantity-product = {}]\thousand{k}
\DeclareSIUnit[quantity-product = {}]\million{M}
\DeclareSIUnit[quantity-product = {}]\billion{B}
\DeclareSIUnit[quantity-product = {}]\trillion{T}

% Results Theorem Style  

\newtheoremstyle{resultstyle} % name of the style to be used
  {.8em} % space above
  {.8em} % space below
  {} % font in the body of the theorem
  {} % indent amount
  {\bfseries} % theorem head font
  {.} %  punctuation after theorem head
  {.5em} % space after theorem head
  {\thmname{#1 }\thmnumber{#2. }\textbf{\thmnote{#3}}}

\theoremstyle{resultstyle}
\newtheorem{result}{Result} 

%%%% Special Variable, Math Utilities

% matrices
\newcommand{\Xmatrix}{\boldsymbol{\mathrm{X}}}
\newcommand{\Ymatrix}{\boldsymbol{\mathrm{Y}}}
\newcommand{\Wmatrix}{\boldsymbol{\mathrm{W}}}

% functions
\newcommand{\defn}[1]{\textbf{#1}}
\newcommand{\defeq}[0]{\mathrel{\stackrel{\textnormal{\tiny def}}{=}}}
\newcommand{\smalldots}{...}
\newcommand{\size}[1]{{\vert #1 \vert}}
\newcommand{\norm}[1]{\left\lVert#1\right\rVert}

% tokens
\newcommand{\token}{t}
\newcommand{\sequence}{\boldsymbol{\mathrm{\token}}}

% data, activations, and params
\newcommand{\xdata}{\boldsymbol{x}}
\newcommand{\act}{\boldsymbol{a}}
\newcommand{\actatt}{\act^{\mathtt{ATT}}}
\newcommand{\actmlp}{\act^{\mathtt{MLP}}}
\newcommand{\attention}{\mathrm{Attention}}
\newcommand{\mlp}{\mathrm{MLP}}
\newcommand{\vtheta}{\boldsymbol{\theta}}
\newcommand{\attweight}{\vtheta^{\mathtt{ATT}}}
\newcommand{\mlpweight}{\vtheta^{\mathtt{MLP}}}
\newcommand{\actcenter}{\overline{\act}}

% dimensions
\newcommand{\layer}{l}
\newcommand{\numlayers}{L}
\newcommand{\seqlen}{T}
\newcommand{\residualdim}{D}
\newcommand{\hiddendim}{H}
\newcommand{\checkpoint}{c}
\newcommand{\numcheckpoints}{C}

% spaces
\newcommand{\R}{\mathbb{R}}

% others
\newcommand{\ptheta}{p_{\scaleto{\vtheta}{5pt}}}
\newcommand{\vocab}{\mathcal{V}}
\newcommand{\vocabeos}{\overline{\vocab}}
\DeclareMathOperator*{\expect}{\mathbb{E}}

%%%% Paper Specific Macros 

% Tending Towards Stability - Macros
\definecolor{70M}{HTML}{003049}
\definecolor{160M}{HTML}{2a9d8f}
\definecolor{410M}{HTML}{d62828}
\definecolor{1.4B}{HTML}{9b5de5}
\definecolor{2.8B}{HTML}{ff9f1c}
\newcommand{\sevenmil}{\myemph{\textcolor{70M}{\q{70}{\million}}}\xspace}
\newcommand{\sixmil}{\myemph{\textcolor{160M}{\q{160}{\million}}}\xspace}
\newcommand{\fourmil}{\myemph{\textcolor{410M}{\q{410}{\million}}}\xspace}
\newcommand{\onebil}{\myemph{\textcolor{1.4B}{\q{1.4}{\billion}}}\xspace}
\newcommand{\twobil}{\myemph{\textcolor{2.8B}{\q{2.8}{\billion}}}\xspace}

\newcommand{\per}{\mathrm{PER}}
\newcommand{\er}{\mathrm{ER}}
\newcommand{\cka}{\mathrm{CKA}\xspace}

% Pico - Macros 
\newcommand{\pico}{{\rammetto\fontsize{10pt}{12pt}\selectfont Pico}\xspace}
\newcommand{\picolarge}{{\rammetto\fontsize{12pt}{14pt}\selectfont Pico}\xspace}


%%%%% EOF: cam-thesis.cls
