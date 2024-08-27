// Global Settings
settings.showModeStatus = true;
settings.richHintsForKeystroke = 500;
settings.omnibarPosition = "bottom";
settings.focusFirstCandidate = false;
settings.omnibarSuggestion = true;
settings.newTabPosition = "right";
settings.tabsMRUOrder = true;
settings.cursorAtEndOfInput = true;
settings.tabsThreshold = 5;
settings.hintAlign = "left";
settings.modeAfterYank = "Normal";

// Search settings
addSearchAliasX('D', 'ddgH', 'https://duckduckgo.com/html/?q=', 's', 'https://duckduckgo.com/ac/?q=', function(response) {
    var res = JSON.parse(response.text);
    return res.map(function(r){
        return r.phrase;
    });
});
settings.defaultSearchEngine = 'D';

// Hints settings
Hints.characters = 'yuiophjklnm'; // for right hand
settings.hintAlign = "left";

// Mappings
map("J", "E"); // use ctrl-p to switch to previous tab
map("K", "R"); // use ctrl-p to switch to next tab
map("F", "gf"); //shift + F for following links


// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult>ul>li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult>ul>li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;
