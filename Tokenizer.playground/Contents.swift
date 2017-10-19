import Foundation

let input = "1+4*abc+3+B"


let IdentifierDictionary:[String:Int] = ["abc":5, "B":7]

let tokens = Tokenizer<Type>.tokens(from: input)

print("Output Of the Tokenizer:" ,tokens)


protocol TokenType {
    // create a token from a string
    init?(from firstCharacter: UnicodeScalar)
    
    // return valid characters for this token type
    var characters: CharacterSet { get }
    
}

struct Tokenizer<Token: TokenType> {
    
    typealias Match = (type: Token, text: String)
    
    static func tokens(from text: String) -> [String] {
        
        
        var matches: [Match] = []
        
        
        var lowerBound = text.startIndex
        var returnValue : [String] = []
        
        while lowerBound < text.endIndex {
            
            
            guard let firstCharacter = text[lowerBound...lowerBound].unicodeScalars.first,
               let tokenType = Token(from: firstCharacter) else {
                    
                    
                    lowerBound = text.index(after: lowerBound)
                    
                    continue
            }
            
            
            var upperBound = lowerBound
            while upperBound <= text.endIndex {
                
                if upperBound < text.endIndex, let nextCharacter = text[upperBound...upperBound].unicodeScalars.first,
                    tokenType.characters.contains(nextCharacter) {
                    upperBound = text.index(after: upperBound)
                    
                }
                    
                else {
                    matches.append((type: tokenType,
                                    text: text[lowerBound..<upperBound]))
                    
                    returnValue.append(String(describing:tokenType) + " (" + text[lowerBound..<upperBound] + ")")
                    break
                }
            }
            
            lowerBound = upperBound
            
        }
        evaluator()

        return returnValue
    }
}

func ~= (pattern: CharacterSet, value: UnicodeScalar) -> Bool {
    return pattern.contains(value)
}

enum Type: TokenType {
    
    case Number
    case Identifier
    case Operator
    
    
    static let numberCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,"))
    static let wordCharacters = CharacterSet.letters.union(.punctuationCharacters)
    static let operatorPlus = CharacterSet(charactersIn: "+-/*")
    
    var characters: CharacterSet {
        switch self {
        case .Number: return Type.numberCharacters
        case .Identifier: return Type.wordCharacters
        case .Operator: return Type.operatorPlus
        }
    }
    
    // using `~=` for pattern matching of charater set to character
    init?(from firstCharacter: UnicodeScalar) {
        switch firstCharacter {
        case CharacterSet.decimalDigits: self = .Number
        case CharacterSet.letters: self = .Identifier
        case CharacterSet(charactersIn: "+-/*"): self = .Operator
            
        default: return nil
        }
    }
}

// EVALAUTOR FOR THE EXPRESSION

func evaluator (){
    
    //REPLACE THE INPUT TOKEN VALUE WITH DICTIONARY
    
    var string = input
    
    for (key, value) in IdentifierDictionary {
        string = string.replacingOccurrences(of: key, with: String(value))
    }
    
    let expression = NSExpression(format: string)
    
    let result = expression.expressionValue(with:nil, context:nil) as! NSNumber
    print("Output Of the Evaluator:" , result)

}


