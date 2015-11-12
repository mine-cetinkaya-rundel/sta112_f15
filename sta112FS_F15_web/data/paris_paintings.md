---
layout: page
title: paris_paintings.csv
---

These data were collected by Hilary Coe Cronheim and Sandra van Ginhoven (Duke Art, Art History & Visual Studies PhD students) as part of the Data Expeditions project sponsored by <a href = "http://bigdata.duke.edu/">iiD</a>.

This data frame contains the following variables (columns):

* `name` - unique identifier of painting
* `sale` - code for sale (dealer initial + year of sale)
* `lot` - lot number in the catalogue
* `position` - position of lot in the catalogue (as %, to control for size of sale)
* `dealer` - dealer initials (4 unique dealers: J, L, P, R)
* `year` - year of sale
* `origin_author` - origin of painting based on nationality of artist (A = Austrian, D/FL = Dutch/Flemish, F = French, G = German, I = Italian, S = Spanish, X = Unknown)
* `origin_cat` - origin of painting based on dealers' classification in the catalogue (D/FL = Dutch/Flemish, F = French, I = Italian, O = Other, S = Spanish)
* `school_pntg` - school of painting (A = Austrian, D/FL = Dutch/Flemish, F = French, G = German, I = Italian, S = Spanish, X = Unknown) 
* `diff_origin` - if origin_author is different than origin_cat (0/1)
* `logprice` - log of price fetched at auction (sales price in livres)
* `price` - price fetched at auction (sales price in livres)
* `count` - count, all 1s
* `subject` - short description of subject matter
* `authorstandard` - name of artist (standardized)
* `artistliving` - if artist is living or deceased at time of the sale (1 = yes, 0 = no)
* `authorstyle` - indicates how, if at all, the authors name is introduced, e.g. school of, copy after, in the manner of etc. or n/a if there is no introduction
* `author` - name of artist (not standardized)
* `winningbidder` - name of winning bidder
* `winningbiddertype` - type of winning bidder (B = buyer, BB = buyer on behalf of buyer, BC = buyer on behalf of collector, C = collector, D = dealer, DB = dealer on behalf of buyer, DC = dealer on behalf of collector, DD = dealer on behalf of dealer, E = expert organizing the sale, EB = expert on behalf of buyer, EBC = expert on behalf of buyer on behalf of collector, EC = expert on behalf of collector, ED = expert on behalf of dealer, X = identity unknown; blank = no information)
* `endbuyer` - type of end buyer (B = buyer, C = collector, D = dealer, E = expert organizing the sale, X = identity unknown; blank = no information)
* `interm` - whether or not an intermediary is involved in the transaction (1 = yes, 0 = no)
* `type_intermed` - type of intermediary (B = buyer, D = dealer, E = expert) 
* `Height_in` - height of painting in inches
* `Width_in` - width of painting in inches
* `Surface_rect` - surface of rectangular painting in squared inches
* `Diam_in` - diameter of painting in inches 
* `Surface_rnd` - surface of round painting 
* `Shape` - shape of painting
* `Surface` - surface of painting in squared inches
* `material` - material of support (canvas, wood, copper, etc.)
* `mat` - category of material (a=silver, al=alabaster, ar=slate, b=wood, bc=wood and copper, br=bronze frames, bt=canvas on wood, c=copper, ca=cardboard, co=cloth, e=wax, g=grissaille technique, h=oil technique, m=marble, mi=miniature technique, o=other, p=paper, pa=pastel, t=canvas, ta=canvas?, v=glass, n/a=NA, (blanks)=NA)
* `quantity` - count 
* `nfigures` - number of figures (if specified)
* `engraved` - if the dealer mentions engravings done after the painting
* `original` - if the original's whereabouts is mentioned (when painting is a copy)
* `prevcoll` - if the previous owner is mentioned
* `othartist` - if the painting is linked to the work of another artist or style
* `paired` - if the painting is sold or suggested as a pairing for another
* `figures` - if the number of figures included is emphasized
* `finished` - if the painting is noted for its highly polished finishing
* `lrgfont` - if the dealer devotes an additional paragraph (always written in a larger font size)
* `relig` - if description mentions a religious subject matter
* `landsALL` - if any type of landscape is mentioned (either lands_sc, lands_figs, or lands_ment)
* `lands_sc` - if described as a plain landscape
* `lands_elem` - if landscape elements are mentioned in the description (if lands_figs=1 or lands_ment=1)
* `lands_figs` - if description mentions figures in a landscape
* `lands_ment` - if landscape is mentioned in the description
* `arch` - if architectural constructions are mentioned in the description
* `mytho` - if a mythological scene is mentioned
* `peasant` - if description mentions peasants messing around
* `othgenre` - if description mentions a genre scene (different than a peasant scene)
* `singlefig` - if description mentions a single figure (different than a portrait)
* `portrait` - if described as a portrait
* `still_life` - if description indicates still life elements
* `discauth` - if the dealer engages with the authenticity of the painting
* `history` - if description includes elements of history painting
* `allegory` - if allegorical scene is mentioned
* `pastorale` - if "pastorale" is used in the description
* `other` - represents any other subject matter not captured by the previous variables