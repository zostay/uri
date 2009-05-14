use v6;

# Taken/Copied with relatively minor translation to Perl6
# from RFC 3986 (http://www.ietf.org/rfc/rfc3986.txt)

use IETF::RFC_Grammar::IPv6;

grammar IETF::RFC_Grammar::URI is IETF::RFC_Grammar::IPv6 {
    token URI_reference     { <URI> | <relative_ref> };

    token absolute_URI      { <scheme> ':' <hier_part> [ '?' query ]? };
    token relative_ref      {
        <relative_part> [ '?' <query> ]? [ '#' <fragment> ]?
    };

    token relative_part     {
        '//' <authority> <.path_abempty>    |
        <.path_absolute>                    |
        <.path_noscheme>                    |
        <.path_empty>
    };

    token URI               {
        <scheme> ':' <hier_part> [ '?' <query> ]? [ '#' <fragment> ]?
    };

    token hier_part     {
        '//' <authority> <.path_abempty>    |
        <.path_absolute>                    |
        <.path_rootless>                    |
        <.path_empty>
    };

    token scheme            { <.uri_alpha> <[\-+.] +uri_alpha +digit>* };
    
    token authority         { [ <userinfo> '@' ]? <host> [ ':' <port> ]? };
    token userinfo          {
        [ <[:] +unreserved +sub_delims> | <.pct_encoded> ]*
    };    
    token host              { <IPv4address> | <IP_literal> | <reg_name> };
    token port              { <.digit>* };

    token IP_literal        { '[' [ <IPv6address> | <IPvFuture> ] ']' };
    token IPvFuture         {
        'v' <.xdigit>+ '.' <[:] +unreserved +sub_delims>+
    };
    token reg_name          { [ <+unreserved +sub_delims> | <.pct_encoded> ]* };

    token path_abempty      { [ '/' <.segment> ]* };
    token path_absolute     { '/' [ <.segment_nz> [ '/' <.segment> ]* ]? };
    token path_noscheme     { <.segment_nz_nc> [ '/' <.segment> ]* };
    token path_rootless     { <.segment_nz> [ '/' <.segment> ]* };
    token path_empty        { <.pchar> ** 0 }; # yes - zero characters

    token   segment         { <.pchar>* };
    token   segment_nz      { <.pchar>+ };
    token   segment_nz_nc   { [ <+unenc_pchar - [:]> | <.pct_encoded> ] + };

    token query             { <.fragment> };
    token fragment          { [ <[/?] +unenc_pchar> | <.pct_encoded> ]* };

    token pchar             { <.unenc_pchar> | <.pct_encoded> };
    token unenc_pchar       { <[:@] +unreserved +sub_delims> };

    token pct_encoded       { '%' <.xdigit> <.xdigit> };

    token unreserved        { <[\-._~] +uri_alphanum> };

    token reserved          { <+gen_delims +sub_delims> };

    token gen_delims        { <[:/?#\[\]@]> };
    token sub_delims        { <[;!$&'()*+,=]> };

    token uri_alphanum      { <+uri_alpha +digit> };   
    token uri_alpha         { <+lowalpha +upalpha> };

    token lowalpha          { <[a..z]> };
    token upalpha           { <[A..Z]> };
}

# vim:ft=perl6