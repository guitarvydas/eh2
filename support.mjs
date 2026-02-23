// decode.mjs
import { decode } from 'html-entities';


function legalize (s) {
    return s.replace (/ /g, "_");
}

function decodeHTML(s) {
    let prev;
    do { prev = s; s = decode(s); } while (s !== prev);
    return s;
}

