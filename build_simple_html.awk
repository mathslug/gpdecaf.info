#!/usr/bin/awk -f

# Function to print opening HTML tags
function print_html_header() {
    print "<!DOCTYPE html>";
    print "<html>";
    print "<head>";
    print "<title>GP Decaf</title>";  # You can customize the title
    print "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\">";
    print "</head>";
    print "<body>";
}

# Function to print closing HTML tags
function print_html_footer() {
    print "</body>";
    print "</html>";
}

# Function to print a paragraph
function print_paragraph() {
    if (paragraph != "") {
        print "<p>" paragraph "</p>";
        paragraph = "";
    }
}

BEGIN {
    print_html_header();  # Print the header at the beginning
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

    # Hyperlinks
    while(match($0, /\[[^\]]+\]\([^\)]+\)/)) {
        link_start = RSTART;
        link_end = RLENGTH;
        link_text = substr($0, link_start + 1, index(substr($0, link_start), "]") - 2);
        url_start = link_start + index(substr($0, link_start), "(") - 1;
        url = substr($0, url_start + 1, index(substr($0, url_start), ")") - 2);
        $0 = substr($0, 1, link_start - 1) "<a href=\"" url "\">" link_text "</a>" substr($0, link_start + link_end);
    }

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


END {
    print_html_footer();  # Print the footer at the end
}
