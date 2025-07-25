/*
    tripass : password generator that uses a dictionary of three letter words.

    Author:  Simon Rowe <simon@wiremoons.com>
    License: MIT
    File:    triwords.odin

    Source:  https://www.github.com/wiremoons/tripass
*/
package tripass

import "core:testing"

// Define constants for any array based maximum to avoid out of bounds errors.
MAX_WORDS :: len(words) - 1
MAX_MARKS :: len(marks) - 1

// Each character (mark) is used as an additional random value to enhance 
// the strength of the generated password. Total marks included: 10
@rodata
marks := [?]rune{'#', '.', ';', '@', '%', ':', '!', '>', '-', '<'}

// Each string in the array contains a three letter english word used
// to generate a password string. Total words included: 1311
//odinfmt: disable
@rodata
words := [?]string{
    "aah", "aal", "aas", "aba", "abb", "abo", "abs", "aby", "ace", "ach", "act",
    "add", "ado", "ads", "adz", "aff", "aft", "aga", "age", "ago", "ags", "aha",
    "ahi", "ahs", "aia", "aid", "ail", "aim", "ain", "air", "ais", "ait", "aka",
    "ake", "ala", "alb", "ale", "alf", "all", "alp", "als", "alt", "alu", "ama",
    "ame", "ami", "amp", "amu", "ana", "and", "ane", "ani", "ann", "ans", "ant",
    "any", "ape", "apo", "app", "apt", "arb", "arc", "ard", "are", "arf", "ark",
    "arm", "ars", "art", "ary", "ash", "ask", "asp", "ass", "ate", "ats", "att",
    "aua", "aue", "auf", "auk", "ava", "ave", "avo", "awa", "awe", "awk", "awl",
    "awn", "axe", "aye", "ays", "ayu", "azo", "baa", "bac", "bad", "bag", "bah",
    "bal", "bam", "ban", "bap", "bar", "bas", "bat", "bay", "bed", "bee", "beg",
    "bel", "ben", "bes", "bet", "bey", "bez", "bib", "bid", "big", "bin", "bio",
    "bis", "bit", "biz", "boa", "bob", "bod", "bog", "boh", "boi", "bok", "bon",
    "boo", "bop", "bor", "bos", "bot", "bow", "box", "boy", "bra", "bro", "brr",
    "bru", "bub", "bud", "bug", "bum", "bun", "bur", "bus", "but", "buy", "bye",
    "bys", "caa", "cab", "cad", "cag", "cam", "can", "cap", "car", "cat", "caw",
    "cay", "caz", "cee", "cel", "cep", "cha", "che", "chi", "cid", "cig", "cis",
    "cit", "cly", "cob", "cod", "cog", "col", "con", "coo", "cop", "cor", "cos",
    "cot", "cow", "cox", "coy", "coz", "cru", "cry", "cub", "cud", "cue", "cum",
    "cup", "cur", "cut", "cuz", "cwm", "dab", "dad", "dae", "dag", "dah", "dak",
    "dal", "dam", "dan", "dap", "das", "daw", "day", "deb", "dee", "def", "deg",
    "dei", "del", "den", "dev", "dew", "dex", "dey", "dib", "did", "die", "dif",
    "dig", "dim", "din", "dip", "dis", "dit", "div", "dob", "doc", "dod", "doe",
    "dof", "dog", "doh", "dol", "dom", "don", "doo", "dop", "dor", "dos", "dot",
    "dow", "doy", "dry", "dso", "dub", "dud", "due", "dug", "duh", "dui", "dun",
    "duo", "dup", "dux", "dye", "dzo", "ean", "ear", "eas", "eat", "eau", "ebb",
    "ech", "eco", "ecu", "edh", "eds", "eek", "eel", "een", "eff", "efs", "eft",
    "egg", "ego", "ehs", "eik", "eke", "eld", "elf", "elk", "ell", "elm", "els",
    "elt", "eme", "emo", "ems", "emu", "end", "ene", "eng", "ens", "eon", "era",
    "ere", "erf", "erg", "erk", "erm", "ern", "err", "ers", "ess", "est", "eta",
    "eth", "euk", "eve", "evo", "ewe", "ewk", "ewt", "exo", "eye", "faa", "fab",
    "fad", "fae", "fag", "fah", "fan", "fap", "far", "fas", "fat", "faw", "fax",
    "fay", "fed", "fee", "feg", "feh", "fem", "fen", "fer", "fes", "fet", "feu",
    "few", "fey", "fez", "fib", "fid", "fie", "fig", "fil", "fin", "fir", "fit",
    "fix", "fiz", "flu", "fly", "fob", "foe", "fog", "foh", "fon", "fop", "for",
    "fou", "fox", "foy", "fra", "fro", "fry", "fub", "fud", "fug", "fum", "fun",
    "fur", "gab", "gad", "gae", "gag", "gak", "gal", "gam", "gan", "gap", "gar",
    "gas", "gat", "gau", "gaw", "gay", "ged", "gee", "gel", "gem", "gen", "geo",
    "ger", "get", "gey", "ghi", "gib", "gid", "gie", "gif", "gig", "gin", "gio",
    "gip", "gis", "git", "gju", "gnu", "goa", "gob", "god", "goe", "gon", "goo",
    "gor", "gos", "got", "gov", "gox", "goy", "gub", "gue", "gul", "gum", "gun",
    "gup", "gur", "gus", "gut", "guv", "guy", "gym", "gyp", "had", "hae", "hag",
    "hah", "haj", "ham", "han", "hao", "hap", "has", "hat", "haw", "hay", "heh",
    "hem", "hen", "hep", "her", "hes", "het", "hew", "hex", "hey", "hic", "hid",
    "hie", "him", "hin", "hip", "his", "hit", "hmm", "hoa", "hob", "hoc", "hod",
    "hoe", "hog", "hoh", "hoi", "hom", "hon", "hoo", "hop", "hos", "hot", "how",
    "hox", "hoy", "hub", "hue", "hug", "huh", "hui", "hum", "hun", "hup", "hut",
    "hye", "hyp", "ice", "ich", "ick", "icy", "ide", "ids", "iff", "ifs", "igg",
    "ilk", "ill", "imp", "ing", "ink", "inn", "ins", "ion", "ios", "ire", "irk",
    "ish", "ism", "iso", "ita", "its", "ivy", "iwi", "jab", "jag", "jai", "jak",
    "jam", "jap", "jar", "jaw", "jay", "jee", "jet", "jeu", "jew", "jib", "jig",
    "jin", "jiz", "job", "joe", "jog", "jol", "jor", "jot", "jow", "joy", "jud",
    "jug", "jun", "jus", "jut", "kab", "kae", "kaf", "kai", "kak", "kam", "kas",
    "kat", "kaw", "kay", "kea", "keb", "ked", "kef", "keg", "ken", "kep", "ket",
    "kex", "key", "khi", "kid", "kif", "kin", "kip", "kir", "kis", "kit", "koa",
    "kob", "koi", "kon", "kop", "kor", "kos", "kow", "kue", "kye", "kyu", "lab",
    "lac", "lad", "lag", "lah", "lam", "lap", "lar", "las", "lat", "lav", "law",
    "lax", "lay", "lea", "led", "lee", "leg", "lei", "lek", "lep", "les", "let",
    "leu", "lev", "lew", "lex", "ley", "lez", "lib", "lid", "lie", "lig", "lin",
    "lip", "lis", "lit", "lob", "lod", "log", "loo", "lop", "lor", "los", "lot",
    "lou", "low", "lox", "loy", "lud", "lug", "lum", "lur", "luv", "lux", "luz",
    "lye", "lym", "maa", "mac", "mad", "mae", "mag", "mak", "mal", "mam", "man",
    "map", "mar", "mas", "mat", "maw", "max", "may", "med", "mee", "meg", "meh",
    "mel", "mem", "men", "mes", "met", "meu", "mew", "mho", "mib", "mic", "mid",
    "mig", "mil", "mim", "mir", "mis", "mix", "miz", "mna", "moa", "mob", "moc",
    "mod", "moe", "mog", "moi", "mol", "mom", "mon", "wit", "moo", "mop", "mor",
    "mos", "mot", "mou", "mow", "moy", "moz", "mud", "mug", "mum", "mun", "mus",
    "mut", "mux", "myc", "nab", "nae", "nag", "nah", "nam", "nan", "nap", "nas",
    "nat", "naw", "nay", "neb", "ned", "nee", "nef", "neg", "nek", "nep", "net",
    "new", "nib", "nid", "nie", "nil", "nim", "nip", "nis", "nit", "nix", "nob",
    "nod", "nog", "noh", "nom", "non", "noo", "nor", "nos", "not", "now", "nox",
    "noy", "nth", "nub", "nun", "nur", "nus", "nut", "nye", "nys", "oaf", "oak",
    "oar", "oat", "oba", "obe", "obi", "obo", "obs", "oca", "och", "oda", "odd",
    "ode", "ods", "oes", "off", "oft", "ohm", "oho", "ohs", "oik", "oil", "ois",
    "oka", "oke", "old", "ole", "olm", "oms", "one", "ono", "ons", "ony", "oof",
    "ooh", "oom", "oon", "oop", "oor", "oos", "oot", "ope", "ops", "opt", "ora",
    "orb", "orc", "ord", "ore", "orf", "ors", "ort", "ose", "oud", "ouk", "oup",
    "our", "ous", "out", "ova", "owe", "owl", "own", "owt", "oxo", "oxy", "oye",
    "oys", "pac", "pad", "pah", "pal", "pam", "pan", "pap", "par", "pas", "pat",
    "pav", "paw", "pax", "pay", "pea", "pec", "ped", "pee", "peg", "peh", "pel",
    "pen", "pep", "per", "pes", "pet", "pew", "phi", "pho", "pht", "pia", "pic",
    "pie", "pig", "pin", "pip", "pir", "pis", "pit", "piu", "pix", "plu", "ply",
    "poa", "pod", "poh", "poi", "pol", "pom", "poo", "pop", "pos", "pot", "pow",
    "pox", "poz", "pre", "pro", "pry", "psi", "pst", "pub", "pud", "pug", "puh",
    "pul", "pun", "pup", "pur", "pus", "put", "puy", "pya", "pye", "pyx", "qat",
    "qis", "qua", "qin", "rad", "rag", "rah", "rai", "raj", "ram", "ran", "rap",
    "ras", "rat", "rav", "raw", "rax", "ray", "reb", "rec", "red", "ree", "ref",
    "reg", "reh", "rei", "rem", "ren", "reo", "rep", "res", "ret", "rev", "rew",
    "rex", "rez", "rho", "rhy", "ria", "rib", "rid", "rif", "rig", "rim", "rin",
    "rip", "rit", "riz", "rob", "roc", "rod", "roe", "rok", "rom", "roo", "rot",
    "row", "rub", "ruc", "rud", "rue", "rug", "rum", "run", "rut", "rya", "rye",
    "sab", "sac", "sad", "sae", "sag", "sai", "sal", "sam", "san", "sap", "sar",
    "sat", "sau", "sav", "saw", "sax", "say", "saz", "sea", "sec", "sed", "see",
    "seg", "sei", "sel", "sen", "ser", "set", "sew", "sex", "sey", "sez", "sha",
    "she", "shh", "shy", "sib", "sic", "sif", "sik", "sim", "sin", "sip", "sir",
    "sis", "sit", "six", "ska", "ski", "sky", "sly", "sma", "sny", "sob", "soc",
    "sod", "sog", "soh", "sol", "som", "son", "sop", "sos", "sot", "sou", "sov",
    "sow", "sox", "soy", "soz", "spa", "spy", "sri", "sty", "sub", "sud", "sue",
    "sug", "sui", "suk", "sum", "sun", "sup", "suq", "sur", "sus", "swy", "sye",
    "syn", "tab", "tad", "tae", "tag", "tai", "taj", "tak", "tam", "tan", "tao",
    "tap", "tar", "tas", "tat", "tau", "tav", "taw", "tax", "tay", "tea", "tec",
    "ted", "tee", "tef", "teg", "tel", "ten", "tes", "tet", "tew", "tex", "the",
    "tho", "thy", "tic", "tid", "tie", "tig", "tik", "til", "tin", "tip", "tis",
    "tit", "tix", "toc", "tod", "toe", "tog", "tom", "ton", "too", "top", "tor",
    "tot", "tow", "toy", "try", "tsk", "tub", "tug", "tui", "tum", "tun", "tup",
    "tut", "tux", "twa", "two", "twp", "tye", "tyg", "udo", "uds", "uey", "ufo",
    "ugh", "ugs", "uke", "ule", "ulu", "umm", "ump", "ums", "umu", "uni", "uns",
    "upo", "ups", "urb", "urd", "ure", "urn", "urp", "use", "uta", "ute", "uts",
    "utu", "uva", "vac", "vae", "vag", "van", "var", "vas", "vat", "vau", "vav",
    "vaw", "vee", "veg", "vet", "vex", "via", "vid", "vie", "vig", "vim", "vin",
    "vis", "vly", "voe", "vol", "vor", "vow", "vox", "vug", "vum", "wab", "wad",
    "wae", "wag", "wai", "wan", "wap", "war", "was", "wat", "waw", "wax", "way",
    "web", "wed", "wee", "wem", "wen", "wet", "wex", "wey", "wha", "who", "why",
    "wig", "win", "wis", "wit", "wiz", "woe", "wof", "wog", "wok", "won", "woo",
    "wop", "wos", "wot", "wow", "wox", "wry", "wud", "wus", "wye", "wyn", "xis",
    "yad", "yae", "yag", "yah", "yak", "yam", "yap", "yar", "yaw", "yay", "yea",
    "yeh", "yen", "yep", "yes", "yet", "yew", "yex", "ygo", "yid", "yin", "yip",
    "yob", "yod", "yok", "yom", "yon", "you", "yow", "yug", "yuk", "yum", "yup",
    "yus", "zag", "zap", "zas", "zax", "zea", "zed", "zee", "zek", "zel", "zep",
    "zex", "zho", "zig", "zin", "zip", "zit", "ziz", "zoa", "zol", "zoo", "zos",
    "zuz", "zzz"}
//odinfmt: enable

@(test)
validate_sizes :: proc(t: ^testing.T) {
	assert(MAX_WORDS == len(words) - 1)
	assert(MAX_WORDS == 1310, "'words' array size has changed and no longer matches expected length.")
	assert(MAX_MARKS == len(marks) - 1)
	assert(MAX_MARKS == 9, "'marks' array size has changed and no longer matches expected length.")
}

@(test)
validate_array_entries :: proc(t: ^testing.T) {
	assert(words[0] == "aah", "First entry in array 'words' no matching - expected 'aah'")
	assert(words[MAX_WORDS] == "zzz", "Last entry in array 'words' no matching - expected 'zzz'")
	assert(marks[0] == '#', "First entry in array 'marks' no matching - expected '#'")
	assert(marks[MAX_MARKS] == '<', "Last entry in array 'marks' no matching - expected '<'")
}
