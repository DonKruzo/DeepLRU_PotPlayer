/*
	real time subtitle translate for PotPlayer using DeepL API
*/

// void OnInitialize()
// void OnFinalize()
// string GetTitle() 														-> get title for UI
// string GetVersion														-> get version for manage
// string GetDesc()															-> get detail information
// string GetLoginTitle()													-> get title for login dialog
// string GetLoginDesc()													-> get desc for login dialog
// string GetUserText()														-> get user text for login dialog
// string GetPasswordText()													-> get password text for login dialog
// string ServerLogin(string User, string Pass)								-> login
// string ServerLogout()													-> logout
//------------------------------------------------------------------------------------------------
// array<string> GetSrcLangs() 												-> get source language
// array<string> GetDstLangs() 												-> get target language
// string Translate(string Text, string &in SrcLang, string &in DstLang) 	-> do translate !!

string JsonParseNew(string &in json)
{
    JsonReader Reader;
    JsonValue Root;
    string ret = "";    
    
    if (Reader.parse(json, Root))
    {
        JsonValue translations = Root["translations"];
        
        if (translations.isArray())
        {
            for (int j = 0, len = translations.size(); j < len; j++)
            {       
                JsonValue child1 = translations[j];
                
                if (child1.isObject())
                {
                    JsonValue translatedText = child1["text"];
            
                    if (!ret.empty()) ret = ret + "\n";
                    if (translatedText.isString()) ret = ret + translatedText.asString();
                }
            }
        }
    } 
    return ret;
}

array<string> LangTable = 
{
        "az",
	"ar",
	"am",
	"af",
	"ba",
	"be",
	"bn",
	"bg",
	"bs",
	"cy",
	"ceb",
	"ca",
	"cs",
	"de",
	"da",
	"en",
	"eu",
	"el",
	"es",
	"et",
	"eo",
	"fa",
	"fi",
	"fr",
	"gl",
	"gu",
	"ga",
	"gd",
	"hy",
	"hu",
	"ht",
	"he",
	"hi",
	"hr",
	"id",
	"it",
	"is",
	"ja",
	"jv",
	"ka",
	"kk",
	"kn",
	"ky",
	"ko",
	"km",
	"lo",
	"la",
	"lv",
	"lt",
	"lb",
	"ml",
	"mt",
	"mk",
	"mi",
	"mr",
	"mn",
	"my",
	"mg",
	"ms",
	"ne",
	"no",
	"nl",
	"pa",
	"pap",	
	"pl",
	"pt",
	"ro",
	"ru",
	"sq",
	"sr",
	"si",
	"sk",
	"sl",
	"sw",
	"su",
	"sv",
	"tg",
	"th",
	"tl",
	"ta",
	"tt",
	"te",
	"tr",
	"uk",
	"ur",
	"udm",	
	"uz",
	"vi",
	"xh",
	"yi",
	"zh"
};

string UserAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36";

string api_key = ""; // API key variable

string GetTitle()
{
    return "{$CP950=DeepL 翻譯$}{$CP0=DeepL translate$}";
}

string GetVersion()
{
    return "1";
}

string GetDesc()
{
    return "https://www.deepl.com/";
}

string GetLoginTitle()
{
    return "Input DeepL API key";
}

string GetLoginDesc()
{
    return "Input your DeepL API key";
}

string GetUserText()
{
    return "API key:";
}

string GetPasswordText()
{
    return "";
}

string ServerLogin(string User, string Pass)
{
    api_key = User;
    if (api_key.empty()) return "Failed to log in. Please provide the API key.";
    return "200 ok";
}

void ServerLogout()
{
    api_key = "";
}

array<string> GetSrcLangs()
{
    array<string> ret = LangTable;

    ret.insertAt(0, ""); // empty is auto
    return ret;
}

array<string> GetDstLangs()
{
    array<string> ret = LangTable;

    return ret;
}

string Translate(string Text, string &in SrcLang, string &in DstLang)
{
    if (api_key.length() > 0)
    {
        // form the API request URL
        string enc = HostUrlEncode(Text);
        string url = "https://api-free.deepl.com/v2/translate?text=" + enc + "&target_lang=" + DstLang;
        url = url + "&auth_key=" + api_key;

        // make the API request and get the JSON response
        string text = HostUrlGetString(url, UserAgent);

        // parse the JSON response and extract translated text
        string ret = JsonParseNew(text);
        
        // check if the translation was successful
        if (ret.length() > 0)
        {
            SrcLang = "UTF8";
            DstLang = "UTF8";
            return ret;
        }
    }
    
    return "Failed to translate. Please make sure you have provided a valid API key.";
}


