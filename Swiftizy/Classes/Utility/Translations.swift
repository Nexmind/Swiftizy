
import Foundation

public class Translations {
    
    struct Static {
        static var instance = Translations()
    }
    var currentLangCode : String
    var defaultLanguage: String
    var currentHm : [String : String]
    
    init(){
        currentLangCode = ""
        defaultLanguage = ""
        currentHm = [String : String]()
    }
    
    public static func translate(forKey: String) -> String {
        return Static.instance.get(clef: forKey)
    }
    /**
     initialize the Translation with the good language.
     - return: nothing
     - parameter defaultLang: the default language which the app is translation (example: "en")
     - parameter: currentLang: specific language you want. If you want the language of the user's device, set it to nil
     */
    public static func initialize(defaultLang: String, currentLang: String?) {
        var current = Locale.preferredLanguages[0]
        if currentLang != nil {
            current = currentLang!
        }
        Static.instance.loadLanguageInHashMap(currentLang: current, defaultLanguage: defaultLang)
    }
    
    /*if(lang == Translations.getInstance().get("language_lbl_fr")){
    Translations.getInstance().currentLangCode = "fr"
    } else if(lang == Translations.getInstance().get("language_lbl_en")){
    Translations.getInstance().currentLangCode = "en"
    } else if(lang == Translations.getInstance().get("language_lbl_de")){
    Translations.getInstance().currentLangCode = "de"
    } else if(lang == Translations.getInstance().get("language_lbl_nl")){
    Translations.getInstance().currentLangCode = "nl"
    }
    NSUserDefaults.standardUserDefaults().setObject([Translations.getInstance().currentLangCode], forKey: "AppleLanguages")
    NSUserDefaults.standardUserDefaults().synchronize()
    Translations.getInstance().loadLanguageInHashMap(NSLocale.preferredLanguages()[0])*/
    
    func loadLanguageInHashMap(currentLang : String, defaultLanguage: String){
        self.defaultLanguage = defaultLanguage
        currentLangCode = currentLang
        let bundle = Bundle.main
        let langPath = bundle.path(forResource: self.currentLangCode, ofType: "txt")
        let defaultPath = bundle.path(forResource: defaultLanguage, ofType: "txt")
        var result : [String : String] = [String : String]()
        if langPath != nil {
            if let aStreamReader = StreamReader(path: langPath!) {
                self.readAndPutFileInHm(aStreamReader: aStreamReader)
            } else {
                if let aStreamReader = StreamReader(path: defaultPath!) {
                    self.readAndPutFileInHm(aStreamReader: aStreamReader)
                }
            }
        } else {
            if defaultPath != nil {
                if let aStreamReader = StreamReader(path: defaultPath!) {
                    self.readAndPutFileInHm(aStreamReader: aStreamReader)
                }
            } else {
                print("-----< Translations >----- Error when searching traductions files '\(currentLang).txt' or '\(defaultLanguage).txt'")
            }
        }
    }
    
    func getCurrentLanguageInTwoLettersFormat() -> String{
        //return Locale.preferredLanguages()[0].subStr(0, length: 2)
        return "";
    }
    
    func readAndPutFileInHm(aStreamReader : StreamReader){
       /* while let line = aStreamReader.nextLine() {
            var index = 0
            if let idx = line.characters.index(of: "=") {
                index = line.startIndex.distance(from: idx, to: idx)
            }

            let clef = line.subStr(0, length: index)
            let valeur = line.subStr(index + 1, length: line.length - (index + 1))
            currentHm.updateValue(valeur, forKey: clef)
        }
        aStreamReader.close()*/
        
    }
    func get(clef : String) -> String{
        if let value = self.currentHm[clef]{
            return value
        } else {
            return clef
        }
    }
    
    func getHm() -> [String : String]{
        return currentHm
    }
    
    func setLangCode(newCode : String){
        self.currentLangCode = newCode
    }
}
