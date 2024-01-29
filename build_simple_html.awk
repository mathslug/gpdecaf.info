#!/usr/bin/awk -f

function print_paragraph() {
    if (paragraph != "") {
        print "<p>" paragraph "</p>";
        paragraph = "";
    }
}

{
    # Header
    if ($0 ~ /^#+/) {
        print_paragraph();
        n = split($0, header, " ");
        size = length(header[1]);
        $1 = ""; # Remove the '#' characters
        print "<h" size ">" $0 "</h" size ">";
        next;
    }

    # Bold and Italic
    gsub(/\*\*([^\*]+)\*\*/, "<strong>\\1</strong>");
    gsub(/__([^_]+)__/,"<strong>\\1</strong>");
    gsub(/\*([^\*]+)\*/, "<em>\\1</em>");
    gsub(/_([^_]+)_/, "<em>\\1</em>");

    # Paragraph
    if (NF > 0) {
        paragraph = paragraph " " $0;
    } else {
        print_paragraph();
    }
}

END {
    print_paragraph();
}
