CLASS lcl_file_api DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS read_abap
      RETURNING
        VALUE(r_result) TYPE string.
    CLASS-METHODS read_json
      RETURNING
        VALUE(r_result) TYPE string.
    CLASS-METHODS read_js
      RETURNING
        VALUE(r_result) TYPE string.
    CLASS-METHODS read_yaml
      RETURNING
        VALUE(r_result) TYPE string.
    CLASS-METHODS read_text
      RETURNING
        VALUE(r_result) TYPE string.

    TYPES:
      BEGIN OF ty_s_suggest,
        name  TYPE string,
        value TYPE string,
      END OF ty_s_suggest.
    TYPES ty_t_suggest TYPE STANDARD TABLE OF ty_s_suggest WITH EMPTY KEY.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_file_api IMPLEMENTATION.


  METHOD read_abap.

    r_result = `METHOD SELECT_FILES.` && |\n| &&
           |\n| &&
           `    DATA: LV_RET_CODE TYPE I,` && |\n| &&
           `          LV_USR_AXN  TYPE I.` && |\n| &&
           |\n| &&
           `    CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG(` && |\n| &&
           `      EXPORTING` && |\n| &&
           `        WINDOW_TITLE            = 'Select file'` && |\n| &&
           `        MULTISELECTION          = 'X'` && |\n| &&
           `      CHANGING` && |\n| &&
           `        FILE_TABLE              = ME->PT_FILETAB` && |\n| &&
           `        RC                      = LV_RET_CODE` && |\n| &&
           `        USER_ACTION             = LV_USR_AXN` && |\n| &&
           `      EXCEPTIONS` && |\n| &&
           `        FILE_OPEN_DIALOG_FAILED = 1` && |\n| &&
           `        CNTL_ERROR              = 2` && |\n| &&
           `        ERROR_NO_GUI            = 3` && |\n| &&
           `        NOT_SUPPORTED_BY_GUI    = 4` && |\n| &&
           `        OTHERS                  = 5` && |\n| &&
           `           ).` && |\n| &&
           `    IF SY-SUBRC <> 0 OR` && |\n| &&
           `       LV_USR_AXN = CL_GUI_FRONTEND_SERVICES=>ACTION_CANCEL.` && |\n| &&
           `      RAISE EX_FILE_SEL_ERR.` && |\n| &&
           `    ENDIF.` && |\n| &&
           |\n| &&
           `  ENDMETHOD.   `.

  ENDMETHOD.


  METHOD read_json.

    r_result = `{` && |\n| &&
               `    "quiz": {` && |\n| &&
               `        "sport": {` && |\n| &&
               `            "q1": {` && |\n| &&
               `                "test" : false,` && |\n| &&
               `                "question": "Which one is correct team name in NBA?",` && |\n| &&
               `                "options": [` && |\n| &&
               `                    "New York Bulls",` && |\n| &&
               `                    "Los Angeles Kings",` && |\n| &&
               `                    "Golden State Warriros",` && |\n| &&
               `                    "Huston Rocket"` && |\n| &&
               `                ],` && |\n| &&
               `                "answer": "Huston Rocket"` && |\n| &&
               `            }` && |\n| &&
               `        },` && |\n| &&
               `        "maths": {` && |\n| &&
               `            "q1": {` && |\n| &&
               `                "question": "5 + 7 = ?",` && |\n| &&
               `                "options": [` && |\n| &&
               `                    "10",` && |\n| &&
               `                    "11",` && |\n| &&
               `                    "12",` && |\n| &&
               `                    "13"` && |\n| &&
               `                ],` && |\n| &&
               `                "answer": "12"` && |\n| &&
               `            },` && |\n| &&
               `            "q2": {` && |\n| &&
               `                "question": true,` && |\n| &&
               `                "options": [` && |\n| &&
               `                    "1",` && |\n| &&
               `                    "2",` && |\n| &&
               `                    "3",` && |\n| &&
               `                    "4"` && |\n| &&
               `                ],` && |\n| &&
               `                "answer": 487829` && |\n| &&
               `            }` && |\n| &&
               `        }` && |\n| &&
               `    }` && |\n| &&
               `}`.

  ENDMETHOD.


  METHOD read_js.

    r_result = `function showAlert() {` && |\n| &&
               `    alert("Alert from JS file");` && |\n| &&
               `}` && |\n| &&
               |\n| &&
               `function updateHeading() {` && |\n| &&
               `    document.getElementById('heading').innerHTML = 'Heading changed with JS';` && |\n| &&
               `}`.

  ENDMETHOD.


  METHOD read_yaml.

    r_result = `# Employee records` && |\n| &&
               `- martin:` && |\n| &&
               `    name: Martin Developer` && |\n| &&
               `    job: Developer` && |\n| &&
               `    skills:` && |\n| &&
               `      - python` && |\n| &&
               `      - perl` && |\n| &&
               `      - pascal` && |\n| &&
               `- tabitha:` && |\n| &&
               `    name: Tabitha Bitumen` && |\n| &&
               `    job: Developer` && |\n| &&
               `    skills:` && |\n| &&
               `      - lisp` && |\n| &&
               `      - fortran` && |\n| &&
               `      - erlang`.

  ENDMETHOD.


  METHOD read_text.
    r_result = `TXT test file` && |\n| &&
               `Purpose: Provide example of this file type` && |\n| &&
               `Document file type: TXT` && |\n| &&
               `Version: 1.0` && |\n| &&
               `Remark:` && |\n| &&
               |\n| &&
               `Example content:` && |\n| &&
               `The names "John Doe" for males, "Jane Doe" or "Jane Roe" for females, or "Jonnie Doe" and "Janie Doe" for children, or just ` &&
               ` "Doe" non-gender-specifically are used as placeholder names for a party whose true identity is unknown or must ` &&
               `be withheld in a legal action, case, or discussion. The names are also used to refer to acorpse or hospital patient whose ` &&
               `identity is unknown. This practice is widely used in the United States and Canada, but is rarely used in other ` &&
               `English-speaking countries including the United Kingdom itself, from where the use of "John Doe" in a legal context ` &&
               `originates. The names Joe Bloggs or John Smith are used in the UK instead, as well as in Australia and New Zealand.` &&
               |\n| &&
               |\n| &&
               `John Doe is sometimes used to refer to a typical male in other contexts as well, in a similar manner to John Q. Public,` &&
               ` known in Great Britain as Joe Public, John Smith or Joe Bloggs. For example, the first name listed on a form is often ` &&
               `John Doe, along with a fictional address or other fictional information to provide an example of how to fill in the form` &&
               `. The name is also used frequently in popular culture, for example in the Frank Capra film Meet John Doe. John Doe was ` &&
               `also the name of a 2002 American television series.`.
  ENDMETHOD.

ENDCLASS.
